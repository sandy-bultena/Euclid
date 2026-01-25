import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop19(Book1Scene):
    steps = []
    title = "A greater angle of a triangle is opposite a greater side."

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(475, 430))
        t3 = TextBox(mn_coord(300, 250))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
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
        t1.title("In other words:")
        t1.explain("Given a triangle ABC")
        t['ABC'] = ETriangle(A,B,C,
                             point_labels='ABC',
                             labels='cab',
                             angles=r'\alpha \beta \gamma'.split()
                             )
        t2.math(r'\beta > \alpha\ \text{and} \ \beta > \gamma', fill_color=BLUE)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("If angle ABC is greater than angle BCA and CAB, "
                   "then the side AC is greater than the other two sides of the triangle")
        t2.math(r'\implies b > a \ \text{and} \ b > c', align_str=r'\text{and}')

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------

        t1.title("Proof by contradiction")
        t1.explain("Without loss of generality")
        t1.explain("If AC is not greater than AB, "
                   "then it must be less than or equal to AB")
        t2.delete_last()
        t2.math(r'AC \le AB')
        t1.down()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("If line AC equals AB, then the triangle would be "
                   "an isosceles triangle, where angle ABC equals angle ACB (I.5)")
        t2.indent(MED_LARGE_BUFF)
        t['ABC'].move_point_to(0, E)
        t2.math('AC = AB')
        t2.math(r'\implies \beta = \gamma')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("But we have already stated that angle ABC "
                   "is greater than angle BCA, so we have a contradiction")
        self.play(mn.Indicate(t2[-1][r'\beta = \gamma'], color=RED))
        self.play(mn.Indicate(t2[0][r'\beta > \gamma'], color=RED))
        with self.simultaneous():
            t2.e_append_morph(-1, r'\ \ecrossmark', RED)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Because we have a contradiction, "
                   "the original assumption that AC equals AB cannot be true")
        with self.simultaneous():
            t2.e_update(
                -2,
                r'AC \neq AB',
                transform_args={'matched_keys': ['AC', 'AB'], 'key_map': {'=': r'\neq'}}
            )
            t2.delete_last()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("If line AC is less than AB, then by the previous "
                   "proposition, angle BCA would be larger than angle ABC (I.18)")

        with self.simultaneous():
            t2.e_fade[-1:]()
        t['ABC'].move_point_to(0, F)
        t2.math(r'AC < AB')
        t2.math(r'\implies \beta < \gamma')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("But we have already stated that angle ABC "
                   "is greater than angle BCA, so we have a contradiction")
        self.play(mn.Indicate(t2[-1][r'\beta < \gamma'], color=RED))
        self.play(mn.Indicate(t2[0][r'\beta > \gamma'], color=RED))
        with self.simultaneous():
            t2.e_append_morph(-1, r'\ \ecrossmark', RED)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Because we have a contradiction, "
                   "the original assumption that AC is less than AB cannot be true")
        with self.simultaneous():
            t2.e_update(
                -2,
                r'AC \nless AB',
                transform_args={'matched_keys': ['AC', 'AB'], 'key_map': {'<': r'\nless'}}
            )
            t2.delete_last()


        self.next_page()

        # ------------------------------------------------------------------------
        t['ABC'].move_point_to(0, A)
        with self.simultaneous():
            t2[-2].e_normal()
        self.play(mn.Indicate(t2[1], color=RED))
        with self.simultaneous():
            self.play(mn.Indicate(t2[-2], color=RED))
            self.play(mn.Indicate(t2[-1], color=RED))


        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Therefore, AC is greater than AB")
        with self.simultaneous():
            t2.e_update(
                1,
                r'\therefore\ AC > AB',
                transform_args={'matched_keys': ['AC', 'AB'], 'key_map': {r'\le': '>'}}
            )
            t2.e_fade[2:]()
