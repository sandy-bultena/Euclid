import math
import sys
import os
DEG = 180/math.pi

sys.path.append(os.getcwd())

from euclidlib.Scenes.book01 import Book1Scene
from euclidlib.Objects import *
from typing import Dict

# ********* What does freeze do? ******************
# if removing something, it doesn't get removed if its frozen??
# *************************************************

class Prop16(Book1Scene):
    steps = []
    title = ("In any triangle, if one of the sides is produced, "
             "then the exterior angle is greater than either of "
             "the interior and opposite angles.")

    def go(self):

        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(500, 430))

        l: Dict[str | int, ELine] = self.l
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(150, 200)
        B = mn_coord(100, 450)
        C = mn_coord(350, 450)
        D = mn_coord(450, 450)
        F = A - B + C

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Start with a triangle ABC")
        t['ABC'] = ETriangle(A, B, C,
                             point_labels=[('A', dict(away_from=B)),
                                                ('B', dict(away_from=A)),
                                                ('C', dict(away_from=F))])
        l['AB'], l['BC'], l['AC'] = t['ABC'].l

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Extend line BC to point D")
        l['CD'] = ELine(C, D)
        p['D'] = EPoint(D, label=('D', DOWN))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explainM(r"The angle $\measuredangle{ACD}$ is larger than either $\measuredangle{ABC}$ or $\measuredangle{CAB}$")
        a['a'] = EAngle(*self.lines('ACD'), size=mn_scale(20), label=(r'\alpha',))
        a['g'] = EAngle(*self.lines('CBA'), size=mn_scale(40), label=r'\gamma')
        a['b'] = EAngle(*self.lines('BAC'), label=r'\beta')

        t2.math(r'\alpha > \gamma')
        t2.math(r'\alpha > \beta')

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t1.down()
        t1.title("Proof:")

        t1.explain("Bisect line AC at point E (I.10)")
        with self.simultaneous():
            t2.e_remove()
        with self.simultaneous():
            a['a'].e_fade()
            a['b'].e_fade()
            a['g'].e_fade()
            l['AB'].e_fade()
            l['BC'].e_fade()
            l['CD'].e_fade()
        p['E'] = l['AC'].bisect(speed=2*self.default_speed)
        p['E'].add_label('E', mn.rotate_vector(l['AC'].get_unit_vector(), 90 * DEG))
        l['CE'], l['AE'] = l['AC'].e_split(p['E'])
        l['CE'].add_label('y', side=LineLabelSide.INSIDE)
        l['AE'].add_label('y')
        t2.math('AE = EC = y')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Create line segment BE")
        l['BE'] = ELine(B, p['E'], label='x')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain('Extend line BE to line F, where EF equals BE')
        with self.simultaneous():
            l['BF1'] = l['BE'].extend_cpy(p['E'].distance_to(B) + mn_scale(50))
            p['E'].add_label('E', dict(away_from=mn.midpoint(B, C)))
        c['E'] = ECircle(p['E'], B)
        pts = c['E'].intersect(l['BF1'])
        p['F'] = EPoint(pts[0], label=('F', dict(away_from=C)))
        c['E'].e_remove()

        tmp, l['EF'], x = l['BF1'].e_split(p['E'], p['F'])
        x.e_remove()
        l['EF'].add_label('x', side=LineLabelSide.INSIDE)
        tmp.e_delete()
        t2.math('BE = EF = x')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Angles AEB and CEF are vertical to each other, "
                   "hence they are {nb:equal (I.15)}")
        with self.simultaneous():
            a['th1'] = EAngle(*self.lines('AEB'), label=r'\theta', no_right=True)
            a['th2'] = EAngle(*self.lines('CEF'), label=r'\theta', no_right=True)
        t2.math(r'\measuredangle{AEB} = \measuredangle{CEF} = \theta')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Create line CF")
        l['CF'] = ELine(C,F)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Triangles ABE and FEC are equivalent since they "
                   "have two equal sides, with an equal angle AEB and FEC")
        l['AB'].e_normal()
        t['ABE'] = ETriangle.assemble(
            lines=self.lines('ABEA'), angles=[None, None, None]).e_fill(BLUE_D)
        t['CEF'] = ETriangle.assemble(lines=self.lines('CEFC')).e_fill(GREEN_D)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Thus, angles BAE and ECF are equal (I.4)")
        a['b'].e_normal()
        t['CEF'].set_angles((r'\beta', mn_scale(40)), None, None)
        t2.math(r'\measuredangle{BAE} = \measuredangle{ECF} = \beta')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("As can be seen angle ECF, which is equals to angle BAC, "
                   "is less than angle ACD")
        with self.simultaneous():
            t['ABE'].e_unfill()
            t['CEF'].e_unfill()

        with self.simultaneous():
            t['ABE'].l[1].e_remove()
            a['th1'].e_remove()
            t['CEF'].l[1].e_remove()
            a['th2'].e_remove()
            a['a'].e_normal()
            l['CD'].e_normal()

        t2.math(r'\measuredangle{ECF} = \measuredangle{BAC} < \measuredangle{ACD}')
        t2.math(r'\alpha > \beta')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.down()
        t1.explain("Thus it has been shown that the exterior "
                   "angle ACD is larger than the interior angle BAC")

        l['AC'].e_draw(skip_anim=True)
        with self.simultaneous():
            with self.freeze(l['AB']):
                t['CEF'].e_remove()
                t['ABE'].e_remove()
                p['E'].e_remove()
            l['BC'].e_normal().e_draw()
            t2.e_fade()
            t2.white(-1)
            l['CD'].e_normal()
        p['F'].e_remove()
        t['ABC'].e_fill(PINK)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.down()
        t1.explain("Using the same method as before, "
                   "we can prove that angle BCG is greater than ABC")

        t['ABC'].e_unfill()
        a['a'].e_normal()

        l['AG'] = t['ABC'].l[-1].copy()
        l['AG'].prepend(mn_scale(100))
        l['CG'] = ELine(C, l['AG'].get_start())
        l['AG'].e_remove()

        t['ABC'].p[-1].add_label('C', dict(buff=1.5 * EPoint.LabelBuff, towards=mn.midpoint(l['CG'].get_end(), D)))
        p['G'] = EPoint(l['CG'].get_end(), label=('G', dict(away_from=C)))
        a['BCG'] = EAngle(*self.lines('BCG'), size=mn_scale(20), label=(r'\alpha'))

        self.next_page()

        # ------------------------------------------------------------------------
        self.set_base_animation_speed(self.default_speed*3)
        p['E'] = l['BC'].bisect()
        p['E'].add_label('E', DOWN)
        l['BE'] = ELine(p['E'],B, label=('y', DOWN))
        l['CE'] = ELine(p['E'],C, label=('y', UP))
        l['AE'] = ELine(A,p['E'], label=('x', dict(side=LineLabelSide.INSIDE)))
        a['b'].e_fade()

        self.next_page()

        # ------------------------------------------------------------------------
        l['AF1'] = l['AE'].extend_cpy(p['E'].distance_to(A) + mn_scale(50))
        c['E'] = ECircle(p['E'], A)
        pts = c['E'].intersect(l['AF1'])
        p['F'] = EPoint(pts[0]).add_label('F',DOWN)
        F = p['F'].coordinates
        c['E'].e_remove()
        l['EF'] = ELine(p['E'],p['F'], label='x')
        l['AF1'].e_remove()

        self.next_page()

        # ------------------------------------------------------------------------
        l['CF'] = ELine(C, F)
        with self.simultaneous():
            t['ABE'] = ETriangle.assemble(lines=self.lines('ABEA'), angles=[None, None, None]).e_fill(GREEN_E)
            a['g'].e_normal()
            t['CEF'] = ETriangle.assemble(lines=self.lines('CEFC')).e_fill(BLUE_E)
            t['ABE'].set_angles(None, None, (r'\epsilon', mn_scale(20)))
            t['CEF'].set_angles(None, (r'\epsilon', mn_scale(20)), None)
            t['ABC'].e_fade()
            t['ABE'].e_normal()

        self.next_page()

        # ------------------------------------------------------------------------
        a['g'].e_normal()
        t['CEF'].set_angles((r'\gamma', mn_scale(60)), None, None)

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t['ABE'].e_unfill()
            t['CEF'].e_unfill()
            p['E'].e_remove()

            with t['CEF'].angles[0].as_frozen():
                t['ABE'].remove_labels()
                t['CEF'].remove_labels()

            t['ABE'].l[-1].e_remove()
            t['ABE'].a[-1].e_remove()
            t['CEF'].l[1].e_remove()
            t['CEF'].a[1].e_remove()

        self.set_base_animation_speed(self.default_speed)
        t2.math(r'\alpha > \gamma')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            with self.freeze(l['AB'], a['b'], a['a']):
                t['ABE'].e_remove()
                t['CEF'].e_remove()
            with self.simultaneous():
                a['a'].e_draw()
                a['b'].e_normal()
                p['F'].e_remove()
                p['G'].e_remove()
                l['CG'].e_remove()
                a['BCG'].e_remove()
                t['ABC'].e_normal()
                t['ABC'].e_fill(PINK)



