from __future__ import annotations
from collections import defaultdict
from typing import Tuple, Mapping
import manimlib as mn
import numpy as np
from euclidlib.Propositions.PropScene import PropScene

TEXT_RUN_TIME = 0.5

class TextBox(mn.VGroup[mn.Text]):
    fonts = defaultdict(
        lambda: (mn.MarkupText, dict(font_size=30)),
        title=(mn.MarkupText, dict(font_size=30)),
        explain=(mn.MarkupText, dict(font_size=18)),
        math=(mn.Tex, dict(font_size=20)),
    )

    def __init__(self,
                 scene: PropScene,
                 *args,
                 absolute_position: Tuple[float, float, float] | None = None,
                 relative_position: Tuple[mn.Mobject, mn.Vect3] | None = None,
                 line_width: float = None,
                 **kwargs):
        if not absolute_position and not relative_position:
            raise Exception("Must define starting position")
        self.line_width = line_width
        self.scene = scene
        self.abs_position = absolute_position
        self.rel_position = relative_position
        super().__init__(*args, **kwargs)

    def delete(self):
        self.scene.play(mn.FadeOut(self))

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
        return mn.SMALL_BUFF if self else 0


    def generate_text(self, text: str, style: str = ''):
        cls, kwargs = self.fonts[style]
        if issubclass(cls, mn.MarkupText) and self.line_width is not None:
            kwargs['line_width'] = self.line_width
        newline = cls(text, **kwargs)
        newline.next_to(self.get_bottom(), mn.DOWN, buff=self.buff_size)
        newline.align_to(self.get_left(), mn.LEFT)
        self.add(newline)
        if self.rel_position:
            self.rel_position[0].refresh_bounding_box()
        self.scene.play(mn.Write(newline, run_time=TEXT_RUN_TIME))
        return newline


    def title(self, title: str):
        self.generate_text(title, 'title')

    def explain(self, title: str):
        self.generate_text(title, 'explain')

    def math(self, title: str):
        self.generate_text(title, 'math')

    def down(self, buff=mn.SMALL_BUFF):
        sq = mn.Square(buff, stroke_opacity=0)
        sq.next_to(self.get_bottom(), mn.DOWN, buff=0)
        sq.align_to(self.get_left(), mn.LEFT)
        self.add(sq)
        if self.rel_position:
            self.rel_position[0].refresh_bounding_box()
        self.scene.add(sq)


