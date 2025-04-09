import sys
import os
from typing import cast

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop45(Book1Scene):
    steps = []
    title = "To construct a parallelogram equal to a given rectilinear figure in a given rectilinear angle."

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 200))
        t3 = TextBox(mn_coord(475, 525))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        top = 125
        bot = 325

        A_base = np.array([75, top + 30, 0.0])
        A = mn_coord(*A_base)
        B = mn_coord(300, bot)
        C = mn_coord(425, top + 70)
        D = mn_coord(275, top)
        K = mn_coord(400, 700)

        E1_base = A_base + np.array([10, 300, 0])
        E1 = mn_coord(*E1_base)
        E2 = mn_coord(*(E1_base + np.array([100, 0, 0])))
        E3 = mn_coord(*(E1_base + np.array([150, -125, 0])))

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t1.title("In other words:")
            t1.explainM("Start with a given rectilinear figure ABCD and a "
                       r"given angle $\epsilon$")
            s['ABCD'] = EPolygon(A, B, C, D, point_labels='ABCD')
            l['E12'] = ELine(E1, E2)
            l['E23'] = ELine(E2, E3)
            a['E'] = EAngle(l['E23'], l['E12'], label=r'\epsilon')
            s['ABCD'].e_fill(BLUE_D)

        @self.push_step
        def _i1():
            t1.explainM(r"Create a parallelogram with an angle $\epsilon$, "
                       "such that it is equal in area to the polygon ABCD")
            p['x'] = EPoint(K)
            with self.skip_animations_for(False):
                s['x'] = s['ABCD'].copy_to_parallelogram_on_point(p['x'], a['E'], negative=True, speed=1)
            s['x'].e_draw()
            s['x'].e_fill(BLUE_D)
            s['x'].set_angles(None, r'\epsilon')

        # ----------------------------------------------
        # Construction
        # ----------------------------------------------
        @self.push_step
        def _c1():
            t1.down()
            t1.title("Construction:")

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof:")
