import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop05(Book1Scene):
    steps = []
    title = ("In isosceles triangles the angles at the base equal one another, and, "
             "if the equal straight lines are produced further, "
             "then the angles under the base equal one another.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(400, 180))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        a: Dict[str | int, EuclidAngleBase] = {}
        t: Dict[str | int, EuclidTriangle] = {}

        A = mn_coord(200, 200)
        B = mn_coord(300, 440)
        C = mn_coord(100, 440)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t1.title("In other words:")
            t1.explain("Given an isosceles triangle ABC")
            t['ABC'] = EuclidTriangle(A, B, C,
                                      point_labels=[('A', UP), ('B', RIGHT), ('C', LEFT)],
                                      angles=[r'\gamma', None, None]
                                      )
            t2.math("AB = AC", fill_color=BLUE)

        @self.push_step
        def _i2():
            t1.explain("Then the angles at the base ACB and ABC are equal")
            t2.math(r"\angle ACB = \angle ABC", fill_color=BLUE)
            t['ABC'].set_angles(None, r'\alpha', r'\alpha',
                                None, mn_scale(30), mn_scale(30))
            l['AB'], l['BC'], l['AC'] = t['ABC'].l
            p['A'], p['B'], p['C'] = t['ABC'].p

        @self.push_step
        def _i3():
            t1.explain("In addition, if we extend lines AB and AC")
            with self.simultaneous():
                l['BY'] = l['AB'].extend_cpy(mn_scale(150))
                l['CZ'] = l['AC'].extend_cpy(mn_scale(-150))

        @self.push_step
        def _i3():
            t1.explain("Then the exterior angles are equal")
            D = l['BY'].point(mn_scale(100))
            E = l['CZ'].point(mn_scale(100))
            with self.simultaneous():
                a['YBC'] = EuclidAngle(l['BC'], l['BY'], label=r'\beta')
                a['ZCB'] = EuclidAngle(l['BC'], l['CZ'], label=r'\beta')
            with self.simultaneous():
                p['D'] = EuclidPoint(D, label_args=('D', dict(away_from=E)))
                p['E'] = EuclidPoint(E, label_args=('E', dict(away_from=D)))
            t2.math(r"\angle BCE = \angle CBD")

        @self.push_step
        def _i4():
            with self.simultaneous():
                t1.e_remove()
                t2.e_remove()
                a['YBC'].e_remove()
                a['ZCB'].e_remove()
                t['ABC'].a[1].e_remove()
                t['ABC'].a[2].e_remove()
                p['E'].e_remove()
                p['D'].e_remove()
                l['BY'].e_fade()
                l['CZ'].e_fade()

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.title("Proof:")
            t2.math("AB = AC", fill_color=BLUE)

        @self.push_step
        def _p2():
            t1.explain("Define a point along the extension of AB")
            D = l['BY'].point(mn_scale(100))
            p['D'] = EuclidPoint(D, label_args=('D', dict(away_from=C)))
            # TODO: ARROW?
            l['BD'] = EuclidLine(B, D)

        @self.push_step
        def _p3():
            t1.explain("Construct a line starting at C, with length BD, "
                       "on the line segment of {nb:<sub>(I.2)</sub>}")
            l['CE'], p['E'] = l['BD'].copy_to_line(p['C'], l['CZ'], speed=2)
            p['E'].add_label('E', away_from=B)
            t2.math("BD = CE", fill_color=BLUE)

        @self.push_step
        def _p4():
            t1.explain("AC and AB are equal, as are BD and CE, thus AE and AD which "
                       "are the sum of AC,CE and AB,BD respectively, are also equal")
            t2.math("AE = AC + CE")
            t2.math("AD = AB + BD")
            t2.math("AE = AD")

        @self.push_step
        def _p5():
            l['BC'].e_fade()
            t1.explain("Create triangle AEB")
            t2.down(mn.MED_SMALL_BUFF)
            l['BE'] = EuclidLine(B, p['E'])
            t['AEB'] = EuclidTriangle(p['E'], p['A'], p['B']).e_fill(BLUE_E)
            t2.math(r'AE, \angle EAB = \gamma, AB')

        @self.push_step
        def _p6():
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
                l['AC'] = EuclidLine(A, C)
                l['CD'] = EuclidLine(C, p['D'])
            t2.math(r'AD, \angle DAC = \gamma, AC')
            t['ADC'] = EuclidTriangle(p['C'], p['A'], p['D']).e_fill(BLUE_E)

        @self.push_step
        def _p7():
            with self.simultaneous():
                l['CE'].e_normal()
                l['BE'].e_normal()

            pts = l['CD'].intersect(l['BE'])

            t['AEB'].e_fill(BLUE_E)

            t1.explain("Since two sides and the angle between are "
                       "the same for both triangles, ")

            t2.e_fade(*t2.except_index(4, 0, 5, 6))

        @self.push_step
        def _p8():
            t1.explain("then all the sides and angles are {nb:equal <sub>I.4</sub>}")
            with self.simultaneous():
                a['ACD'] = EuclidAngle(l['CD'], l['AC'], size=mn_scale(40), label=r'\delta')
                a['ABE'] = EuclidAngle(l['AB'], l['BE'], size=mn_scale(40), label=r'\delta')

            t2.down(MED_SMALL_BUFF)
            t2.math('CD = BE')
            t2.math(r'\angle ACD = \angle ABE = \delta')

            with self.simultaneous():
                a['CDB'] = EuclidAngle(l['BD'], l['CD'], size=mn_scale(20), label=r'\sigma')
                a['CEB'] = EuclidAngle(l['BE'], l['CE'], size=mn_scale(20), label=r'\sigma')
            t2.math(r'\angle CDA = \angle BEA = \sigma')

        @self.push_step
        def _p9():
            with self.simultaneous():
                for x in (a['ACD'], a['ABE'], a['CDB'], l['AC'], l['AB'], l['CD'], l['BD'], l['BY']):
                    x.e_fade()
                l['BC'].e_normal()
                for x in (t['ADC'], t['AEB']):
                    x.e_remove()

            t1.explain("Lets look at triangle CEB")
            t['CEB'] = EuclidTriangle(p['C'], p['E'], p['B'], skip_anim=True).e_fill(PINK)
            a['CEB'].e_normal()
            t2.down()
            t2.math(r'CE, \angle BEA = \angle BEC = \sigma, BE')

        @self.push_step
        def _p10():
            with self.simultaneous():
                for x in (a['ACD'], a['ABE'], a['CEB'], l['AC'], l['AB'], l['CD'], l['BE'], l['CE']):
                    x.e_fade()
                t['CEB'].e_fade().e_unfill()
                for x in (a['CDB'], l['CD'], l['BD'], l['BC']):
                    x.e_normal()

            t['CDB'] = EuclidTriangle(p['C'], p['D'], p['B'], skip_anim=True).e_fill(PINK)

            t1.explain("And at triangle CDB")
            t2.math(r'BD, \angle CDA = \angle CDB = \sigma, CD')

        @self.push_step
        def _p11():
            with self.simultaneous():
                l['CE'].e_normal()
                l['BE'].e_normal()
                a['CEB'].e_normal()

            t2.white(1, 7, 9)
            t1.explain("Since two sides and the angle between are the "
                       "same for both triangles, "
                       "then all the sides and angles are {nb:equal <sub>I.4</sub>}")

            t['CDB'].e_fade().e_unfill()
            with self.simultaneous():
                a['BCD'] = EuclidAngle('BCD', size=mn_scale(50), label=r'\epsilon')
                a['CBE'] = EuclidAngle('CBE', size=mn_scale(50), label=r'\epsilon')

            with self.simultaneous():
                t['CEB'].e_fill(PINK)
                t['CDB'].e_fill(PINK)

            t2.math(r'\angle CBE = \angle BCD = \epsilon')

        @self.push_step
        def _p11():
            nonlocal l
            with self.simultaneous():
                a['CBD'] = EuclidAngle('CBD', size=mn_scale(25), label=r'\beta')
                a['BCE'] = EuclidAngle('BCE', size=mn_scale(25), label=r'\beta')

            t2.math(r'\angle BCE = \angle CBD = \beta')

        @self.push_step
        def _p12():
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

            t1.explain("And, we have just shown that the exterior angles are equal")
            t2.down(MED_SMALL_BUFF)
            t2.math(r'\angle BCE = \angle CBD = \beta')
            t2.down(MED_SMALL_BUFF)

        @self.push_step
        def _p13():
            with self.simultaneous():
                for x in ('CBE', 'BCD', 'CBE', 'ACD', 'ABE'):
                    a[x].e_normal()

            t1.explain("Let's look now at the interior angles.  "
                       "The differences between equals are equal"
                       " so that means the interior angles are the same")
            t2.math(r'\angle ABC = \angle ACB - \delta - \epsilon = \alpha')

        @self.push_step
        def _p14():
            with self.simultaneous():
                for x in ('CBE', 'BCD', 'CBE', 'ACD', 'ABE'):
                    a[x].e_remove()
                for x in ('CD', 'BE', 'BY', 'CZ'):
                    l[x].e_remove()

                a['ABC'] = EuclidAngle('ABC', size=mn_scale(30), label=r'\alpha')
                a['ACB'] = EuclidAngle('ACB', size=mn_scale(30), label=r'\alpha')
            with self.simultaneous():
                pass

