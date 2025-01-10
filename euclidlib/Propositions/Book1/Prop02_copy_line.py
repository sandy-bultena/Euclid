import sys
import os
from pprint import pprint

sys.path.append(os.getcwd())

from manimlib import *
from euclidlib.Propositions.PropScene import PropScene, to_manim_coord, to_manim_h_scale
from euclidlib.Objects.TextBox import TextBox
from euclidlib.Objects import *
from euclidlib.Builders import EquilateralTriangle


class Book1Prop2(PropScene):
    steps = []
    pA: EuclidPoint
    pB: EuclidPoint
    pC: EuclidPoint
    pD: EuclidPoint
    pE: EuclidPoint
    pF: EuclidPoint

    lAB: EuclidLine
    lAC: EuclidLine
    lBC: EuclidLine
    lAD: EuclidLine
    lCD: EuclidLine
    lCF: EuclidLine
    lAE: EuclidLine
    lDE: EuclidLine
    lDF: EuclidLine

    cA: EuclidCircle
    cB: EuclidCircle
    cD: EuclidCircle

    tri1: EuclidTriangle

    def define_steps(self):
        t1 = TextBox(self, absolute_position=to_manim_coord(800, 150), line_width=to_manim_h_scale(550))
        t2 = TextBox(self, absolute_position=to_manim_coord(580, 430), line_width=to_manim_h_scale(500))
        t3 = TextBox(self, absolute_position=to_manim_coord(800, 150), line_width=to_manim_h_scale(500))
        t4 = TextBox(self, absolute_position=to_manim_coord(800, 150), line_width=to_manim_h_scale(500))
        A = to_manim_coord(200, 500)
        B = to_manim_coord(300, 500)
        C = to_manim_coord(450, 400)
        D = to_manim_coord(250, 400)

        # ------------------------------------------------------------------------
        # Construction
        # ------------------------------------------------------------------------
        @self.push_step
        def _1():
            t1.title("Construction:")
            t1.explain("Start with line segment AB and Point C")

            self.pA = EuclidPoint(A, scene=self, label='A', label_dir=LEFT)
            self.pB = EuclidPoint(B, scene=self, label='B', label_dir=RIGHT)
            self.lAB = EuclidLine(self.pA, self.pB, scene=self, stroke_color=BLUE)
            self.pC = EuclidPoint(C, scene=self, label='C', label_dir=DOWN)

        @self.push_step
        def _2():
            t1.explain("Construct line segment AC")
            self.lAC = EuclidLine(self.pA, self.pC, scene=self)

        @self.push_step
        def _3():
            t1.explain("Construct an equilateral triangle on line AC <sub>(I.1)</sub>")
            self.tri1, self.pD = EquilateralTriangle.build(self, A, C, 3)
            with self.animation_speed(3):
                with self.simultaneous():
                    self.lAD = self.tri1.l[2]
                    self.lCD = self.tri1.l[1]
            self.pD.add_label('D', UP)

        @self.push_step
        def _4():
            t1.explain("Draw a circle with A as the center and AB as the radius")
            self.cA = EuclidCircle(A, B, scene=self)

        @self.push_step
        def _5():
            t1.explain("Label the intersection of the circle and line AD as E")
            pts = self.cA.intersect(self.lAD)
            self.pE = EuclidPoint(pts[0], scene=self, label='E', label_dir=UL)

        @self.push_step
        def _6():
            t1.explain("Draw a circle with D as the center and ED as the radius")
            self.cA.e_fade()
            self.cD = EuclidCircle(self.pD, self.pE, scene=self)

        @self.push_step
        def _7():
            t1.explain("Label the intersection of the circle and line CD as F")
            pts = self.cD.intersect(self.lCD)
            self.pF = EuclidPoint(pts[0], scene=self, label='F', label_dir=RIGHT)

        @self.push_step
        def _8():
            t1.explain("Line AB is equal to line CF")
            with self.simultaneous():
                self.cD.e_fade()
                self.lAC.e_fade()
                self.tri1.e_fade()
                self.lCD.e_fade()
                self.lAD.e_fade()
                # self.pD.dullout()
                # self.pE.dullout()
            self.lCF = EuclidLine(C, self.pF, scene=self)

        # ------------------------------------------------------------------------
        # Proof
        # ------------------------------------------------------------------------

        @self.push_step
        def _9():
            t1.down()
            t1.title("Proof:")

        @self.push_step
        def _10():
            with self.simultaneous():
                self.lCD.e_normal()
                self.lAD.e_normal()
                self.lAB.e_fade()
                self.pE.e_remove()
                self.pF.e_remove()
                self.lCF.e_remove()

            t1.explain("Line AD is equal to line DC (equilateral triangle)")
            self.lCD.add_label("x", LEFT)
            self.lAD.add_label("x", RIGHT)
            t2.math("AD = DC = x")

        @self.push_step
        def _11():
            with self.simultaneous():
                self.lAD.green()
                self.lAC.e_fade()
                self.lCD.green()
                self.cD.e_normal()

            t1.explain("DE and DF are equal (radii of the same circle)")
            with self.simultaneous():
                self.pE.e_draw()
                self.pF.e_draw()
                self.lDE = EuclidLine(self.pD, self.pE, label='y', label_dir=LEFT, scene=self)
                self.lDF = EuclidLine(self.pD, self.pF, label='y', label_dir=RIGHT, scene=self)
            t2.math("DE = DF = y")

        @self.push_step
        def _12():
            with self.simultaneous():
                self.cD.e_fade()
                if 'lAE' in self.__dict__:
                    self.lAE.e_remove()
                self.lCD.e_fade()
                self.lAD.e_fade()
                self.lDE.e_fade()

            t1.explain("AE is the difference between DA and DE")
            self.lAE = EuclidLine(A, self.pE, scene=self, label='x-y', label_dir=LEFT)
            t2.math("AE = DA - DE")
            t2.math("AE = x  - y")

        @self.push_step
        def _13():
            with self.simultaneous():
                self.cD.e_fade()
                if self.lCF.in_scene():
                    self.lCF.e_remove()
                self.lCD.e_fade()
                self.lDF.e_fade()

            t1.explain("CF is the difference between DC and DF")
            self.lCF = EuclidLine(C, self.pF, scene=self, label='x-y', label_dir=RIGHT)
            t2.math("CF = DC - DF")
            t2.math("CF = x  - y")

        @self.push_step
        def _14():
            with self.simultaneous():
                self.lAD.e_fade()
                self.lCD.e_fade()
                self.lDE.e_fade()
                self.lDF.e_fade()

            t1.explain(
                "AE and FC are the differences of equals, "
                "so they are equal")
            with self.simultaneous():
                self.lAE.add_label('z', LEFT)
                self.lCF.add_label('z', RIGHT)
            t2.math("AE = CF = z")

        @self.push_step
        def _15():
            with self.simultaneous():
                self.cA.e_normal()
                self.lAB.blue()
                self.lAD.e_fade()
                self.lCD.e_fade()
                self.lCF.e_fade()

            t1.explain("AB and AE are radii of the same circle")
            self.lAB.add_label('z', DOWN)
            t2.math("AB = AE = z")

        @self.push_step
        def _16():
            with self.simultaneous():
                self.cA.e_fade()
                self.lAD.e_fade()
                self.lAE.e_fade()
                self.lCF.e_normal()

            t1.explain("AB and CF are equal")
            self.lAB.add_label('z', DOWN)
            t2.math("AB = CF = z")
