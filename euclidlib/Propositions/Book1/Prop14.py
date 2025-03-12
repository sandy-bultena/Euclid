import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop14(Book1Scene):
    steps = []
    title = ("If with any straight line, and at a point on it, two straight lines "
             "not lying on the same side make the sum of the adjacent angles equal "
             "to two right angles, then the two straight lines are in a straight "
             "line with one another.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(500, 430))
        t3 = TextBox(mn_coord(275, 275))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(150, 250)
        B = mn_coord(250, 450)
        C = mn_coord(100, 450)
        D = mn_coord(400, 450)
        E = mn_coord(450, 375)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t1.title("In other words:")
            t1.explain("Start with an arbitrary line segment AB")
            p['A'] = EPoint(A, label=('A', UP))
            p['B'] = EPoint(B, label=('B', DOWN))
            l['AB'] = ELine('AB')

        @self.push_step
        def _i2():
            t1.explain("Draw a line from B to an arbitrary point C")
            p['C'] = EPoint(C, label=('C', LEFT))
            l['BC'] = ELine('BC')

        @self.push_step
        def _i3():
            t1.explain("Draw a line from B to a point D (not on the same side as C),")
            p['C'] = EPoint(D, label=('D', RIGHT))
            l['BD'] = ELine('BD')
            a['a'] = EAngle('ABC', label=r'\alpha', size=mn_scale(40))
            a['b'] = EAngle('DBA', label=r'\beta', size=mn_scale(30))

        @self.push_step
        def _i4():
            t1.explain("If the sum of the angles ABC and ABD equals "
                       "the sum of two right angles...")
            eq['a+b'], _, eq['2R-1'], _ = (
                t2.math(r'\alpha + \beta = \rightangle + \rightangle',
                        break_into_parts=(r'\alpha + \beta', '=', r'\rightangle + \rightangle')))

        @self.push_step
        def _i5():
            t1.explain("... then BC and BD make a single line CD")
            t2.math(r'CB, BD\ =\ CD')

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            lastline = t2[-1].e_remove()
            t2.remove(lastline)
            t1.down()
            t1.title("Proof by Contradiction:")
            t2.blue()

        @self.push_step
        def _p2():
            t1.explain("Assume line BE makes a straight line with CB")
            t2.down()
            t2.math(r"CB, BE\ =\ CE", fill_color=BLUE)

            p['E'] = EPoint(E, label=('E', UP))
            l['BE'] = ELine('BE')
            a['th'] = EAngle(l['BE'], l['AB'], size=mn_scale(70), label=r'\theta')
            with self.simultaneous():
                l['BD'].e_fade()
                a['b'].e_fade()

        @self.push_step
        def _p3():
            t1.explainM(r"If CBE is a straight line, then the sum of $\alpha$ and $\theta$ "
                        r" equals two right angles \textsubscript{(I.13)}")
            eq['a+t'], _, eq['2R-2'], _ = (
                t2.math(r'\alpha + \theta = \rightangle + \rightangle',
                        break_into_parts=(r'\alpha + \theta', '=', r'\rightangle + \rightangle')))

        @self.push_step
        def _p4():
            with self.simultaneous():
                l['BD'].e_normal()
                a['b'].e_normal()
                a['a'].e_normal()

            t1.explainM(r"But the sum of $\alpha$ and $\beta$ also equals two right angles")
            self.play(
                mn.Indicate(eq['2R-1']),
                mn.Indicate(eq['2R-2']),
            )
            at, q, ab, full = t2.math(r'\alpha + \theta = \alpha + \beta',
                                      break_into_parts=(r'\alpha + \theta', '=', r'\alpha + \beta'),
                                      delay_anim=True)
            with self.simultaneous():
                at.transform_from(eq['a+t'])
                ab.transform_from(eq['a+b'])
                q.e_draw()

        @self.push_step
        def _p5():
            with self.simultaneous():
                l['BD'].e_normal()
                a['b'].e_normal()
                a['a'].e_normal()

            t1.explainM(r"This implies that angles $\beta$ equals $\theta$...")
            t2.math(r'\beta = \theta')
            a['a'].e_fade()

        @self.push_step
        def _p6():
            with self.simultaneous():
                l['BD'].e_normal()
                a['b'].e_normal()
                a['a'].e_normal()

            t1.explainM("... which is "
                        r"impossible since $\beta$ is the sum of $\theta$ and $\epsilon$")
            t2.math(r'\beta = \theta + \epsilon')
            a['e'] = EAngle('DBE', size=mn_scale(60), label=r'\epsilon')
            with self.simultaneous():
                t2.e_fade()
                t2.blue[0:4]()
                t2.red(-1, -2)

        @self.push_step
        def _p7():
            t1.explainM("The assumption that CB,BE make a straight line led to a "
                        "contradiction, and therefore must be incorrect")
            with self.simultaneous():
                t2.e_fade()
                t2.blue[0:3]()
                t2.red(3)
                t2.red(-1, -2)

        @self.push_step
        def _p8():
            t1.down()
            t1.explain("Thus, CB and BD form a straight line")
            with self.simultaneous():
                # t2.e_fade(3)
                a['a'].e_normal()
                a['e'].e_fade()
                a['th'].e_fade()
                l['BE'].e_fade()
            t2.math(r'CB, BD\ =\ CD')

