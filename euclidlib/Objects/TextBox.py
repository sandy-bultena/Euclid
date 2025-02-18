from __future__ import annotations
from collections import defaultdict
from typing import Tuple, Mapping, TYPE_CHECKING, Dict
import manimlib as mn
import numpy as np

from .EucidMObject import EMObject
from .EucidGroupMObject import EGroup, PsuedoGroup
from . import Text as T
from . import CustomAnimation as CA
from contextlib import contextmanager
import sys

from euclidlib.Propositions.PropScene import PropScene

INIT_TEXT_RUN_TIME = 0.5
INCREASE_PER_CHARACTER = 0.02
DELAYED_INCREASE = 20


class TextBuffer(EMObject, mn.Square):
    def CreationOf(self, *args, **kwargs):
        return []

    def __init__(self, size, scene, **kwargs):
        super().__init__(size, stroke_opacity=0, **kwargs, scene=scene)


class TextBox(EGroup[T.EStringObj]):
    AUX_CONSTRUCTION_TIME = 0.1
    ALIGNMENT = {
        None: (mn.Mobject.get_left, mn.LEFT),
        'e': (mn.Mobject.get_left, mn.LEFT),
        'w': (mn.Mobject.get_right, mn.RIGHT),
        'n': None,
    }

    def get_group(self):
        return [x for x in self if isinstance(x, T.EStringObj)]

    fonts: Dict[str, Tuple[T.EStringObj, dict]]

    if sys.platform == 'darwin':  # MAC CHECK
        fonts = dict(
            title=(T.EMarkupText, dict(font_size=30, font='Arial Rounded MT Bold')),
            explain=(T.EMarkupText, dict(font_size=18, font='Arial')),
            explainM=(T.ETexText, dict(font_size=18, font='Arial')),
            normal=(T.EText, dict(font_size=16, font='Arial')),
            math=(T.ETex, dict(font_size=20)),
            fancy=(T.EText, dict(font_size=24, font='Apple Chancery')),
            title_screen=(T.EText, dict(font_size=48, font='Chalkduster')),
        )
    elif sys.platform == 'linux':
        fonts = dict(
            title=(T.EMarkupText, dict(font_size=30, font='Arimo', weight=mn.BOLD)),
            explain=(T.EMarkupText, dict(font_size=18, font='Arimo')),
            explainM=(T.ETexText, dict(font_size=18, font='Arimo')),
            normal=(T.EText, dict(font_size=16, font='Arimo')),
            math=(T.ETex, dict(font_size=20)),
            fancy=(T.EText, dict(font_size=36, font='Z003')),
            title_screen=(T.EText, dict(font_size=128, font='Karumbi'))
        )
    else:
        fonts = dict(
            title=(T.EMarkupText, dict(font_size=30, weight=mn.BOLD)),
            explain=(T.EMarkupText, dict(font_size=18)),
            explainM=(T.ETexText, dict(font_size=18)),
            normal=(T.EText, dict(font_size=16)),
            math=(T.ETex, dict(font_size=20)),
            fancy=(T.EText, dict(font_size=36)),
            title_screen=(T.EText, dict(font_size=128))
        )

    def __init__(self,
                 absolute_position: Tuple[float, float, float],
                 scene: PropScene | None = None,
                 *args,
                 line_width: float = None,
                 stroke_width=0,
                 alignment=None,
                 buff_size=mn.SMALL_BUFF,
                 **kwargs):
        self.next_buff = 0
        self.indent_value = 0
        self.line_width = line_width
        self._buff_size = buff_size
        self.abs_position = absolute_position
        self.alignment = self.ALIGNMENT[alignment]
        super().__init__(*args, **kwargs, scene=scene, stroke_width=0)

    def compute_bounding_box(self):
        if self:
            return super().compute_bounding_box()
        x, y, _ = self.abs_position
        return np.array([[x, y, 0]] * 3)

    @property
    def buff_size(self):
        return self._buff_size if self else 0

    def _generate_text_no_anim(self, text: str, style: str = '', delay_anim=True, **other_options):
        cls, kwargs = self.fonts[style]
        kwargs = kwargs | other_options
        kwargs['style'] = style
        if ((cls is T.ETexText or issubclass(cls, (mn.MarkupText, T.ETexText))) and
                self.line_width is not None):
            kwargs['line_width'] = self.line_width
        newline = cls(text, **kwargs, scene=self.scene, delay_anim=delay_anim)
        newline.fix_in_frame()
        return newline

    def generate_text(self,
                      text: str,
                      style: str = '',
                      /,
                      align_index: int | T.EStringObj = -1,
                      align_str: mn.SingleSelector | Tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                      transform_from: T.EStringObj | int = None,
                      transform_args: dict = None,
                      delay_anim=False,
                      break_into_parts: Tuple[str, ...] | None = None,
                      **other_options):
        cls, kwargs = self.fonts[style]
        kwargs = kwargs | other_options
        kwargs['style'] = style
        if ((cls is T.ETexText or issubclass(cls, (mn.MarkupText, T.ETexText))) and
                self.line_width is not None):
            kwargs['line_width'] = self.line_width
        with self.scene.simultaneous():
            newline = cls(text, **kwargs, scene=self.scene, delay_anim=True)
            newline.fix_in_frame()
            if align_str:
                if isinstance(align_str, str):
                    align_str = (align_str, align_str)
                align_obj = align_index if isinstance(align_index, T.EStringObj) else self[align_index]
                newline.next_to(
                    align_obj[align_str[0]].get_bottom(),
                    mn.DOWN,
                    buff=self.buff_size + self.next_buff,
                    index_of_submobject_to_align=align_str[1]
                )
                newline.next_to(align_obj, mn.DOWN, buff=self.buff_size, coor_mask=mn.UP)
            else:
                newline.next_to(self.get_bottom(), mn.DOWN, buff=self.buff_size + self.next_buff)
            self.next_buff = 0
            if self.alignment and not align_str:
                (get_side, side) = self.alignment
                newline.align_to(get_side(self), side)
                newline.shift(mn.RIGHT * self.indent_value)
            if break_into_parts:
                parts = [self.generate_text(part, style, delay_anim=True)
                         for part in break_into_parts]
                for p, t in zip(parts, break_into_parts):
                    p.next_to(newline[t], mn.ORIGIN, buff=0)
                    if not delay_anim:
                        p.e_draw()
                self.add(newline)
                return *parts, newline

            elif transform_from is None and not delay_anim:
                newline.e_draw()
            elif not delay_anim:
                transform_args = transform_args or {}
                if isinstance(transform_from, int):
                    transform_from = self[transform_from]
                self.scene.play(mn.TransformMatchingStrings(
                    transform_from.copy(),
                    newline,
                    **transform_args,
                ))
        self.add(newline)
        return newline

    def e_remove(self):
        super().e_remove()
        self.clear()

    def __delitem__(self, key):
        self[key].e_remove()
        self.remove(self[key])

    def __delslice__(self, i, j):
        for x in self[i:j]:
            x.e_remove()
        self.remove(*self[i:j])

    def delete_last(self):
        del self[-1]

    if TYPE_CHECKING:
        def title(self, text: str,
                  align_index: int | T.EStringObj = -1,
                  align_str: mn.SingleSelector | Tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                  transform_from: T.EStringObj | int = None,
                  transform_args: dict = None,
                  break_into_parts: Tuple[str, ...] | None = None,
                  **kwargs,
                  ) -> T.EStringObj: ...

        def explain(self, text: str,
                    align_index: int | T.EStringObj = -1,
                    align_str: mn.SingleSelector | Tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                    transform_from: T.EStringObj | int = None,
                    transform_args: dict = None,
                    break_into_parts: Tuple[str, ...] | None = None,
                    **kwargs,
                    ) -> T.EStringObj: ...

        def explainM(self, text: str,
                     align_index: int | T.EStringObj = -1,
                     align_str: mn.SingleSelector | Tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                     transform_from: T.EStringObj | int = None,
                     transform_args: dict = None,
                     break_into_parts: Tuple[str, ...] | None = None,
                     **kwargs,
                     ) -> T.EStringObj: ...

        def normal(self, text: str,
                   align_index: int | T.EStringObj = -1,
                   align_str: mn.SingleSelector | Tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                   transform_from: T.EStringObj | int = None,
                   transform_args: dict = None,
                   break_into_parts: Tuple[str, ...] | None = None,
                   **kwargs,
                   ) -> T.EStringObj: ...

        def math(self, text: str,
                 align_index: int | T.EStringObj = -1,
                 align_str: mn.SingleSelector | Tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                 transform_from: T.EStringObj | int = None,
                 transform_args: dict = None,
                 break_into_parts: Tuple[str, ...] | None = None,
                 **kwargs,
                 ) -> T.EStringObj: ...

        def fancy(self, text: str,
                  align_index: int | T.EStringObj = -1,
                  align_str: mn.SingleSelector | Tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                  transform_from: T.EStringObj | int = None,
                  transform_args: dict = None,
                  break_into_parts: Tuple[str, ...] | None = None,
                  **kwargs,
                  ) -> T.EStringObj: ...

        def title_screen(self, text: str,
                         align_index: int | T.EStringObj = -1,
                         align_str: mn.SingleSelector | Tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                         transform_from: T.EStringObj | int = None,
                         transform_args: dict = None,
                         break_into_parts: Tuple[str, ...] | None = None,
                         **kwargs,
                         ) -> T.EStringObj: ...

    for style in fonts:
        exec(f"""
def {style}(self, text: str, **kwargs):
    return self.generate_text(text, '{style}', **kwargs)
""")

    # @contextmanager
    # def join_parts(self,
    #                delay_anim=False,
    #                realign_result=False,
    #                transform_from: T.EStringObj | int = None,
    #                transform_args: dict = None):
    #     proxy = TempTextBoxProxy(self)
    #     yield proxy
    #     head: mn.StringMobject
    #     head, *rest = proxy
    #     head.string = head.string + ' '.join(x.string for x in rest)
    #     for r in rest:
    #         head.add(*r)
    #     self.add(head)
    #     if realign_result and self.alignment:
    #         (get_side, side) = self.alignment
    #         head.align_to(get_side(self), side)
    #     if not delay_anim:
    #         if transform_from is not None:
    #             if isinstance(transform_from, int):
    #                 transform_from = self[transform_from]
    #             self.scene.play(mn.TransformMatchingStrings(
    #                 transform_from.copy(),
    #                 head,
    #                 **transform_args,
    #             ))
    #         else:
    #             head.e_draw()
    #     proxy.clear()
    #     self.scene.remove(proxy)

    def e_update(self, index, text: str, transform_args=None, **kwargs):
        old = self[index]
        transform_args = transform_args or {}
        assert isinstance(old, T.EStringObj)
        new = self._generate_text_no_anim(text, old.style, **kwargs)
        new.next_to(old.get_corner(mn.UL), mn.DR, buff=0)
        self.scene.play(CA.AppendString(old, new, **transform_args))
        self.replace_submobject(index, new)

    def e_append(self, index, text: str, **kwargs):
        old = self[index]
        assert isinstance(old, T.EStringObj)
        new = self._generate_text_no_anim(text, old.style, **kwargs)
        new.next_to(old.get_right(), mn.RIGHT, buff=mn.SMALL_BUFF)
        new.e_draw()
        old.add(*new.submobjects)

    def e_append_morph(self, index, text: str, color: None = None, transform_args=None, **kwargs):
        if color:
            kwargs['t2c'] = {text: color}
        transform_args = transform_args or {}
        if 'run_time' not in transform_args:
            transform_args['run_time'] = 0.5
        old = self[index]
        new = self._generate_text_no_anim(f"{old.string} {text}", old.style, **kwargs)
        new.next_to(old.get_corner(mn.UL), mn.DR, buff=0)
        self.scene.play(CA.AppendString(old, new, **transform_args))
        self.replace_submobject(index, new)

    def down(self, buff=mn.MED_SMALL_BUFF):
        self.next_buff = buff

    def indent(self, buff=mn.MED_SMALL_BUFF):
        self.indent_value += buff

    def unindent(self, buff=mn.MED_SMALL_BUFF):
        self.indent_value -= buff


# class TempTextBoxProxy(TextBox):
#     def __init__(self, parent: TextBox):
#         self.next_buff = 0
#         self.parent = parent
#         self.line_width = parent.line_width
#         self._buff_size = parent._buff_size
#         self.abs_position = parent.abs_position
#         self.alignment = parent.alignment
#         super(TextBox, self).__init__()
#
#     @property
#     def buff_size(self):
#         return self._buff_size
#
#     def __getitem__(self, item):
#         return self.parent[item]
#
#     def get_bottom(self):
#         if not self:
#             return self.parent.get_bottom()
#         return super().get_bottom()
#
#     for style in TextBox.fonts:
#         exec(f"""
# def {style}(self, text: str, **kwargs):
#     return self.generate_text(text, '{style}', delay_anim=True, **kwargs)
#     """)
#
#     def __getattr__(self, item):
#         return getattr(self.parent, item)
#
#     def __iter__(self):
#         return iter(self.submobjects)
