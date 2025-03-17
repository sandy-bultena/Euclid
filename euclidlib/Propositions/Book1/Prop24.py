import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop24(Book1Scene):
    steps = []
    title = ("If two triangles have two sides equal to two sides "
             "respectively, but have one of the angles contained by the equal "
             "straight lines greater than the other, then they also have the "
             "base greater than the base.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 175))
        t3 = TextBox(mn_coord(475, 475))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        A = mn_coord(200, 150)
        B = mn_coord(75, 350)
        C = mn_coord(375, 350)
        D = mn_coord(220, 425)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            nonlocal A, B, C, D
            t1.title("In other words:")
            t1.explain("Given two triangles ABC and DEF, where "
                       "lengths AB equals DE and AC equals DF, "
                       "and angle BAC is greater than DEF")
            t['ABC'] = ETriangle('ABC',
                                 point_labels='ABC',
                                 angles=[r'\alpha'],
                                 labels=['c', None, 'b'])

            t['DEF'] = ETriangle.SAS(D,
                                     t['ABC'].l[0],
                                     abs(t['ABC'].a[0].e_angle) - 30 * DEGREES,
                                     t['ABC'].l[2],
                                     point_labels='DEF',
                                     angles=[r'\delta'],
                                     labels=['c', None, 'b'])

            t2.math(r'\alpha > \delta', fill_color=BLUE)
            t2.math('AB = DE = c', fill_color=BLUE)
            t2.math('AC = DF = b', fill_color=BLUE)

        @self.push_step
        def _i2():
            t1.explain("Then length BC is greater than length EF")
            t['ABC'].set_labels((), 'a')
            t['DEF'].set_labels((), 'd')
            t2.math(r'BC > EF \Rightarrow a > d')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof:")
            t2[-1].e_remove()
            t2.submobjects.pop()

        @self.push_step
        def _p2():
            t1.explain("Copy the angle BAC onto line ED at point D  (I.23)")
            with self.simultaneous():
                t['ABC'].l[1].e_fade()
                t['DEF'].l[1].e_fade()
                t['DEF'].l[2].e_fade()
                t['DEF'].a[0].e_fade()

            l['DG2'], a['GDE'] = t['ABC'].a[0].copy_to_line(t['DEF'].p[0], t['DEF'].l[0], speed=2, negative=True)
            l['DG2'].extend(mn_scale(100))
            a['GDE'].add_label(r'\alpha')
            t2.e_fade()
            t2.math(r'\angle{EDG} = \angle{BAC}', fill_color=BLUE)

        @self.push_step
        def _p3():
            t1.explain("Define point G on the copied angle such that DG equals DF")
            c['D'] = ECircle(D, t['DEF'].p[2])
            p['G'] = EPoint(*c['D'].intersect(l['DG2']), label=('G', RIGHT))
            l['DG2'].e_fade()
            l['DG'] = ELine('DG', label=('b', dict(outside=True)))
            c['D'].e_remove()
            t2.e_fade()
            t2.math('DG = DF', fill_color=BLUE)

        @self.push_step
        def _p4():
            t1.explain("Construct line EG and FG")
            l['EG'] = ELine(t['DEF'].p[1], p['G'])
            l['FG'] = ELine(t['DEF'].p[2], p['G'])
            t['DEF'].l[1].e_normal()
            l['DG2'].e_remove()

            t['DEG'] = ETriangle.assemble(
                lines=[t['DEF'].l[0], l['EG'], l['DG']],
                angles=[a['GDE'], None, None],
                points=[t['DEF'].p[0], t['DEF'].p[1], p['G']]
            )

            t['DFG'] = ETriangle.assemble(
                lines=[t['DEF'].l[2], l['FG'], l['DG']],
                points=[t['DEF'].p[0], t['DEF'].p[2], p['G']]
            )

            t['EFG'] = ETriangle.assemble(
                lines=[t['DEF'].l[1], l['FG'], l['EG']],
                points=[t['DEF'].p[1], t['DEF'].p[2], p['G']]
            )

        @self.push_step
        def _p5():
            with self.simultaneous():
                t['DEF'].e_fade()
                t['DFG'].e_fade()
                t['DEG'].e_normal()
                t['ABC'].l[1].e_normal()
            with self.delayed():
                t['ABC'].e_fill(BLUE_D)
                t['DEG'].e_fill(BLUE_D)

            t1.explain("Triangle ABC and DEG have two equal sides "
                       "with an equal angle between them, hence they are equal, "
                       "and the line BC equals EG (I.4)")
            l['EG'].add_label('a', outside=True)
            t2.blue(1, 2, 3, 4)
            t2.math('EG = BC')

        @self.push_step
        def _p6():
            with self.simultaneous():
                t['DEF'].e_fade()
                t['DEG'].e_fade()
                t['DFG'].e_normal()

            t1.explain("Consider triangle FDG")
            t1.explain("Angles DFG and DGF are equal since the "
                       "the triangle is an isosceles triangle (I.5)")

            t['DFG'].set_angles(None, r'\epsilon', (r'\epsilon', dict(alpha=0.6)), 0, mn_scale(25), mn_scale(25))
            t['DFG'].e_fill(GREEN_D)
            t['ABC'].e_unfill()

            with self.simultaneous():
                t2.e_fade()
                t2.blue(4)
            t2.math(r'\angle{DFG} = \angle{DGF} = \epsilon')

        @self.push_step
        def _p7():
            with self.simultaneous():
                t['DFG'].e_fade()
            with self.simultaneous():
                for line in t['DEF'].l:
                    line.remove_label()
            t['DEF'].p[0].e_normal()
            with self.simultaneous():
                t['EFG'].e_normal()
            t1.explain('Angle EFG is greater than DFG')

            with self.simultaneous():
                t['DEF'].l[2].e_normal()
                t['DEG'].l[1].e_fade()
                t['DFG'].a[1].e_normal()
            t['EFG'].set_angles(None, (r'\beta', dict(alpha=0.25)), None, 0, mn_scale(15), 0)

            with self.simultaneous():
                t2.e_fade()
            t2.math(r'\beta > \epsilon')

        @self.push_step
        def _p8():
            with self.simultaneous():
                t['ABC'].e_remove()
            t['DFG'].a[1].red()
            with self.delayed():
                for line in t['DFG'].l:
                    line.remove_label()
                for line in t['EFG'].l:
                    line.remove_label()
                for line in t['DEG'].l:
                    line.remove_label()

            all = EGroup(sub for name in 'DFG EFG DEF DEG'.split() for sub in t[name].get_e_family())
            for x in all:
                if x.e_label is not None:
                    x.e_label.enable_updaters()
            self.play(all.animate.scale(1.5, about_point=all.get_corner(DL)))
            for x in all:
                if x.e_label is not None:
                    x.e_label.disable_updaters()

        @self.push_step
        def _p9():
            t1.explain("Angle DGF is greater than EGF")
            with self.simultaneous():
                t['DEF'].l[2].e_fade()
                t['EFG'].l[2].e_normal()
            t['DFG'].set_angles(None, None, (r'\epsilon', dict(alpha=0.6)), 0, mn_scale(40), mn_scale(25 * 1.5))
            t['DFG'].a[2].red()
            t['EFG'].set_angles(None, None, r'\theta', 0, mn_scale(40), mn_scale(40 * 1.5))
            with self.simultaneous():
                t2.e_fade()
                t2.white(-1)
            t2.e_update(-1, r'\beta > \epsilon > \theta')

        @self.push_step
        def _p10():
            with self.delayed():
                t['DFG'].l[2].e_fade()
                t['DFG'].a[2].e_fade()
            t['EFG'].e_fill(PINK)
            t['EFG'].l[0].e_normal()

        @self.push_step
        def _p11():
            t1.explain("The angle EFG is greater than EGF, "
                       "hence line EG is greater than EF (I.19)")
            t2.white(-2)
            t2.math('EG > EF')

        @self.push_step
        def _p12():
            all = EGroup(sub for name in 'DFG EFG DEF DEG'.split() for sub in t[name].get_e_family())
            for x in all:
                if x.e_label is not None:
                    x.e_label.enable_updaters()
            self.play(all.animate.scale(1/1.5, about_point=all.get_corner(DL)))
            for x in all:
                if x.e_label is not None:
                    x.e_label.disable_updaters()

            with self.simultaneous():
                t['ABC'].e_draw()
            t1.explain("Since EG is equal to BC, BC is greater than EF")
            with self.simultaneous():
                t2.e_fade()
                t2.white(5, -1)
            t2.down()
            t2.math('BC > EF')

        @self.push_step
        def _p13():
            with self.simultaneous():
                t['DEF'].e_normal()

            to_keep = t['DEF'].get_group()

            with self.simultaneous():
                t['EFG'].e_unfill()
                t['DFG'].e_unfill()
                t['DEG'].e_unfill()
                for y in 'EFG DFG DEG'.split():
                    for x in t[y].get_group():
                        if x not in to_keep:
                            x.e_remove()

            with self.simultaneous():
                t2.e_fade()
                t2.blue[:3]()
                t2.white(-1)


