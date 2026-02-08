import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop22(Book1Scene):
    steps = []
    title = ("To construct a triangle out of three straight lines which equal three "
             "given straight lines - thus it is necessary that the sum of any two of "
             "the straight lines should be greater than the remaining one.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(475, 200), line_width=mn_scale(550))
        t3 = TextBox(mn_coord(500, 475), line_width=mn_scale(550))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        #ex: Dict[str | int, Mobject] = {}

        A = mn_coord(75, 200), mn_coord(240, 200)
        B = mn_coord(75, 220), mn_coord(250, 220)
        C = mn_coord(75, 240), mn_coord(175, 240)
        D = mn_coord(75, 400)
        E = mn_coord(600, 400)

        # ------------------------------------------------------------------------
        # Construction
        # ----------------------------------------------
        t1.title("Construction:")
        t1.explain("Start with three lines a,b,c where the sum of any two "
                   "is greater than the third")
        with self.staggered_animation():
            p['A'] = EPoint(A[0], label=('a', LEFT))
            l['A'] = ELine(*A)
            p['B'] = EPoint(B[0], label=('b', LEFT))
            l['B'] = ELine(*B)
            p['C'] = EPoint(C[0], label=('c', LEFT))
            l['C'] = ELine(*C)
        with self.staggered_animation():
            t2.math('b + c > a')
            t2.math('c + a > b')
            t2.math('a + b > c')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Construct a line DE of sufficient length such that "
                   "it is greater than the sum of a,b,c")
        with self.staggered_animation():
            p['D'] = EPoint(D, label=('D', LEFT))
            l['DE'] = ELine(D,E)
            p['E'] = EPoint(E, label=('E', RIGHT))

        self.next_page()

        # ------------------------------------------------------------------------
        def copy_line(name, F, A, D, a):
            t1.explain(rf"Define a point {F} such that {D}{F} is equal in length to {A}{{nb}}(I.3)")
            l[f'{D}{F}'], p[F] = l[A].copy_to_line(p[D], l['DE'], speed=self.default_speed*3)
            with self.simultaneous():
                p[F].add_label(F, DOWN)
                l[f'{D}{F}'].add_label(a, DOWN)

        copy_line('_c3', 'F', 'A', 'D', 'a')
        self.next_page()

        # ------------------------------------------------------------------------
        copy_line('_c4', 'G', 'B', 'F', 'b')
        self.next_page()

        # ------------------------------------------------------------------------
        copy_line('_c5', 'H', 'C', 'G', 'c')
        self.next_page()

        # ------------------------------------------------------------------------

        def draw_circle(name, F, D):
            t1.explain(f"Draw a circle, with center {F}, and radius {D}{F}")
            c[F] = ECircle(p[F], p[D])


        draw_circle('_c6', 'F', 'D')
        self.next_page()

        # ------------------------------------------------------------------------
        draw_circle('_c7', 'G', 'H')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("From the intersection point K, construct two lines "
                   "KF and KG")
        pts = c['G'].intersect(c['F'])
        p['K'] = EPoint(pts[0], label=('K', UP))
        with self.simultaneous():
            l['FK'] = ELine(p["K"],p["F"])
            l['GK'] = ELine(p['K'], p['G'])
        with self.simultaneous():
            c['G'].e_fade()
            c['F'].e_fade()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Triangle FKG has been constructed from lines of "
                   "length a, b and c")

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t1.down()
        t1.title("Proof:")
        t1.explain("Line FK and FD are equal, since they are the radius "
                   "of the same circle, and FD is equal to a")
        with self.simultaneous():
            l['GK'].e_fade()
            c['F'].e_normal()
        l['FK'].add_label('a', outside=True)
        t3.math('FK = FD = a')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Line GK and GH are equal, since they are the radius "
                   "of the same circle, and GH is equal to c")
        with self.simultaneous():
            l['FK'].e_fade()
            c['F'].e_fade()
            c['G'].e_normal()
            l['GK'].e_normal()
        l['GK'].add_label('c', inside=True)
        t3.math('GK = GH = c')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            l['FK'].e_normal()
            c['F'].e_remove()
            c['G'].e_remove()
