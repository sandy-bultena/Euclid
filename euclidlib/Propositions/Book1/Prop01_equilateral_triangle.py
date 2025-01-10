import sys
import os
from pprint import pprint

sys.path.append(os.getcwd())

from manimlib import *
from euclidlib.Propositions.PropScene import PropScene, to_manim_coord, to_manim_h_scale
from euclidlib.Objects.TextBox import TextBox
from euclidlib.Objects import *


class Book1Prop1(PropScene):
    steps = []
    pA: EuclidPoint
    pB: EuclidPoint
    pC: EuclidPoint
    lAB: EuclidLine
    lAC: EuclidLine
    lBC: EuclidLine
    cA: EuclidCircle
    cB: EuclidCircle

    def define_steps(self):
        t1 = TextBox(self, absolute_position=to_manim_coord(800, 150), line_width=to_manim_h_scale(500))
        t2 = TextBox(self, absolute_position=to_manim_coord(500, 430))
        A = to_manim_coord(200, 500)
        B = to_manim_coord(450, 500)

        @self.push_step
        def _1():
            t1.title("Construction:")
            t1.explain("Start with line segment AB")
            self.pA = EuclidPoint(A, scene=self, label='A', label_dir=LEFT)
            self.pB = EuclidPoint(B, scene=self, label='B', label_dir=RIGHT)
            self.lAB = EuclidLine(self.pA, self.pB, scene=self)

        @self.push_step
        def _2():
            t1.explain("Create a circle with center A and radius AB")
            self.cA = EuclidCircle(self.pA, self.pB, scene=self)

        @self.push_step
        def _3():
            t1.explain("Create a circle with center B and radius AB")
            self.cB = EuclidCircle(self.pB, self.pA, scene=self)

        @self.push_step
        def _4():
            t1.explain("Label the intersection point C")
            pts = self.cA.intersect(self.cB)
            self.pC = EuclidPoint(pts[0], scene=self, label='C', label_dir=UP)

        @self.push_step
        def _5():
            t1.explain("Create line AC and CB")
            with self.simultaneous():
                self.lAC = EuclidLine(self.pA, self.pC, scene=self)
                self.lBC = EuclidLine(self.pB, self.pC, scene=self)

        @self.push_step
        def _6():
            t1.explain("Triangle ABC is an equilateral triangle")
            with self.simultaneous():
                self.cA.e_fade()
                self.cB.e_fade()

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _7():
            t1.down()
            t1.title("Proof:")
            with self.simultaneous():
                self.lAC.e_fade()
                self.cA.e_fade()
                self.cB.e_normal()

            t1.explain("AB and CB are radii of the same circle - hence they are equal")
            self.lAB.add_label("r", DOWN)
            self.lBC.add_label("r", RIGHT)
            t2.math("AB = CB = r")

        @self.push_step
        def _8():
            with self.simultaneous():
                self.lBC.e_fade()
                self.cB.e_fade()
                self.lAB.e_normal()
                self.lAC.e_normal()
                self.cA.e_normal()

            t1.explain("AB and AC are radii of the same circle - hence they are equal")
            self.lAC.add_label("r", LEFT)
            t2.math("AB = AC = r")

        @self.push_step
        def _9():
            with self.simultaneous():
                self.cB.e_fade()
                self.cA.e_fade()
                self.lAB.e_normal()
                self.lAC.e_normal()
                self.lBC.e_normal()

            t1.explain(
                "If AB equals AC and AB equals CB, "
                "then AC equals CB"
            )
            self.lBC.add_label("r", RIGHT)
            t2.math("AB = CB = CA = r")

        @self.push_step
        def _9():
            t2.down()
            t2.math(r"\therefore Equilateral Triangle!")

