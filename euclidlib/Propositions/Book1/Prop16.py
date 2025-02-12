import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop16(Book1Scene):
    steps = []
    title = ("In any triangle, if one of the sides is produced, "
             "then the exterior angle is greater than either of "
             "the interior and opposite angles.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(500, 430))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(150, 200)
        B = mn_coord(100, 450)
        C = mn_coord(350, 450)
        D = mn_coord(450, 450)
        F = A - B + C

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t1.title("In other words:")
            t1.explain("Start with a triangle ABC")
            t['ABC'] = EuclidTriangle(A, B, C,
                                      point_labels=[('A', dict(away_from=B)),
                                                    ('B', dict(away_from=A)),
                                                    ('C', dict(away_from=F))])
            l['AB'], l['BC'], l['AC'] = t['ABC'].l

        @self.push_step
        def _i2():
            t1.explain("Extend line BC to point D")
            l['CD'] = EuclidLine(C, D)
            p['D'] = EuclidPoint(D, label=('D', DOWN))

        @self.push_step
        def _i3():
            nonlocal l
            t1.explainM(r"The angle $\angle{ACD}$ is larger than either $\angle{ABC}$ or $\angle{CAB}$")
            a['a'] = EuclidAngle('ACD', size=mn_scale(20), label=(r'\alpha', 0.7))
            a['g'] = EuclidAngle('CBA', size=mn_scale(40), label=r'\gamma')
            a['b'] = EuclidAngle('BAC', label=r'\beta')

            t2.math(r'\alpha > \gamma')
            t2.math(r'\alpha > \beta')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof:")

        @self.push_step
        def _p2():
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
            p['E'] = l['AC'].bisect(speed=2)
            p['E'].add_label('E', mn.rotate_vector(l['AC'].get_unit_vector(), -90 * DEG))
            l['CE'], l['AE'] = l['AC'].e_split(p['E'])
            l['CE'].add_label('y', outside=True)
            l['AE'].add_label('y', inside=True)
            t2.math('AE = EC = y')

        @self.push_step
        def _p3():
            t1.explain("Create line segment BE")
            l['BE'] = EuclidLine(B, p['E'], label=('x', dict(inside=True)))

        @self.push_step
        def _p4():
            t1.explain('Extend line BE to line F, where EF equals BE')
            with self.simultaneous():
                l['BF1'] = l['BE'].extend_cpy(p['E'].distance_to(B) + mn_scale(50))
                p['E'].add_label('E', dict(away_from=mn.midpoint(B, C)))
            c['E'] = EuclidCircle(p['E'], B)
            pts = c['E'].intersect(l['BF1'])
            p['F'] = EuclidPoint(pts[0], label=('F', dict(away_from=C)))
            c['E'].e_remove()

            tmp, l['EF'], x = l['BF1'].e_split(p['E'], p['F'])
            x.e_remove()
            l['EF'].add_label('x', outside=True)
            tmp.e_delete()
            t2.math('BE = EF = x')

        @self.push_step
        def _p5():
            nonlocal l
            t1.explain("Angles AEB and CEF are vertical to each other, "
                       "hence they are equal (I.15)")
            with self.simultaneous():
                a['th1'] = EuclidAngle('AEB', label=r'\theta', no_right=True)
                a['th2'] = EuclidAngle('CEF', label=r'\theta', no_right=True)
            t2.math(r'\angle{AEB} = \angle{CEF} = \theta')

        @self.push_step
        def _p6():
            nonlocal p, C
            t1.explain("Create line CF")
            l['CF'] = EuclidLine('CF')

        @self.push_step
        def _p7():
            nonlocal p
            t1.explain("Triangles ABE and FEC are equivalent since they "
                       "have two equal sides, with an equal angle AEB and FEC")
            l['AB'].e_normal()
            t['ABE'] = EuclidTriangle.assemble(
                lines='ABE', angles=[a['g'], None, None]).e_fill(BLUE_D)
            t['CEF'] = EuclidTriangle.assemble(lines='CEF').e_fill(GREEN_D)

        @self.push_step
        def _p8():
            t1.explain("Thus, angles BAE and ECF are equal (I.4)")
            a['b'].e_normal()
            t['CEF'].set_angles(r'\beta', None, None, mn_scale(40))  # Look Out For
            t2.math(r'\angle{BAE} = \angle{ECF} = \beta')

        @self.push_step
        def _p9():
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

            t1.explain("As can be seen angle ECF, which is equals to angle BAC, "
                       "is less than angle ACD")
            t2.math(r'\angle{ECF} = \angle{BAC} < \angle{ACD}')
            t2.math(r'\alpha > \beta')

        @self.push_step
        def _p10():
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
            t['ABC'].e_fill(PINK)

        @self.push_step
        def _p11():
            t1.down()
            t1.explain("Using the same method as before, "
                       "we can prove that angle BCG is greater than ABC")

            self.set_base_animation_speed(2)

            t['ABC'].e_unfill()
            a['a'].e_normal()
            p['F'].e_remove()

            l['AG'] = t['ABC'].l[-1].copy()
            l['AG'].prepend(mn_scale(100))
            l['CG'] = EuclidLine(C, l['AG'].get_start())
            l['AG'].e_remove()

            t['ABC'].p[-1].add_label('C', dict(buff=1.5*EuclidPoint.LabelBuff, towards=mn.midpoint(l['CG'].get_end(), D)))
            p['G'] = EuclidPoint(l['CG'].get_end(), label=('G', dict(away_from=C)))
            a['BCG'] = EuclidAngle('BCG', size=mn_scale(20), label=(r'\alpha', 0.80))

        @self.push_step
        def _p12():
            nonlocal B, C, A
            p['E'] = l['BC'].bisect()
            l['BE'] = EuclidLine('EB', label=('y', DOWN))
            l['CE'] = EuclidLine('EC', label=('y', UP))
            l['AE'] = EuclidLine('AE', label=('x', dict(outside=True)))
            a['b'].e_fade()

        @self.push_step
        def _p13():
            l['AF1'] = l['AE'].extend_cpy(p['E'].distance_to(A) + mn_scale(50))
            c['E'] = EuclidCircle(p['E'], A)
            pts = c['E'].intersect(l['AF1'])
            p['F'] = EuclidPoint(pts[0])
            c['E'].e_remove()
            l['EF'] = EuclidLine('EF', label=('x', dict(inside=True)))
            l['AF1'].e_remove()

        @self.push_step
        def _p14():
            nonlocal p, A, B, C
            l['CF'] = EuclidLine('CF')
            t['ABE']=EuclidTriangle.assemble(lines='ABE', angles=[None, a['a'], None]).e_fill(GREEN_E)
            t['CEF']=EuclidTriangle.assemble(lines='CEF').e_fill(BLUE_E)
            t['ABE'].set_angles(None, None, r'\epsilon', mn_scale(20))
            t['CEF'].set_angles(None, r'\epsilon', None, mn_scale(20))
            with self.simultaneous():
                t['ABC'].e_fade()
                t['ABE'].e_normal()


        @self.push_step
        def _p15():
            a['g'].e_normal()
            t['CEF'].set_angles(r'\gamma', None, None, mn_scale(60))


        @self.push_step
        def _p16():
            with self.simultaneous():
                t['ABE'].e_unfill()
                t['CEF'].e_unfill()
                p['E'].e_remove()

                with t['CEF'].angles[0].as_frozen():
                    t['ABE'].remove_labels()
                    t['CEF'].remove_labels()

                t['ABE'].l[-1].e_remove()
                t['ABE'].a[-1].e_remove()
                t['ABE'].a[1].e_remove()
                t['CEF'].l[1].e_remove()
                t['CEF'].a[1].e_remove()

            self.set_base_animation_speed(1)
            t2.math(r'\alpha > \gamma')

        @self.push_step
        def _p17():
            with self.simultaneous():
                with self.freeze(l['AB'], a['b'], a['a']):
                    t['ABE'].e_remove()
                    t['CEF'].e_remove()
                a['a'].e_draw()
                a['b'].e_normal()
                p['F'].e_remove()
                p['G'].e_remove()
                l['CG'].e_remove()
                a['BCG'].e_remove()
                t['ABC'].e_normal()


