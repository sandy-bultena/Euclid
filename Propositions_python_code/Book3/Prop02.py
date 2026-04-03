import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.BookScene import Book3Scene, AttrDict
from euclidlib.Objects import *


class Prop2(Book3Scene):
    steps = []
    title = ("If on the circumference on a circle two points be taken at random, "
             "the straight line joining the points will fall within the circle.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(520, 200))
        t3 = TextBox(mn_coord(450, 200))

        l: dict[str | int, ELine] = {}
        p: dict[str | int, EPoint] = {}
        c: dict[str | int, AbstractArc] = {}
        t: dict[str | int, ETriangle] = {}
        s: dict[str | int, EPolygon] = {}
        a: dict[str | int, EAngleBase] = {}
        eq: dict[str | int, EStringObj] = {}
        ex: dict[str | int, mn.Mobject] = {}

        C = mn_coord(225, 350)
        r = mn_scale(180)
        DEG = mn.PI/180

        # -------------------------------------------------------------------------------------------------------------
        # In Other Words
        # -------------------------------------------------------------------------------------------------------------
        c['C'] = ECircle(C, C + r * RIGHT, label=('C', PI / 4))
        t1.title("In other words:")
        t1.explain("Let there be two points, A and B, randomly placed "
                   "on the circumference of the circle")
        with self.simultaneous():
            A = p['A'] = c['C'].e_point_at_angle(200 * DEG)
            B = p['B'] = c['C'].e_point_at_angle(270 * DEG)
        with self.simultaneous():
            p['A'].add_label('A', away_from=p['B'])
            p['B'].add_label('B', away_from=p['A'])

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("The straight line AB will fall within the circle ")
        l['AB'] = ELine(A,B)

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.down()
        t1.title("Proof by contradiction:")

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        l['AB'].e_remove()
        t1.explain("Let E be a point on the straight line AB, "
                   "and let it be outside of the circle")
        c['AB'] = EArc(r / 1.7, p['A'], p['B'])
        E = p['E'] = c['AB'].e_point_at_angle(235 * DEG).add_label('E', DOWN)

        aside = TextBox(p['E'].get_center() + mn_scale(*50 * DOWN))
        aside.sidenote("Pretend AB is a straight line")

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Find the center of the circle (D) (III.1) and "
                   "draw lines DA,DB, and DE "
                   "and point F is the intersection of DE and the circle")

        t3.explain("If AB is a straight line")
        t3.explain("and E is outside the circle...")
        t3.math('DE > DF', fill_color=BLUE)
        D = p['D'] = EPoint(c['C'].get_center(), label=('D', UP))
        l['DA'] = ELine(D,A)
        l['DE'] = ELine(D,E)
        l['DB'] = ELine(D,B)
        F = p['F'] = EPoint(c['C'].intersect(l['DE'])[0], label=('F', RIGHT))

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            c['C'].e_fade()
            l['DE'].e_fade()
        t1.explainM("Looking at the isosceles triangle DAB (DA equals DB), "
                    r"then the angles $\alpha$ and $\beta$ are equal (I.5)")
        l['AEv'] = VirtualLine(*c['AB'].tangent_points(p['A']))
        l['BEv'] = VirtualLine(*c['AB'].tangent_points(p['B'],negative=True))
        a['DAE'] = EAngle(l['AEv'], l['DA'], label=r'\alpha', size=mn_scale(20))
        a['DBE'] = EAngle(l['DB'], l['BEv'], label=r'\beta', size=mn_scale(20))
        t2.next_to(t3, DOWN, aligned_edge=LEFT, buff=SMALL_BUFF * 1.5)
        t2.math(r'\alpha = \beta')

        for key in 'AEv BEv BEv'.split():
            l[key].e_remove()

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            l['DE'].e_normal()
            l['DB'].e_fade()
            a['DBE'].e_fade()
        t1.explainM(r"Angle $\gamma$ is exterior to the triangle DAE, "
                    r"so it is larger than the angle $\alpha$ (I.16)")

        l['EBv'] = VirtualLine(*c['AB'].tangent_points(p['E']))
        a['DEB'] = EAngle(l['EBv'], l['DE'], label=r'\gamma', size=mn_scale(20))

        with self.simultaneous():
            t2.e_fade()
        t2.math(r'\gamma > \alpha')
        l['EBv'].e_remove()

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            l['DE'].e_normal()
            l['DB'].e_normal()
            l['DA'].e_fade()
            a['DBE'].e_normal()
            a['DAE'].e_fade()
        t1.explainM(r"Since $\alpha$ equals $\beta$, then $\gamma$ "
                    r"is also greater than $\beta$")
        with self.simultaneous():
            t2.white()
        t2.math(r'\gamma > \beta')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("The side opposite a larger angle is larger (I.19), "
                   "therefore DB is larger than DE")
        with self.simultaneous():
            t2.e_fade()
            t2.white(-1)
        t2.math('DB > DE')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t2.down()
        t1.explain("DB equals DF because they are the radii of the same circle")
        with self.simultaneous():
            t2.e_fade()
        t2.math('DB = DF')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Therefore DF is also greater than DE")
        with self.simultaneous():
            t2.e_fade()
            t2.white(-1, -2)
        t2.math('DF > DE')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            l['DE'].e_normal()
            l['DB'].e_fade()
            l['DA'].e_fade()
            c['AB'].e_fade()
        t1.explain("But DE is larger than DF (by definition), "
                   "so we have a logical inconsistency")

        with self.simultaneous():
            t3.red(-1)
            t2.e_fade()
            t2.red(-1)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            a['DBE'].e_normal()
            a['DEB'].e_normal()
            a['DAE'].e_normal()
            l['DE'].e_normal()
            l['DB'].e_normal()
            l['DA'].e_normal()
            c['AB'].e_normal()
            c['C'].e_normal()
        t1.explain("Therefore E cannot lie outside of the circle, "
                   "or by similar logic, on the circumference of the circle")
        with self.simultaneous():
            t2.e_fade()
            t3.e_fade()
            t3.red(0, 1)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            t3.e_fade()
        t2.down()
        t2.explain('AB is a straight line and inside the circle')
        l['AB'].e_draw()
        with self.simultaneous():
            c['AB'].e_remove()
            p['E'].e_remove()
            l['DA'].e_remove()
            l['DE'].e_remove()
            l['DB'].e_remove()
            p['F'].e_remove()
            p['D'].e_remove()
            a['DEB'].e_remove()
            a['DAE'].e_remove()
            a['DBE'].e_remove()
