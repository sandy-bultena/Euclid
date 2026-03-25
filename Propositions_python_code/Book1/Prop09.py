import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop09(Book1Scene):
    steps = []
    title = "To bisect a given rectilinear angle."

    def go(self):
        t1 = TextBox(absolute_position=mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(absolute_position=mn_coord(500, 430))

        l: Dict[str | int, ELine] = self.l
        p: Dict[str | int, EPoint] = self.p
        c: Dict[str | int, ECircle] = self.c
        t: Dict[str | int, ETriangle] = self.t
        a: Dict[str | int, EAngleBase] = self.a

        A = mn_coord(100, 400)
        B = mn_coord(400, 200)
        C = mn_coord(400, 500)

        self.next_page()

        # ------------------------------------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Start with two straight lines joined at a single point")
        l['AC_'] = ELine(B,A)
        l['AB_'] = ELine(A,C)
        p['A'] = EPoint(A, label=('A', DOWN))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Divide the resulting angle into two, using only a straight edge and compass")
        pt = l['AB_'].point(mn_scale(250))
        with self.pause_animations_for():
            p['B'] = EPoint(pt)
            c['A'] = ECircle(A, p['B'])
            pt = c['A'].intersect(l['AC_'])
            p['C'] = EPoint(pt[0])
            l['AB'] = ELine(A, p['B'])
            l['AC'] = ELine(A, p['C'])
            l['BC'] = ELine(p['B'], p['C'])
            t[1] = ETriangle.build_equilateral(p['C'], p['B'])
        l['CD'], l['BD'], p['D'] = t[1].l[2], t[1].l[1], t[1].p[2]
        l['AD'] = ELine(A, p['D'])
        a['DAC'] = EAngle(l['AD'],l['AC'], label=r'\alpha')
        a['DAB'] = EAngle(l['AD'],l['AB'], label=r'\alpha', size=mn_scale(50))

        self.next_page()

        # ------------------------------------------------------------------------
        # Construction
        # ----------------------------------------------
        t1.down()
        t1.title("Construction:")
        with self.simultaneous():
            l['AD'].e_remove()
            a['DAC'].e_remove()
            a['DAB'].e_remove()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Pick an arbitrary point B on one of the lines, and "
                   "construct another point C on the other line, such that AB and AC "
                   "are equal")
        p['B'].add_label('B', DOWN).e_draw()

        c['A'].e_draw()
        p['C'].add_label('C', UP).e_draw()
        l['AB'].e_draw()
        l['AC'].e_draw()
        t2.math('AC = AB', fill_color=BLUE)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Construct an equilateral triangle on line AC, "
                   r"and label the vertex {nb:D (I.1)}")
        c['A'].e_fade()
        l['BC'].e_draw()
        t[1] = ETriangle.build_equilateral(p['C'], p['B'])
        l['CD'], l['BD'], p['D'] = t[1].l[2], t[1].l[1], t[1].p[2]
        t[1].l[0].e_delete()
        p['D'].add_label('D', DOWN)
        t2.math('CB = BD = DC', fill_color=BLUE)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Create a line between points A and D")
        l['BC'].e_fade()
        l['AD'].e_draw()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Line AD bisects the angle CAB")
        with self.simultaneous():
            l['CD'].e_fade()
            l['BD'].e_fade()
        with self.simultaneous():
            a['DAC'].e_draw()
            a['DAB'].e_draw()
        t2.math(r'\measuredangle DAB = \measuredangle DAC')

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t1.down()
        t1.title("Proof:")
        with self.simultaneous():
            a['DAC'].e_remove()
            a['DAB'].e_remove()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Points B and C are equi-distance from point A since they "
                   "are the radii of the same circle")
        with self.simultaneous():
            l['AD'].e_fade()
            c['A'].e_normal()
            l['AB'].red()
            l['AC'].red()
        with self.simultaneous():
            t2.e_fade()
            t2.white(0)
            t2.math('AB = AC')

        self.next_page()

        # ------------------------------------------------------------------------
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

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Triangle ACD and ABD are congruent because they have "
                   r"three equal sides {nb: (I.8)}")
        with self.simultaneous():
            t[1].e_unfill()
            l['AD'].e_normal()
            l['BC'].e_remove()
            l['BD'].white()
            l['CD'].white()
        with self.simultaneous():
            t[3] = ETriangle(l['AB'], l['BD'], l['AD']).e_fill(GREEN_E)
            t[2] = ETriangle(l['AC'], l['CD'], l['AD']).e_fill(PINK)

        with self.simultaneous():
            t2.e_fade()
            t2.white(4, 3)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Hence, the angles are congruent as well")
        with self.simultaneous():
            a['DAC'].e_draw()
            a['DAB'].e_draw()
            a['ACD'] = EAngle(*self.lines('ACD'), label=r'\beta')
            a['ABD'] = EAngle(*self.lines('ABD'), label=r'\beta')
            a['CDA'] = EAngle(*self.lines('CDA'), label=r'\theta')
            a['BDA'] = EAngle(*self.lines('BDA'), label=r'\theta')

        with self.simultaneous():
            t2.math(r'\measuredangle CAD = \measuredangle DAB = \alpha')
            t2.math(r'\measuredangle ACD = \measuredangle ABD = \beta')
            t2.math(r'\measuredangle CDA = \measuredangle BDA = \theta')

        self.next_page()

        # ------------------------------------------------------------------------
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
            r'\measuredangle CAB = 2 \measuredangle CAD',
        )

        self.next_page()

        # ------------------------------------------------------------------------
        t1.down()
        t1.explain("Or angle CAD is half the angle CAB")
        with self.simultaneous():
            a['DAB'].e_remove()
            a['CAB'] = EAngle(*self.lines('CAB'), label=(r'2\alpha', 0.75), size=mn_scale(80))

        with self.simultaneous():
            t2.e_fade()
            t2.math(r'\measuredangle CAD = \frac{1}{2} \measuredangle CAB',
                    transform_from=-1,
                    transform_args=dict(
                        matched_keys=[r'\measuredangle CAD', r'\measuredangle CAB', r'='],
                        key_map={'2': r'\frac{1}{2}'},
                        path_arc=90 * DEGREES,
                    ))

