import sys
import os

sys.path.append(os.getcwd())
from euclidlib.Propositions.BookScene import Book1Scene

from euclidlib.Objects import *
from euclidlib.Objects import EquilateralTriangle
from typing import Dict


class Book1Prop2(Book1Scene):
    steps = []
    title = ("To place a straight line equal to a given straight line "
             "with one end at a given point.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=to_manim_h_scale(550))
        t2 = TextBox(mn_coord(580, 430), line_width=to_manim_h_scale(500))
        t3 = TextBox(mn_coord(800, 150), line_width=to_manim_h_scale(500))
        A = mn_coord(200, 500)
        B = mn_coord(300, 500)
        C = mn_coord(440, 400)
        D = mn_coord(250, 400)

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}

        # ------------------------------------------------------------------------
        # Construction
        # ------------------------------------------------------------------------
        @self.push_step
        def _1():
            t1.title("Construction:")
            t1.explain("Start with line segment AB and Point C")

            p['A'] = EuclidPoint(A, label_args=('A', dict(away_from=B)))
            p['B'] = EuclidPoint(B, label_args=('B', dict(away_from=A)))
            l['AB'] = EuclidLine(p['A'], p['B'], stroke_color=BLUE)
            p['C'] = EuclidPoint(C, label_args=('C', dict(away_from=A)))

        @self.push_step
        def _2():
            t1.explain("Construct line segment AC")
            l['AC'] = EuclidLine(p['A'], p['C'])

        @self.push_step
        def _3():
            t1.explain("Construct an equilateral triangle on line AC <sub>(I.1)</sub>")
            t[1] = EquilateralTriangle.build(A, C)
            p['D'] = t[1].p[-1]
            self.remove(l['AC'])
            l['AC'] = t[1].l[0]
            l['CD'] = t[1].l[1]
            l['AD'] = t[1].l[2]
            p['D'].add_label('D', away_from=t[1].get_center_of_mass())

        @self.push_step
        def _4():
            t1.explain("Draw a circle with A as the center and AB as the radius")
            c['A'] = EuclidCircle(A, B)

        @self.push_step
        def _5():
            t1.explain("Label the intersection of the circle and line AD as E")
            pts = c['A'].intersect(l['AD'])
            p['E'] = EuclidPoint(pts[0], label_args=('E', DL))

        @self.push_step
        def _6():
            t1.explain("Draw a circle with D as the center and ED as the radius")
            c['A'].e_fade()
            c['D'] = EuclidCircle(p['D'], p['E'])

        @self.push_step
        def _7():
            t1.explain("Label the intersection of the circle and line CD as F")
            pts = c['D'].intersect(l['CD'])
            p['F'] = EuclidPoint(pts[0], label_args=('F', RIGHT))

        @self.push_step
        def _8():
            t1.explain("Line AB is equal to line CF")
            with self.simultaneous():
                c['D'].e_fade()
                l['AC'].e_fade()
                t[1].e_fade()
                l['CD'].e_fade()
                l['AD'].e_fade()
            l['CF'] = EuclidLine(C, p['F'])

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
                l['CD'].e_normal()
                l['AD'].e_normal()
                l['AB'].e_fade()
                p['E'].e_remove()
                p['F'].e_remove()
                l['CF'].e_remove()

            t1.explain("Line AD is equal to line DC (equilateral triangle)")
            l['CD'].add_label("x", outside=True)
            l['AD'].add_label("x", outside=True)
            t2.math("AD = DC = x")

        @self.push_step
        def _11():
            with self.simultaneous():
                l['AD'].green()
                l['AC'].e_fade()
                l['CD'].green()
                c['D'].e_normal()

            t1.explain("DE and DF are equal (radii of the same circle)")
            with self.simultaneous():
                p['E'].e_draw()
                p['F'].e_draw()
            with self.simultaneous():
                l['DE'] = EuclidLine(p['D'], p['E'], label_args=('y', dict(inside=True)))
                l['DF'] = EuclidLine(p['D'], p['F'], label_args=('y', dict(outside=True)))
            t2.math("DE = DF = y")

        @self.push_step
        def _12():
            with self.simultaneous():
                c['D'].e_fade()
                if 'AE' in l:
                    l['AE'].e_remove()
                l['CD'].e_fade()
                l['AD'].e_fade()
                l['DE'].e_fade()

            t1.explain("AE is the difference between DA and DE")
            l['AE'] = EuclidLine(A, p['E'], label_args=('x-y', dict(align=RIGHT, inside=True)))
            t2.math("AE = DA - DE")
            t2.math("AE = x  - y")

        @self.push_step
        def _13():
            with self.simultaneous():
                c['D'].e_fade()
                if l['CF'].in_scene():
                    l['CF'].e_remove()
                l['CD'].e_fade()
                l['DF'].e_fade()

            t1.explain("CF is the difference between DC and DF")
            l['CF'] = EuclidLine(C, p['F'], label_args=('x-y', dict(align=LEFT, outside=True)))
            t2.math("CF = DC - DF")
            t2.math("CF = x  - y")

        @self.push_step
        def _14():
            with self.simultaneous():
                l['AD'].e_fade()
                l['CD'].e_fade()
                l['DE'].e_fade()
                l['DF'].e_fade()

            t1.explain(
                "AE and FC are the differences of equals, "
                "so they are equal")
            with self.simultaneous():
                l['AE'].add_label('z', inside=True)
                l['CF'].add_label('z', outside=True)
            t2.math("AE = CF = z")

        @self.push_step
        def _15():
            with self.simultaneous():
                c['A'].e_normal()
                l['AB'].e_normal()
                l['AD'].e_fade()
                l['CD'].e_fade()
                l['CF'].e_fade()

            t1.explain("AB and AE are radii of the same circle")
            l['AB'].add_label('z', outside=True)
            t2.math("AB = AE = z")

        @self.push_step
        def _16():
            with self.simultaneous():
                c['A'].e_fade()
                l['AD'].e_fade()
                l['AE'].e_fade()
                l['CF'].e_normal()

            t1.explain("AB and CF are equal")
            t2.math("AB = CF = z")

        # ------------------------------------------------------------------------
        # clean and do second construction
        # ------------------------------------------------------------------------
        @self.push_step
        def _17():
            with self.simultaneous(run_time=1):
                t1.e_remove()
                t2.e_remove()
                for group in (p, l, c, t):
                    for obj in group.values():
                        obj.e_remove()
                    group.clear()

            t3.title("But what if?")
            t3.explain("Start with line segment AB and point C")
            p['A'] = EuclidPoint(A, label_args=('A', dict(away_from=B)))
            p['B'] = EuclidPoint(C, label_args=('B', dict(away_from=A)))
            l['AB'] = EuclidLine(p['A'], p['B'], stroke_color=BLUE)
            p['C'] = EuclidPoint(D, label_args=('C', dict(away_from=A)))

        @self.push_step
        def _18():
            t3.explain("Construct line segment AC")
            l['AC'] = EuclidLine(A, D)

        @self.push_step
        def _19():
            t3.explain("Construct an equilateral triangle on line AC")
            t[2] = EquilateralTriangle.build(A, D)
            p['D'] = t[2].p[-1]
            with self.simultaneous():
                l['AD'] = t[2].l[2]
                l['CD'] = t[2].l[1]
                p['D'].add_label('D', away_from=t[2].get_center_of_mass())

        @self.push_step
        def _20():
            t3.explain("Draw a circle with A as the center and AB as the radius")
            c['A'] = EuclidCircle(A, C)

        @self.push_step
        def _21():
            t3.explain("Label the intersection of the circle and line AD as E ")
            t3.explain("  ...hang on... there isn't any intersection point, what now?")

        @self.push_step
        def _22():
            t3.explain("Extend DA and DC such that they intersect the circle")
            l['AD'].extend(mn_scale(400))
            l['CD'].prepend(mn_scale(400))

        @self.push_step
        def _23():
            t3.explain("Label the intersection of the circle and line AD as E")
            pts = c['A'].intersect(l['AD'])
            p['E'] = EuclidPoint(pts[0], label_args=('E', RIGHT))

        @self.push_step
        def _24():
            c['A'].e_fade()
            t3.explain("Draw a circle with D as the center and ED as the radius")
            c['D'] = EuclidCircle(p['D'], p['E'])

        @self.push_step
        def _25():
            t3.explain("Label the intersection of the circle and line CD as F")
            pts = c['D'].intersect(l['CD'])
            p['F'] = EuclidPoint(pts[0], label_args=('F', RIGHT))

        @self.push_step
        def _26():
            with self.simultaneous():
                c['D'].e_fade()
                t[2].e_fade()
                l['AC'].e_fade()
                l['CD'].e_fade()
                l['AD'].e_fade()

            t3.explain("Line AB is equal to line CF")
            l['CF'] = EuclidLine(D, p['F'])

        # ------------------------------------------------------------------------
        # Proof
        # ------------------------------------------------------------------------

        @self.push_step
        def _27():
            t3.down()
            t3.title("Proof:")

        @self.push_step
        def _28():
            t3.explain("... I will leave it to the reader to prove ...")

        @self.push_step
        def _29():
            with self.simultaneous():
                t3.e_remove()
            with self.simultaneous():
                for group in (p, l, c, t):
                    for obj in group.values():
                        obj.e_remove()
                    group.clear()
