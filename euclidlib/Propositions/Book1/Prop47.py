import sys
import os

import numpy as np

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop47(Book1Scene):
    steps = []
    title = ("In right-angled triangles the square on the side opposite "
             "the right angle equals the sum of the squares on the sides "
             "containing the right angle.")

    def define_steps(self):
        t1 = TextBox(mn_coord(775, 150), line_width=mn_h_scale(575))
        t2 = TextBox(mn_coord(500, 175))
        t3 = TextBox(mn_coord(500, 175))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        top = 325
        bot = 425
        A_base = np.array([220, top, 0])
        B_base = np.array([145, bot, 0])

        side = -1 * (B_base[0] - A_base[0]) / (bot - top)
        b = A_base[1] - side * A_base[0]
        C_base = np.array([(1 / side) * (bot - b), bot, 0])

        A = mn_coord(*A_base)
        B = mn_coord(*B_base)
        C = mn_coord(*C_base)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def i01_given_triangle():
            nonlocal A, B, C
            t1.title("In other words:")
            t1.explain("Given a right angle triangle ABC")
            t['ABC'] = ETriangle('ABC', point_labels='ABC', angles=' ')

        @self.push_step
        def i02_square_on_all_sides():
            s['B'] = ESquare(B, A, point_labels=['F', None, None, 'G'])
            s['A'] = ESquare(A, C, point_labels=['H', None, None, 'K'])
            s['C'] = ESquare(C, B, point_labels=['E', None, None, 'D'])

            self.extract_all(l, p, a, s, 'FBAG', 'B')
            self.extract_all(l, p, a, s, 'HACK', 'A')
            self.extract_all(l, p, a, s, 'ECBD', 'C')

            with self.delayed():
                t3.explainM('$ABFG$ is a square', fill_color=BLUE)
                t3.explainM('$ACKH$ is a square', fill_color=BLUE)
                t3.explainM('$BCDE$ is a square', fill_color=BLUE)
            t2.next_to(t3, DOWN, buff=0, aligned_edge=LEFT)
            t2.down()

        @self.push_step
        def i03_state_theorem():
            t1.explain("Then the sum of the squares of lines AB and AC equals the square of BC")
            t2.math(r'\square AB + \square AC = \square BC')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def p01_cleanup_iow():
            with self.delayed():
                t1.e_remove()
                t2.e_remove()
            t2.next_to(t3, DOWN, aligned_edge=LEFT)
            t1.title("Proof:")
            with self.simultaneous():
                s['A'].e_fade()
                s['B'].e_fade()
                s['C'].e_fade()

        @self.push_step
        def p02_GA_AC_eq_GC():
            t1.explain("By construction, angle GAB is a right angle, as is BAC, "
                       "therefore lines GA and AC form a single line GC{nb}(I.14)")
            with self.simultaneous():
                t3.e_fade()
                t3.blue(0)

            s['B'].p[3].e_normal()
            s['B'].set_angles(None, None, " ", 0, 0, mn_scale(30))
            l['GC'] = ELine(s['B'].p[3], C)
            l['GC'].highlight()
            t2.e_fade()
            t2.math('GA,AC = GC')

        @self.push_step
        def p03_same_with_BG():
            t1.explain("Similarly for line BH{nb}(I.14)")
            with self.simultaneous():
                l['GC'].e_fade()
                s['B'].a[2].e_remove()
                s['B'].p[3].e_fade()
                s['A'].p[0].e_normal()

            s['A'].set_angles(None, " ", None, 0, mn_scale(30))
            l['BH'] = ELine(s['A'].p[0], B)
            l['BH'].highlight()

            with self.simultaneous():
                t3.e_fade()
                t3.blue(1)
                t2.e_fade()
            t2.math('BA,AH = BH')

        @self.push_step
        def p04_aglFBC_eq_aglABD():
            with self.simultaneous():
                t2.e_fade()
                l['BH'].e_fade()
                s['A'].p[2].e_remove()
                s['A'].a[1].e_remove()
                s['A'].p[0].e_fade()
            t1.explain("Angles FBA and CBD are both right angles")
            t1.explain("Adding angle ABC to both demonstrates that angles "
                       "FBC and ABD are also equal")

            with self.simultaneous():
                s['B'].p[0].e_normal()
                s['B'].l[0].e_normal()
                s['C'].p[3].e_normal()
                s['C'].l[2].e_normal()

            a['FBC'] = EAngle('FBC', size=mn_scale(15), label=(r'\gamma', 0.3))
            a['ABD'] = EAngle('ABD', size=mn_scale(25), label=(r'\gamma', 0.6))

            with self.simultaneous():
                t3.e_fade()
                t3.e_normal.blue(0, 2)
                t2.math(r'\angle{FBC} = \rightangle + \angle{ABC} = \angle{ABD}')

        @self.push_step
        def p05_draw_line_from_A_para_BD():
            t1.explain("Draw a line from A, parallel to BD")
            with self.skip_animations_for():
                l['ALx'] = s['C'].l2.parallel(t['ABC'].p0)
            p['L'] = EPoint(l['ALx'].intersect(s['C'].l3), label=('L', DOWN))
            l['AL'] = EDashedLine(A, p['L'])
            l['ALx'].e_remove()
            with self.simultaneous():
                t2.e_fade()
                t3.e_fade()
            t2.math(r'AL \parallel BD')

        @self.push_step
        def p06_draw_line_AD_and_FC():
            t1.explain("Draw lines AD and FC, and consider triangles FBC and ABD")
            l['FC'] = ELine(s['B'].p0, C)
            l['AD'] = ELine(A, s['C'].p3)
            s['ABD'] = ETriangle.assemble(lines=[t['ABC'].l0, s['C'].l2, l['AD']])
            s['FBC'] = ETriangle.assemble(lines=[s['B'].l0, t['ABC'].l1, l['FC']])

            with self.simultaneous():
                t['ABC'].l0.e_fade()
                t['ABC'].l1.e_fade()
                t['ABC'].l2.e_fade()
                t['ABC'].a0.e_fade()
                s['ABD'].e_normal()
                s['FBC'].e_normal()
                l['AL'].e_fade()
                t2.e_fade()

        @self.push_step
        def p07_triangles_are_equal():
            t1.explainM(r"The two triangles are equal, FB equals AB, BC equals "
                        r"BD, with a common angle $\gamma$(I.4)")
            s['ABD'].e_fill(BLUE_D)
            s['FBC'].e_fill(BLUE_D)
            with self.simultaneous():
                t3.e_normal(0, 2)
                t2.e_normal(-2)
                t2.math(r'\triangle FBC = \triangle ABD')

        @self.push_step
        def p08_sqAB_related_tFBC():
            t1.explain("The square AB and the triangle FBC share the same base, and are "
                        "enclosed by the same parallel lines GC,FB "
                        "thus FBC "
                        "is one half ABFG{nb}(I.41)")

            t['ABC'].l2.e_normal()
            with self.simultaneous():
                l['CAX'] = t['ABC'].l2.copy().extend_and_prepend(mn_scale(200))
                l['FBX'] = s['B'].l0.copy().extend_and_prepend(mn_scale(350))

            with self.simultaneous():
                l['FBX'] = l['FBX'].dashed()
                l['CAX'] = l['CAX'].dashed()

            s['B'].e_normal()
            s['B'].e_fill(BLUE)
            s['FBC'].e_fill(BLUE_D)
            with self.simultaneous():
                t3.e_fade()
                t3.blue(0)
                t2.e_fade()
            t2.math(r'\triangle FBC = \frac{1}{2} \square AB')

        @self.push_step
        def p09_rect_BDL_eq_half_ABD():
            nonlocal p
            with self.simultaneous():
                s['B'].e_fade()
                s['FBC'].e_fade()
                l['FBX'].e_remove()
                l['CAX'].e_remove()

            t1.explain("The triangle ABD equals half the parallelogram BDL{nb}(I.41)")
            s['ABD'].e_normal()
            s['BDL'] = EParallelogram('BDL').e_fill(BLUE_D)

            s['BDL'].l0.e_normal()
            with self.simultaneous():
                l['ALx'] = l['AL'].extend_and_prepend(mn_scale(150))
                l['BCx'] = s['BDL'].l0.copy().extend_and_prepend(mn_scale(150))

            with self.simultaneous():
                l['BCx'] = l['BCx'].dashed()

            with self.simultaneous():
                t3.e_fade()
                t2.e_fade()
                t2.e_normal(3)
            t2.math(r'\triangle ABD = \frac{1}{2} \parallelogram BDL')

        @self.push_step
        def p10_rect_BDL_eq_sqAB():
            nonlocal p
            t1.explain("Therefore, the square of AB equals the polygon BDL")
            with self.simultaneous():
                l['ALx'].e_remove()
                l['BCx'].e_remove()
                with self.freeze(*s['ABD'].l, *s['FBC'].l):
                    s['ABD'].e_remove()
                    s['FBC'].e_remove()
                t['ABC'].e_normal()
                s['B'].e_normal()

                l['FC'].e_remove()
                l['AD'].e_remove()
                a['FBC'].e_remove()
                a['ABD'].e_remove()

                t2.e_fade()
                t3.e_fade()
                t2.e_normal[-3:]()
            t2.math(r'\square AB = \parallelogram BDL')

        @self.push_step
        def p11_using_same_logic():
            nonlocal p
            t1.explain("Applying the same logic as before, triangles BCK and AEC are equal{nb}(I.4)")
            with self.simultaneous():
                s['C'].e_normal()
                s['A'].e_normal()
            l['AE'] = ELine(A, s['C'].p0)
            l['BK'] = ELine(B, s['A'].p3)
            with self.simultaneous():
                s['BCK'] = ETriangle.assemble(lines=[t['ABC'].l1, s['A'].l2, l['BK']])
                s['ECA'] = ETriangle.assemble(lines=[s['C'].l0, t['ABC'].l2, l['AE']])
            with self.simultaneous():
                s['BCK'].set_angles(None, r'\sigma', None, 0, mn_scale(15))
                s['ECA'].set_angles(None, r'\sigma', None, 0, mn_scale(25))
            with self.simultaneous():
                s['BCK'].e_fill(GREEN_D)
                s['ECA'].e_fill(GREEN_D)

            with self.simultaneous():
                t2.e_fade()
                t3.e_normal(1, 2)
                t2.math(r'\angle{BCK} = \angle{ACE}')
                t2.math(r'\triangle{ECA} = \triangle{BCK}')

        @self.push_step
        def p12_tri_BCK_half_AC():
            t1.explain("Triangle BCK is half of the square AC")
            with self.simultaneous():
                s['ECA'].e_fade()
                s['A'].e_normal()
                s['A'].e_fill(GREEN)
            with self.simultaneous():
                s[1] = t['ABC'].l0.dashed_copy().extend_and_prepend(mn_scale(300))
                s[2] = s['A'].l2.dashed_copy().extend_and_prepend(mn_scale(300))

            with self.simultaneous():
                t2.e_fade()
                t3.e_fade()
                t3.e_normal(1)

            t2.math(r'\triangle BCK = \frac{1}{2} \square AC')

        @self.push_step
        def p13_tri_ECA_half_CEL():
            with self.simultaneous():
                s[1].e_remove()
                s[2].e_remove()

            t1.explain("Triangle ECA is half the parallelogram CEL{nb}(I.41)")

            with self.simultaneous():
                s['BCK'].e_fade()
                s['ECA'].e_normal()
                s['A'].e_fade()

            nonlocal p
            s['CEL'] = EParallelogram('CEL', skip_anim=True)
            s['CEL'].e_fill(GREEN)

            with self.simultaneous():
                s[1] = s['C'].l0.dashed_copy().extend_and_prepend(mn_scale(300))
                s[2] = l['AL'].dashed_copy().extend_and_prepend(mn_scale(100))


            with self.simultaneous():
                t2.e_fade()
                t3.e_fade()
                t3.e_normal(2)
                t2.e_normal(3)

            t2.math(r'\triangle ECA = \frac{1}{2} \parallelogram CEL')

        @self.push_step
        def p14_CEL_eq_AC():
            t1.explain("Therefore the square of AC equals the parallelogram{nb}CEL")

            with self.simultaneous():
                s[1].e_remove()
                s[2].e_remove()
                l['AE'].e_remove()
                l['BK'].e_remove()
                s['ECA'].e_unfill()
                s['ECA'].remove_angles()
                s['BCK'].e_unfill()
                s['BCK'].remove_angles()
                s['A'].e_normal()

            with self.simultaneous():
                t2.e_fade()
                t3.e_fade()
                t2.e_normal[-3:]()
            t2.math(r'\square AC = \parallelogram CEL')

        @self.push_step
        def p15_big_square_eq_rectangles():
            t1.explain("The square of line BC equals the sum of BDL and CEL")
            with self.simultaneous():
                t2.e_fade()
                t3.e_fade()
            t2.math(r'\square BC = \parallelogram BDL + \parallelogram CEL')

        @self.push_step
        def p16_QED():
            t1.explain("The sum of the squares of lines AB and AC equals the square of BC")
            with self.simultaneous():
                t2.e_fade()
                t2.e_normal(7, 12, -1)
            t2.math(r'\square AB + \square AC = \square BC')