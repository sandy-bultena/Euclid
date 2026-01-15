import sys
import os

sys.path.append(os.getcwd())
from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Book1Prop4(Book1Scene):
    steps = []
    title = (
        "If two triangles have two sides equal to two sides respectively, "
        "and have the angles contained by the equal straight lines equal, "
        "then they also have the base equal to the base, the triangle equals "
        "the triangle, and the remaining angles equal the remaining angles "
        "respectively, namely those opposite the equal sides."
    )

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 200), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(40, 400), line_width=mn_h_scale(550))
        t3 = TextBox(mn_coord(100, 500), line_width=mn_h_scale(800))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, Angel] = {}

        A = mn_coord(300, 250)
        B = mn_coord(100, 250)
        C = mn_coord(250, 450)

        D = mn_coord(400, 400)
        E = mn_coord(600, 400)
        F = mn_coord(450, 200)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t1.title("In other words:")
            t1.explain(
                "If two triangles have two sides which are "
                "equivalent, and if the angles between the two "
                "sides are also equivalent, "
                "(side-angle-side SAS)..."
            )
            t2.math("AB = DE")
            t2.math("AC = DF")
            t2.math(r"\measuredangle BAC = \measuredangle FDE")

            t['ABC'] = ETriangle(A, B, C,
                                 scene=self,
                                 point_labels=[('A', dict(away_from='center_f')), ('B', dict(away_from='center_f')),
                                                    ('C', dict(away_from='center_f'))],
                                 labels=[('x', dict(outside=True)), (), ('y', dict(inside=True))],
                                 angles=[r'\alpha', None, None, mn_scale(20)]
                                 )

            t['DEF'] = ETriangle(D, E, F,
                                 scene=self,
                                 point_labels=[('D', dict(away_from='center_f')), ('E', dict(away_from='center_f')),
                                                    ('F', dict(away_from='center_f'))],
                                 labels=[('x', dict(inside=True)), (), ('y', dict(outside=True))],
                                 angles=[r'\alpha', None, None]
                                 )

        @self.push_step
        def _i2():
            t1.explain("... then they are equal in all respects")
            t2.math(r"\triangle ABC = \triangle DEF")
            with self.simultaneous():
                t['ABC'].set_labels((), ('z', RIGHT), ())
            with self.simultaneous():
                t['DEF'].set_labels((), ('z', LEFT), ())
            with self.simultaneous():
                t['ABC'].set_angles(None, r'\gamma', r'\beta')
            with self.simultaneous():
                t['DEF'].set_angles(None, r'\gamma', r'\beta')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t2.e_remove()
            with self.simultaneous():
                t['ABC'].l[1].remove_label()
                t['DEF'].l[1].remove_label()
                t['ABC'].a[1].e_remove()
                t['DEF'].a[1].e_remove()
                t['ABC'].a[2].e_remove()
                t['DEF'].a[2].e_remove()
            t1.title("Proof:")
            t2.math("AB = DE")
            t2.math("AC = DF")
            t2.math(r"\measuredangle BAC = \measuredangle FDE")

        @self.push_step
        def _p2():
            t1.explain("Move triangle ABC such that point A coincides "
                       "with point{nb}D")

            with self.simultaneous():
                t['ABC'].green()
            with self.simultaneous():
                t['ABC'].lift.e_move(np.array([D[0] - A[0], D[1] - A[1], 0]))(run_time=2)

        @self.push_step
        def _p3():
            t1.explain("Rotate the triangle so that line AB line coincides with DE.")
            t1.explain("... diagram is offset a bit so we can see more clearly")

            t['DEF'].l[0].red()
            with self.simultaneous():
                t['DEF'].remove_labels()

            with self.simultaneous():
                t['ABC'].e_rotate(D, PI)(run_time=2)

            with self.simultaneous():
                t['ABC'].e_move(mn_scale(20, -10, 0))(run_time=1)

            t['ABC'].l[0].red()

        @self.push_step
        def _p4():
            t1.explain("Since lines AB and DE are the same lengths, "
                       "the endpoints are congruent")

            with self.simultaneous(run_time=1):
                t['ABC'].white()
                t['DEF'].white()
            with self.simultaneous(run_time=1):
                t['DEF'].l[1].e_fade()
                t['DEF'].l[2].e_fade()
                t['ABC'].l[1].e_fade()
                t['ABC'].l[2].e_fade()

                t['DEF'].a[0].e_remove()
                t['ABC'].a[0].e_remove()

                t['ABC'].p[2].e_fade()
                t['DEF'].p[2].e_fade()

            # t['ABC'].p[0].notice()
            # t['DEF'].p[0].notice()
            # t['ABC'].p[1].notice()
            # t['DEF'].p[1].notice()

            t2.e_fade()
            t2.e_normal.blue(0)
            t2.math("A = D")
            t2.math("B = E")

        @self.push_step
        def _p5():
            t1.explain("Line AC coincides with DF since they are the "
                       "same length and the angles "
                       "BAC and EDF are equal ")

            t['DEF'].a[0].e_draw()
            a['ABC'] = EAngle(t['ABC'].l[0], t['ABC'].l[2], label=r'\alpha', size=mn_scale(20), scene=self)
            with self.simultaneous():
                t['ABC'].l[2].e_normal()
                t['DEF'].l[2].e_normal()
                t['ABC'].p[2].e_normal()
                t['DEF'].p[2].e_normal()

            t2.white.e_fade()
            t2.e_normal.blue(1, 2)
            t2.math("C = F")
            t2.math("AC = DF")

        @self.push_step
        def _p6():
            t1.explain("Since the points B coincides with E and C with F, "
                       "then the lines BC coincides with EF"
                       "... based on the implicit  understanding that there is only one "
                       "straight path"
                       " between two points")

            t2.e_fade()
            t2.e_normal.white(4, 5)

            with self.simultaneous():
                a['ABC'].e_fade()
                t['DEF'].a[0].e_fade()

            # with self.simultaneous():
            #     t['ABC'].p[1].notice()
            #     t['DEF'].p[1].notice()
            #     t['ABC'].p[2].notice()
            #     t['DEF'].p[2].notice()

            with self.simultaneous():
                t['ABC'].p[0].e_fade()
                t['DEF'].p[0].e_fade()
                t['ABC'].p[1].red()
                t['DEF'].p[1].red()
                t['ABC'].p[2].red()
                t['DEF'].p[2].red()

            with self.simultaneous():
                t['ABC'].l[0].e_fade()
                t['DEF'].l[0].e_fade()
                t['ABC'].l[2].e_fade()
                t['DEF'].l[2].e_fade()

            with self.simultaneous():
                t['ABC'].l[1].e_normal()
                t['DEF'].l[1].e_normal()

            t2.white.e_fade()
            t2.e_normal.blue(1, 2)
            t2.math("C = F")
            t2.math("AC = DF")

        @self.push_step
        def _p7():
            t1.explain("From common notion 4, things which coincide "
                       "with one another, equal one another")

            t2.e_normal.white()
            t2.blue(*range(3))

            with self.simultaneous():
                t['ABC'].e_fade.white()
                t['DEF'].e_fade.white()

            t2.math(r"\triangle ABC \equiv \triangle DEF")
