import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book01 import Book1Scene
from euclidlib.Objects import *
from typing import Dict


class Prop15(Book1Scene):
    steps = []
    title = ("If two straight lines cut one another, then they make "
             "the vertical angles equal to one another.")

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(475, 430))

        l: Dict[str | int, ELine] = self.l
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}

        A = mn_coord(150, 250)
        B = mn_coord(300, 500)
        C = mn_coord(100, 400)
        D = mn_coord(400, 400)
        E = mn_coord(400, 375)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        t1.title("In other words:")
        t1.explain("Given two arbitrary line segments AB "
                   "and CD which intersect at {nb:point E}")
        with self.simultaneous():
            p["A"] = EPoint(A, label=("A", dict(away_from=B)))
            p["B"] = EPoint(B, label=("B", dict(away_from=A)))
        l["AB"] = ELine(A, B)
        with self.simultaneous():
            p["C"] = EPoint(C, label=("C", LEFT))
            p["D"] = EPoint(D, label=("D", RIGHT))
        l["CD"] = ELine(C, D)
        p['E'] = l['CD'].intersection_e_point(l['AB']).add_label('E', away_from = mn.midpoint(A, D))

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explainM(r"$\measuredangle{AEC}$ and $\measuredangle{DEB}$ are equal")
        t1.explainM(r"$\measuredangle{AED}$ and $\measuredangle{CEB}$ are equal")
        l["CE"], l["DE"] = l["CD"].e_split(p["E"])
        l["AE"], l["BE"] = l["AB"].e_split(p["E"])
        with self.simultaneous():
            a["a"] = EAngle(*self.lines('AEC'), label=r"\alpha")
            a["b"] = EAngle(*self.lines("BED"), label=r"\beta")
        with self.simultaneous():
            a["g"] = EAngle(*self.lines("AED"), label=r"\gamma", size=mn_scale(50))
            a["t"] = EAngle(*self.lines("BEC"), label=r"\theta", size=mn_scale(50))
        t2.math(r"\alpha=\beta")
        t2.math(r"\gamma=\theta")

        self.next_page()

        # ------------------------------------------------------------------------
        # Proof
        # ----------------------------------------------
        t1.down()
        t1.title("Proof:")
        with self.simultaneous():
            t2.e_remove()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explainM(r"CD is a straight line, so the sum of $\measuredangle{AEC}$ and $\measuredangle{AED}$ "
                    r"equals two right angles (I.13)")
        t2.math(r"\alpha + \gamma = \rightangle + \rightangle")
        with self.simultaneous():
            l["BE"].e_fade()
            a["t"].e_fade()
            a["b"].e_fade()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explainM(r"AB is a straight line, so the sum of $\measuredangle{AED}$ and $\measuredangle{DEB}$ equals "
                    "two right angles (I.13)")
        t2.math(r'\gamma + \beta = \rightangle + \rightangle')
        with self.simultaneous():
            l["BE"].e_normal()
            l["CE"].e_fade()
            a["b"].e_normal()
            a["a"].e_fade()

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explainM("Since the sums of the angles are equal to the same thing "
                    "(two right angles), they are equal to each other")
        with self.simultaneous():
            l["CE"].e_normal()
            a["a"].e_normal()
        t2.math(r'\alpha + \gamma = \gamma + \beta')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t2.e_fade()
            t2.white(-1)
            a['g'].e_fade()
        t1.explainM(r"Thus $\measuredangle{AEC}$ is equal to $\measuredangle{DEB}$")
        t2.math(r'\therefore\quad \alpha = \beta')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.down()
        t1.explainM(r"CD is a straight line, so the sum of $\measuredangle{DEB}$ and $\measuredangle{CEB}$ "
                    r"equals two right angles (I.13)")
        with self.simultaneous():
            l['AE'].e_fade()
            a['t'].e_normal()
            a['a'].e_fade()
            a['g'].e_fade()
        t2.down()
        t2.e_fade()
        t2.math(r'\beta + \theta = \rightangle + \rightangle')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explainM(r"AB is a straight line, so the sum of $\measuredangle{AED}$ and $\measuredangle{DEB}$ "
                    r"equals two right angles (I.13)")
        with self.simultaneous():
            l['CE'].e_fade()
            a['g'].e_normal()
            a['t'].e_fade()
            l['AE'].e_normal()
        t2.math(r'\gamma + \beta = \rightangle + \rightangle')

        self.next_page()

        # ------------------------------------------------------------------------
        t1.explainM("Since the sums of the angles are equal to the same thing "
                    "(two right angles), they are equal to each other")
        with self.simultaneous():
            a['t'].e_normal()
            l['CE'].e_normal()
        t2.math(r'\beta + \theta = \gamma + \beta')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            t2.e_fade()
            t2.white(-1)
            a['b'].e_fade()
        t1.explainM(r"Thus $\measuredangle{CEB}$ is equal to $\measuredangle{AED}$")
        t2.math(r'\therefore\quad \theta = \gamma')

        self.next_page()

        # ------------------------------------------------------------------------
        with self.simultaneous():
            a['b'].e_normal()
            a['a'].e_normal()
        with self.simultaneous():
            t2.e_fade()
            t2.blue(-1, 3)
