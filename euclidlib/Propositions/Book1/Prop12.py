import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop12(Book1Scene):
    steps = []
    title = ("To draw a straight line perpendicular to a given infinite "
             "straight line from a given point not on it.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(500, 430))
        t3 = TextBox(mn_coord(700, 150), alignment='n', line_width=mn_h_scale(1000))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngleBase] = {}
        TMP = []

        A = mn_coord(80, 500)
        B = mn_coord(480, 500)
        C = mn_coord(255, 290)
        D = mn_coord(180, 525)

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
            t1.explain("Start with an arbitrary line segment AB and an "
                       "arbitrary point C not on the line")
            p['A'] = EuclidPoint(A, label=('A', DOWN))
            p['B'] = EuclidPoint(B, label=('B', DOWN))
            l['AB'] = EuclidLine('AB')
            p['C'] = EuclidPoint(C, label=('C', UP))

        @self.push_step
        def _c2():
            t1.explain("Define another point D on the other side of the line")
            p['D'] = EuclidPoint(D, label=('D', DOWN))

        @self.push_step
        def _c3():
            t1.explain("Construct a circle with center C, and radius CD")
            c['C'] = EuclidCircle(C, D)

        @self.push_step
        def _c4():
            t1.explain("Define points E and F as the "
                       "intersection between line and the circle ")
            pts = c['C'].intersect(l['AB'])
            with self.simultaneous():
                p['F'] = EuclidPoint(pts[0], label=('F', UP))
                p['E'] = EuclidPoint(pts[1], label=('E', UP))
            c['C'].e_fade()

        @self.push_step
        def _c5():
            t1.explain("Bisect line EF at point G <sub>(I.9)</sub>")
            p['D'].e_remove()
            l['EF'] = EuclidLine('EF')
            p['G'] = l['EF'].bisect().add_label('G', DOWN)
            l['AB'].e_fade()

        @self.push_step
        def _c6():
            nonlocal p
            t1.explain('Create line CG')
            l['CG'] = EuclidLine('CG')

        @self.push_step
        def _c7():
            t1.explain("Line CG is perpendicular to EF")
            l['AE'], l['EG'], l['FG'], l['BF'] = l['AB'].e_split(*map(p.get, 'EGF'))
            with self.simultaneous():
                a['CGE'] = EuclidAngle('CGE')
                a['CGF'] = EuclidAngle('FGC')
            with self.simultaneous():
                l['AE'].e_fade()
                l['BF'].e_fade()
                l['EG'].e_fade()
                l['FG'].e_fade()

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof:")
            with self.simultaneous():
                a['CGE'].e_remove()
                a['CGF'].e_remove()

        @self.push_step
        def _p2():
            t1.explain("Create lines CE and CF")
            t1.explain("CE and CF are equal since they are radii of the same circle")
            c['C'].e_normal()
            with self.simultaneous():
                l['CG'].e_fade()
                l['EF'].e_fade()
                p['G'].e_fade()

            l['CE'] = EuclidLine('CE', label=('r_1', dict(outside=True)))
            l['CF'] = EuclidLine('CF', label=('r_1', dict(inside=True)))

            t2.math('CE = CF = r_1')

        @self.push_step
        def _p3():
            c['C'].e_fade()
            t1.explain("EG and GF are equal since G bisects EF")
            with self.simultaneous():
                l['EF'].e_normal()
                l['EG'].e_normal()
                p['G'].e_normal()
                l['CE'].e_fade()
                l['CF'].e_fade()

            with self.simultaneous():
                l['EG'].add_label('r_2', dict(outside=True))
                l['FG'].add_label('r_2', dict(outside=True))

            t2.math('EG = GF = r_2')

        @self.push_step
        def _p4():
            t1.explain("Triangles ECG and FCG have three congruent sides ")
            with self.simultaneous():
                l['CE'].e_normal()
                l['CG'].e_normal()
                l['CF'].e_normal()

            with self.simultaneous():
                t[3] = EuclidTriangle.assemble(lines=[l[x] for x in ('EG', 'CG', 'CE')]).e_fill(BLUE_D)
                t[2] = EuclidTriangle.assemble(lines=[l[x] for x in ('FG', 'CF', 'CG')]).e_fill(GREEN_D)

        @self.push_step
        def _p5():
            t1.explain("hence the triangles are congruent, "
                       "and all the angles are congruent")
            nonlocal l
            with self.simultaneous():
                a['ECG'] = EuclidAngle('ECG', label=r'\alpha', size=mn_scale(30))
                a['FCG'] = EuclidAngle('FCG', label=r'\alpha')
                a['CEG'] = EuclidAngle('CEG', label=r'\beta', size=mn_scale(20))
                a['CFG'] = EuclidAngle('CFG', label=r'\beta', size=mn_scale(30))
                a['CGE'] = EuclidAngle('CGE', label=r'\gamma', size=mn_scale(30))
                a['CGF'] = EuclidAngle('CGF', label=r'\gamma')

            t2.math(r'\angle CGE = \angle CGF = \gamma')

        @self.push_step
        def _p6():
            t1.explain("Since CGE and CGF are equal, and EF is a line, by definition "
                       "the angles are right angles, and CG is perpendicular to EF")

            with self.simultaneous():
                a['ECG'].e_remove()
                a['FCG'].e_remove()
                a['CEG'].e_remove()
                a['CFG'].e_remove()
            with self.simultaneous():
                t[3].e_unfill()
                t[2].e_unfill()
            with self.simultaneous():
                l['CE'].e_fade()
                l['CF'].e_fade()
            with self.simultaneous():
                l['EG'].remove_label()
                l['FG'].remove_label()
                a['CGE'].remove_label()
                a['CGF'].remove_label()

            t2.e_update(-1, r'\angle CGE = \angle CGF = \rightangle',
                    fill_color=BLUE,
                    transform_args=dict(
                        matched_keys=[r'\angle CGE = \angle CGF = '],
                        key_map={r'\gamma': r'\rightangle'},
                    ))
