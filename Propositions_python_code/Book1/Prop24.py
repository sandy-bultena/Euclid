import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book01 import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop24(Book1Scene):
    steps = []
    title = ("If two triangles have two sides equal to two sides "
             "respectively, but have one of the angles contained by the equal "
             "straight lines greater than the other, then they also have the "
             "base greater than the base.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(475, 175))
        t3 = TextBox(mn_coord(475, 475))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(200, 150)
        B = mn_coord(75, 350)
        C = mn_coord(375, 350)
        D = mn_coord(220, 425)

        self.next_page()

        # ------------------------------------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Given two triangles ABC and DEF, where "
                   "lengths AB equals DE and AC equals DF, "
                   "and angle BAC is greater than DEF")
        t['ABC'] = ETriangle(A,B,C,
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

        t2.math(r'\alpha > \delta', is_axiom=True)
        t2.math('AB = DE = c', is_axiom=True)
        t2.math('AC = DF = b', is_axiom=True)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Then length BC is greater than length EF")
        t['ABC'].set_labels((), 'a')
        t['DEF'].set_labels((), 'd')
        t2.math(r'BC > EF \Rightarrow a > d')

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t1.down()
        t1.title("Proof:")
        t2[-1].e_remove()
        t2.submobjects.pop()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Copy the angle BAC onto line ED at point D  (I.23)")
        with self.simultaneous():
            t['ABC'].l[1].e_fade()
            t['DEF'].l[1].e_fade()
            t['DEF'].l[2].e_fade()
            t['DEF'].a[0].e_fade()

        l['DG2'], a['GDE'] = t['ABC'].a[0].copy_to_line(t['DEF'].p[0], t['DEF'].l[0],
                                                        speed=5*self.default_speed,
                                                        negative=True)
        l['DG2'].extend(mn_scale(100))
        a['GDE'].add_label(r'\alpha')
        t2.e_fade()
        t2.math(r'\measuredangle{EDG} = \measuredangle{BAC}', fill_color=BLUE)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Define point G on the copied angle such that DG equals DF")
        c['D'] = ECircle(D, t['DEF'].p[2])
        p['G'] = EPoint(*c['D'].intersect(l['DG2']), label=('G', RIGHT))
        l['DG2'].e_fade()
        l['DG'] = ELine(p['G'],D, label='b')
        c['D'].e_remove()
        t2.e_fade()
        t2.math('DG = DF', fill_color=BLUE)

        self.next_page()

        # ------------------------------------------------------------------------
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

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t['DEF'].e_fade()
            t['DFG'].e_fade()
            t['DEG'].e_normal()
            t['ABC'].l[1].e_normal()
        with self.staggered_animation():
            t['ABC'].e_fill(BLUE_D)
            t['DEG'].e_fill(BLUE_D)

        t1.explain("Triangle ABC and DEG have two equal sides "
                   "with an equal angle between them, hence they are equal, "
                   "and the line BC equals EG (I.4)")
        l['EG'].add_label('a')
        t2.blue(1, 2, 3, 4)
        t2.math('EG = BC')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t['DEF'].e_fade()
            t['DEG'].e_fade()
            t['DFG'].e_normal()

        t1.explain("Consider triangle FDG")
        t1.explain("Angles DFG and DGF are equal since the "
                   "the triangle is an isosceles triangle (I.5)")

        t['DFG'].set_angles(None, (r'\epsilon',mn_scale(25)), (r'\epsilon',  mn_scale(25)) )
        t['DFG'].e_fill(GREEN_D)
        t['ABC'].e_unfill()

        with self.simultaneous():
            t2.e_fade()
            t2.blue(4)
        t2.math(r'\measuredangle{DFG} = \measuredangle{DGF} = \epsilon')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain('Angle EFG is greater than DFG')
        with self.simultaneous():
            t['DFG'].e_fade()
        with self.simultaneous():
            for line in t['DEF'].l:
                line.remove_label()
        t['DEF'].p[0].e_normal()
        with self.simultaneous():
            t['EFG'].e_normal()

        with self.simultaneous():
            t['DEF'].l[2].e_normal()
            t['DEG'].l[1].e_fade()
            t['DFG'].a[1].e_normal()
        t['EFG'].set_angles(None, (r'\beta', mn_scale(15)), None)

        with self.simultaneous():
            t2.e_fade()
        t2.math(r'\beta > \epsilon')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t['ABC'].e_remove()
        t['DFG'].a[1].red()
        with self.staggered_animation():
            for line in t['DFG'].l:
                line.remove_label()
            for line in t['EFG'].l:
                line.remove_label()
            for line in t['DEG'].l:
                line.remove_label()

        objs_to_scale = [t[name] for name in 'DFG EFG DEF DEG'.split()]
        self.scale(*objs_to_scale, corner=DL, factor=1.5)
        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Angle DGF is greater than EGF")
        with self.simultaneous():
            t['DEF'].l[2].e_fade()
            t['EFG'].l[2].e_normal()
        t['DFG'].set_angles(None, None, (r'\epsilon', mn_scale(25 * 1.5)))
        t['DFG'].a[2].red()
        t['EFG'].set_angles(None, None, (r'\theta',mn_scale(40 * 1.5)))
        with self.simultaneous():
            t2.e_fade()
            t2.default_color(-1)
        t2.e_update(-1, r'\beta > \epsilon > \theta')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.staggered_animation():
            t['DFG'].l[2].e_fade()
            t['DFG'].a[2].e_fade()
        t['EFG'].e_fill(PINK)
        t['EFG'].l[0].e_normal()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("The angle EFG is greater than EGF, "
                   "hence line EG is greater {nb: than EF (I.19)}")
        t2.default_color(-2)
        t2.math('EG > EF')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Since EG is equal to BC, BC is greater than EF")
        self.scale(*objs_to_scale, corner=DL, factor=1/1.5)

        with self.simultaneous():
            t['ABC'].e_draw()
        with self.simultaneous():
            t2.e_fade()
            t2.default_color(5, -1)
        t2.down()
        t2.math('BC > EF')

        self.next_page()

        # ------------------------------------------------------------------------
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
            t2.blue(slice(0,3))
            t2.default_color(-1)


