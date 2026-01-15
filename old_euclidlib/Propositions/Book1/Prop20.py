import sys
import os
from itertools import permutations

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop20(Book1Scene):
    steps = []
    title = "Any two sides of a triangle are together greater than the third side."

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 430))
        t3 = TextBox(mn_coord(300, 250))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(250, 150)
        B = mn_coord(100, 350)
        C = mn_coord(350, 350)
        D = mn_coord(450, 350)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            nonlocal A, B, C
            t1.title("In other words:")
            t1.explain("Given a triangle ABC")
            t['ABC'] = ETriangle('ABC',
                                 point_labels='ABC',
                                 labels='cab',
                                 angles=r'\alpha \beta \gamma'.split()
                                 )

        @self.push_step
        def _i2():
            t1.explain("The sum of any two sides of the triangle is greater "
                       "than the third")
            with self.delayed(lag_ratio=0.1):
                strings = {'ABc', 'BCa', 'ACb'}
                for c in strings:
                    a, b = sorted(strings - {c})
                    t2.math(rf"{a[:2]} + {b[:2]} > {c[:2]}\quad({a[2]} + {b[2]} > {c[2]})")

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            with self.simultaneous():
                t2.e_remove()
            t1.down()
            t1.title("Proof:")
            t1.explain("Extend BC")
            x = t['ABC'].p[2].distance_to(A) + mn_scale(25)
            l['Bp'] = t['ABC'].l[1].extend_cpy(x)

        @self.push_step
        def _p2():
            t1.explain("Define point D, such that CD equals AC")
            t2.math(r"CD =\ AC")
            c['C'] = ECircle(C, A)
            pts = c['C'].intersect(l['Bp'])
            p['D'] = EPoint(pts[0], label=('D', DOWN))
            c['C'].e_remove()

            l['CD'], l['Dp'] = l['Bp'].e_split(p['D'])
            l['CD'].add_label('b', DOWN)

            with self.simultaneous():
                t['ABC'].l[0].e_fade()
                for angle in t['ABC'].a:
                    angle.e_fade()

            t2.math(r'BD =\ BC + CD')
            t2.math(r'BD =\ BC + AC')

        @self.push_step
        def _p3():
            t1.explain("Create line AD, making the triangle ACD an isosceles triangle, "
                       "thus the angles CAD and CDA are equal (I.5)")
            l['AD'] = ELine(A, p['D'])
            t['ACD'] = ETriangle.assemble(lines=[t['ABC'].l[2], l['CD'], l['AD']])
            with self.simultaneous():
                t['ACD'].set_angles(r'\theta', None, r'\theta', mn_scale(50), None, mn_scale(50))
            t['ACD'].e_fill(BLUE_D)

            with self.simultaneous():
                t2.e_fade()
            t2.math(r'\angle{CAD} = \angle{CDA} = \theta')
            t2.down()

        @self.push_step
        def _p4():
            t1.explain("Consider triangle ABD")
            with self.simultaneous():
                t['ACD'].e_unfill()
                t['ABC'].l[2].e_fade()
                t['ABC'].a[2].e_fade()
                t['ABC'].l[1].e_normal()
                t['ABC'].l[0].e_normal()
                t['ABC'].a[0].e_normal()
                t['ABC'].a[1].e_normal()
                t2.e_fade()

            t1.explain("Angle BAD is obviously larger than angle BDA, "
                       "thus length BD is larger than AB (I.18)")
            t2.math(r'\alpha + \theta > \theta')
            t2.math(r'\implies \angle{BAD} > \angle{BDA}')
            t2.math(r'\implies BD > AB')

        @self.push_step
        def _p5():
            t1.explain("But BD is the sum of BC and AC")
            with self.simultaneous(run_time=0.5):
                t2.e_fade()
                t2.e_normal(2, -1)

            self.wait(0.5)

            self.play(
                mn.Indicate(t2[2]),
                mn.Indicate(t2[-1]['BD']),
            )

            head = t2[2]
            tail = t2[-1]

            self.wait(0.5)

            ad, q, ab, eq['-1'] = t2.math(r'\therefore\ BC + AC > AB',
                                    break_into_parts=(r'\therefore', 'BC + AC', '> AB'),
                                    delay_anim=True)
            with self.simultaneous(run_time=1):
                ad.transform_from(tail, r'\implies')
                q.transform_from(head, 'BC + AC')
                ab.transform_from(tail, '> AB')

            with self.simultaneous(run_time=1):
                t['ABC'].l[2].e_normal()
                t['ABC'].a[2].e_normal()
                t['ACD'].l[2].e_fade()
                t['ACD'].a[0].e_remove()
                t['ACD'].a[2].e_remove()
                t['ACD'].p[0].e_remove()
                t['ACD'].p[1].e_remove()
                t['ACD'].p[2].e_remove()

        @self.push_step
        def _p6():
            t1.explain("Thus BD, one side of a triangle, is less than the sum "
                       "of the other two sides")
            with self.simultaneous():
                l['CD'].e_fade()
                l['Dp'].e_fade()
                p['D'].e_fade()
                t2.e_fade[0:-4]()

        @self.push_step
        def _p7():
            t1.explain("This procedure can be used on any side of the triangle, "
                       "hence the sum of two sides is always greater than the third")
