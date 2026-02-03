"""
BookScene contains the table of contents and first image for a specific book

inherits from PropScene

"""
from __future__ import annotations

import re
from enum import Enum
from itertools import pairwise

import manimlib as mn
from typing import Callable

#from euclidlib.Objects import TextBox, ELine, EPoint, ECircle, ETriangle, EAngleBase, EGroup, EMObject, EPolygon
#from euclidlib.Objects import *
from euclidlib.Utilities.coordinate_utilities import mn_coord, mn_scale
from euclidlib.Objects.TextBox import TextBox
from euclidlib.Objects.Line import ELine
from euclidlib.Objects.Circle import ECircle
from euclidlib.Objects.Triangle import ETriangle
from euclidlib.Objects.Angle import EAngleBase
from euclidlib.Objects.em_group_object import EGroup
from euclidlib.Objects.em_object_base import EMObject
from euclidlib.Objects.Polygon import EPolygon
from euclidlib.Objects.Point import EPoint


GRID_OPACITY = 0

from euclidlib.debugging import print_debug
from euclidlib.Scenes.PropScene import PropScene
import roman

DEG = 180/mn.PI

class AnimState(Enum):
    NORMAL = 0
    STORING = 1
    PAUSED = 2


def get_TOC(toc):
    entries = TextBox(mn.ORIGIN)
    for i, title in enumerate(toc, start=1):
        entries.explain(f"Proposition {i}: {title}", skip_anim=True)
    return mn.VGroup(*entries.submobjects)


class AttrDict[K, T](dict[K, T]):
    __slots__ = ()
    __getattr__ = dict[K, T].__getitem__
    __setattr__ = dict[K, T].__setitem__


class BookScene(PropScene):
    book: int
    prop: int
    TOC: list[str]

    def __init__(self, *args, **kwargs):
        cls = type(self)
        self.l: dict[str | int, ELine] = {}
        self.p: dict[str | int, EPoint] = {}
        self.c: dict[str | int, ECircle] = {}
        self.t: dict[str | int, ETriangle] = {}
        self.a: dict[str | int, EAngleBase] = {}
        cls.book, cls.prop = cls.get_prop_number()
        super().__init__(*args, **kwargs)


    # -----------------------------------------------------------------------------------------------------------------
    # get objects from object names
    # -----------------------------------------------------------------------------------------------------------------
    def points(self, name:str):
        pts = []
        for c in name:
            if c not in self.p:
                raise IndexError(f"{name=} p[{c}] does not exists")
            pts.append(self.p[c])
        return [self.p.get(a,None) for a in name if a in self.p]

    def lines(self, name: str):
        lines = []
        for c1,c2 in pairwise(name):
            if f"{c1}{c2}" not in self.l and f"{c2}{c1}" not in self.l:
                raise IndexError(f"neither l[{c1}{c2}] nor l[{c2}{c1}] exists")
            if f"{c1}{c2}" in self.l:
                lines.append(self.l[f"{c1}{c2}"])
            else:
                lines.append(self.l[f"{c2}{c1}"])
        return lines

    def title_page(self):
        t = TextBox((0, mn_scale(350), 0),
                    buff_size=mn.MED_LARGE_BUFF,
                    alignment='n'
                    )

        t.title_screen("Euclid's Elements", write_simultaneous=True)
        print_debug(2,f"book number: {self.book=}")
        t.title(f"Book {roman.toRoman(self.book)}", write_simultaneous=True)
        t.fancy("Fancy quote")

    # -----------------------------------------------------------------------------------------------------------------
    # table of contents
    # -----------------------------------------------------------------------------------------------------------------
    def table_of_contents(self, tb: TextBox):
        entries = get_TOC(self.TOC)
        self.add(entries)
        entries.next_to(self.frame.get_corner(mn.DL), mn.DR)

        distance_diff = entries.get_center() - entries[self.prop - 1].get_center()
        self.play(entries.animate(run_time=1, rate_func=mn.rush_from).move_to(distance_diff, coor_mask=mn.UP))

        line = entries[self.prop - 1]
        entries.remove(line)
        self.play(line.animate.set_fill(mn.BLUE))

        title = tb.title(f"Proposition {self.prop} of Book {self.book}", delay_anim=True)
        self.play(
            mn.TransformMatchingStrings(line, title),
            entries.animate(run_time=1, rate_func=mn.rush_into).next_to(self.frame.get_corner(mn.UL), mn.UR)
        )

    # -----------------------------------------------------------------------------------------------------------------
    # reset
    #  - clears all the objects in the scene, and then  sets the title
    #  - (shows table of contents if desired)
    # -----------------------------------------------------------------------------------------------------------------
    def reset(self):
        with self.simultaneous(run_time=1):
            gg = EGroup((sub for sub in self.mobjects if isinstance(sub, EMObject)), scene=self)
            gg.e_remove()

        # print the title (and maybe table of contents)
        if self.title and self.prop:
            t = TextBox(mn_coord(700, 50),
                        line_width=mn_scale(1000),
                        alignment='n'
                        )
            if False and not self.debug:
                self.table_of_contents(t)
            else:
                t.title(f"Proposition {self.prop} of Book {self.book}")
            t.normal(self.title)

        # draw the grid
        line_options = dict(
            stroke_color=mn.WHITE,
            stroke_width=0.5,
            stroke_opacity=GRID_OPACITY,
        )

        grid = mn.NumberPlane(
            background_line_style=line_options,
            axis_config=line_options,
            faded_line_style=line_options,
        )
        grid.fix_in_frame()
        self.play(mn.FadeIn(grid))

    @classmethod
    def get_prop_number(cls):
        match = re.search(r"Book(\d+).Prop(\d+)", cls.__module__)
        if not match:
            return 0,0
        return int(match.group(1)), int(match.group(2))



class Book1Scene(BookScene):
    def title_page(self):
        title_box = TextBox(mn_scale(0, 100, 0),
                            line_width=mn_scale(550),
                            alignment='w'
                            )
        with self.simultaneous():
            super().title_page()
            title_box.fancy("If Euclid did not kindle your youthful enthusiasm, "
                            "you were not born to be a scientific thinker.", font_size=24, write_simultaneous=True)
            title_box.explain("-Albert Einstein", font_size=18)

            # top = 400
            # bot = top + 100
            # left = 945
            # right = 75 + left
            # A_base = np.array([right, top, 0])
            # B_base = np.array([left, bot, 0])
            #
            # side = -1 * (B_base[0] - A_base[0]) / (bot - top)
            # b = A_base[1] - side * A_base[0]
            # C_base = np.array([(1 / side) * (bot - b), bot, 0])
            #
            # A = mn_coord(*A_base)
            # B = mn_coord(*B_base)
            # C = mn_coord(*C_base)
            #
            # tABC = ETriangle('ABC', point_labels='ABC', angles=' ')
            # sB = ESquare(B, A, point_labels=['F', None, None, 'G'])
            # sA = ESquare(A, C, point_labels=['H', None, None, 'K'])
            # sC = ESquare(C, B, point_labels=['E', None, None, 'D'])
            #
            # sABD = ETriangle.assemble(lines=[tABC.l0, sC.l2, EDashedLine(A, sC.p3)])
            # sFBC = ETriangle.assemble(lines=[sB.l0, tABC.l1, EDashedLine(sB.p0, C)])
            # sBCK = ETriangle.assemble(lines=[tABC.l1, sA.l2, EDashedLine(B, sA.p3)])
            # sECA = ETriangle.assemble(lines=[sC.l0, tABC.l2, EDashedLine(A, sC.p0)])
            #
            # with self.pause_animations_for():
            #     lAlx = sC.l2.parallel(tABC.p0)
            # pL = EPoint(lAlx.intersect(sC.l3), label=('L', mn.DOWN))
            #
            # sBDL = EParallelogram(B, sC.p3, pL)
            # sCEL = EParallelogram(C, sC.p0, pL)
            #
            # sA.e_fill(mn.GREEN)
            # sCEL.e_fill(mn.GREEN)
            # sECA.e_fill(mn.GREEN_D)
            # sBCK.e_fill(mn.GREEN_D)
            #
            # sB.e_fill(mn.BLUE)
            # sBDL.e_fill(mn.BLUE)
            # sABD.e_fill(mn.BLUE_D)
            # sFBC.e_fill(mn.BLUE_D)


class Book2Scene(BookScene):
    def title_page(self):
        title_box = TextBox(mn_scale(0, 100, 0),
                            line_width=mn_scale(600),
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

                title_box[-1].align_to(title_box[-2], mn.RIGHT)

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
                gnomon.e_fill(mn.BLUE_D)

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


class Book3Scene(BookScene):
    def title_page(self):
        title_box = TextBox(mn_scale(0, 100, 0),
                            line_width=mn_scale(600),
                            alignment='e'
                            )
        with self.simultaneous():
            super().title_page()

            with self.pause_animations_for() as draw:
                title_box.fancy("A circle is a round straight line with a hole in the middle.", font_size=48,
                                write_simultaneous=True)
                title_box.explain("""
                - <b>Mark Twain</b>,
                  quoting a schoolchild in "-English as She Is Taught-"
                """, font_size=16)

                title_box[-1].align_to(title_box[-2], mn.RIGHT)
                title_box.down()
                title_box.fancy("If people stand in a circle long enough, "
                                "they'll eventually begin to dance.", font_size=48, write_simultaneous=True)
                title_box.explain("""
                <b>George Carlin</b>, Napalm and Silly Putty (2001)
                """, font_size=16)
                title_box[-1].align_to(title_box[-2], mn.RIGHT)
                draw.append(title_box)

            c1 = mn_coord(260, 360)
            r1 = mn_scale(180)
            c2 = c1 + mn_scale(80, 0, 0)

            with self.pause_animations_for() as draw:
                cA = ECircle(c1, c1 + r1 * mn.RIGHT)
                pE = EPoint(c1, label=('E', mn.DL))
                pF = EPoint(c2, label=('F', mn.DR))

                pA = cA.e_point_at_angle(mn.PI).add_label('A', away_from=c2)
                lFA = ELine(c2, pA)

                pD = cA.e_point_at_angle(0).add_label('D', away_from=c2)
                lFD = ELine(c2, pD)

                pB = cA.e_point_at_angle(140 * DEG).add_label('B', away_from=c2)
                lFB = ELine(c2, pB)

                pC = cA.e_point_at_angle(100 * DEG).add_label('C', away_from=c2)
                lFC = ELine(c2, pC)

                pG = cA.e_point_at_angle(mn.PI/4).add_label('G', away_from=c2)
                lFG = ELine(c2, pG)

                pH = cA.e_point_at_angle(-mn.PI/4).add_label('H', away_from=c2)
                lFH = ELine(c2, pG)

                draw.extend([cA, pE, pF, pA, lFA, pD, lFD, pB, lFB, pC, lFC, pG, lFG, pH, lFH])
                draw.append(ELine(pB, pE))
                draw.append(ELine(pC, pE))
                draw.append(ELine(pG, pE))
                draw.append(ELine(pH, pE))



