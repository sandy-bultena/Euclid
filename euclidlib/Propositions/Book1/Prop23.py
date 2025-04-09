import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *
from typing import Dict
from typing import Any


class Prop23(Book1Scene):
    steps = []
    title = ("To construct a rectilinear angle equal to a given rectilinear angle "
             "on a given straight line and at a point on it.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 475))
        t3 = TextBox(mn_coord(820, 150))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Any] = {}

        A = mn_coord(75, 650)
        B = mn_coord(400, 700)
        C = mn_coord(75, 400)
        D = mn_coord(225, 200)
        E = mn_coord(350, 400)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            nonlocal A, B, C, D, E

            t1.title("In other words:")
            t1.explain("Given an angle and a line AB")

            l['CD'] = ELine('CD')
            l['CD2'] = l['CD'].copy().extend(mn_scale(50))

            p['C'] = EPoint(C)

            l['CE'] = ELine('CE')
            l['CE2'] = l['CE'].copy().extend(mn_scale(50))

            a['a'] = EAngle('ECD', label=r'\alpha')

            p['A'] = EPoint(A, label=('A', LEFT))
            p['B'] = EPoint(B, label=('B', RIGHT))
            l['AB'] = ELine('AB')

        @self.push_step
        def _i2():
            t1.explain("Draw a new line on point A such that it forms "
                       "an angle equivalent to the original")
            with self.pause_animations_for():
                ex['cpy'] = a['a'].copy_to_line(p['A'], l['AB'])
            ex['cpy'][1].add_label(r'\alpha')
            ex['cpy'][0].e_draw()
            ex['cpy'][1].e_draw()

        # ----------------------------------------------
        # Construction
        # ----------------------------------------------
        @self.push_step
        def _c1():
            with self.simultaneous():
                t1.e_remove()
            with self.delayed():
                for x in ex['cpy']:
                    x.e_remove()
            t1.title("Construction:")

        @self.push_step
        def _c2():
            t1.explain("Define points D and E at random on "
                       "the two lines defining the angle")
            p['D'] = EPoint(D, label=('D', dict(away_from=E)))
            p['E'] = EPoint(E, label=('E', dict(away_from=D)))
            l['CD'].add_label('e', inside=True)
            l['CE'].add_label('d', outside=True)

        @self.push_step
        def _c3():
            nonlocal D, E
            t1.explain("Construct triangle DCE by constructing the line DE")
            l['DE'] = ELine('DE', label=('c', dict(inside=True)))

        @self.push_step
        def _c4():
            t1.explain("Copy this triangle onto line segment AB, using the methods "
                       "described in I.22")
            t1.indent()
            t1.decorate()
            t1.explain('Copy length CE to AF (I.2)')
            t2.math('AF = CE')
            l['AF'], p['F'] = l['CE'].copy_to_line(p['A'], l['AB'])
            p['F'].add_label('F', DOWN)
            l['AF'].add_label('d', outside=True)

        @self.push_step
        def _c5():
            t1.explain('Copy length CD, start at point A (I.2), and then construct '
                       'a circle with radius CD')
            l['AG'], p['G'] = l['CD'].copy_to_point(p['A'])
            p['G'].e_remove()
            c['A'] = ECircle(A, p['G'])
            l['AG'].grey()
            l['AG'].add_label('e', inside=True)

        @self.push_step
        def _c6():
            t1.explain("Copy length DE, start at point F (I.2), and then construct "
                       "a circle with radius DE")
            l['FH'], p['H'] = l['DE'].copy_to_point(p['F'])
            p['H'].e_remove()
            c['F'] = ECircle(p['F'], p['H'])
            l['FH'].grey()
            l['FH'].add_label('c', inside=True)

        @self.push_step
        def _c7():
            nonlocal p
            t1.explain("Construct triangle AFG, where G is the intersection "
                       "of the two circles")
            with self.simultaneous():
                l['FH'].e_remove()
                l['AG'].e_remove()
            t2.math('AG = CD')
            t2.math('FG = ED')
            pts = c['F'].intersect(c['A'])
            p['G'] = EPoint(pts[0], label=('G', UP))
            c['F'].e_fade()
            c['A'].e_fade()
            l['AG'] = ELine('AG', label=('c', dict(inside=True)))
            l['FG'] = ELine('FG', label=('e', dict(outside=True)))
            t1.unindent()
            t1.reset_decoration()

        @self.push_step
        def _c8():
            nonlocal l
            t1.explain("Angle GAF is equal to DCE")
            a['a2'] = EAngle('GAF', label=r'\alpha')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof:")
            t1.explain("Two triangles where all three sides are equivalent, have "
                     "equivalent angles (I.8)")
            with self.delayed():
                c['F'].e_remove()
                c['A'].e_remove()
                l['FG'].e_remove()
                l['DE'].e_remove()
