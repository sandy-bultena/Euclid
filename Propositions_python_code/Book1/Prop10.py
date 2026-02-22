import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop10(Book1Scene):
    steps = []
    title = "To bisect a given finite straight line."

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(500, 430))
        A = mn_coord(100, 400)
        B = mn_coord(400, 400)
        C = mn.midpoint(A, B) + UP * 2
        D = mn.midpoint(A, B) + DOWN * 2

        l: Dict[str | int, ELine] = self.l
        p: Dict[str | int, EPoint] = self.p
        c: Dict[str | int, ECircle] = self.c
        t: Dict[str | int, ETriangle] = self.t
        a: Dict[str | int, EAngleBase] = self.a

        self.next_page()

        # ------------------------------------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Start with a line segment AB")
        p['A']  = EPoint(A, label=('A', LEFT))
        p['B']  = EPoint(B, label=('B', RIGHT))
        l['AB'] = ELine(A,B)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("and cut it in half")
        l['half'] = ELine(C,D)

        self.next_page()

        # ------------------------------------------------------------------------
        # Construction
        # ----------------------------------------------
        t1.down()
        t1.title("Construction:")
        l['half'].e_remove()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Construct an equilateral triangle on AB and label the {nb:vertex C (I.1)}")
        t[1] = EquilateralTriangle.build(A, B, speed=2*self.default_speed)
        p['C'] = t[1].p[-1]
        l['BC'], l['AC'] = t[1].l[1:]
        t[1].l[0].e_remove()
        p['C'].add_label('C', UP)

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Bisect angle ACB, and extend line past the line segment{nb: AB (I.9)")
        a['t'] = EAngle(*self.lines('ACB'))
        l['CD'], p['D'], *objs = a['t'].bisect(speed=self.default_speed*2)
        with self.simultaneous():
            for o in objs:
                o.e_remove()
            a['t'].e_remove()
            pts = l['CD'].intersect(l['AB'])
            p['D'].e_remove()
        if pts:
            p['D'] = EPoint(pts[0], label=('D', UR))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Line AD is equal to line DB")
        l['AD'], l['BD'] = l['AB'].e_split(p['D'])
        l['CD'], l['DX'] = l['CD'].e_split(p['D'])
        with self.simultaneous():
            l['AD'].add_label('r', DOWN)
            l['BD'].add_label('r', DOWN)
        with self.simultaneous():
            l['AC'].e_fade()
            l['BC'].e_fade()
            l['CD'].e_fade()
            l['DX'].e_fade()
        t2.math('AD = BD')


        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t1.down()
        t1.title("Proof:")
        t1.explain("AC equals BC since they are sides of an equilateral triangle")
        with self.simultaneous():
            l['AD'].remove_label()
            l['BD'].remove_label()
        t2.e_remove()
        t[1].e_fill(BLUE_D)

        with self.simultaneous():
            l['AC'].e_normal()
            l['BC'].e_normal()

        l['AC'].add_label('r_1')
        l['BC'].add_label('r_1')
        t2.math('AC = CB')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Angle ACD equals BCD since we bisected angle ACB")
        l['CD'].e_normal()
        with self.simultaneous():
            a['ACD'] = EAngle(*self.lines('ACD'), label=r'\alpha')
            a['DCB'] = EAngle(*self.lines('DCB'), label=r'\alpha')
        t2.math(r'\measuredangle ACD = \measuredangle BCD = \alpha')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("Since the two triangles ACD and CDB have two "
                   "equal sides, and an equal angle between them,")
        t[1].e_unfill()
        with self.simultaneous():
            t[2] = ETriangle.assemble(lines=[l['AD'], l['CD'], l['AC']]).e_fill(GREEN_D)
            t[3] = ETriangle.assemble(lines=[l['BD'], l['BC'], l['CD']]).e_fill(LIGHT_PINK)


        self.next_page()

        # ------------------------------------------------------------------------
        t1.explain("then "
                   "the third side of each triangle is equal (I.4)")
        l['AD'].add_label('r', DOWN)
        l['BD'].add_label('r', DOWN)
        t2.math('AD = DB = r')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t[2].e_unfill()
            t[3].e_unfill()
        with self.simultaneous():
            t[2].e_fade()
            t[3].e_fade()
            l['AB'].e_draw(True)
            l['AD'].e_normal()
            l['BD'].e_normal()
            a['ACD'].e_fade()
            a['DCB'].e_fade()
            p['C'].e_fade()
            l['DX'].e_fade()
            t2.e_fade()
            t2.e_normal(-1)




