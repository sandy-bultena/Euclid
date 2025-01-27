import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop08(Book1Scene):
    steps = []
    title = ("If two triangles have the two sides equal to two "
             "sides respectively, and also have the base equal to the base, then they "
             "also have the angles equal which are contained by the equal straight lines.")

    def define_steps(self):
        t1 = TextBox(self, absolute_position=mn_coord(800, 150), line_width=to_manim_h_scale(550))
        t2 = TextBox(absolute_position=mn_coord(500, 330))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngle] = {}

        A = mn_coord(100, 450)
        B = mn_coord(300, 450)
        C = mn_coord(250, 200)

        D = mn_coord(550, 700)
        E = mn_coord(350, 700)
        F = mn_coord(400, 450)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t1.title("In other words:")
            t1.explain("Given two triangles with three sides of one "
                       "triangle equal to the three sides of the other "
                       "triangle (SSS)")

            t['ABC'] = EuclidTriangle(A, B, C, point_labels=[('A', LEFT), ('B', RIGHT), ('C', UP)])
            t['EDF'] = EuclidTriangle(E, D, F, point_labels=[('E', LEFT), ('D', RIGHT), ('F', UP)])

            t2.math('CB = EF')
            t2.math('AC = DF')
            t2.math('AB = ED')

        @self.push_step
        def _i2():
            t1.explain("Then the two triangles are equivalent in all respects")
            t2.math(r"\triangle ABC \equiv \triangle DEF")
            with self.simultaneous():
                t['ABC'].set_angles(r'\alpha', r'\beta', r'\theta')
            with self.simultaneous():
                t['EDF'].set_angles(r'\beta', r'\alpha', r'\theta')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof:")
            with self.simultaneous():
                t['ABC'].remove_angles()
                t['EDF'].remove_angles()

            p['A'], p['B'], p['C'] = t['ABC'].p
            with self.simultaneous():
                t2.e_remove()
            t2.math('AC = DF', fill_color=BLUE)
            t2.math('AB = ED', fill_color=BLUE)

        @self.push_step
        def _p2():
            t1.explain(r"Construct line segment BX equal to DE at point {nb:B <sub>I.2</sub>}")
            l['BX'], p['X'] = t['EDF'].l[0].copy_to_point(p['B'])
            p['X'].add_label('X', RIGHT)

            t['EDF'].l[0].e_fade()
            t2.math('BX = DE')

        @self.push_step
        def _p3():
            t1.explain("Align BX to AB. Since they are the same lengths, "
                       "the endpoints are congruent")
            l['BX'].red()
            p['X'].f_always.move_to(l['BX'].get_end)
            l['BX'].e_rotate_to(PI + t['ABC'].l[0].get_angle())(run_time=1)
            p['X'].clear_updaters()
            t['ABC'].p[0].lift()
            p['X'].add_label('X', DOWN)

        @self.push_step
        def _p4():
            t1.explain("Construct line segment BZ equal to EF at point {nb:B <sub>I.2</sub>}")
            l['BZ'], p['Z'] = t['EDF'].l[2].copy_to_point(p['B'], speed=2)
            p['Z'].add_label('Z', RIGHT)
            t['EDF'].l[2].e_fade()
            t2.math('BZ = EF')

        @self.push_step
        def _p5():
            t1.explain("Construct line segment AY equal to DF at point {nb:A <sub>I.2</sub>}")
            l['AY'], p['Y'] = t['EDF'].l[1].copy_to_point(p['A'], speed=2)
            p['Y'].add_label('Y', RIGHT)
            t['EDF'].l[1].e_fade()
            t2.math('AY = DF')

        @self.push_step
        def _p6():
            t1.explain("Where do ends of the lines BZ and AY meet?")
            with self.simultaneous():
                l['BZ'].remove_label()
                l['AY'].remove_label()

            p['Y'].f_always.move_to(l['AY'].get_end)
            p['Z'].f_always.move_to(l['BZ'].get_end)
            with self.simultaneous(run_time=1):
                l['BZ'].e_rotate_to(t['ABC'].l[1].get_angle() - 10 * DEGREES).red(run_time=1)
                l['AY'].e_rotate_to(t['ABC'].l[2].get_angle() - 5 * DEGREES + PI).red(run_time=1)
            with self.simultaneous():
                p['Z'].add_label('Z', UP)
                p['Y'].add_label('Y', UP)
            p['Y'].clear_updaters()
            p['Z'].clear_updaters()

        @self.push_step
        def _p7():
            t1.explain(r"They can only meet at one point, {nb:'C' <sub>(I.7)</sub>}")
            with self.simultaneous():
                p['Y'].e_remove()
                p['Z'].e_remove()

            with self.simultaneous(run_time=1):
                l['BZ'].e_rotate_to(t['ABC'].l[1].get_angle()).red()
                l['AY'].e_rotate_to(t['ABC'].l[2].get_angle() + PI).red()

        @self.push_step
        def _p8():
            t1.explain(r"Since all the endpoints of the lines are congruent, "
                       "then the angles must also be congruent")
            with self.simultaneous():
                EGroup(*t['EDF'].l).e_normal()

            with self.simultaneous():
                t['ABC'].draw_angles()
            with self.simultaneous():
                t['EDF'].draw_angles()

        @self.push_step
        def _p9():
            t1.explain("Thus the two triangles are equivalent")
            with self.simultaneous():
                t2.e_fade()
                t2.blue[0:3]
            t2.math(r"\triangle ABC \equiv \triangle DEF")
