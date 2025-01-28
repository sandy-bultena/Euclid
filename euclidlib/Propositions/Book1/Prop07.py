import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop07(Book1Scene):
    steps = []
    title = ("Given two straight lines constructed from the ends of a straight "
             "line and meeting in a point, there cannot be constructed from the "
             "ends of the same straight line, and on the same side of it, two "
             "other straight lines meeting in another point and equal to the former "
             "two respectively, namely each equal to that from the same end.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(500, 330), line_width=mn_h_scale(550))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngleBase] = {}

        A = mn_coord(450, 650)
        B = mn_coord(200, 650)
        C = mn_coord(280, 270)
        D = mn_coord(400, 270)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            nonlocal A, B, C
            t1.title("In other words:")
            t1.explain("Given a triangle ABC")
            t1.explain("There is a unique point C where the sides of "
                       "the triangle, AC and BC, meet")

            t['ABC'] = EuclidTriangle('ABC',
                                      point_labels=[('A', DOWN), ('B', DOWN), ('C', UP)],
                                      labels=[(), ('r_2', RIGHT), ('r_1', LEFT)])
            p['A'], p['B'], p['C'] = t['ABC'].p

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof by Contradiction:")
            t1.explain("Assume there is a point D where AD is equal in "
                       "length to AC and BD is equal in length to BC")
            t1.explain("Create triangle ABD")

            nonlocal D
            t['ABD'] = EuclidTriangle('ABD',
                                      point_labels=[(), (), ('D', UP)],
                                      labels=[(), ('r_2', RIGHT), ('r_1', LEFT)])
            p['D'] = t['ABD'].p[-1]
            t2.math('AC = AD = r_1')
            t2.math('BC = BD = r_2')

        @self.push_step
        def _p2():
            t1.explain("Construct line CD, thus creating triangles ACD and BCD")

            nonlocal p
            l['CD'] = EuclidLine('CD')
            t['CAD'] = EuclidTriangle(t['ABC'].l[-1], t['ABD'].l[-1], l['CD'])
            t['CBD'] = EuclidTriangle(t['ABC'].l[1], t['ABD'].l[1], l['CD'])
            with self.simultaneous():
                t['ABC'].e_fade()
                t['ABD'].e_fade()
                l['CD'].e_fade()
                EGroup(*t['ABC'].p).e_normal()
                p['D'].e_normal()
            with self.simultaneous():
                t['CBD'].e_fill(TEAL_D)
                t['CAD'].e_fill(BLUE_D)

        @self.push_step
        def _p3():
            with self.simultaneous():
                t['CBD'].e_fade()
            t1.explain("Triangle ACD is an isosceles triangle by "
                       "definition, so the base angles must be equal <sub>(I.6)</sub>")
            t['CAD'].set_angles(r'\alpha', None, r'\alpha', mn_scale(20), 0, mn_scale(55))
            t2.e_fade(*t2.except_index(0))
            t2.math(r'\angle ACD = \angle CDA = \alpha')

        @self.push_step
        def _p4():
            with self.simultaneous():
                t['CAD'].e_fade()
                t['CBD'].e_normal()
            t1.explain("Triangle BCD is an isosceles triangle by definition, "
                       "so the base angles must be equal <sub>(I.6)</sub>")
            t['CBD'].set_angles(r'\beta', None, r'\beta', mn_scale(55), 0, mn_scale(20))
            with self.simultaneous():
                t2.white(1)
                t2.e_fade(*t2.except_index(1))
            t2.math(r'\angle BCD = \angle CDB = \beta')

        @self.push_step
        def _p5():
            with self.simultaneous():
                t['CAD'].e_normal()
                t['CAD'].e_normal()
                t['CAD'].l[1].e_fade()
                t['CAD'].a[2].e_fade()
                t['CBD'].l[1].e_fade()
                t['CBD'].a[2].e_fade()


            t1.explainM("Looking at the figure, we can see that angle DCA~"
                        r"($\alpha$) is less than angle DCB~($\beta$)")

            with self.simultaneous():
                t2.white(2, 3)
                t2.e_fade(*t2.except_index(2, 3))

            t2.math(r'\angle ACD < \angle BCD')
            t2.math(r'\alpha\quad<\quad\beta', align_str='<')

        @self.push_step
        def _p6():
            with self.simultaneous():
                t['CAD'].e_normal()
                t['CBD'].e_normal()
                t['CAD'].l[0].e_fade()
                t['CAD'].a[0].e_fade()
                t['CBD'].l[0].e_fade()
                t['CBD'].a[0].e_fade()

            t1.explainM(r"Similarly, angle CDA~($\alpha$) is greater than angle CDB~($\beta$)")

            with self.simultaneous():
                t2.white(2, 3)
                t2.e_fade(*t2.except_index(2, 3))

            t2.math(r'\angle CDA > \angle CDB')
            t2.math(r'\alpha\quad>\quad\beta', align_str='>')


        @self.push_step
        def _p7():
            with self.simultaneous():
                t['CAD'].e_normal()
                t['CBD'].e_normal()

            t1.explain("But, since angle CDA is equal to DCA, "
                       "and angle DCB is equal to angle CDB "
                       "we have CDA simultaneously bigger and less than DBC")
            t1.explain("This is impossible")

            with self.simultaneous():
                t2.red(5, 7)
                t2.e_fade(*t2.except_index(5, 7))


        @self.push_step
        def _p8():
            with self.simultaneous():
                t['ABC'].e_normal()
                t['CAD'].e_remove()
                l['CD'].e_remove()
                t['CBD'].e_remove()


            t1.explain("Thus, we have demonstrated that point D "
                       "cannot exist, and the point C is unique.")

            with self.simultaneous():
                t['ABD'].e_normal()

            t['ABD'].p[-1].add_label('C', UP)
            #with self.simultaneous():
            t['ABD'].move_point_to(-1, t['ABC'].p[-1])

            t2.e_fade()
