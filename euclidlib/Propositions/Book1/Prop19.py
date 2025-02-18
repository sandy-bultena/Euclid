import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop19(Book1Scene):
    steps = []
    title = "A greater angle of a triangle is opposite a greater side."

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 430))
        t3 = TextBox(mn_coord(300, 250))

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

        E = mn_coord((100 + 350) / 2, 150)
        F = mn_coord(275, 150)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            nonlocal A, B, C
            t1.title("In other words:")
            t1.explain("Given a triangle ABC")
            t['ABC'] = EuclidTriangle('ABC',
                                      point_labels='ABC',
                                      labels='cab',
                                      angles=r'\alpha \beta \gamma'.split()
                                      )
            t2.math(r'\beta > \alpha\ \land \ \beta > \gamma', fill_color=BLUE)

        @self.push_step
        def _i2():
            t1.explain("If angle ABC is greater than angle BCA and CAB, "
                       "then the side AC is greater than the other two sides of the triangle")
            t2.math(r'\implies b > a \ \land \ b > c', align_str=r'\land')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t2.delete_last()
            t1.down()
            t1.title("Proof by contradiction")
            t1.explain("Without loss of generality")
            t1.explain("If AC is not greater than AB, "
                       "then it must be less than or equal to AB")
            t2.math(r'AC \le AB')

        @self.push_step
        def _p2():
            t1.explain("If line AC equals AB, then the triangle would be "
                       "an isosceles triangle, where angle ABC equals angle ACB (I.5)")
            t2.indent(MED_LARGE_BUFF)
            t['ABC'].move_point_to(0, E)
            t2.math('AC = AB')
            t2.math(r'\implies \beta = \gamma')

        @self.push_step
        def _p3():
            t1.explain("But we have already stated that angle ABC "
                       "is greater than angle BCA, so we have a contradiction")
            self.play(mn.Indicate(t2[-1][r'\beta = \gamma'], color=RED))
            self.play(mn.Indicate(t2[0][r'\beta > \gamma'], color=RED))
            with self.simultaneous():
                t2.e_append_morph(-1, r'\ \ecrossmark', RED)

        @self.push_step
        def _p4():
            t1.explain("Because we have a contradiction, "
                       "the original assumption that AC equals AB cannot be true")
            with self.simultaneous():
                t2.e_update(
                    -2,
                    r'AC \neq AB',
                    transform_args={'matched_keys': ['AC', 'AB'], 'key_map': {'=': r'\neq'}}
                )
                t2.delete_last()

        @self.push_step
        def _p5():
            t1.explain("If line AC is less than AB, then by the previous "
                       "proposition, angle BCA would be larger than angle ABC (I.18)")

            with self.simultaneous():
                t2.e_fade[-1:]()
            t['ABC'].move_point_to(0, F)
            t2.math(r'AC < AB')
            t2.math(r'\implies \beta < \gamma')

        @self.push_step
        def _p6():
            t1.explain("But we have already stated that angle ABC "
                       "is greater than angle BCA, so we have a contradiction")
            self.play(mn.Indicate(t2[-1][r'\beta < \gamma'], color=RED))
            self.play(mn.Indicate(t2[0][r'\beta > \gamma'], color=RED))
            with self.simultaneous():
                t2.e_append_morph(-1, r'\ \ecrossmark', RED)

        @self.push_step
        def _p7():
            t1.explain("Because we have a contradiction, "
                       "the original assumption that AC is less than AB cannot be true")
            with self.simultaneous():
                t2.e_update(
                    -2,
                    r'AC \nless AB',
                    transform_args={'matched_keys': ['AC', 'AB'], 'key_map': {'<': r'\nless'}}
                )
                t2.delete_last()


        @self.push_step
        def _p8():
            t['ABC'].move_point_to(0, A)
            with self.simultaneous():
                t2[-2].e_normal()
            self.play(mn.Indicate(t2[1], color=RED))
            with self.simultaneous():
                self.play(mn.Indicate(t2[-2], color=RED))
                self.play(mn.Indicate(t2[-1], color=RED))


        @self.push_step
        def _p9():
            t1.explain("Therefore, AC is greater than AB")
            with self.simultaneous():
                t2.e_update(
                    1,
                    r'\therefore\ AC > AB',
                    transform_args={'matched_keys': ['AC', 'AB'], 'key_map': {r'\le': '>'}}
                )
                t2.e_fade[2:]()
