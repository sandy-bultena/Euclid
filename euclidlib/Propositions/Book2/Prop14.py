import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book2Scene, AttrDict
from euclidlib.Objects import *
from typing import Dict


class Prop14(Book2Scene):
    steps = []
    title = "To construct a square equal to a given rectilinear figure."

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(200, 530))
        t3 = TextBox(mn_coord(500, 200))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        A = (mn_coord(150, 160),
             mn_coord(300, 185),
             mn_coord(250, 310),
             mn_coord(90, 235))
        K = mn_coord(100, 450)

        # ----------------------------------------------
        # Construction
        # ----------------------------------------------
        @self.push_step
        def c01_given_rect_figure():
            t1.title("Construction:")
            t1.explain("Let A be the given rectilinear figure")
            s['A'] = EPolygon(*A, point_labels=[None, 'A', None, None])

        @self.push_step
        def c02_create_eq_rectangle():
            t1.explain("Copy A to a rectangle{nb}(I.45)")
            p['K'] = EPoint(K)
            s['R'] = s['A'].copy_to_rectangle(p['K'])
            with self.simultaneous():
                s['R'].set_point_labels(("B", LEFT), ("E", UR), ('D', RIGHT), ('C', LEFT))
            t3.math(r'A_A = A_{BEDC}', fill_color=BLUE)

        @self.push_step
        def c03_larger_line_to():
            p['B'] = s['R'].p0
            l['BF'] = s['R'].l0.copy()
            l['BF'].extend(mn_scale(100))
            c['E'] = ECircle(s['R'].p1, s['R'].p2).e_fade()
            cuts = c['E'].intersect(l['BF'])
            p['F'] = EPoint(cuts[0], label=('F', DOWN))
            l['BF'].e_remove()
            l['BF'] = ELine('BF')
            t3.math(r'\overline{EF} = \overline{ED}')

        @self.push_step
        def c04_bisect_BF_as_G():
            t1.explain("Bisect BF (and label it point G)")
            c['E'].e_remove()
            p['G'] = l['BF'].bisect().add_label('G', UL)
            t3.math(r'\overline{BG} = \overline{GF}')

        @self.push_step
        def c05_draw_circle_around_G():
            t1.explain("Draw a circle with G as the center and GF as the radii")
            c['G'] = ECircle(p['G'], p['F']).e_fade()

        @self.push_step
        def c05_extend_DE_to_inter_circle():
            t1.explain("Extend DE to intersect with the circle at "
                       "point H, and let GH be joined")
            l['H1'] = s['R'].l1.copy().prepend(mn_scale(200))
            p['H'] = EPoint(c['G'].intersect(l['H1'])[0], label=('H', DR))
            p['E'] = s['R'].p1

            l['H1'].e_remove()
            with self.simultaneous():
                l['H'] = ELine('EH')
                l['G'] = ELine('GH')

            t3.math(r'\overline{GH} = \overline{GF}', fill_color=BLUE)

        @self.push_step
        def c06_square_HE_eq_Area_A():
            t1.explain("The square on HE is equal in area to figure A")
            s['EH'] = ESquare(*l['H'].get_start_and_end())
            with self.simultaneous():
                s['A'].e_fill(BLUE_D)
                s['EH'].e_fill(GREEN_D)
            t3.math(r'A_{\square HE} = A_A')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def p00_cleanup():
            with self.simultaneous():
                t3.delete_last()
                t1.e_remove()

            t1.title("Proof:")

        @self.push_step
        def p01_polyA_eq_polyBD_by_construction():
            with self.simultaneous():
                s['A'].e_fill(BLUE_D)
                s['R'].e_fill(BLUE_D)
                s['EH'].e_fade()
                l['H'].e_fade()
                l['BF'].e_fade()
                l['G'].e_fade()

            t1.explain("Polygon A equals the polygon BD by construction")

        @self.push_step
        def p02_lineBF_is_divided_into_eq_and_non_eq():
            with self.simultaneous():
                s['A'].e_fade()
                s['R'].e_fade()
                s['EH'].e_fade()

                l['BF'].e_normal()
                p['E'].e_normal()
                p['B'].e_normal()

            t1.explain("Line BF is divided into equal (G) and unequal "
                       "segments{nb}(E), thus the rectangle formed by BE,EF "
                       "plus the square "
                       "of EG is equal to the square on GF{nb}(II.5)")

            with self.simultaneous():
                t3.e_fade()
                t3.blue(2)
            t3.math(r'BE \cdot EF + EG^2 = GF^2')

        @self.push_step
        def p03_since_GHE_is_right_GH_eq_GF():
            nonlocal p
            t1.explain("Since GHE is a right triangle, and GH is equal to GF, "
                       "the square of GF is equal to the sum of the squares on "
                       "EG and GH (I.47)")

            s['GHE'] = ETriangle('GHE').e_fill(PINK)

            with self.simultaneous():
                t3.e_fade()
                t3.blue(3)
            t3.math(r'GH^2 = EG^2 + EH^2')
            t3.math(r'GF^2 = EG^2 + EH^2', transform_from=-1)

        @self.push_step
        def p04_thus_rect_plus_square_eq_sum():
            nonlocal p
            t1.explain("Thus the rectangle formed"
                       " by BE,EF plus the square of EG is equal to the sum of "
                       "the squares "
                       "on EG and GH")

            s['GHE'].e_unfill()

            with self.simultaneous():
                t3.e_fade()
                t3.e_normal(-1, -3)
            t3.math(r'BE \cdot EF + EG^2  = EG^2 + EH^2', transform_from=-3, break_into_parts=r'  ')

        @self.push_step
        def p05_subtract_EG_from_both_sides():
            with self.simultaneous():
                t3.e_fade()
                t3.blue(3)

            t1.explain("Subtracting EG from both sides of the equality, "
                       "gives BE,EF equals the square of EH")


            with self.simultaneous():
                t3.e_fade()
                t3.e_normal(-1, -2, -3)

            t3.unindent()
            parts = t3.math(r'BE \cdot EF  = EH^2  = A_{BEDC}  = A_A', delay_anim=True, break_into_parts=r'  ')
            for i, part in enumerate(parts):
                eq[i] = part

            self.play(
                mn.TransformMatchingStrings(t3[-8].copy(), parts[0]),
                mn.TransformMatchingStrings(t3[-7].copy(), parts[1]),
            )


        @self.push_step
        def p06_rect_eq_square():
            t1.explain("The rectangle formed by BE,EF is BD, since EF equals ED ")
            with self.simultaneous():
                s['R'].e_normal()
            s['R'].e_fill(BLUE_D)

            with self.simultaneous():
                t3.e_fade(-2)
                t3.e_normal(1)

            with self.simultaneous():
                self.play(l['BF'].highlight())
                self.play(s['R'].l1.highlight())
                self.play(s['R'].highlight())
            self.play(eq[0].highlight())

            eq[2].e_draw()


        @self.push_step
        def p07_rect_eq_square2():
            t1.explain("Therefore BD equals the square on EH")
            with self.simultaneous():
                s['EH'].e_normal()
            s['EH'].e_fill(BLUE_D)

            t3[-2].e_fade()
            eq[1].e_normal()
            eq[0].e_fade()


        @self.push_step
        def p08_therefore_sq_eq_polygon():
            t1.explain("Therefore polygon 'A' equals the square on EH")
            with self.simultaneous():
                s['A'].e_normal()
            s['A'].e_fill(BLUE_D)

            t3.blue(0)
            eq[3].e_normal().e_draw()
            self.play(mn.FlashAround(t3[0]))
            self.play(mn.FlashAround(mn.VGroup(eq[2], eq[3])))
            eq[2].e_fade()


        @self.push_step
        def p09_final_cleanup():
            t3.indent()
            t3.indent()
            parts = t3.math(r'A_A  = EH^2', delay_anim=True, break_into_parts=r'  ')
            self.play(
                mn.TransformMatchingStrings(eq[1].copy(), parts[1]),
                mn.TransformMatchingStrings(eq[3].copy(), parts[0]),
            )
            with self.simultaneous():
                s['R'].e_remove()
                for value in c.values():
                    value.e_remove()
                s['GHE'].e_remove()
                for value in l.values():
                    value.e_remove()
                for value in p.values():
                    value.e_remove()
                t3.e_fade()
                t3.e_normal(0, -2, -3)



