import sys
import os
from cProfile import label

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop17(Book1Scene):
    steps = []
    title = "Any two angles of a triangle are together less than two right angles."

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(500, 430))

        l: Dict[str | int, ELine] = self.l
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(150, 200)
        B = mn_coord(100, 450)
        C = mn_coord(350, 450)
        D = mn_coord(450, 450)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Given any triangle ABC")

        t['ABC'] = ETriangle(A,B,C, point_labels='ABC')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("The sum of any of the two inner angles "
                   "is less than two right angles")

        t['ABC'].set_angles(*r'\beta \gamma \theta'.split(' '))
        t2.math(r'\theta + \gamma < 2\ \rightangle ')
        t2.math(r'\theta + \beta < 2\ \rightangle', align_str='<')
        t2.math(r'\gamma + \beta < 2\ \rightangle', align_str='<')

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t1.down()
        with self.simultaneous():
            t2.e_remove()
        t1.title("Proof:")
        t1.explain("Extend line BC to point D")

        l['CD'] = ELine(C,D)
        l['AC'] = t['ABC'].l[2]
        p['D'] = EPoint(D, label=('D', dict(away_from=C)))
        a['ACD'] = EAngle(*self.lines('ACD'), size=mn_scale(20), label=r'\alpha')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("The sum of the angles ACB and ACD is equal to two right angles (I.13)")
        t2.math(r'\alpha + \theta = 2\ \rightangle')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("The angle ACD is greater than either angle ABC or {nb:CAB (I.16)")
        t1.explain("Therefore the sum of either ABC or CAB with angle ACB will be "
                   "less than 2 right angles")
        t2.math(r'\beta < \alpha \quad \therefore\  \beta + \theta < \alpha + \theta')
        t2.math(r'\gamma < \alpha \quad \therefore\  \gamma + \theta < \alpha + \theta')
        t2.down()
        t2.math(r'\beta + \theta < 2\ \rightangle')
        t2.math(r'\gamma + \theta < 2\ \rightangle')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.down()
        t1.explain("The same logic can be applied to the "
                   "other vertices of the triangle")
        t2.down()
        t2.math(r'\beta + \gamma < 2\ \rightangle')
