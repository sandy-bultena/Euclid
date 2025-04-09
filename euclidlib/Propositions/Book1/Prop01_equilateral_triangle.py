import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Book1Prop1(Book1Scene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(500))
        t2 = TextBox(mn_coord(500, 430))
        A = mn_coord(200, 500)
        B = mn_coord(450, 500)

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}

        @self.push_step
        def _1():
            t1.title("Construction:")
            t1.explain("Start with line segment AB")
            p['A'] = EPoint(A, scene=self, label_args=('A', LEFT))
            p['B'] = EPoint(B, scene=self, label_args=('B', RIGHT))
            l['AB'] = ELine(p['A'], p['B'], scene=self)

        @self.push_step
        def _2():
            t1.explain("Create a circle with center A and radius AB")
            c['A'] = ECircle(p['A'], p['B'], scene=self)

        @self.push_step
        def _3():
            t1.explain("Create a circle with center B and radius AB")
            c['B'] = ECircle(p['B'], p['A'], scene=self)

        @self.push_step
        def _4():
            t1.explain("Label the intersection point C")
            pts = c['A'].intersect(c['B'])
            p['C'] = EPoint(pts[0], scene=self, label_args=('C', UP))

        @self.push_step
        def _5():
            t1.explain("Create line AC and CB")
            with self.simultaneous():
                l['AC'] = ELine(p['A'], p['C'], scene=self)
                l['BC'] = ELine(p['B'], p['C'], scene=self)

        @self.push_step
        def _6():
            t1.explain("Triangle ABC is an equilateral triangle")
            with self.simultaneous():
                c['A'].e_fade()
                c['B'].e_fade()

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _7():
            t1.down()
            t1.title("Proof:")
            with self.simultaneous():
                l['AC'].e_fade()
                c['A'].e_fade()
                c['B'].e_normal()

            t1.explain("AB and CB are radii of the same circle - hence they are equal")
            l['AB'].add_label("r", DOWN)
            l['BC'].add_label("r", RIGHT)
            t2.math("AB = CB = r")

        @self.push_step
        def _8():
            with self.simultaneous():
                l['BC'].e_fade()
                c['B'].e_fade()
                l['AB'].e_normal()
                l['AC'].e_normal()
                c['A'].e_normal()

            t1.explain("AB and AC are radii of the same circle - hence they are equal")
            l['AC'].add_label("r", LEFT)
            t2.math("AB = AC = r")

        @self.push_step
        def _9():
            with self.simultaneous():
                c['B'].e_fade()
                c['A'].e_fade()
                l['AB'].e_normal()
                l['AC'].e_normal()
                l['BC'].e_normal()

            t1.explain(
                "If AB equals AC and AB equals CB, "
                "then AC equals CB"
            )
            l['BC'].add_label("r", RIGHT)
            t2.math("AB = CB = CA = r")

        @self.push_step
        def _9():
            t2.down()
            t2.math(r"\therefore Equilateral Triangle!")

