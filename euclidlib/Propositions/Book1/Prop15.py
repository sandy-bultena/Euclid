import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book1Scene
from euclidlib.Objects import *


class Prop15(Book1Scene):
    steps = []
    title = ("If two straight lines cut one another, then they make "
             "the vertical angles equal to one another.")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(475, 430))

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, EuclidPoint] = {}
        c: Dict[str | int, EuclidCircle] = {}
        t: Dict[str | int, EuclidTriangle] = {}
        a: Dict[str | int, EuclidAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(150, 250)
        B = mn_coord(300, 500)
        C = mn_coord(100, 400)
        D = mn_coord(400, 400)
        E = mn_coord(400, 375)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def _i1():
            t1.title("In other words:")
            t1.explain("Given two arbitrary line segments AB "
                       "and CD which intersect at point E")
            with self.simultaneous():
                p["A"] = EuclidPoint(A, label=("A", dict(away_from=B)))
                p["B"] = EuclidPoint(B, label=("B", dict(away_from=A)))
            l["AB"] = EuclidLine(A, B)
            with self.simultaneous():
                p["C"] = EuclidPoint(C, label=("C", LEFT))
                p["D"] = EuclidPoint(D, label=("D", RIGHT))
            l["CD"] = EuclidLine(C, D)
            p["E"] = EuclidPoint(l["CD"].intersect(l["AB"]), label=('E', dict(away_from=mn.midpoint(A, D))))

        @self.push_step
        def _i2():
            t1.explainM(r"$\angle{AEC}$ and $\angle{DEB}$ are equal")
            t1.explainM(r"$\angle{AED}$ and $\angle{CEB}$ are equal")
            l["CE"], l["DE"] = l["CD"].e_split(p["E"])
            l["AE"], l["BE"] = l["AB"].e_split(p["E"])
            with self.simultaneous():
                a["a"] = EuclidAngle('AEC', label=r"\alpha")
                a["b"] = EuclidAngle("BED", label=r"\beta")
            with self.simultaneous():
                a["g"] = EuclidAngle("AED", label=r"\gamma", size=mn_scale(50))
                a["t"] = EuclidAngle("BEC", label=r"\theta", size=mn_scale(50))
            t2.math(r"\alpha=\beta")
            t2.math(r"\gamma=\theta")

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def _p1():
            t1.down()
            t1.title("Proof:")
            with self.simultaneous():
                t2.e_remove()

        @self.push_step
        def _p2():
            t1.explainM(r"CD is a straight line, so the sum of $\angle{AEC}$ and $\angle{AED}$ "
                        r"equals two right angles (I.13)")
            t2.math(r"\alpha + \gamma = \rightangle + \rightangle")
            with self.simultaneous():
                l["BE"].e_fade()
                a["t"].e_fade()
                a["b"].e_fade()

        @self.push_step
        def _p3():
            t1.explainM(r"AB is a straight line, so the sum of $\angle{AED}$ and $\angle{DEB}$ equals "
                        "two right angles (I.13)")
            t2.math(r'\gamma + \beta = \rightangle + \rightangle')
            with self.simultaneous():
                l["BE"].e_normal()
                l["CE"].e_fade()
                a["b"].e_normal()
                a["a"].e_fade()

        @self.push_step
        def _p4():
            t1.explainM("Since the sums of the angles are equal to the same thing "
                        "(two right angles), they are equal to each other")
            with self.simultaneous():
                l["CE"].e_normal()
                a["a"].e_normal()
            t2.math(r'\alpha + \gamma = \gamma + \beta')

        @self.push_step
        def _p5():
            with self.simultaneous():
                t2.e_fade()
                t2.white(-1)
                a['g'].e_fade()
            t1.explainM(r"Thus $\angle{AEC}$ is equal to $\angle{DEB}$")
            t2.math(r'\therefore\quad \alpha = \beta')

        @self.push_step
        def _p6():
            t1.down()
            t1.explainM(r"CD is a straight line, so the sum of $\angle{DEB}$ and $\angle{CEB}$ "
                        r"equals two right angles (I.13)")
            with self.simultaneous():
                l['AE'].e_fade()
                a['t'].e_normal()
                a['a'].e_fade()
                a['g'].e_fade()
            t2.down()
            t2.e_fade()
            t2.math(r'\beta + \theta = \rightangle + \rightangle')

        @self.push_step
        def _p7():
            t1.explainM(r"AB is a straight line, so the sum of $\angle{AED}$ and $\angle{DEB}$ "
                        r"equals two right angles (I.13)")
            with self.simultaneous():
                l['CE'].e_fade()
                a['g'].e_normal()
                a['t'].e_fade()
                l['AE'].e_normal()
            t2.math(r'\gamma + \beta = \rightangle + \rightangle')

        @self.push_step
        def _p8():
            t1.explainM("Since the sums of the angles are equal to the same thing "
                        "(two right angles), they are equal to each other")
            with self.simultaneous():
                a['t'].e_normal()
                l['CE'].e_normal()
            t2.math(r'\beta + \theta = \gamma + \beta')

        @self.push_step
        def _p9():
            with self.simultaneous():
                t2.e_fade()
                t2.white(-1)
                a['b'].e_fade()
            t1.explainM(r"Thus $\angle{CEB}$ is equal to $\angle{AED}$")
            t2.math(r'\therefore\quad \theta = \gamma')

        @self.push_step
        def _p10():
            with self.simultaneous():
                a['b'].e_normal()
                a['a'].e_normal()
            with self.simultaneous():
                t2.e_fade()
                t2.blue(-1, 3)
