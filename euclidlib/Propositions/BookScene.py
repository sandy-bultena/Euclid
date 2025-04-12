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

class AttrDict[K, T](dict[K, T]):
    __slots__ = ()
    __getattr__ = dict[K, T].__getitem__
    __setattr__ = dict[K, T].__setitem__


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
                angles[label2[i:i + 3]] = angle

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

                distance_diff = entries.get_center() - entries[self.prop - 1].get_center()
                self.play(entries.animate(run_time=1, rate_func=rush_from).move_to(distance_diff, coor_mask=UP))

                line = entries[self.prop - 1]
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

class Book2Scene(BookScene):
    def title_page(self):
        title_box = TextBox(mn_scale(0, 100, 0),
                            line_width=mn_h_scale(600),
                            alignment='e'
                            )
        with self.simultaneous():
            super().title_page()

            with self.pause_animations_for():
                title_box.fancy("It is a remarkable fact in the history of geometry, "
                                "that the Elements of Euclid, "
                                "written two thousand years ago, are still regarded by many as the best "
                                "introduction to the mathematical sciences.", font_size=48, write_simultaneous=True)
                title_box.explain("""
                - Florian Cajori,
                  A History of Mathematics (1893)
                """, font_size=16)

                title_box[-1].align_to(title_box[-2], RIGHT)

                title_box.down()
                title_box.explain('<b>Definitions:</b>')
                title_box.explain("Any rectangular parallelogram is said to "
                                  "be contained by the two straight "
                                  "lines containing the right angle.")
                title_box.explain("And in any parallelogrammic area let any one whatever of "
                                  "the parallelograms about its diameter with the two complements "
                                  "be called a gnomon.")

                para = EPolygon(
                    mn_coord(450, 700),
                    mn_coord(600, 700),
                    mn_coord(650, 600),
                    mn_coord(500, 600))
                gnomon = EPolygon(
                    mn_coord(450, 700),
                    mn_coord(600, 700),
                    mn_coord(617, 667),
                    mn_coord(517, 667),
                    mn_coord(550, 600),
                    mn_coord(500, 600),
                )
                gnomon.e_fill(BLUE_D)

                diag = ELine(mn_coord(450, 700), mn_coord(650, 600))
                l1 = ELine(mn_coord(500, 700), mn_coord(550, 600))
                cross = l1.intersect(diag)
                p = EPoint(cross)
                l2 = para.l0.parallel(p)
                l3 = ELine(
                    l2.intersect(para.l3),
                    l2.intersect(para.l1),
                )
                ar1 = ELine(mn_coord(650, 660),
                            mn_coord(690, 660))
                ar2 = ELine(mn_coord(650, 660),
                            mn_coord(660, 650))
                ar3 = ELine(mn_coord(650, 660),
                            mn_coord(660, 670))

            with self.delayed():
                for x in title_box:
                    x.e_draw()
            with self.simultaneous():
                para.e_draw()
                gnomon.e_draw()
                diag.e_draw()
                l1.e_draw()
                l3.e_draw()
                ar1.e_draw()
                ar2.e_draw()
                ar3.e_draw()