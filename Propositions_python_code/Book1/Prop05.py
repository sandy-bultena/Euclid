import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop05(Book1Scene):
    steps = []
    title = ("In isosceles triangles the angles at the base equal one another, and, "
             "if the equal straight lines are produced further, "
             "then the angles under the base equal one another.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(400, 180))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        a: Dict[str | int, EAngleBase] = {}
        t: Dict[str | int, ETriangle] = {}

        A = mn_coord(200, 200)
        B = mn_coord(300, 440)
        C = mn_coord(100, 440)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Given an isosceles triangle ABC")
        t['ABC'] = ETriangle(A, C, B,
                             point_labels=[('A', UP), ('C', LEFT), ('B', RIGHT)],
                             angles=[r'\gamma', None, None],
                             labels=['r',None,'r'],
                             )
        l['AC'], l['BC'], l['AB'] = t['ABC'].l
        p['A'], p['C'], p['B'] = t['ABC'].p
        t2.math("AB = AC = r", fill_color=BLUE)
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Then the angles at the base ACB and ABC are equal")
        t2.math(r"\alpha = \theta")
        t['ABC'].set_angles(None, r'\alpha', r'\theta',
                            None, mn_scale(30), mn_scale(30))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("In addition, if we extend lines AB and AC")
        with self.simultaneous():
            l['BY'] = l['AB'].extend_cpy(mn_scale(-150))
            l['CZ'] = l['AC'].extend_cpy(mn_scale(150))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Then the exterior angles are equal")
        with self.simultaneous():
            a['YBC'] = EAngle(l['BC'], l['BY'], label=r'\beta')
            a['ZCB'] = EAngle(l['BC'], l['CZ'], label=r'\delta')
        t2.math(r"\beta = \delta")

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ------------------------------------------------------------------------
        with self.simultaneous():
            t1.e_remove()
            t2.e_remove()
            a['YBC'].e_remove()
            a['ZCB'].e_remove()
            t['ABC'].a[1].e_remove()
            t['ABC'].a[2].e_remove()
            l['BY'].e_fade()
            l['CZ'].e_fade()


        t1.title("Proof:")
        t2.math("AB = AC = r", is_axiom=True)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Define a point along the extension of AB")
        D = l['BY'].point(mn_scale(100))
        p['D'] = EPoint(D, label_args=('D', dict(away_from=C)))
        l['BD'] = ELine(B, D)
        l['BD'].add_label('x', inside=True)
        t2.math('BD = x')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Construct a line starting at C, with length BD, "
                   "on the line {nb:segment AC (I.2)}")
        l['CE'], p['E'] = l['BD'].copy_to_line(p['C'], l['CZ'], speed=2)
        l['CE'].add_label('x',outside=True)
        p['E'].add_label('E', away_from=B)
        t2.math("BD = CE = x")

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("AC and AB are equal, as are BD and CE, thus AE and AD which "
                   "are the sum of AC,CE and AB,BD respectively, are also equal")
        t2.math("AE = r + x")
        t2.math("AD = r + x")
        t2.math("AE = AD")

        self.next_page()

        # ------------------------------------------------------------------------
        l['BC'].e_fade()
        t1.explain("Create triangle AEB")
        t2.down(mn.MED_SMALL_BUFF)
        l['BE'] = ELine(B, p['E'])
        t['AEB'] = ETriangle(p['E'], p['A'], p['B']).e_fill(BLUE_E)
        t2.e_fade()
        t2.math(r'AE=x+r, \quad\measuredangle EAB = \gamma, \quad AB = r')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Create triangle ADC")
        with self.simultaneous():
            l['CZ'].e_fade()
            t['AEB'].e_unfill()
            l['BC'].e_fade()
            l['CE'].e_fade()
            l['BE'].e_fade()
            l['BY'].e_fade()
            l['BD'].e_normal()
            l['AC'].e_remove()
        with self.simultaneous():
            l['AC'] = ELine(A, C, label_args=('r',dict(outside=True)))
            l['CD'] = ELine(C, p['D'])
        t['ADC'] = ETriangle(p['C'], p['A'], p['D']).e_fill(BLUE_E)
        t2.math(r'AD=x+r,\quad \measuredangle DAC = \gamma,\quad AC = r')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Since two sides and the angle between are "
                   "the same for both triangles, ")

        with self.simultaneous():
            l['CE'].e_normal()
            l['BE'].e_normal()

        pts = l['CD'].intersect(l['BE'])

        t['AEB'].e_fill(BLUE_E)

        t2.e_fade(*t2.except_index(4, 0, 6, 7))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("then all the sides and angles are {nb:equal (I.4)}")
        with self.simultaneous():
            a['ACD'] = EAngle(l['CD'], l['AC'], size=mn_scale(40), label=r'\delta')
            a['ABE'] = EAngle(l['AB'], l['BE'], size=mn_scale(40), label=r'\delta')

        t2.down(MED_SMALL_BUFF)

        with self.simultaneous():
            a['CDB'] = EAngle(l['BD'], l['CD'], size=mn_scale(20), label=r'\sigma')
            a['CEB'] = EAngle(l['BE'], l['CE'], size=mn_scale(20), label=r'\sigma')
            l['CD'].add_label('y',outside=True, alpha=0.7 )
            l['BE'].add_label('y', inside=True, alpha=0.7)
        t2.math('CD = BE = y')
        t2.math(r'\measuredangle ACD = \measuredangle ABE = \delta')
        t2.math(r'\measuredangle CDA = \measuredangle BEA = \sigma')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Lets look at triangle CEB")
        with self.simultaneous():
            for x in (a['ACD'], a['ABE'], a['CDB'], l['AC'], l['AB'], l['CD'], l['BD'], l['BY']):
                x.e_fade()
            l['BC'].e_normal()
            for x in (t['ADC'], t['AEB']):
                x.e_remove()
        t2.e_fade(*t2.except_index(10))
        t['CEB'] = ETriangle(p['C'], p['E'], p['B'], skip_anim=True).e_fill(PINK)
        a['CEB'].e_normal()
        t2.down()
        t2.math(r'CE=x, \quad\measuredangle CEB = \sigma,\quad EB=y')


        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("And at triangle CDB")
        with self.simultaneous():
            for x in (a['ACD'], a['ABE'], a['CEB'], l['AC'], l['AB'], l['CD'], l['BE'], l['CE']):
                x.e_fade()
            t['CEB'].e_fade().e_unfill()
            for x in (a['CDB'], l['CD'], l['BD'], l['BC']):
                x.e_normal()

        t['CDB'] = ETriangle(p['C'], p['D'], p['B'], skip_anim=True).e_fill(PINK)

        t2.math(r'BD=x,\quad \measuredangle BDC=\sigma,\quad CD = y')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Since two sides and the angle between are the "
                   "same for both triangles, "
                   "then all the sides and angles are {nb:equal (I.4)}")

        with self.simultaneous():
            l['CE'].e_normal()
            l['BE'].e_normal()
            a['CEB'].e_normal()

        t['CEB'].e_fill(PINK)


        with self.simultaneous():
            a['CBE'] = EAngle(l['BC'],l['BE'], size=mn_scale(50), label=r'\epsilon')
            a['BCD'] = EAngle(l['BC'],l['CD'], size=mn_scale(50), label=r'\epsilon')

        t2.e_fade(*t2.except_index(11,12))
        t2.math(r'\measuredangle CBE = \measuredangle BCD = \epsilon')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            a['CBD'] = EAngle(l['BC'],l['BD'], size=mn_scale(25), label=r'\beta')
            a['BCE'] = EAngle(l['BC'],l['CE'], size=mn_scale(25), label=r'\beta')

        t2.math(r'\measuredangle BCE = \measuredangle CBD = \beta')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("And, we have just shown that the exterior angles are equal")
        with self.simultaneous():
            for x in ('CE', 'BE', 'CD'):
                l[x].e_fade()
            for x in ('AB', 'AC'):
                l[x].e_normal()
            for x in ('CE', 'BD'):
                l[x].e_normal().remove_label()
            for x in ('CBE', 'BCD'):
                a[x].e_fade()
            for x in ('CEB', 'CDB'):
                a[x].e_remove()
            for x in ('BCE', 'CBD'):
                a[x].e_normal()
            for x in 'DE':
                p[x].e_remove()
            for x in ('CEB', 'CDB'):
                t[x].e_remove()

        with self.simultaneous():
            t2.e_fade()
            t2.blue(0)

        t2.down(MED_SMALL_BUFF)
        t2.math(r'\measuredangle BCE = \measuredangle CBD = \beta')
        t2.down(MED_SMALL_BUFF)

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            for x in ('CBE', 'BCD', 'CBE', 'ACD', 'ABE'):
                a[x].e_normal()

        t1.explain("Let's look now at the interior angles.  "
                   "The differences between equals are equal"
                   " so that means the interior angles are the same")
        t2.math(r'\measuredangle ABC = \measuredangle ACB = \delta - \epsilon = \alpha')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            for x in ('CBE', 'BCD', 'CBE', 'ACD', 'ABE'):
                a[x].e_remove()
            for x in ('CD', 'BE', 'BY', 'CZ'):
                l[x].e_remove()

            a['ABC'] = EAngle(l['AB'],l['BC'], size=mn_scale(30), label=r'\alpha')
            a['ACB'] = EAngle(l['AC'],l['BC'], size=mn_scale(30), label=r'\alpha')

        self.next_page()
