import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop25(Book1Scene):
    steps = []
    title = ("If two triangles have two sides equal to "
             "two sides respectively, but have the base greater "
             "than the base, then they also have the one of the angles "
             "contained by the equal straight lines greater than the other.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 175))
        t3 = TextBox(mn_coord(475, 475))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        A = mn_coord(200, 150)
        B = mn_coord(75, 350)
        C = mn_coord(375, 350)
        D = mn_coord(100, 660)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            nonlocal A, B, C
            t1.title("In other words:")
            t1.explain("Given two triangles ABC and DEF, where "
                       "lengths AB equals DE and AC equals DF, "
                       "but the base BC is greater than the base EF")
            t['ABC'] = ETriangle('ABC',
                                 point_labels='ABC',
                                 angles=[r'\alpha'],
                                 labels='cab')
            ETriangle.SSS(D,
                          t['ABC'].l[0],
                          t['ABC'].l[1].get_length() - mn_scale(100),
                          t['ABC'].l[2],
                          point_labels='DEF',
                          angles=[r'\delta'],
                          labels='cdb')

            with self.delayed(lag_ratio=0.5):
                t2.math('AB = DE = c', fill_color=BLUE)
                t2.math('AC = DF = b', fill_color=BLUE)
                t2.math(r'BC > EF\ ,\ a > d', fill_color=BLUE)

        @self.push_step
        def _i2():
            t1.explain("Angle CAB is greater than angle FDE")
            t2.down()
            t2.math(r'\alpha > \delta')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def p_proof_by_contra():
            t1.down()
            t1.title("Proof by contradiction:")
            t2.delete_last()

        @self.push_step
        def p_assume_CAB_eq_FDE():
            t1.explain("Assume angle CAB is equal to angle FDE")
            t2.down()
            with self.delayed():
                t2.e_fade()
            t2.math(r'\alpha = \delta')

        @self.push_step
        def p_SAS_implies_eq_sides():
            t1.explain("Then length BC would equal EF because the "
                       "side-angle-side of both triangles are equal (I.4)")
            with self.delayed():
                t2.blue(0, 1)
            t2.math(r'\Rightarrow BC = EF')

        @self.push_step
        def p_eq_sides_contradict():
            t1.explain("which leads to a contradiction")
            with self.delayed():
                t2.e_fade()
                t2.red(-1, 2)

        @self.push_step
        def p_there4_CAB_eq_FDE_X():
            t1.explain("Therefore the original assumption that the angles "
                       "CAB and FDE are equal is also wrong")
            with self.delayed():
                t2.e_fade()
                t2.white(-2)
            with self.simultaneous():
                t2.e_append_morph(-2, r'\ \ecrossmark', RED)

        @self.push_step
        def p_assume_CAB_lt_FDE():
            t1.down()
            t1.explain("Assume angle CAB is less than angle FDE")
            t2.down()
            with self.delayed():
                t2.e_fade()
            t2.math(r'\alpha < \delta')

        @self.push_step
        def p_P24_implies_BC_lt_EF():
            t1.explain("Then length BC would less than EF, since it is "
                       "the triangle with the lesser angle (I.24), ")
            with self.delayed():
                t2.e_fade()
                t2.e_normal(0, 1, -1)
            t2.math(r'\Rightarrow BC < EF')

        @self.push_step
        def p_lt_sides_contradict():
            t1.explain("which leads to a contradiction")
            with self.delayed():
                t2.e_fade()
                t2.red(-1, 2)

        @self.push_step
        def p_there4_CAB_lt_FDE_X():
            t1.explain("Therefore the original assumption that the angles "
                       "CAB is less than FDE is also wrong")
            with self.delayed():
                t2.e_fade()
                t2.white(-2)
            with self.simultaneous():
                t2.e_append_morph(-2, r'\ \ecrossmark', RED)


        @self.push_step
        def p_there4_CAB_gt_FDE():
            t1.down()
            t1.explain("Therefore angle CAB is greater than FDE")
            t2.down()
            with self.delayed():
                t2.e_normal(3)
            t2.math(r'\therefore\  \alpha > \delta')


        @self.push_step
        def p_closing():
            with self.delayed():
                t2.white(-1)
                t2.blue[:3]()
