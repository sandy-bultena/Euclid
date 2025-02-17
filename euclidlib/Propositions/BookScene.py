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

    @staticmethod
    def extract_lines(lines: Dict[str, EuclidLine], triangles: Dict[str, EuclidPolygon], label: str):
        label2 = label + label[0]
        for l_label, line in zip(pairwise(label2), triangles[label].l):
            lines[op.add(*l_label)] = line

    @staticmethod
    def extract_points(points: Dict[str, EuclidPoint], triangles: Dict[str, EuclidPolygon], label: str):
        for p_label, point in zip(label, triangles[label].p):
            points[p_label] = point

    @staticmethod
    def extract_angles(angles: Dict[str, EuclidAngleBase], triangles: Dict[str, EuclidPolygon], label: str):
        label2 = label[-1] + label + label[0]
        for i, angle in enumerate(triangles[label].a):
            if angle is not None:
                angles[label2[i:i+3]] = angle


    @staticmethod
    def extract_all(lines, points, angles, triangles, label):
        BookScene.extract_lines(lines, triangles, label)
        BookScene.extract_points(points, triangles, label)
        BookScene.extract_angles(angles, triangles, label)


    def title_page(self):
        t = TextBox((0, mn_scale(350), 0),
                    buff_size=MED_LARGE_BUFF,
                    alignment='n'
                    )

        t.title_screen("Euclid's Elements", write_simultaneous=True)
        t.title_screen(f"Book {roman.toRoman(self.book)}", write_simultaneous=True)

    def reset(self):
        with self.simultaneous(run_time=1):
            gg = EGroup((sub for sub in self.mobjects if isinstance(sub, EMObject)), scene=self)
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
        grid.fix_in_frame()
        self.play(FadeIn(grid))

        if self.title and self.prop:
            t = TextBox(mn_coord(700, 50),
                        line_width=mn_h_scale(1000),
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

        title_box = TextBox(mn_scale(0, 100, 0),
                            line_width=mn_h_scale(550),
                            alignment='w'
                            )
        title_box.fancy("If Euclid did not kindle your youthful enthusiasm, "
                        "you were not born to be a scientific thinker.", write_simultaneous=True)
        title_box.explain("-Albert Einstein")
