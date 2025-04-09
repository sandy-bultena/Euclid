from __future__ import annotations

import re
from enum import Enum
from itertools import pairwise

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


@cache_on_disk
def get_TOC(toc):
    entries = TextBox(ORIGIN)
    for i, title in enumerate(toc, start=1):
        entries.explain(f"Proposition {i}: {title}", skip_anim=True)
    return VGroup(*entries.submobjects)


class BookScene(PropScene):
    book: int
    prop: int
    TOC: List[str]

    @staticmethod
    def extract_lines(lines: Dict[str, ELine], triangles: Dict[str, EPolygon], label: str, tri_name=None):
        tri_name = tri_name or label
        label2 = label + label[0]
        for l_label, line in zip(pairwise(label2), triangles[tri_name].l):
            lines[op.add(*l_label)] = line

    @staticmethod
    def extract_points(points: Dict[str, EPoint], triangles: Dict[str, EPolygon], label: str, tri_name=None):
        tri_name = tri_name or label
        for p_label, point in zip(label, triangles[tri_name].p):
            points[p_label] = point

    @staticmethod
    def extract_angles(angles: Dict[str, EAngleBase], triangles: Dict[str, EPolygon], label: str, tri_name=None):
        tri_name = tri_name or label
        label2 = label[-1] + label + label[0]
        for i, angle in enumerate(triangles[tri_name].a):
            if angle is not None:
                angles[label2[i:i+3]] = angle


    @staticmethod
    def extract_all(lines, points, angles, triangles, label, tri_name=None):
        tri_name = tri_name or label
        BookScene.extract_lines(lines, triangles, label, tri_name)
        BookScene.extract_points(points, triangles, label, tri_name)
        BookScene.extract_angles(angles, triangles, label, tri_name)


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

        if self.title and self.prop:
            t = TextBox(mn_coord(700, 50),
                        line_width=mn_h_scale(1000),
                        alignment='n'
                        )
            if False and not self.debug:
                entries = get_TOC(self.TOC)
                self.add(entries)
                entries.next_to(self.frame.get_corner(DL), DR)

                distance_diff = entries.get_center() - entries[self.prop-1].get_center()
                self.play(entries.animate(run_time=1, rate_func=rush_from).move_to(distance_diff, coor_mask=UP))

                line = entries[self.prop-1]
                entries.remove(line)
                self.play(line.animate.set_fill(BLUE))

                title = t.title(f"Proposition {self.prop} of Book {self.book}", delay_anim=True)
                self.play(
                    TransformMatchingStrings(line, title),
                    entries.animate(run_time=1, rate_func=rush_into).next_to(self.frame.get_corner(UL), UR)
                )
            else:
                t.title(f"Proposition {self.prop} of Book {self.book}")
            t.normal(self.title)

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

    @classmethod
    def get_prop_number(cls):
        match = re.search(r"Book(\d+).Prop(\d+)", cls.__module__)
        return int(match.group(1)), int(match.group(2))

    def __init__(self, *args, **kwargs):
        cls = type(self)
        cls.book, cls.prop = cls.get_prop_number()
        super().__init__(*args, **kwargs)


class Book1Scene(BookScene):
    TOC = [
        "Construct an equilateral triangle",
        "Copy a line",
        "Subtract one line from another",
        "Equal triangles if equal side-angle-side",
        "Isosceles triangle gives equal base angles",
        "Equal base angles gives isosceles triangle",
        "Two sides of triangle meet at unique point",
        "Equal triangles if equal side-side-side",
        "How to bisect an angle",
        "Bisect a line",
        "Construct right angle, point on line",
        "Construct perpendicular, point to line",
        "Sum of angles on straight line = 180",
        "Two lines form a single line if angle = 180",
        "Vertical angles equal one another",
        "Exterior angle larger than interior angle",
        "Sum of two interior angles less than 180",
        "Greater side opposite of greater angle",
        "Greater angle opposite of greater side",
        "Sum of two angles greater than third",
        "Triangle within triangle has smaller sides",
        "Construct triangle from given lines",
        "Copy an angle",
        "Larger angle gives larger base",
        "Larger base gives larger angle",
        "Equal triangles if equal angle-side-angle",
        "Alternate angles equal then lines parallel",
        "Sum of interior angles = 180 , lines parallel",
        "Lines parallel, alternate angles are equal",
        "Lines parallel to same line are parallel to themselves",
        "Construct one line parallel to another",
        "Sum of interior angles of a triangle = 180",
        "Lines joining ends of equal parallels are parallel",
        "Opposite sides-angles equal in parallelogram",
        "Parallelograms, same base-height have equal area",
        "Parallelograms, equal base-height have equal area",
        "Triangles, same base-height have equal area",
        "Triangles, equal base-height have equal area",
        "Equal triangles on same base, have equal height",
        "Equal triangles on equal base, have equal height",
        "Triangle is half parallelogram with same base and height",
        "Construct parallelogram with equal area as triangle",
        "Parallelogram complements are equal",
        "Construct parallelogram on line, equal to triangle",
        "Construct parallelogram equal to polygon",
        "Construct a square",
        "Pythagoras' theorem",
        "Inverse Pythagoras' theorem",
    ]

    def title_page(self):
        title_box = TextBox(mn_scale(0, 100, 0),
                            line_width=mn_h_scale(550),
                            alignment='w'
                            )
        with self.simultaneous():
            super().title_page()
            title_box.fancy("If Euclid did not kindle your youthful enthusiasm, "
                            "you were not born to be a scientific thinker.", font_size=64, write_simultaneous=True)
            title_box.explain("-Albert Einstein", font_size=32)

            top = 400
            bot = top + 100
            left = 945
            right = 75 + left
            A_base = np.array([right, top, 0])
            B_base = np.array([left, bot, 0])

            side = -1 * (B_base[0] - A_base[0]) / (bot - top)
            b = A_base[1] - side * A_base[0]
            C_base = np.array([(1 / side) * (bot - b), bot, 0])

            A = mn_coord(*A_base)
            B = mn_coord(*B_base)
            C = mn_coord(*C_base)

            tABC = ETriangle('ABC', point_labels='ABC', angles=' ')
            sB = ESquare(B, A, point_labels=['F', None, None, 'G'])
            sA = ESquare(A, C, point_labels=['H', None, None, 'K'])
            sC = ESquare(C, B, point_labels=['E', None, None, 'D'])

            sABD = ETriangle.assemble(lines=[tABC.l0, sC.l2, EDashedLine(A, sC.p3)])
            sFBC = ETriangle.assemble(lines=[sB.l0, tABC.l1, EDashedLine(sB.p0, C)])
            sBCK = ETriangle.assemble(lines=[tABC.l1, sA.l2, EDashedLine(B, sA.p3)])
            sECA = ETriangle.assemble(lines=[sC.l0, tABC.l2, EDashedLine(A, sC.p0)])

            with self.pause_animations_for():
                lAlx = sC.l2.parallel(tABC.p0)
            pL = EPoint(lAlx.intersect(sC.l3), label=('L', DOWN))

            sBDL = EParallelogram(B, sC.p3, pL)
            sCEL = EParallelogram(C, sC.p0, pL)

            sA.e_fill(GREEN)
            sCEL.e_fill(GREEN)
            sECA.e_fill(GREEN_D)
            sBCK.e_fill(GREEN_D)

            sB.e_fill(BLUE)
            sBDL.e_fill(BLUE)
            sABD.e_fill(BLUE_D)
            sFBC.e_fill(BLUE_D)
