import math
import sys
import os

sys.path.append(os.getcwd())
from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Book1Prop3(Book1Scene):
    steps = []
    title = ("To cut off from the greater of two "
             "given unequal straight lines a straight line equal to the less.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(600, 430))
        A = mn_coord(150, 450)
        B = mn_coord(250, 450)
        C = mn_coord(350, 350)
        D = mn_coord(600, 350)

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}

        rAB = math.sqrt(
            (A[0] - B[0]) ** 2 +
            (A[1] - B[1]) ** 2
        )
        rCD = math.sqrt(
            (C[0] - D[0]) ** 2 +
            (C[1] - D[1]) ** 2
        )
        F = (D[0], D[1] - rAB + rCD)
        self.next_page()

        # ------------------------------------------------------------------------
        # In Other Words
        # ------------------------------------------------------------------------
        t1.title("In other words")
        t1.explain("Start with line AB and line CD, where CD is larger than AB")

        with self.simultaneous():
            p['A'] = EPoint(A, scene=self, label_args=('A', LEFT))
            p['B'] = EPoint(B, scene=self, label_args=('B', RIGHT))
            l['AB'] = ELine(p['A'], p['B'], scene=self)

            p['C'] = EPoint(C, scene=self, label_args=('C', DOWN))
            p['D'] = EPoint(D, scene=self, label_args=('D', DOWN))
            l['CD'] = ELine(p['C'], p['D'], scene=self)
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Construct a line that is equal to CD minus AB")

        p['F'] = EPoint(F, scene=self, label_args=('F', RIGHT))
        l['DF'] = ELine(D, F, scene=self, stroke_color=BLUE)
        self.next_page()

        # ------------------------------------------------------------------------
        # Construction
        # ------------------------------------------------------------------------
        t1.down()
        t1.title("Construction")
        with self.simultaneous():
            l['DF'].e_remove()
            p['F'].e_remove()

        t1.explain("Start with line AB and line CD")
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Construct line segment CE equal to AB (I.2)")
        l['CE'], p['E'] = l['AB'].copy_to_point(p['C'], speed=1)
        p['E'].add_label('E', away_from=C)
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Draw a circle with C as the center and CE as the radius")
        c['E'] = ECircle(p['C'], p['E'], scene=self)
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Define the intersection of the circle and CD as F")
        pts = c['E'].intersect(l['CD'])
        p['F'] = EPoint(pts[0], scene=self, label_args=('F', UR))
        l['CF'] = ELine(C, p['F'], scene=self)
        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            c['E'].e_fade()
            l['CE'].e_fade()
        t1.explain("Line DF is the difference between line CD and line AB")
        l['DF'] = ELine(D, p['F'], scene=self)
        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ------------------------------------------------------------------------
        with self.simultaneous():
            l['CE'].e_normal()
            l['CD'].green()
            l['DF'].e_fade()
            l['CF'].e_fade()

        t1.down()
        t1.title("Proof:")
        t1.explain("AB is equal to CE (I.2)")

        with self.simultaneous():
            l['AB'].add_label('x', UP)
            l['CE'].add_label('x', UP)
            l['CD'].add_label('y', DOWN)

        t2.math("CD = y")
        t2.math("AB = CE = x")
        self.next_page()

        # ------------------------------------------------------------------------
        l['CF'].e_normal()

        t1.explain("Line CF and line CE are radii of the same circle")
        l['CF'].add_label('x', UP)

        t2.e_fade(0)
        t2.math("CE = CF = x")
        t2.math("AB = CF = x")
        t2.down()
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Line DF is the difference between CD and CF")
        l['DF'].add_label('y-x', UP)
        t2.e_fade()
        t2.math("DF = CD - CF")
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Line DF is the difference between CD and AB")
        with self.simultaneous():
            l['CE'].e_fade()
            l['CD'].remove_label()
            l['DF'].green.lift()
        t2.e_normal(3,4)
        t2.math("DF = CD - AB")

        self.next_page()
