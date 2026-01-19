from __future__ import annotations
from collections import defaultdict
from typing import Mapping, TYPE_CHECKING, Optional, Literal
import manimlib as mn
import numpy as np
from euclidlib.debugging import print_debug

from .EuclidMObject import EMObject
from .EuclidGroupMObject import EGroup, PsuedoGroup
from . import Text as T
from . import CustomAnimation as CA
from contextlib import contextmanager
import sys

from euclidlib.Propositions import PropScene as ps
if TYPE_CHECKING:
    from . import EStringObj

INIT_TEXT_RUN_TIME = 0.5
INCREASE_PER_CHARACTER = 0.02
DELAYED_INCREASE = 20
DEFAULT_TEXT_FADE_OPACITY = 0.3



# class TextBuffer(EMObject, mn.Square):
#     def CreationOf(self, *args, **kwargs):
#         return []
#
#     def __init__(self, size, scene, **kwargs):
#         super().__init__(size, stroke_opacity=0, **kwargs, scene=scene)

# Font Contenders:
# Consolas, Arial, Gotu, Menlo, Lucida Grande, Monaco, Optima, Verdana
class Fonts:
    fonts: dict[str, tuple[type[T.EStringObj], dict]]

    if sys.platform == 'darwin':  # MAC CHECK
        fonts = dict(
            title=(T.EMarkupText, dict(font_size=30, font='Gotu')),
            explain=(T.EMarkupText, dict(font_size=16, font='Lucida Grande')),
            sidenote=(T.EMarkupText, dict(font_size=16, font='Lucida Grande', slant='ITALIC')),
            explainM=(T.ETexText, dict(font_size=16, font='Lucida Grande')),
            normal=(T.EText, dict(font_size=14, font='Lucida Grande')),
            math=(T.ETex, dict(font_size=20)),
            fancy=(T.EText, dict(font_size=24, font='Charm')),
            title_screen=(T.EText, dict(font_size=48, font='Bradley Hand')),
        )

    elif sys.platform == 'linux':
        fonts = dict(
            title=(T.EMarkupText, dict(font_size=30, font='Arimo', weight=mn.BOLD)),
            explain=(T.EMarkupText, dict(font_size=18, font='Arimo')),
            sidenote=(T.EMarkupText, dict(font_size=18, font='Arimo', slant='ITALIC')),
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
            sidenote=(T.EMarkupText, dict(font_size=18, slant='ITALIC')),
            explainM=(T.ETexText, dict(font_size=18)),
            normal=(T.EText, dict(font_size=16)),
            math=(T.ETex, dict(font_size=20)),
            fancy=(T.EText, dict(font_size=36)),
            title_screen=(T.EText, dict(font_size=128))
        )

# =====================================================================================================================
# Text Box - inherits from EGroup with StringObj
# =====================================================================================================================
class TextBox(EGroup[T.EStringObj]):

    # -----------------------------------------------------------------------------------------------------------------
    # Class properties
    # -----------------------------------------------------------------------------------------------------------------
    AUX_CONSTRUCTION_TIME = 0.1
    ALIGNMENT = {
        None: (mn.Mobject.get_left, mn.LEFT),
        'e': (mn.Mobject.get_left, mn.LEFT),
        'w': (mn.Mobject.get_right, mn.RIGHT),
        'n': None,
    }

    # -----------------------------------------------------------------------------------------------------------------
    # define buffer size
    # -----------------------------------------------------------------------------------------------------------------
    @property
    def buff_size(self):
        return self._buff_size if self else 0


    # -----------------------------------------------------------------------------------------------------------------
    # initialization
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self,
                 absolute_position: tuple[float, float, float],
                 scene: ps.PropScene | None = None,
                 *args,
                 line_width: float = None,
                 alignment: Optional[Literal['n','e','w']]=None,
                 buff_size=mn.SMALL_BUFF,
                 **kwargs):

        self.next_buff = 0
        self.indent_value = 0
        self.line_width = line_width
        self._buff_size = buff_size
        self.abs_position = absolute_position
        self.alignment = self.ALIGNMENT[alignment]
        self.bullet_symbol = None
        self.text_to_index = {}
        super().__init__(*args, **kwargs, scene=scene, stroke_width=0)

    def __str__(self):
        return f"{type(self).__name__}: {self.abs_position} {self.line_width=}"

    # -----------------------------------------------------------------------------------------------------------------
    # return all string objects
    # -----------------------------------------------------------------------------------------------------------------
    def get_group(self):
        return [x for x in self if isinstance(x, T.EStringObj)]

    # -----------------------------------------------------------------------------------------------------------------
    # calculate the bounding box
    # -----------------------------------------------------------------------------------------------------------------
    def compute_bounding_box(self):
        if self:
            return super().compute_bounding_box()
        x, y, _ = self.abs_position
        return np.array([[x, y, 0]] * 3)

    # -----------------------------------------------------------------------------------------------------------------
    # generate the text_str preamble
    # -----------------------------------------------------------------------------------------------------------------
    def _setup_kwargs(self, style, other_options)->tuple[type[T.EStringObj], dict]:
        cls, kwargs = Fonts.fonts[style]
        kwargs = kwargs | other_options
        kwargs['style'] = style
        if ((cls is T.ETexText or issubclass(cls, (mn.MarkupText, T.ETexText))) and
                self.line_width is not None):
            kwargs['line_width'] = self.line_width
        return cls, kwargs

    def _generate_text_no_anim(self, text: str, style: str = '', delay_anim=True, **other_options):
        cls, kwargs = self._setup_kwargs(style, other_options)
        newline = cls(text, **kwargs, scene=self.scene, delay_anim=delay_anim)
        newline.fix_in_frame()
        return newline

    # -----------------------------------------------------------------------------------------------------------------
    # where to put the text_str with respect to another string
    # -----------------------------------------------------------------------------------------------------------------
    def align_string_with_other_string(self, original_str: EStringObj,
                                       align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None,
                                       align_index: int | T.EStringObj):

        # get the object we need to align to
        if isinstance(align_str, str):
            align_str = (align_str, align_str)
        align_obj = align_index if isinstance(align_index, T.EStringObj) else self[align_index]

        # align string "align_str[0]" to "align_str[1]" (below)
        original_str.next_to(
            align_obj[align_str[0]].get_bottom(),
            mn.DOWN,
            buff=self.buff_size + self.next_buff,
            index_of_submobject_to_align=align_str[1],
        )
        original_str.next_to(align_obj, mn.DOWN, buff=self.buff_size, coor_mask=mn.UP)


    # -----------------------------------------------------------------------------------------------------------------
    # align text_str (north, south, east, west)
    # -----------------------------------------------------------------------------------------------------------------
    def justify_text(self, newline):
        if self.alignment:
            (get_side, side) = self.alignment
            newline.align_to(get_side(self), side)
            newline.shift(mn.RIGHT * self.indent_value)

    # -----------------------------------------------------------------------------------------------------------------
    # break the text_str into parts (purpose: so that you can use the different parts for transform_from later on
    # -----------------------------------------------------------------------------------------------------------------
    def break_into_parts(self,
                         text_obj:EStringObj,
                         break_into_parts: Optional[tuple[str, ...] | str],
                         bullet: EStringObj,
                         delay_anim,
                         skip_anim,
                         ):
        text_str: str = text_obj.text

        # if the break_into_parts is a string instead of an array, use that to break text into its parts
        if isinstance(break_into_parts, str):
            break_into_parts = text_str.split(break_into_parts)

        # create the text objects for each part
        parts = [self.generate_text(part, text_obj.style, delay_anim=True)
                 for part in break_into_parts]

        # align the parts next to each other
        for p, t in zip(parts, break_into_parts):
            p.next_to(text_obj[t], mn.ORIGIN, buff=0)
            if not delay_anim:
                p.e_draw(skip_anim)

        return *parts,

    # -----------------------------------------------------------------------------------------------------------------
    # transform text from one object to another
    # -----------------------------------------------------------------------------------------------------------------
    def e_transform_to(self, text_obj, transform_args, transform_from):
        transform_args = transform_args or {}

        if isinstance(transform_from, int):
            transform_from = self[transform_from]

        self.scene.play(mn.TransformMatchingStrings(
            transform_from.copy(),
            text_obj,
            **transform_args,
        ))

    # -----------------------------------------------------------------------------------------------------------------
    # generate the text_str
    # -----------------------------------------------------------------------------------------------------------------
    def generate_text(self,
                      text_str: str,
                      style: str = '',
                      /,
                      align_index: int | T.EStringObj = -1,
                      align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                      transform_from: T.EStringObj | int = None,
                      transform_args: dict = None,
                      delay_anim=False,
                      skip_anim=False,
                      break_into_parts: tuple[str, ...] | str | None = None,
                      **other_options):
        cls, kwargs = self._setup_kwargs(style, other_options)
        bullet = None
        parts = None

        with self.scene.simultaneous():
            # create the text_str and fix the text_str in frame (is always displayed at a fixed position on the screen)
            newline = cls(text_str, **kwargs, scene=self.scene, delay_anim=True)
            newline.fix_in_frame()

            # place the text_str
            if align_str:
                self.align_string_with_other_string(newline, align_str, align_index)
                self.next_buff = 0
            else:
                newline.next_to(self.get_bottom(), mn.DOWN, buff=self.buff_size + self.next_buff)
                self.next_buff = 0
                self.justify_text(newline)

            # add bullet_symbol (i.e. bullet marker)
            if self.bullet_symbol:
                bullet = cls(self.bullet_symbol, **kwargs, scene=self.scene, delay_anim=True)
                bullet.next_to(newline[0], mn.LEFT, buff=mn.SMALL_BUFF)
                bullet.e_draw(skip_anim)

            # break the text into parts (so that later we can use individual parts for animation)
            # and do no further processing
            if break_into_parts:
                parts = self.break_into_parts(newline,break_into_parts,bullet, delay_anim, skip_anim)

            # not delaying the animation...
            elif not delay_anim:

                if transform_from is not None:
                    self.e_transform_to(newline, transform_args, transform_from)
                else:
                    newline.e_draw(skip_anim)

        # save the text object in the VGroup
        self.add(newline)

        if parts is not None:
            return *parts, newline
        return newline

    # -----------------------------------------------------------------------------------------------------------------
    # managing items
    # -----------------------------------------------------------------------------------------------------------------
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

    # -----------------------------------------------------------------------------------------------------------------
    # managing items
    # -----------------------------------------------------------------------------------------------------------------
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

    # -----------------------------------------------------------------------------------------------------------------
    # managing location of new text strings
    # -----------------------------------------------------------------------------------------------------------------
    def down(self, buff=mn.MED_SMALL_BUFF):
        self.next_buff = buff

    def indent(self, buff=mn.MED_SMALL_BUFF):
        self.indent_value += buff

    def unindent(self, buff=mn.MED_SMALL_BUFF):
        self.indent_value -= buff

    # -----------------------------------------------------------------------------------------------------------------
    # managing bullets
    # -----------------------------------------------------------------------------------------------------------------
    def set_bullet_symbol(self, text='–'):
        self.bullet_symbol = text

    def reset_bullet_symbol(self):
        self.bullet_symbol = None

    # ----------------------------------------------------------------------------------------------------------------
    # create functions for all of the text_str styles
    # ----------------------------------------------------------------------------------------------------------------
    if TYPE_CHECKING:
        def title(self, text: str,
                  align_index: int | T.EStringObj = -1,
                  align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                  transform_from: T.EStringObj | int = None,
                  transform_args: dict = None,
                  break_into_parts: tuple[str, ...] | str | None = None,
                  **kwargs,
                  ) -> T.EStringObj: ...

        def explain(self, text: str,
                    align_index: int | T.EStringObj = -1,
                    align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                    transform_from: T.EStringObj | int = None,
                    transform_args: dict = None,
                    break_into_parts: tuple[str, ...] | str | None = None,
                    **kwargs,
                    ) -> T.EStringObj: ...

        def explainM(self, text: str,
                     align_index: int | T.EStringObj = -1,
                     align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                     transform_from: T.EStringObj | int = None,
                     transform_args: dict = None,
                     break_into_parts: tuple[str, ...] | str | None = None,
                     **kwargs,
                     ) -> T.EStringObj: ...

        def normal(self, text: str,
                   align_index: int | T.EStringObj = -1,
                   align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                   transform_from: T.EStringObj | int = None,
                   transform_args: dict = None,
                   break_into_parts: tuple[str, ...] | str | None = None,
                   **kwargs,
                   ) -> T.EStringObj: ...

        def math(self, text: str,
                 align_index: int | T.EStringObj = -1,
                 align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                 transform_from: T.EStringObj | int = None,
                 transform_args: dict = None,
                 break_into_parts: tuple[str, ...] | str | None = None,
                 **kwargs,
                 ) -> T.EStringObj: ...

        def fancy(self, text: str,
                  align_index: int | T.EStringObj = -1,
                  align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                  transform_from: T.EStringObj | int = None,
                  transform_args: dict = None,
                  break_into_parts: tuple[str, ...] | str | None = None,
                  **kwargs,
                  ) -> T.EStringObj: ...

        def title_screen(self, text: str,
                         align_index: int | T.EStringObj = -1,
                         align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                         transform_from: T.EStringObj | int = None,
                         transform_args: dict = None,
                         break_into_parts: tuple[str, ...] | str | None = None,
                         **kwargs,
                         ) -> T.EStringObj: ...

        def sidenote(self, text: str,
                         align_index: int | T.EStringObj = -1,
                         align_str: mn.SingleSelector | tuple[mn.SingleSelector, mn.SingleSelector] | None = None,
                         transform_from: T.EStringObj | int = None,
                         transform_args: dict = None,
                         break_into_parts: tuple[str, ...] | str | None = None,
                         **kwargs,
                         ) -> T.EStringObj: ...

    for style in Fonts.fonts:
        exec(f"""
def {style}(self, text: str, **kwargs):
    self.text_to_index[text] = len(self)
    return self.generate_text(text, '{style}', **kwargs)
""")


