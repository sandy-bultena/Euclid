import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book3Scene, AttrDict
from euclidlib.Objects import *
from typing import Dict
from euclidlib.Objects.utils import *


class Prop37(Book3Scene):
    steps = []
    title = ("If a point be taken outside a circle and from the point there fall "
             "on the circle two straight lines, if one of them cut the circle, and the other "
             "fall on it, and if further the rectangle contained by the whole of the straight "
             "line which cuts the circle and the straight line intercepted on it outside "
             "between the point and the convex circumference be equal to the square on the "
             "straight line which falls on the circle, and the straight line which falls on "
             "it will touch the circle.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(400, 650))
        t3 = TextBox(mn_coord(480, 200))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        c1 = mn_coord(300, 350)
        r1 = mn_scale(125)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def i01_in_other_words():
            t1.down(MED_SMALL_BUFF * 3)
            t1.title("In other words:")
            c[1] = ECircle(c1, c1 + r1 * RIGHT)
            p['A'] = c[1].e_point_at_angle(-50 * DEG).add_label('A', angle_to_vector(-50 * DEG))
            p['C'] = c[1].e_point_at_angle(PI).add_label('C', angle_to_vector(PI))
            p['F'] = EPoint(c1, label=('F', RIGHT))
            l['AC'] = ELine('AC')
            l['AD'] = l['AC'].copy().extend(r1)
            p['D'] = EPoint(l['AD'].get_end(), label=('D', dict(away_from=p['A'])))

            t1.explain("Let point D be outside of the circle")
            t1.explain("Let a line DA cut the circle at C and A, "
                       "and let line DB fall on the circle")

            l['DB'] = c[1].draw_tangent(p['D'], negative=True)
            p['B'] = EPoint(l['DB'].get_end(), label=('B', dict(away_from=p['F'])))

            t1.explain("If the product AD,CD equals BD squared, "
                       "then DB touches the circle")
            t3.math(r'AD \cdot CD = BD^2')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def p01_proof_header():
            t1.down()
            t1.title("Proof:")

        @self.push_step
        def p02_draw_de_tangent():
            t1.explain("Draw DE such that it touches the circle (III.17)")
            l['DE'] = c[1].draw_tangent(p['D'])
            p['E'] = EPoint(l['DE'].get_end(), label=('E', dict(away_from=c[1].get_center())))

        @self.push_step
        def p03_AD_CD_eq_DE2():
            t1.explain("Since DE touches the circle, the product "
                       "AD,CD equals DE squared (III.36)")
            t1.explain('Therefore DE equals BD')
            t3.math(r'AD \cdot CD = DE^2')
            t3.math('BD = DE')

        @self.push_step
        def p04_line_ED_perp_to_ED():
            nonlocal p
            t1.explain("Draw EF, where F is the centre of the circle")
            t1.explain("Angle FED is right (III.18)")
            l['EF'] = ELine('EF')
            a['FED'] = EAngle('DEF')

        @self.push_step
        def p05_compare_two_triangles():
            nonlocal p
            t1.explain("Compare the two triangles DEF and DBF")
            with self.simultaneous():
                l['AC'].e_fade()
                l['AD'].e_fade()
                p['C'].e_fade()
                c[1].e_fade()
                p['A'].e_fade()
            t3.down()
            s['DEF'] = ETriangle('DEF').e_fill(BLUE_D)
            s['DBF'] = ETriangle('DBF').e_fill(GREEN_D)
            t3.math('EF = BF')

        @self.push_step
        def p06_triangle_eq_means_angle_eq():
            nonlocal p
            t1.explain("Since all three sides of the triangle are "
                       "equal (I.8), then angle FBD is also right")
            l['FB'] = ELine('FB')
            a['FBD'] = EAngle('FBD')

        @self.push_step
        def p07_if_angle_is_right_bd_touches_circle():
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
