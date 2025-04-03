import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop44(Book1Scene):
    steps = []
    title = ("To a given straight line in a given rectilinear angle, "
             "to apply a parallelogram equal to a given triangle.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(525, 175))
        t3 = TextBox(mn_coord(525, 200))
        t4 = TextBox(mn_coord(825, 150), line_width=mn_h_scale(455))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        top = 100
        bot = 300
        C_right = 150
        C_left = 125
        C_far = C_left + 300

        C1 = mn_coord(C_right, top)
        C2 = mn_coord(C_left, bot)
        C3 = mn_coord(C_left + 300, bot)

        A = mn_coord(C_right + 50, bot + 375)
        B = mn_coord(C_right + 100, bot + 300)

        D1 = mn_coord(C_far - 75, (bot + top) / 1.75)
        D2 = D1 + mn_scale(100, 0, 0)
        D3 = D1 + mn_scale(150, 125, 0)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t1.title("In other words:")
            t1.explainM("Start with a given triangle C, a straight line AB and "
                        r"an angle $\delta$")
            t['C'] = ETriangle(C1, C2, C3)
            t['C'].l[1].add_label('C', outside=True)
            t['C'].e_fill(BLUE_D)

            p['A'] = EPoint(A, label=('A', dict(away_from=B)))
            p['B'] = EPoint(B, label=('B', dict(away_from=A)))

            l['AB'] = ELine(A, B)
            l['D12'] = ELine(D1, D2)
            l['D23'] = ELine(D2, D3)

            a['D'] = EAngle(l['D23'], l['D12'], label=r'\delta')

        @self.push_step
        def _i2():
            t1.explainM(r"Create a parallelogram, on the line AB, with an angle $\delta$, "
                        "such that it is equal in area to the triangle C")
            with self.pause_animations_for():
                s['x'] = t['C'].copy_to_parallelogram_on_line(l['AB'], a['D'])
            s['x'].e_draw()
            s['x'].e_fill(BLUE_D)
            s['x'].set_angles(None, r'\delta')
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
