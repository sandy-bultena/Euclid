import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop12(Book1Scene):
    steps = []
    title = ("To draw a straight line perpendicular to a given infinite "
             "straight line from a given point not on it.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(500, 430))
        t3 = TextBox(mn_coord(700, 150), alignment='n', line_width=mn_scale(1000))

        l: Dict[str | int, ELine] = self.l
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        TMP = []

        A = mn_coord(80, 500)
        B = mn_coord(480, 500)
        C = mn_coord(255, 290)
        D = mn_coord(180, 525)

        # ----------------------------------------------
        # Definition
        # ----------------------------------------------
        t3.title("Definition - Right Angle")
        t3.down()
        t3.explain("When a straight line standing on a straight line makes "
                   "the adjacent angles equal to one another, each of the equal angles "
                   "is right, and the straight line standing on the other is called a "
                   "perpendicular to that on which it stands.")

        with self.simultaneous():
            p[1] = EPoint(mn_coord(100, 600), label=('A', LEFT))
            p[2] = EPoint(mn_coord(400, 600), label=('B', RIGHT))
            p[3] = EPoint(mn_coord(250, 600), label=('C', DOWN))
            p[4] = EPoint(mn_coord(250, 300), label=('D', UP))
            l[1] = ELine(p[1], p[3])
            l[2] = ELine(p[3], p[2])
            l[3] = ELine(p[4], p[3])
        with self.simultaneous():
            a[1] = EAngle(l[3], l[1], size=mn_scale(40))
            a[2] = EAngle(l[2], l[3], size=mn_scale(60))
        t2.math(r'\angle ACD = \angle BCD = \rightangle\ \text{(right angle)}')
        tmp = EGroup(*p.values(), *l.values(), *a.values())
        TMP.append(tmp)

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            TMP.pop().e_remove()
            t3.e_remove()
            t2.e_remove()

        # ----------------------------------------------
        # Construction
        # ----------------------------------------------
        t1.title("Construction:")
        t1.explain("Start with an arbitrary line segment AB and an "
                   "arbitrary point C not on the line")
        p['A'] = EPoint(A, label=('A', DOWN))
        p['B'] = EPoint(B, label=('B', DOWN))
        l['AB'] = ELine(A,B)
        p['C'] = EPoint(C, label=('C', UP))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Define another point D on the other side of the line")
        p['D'] = EPoint(D, label=('D', DOWN))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Construct a circle with center C, and radius CD")
        c['C'] = ECircle(C, D)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Define points E and F as the "
                   "intersection between line and the circle ")
        pts = c['C'].intersect(l['AB'])
        with self.simultaneous():
            p['F'] = EPoint(pts[0], label=('F', UP))
            p['E'] = EPoint(pts[1], label=('E', UP))
        c['C'].e_fade()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Bisect line EF at point G (I.9)")
        print()
        print()
        print("Bisecting line")
        p['D'].e_remove()
        l['EF'] = ELine(p['E'],p['F'])
        p['G'] = l['EF'].bisect(speed=2)
        print(p['G'])
        p['G'].add_label('G', DOWN)
        l['AB'].e_fade()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain('Create line CG')
        l['CG'] = ELine(C,p['G'])

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Line CG is perpendicular to EF")
        l['AE'], l['EG'], l['FG'], l['BF'] = l['AB'].e_split(*map(p.get, 'EGF'))
        with self.simultaneous():
            a['CGE'] = EAngle(*self.lines('CGE'))
            a['CGF'] = EAngle(*self.lines('FGC'))
        with self.simultaneous():
            l['AE'].e_fade()
            l['BF'].e_fade()
            l['EG'].e_fade()
            l['FG'].e_fade()

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t1.down()
        t1.title("Proof:")
        with self.simultaneous():
            a['CGE'].e_remove()
            a['CGF'].e_remove()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Create lines CE and CF")
        t1.explain("CE and CF are equal since they are radii of the same circle")
        c['C'].e_normal()
        with self.simultaneous():
            l['CG'].e_fade()
            l['EF'].e_fade()
            p['G'].e_fade()

        l['CE'] = ELine(C,p['E'], label=('r_1', dict(outside=True)))
        l['CF'] = ELine(C,p['F'], label=('r_1', dict(inside=True)))

        t2.math('CE = CF = r_1')

        self.next_page()

        # ------------------------------------------------------------------------
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

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Triangles ECG and FCG have three congruent sides ")
        with self.simultaneous():
            l['CE'].e_normal()
            l['CG'].e_normal()
            l['CF'].e_normal()

        with self.simultaneous():
            t[3] = ETriangle.assemble(lines=[l[x] for x in ('EG', 'CG', 'CE')]).e_fill(BLUE_D)
            t[2] = ETriangle.assemble(lines=[l[x] for x in ('FG', 'CF', 'CG')]).e_fill(GREEN_D)
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("hence the triangles are congruent, "
                   "and all the angles are congruent")
        with self.simultaneous():
            a['ECG'] = EAngle(*self.lines('ECG'), label=r'\alpha', size=mn_scale(30))
            a['FCG'] = EAngle(*self.lines('FCG'), label=r'\alpha')
            a['CEG'] = EAngle(*self.lines('CEG'), label=r'\beta', size=mn_scale(20))
            a['CFG'] = EAngle(*self.lines('CFG'), label=r'\beta', size=mn_scale(30))
            a['CGE'] = EAngle(*self.lines('CGE'), label=r'\gamma', size=mn_scale(30))
            a['CGF'] = EAngle(*self.lines('CGF'), label=r'\gamma')

        t2.math(r'\angle CGE = \angle CGF = \gamma')

        self.next_page()

        # ------------------------------------------------------------------------
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
