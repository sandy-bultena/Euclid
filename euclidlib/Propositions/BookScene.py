from __future__ import annotations

import re
from enum import Enum

from manimlib import *
from typing import Callable
from euclidlib.Objects import *
from functools import cache
from euclidlib.Propositions.PropScene import PropScene
import roman


class AnimState(Enum):
    NORMAL = 0
    STORING = 1
    PAUSED = 2


class BookScene(PropScene):
    book: int
    prop: int

    def title_page(self):
        t = TextBox(self,
                    absolute_position=(0, to_manim_v_scale(350), 0),
                    buff_size=MED_LARGE_BUFF,
                    alignment='n'
                    )

        t.title_screen("Euclid's Elements")
        t.title_screen(f"Book {roman.toRoman(self.book)}")

    def reset(self):
        with self.simultaneous(run_time=1):
            gg = EGroup((sub for sub in self.mobjects if isinstance(sub, VMobject)), scene=self)
            gg.e_remove()

        line_options = dict(
            stroke_color=WHITE,
            stroke_width=0.5,
            stroke_opacity=0.2,
        )

        grid = mn.NumberPlane(
            background_line_style=line_options,
            axis_config=line_options,
            faded_line_style=line_options,
        )
        self.play(FadeIn(grid))

        if self.title and self.prop:
            t = TextBox(self,
                        absolute_position=to_manim_coord(700, 50),
                        line_width=to_manim_h_scale(1000),
                        alignment='n'
                        )
            t.title(f"Proposition {self.prop} of Book {self.book}")
            t.normal(self.title)

    @classmethod
    def get_prop_number(cls):
        match = re.search(r"Book(\d+).Prop(\d+)", cls.__module__)
        return int(match.group(1)), int(match.group(2))

    def __init__(self, *args, **kwargs):
        cls = type(self)
        cls.book, cls.prop = cls.get_prop_number()
        super().__init__(*args, **kwargs)


class Book1Scene(BookScene):
    def title_page(self):
        super().title_page()

        title_box = TextBox(self,
                            absolute_position=to_manim_scale(0, 100),
                            line_width=to_manim_h_scale(550),
                            alignment='w'
                            )
        title_box.fancy("If Euclid did not kindle your youthful enthusiasm, "
                        "you were not born to be a scientific thinker.")
        title_box.explain("-Albert Einstein")

