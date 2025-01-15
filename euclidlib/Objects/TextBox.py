from __future__ import annotations
from collections import defaultdict
from typing import Tuple, Mapping
import manimlib as mn
import numpy as np
from .EucidMObject import EMObject
from .EucidGroupMObject import EGroup
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
    ALIGNMENT = defaultdict(
        lambda: (mn.Mobject.get_left, mn.LEFT),
        w=(mn.Mobject.get_right, mn.RIGHT),
        n=None
    )

    if sys.platform == 'darwin': # MAC CHECK
        fonts = defaultdict(
            lambda: (T.EMarkupText, dict(font_size=30)),
            title=(T.EMarkupText, dict(font_size=30, font='Arial Rounded MT Bold')),
            explain=(T.EMarkupText, dict(font_size=18, font='Arial')),
            normal=(T.EText, dict(font_size=16, font='Arial')),
            math=(T.ETex, dict(font_size=20)),
            fancy=(T.EText, dict(font_size=24, font='Apple Chancery')),
            title_screen=(T.EText, dict(font_size=48, font='Chalkduster')),
        )
    elif sys.platform == 'linux':
        fonts = defaultdict(
            lambda: (T.EMarkupText, dict(font_size=30)),
            title=(T.EMarkupText, dict(font_size=30, font='Armino', weight=mn.BOLD)),
            explain=(T.EMarkupText, dict(font_size=18, font='Armino')),
            normal=(T.EText, dict(font_size=16, font='Armino')),
            math=(T.ETex, dict(font_size=20)),
            fancy=(T.EText, dict(font_size=36, font='Z003')),
            title_screen=(T.EText, dict(font_size=128, font='Karumbi'))
        )


    def RemovalOf(self, *args, **kwargs):
        to_remove = [sub for sub in self if isinstance(sub, TextBuffer)]
        self.remove(*to_remove)
        self.scene.remove(*to_remove)
        return [CA.UnWrite(x, *args, **kwargs, stroke_color=mn.RED, stroke_width=1) for x in self]

    def __init__(self,
                 scene: PropScene,
                 *args,
                 absolute_position: Tuple[float, float, float] | None = None,
                 relative_position: Tuple[mn.Mobject, mn.Vect3] | None = None,
                 line_width: float = None,
                 stroke_width=0,
                 alignment=None,
                 buff_size=mn.SMALL_BUFF,
                 **kwargs):
        if not absolute_position and not relative_position:
            raise Exception("Must define starting position")
        self.line_width = line_width
        self._buff_size = buff_size
        self.abs_position = absolute_position
        self.rel_position = relative_position
        self.alignment=self.ALIGNMENT[alignment]
        super().__init__(*args, **kwargs, scene=scene, stroke_width=0)

    def compute_bounding_box(self):
        if self:
            return super().compute_bounding_box()
        if self.abs_position:
            x, y, _ = self.abs_position
            return np.array([[x, y, 0]] * 3)
        if self.rel_position:
            ref, direction = self.rel_position
            low, _, _ = ref.get_bounding_box()
            return np.array([low - (direction * mn.MED_SMALL_BUFF)] * 3)


    @property
    def buff_size(self):
        return self._buff_size if self else 0


    def generate_text(self, text: str, style: str = ''):
        cls, kwargs = self.fonts[style]
        if issubclass(cls, mn.MarkupText) and self.line_width is not None:
            kwargs['line_width'] = self.line_width
        with self.scene.simultaneous():
            newline = cls(text, **kwargs, scene=self.scene)
            newline.next_to(self.get_bottom(), mn.DOWN, buff=self.buff_size)
            if self.alignment:
                (get_side, side) = self.alignment
                newline.align_to(get_side(self), side)
        self.add(newline)
        if self.rel_position:
            self.rel_position[0].refresh_bounding_box()
        return newline

    def e_remove(self):
        super(EGroup, self).e_remove()
        self.clear()

    def title(self, title: str):
        self.generate_text(title, 'title')

    def title_screen(self, title: str):
        self.generate_text(title, 'title_screen')

    def normal(self, title: str):
        self.generate_text(title, 'normal')

    def explain(self, title: str):
        self.generate_text(title, 'explain')

    def fancy(self, title: str):
        self.generate_text(title, 'fancy')

    def math(self, title: str):
        self.generate_text(title, 'math')

    def down(self, buff=mn.SMALL_BUFF):
        sq = TextBuffer(buff, self.scene)
        sq.next_to(self.get_bottom(), mn.DOWN, buff=0)
        self.add(sq)
        if self.rel_position:
            self.rel_position[0].refresh_bounding_box()
        self.scene.add(sq)


