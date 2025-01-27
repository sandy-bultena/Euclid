import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop06(Book1Scene):
    steps = []
    title = "If two angles of a triangle are equal, then the sides opposite them will be equal."

    def define_steps(self):
        t1 = TextBox(absolute_position=mn_coord(800, 150), line_width=to_manim_h_scale(550))
        t2 = TextBox(absolute_position=mn_coord(450, 330))
        t4 = TextBox(absolute_position=mn_coord(450, 330))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngle] = {}

        A = mn_coord(225, 250)
        B = mn_coord(425, 450)
        C = mn_coord(75, 450)
        mid = (B[0] + C[0]) / 2

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            nonlocal A, B, C
            t1.title("In other words:")
            t1.explain("Start with a triangle with equal base angles")
            # with self.simultaneous():
            t['ABC'] = EuclidTriangle('ABC',
                                      point_labels=['A', ('B', RIGHT), ('C', LEFT)],
                                      angles=[None, r'\alpha', r'\alpha']
                                      )
            t2.math(r'\angle ACB = \angle ABC', fill_color=BLUE)

        @self.push_step
        def _i2():
            t1.explain("Then the sides opposite the equal angles are equal")
            t['ABC'].set_labels(('r', dict(outside=True)), (), ('r', dict(outside=True)))

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t2.e_remove()
            t1.down()
            t1.title("Proof By Contradiction")
            t1.explain("Assume that the sides are not equal, and "
                       "demonstrate that this leads to a logical inconsistency")

            t['ABC'].set_labels(('r_2', dict(outside=True)), (), ('r_1', dict(outside=True))).e_fill(BLUE_D)
            t2.math(r'\angle ACB = \angle ABC', fill_color=BLUE)
            t4.set_y(t2[-1].get_top()[1])
            t2.math(r"AB > AC\quad(r_2 > r_1)")

        @self.push_step
        def _p2():
            t1.explain("Use the method from Propositions 2 and 3 to find a "
                       "point D such that BD equals AC")
            l['BD'], p['D'] = t['ABC'].l[-1].copy_to_line(B, t['ABC'].l[0])
            p['D'].add_label('D', RIGHT)
            l['BD'].add_label('r_1', outside=True)
            with self.simultaneous():
                t2.math(r'BD = AC = r_1').shift(RIGHT * 0.5)

        @self.push_step
        def _p3():
            nonlocal B, C, p
            t1.explain("Create a triangle DCB")
            t['BCD'] = EuclidTriangle('BCD',
                                      point_labels=[('B', RIGHT),
                                                    ('C', LEFT),
                                                    ()],
                                      ).e_fill(TEAL_D)
            t['BCD'].replace_point(-1, p['D'])
            t['BCD'].replace_line(-1, l['BD'])
            p['D'].add_label('D', away_from=t['BCD'].get_center)

        @self.push_step
        def _p4():
            t1.explain("Let's move DCB to a different spot so we can see more clearly")

            with self.simultaneous():
                t['ABC'].set_labels((), 'r_3', ())
                t['BCD'].set_labels(('r_3', dict(inside=True)), (), ())

            with self.simultaneous(run_time=1):
                t['BCD'].e_move(mn_scale(150, -250, 0))()

            with self.simultaneous():
                t['BCD'].set_angles(r'\alpha', None, None)

            t['BCD'].e_fill(GREEN_D)

        @self.push_step
        def _p5():
            t1.explain("Since two sides and the angle between are "
                       "the same for both triangles, then "
                       "all the sides and angles are {nb:equal <sub>(I.4)</sub>}")

            with self.simultaneous():
                t['ABC'].l[0].e_fade()
                t['BCD'].l[1].e_fade()

            t2.down()
            t2.e_fade(*t2.except_index(2, 3, 5))
            with self.simultaneous():
                t2.math(r"BD = r_1\ \angle DBC=\alpha\ BC=r_3").shift(RIGHT / 2)
            with self.simultaneous():
                t2.math(r"AC=r_1\ \angle ACB=\alpha\ BC=r_3").shift(RIGHT / 2)

        @self.push_step
        def _p6():
            with self.simultaneous():
                t['ABC'].l[0].e_normal()
                t['BCD'].l[1].e_normal()
            t['BCD'].set_angles(None, r'\alpha', None, 0, mn_scale(70), 0)

            with self.simultaneous():
                t2.math(r"\therefore \angle DCB = \angle ABC = \alpha").shift(RIGHT / 2)

        @self.push_step
        def _p7():
            with self.simultaneous(run_time=1):
                t['BCD'].e_move(mn_scale(-150, 250, 0))()
            t['BCD'].e_fill(TEAL_D)

            with self.simultaneous():
                for x in t['ABC'].l + t['BCD'].l:
                    x.remove_label()
            with self.simultaneous():
                for x in t['ABC'].p[1:]:
                    x.e_remove()

        @self.push_step
        def _p8():
            a['ACD'] = EuclidAngle(t['BCD'].l[1], t['ABC'].l[2], size=mn_scale(120), label=r'\beta')
            t2.e_fade()
            with self.simultaneous():
                t2.explainM(r'let $\angle ACD = \beta$')
            t2.math(r'\Rightarrow \beta + \alpha = \alpha')

        @self.push_step
        def _p9():
            t1.down()
            t1.explainM(r"We now have an angle $\alpha$ which is equal to $\alpha$ "
                        r"plus $\beta$")
            t1.explain(r"This leaves us with a violation of the common notion{nb}5 that "
                       "the while is greater than the part")
            t1.explainM(r"... unless $\beta$ is zero!")
            t2.e_append(
                -1,
                r'\ecrossmark',
                fill_color=RED
            )

        @self.push_step
        def _p10():
            t1.down()
            t1.explain("This implies that D is concurrent with A, and that "
                       "the two sides of the triangle are equal")

            a['ACD'].e_remove()
            with self.simultaneous():
                t['ABC'].p[0].add_label('A', away_from=B)
                t['BCD'].p[-1].add_label('D', away_from=C)

            t['ABC'].move_point_to(0, t['BCD'].p[-1])
            t['BCD'].set_labels((), ('r', dict(inside=True)), 'r')

            with self.simultaneous():
                t2.e_fade(*t2.except_index(0))
                t2.blue(0)

            t2.math('A = D')
            t2.math('AC = DB = r')
