import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.BookScene import Book3Scene, AttrDict
from euclidlib.Objects import *
DEG = mn.PI/180

class Prop37(Book3Scene):
    steps = []
    title = ("If a point be taken outside a circle and from the point there fall "
             "on the circle two straight lines, if one of them cut the circle, and the other "
             "fall on it, and if further the rectangle contained by the whole of the straight "
             "line which cuts the circle and the straight line intercepted on it outside "
             "between the point and the convex circumference be equal to the square on the "
             "straight line which falls on the circle, and the straight line which falls on "
             "it will touch the circle.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(400, 650))
        t3 = TextBox(mn_coord(480, 200))

        l: dict[str | int, ELine] = {}
        p: dict[str | int, EPoint] = {}
        c: dict[str | int, ECircle] = {}
        t: dict[str | int, ETriangle] = {}
        s: dict[str | int, EPolygon] = {}
        a: dict[str | int, EAngleBase] = {}
        eq: dict[str | int, EStringObj] = {}
        ex: dict[str | int, mn.Mobject] = {}

        c1 = mn_coord(300, 350)
        r1 = mn_scale(125)

        # -------------------------------------------------------------------------------------------------------------
        # In Other Words
        # -------------------------------------------------------------------------------------------------------------
        t1.down(MED_SMALL_BUFF * 3)
        t1.title("In other words:")
        c[1] = ECircle(c1, c1 + r1 * RIGHT)
        A= p['A'] = c[1].e_point_at_angle(-50 * DEG).add_label('A', angle_to_vector(-50 * DEG))
        C= p['C'] = c[1].e_point_at_angle(PI).add_label('C', angle_to_vector(PI))
        F= p['F'] = EPoint(c1, label=('F', RIGHT))
        l['AC'] = ELine(A,C)
        l['AD'] = l['AC'].copy().extend(r1)
        D= p['D'] = EPoint(l['AD'].get_end(), label=('D', dict(away_from=p['A'])))

        t1.explain("Let point D be outside of the circle")
        t1.explain("Let a line DA cut the circle at C and A, "
                   "and let line DB fall on the circle")

        l['BD'] = c[1].draw_tangent(p['D'], negative=True)
        B= p['B'] = EPoint(l['BD'].get_end(), label=('B', dict(away_from=p['F'])))

        t1.explain("If the product AD,CD equals BD squared, "
                   "then DB touches the circle")
        t3.math(r'AD \cdot CD = BD^2', is_axiom=True)
        t3.math(r'\measuredangle DBF = \rightangle')

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.down()
        t1.title("Proof:")
        t3.e_remove(-1)

        t1.explain("Draw DE such that it touches the circle (III.17)")
        l['DE'] = c[1].draw_tangent(p['D'])
        E = p['E'] = EPoint(l['DE'].get_end(), label=('E', dict(away_from=c[1].get_center())))

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Since DE touches the circle, the product "
                   "AD,CD equals DE {nb:squared (III.36)}")
        t1.explain('Therefore DE equals BD')
        t3.math(r'AD \cdot CD = DE^2')
        t3.math('BD = DE')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Draw EF, where F is the centre of the circle")
        t1.explain("Angle FED is right (III.18)")
        l['EF'] = ELine(E,F)
        a['FED'] = EAngle(l['DE'],l['EF'])

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Compare the two triangles DEF and DBF")
        with self.simultaneous():
            l['AC'].e_fade()
            l['AD'].e_fade()
            p['C'].e_fade()
            c[1].e_fade()
            p['A'].e_fade()
        t3.down()
        s['DEF'] = ETriangle(D,E,F).e_fill(BLUE_D)
        s['DBF'] = ETriangle(D,B,F).e_fill(GREEN_D)
        t3.math('EF = BF')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Since all three sides of the triangle are "
                   "equal (I.8), then angle FBD is also right")
        l['FB'] = ELine(F,B)
        a['FBD'] = EAngle(l['FB'],l['BD'])

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("If the angle FBD is right (and since B is at "
                   "the extremity of the diameter), "
                   "then BD touches the circle (III.16)")
        with self.simultaneous():
            s['DEF'].e_remove()
            s['DBF'].e_remove()
            l['DE'].e_remove()
            l['EF'].e_remove()
            c[1].e_normal()
            p['E'].e_remove()
            a['FED'].e_remove()
