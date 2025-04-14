import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book3Scene, AttrDict
from euclidlib.Objects import *
from typing import Dict


class Prop2(Book3Scene):
    steps = []
    title = ("If on the circumference on a circle two points be taken at random, "
             "the straight line joining the points will fall within the circle.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(520, 200))
        t3 = TextBox(mn_coord(450, 200))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, AbstractArc] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        C = mn_coord(225, 350)
        r = mn_scale(180)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def i01_let_AB_points_on_Circle():
            c['C'] = ECircle(C, C + r * RIGHT, label=('C', PI / 4))
            t1.title("In other words:")
            t1.explain("Let there be two points, A and B, randomly placed "
                       "on the circumference of the circle")
            with self.simultaneous():
                p['A'] = c['C'].e_point_at_angle(200 * DEG)
                p['B'] = c['C'].e_point_at_angle(270 * DEG)
            with self.simultaneous():
                p['A'].add_label('A', away_from=p['B'])
                p['B'].add_label('B', away_from=p['A'])

        @self.push_step
        def i02_line_AB_within_circle():
            nonlocal p
            t1.explain("The straight line AB will fall within the circle ")
            l['AB'] = ELine('AB')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def p01_start():
            t1.down()
            t1.title("Proof by contradiction:")

        @self.push_step
        def p02_draw_outside_line():
            l['AB'].e_remove()
            t1.explain("Let E be a point on the straight line AB, "
                       "and let it be outside of the circle")
            c['AB'] = EArc(r / 1.7, p['A'], p['B'])
            p['E'] = c['AB'].e_point_at_angle(235 * DEG).add_label('E', DOWN)
            t3.explain("If AB is a straight line")
            t3.explain("and E is outside the circle...")
            t3.math('DE > DF', fill_color=BLUE)

            aside = TextBox(p['E'].get_center() + mn_scale(*50 * DOWN))
            aside.sidenote("Pretend AB is a straight line")

        @self.push_step
        def p03_find_center_of_circle_D():
            t1.explain("Find the center of the circle (D) (III.1) and "
                       "draw lines DA,DB, and DE "
                       "and point F is the intersection of DE and the circle")
            p['D'] = EPoint(c['C'].get_center(), label=('D', UP))
            l['DA'] = ELine('DA')
            l['DE'] = ELine('DE')
            l['DB'] = ELine('DB')
            p['F'] = EPoint(c['C'].intersect(l['DE'])[0], label=('F', RIGHT))
            t3.e_fade(-1)

        @self.push_step
        def p04_center_of_circle_and_isosceles():
            with self.simultaneous():
                c['C'].e_fade()
                l['DE'].e_fade()
            t1.explainM("Looking at the isosceles triangle DAB (DA equals DB), "
                        r"then the angles $\alpha$ and $\beta$ are equal (I.5)")
            l['AEv'] = VirtualLine(*c['AB'].tangent_points(p['A']))
            l['BEv'] = VirtualLine(*c['AB'].tangent_points(p['B']))
            l['BEv'].prepend(mn_scale(50))
            l['BEv2'] = VirtualLine(l['BEv'].get_start(), p['B'])
            a['DAE'] = EAngle(l['AEv'], l['DA'], label=r'\alpha', size=mn_scale(20))
            a['DBE'] = EAngle(l['DB'], l['BEv2'], label=r'\beta', size=mn_scale(20))
            t2.next_to(t3, DOWN, aligned_edge=LEFT, buff=SMALL_BUFF * 1.5)
            t2.math(r'\alpha = \beta')

            for key in 'AEv BEv BEv2'.split():
                l[key].e_remove()

        @self.push_step
        def p05_gamma_is_larger_than_alpha():
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

        @self.push_step
        def p06_gamma_is_larger_than_beta():
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

        @self.push_step
        def p07_side_opposite_larger_larger():
            t1.explain("The side opposite a larger angle is larger (I.19), "
                       "therefore DB is larger than DE")
            with self.simultaneous():
                t2.e_fade()
                t2.white(-1)
            t2.math('DB > DE')

        @self.push_step
        def p08_sides_eq_cause_radius():
            t2.down()
            t1.explain("DB equals DF because they are the radii of the same circle")
            with self.simultaneous():
                t2.e_fade()
            t2.math('DB = DF')

        @self.push_step
        def p09_sides_eq_cause_radius():
            t1.explain("Therefore DF is also greater than DE")
            with self.simultaneous():
                t2.e_fade()
                t2.white(-1, -2)
            t2.math('DF > DE')

        @self.push_step
        def p10_but_de_larger_than_df_by_def():
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

        @self.push_step
        def p11_therefore_contradiction():
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


        @self.push_step
        def p12_AB_is_inside_circle():
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
