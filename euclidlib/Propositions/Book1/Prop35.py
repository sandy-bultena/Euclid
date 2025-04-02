import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop35(Book1Scene):
    steps = []
    title = ("Parallelograms which are on the same base and in "
             "the same parallels equal one another.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 175))
        t3 = TextBox(mn_coord(475, 300))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        A = mn_coord(75, 200)
        B = mn_coord(100, 400)
        C = mn_coord(250, 400)
        F = mn_coord(450, 200)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def i01_given_two_para_lines():
            nonlocal A, B, C, F
            t1.title("In other words:")
            t1.explain("Given two parallel lines")
            l['AF1'] = EDashedLine('AF')
            l['BC1'] = ELine('BC')

        @self.push_step
        def i02_given_two_para_lines():
            nonlocal A, B, C, F
            t1.explain("Let ABCD and EBCF be parallelograms with the same "
                       "base BC and the same height, (congruent with AF, a line parallel to the base)")
            s['ABCD'] = EParallelogram('ABC',
                                       point_labels=[
                                           ('A', UP),
                                           ('B', DOWN),
                                           ('C', DOWN),
                                           ('D', UP),
                                       ])
            s['BCFE'] = EParallelogram('BCF',
                                       point_labels=[
                                           ('B', DOWN),
                                           ('C', DOWN),
                                           ('F', UP),
                                           ('E', UP),
                                       ])
            with self.delayed():
                t2.math(r'AD \parallel BC \parallel EF', fill_color=BLUE)
                t2.math(r'AB \parallel DC', fill_color=BLUE)
                t2.math(r'EB \parallel FC', fill_color=BLUE)

        @self.push_step
        def i03_areas_are_equal():
            nonlocal A, B, C, F
            t1.explain("The area ABCD is equal to EBCF")
            t2.math(r'\parallelogram ABCD = \parallelogram EBCF')
            with self.delayed():
                for v in l.values():
                    v.e_fade()

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def p01_clear_text():
            t1.down()
            t1.title("Proof:")
            del t2[-1]

        @self.push_step
        def p02_since_paragram_AD_eq_BC():
            t1.explain(r"Since ABCD is a parallelogram, AD is equal to BC{nb}(I.34)")
            s['ABCD'].l[3].add_label('x', UP)
            s['ABCD'].l[1].add_label('x', DOWN)
            s['ABCD'].e_fill(BLUE_D)
            t3.math('AD = BC = x')

        @self.push_step
        def p03_since_paragram_EF_eq_BC():
            t1.explain(r"Since EBCF is a parallelogram, EF is equal to BC{nb}(I.34)")
            s['BCFE'].l[2].add_label('x', UP)
            s['ABCD'].e_unfill()
            s['BCFE'].e_fill(GREEN_D)
            t3[0].e_fade()
            t3.math('EF = BC = x')

        @self.push_step
        def p03_ergo_AD_eq_EF():
            t1.explain("Hence AD is equal to EF")
            s['BCFE'].e_unfill()
            t3[0].e_normal()
            t3.math('AD = EF = x')

        @self.push_step
        def p04_add_delta():
            t1.explain("Add DE to both AD and EF, then AE is equal to DF")
            l['DE'] = ELine(s['ABCD'].p[3], s['BCFE'].p[3], label=(r'\delta', UP))
            with self.delayed():
                t3.e_fade[0:-1]()
            t3.math(r'AE = DF = x + \delta', transform_from=-1)

        @self.push_step
        def p05_since_paragram_AB_eq_DC():
            t1.explain("Since ABCD is a parallelograms, AB is equal to DC{nb}(I.34)")
            s['ABCD'].l[0].add_label('y', outside=True)
            s['ABCD'].l[2].add_label('y', outside=True)
            s['ABCD'].e_fill(BLUE_D)
            with self.delayed():
                t3.e_fade[-2:]()
            t3.math('AB = DC = y')

        @self.push_step
        def p06_DAB_eq_FDC():
            t1.explain("Angle DAB and FDC are equal (interior and "
                       "exterior angles), since AF "
                       "intersects two parallel lines AB and DC{nb}(I.29)")
            with self.delayed():
                s['BCFE'].l[0].e_fade()
                s['BCFE'].l[1].e_fade()
                s['BCFE'].l[3].e_fade()
                s['ABCD'].l[1].e_fade()
            s['ABCD'].set_angles(r'\alpha')
            s['ABCD'].e_unfill()
            a['CDE'] = EAngle(s['ABCD'].l[2], l['DE'], size=mn_scale(20), label=r'\alpha')
            t3.e_fade(-1)
            t3.math(r'\angle{EAB} = \angle{FDC}')

        @self.push_step
        def p07_triangles_are_eq():
            l['BC1'].e_remove()
            t1.explain("Triangles ABE and DFC are equivalent{nb}(I.4), thus equal in area")
            p['G'] = EPoint(s['BCFE'].l[3].intersect(s['ABCD'].l[2]))
            t['ABDG'] = ETriangle(A, B, s['BCFE'].p[3]).e_fill(BLUE_D)
            t['EFCG'] = ETriangle(F, C, s['ABCD'].p[3]).e_fill(GREEN_D)
            t3.e_normal(3, 4)
            t3.math(r'\triangle ABE = \triangle DCF')

        @self.push_step
        def p08_trapazoids_are_eq():
            with self.simultaneous():
                for line in s['ABCD'].l:
                    line.remove_label()
                l['DE'].e_remove()
                s['ABCD'].remove_angles()
                a['CDE'].e_remove()
            p['G'].add_label('G', RIGHT)
            t1.explain("Remove EDG from ABE and DFC, the resulting trapezoids ADGB and EGCF are equal")
            l['AF1'].e_fade()
            s['ABDG'] = EPolygon(A, B, p['G'], s['ABCD'].p[3], delay_anim=True, fill_color=BLUE_D, fill_opacity=0.5)
            s['EFCG'] = EPolygon(F, C, p['G'], s['BCFE'].p[3], delay_anim=True, fill_color=GREEN_D, fill_opacity=0.5)
            with self.simultaneous():
                self.play(mn.ReplacementTransform(t['ABDG'], s['ABDG']))
                self.play(mn.ReplacementTransform(t['EFCG'], s['EFCG']))
            t3.down()
            t3.math(r'\triangle ABE - \triangle DGE\\ =\ \triangle DCF - \triangle DGE', transform_from=-1)
            t3.math(r'\hrectangle ADBG = \hrectangle EGCF')
            t3.e_fade(3, 4, 5)

        @self.push_step
        def p09_add_base_triangle():
            t1.explain("Add BGC to both trapezoids, and the result is that the parallelograms ABCD and EBCF are equal" )
            with self.simultaneous():
                s['ABDG'].e_unfill()
                s['EFCG'].e_unfill()
                s['ABCD'].e_fill(BLUE_D)
                s['BCFE'].e_fill(GREEN_D)
                s['ABCD'].l[1].e_normal()
            with self.simultaneous():
                t3.e_fade[6:-1]()
            t3.down()
            t3.math(r'\hrectangle ADBG + \triangle BGC\\ =\ \hrectangle EGCF + \triangle BGC', transform_from=-1)
            self.wait(1)
            t3.math(r'\parallelogram ABCD = \parallelogram EBCF', transform_from=-1, transform_args=dict(
                key_map={r'\hrectangle ADBG + \triangle BGC': r'\parallelogram ABCD',
                         r'\hrectangle EGCF + \triangle BGC': r'\parallelogram EBCF'}
            ))

        @self.push_step
        def p10_QED():
            with self.delayed():
                t3.e_fade[:-1]()
