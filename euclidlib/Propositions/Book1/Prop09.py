import sys
import os
from cProfile import label

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop09(Book1Scene):
    steps = []
    title = "To bisect a given rectilinear angle."

    def define_steps(self):
        t1 = TextBox(absolute_position=mn_coord(800, 150), line_width=to_manim_h_scale(550))
        t2 = TextBox(absolute_position=mn_coord(500, 430))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngleBase] = {}

        A = mn_coord(100, 400)
        B = mn_coord(400, 200)
        C = mn_coord(400, 500)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            nonlocal A, B, C
            t1.title("In other words:")
            t1.explain("Start with two straight lines joined at a single point")
            l['AC_'] = EuclidLine('BA')
            l['AB_'] = EuclidLine('AC')
            p['A'] = EuclidPoint(A, label_args=('A', DOWN))

        @self.push_step
        def _i2():
            t1.explain("Divide the resulting angle into two, using only a straight edge and compass")
            pt = l['AB_'].point(mn_scale(250))
            with self.pause_animations_for():
                p['B'] = EuclidPoint(pt)
                c['A'] = EuclidCircle(A, p['B'])
                pt = c['A'].intersect(l['AC_'])
                p['C'] = EuclidPoint(pt[0])
                l['AB'] = EuclidLine(A, p['B'])
                l['AC'] = EuclidLine(A, p['C'])
                l['BC'] = EuclidLine(p['B'], p['C'])
                t[1], _ = EquilateralTriangle.build(p['C'], p['B'])
            l['CD'], l['BD'], p['D'] = t[1].l[2], t[1].l[1], t[1].p[2]
            l['AD'] = EuclidLine(A, p['D'])
            a['DAC'] = EuclidAngle('DAC', label=r'\alpha')
            a['DAB'] = EuclidAngle('DAB', label=r'\alpha', size=mn_scale(50))

        # ----------------------------------------------
        # Construction
        # ----------------------------------------------
        @self.push_step
        def _c1():
            t1.down()
            t1.title("Construction:")
            with self.simultaneous():
                l['AD'].e_remove()
                a['DAC'].e_remove()
                a['DAB'].e_remove()

        @self.push_step
        def _c2():
            t1.explain("Pick an arbitrary point B on one of the lines, and "
                       "construct another point C on the other line, such that AB and AC "
                       "are equal")
            p['B'].add_label('B', DOWN).e_draw()

        @self.push_step
        def _c3():
            c['A'].e_draw()
            p['C'].add_label('C', UP).e_draw()
            l['AB'].e_draw()
            l['AC'].e_draw()
            t2.math('AC = AB', fill_color=BLUE)

        @self.push_step
        def _c4():
            t1.explain("Construct an equilateral triangle on line AC, "
                       r"and label the vertex {nb:D <sub>(I.1)</sub>}")
            c['A'].e_fade()
            l['BC'].e_draw()
            t[1], _ = EquilateralTriangle.build(p['C'], p['B'])
            l['CD'], l['BD'], p['D'] = t[1].l[2], t[1].l[1], t[1].p[2]
            t[1].l[0].e_delete()
            p['D'].add_label('D', DOWN)
            t2.math('CB = BD = DC', fill_color=BLUE)

        @self.push_step
        def _c5():
            t1.explain("Create a line between points A and D")
            l['BC'].e_fade()
            l['AD'].e_draw()

        @self.push_step
        def _c6():
            t1.explain("Line AD bisects the angle CAB")
            with self.simultaneous():
                l['CD'].e_fade()
                l['BD'].e_fade()
            with self.simultaneous():
                a['DAC'].e_draw()
                a['DAB'].e_draw()
            t2.math(r'\angle DAB = \angle DAC')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof:")
            with self.simultaneous():
                a['DAC'].e_remove()
                a['DAB'].e_remove()

        @self.push_step
        def _p2():
            t1.explain("Points B and C are equi-distance from point A since they "
                       "are the radii of the same circle")
            with self.simultaneous():
                l['AD'].e_fade()
                c['A'].e_normal()
                l['AB'].red()
                l['AC'].red()
            with self.simultaneous():
                t2.e_fade()
                t2.white[0]
                t2.math('AB = AC')

        @self.push_step
        def _p3():
            t1.explain("Points B and C are equi-distance from point D since they "
                       "are sides of an equilateral triangle")
            with self.simultaneous():
                c['A'].e_remove()
                l['AB'].white()
                l['AC'].white()
            with self.simultaneous():
                l['BD'].red.e_normal()
                l['BC'].e_normal()
                l['CD'].red.e_normal()
                t[1].e_fill(BLUE_D)
                t2.e_fade()
                t2.white(1)
            t2.math("DB = DC")

        @self.push_step
        def _p4():
            t1.explain("Triangle ACD and ABD are congruent because they have "
                       r"three equal sides {nb: <sub>(I.8)</sub>}")
            with self.simultaneous():
                t[1].e_unfill()
                l['AD'].e_normal()
                l['BC'].e_remove()
                l['BD'].white()
                l['CD'].white()
            with self.simultaneous():
                t[3] = EuclidTriangle(l['AB'], l['BD'], l['AD']).e_fill(GREEN_E)
                t[2] = EuclidTriangle(l['AC'], l['CD'], l['AD']).e_fill(PINK)

            with self.simultaneous():
                t2.e_fade()
                t2.white(4, 3)

        @self.push_step
        def _p5():
            nonlocal l
            t1.explain("Hence, the angles are congruent as well")
            with self.simultaneous():
                a['DAC'].e_draw()
                a['DAB'].e_draw()
                a['ACD'] = EuclidAngle('ACD', label=r'\beta')
                a['ABD'] = EuclidAngle('ABD', label=r'\beta')
                a['CDA'] = EuclidAngle('CDA', label=r'\theta')
                a['BDA'] = EuclidAngle('BDA', label=r'\theta')

            with self.simultaneous():
                t2.math(r'\angle CAD = \angle DAB = \alpha')
                t2.math(r'\angle ACD = \angle ABD = \beta')
                t2.math(r'\angle CDA = \angle BDA = \theta')

        @self.push_step
        def _p6():
            t1.explain("Angle CAB is equal to twice angle CAD")
            with self.simultaneous():
                l['AC'].remove_label()
                l['AB'].remove_label()
                a['ACD'].e_remove()
                a['ABD'].e_remove()
                a['CDA'].e_remove()
                a['BDA'].e_remove()
                t[2].e_remove()
                t[3].e_remove()
            with self.simultaneous():
                l['CD'].e_remove()
                l['BD'].e_remove()
            with self.simultaneous():
                t2.e_fade()
                t2.white(5)
            t2.math(
                r'\angle CAB = 2 \times \angle CAD',
            )

        @self.push_step
        def _p7():
            nonlocal l
            t1.down()
            t1.explain("Or angle CAD is half the angle CAB")
            with self.simultaneous():
                a['DAB'].e_remove()
                a['CAB'] = EuclidAngle('CAB', label_args=(r'2\alpha', 0.75), size=mn_scale(80))

            with self.simultaneous():
                t2.e_fade()
                t2.math(r'\angle CAD = \frac{1}{2} \times \angle CAB',
                        transform_from=-1,
                        transform_args=dict(
                            matched_keys=[r'\angle CAD', r'\angle CAB', r'\times', r'='],
                            key_map={'2': r'\frac{1}{2}'},
                            path_arc=90 * DEGREES,
                        ))

