import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop11(Book1Scene):
    steps = []
    title = ("To draw a straight line at right angles to a given "
             "straight line from a given point on it.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=to_manim_h_scale(550))
        t2 = TextBox(mn_coord(500, 430))
        t3 = TextBox(mn_coord(700, 150), alignment='n', line_width=mn_scale(1000))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngleBase] = {}

        A = mn_coord(100, 400)
        B = mn_coord(450, 400)

        TMP = []

        # ----------------------------------------------
        # Definition
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t3.title("Definition - Right Angle")
            t3.down()
            t3.explain("When a straight line standing on a straight line makes "
                       "the adjacent angles equal to one another, each of the equal angles "
                       "is right, and the straight line standing on the other is called a "
                       "perpendicular to that on which it stands.")

            with self.simultaneous():
                p[1] = EuclidPoint(mn_coord(100, 600), label=('A', LEFT))
                p[2] = EuclidPoint(mn_coord(400, 600), label=('B', RIGHT))
                p[3] = EuclidPoint(mn_coord(250, 600), label=('C', DOWN))
                p[4] = EuclidPoint(mn_coord(250, 300), label=('D', UP))
                l[1] = EuclidLine(p[1], p[3])
                l[2] = EuclidLine(p[3], p[2])
                l[3] = EuclidLine(p[4], p[3])
            with self.simultaneous():
                a[1] = EuclidAngle(l[3], l[1], size=mn_scale(40))
                a[2] = EuclidAngle(l[2], l[3], size=mn_scale(60))
            t2.math(r'\angle ACD = \angle BCD = \rightangle \text{(right angle)}')
            tmp = EGroup(*p.values(), *l.values(), *a.values())
            TMP.append(tmp)

        @self.push_step
        def _i2():
            with self.simultaneous():
                TMP.pop().e_remove()
                t3.e_remove()
                t2.e_remove()

        # ----------------------------------------------
        # Construction
        # ----------------------------------------------
        @self.push_step
        def _c1():
            t1.title("Construction:")
            t1.explain("Start with a line segment AB, and an arbitrary "
                       "point C on this line")
            p['A'] = EuclidPoint(A, label=('A', LEFT))
            p['B'] = EuclidPoint(B, label=('B', RIGHT))
            l['AB'] = EuclidLine('AB')
            p['C'] = EuclidPoint(l['AB'].point_from_proportion(0.55), label=('C', DOWN))
            l['AC'], l['BC'] = l['AB'].e_split(p['C'])

        @self.push_step
        def _c2():
            t1.explain("Define another point D on line AB")
            p['D'] = EuclidPoint(l['AC'].point_from_proportion(0.28), label=('D', DOWN))
            c['C'] = EuclidCircle(p['C'], p['D'])
            pt = c['C'].intersect(l['BC'])
            t1.explain("Define point E such that EC equals CD")
            p['E'] = EuclidPoint(pt[0], label=('E', DOWN))
            l['CE'], l['EB'] = l['BC'].e_split(p['E'])
            l['AD'], l['CD'] = l['AC'].e_split(p['D'])

        @self.push_step
        def _c3():
            c['C'].e_fade()
            t1.explain("Construct an equilateral triangle on DE and label the vertex {nb:F"
                       "<sub>(I.1)</sub>}")
            t[1] = EquilateralTriangle.build(p['D'], p['E'], speed=2)
            l['DF'], l['EF'], p['F'] = t[1].l[2], t[1].l[1], t[1].p[-1]
            p['F'].add_label('F', UP)

        @self.push_step
        def _c4():
            t1.explain("Construct line segment FC")
            l['CF'] = EuclidLine(p['F'], p['C'])

        @self.push_step
        def _c5():
            t1.explain("Angle ACF and angle BCF are right angles")
            a['ACF'] = EuclidAngle('FCA')
            a['BCF'] = EuclidAngle('BCF', size=mn_scale(50))
            with self.simultaneous():
                l['DF'].e_fade()
                l['EF'].e_fade()

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof:")
            a['ACF'].e_remove()
            a['BCF'].e_remove()

        @self.push_step
        def _p2():
            t1.explain("Line DC equals line CE since they are radii of the same circle")
            c['C'].e_normal()
            with self.simultaneous():
                l['CD'].add_label('r_1', DOWN)
                l['CE'].add_label('r_1', DOWN)
            t2.math('DC = CE = r_1')

        @self.push_step
        def _p3():
            c['C'].e_fade()
            t1.explain("FD and FE are equal since they are two "
                       "sides of an equilateral triangle")
            with self.simultaneous():
                l['DF'].e_normal().add_label('r_2', outside=True)
                l['EF'].e_normal().add_label('r_2', outside=True)
            t2.math('FD = FE = r_2')

        @self.push_step
        def _p4():
            c['C'].e_fade()
            t1.explain("Triangle DCF and triangle FCE have all three "
                       "sides equal to each other, "
                       "thus all the angles are equal to each {nb:other <sub>(I.8)</sub>}")
            with self.simultaneous():
                t[3] = EuclidTriangle.assemble(lines=[l['DF'], l['CF'], l['CD']]).e_fill(BLUE_D)
                t[2] = EuclidTriangle.assemble(lines=[l['EF'], l['CF'], l['CE']]).e_fill(GREEN_D)

            with self.simultaneous():
                a['CDF'] =  EuclidAngle('CDF', label=r'\beta')
                a['CEF'] =  EuclidAngle('CEF', label=r'\beta')
                a['DFC'] =  EuclidAngle('DFC', label=r'\theta', size=mn_scale(50))
                a['CFE'] =  EuclidAngle('CFE', label=r'\theta', size=mn_scale(60))
                a['ACF'] =  EuclidAngle('ACF', label=r'\alpha')
                a['BCF'] =  EuclidAngle('BCF', label=r'\alpha', size=mn_scale(30))

            with self.simultaneous():
                t2.math(r'\angle CDF = \angle CEF = \beta')
                t2.math(r'\angle DFC = \angle EFC = \theta')
                t2.math(r'\angle FCD = \angle FCE = \alpha')

        @self.push_step
        def _p4():
            t1.explain("Angles FCD and FCE are equal, and therefore are 'right angles'")
            with self.simultaneous():
                a['CDF'].e_remove()
                a['CEF'].e_remove()
                a['DFC'].e_remove()
                a['CFE'].e_remove()
            with self.simultaneous():
                t[3].e_unfill()
                t[2].e_unfill()
            with self.simultaneous():
                l['DF'].e_fade()
                l['EF'].e_fade()
            with self.simultaneous():
                l['CD'].remove_label()
                l['CE'].remove_label()
                a['ACF'].remove_label()
                a['BCF'].remove_label()

            t2.blue(-1)
