from __future__ import annotations
from collections import defaultdict
from typing import Tuple, Mapping, TYPE_CHECKING, Dict
import manimlib as mn
import numpy as np
from .EucidMObject import EMObject
from .EucidGroupMObject import EGroup, PsuedoGroup
from . import Text as T
from . import CustomAnimation as CA
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

    if sys.platform == 'darwin': # MAC CHECK
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
        self.line_width = line_width
        self._buff_size = buff_size
        self.abs_position = absolute_position
        self.alignment=self.ALIGNMENT[alignment]
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
                      align_str: mn.SingleSelector|None=None,
                      transform_from: T.EStringObj | int = None,
                      transform_args: dict = None,
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
                newline.next_to(
                    self[-1][align_str].get_bottom(),
                    mn.DOWN,
                    buff=self.buff_size + self.next_buff,
                    index_of_submobject_to_align=align_str
                )
            else:
                newline.next_to(self.get_bottom(), mn.DOWN, buff=self.buff_size + self.next_buff)
            self.next_buff = 0
            if self.alignment and not align_str:
                (get_side, side) = self.alignment
                newline.align_to(get_side(self), side)
            if transform_from is None:
                newline.e_draw()
            else:
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

    if TYPE_CHECKING:
        def title(self, text: str, **kwargs) -> T.EStringObj: ...
        def explain(self, text: str, **kwargs) -> T.EStringObj: ...
        def explainM(self, text: str, **kwargs) -> T.EStringObj: ...
        def normal(self, text: str, **kwargs) -> T.EStringObj: ...
        def math(self, text: str, **kwargs) -> T.EStringObj: ...
        def fancy(self, text: str, **kwargs) -> T.EStringObj: ...
        def title_screen(self, text: str, **kwargs) -> T.EStringObj: ...

    for style in fonts:
        exec(f"""
def {style}(self, text: str, **kwargs):
    return self.generate_text(text, '{style}', **kwargs)
""")

    def e_update(self, index, text: str, transformArgs=None, **kwargs):
        old = self[index]
        transformArgs = transformArgs or {}
        assert isinstance(old, T.EStringObj)
        new = self._generate_text_no_anim(text, old.style, **kwargs)
        new.next_to(old.get_corner(mn.UL), mn.DR, buff=0)
        self.scene.play(mn.TransformMatchingTex(old, new, **transformArgs))
        self.replace_submobject(index, new)

    def e_append(self, index, text: str, **kwargs):
        old = self[index]
        assert isinstance(old, T.EStringObj)
        new = self._generate_text_no_anim(text, old.style, **kwargs)
        new.next_to(old.get_right(), mn.RIGHT, buff=mn.SMALL_BUFF)
        new.e_draw()
        old.add(*new.submobjects)


    def down(self, buff=mn.MED_SMALL_BUFF):
        self.next_buff = buff


