import sys
import os
from pprint import pprint

sys.path.append(os.getcwd())

from manimlib import *
from euclidlib.Propositions.PropScene import PropScene, to_manim_coord
from euclidlib.Objects.TextBox import TextBox
from euclidlib.Objects.Geometry import *


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
        t1 = TextBox(self, absolute_position=to_manim_coord(800, 150))
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
            C = Intersection(self.cA, self.cB).get_top()
            self.pC = EuclidPoint(C, scene=self, label='C', label_dir=UP)

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
                self.cA.dullout()
                self.cB.dullout()

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _7():
            t1.down()
            t1.title("Proof:")
            with self.simultaneous():
                self.lAC.dullout()
                self.cA.dullout()
                self.cB.normal()

            t1.explain("AB and CB are radii of the same circle - hence they are equal")
            self.lAB.add_label("r", DOWN)
            self.lBC.add_label("r", RIGHT)
            t2.math("AB = CB = r")

        @self.push_step
        def _8():
            with self.simultaneous():
                self.lBC.dullout()
                self.cB.dullout()
                self.lAB.normal()
                self.lAC.normal()
                self.cA.normal()

            t1.explain("AB and AC are radii of the same circle - hence they are equal")
            self.lAC.add_label("r", LEFT)
            t2.math("AB = AC = r")

        @self.push_step
        def _9():
            with self.simultaneous():
                self.cB.dullout()
                self.cA.dullout()
                self.lAB.normal()
                self.lAC.normal()
                self.lBC.normal()

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

