import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Objects import *
from euclidlib.Objects import EquilateralTriangle
from typing import Dict


class Book1Prop2(PropScene):
    steps = []
    def define_steps(self):
        t1 = TextBox(self, absolute_position=to_manim_coord(800, 150), line_width=to_manim_h_scale(550))
        t2 = TextBox(self, absolute_position=to_manim_coord(580, 430), line_width=to_manim_h_scale(500))
        t3 = TextBox(self, absolute_position=to_manim_coord(800, 150), line_width=to_manim_h_scale(500))
        A = to_manim_coord(200, 500)
        B = to_manim_coord(300, 500)
        C = to_manim_coord(450, 400)
        D = to_manim_coord(250, 400)
        
        l: Dict[str|int, EuclidLine] = {}
        p: Dict[str|int, EuclidPoint] = {}
        c: Dict[str|int, EuclidCircle] = {}
        t: Dict[str|int, EuclidTriangle] = {}

        # ------------------------------------------------------------------------
        # Construction
        # ------------------------------------------------------------------------
        @self.push_step
        def _1():
            t1.title("Construction:")
            t1.explain("Start with line segment AB and Point C")

            p['A'] = EuclidPoint(A, scene=self, label='A', label_dir=LEFT)
            p['B'] = EuclidPoint(B, scene=self, label='B', label_dir=RIGHT)
            l['AB'] = EuclidLine(p['A'], p['B'], scene=self, stroke_color=BLUE)
            p['C'] = EuclidPoint(C, scene=self, label='C', label_dir=DOWN)

        @self.push_step
        def _2():
            t1.explain("Construct line segment AC")
            l['AC'] = EuclidLine(p['A'], p['C'], scene=self)

        @self.push_step
        def _3():
            t1.explain("Construct an equilateral triangle on line AC <sub>(I.1)</sub>")
            t[1], p['D'] = EquilateralTriangle.build(self, A, C, 3)
            with self.animation_speed(3):
                with self.simultaneous():
                    l['AD'] = t[1].l[2]
                    l['CD'] = t[1].l[1]
            p['D'].add_label('D', UP)

        @self.push_step
        def _4():
            t1.explain("Draw a circle with A as the center and AB as the radius")
            c['A'] = EuclidCircle(A, B, scene=self)

        @self.push_step
        def _5():
            t1.explain("Label the intersection of the circle and line AD as E")
            pts = c['A'].intersect(l['AD'])
            p['E'] = EuclidPoint(pts[0], scene=self, label='E', label_dir=UL)

        @self.push_step
        def _6():
            t1.explain("Draw a circle with D as the center and ED as the radius")
            c['A'].e_fade()
            c['D'] = EuclidCircle(p['D'], p['E'], scene=self)

        @self.push_step
        def _7():
            t1.explain("Label the intersection of the circle and line CD as F")
            pts = c['D'].intersect(l['CD'])
            p['F'] = EuclidPoint(pts[0], scene=self, label='F', label_dir=RIGHT)

        @self.push_step
        def _8():
            t1.explain("Line AB is equal to line CF")
            with self.simultaneous():
                c['D'].e_fade()
                l['AC'].e_fade()
                t[1].e_fade()
                l['CD'].e_fade()
                l['AD'].e_fade()
            l['CF'] = EuclidLine(C, p['F'], scene=self)

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
            l['CD'].add_label("x", LEFT)
            l['AD'].add_label("x", RIGHT)
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
                l['DE'] = EuclidLine(p['D'], p['E'], label='y', label_dir=LEFT, scene=self)
                l['DF'] = EuclidLine(p['D'], p['F'], label='y', label_dir=RIGHT, scene=self)
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
            l['AE'] = EuclidLine(A, p['E'], scene=self, label='x-y', label_dir=LEFT)
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
            l['CF'] = EuclidLine(C, p['F'], scene=self, label='x-y', label_dir=RIGHT)
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
                l['AE'].add_label('z', LEFT)
                l['CF'].add_label('z', RIGHT)
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
            l['AB'].add_label('z', DOWN)
            t2.math("AB = AE = z")

        @self.push_step
        def _16():
            with self.simultaneous():
                c['A'].e_fade()
                l['AD'].e_fade()
                l['AE'].e_fade()
                l['CF'].e_normal()

            t1.explain("AB and CF are equal")
            l['AB'].add_label('z', DOWN)
            t2.math("AB = CF = z")

        # ------------------------------------------------------------------------
        # clean and do second construction
        # ------------------------------------------------------------------------
        @self.push_step
        def _17():
            with self.simultaneous():
                t1.delete()
                t2.delete()
            with self.simultaneous():
                for group in (p, l, c, t):
                    for obj in group.values():
                        obj.e_remove()
                    group.clear()

            t3.title("But what if?")
            t3.explain("Start with line segment AB and point C")
            p['A'] = EuclidPoint(A, scene=self, label='A', label_dir=LEFT)
            p['B'] = EuclidPoint(C, scene=self, label='B', label_dir=RIGHT)
            l['AB'] = EuclidLine(p['A'], p['B'], scene=self, stroke_color=BLUE)
            p['C'] = EuclidPoint(D, scene=self, label='C', label_dir=DOWN)

        @self.push_step
        def _18():
            t3.explain("Construct line segment AC")
            l['AC'] = EuclidLine(A, D, scene=self)

        @self.push_step
        def _19():
            t3.explain("Construct an equilateral triangle on line AC")
            t[2], p['D'] = EquilateralTriangle.build(self, A, D)
            with self.simultaneous():
                l['AD'] = t[2].l[2]
                l['CD'] = t[2].l[1]
                p['D'].add_label('D', UP)

        @self.push_step
        def _20():
            t3.explain("Draw a circle with A as the center and AB as the radius")
            c['A'] = EuclidCircle(A, C, scene=self)

        @self.push_step
        def _21():
            t3.explain("Label the intersection of the circle and line AD as E ")
            t3.explain("  ...hang on... there isn't any intersection point, what now?")

        @self.push_step
        def _22():
            t3.explain("Extend DA and DC such that they intersect the circle")
            l['AD'].extend(to_manim_v_scale(400))
            l['CD'].prepend(to_manim_v_scale(400))

        @self.push_step
        def _23():
            t3.explain("Label the intersection of the circle and line AD as E")
            pts = c['A'].intersect(l['AD'])
            p['E'] = EuclidPoint(pts[0], scene=self, label='E', label_dir=RIGHT)

        @self.push_step
        def _24():
            c['A'].e_fade()
            t3.explain("Draw a circle with D as the center and ED as the radius")
            c['D'] = EuclidCircle(p['D'], p['E'], scene=self)

        @self.push_step
        def _25():
            t3.explain("Label the intersection of the circle and line CD as F")
            pts = c['D'].intersect(l['CD'])
            p['F'] = EuclidPoint(pts[0], scene=self, label='F', label_dir=RIGHT)

        @self.push_step
        def _26():
            with self.simultaneous():
                c['D'].e_fade()
                t[2].e_fade()
                l['AC'].e_fade()
                l['CD'].e_fade()
                l['AD'].e_fade()

            t3.explain("Line AB is equal to line CF")
            l['CF'] = EuclidLine(D, p['F'], scene=self)

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
                t3.delete()
            with self.simultaneous():
                for group in (p, l, c, t):
                    for obj in group.values():
                        obj.e_remove()
                    group.clear()






