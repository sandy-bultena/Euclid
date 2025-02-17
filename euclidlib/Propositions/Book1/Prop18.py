import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop18(Book1Scene):
    steps = []
    title = "A greater side of a triangle is opposite a greater angle."

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 430))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(75, 150)
        B = mn_coord(100, 400)
        C = mn_coord(350, 400)
        D = mn_coord(450, 450)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            nonlocal A, B, C
            t1.title("In other words:")
            t1.explain("Given a triangle ABC")
            t['ABC'] = EuclidTriangle(
                'ABC',
                point_labels='ABC',
                angles=r'\alpha \beta \gamma'.split(),
                angle_sizes=[None, 60, None],
                labels=[None, 'x', 'y']
            )
            self.extract_all(l, p, a, t, 'ABC')
            a['a'] = a['CAB']
            a['b'] = a['ABC']
            a['g'] = a['BCA']

        @self.push_step
        def _i2():
            t1.explain("If line AC is greater than BC, "
                       "then angle ABC is greater than BAC")
            t2.math(r'y > x\ \Rightarrow\ \beta > \alpha')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t2.down()
            t2.math(r'AC > BC', fill_color=BLUE)
            t1.down()
            t1.title("Proof:")

        @self.push_step
        def _p2():
            t1.explain("Create point D on line AC, such that CD equals BC")
            c['C'] = EuclidCircle(C, B)
            pts = c['C'].intersect(l['CA'])
            p['D'] = EuclidPoint(pts[0], label=('D', l['CA'].OUT()))
            c['C'].e_remove()
            l['CD'], l['AD'] = l['CA'].e_split(p['D'])
            with self.simultaneous():
                l['CD'].add_label('x', outside=True)
                l['CA'].remove_label()
            t2.math('DC = BC')

        @self.push_step
        def _p3():
            nonlocal p
            t1.explain("Create line BD")
            t1.explain("The angle CDB is an exterior angle to triangle ADB, "
                       "thus angle CDB is greater than angle DAB (I.16)")

            with self.simultaneous():
                a['ABC'].e_fade()
                a['BCA'].e_fade()

            l['BD'] = EuclidLine('BD')
            t['ABD'] = EuclidTriangle.assemble(
                lines=[l['AB'], l['BD'], l['AD']],
                angles=[a['a'], None, None]
            )

            t['DBC'] = EuclidTriangle.assemble(
                lines=[l['BD'], l['BC'], l['CD']],
                angles=[None, None, a['BCA']]
            )

            t['DBC'].set_angles(r'\theta', None, None)
            a['th'] = t['DBC'].a[0]

            with self.simultaneous():
                t['DBC'].e_fade()
                t['ABC'].e_fade()
                t['ABD'].e_normal()
                a['th'].e_normal()
                a['a'].e_normal()
                p['A'].e_normal()
                p['B'].e_normal()
                l['CD'].e_normal()
                p['C'].e_normal()

            t['ABD'].e_fill(BLUE_D)
            t2.math(r'\theta > \alpha')

        @self.push_step
        def _p4():
            nonlocal p
            t1.explain("The triangle BCD is an isosceles triangle, "
                       "thus angles CDB and DBC are equal (I.5)")
            with self.simultaneous():
                t['ABD'].e_fade()
                t['DBC'].e_normal()
                t['ABD'].a[0].e_normal()
                a['a'].e_fade()
                p['A'].e_fade()
            t['DBC'].set_angles(None, r'\theta', None, 0, mn_scale(15), 0)
            with self.simultaneous():
                t['DBC'].e_fill(GREEN_E)

        @self.push_step
        def _p5():
            t1.explain("Angle ABC is greater than angle DBC, "
                       "so angle ABC is greater than angle BAC")
            t['DBC'].e_unfill()
            with self.simultaneous():
                t['ABC'].a[1].e_normal()
                p['A'].e_normal()
                a['a'].e_normal()
                l['AB'].e_normal()
                l['AD'].e_normal()
                a['g'].e_fade()
            t2.math(r'\beta > \theta > \alpha')

        @self.push_step
        def _p5():
            with self.simultaneous():
                t['ABD'].e_remove()
                t['DBC'].e_remove()
                p['D'].e_remove()
                a['a'].e_remove()
                a['b'].e_remove()
                a['g'].e_remove()
                # l['BC'].remove_label()
            with self.skip_animations_for():
                t['ABC'].e_normal()
                l['CA'].add_label('y', outside=True)
            with self.simultaneous():
                with self.freeze(a['g']):
                    t['ABC'].e_draw()
            with self.simultaneous():
                t2.e_fade[2:]()
            t2.down()
            t2.math(r'\therefore \angle{ABC} > \angle{BAC}')
