import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop10(Book1Scene):
    steps = []
    title = "To bisect a given finite straight line."

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=to_manim_h_scale(550))
        t2 = TextBox(mn_coord(500, 430))
        A = mn_coord(100, 400)
        B = mn_coord(400, 400)
        C = mn.midpoint(A, B) + UP * 2
        D = mn.midpoint(A, B) + DOWN * 2

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngleBase] = {}

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t1.title("In other words:")
            t1.explain("Start with a line segment AB")
            p['A']  = EuclidPoint(A, label=('A', LEFT))
            p['B']  = EuclidPoint(B, label=('B', RIGHT))
            l['AB'] = EuclidLine('AB')

        @self.push_step
        def _i2():
            t1.explain("and cut it in half")
            nonlocal C, D
            l['half'] = EuclidLine('CD')

        # ----------------------------------------------
        # Construction
        # ----------------------------------------------
        @self.push_step
        def _c1():
            t1.down()
            t1.title("Construction:")
            l['half'].e_remove()

        @self.push_step
        def _c2():
            t1.explain("Construct an equilateral triangle on AB and label the {nb:vertex C <sub>(I.1)</sub>}")
            t[1], p['C'] = EquilateralTriangle.build(A, B, speed=2)
            l['BC'], l['AC'] = t[1].l[1:]
            t[1].l[0].e_remove()
            p['C'].add_label('C', UP)

        @self.push_step
        def _c3():
            t1.explain("Bisect angle ACB, and extend line past the line segment{nb: AB <sub>(I.9)</sub>")
            nonlocal p
            a['t'] = EuclidAngle('ACB')
            l['CD'], p['D'], *objs = a['t'].bisect(2)
            with self.simultaneous():
                for o in objs:
                    o.e_remove()
                a['t'].e_remove()
                pts = l['CD'].intersect(l['AB'])
                p['D'].e_remove()
            p['D'] = EuclidPoint(pts, label=('D', UR))

        @self.push_step
        def _c4():
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



        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            with self.simultaneous():
                l['AD'].remove_label()
                l['BD'].remove_label()
            t2.e_remove()
            t1.title("Proof:")
            t[1].e_fill(BLUE_D)

            with self.simultaneous():
                l['AC'].e_normal()
                l['BC'].e_normal()

            t1.explain("AC equals BC since they are sides of an equilateral triangle")
            l['AC'].add_label('r_1', outside=True)
            l['BC'].add_label('r_1', outside=True)
            t2.math('AC = CB')

        @self.push_step
        def _p2():
            t1.explain("Angle ACD equals BCD since we bisected angle ACB")
            l['CD'].e_normal()
            with self.simultaneous():
                a['ACD'] = EuclidAngle('ACD', label=r'\alpha')
                a['DCB'] = EuclidAngle('DCB', label=r'\alpha')
            t2.math(r'\angle ACD = \angle BCD = \alpha')

        @self.push_step
        def _p3():
            t1.explain("Since the two triangles ACD and CDB have two "
                       "equal sides, and an equal angle between them,")
            t[1].e_unfill()
            with self.simultaneous():
                t[2] = EuclidTriangle.assemble(lines=[l['AD'], l['CD'], l['AC']]).e_fill(GREEN_D)
                t[3] = EuclidTriangle.assemble(lines=[l['BD'], l['BC'], l['CD']]).e_fill(LIGHT_PINK)


        @self.push_step
        def _p4():
            t1.explain("then "
                       "the third side of each triangle is equal <sub>(I.4)</sub>")
            l['AD'].add_label('r', DOWN)
            l['BD'].add_label('r', DOWN)
            t2.math('AD = DB = r')


        @self.push_step
        def _p5():
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




