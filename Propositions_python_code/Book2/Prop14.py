import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *
from typing import Dict


class Prop14(Book2Scene):
    steps = []
    title = "To construct a square equal to a given rectilinear figure."

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(200, 530))
        t3 = TextBox(mn_coord(470, 200))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, mn.Mobject] = {}

        A = (mn_coord(150, 160),
             mn_coord(300, 185),
             mn_coord(250, 310),
             mn_coord(90, 235))
        K = mn_coord(80, 650)

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        t1.title("Construction:")
        t1.explain("Let A be the given rectilinear figure")
        s['A'] = EPolygon(*A, label= 'A')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Copy A to a rectangle{nb}(I.45)")
        p['K'] = EPoint(K)
        s['R'] = s['A'].copy_to_rectangle(p['K'])
        with self.simultaneous():
            s['R'].set_point_labels(("C", LEFT), ("D", DR), ('E', DR), ('B', LEFT))
        C,D,E,B,*remainder = s['R'].p
        t3.math(r'\square A = \square BD', is_axiom=True)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("If BE does not equal ED, and if BE is the larger, extend BE to F, where EF equals ED")
        l['BF'] = s['R'].l2.copy()
        l['BF'].prepend(mn_scale(100))
        c['E'] = ECircle(E, D).e_fade()
        cuts = c['E'].intersect(l['BF'])
        F = p['F'] = EPoint(cuts[0], label=('F', DOWN))
        l['BF'].e_remove()
        l['BF'] = ELine(B,F)
        t3.math(r'EF = ED', is_axiom=True)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Bisect BF (and label it point G)")
        c['E'].e_remove()
        G = p['G'] = l['BF'].bisect().add_label('G', UL)
        t3.math(r'BG = GF',is_axiom=True)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Draw a circle with G as the center and GF as the radii")
        c['G'] = ECircle(p['G'], p['F']).e_fade()

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Extend DE to intersect with the circle at "
                   "point H, and let GH be joined")
        l['H1'] = s['R'].l1.copy().extend(mn_scale(200))
        H = p['H'] = EPoint(c['G'].intersect(l['H1'])[0], label=('H', UP))
        #Ep['E'] = s['R'].p1

        l['H1'].e_remove()
        with self.simultaneous():
            l['H'] = ELine(E,H)
            l['G'] = ELine(G,H)

        t3.math(r'GH = GF', is_axiom=True)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("The square on HE is equal in area to figure A")
        s['EH'] = ESquare(*l['H'].get_start_and_end())
        with self.simultaneous():
            s['A'].e_fill(BLUE_D)
            s['EH'].e_fill(GREEN_D)
        t3.math(r'\square HE = A')

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            t3.delete_last()
            t1.e_remove()

        t1.title("Proof:")

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Polygon A equals the polygon BD by construction")
        with self.simultaneous():
            s['A'].e_fill(BLUE_D)
            s['R'].e_fill(BLUE_D)
            s['EH'].e_fade()
            l['H'].e_fade()
            l['BF'].e_fade()
            l['G'].e_fade()


        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            s['A'].e_fade()
            s['R'].e_fade()
            s['EH'].e_fade()

            l['BF'].e_normal()
            E.e_normal()
            B.e_normal()

        t1.explain("Line BF is divided into equal (G) and unequal "
                   "segments{nb}(E), thus the rectangle formed by BE,EF "
                   "plus the square "
                   "of EG is equal to the square on GF{nb}(II.5)")

        with self.simultaneous():
            t3.e_fade()
            t3.blue(2)
        t3.math(r'BE \cdot EF + EG^2 = GF^2')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Since GHE is a right triangle, and GH is equal to GF, "
                   "the square of GF is equal to the sum of the squares on "
                   "EG and GH (I.47)")

        s['GHE'] = ETriangle(G,H,E).e_fill(PINK)

        with self.simultaneous():
            t3.e_fade()
            t3.blue(3)
        t3.math(r'GH^2 = EG^2 + EH^2')
        t3.math(r'GF^2 = EG^2 + EH^2', transform_from=-1)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Thus the rectangle formed"
                   " by BE,EF plus the square of EG is equal to the sum of "
                   "the squares "
                   "on EG and GH")

        s['GHE'].e_fade()

        with self.simultaneous():
            t3.e_fade()
            t3.e_normal(-1, -3)
        t3.math(r'BE \cdot EF + EG^2  = EG^2 + EH^2', transform_from=-3, )

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Subtracting EG from both sides of the equality, "
                   "gives BE,EF equals the square of EH")


        with self.simultaneous():
            t3.e_fade()
            t3.e_normal(-1)

        t3.math(r'BE \cdot EF  = EH^2', transform_from=-1)



        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("The rectangle formed by BE,EF is BD, since EF equals ED ")
        with self.simultaneous():
            s['R'].e_normal()
        s['R'].e_fill(BLUE_D)

        with self.simultaneous():
            t3.e_fade()
            t3.e_normal(1)

        t3.math(r' BE\cdot EF  = \square BD')


        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Therefore BD equals the square on EH")
        with self.simultaneous():
            s['EH'].e_normal()
            t3.e_fade()
            t3.e_normal(-1,-2)
        t3.math(r'\square BD = EH^2')
        s['EH'].e_fill(BLUE_D)



        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Therefore polygon 'A' equals the square on EH")
        with self.simultaneous():
            s['A'].e_normal()
            t3.e_fade()
            t3.blue(0)
            t3.e_normal(-1)


        t3.math(r'\square A = EH^2 = \square EH')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t3.math(r'\square A = \square EH', transform_from=-1)
        with self.simultaneous():
            s['A'].e_normal()
            t3.e_fade()
            t3.blue(0)
            t3.e_normal(-1)
            G.e_fade()
            F.e_fade()
            s['R'].e_fade()
            s['GHE'].e_fade()
            E.e_normal()



