import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book01 import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop25(Book1Scene):
    steps = []
    title = ("If two triangles have two sides equal to "
             "two sides respectively, but have the base greater "
             "than the base, then they also have the one of the angles "
             "contained by the equal straight lines greater than the other.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(475, 175))
        t3 = TextBox(mn_coord(475, 475))

        l: Dict[str | int, ELine] = self.l
        p: Dict[str | int, EPoint] = self.p
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(200, 150)
        B = mn_coord(75, 350)
        C = mn_coord(375, 350)
        D = mn_coord(100, 660)

        self.next_page()

        # ------------------------------------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Given two triangles ABC and DEF, where "
                   "lengths AB equals DE and AC equals DF, "
                   "but the base BC is greater than the base EF")
        t['ABC'] = ETriangle(A,B,C,
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

        with self.staggered_animation():
            t2.math('AB = DE = c', is_axiom=True)
            t2.math('AC = DF = b', is_axiom=True)
            t2.math(r'BC > EF\ ,\ a > d', is_axiom=True)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Angle CAB is greater than angle FDE")
        t2.down()
        t2.math(r'\alpha > \delta')

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t1.down()
        t1.title("Proof by contradiction:")
        t2.delete_last()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Assume angle CAB is equal to angle FDE")
        t2.down()
        with self.staggered_animation():
            t2.e_fade()
        t2.math(r'\alpha = \delta')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Then length BC would equal EF because the "
                   "side-angle-side of both triangles are equal (I.4)")
        with self.staggered_animation():
            t2.blue(0, 1)
        t2.math(r'\Rightarrow BC = EF')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("which leads to a contradiction")
        with self.staggered_animation():
            t2.e_fade()
            t2.red(-1, 2)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Therefore the original assumption that the angles "
                   "CAB and FDE are equal is also wrong")
        with self.staggered_animation():
            t2.e_fade()
            t2.default_color(-2)
        with self.simultaneous():
            t2.e_append_morph(-2, r'\ \ecrossmark', RED)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.down()
        t1.explain("Assume angle CAB is less than angle FDE")
        t2.down()
        with self.staggered_animation():
            t2.e_fade()
        t2.math(r'\alpha < \delta')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Then length BC would less than EF, since it is "
                   "the triangle with the lesser angle (I.24), ")
        with self.staggered_animation():
            t2.e_fade()
            t2.e_normal(0, 1, -1)
        t2.math(r'\Rightarrow BC < EF')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("which leads to a contradiction")
        with self.staggered_animation():
            t2.e_fade()
            t2.red(-1, 2)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Therefore the original assumption that the angles "
                   "CAB is less than FDE is also wrong")
        with self.staggered_animation():
            t2.e_fade()
            t2.default_color(-2)
        with self.simultaneous():
            t2.e_append_morph(-2, r'\ \ecrossmark', RED)


        self.next_page()

        # ------------------------------------------------------------------------
        t1.down()
        t1.explain("Therefore angle CAB is greater than FDE")
        t2.down()
        with self.staggered_animation():
            t2.e_normal(3)
        t2.math(r'\therefore\  \alpha > \delta')


        self.next_page()

        # ------------------------------------------------------------------------
        with self.staggered_animation():
            t2.default_color(-1)
            t2.blue(slice(0,3))
