import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop32(Book1Scene):
    steps = []
    title = ("In any triangle, if one of the sides is produced, "
             "then the exterior angle equals the sum of the two "
             "interior and opposite angles, and the sum of the three "
             "interior angles of the triangle equals two right angles.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 175))
        t3 = TextBox(mn_coord(475, 500))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        A = mn_coord(250, 200)
        B = mn_coord(75, 400)
        C = mn_coord(350, 400)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i00_given_triangle_w_extension():
            nonlocal A, B, C
            t1.title("In other words:")
            t1.explain(r"Given a triangle ABC, and line BC extended to point{nb}D")
            t['ABC'] = ETriangle('ABC',
                                 point_labels='ABC',
                                 angles=r'\gamma \alpha \beta'.split())
            l['BC'] = t['ABC'].l[1].copy().extend(mn_scale(200))
            p['D'] = EPoint(l['BC'].get_end(), label=('D', dict(away_from=B)))

            l['BC'], l['CD'] = l['BC'].e_split(t['ABC'].p[-1])

            l['BC'].e_delete()
            a['DCA'] = EAngle(l['CD'], t['ABC'].l[2], size=mn_scale(60), label=r'\delta')

        @self.push_step
        def _i01_DCA_eq_sum_ABC_CAB():
            t1.explain(r"Angle DCA is equal to the sum of ABC and CAB")
            t2.math(r'\delta = \gamma + \alpha')

        @self.push_step
        def _i02_total_2_right_angle():
            t1.explain(r"The sum of the angles BCA, ABC and CAB is two right angles")
            t2.math(r'\beta + \gamma + \alpha = \rightangle + \rightangle')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p00_clear_math():
            t1.down()
            t1.title("Proof:")
            with self.simultaneous():
                t2.e_remove()

        @self.push_step
        def _p01_draw_parallel_line():
            t1.explain("Create a line parallel to AB, at point C{nb}(I.31)")
            a['DCA'].e_fade()
            l['CE'] = t['ABC'].l[0].parallel(t['ABC'].p[-1])
            with self.simultaneous():
                t['ABC'].e_fade()
                t['ABC'].l[0].e_normal()
                t['ABC'].p[0].e_normal()
                t['ABC'].p[1].e_normal()
                t['ABC'].p[2].e_normal()
                l['CD'].e_fade()

            p['E'] = EPoint(l['CE'].get_start(), label=('E', UP))
            l['CE'], l['XC'] = l['CE'].e_split(t['ABC'].p[-1])

        @self.push_step
        def _p02_since_lines_are_parallel_and_AC_cross():
            l['AB'] = t['ABC'].l[0].copy().prepend(mn_scale(40))
            l['AB'].extend(mn_scale(40))
            l['CD'].e_fade()
            t['ABC'].a[0].e_normal()
            t['ABC'].l[2].e_normal()

            t1.explain("Since lines AB and CE are parallel, and line AC crosses them, "
                       "then angles BAC and ACE are equal (I.29)")

            a['ECA'] = EAngle(l['CE'], t['ABC'].l[2], size=mn_scale(20), label=r'\gamma')
            t3.math(r'\angle{BAC} = \angle{ACE} = \gamma')

        @self.push_step
        def _p03_since_lines_are_parallel_and_BC_cross():
            with self.delayed():
                t['ABC'].e_normal()
                l['CD'].e_normal()
                t['ABC'].l[2].e_fade()
                t['ABC'].a[0].e_fade()
                t['ABC'].a[2].e_fade()
                a['ECA'].e_fade()

            t1.explain("Since lines AB and CE are parallel, and line BC crosses them, "
                       "then angles ABC and ECD are equal (I.29)")

            a['ECD'] = EAngle(l['CD'], l['CE'], size=mn_scale(25), label=r'\alpha')
            t3.math(r'\angle{ABC} = \angle{ECD} = \alpha')

        @self.push_step
        def _p04_angle_ACD_eq_ACE_plus_ECD():
            with self.delayed():
                t['ABC'].e_normal()
                a['ECA'].e_normal()
                a['DCA'].e_normal()

            t1.explain("Angle ACD equals the sum of angles ACE and ECD")
            t3.math(r'\delta = \gamma = \alpha')

        @self.push_step
        def _p05_sum_eq_2_right():
            t1.explain("The sum of angles ACD and ACB is two right angles\\{nb}(I.13)")
            t3.math(r'\beta = \delta = \rightangle + \rightangle')

        @self.push_step
        def _p06_therefore():
            t1.explain("Therefore sum of angles ACE, ECD, and ACB is two right angles")
            t3.math(r'\therefore\ \beta + \gamma + \alpha = \rightangle + \rightangle')

