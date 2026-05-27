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

        A_colour = GREEN
        BD_colour = BLUE
        HE_colour = PINK
        GHE_colour = YELLOW

        box_colours = {"A": A_colour,
                       "BD": BD_colour,
                       "HE": HE_colour,
                       "EH": HE_colour,
                       "GHE": GHE_colour,
                       }


        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        t1.title("Construction:")
        t1.explain("Let A be the given rectilinear figure")
        sA = EPolygon(*A, label= 'A').e_fill(A_colour)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Copy A to a rectangle{nb}(I.45)")
        pK = EPoint(K)
        sR = sA.copy_to_rectangle(pK)
        with self.simultaneous():
            sR.set_point_labels(("C", LEFT), ("D", DR), ('E', DR), ('B', LEFT))
            sR.e_fill(BD_colour)
        C,D,E,B,*remainder = sR.p
        t3.math(r'\square A = \square BD', is_axiom=True, colours=box_colours)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("If BE does not equal ED, and if BE is the larger, extend BE to F, where EF equals ED")
        lBF = sR.l2.copy()
        lBF.prepend(mn_scale(100))
        cE = ECircle(E, D).e_fade()
        cuts = cE.intersect(lBF)
        F = pF = EPoint(cuts[0], label=('F', DOWN))
        lBF.e_remove()
        lBF = ELine(B,F)
        t3.math(r'EF = ED', is_axiom=True)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Bisect BF (and label it point G)")
        cE.e_remove()
        G = pG = lBF.bisect().add_label('G', UL)
        t3.math(r'BG = GF',is_axiom=True)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Draw a circle with G as the center and GF as the radii")
        cG = ECircle(pG, pF).e_fade()

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Extend DE to intersect with the circle at "
                   "point H, and let GH be joined")
        lH1 = sR.l1.copy().extend(mn_scale(200))
        H = pH = EPoint(cG.intersect(lH1)[0], label=('H', UP))
        #EpE = sR.p1

        lH1.e_remove()
        with self.simultaneous():
            lH = ELine(E,H)
            lG = ELine(G,H)

        t3.math(r'GH = GF', is_axiom=True)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("The square on HE is equal in area to figure A")
        sEH = ESquare(*lH.get_start_and_end())
        with self.simultaneous():
            sEH.e_fill(HE_colour)
        t3.math(r'\square HE = \square A', colours=box_colours)

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
            sEH.e_fade()
            lH.e_fade()
            lBF.e_fade()
            lG.e_fade()

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            sA.e_fade()
            sR.e_fade()
            sEH.e_fade()

            lBF.e_normal()
            E.e_normal()
            B.e_normal()
            pH.e_fade()

        t1.explain("Line BF is divided into equal (G) and unequal "
                   "segments{nb}(E), thus the rectangle formed by BE,EF "
                   "plus the square "
                   "of EG is equal to the square on GF{nb}(II.5)")

        lBG = ELine(pG, B, skip_anim=True)
        lGE = ELine(E, pG, skip_anim=True)
        lEF = ELine(F, E, skip_anim=True)
        with self.simultaneous():
            t3.e_fade()
            t3.blue(2)
            lBG.add_label("x")
            lGE.add_label("y")
            lEF.add_label("x-y")
            pG.add_label("G", mn.DOWN)
        t3.math(r'BE \cdot EF + EG^2 = GF^2')
        t3.add_marker()
        t3.math(r"(x+y)(x-y) + y^2 = x^2", transform_from=-1,
                transform_args=dict(
                    key_map={r'BE \cdot EF':"(x+y)(x-y)",
                             'EG^2':'y^2', 'GF^2':'x^2'
                             }
                )
                )

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t3.delete_until_last_marker()
        with self.simultaneous():
            lBG.e_hide()
            lGE.e_hide()
            lEF.e_hide()
            pH.e_normal()

        t1.explain("Since GHE is a right triangle, and GH is equal to GF, the square of GF is equal to the sum of "
                   "the squares on EG and GH (I.47)")

        sGHE = ETriangle(G,H,E).e_fill(GHE_colour)

        with self.simultaneous():
            t3.e_fade()
            t3.blue(3)
        t3.math(r'GH^2 = EG^2 + EH^2')
        t3.math(r'GF^2 = EG^2 + EH^2', transform_from=-1,
                transform_args=dict(key_map={
                    'GH^2':'GF^2'
                }))

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Thus the rectangle formed by BE,EF plus the square of EG is equal to the sum of "
                   "the squares on EG and GH")

        sGHE.e_fade()

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
            sR.e_normal()
            pG.add_label("G",mn.UL)
        sR.e_fill(BLUE_D)

        with self.simultaneous():
            t3.e_fade()
            t3.e_normal(1)

        t3.math(r' BE\cdot EF  = \square BD', colours=box_colours)


        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Therefore BD equals the square on EH")
        with self.simultaneous():
            sEH.e_normal()
            t3.e_fade()
            t3.e_normal(-1,-2)
        t3.math(r'\square BD = EH^2', colours=box_colours)




        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Therefore polygon 'A' equals the square on EH")
        with self.simultaneous():
            sA.e_normal()
            t3.e_fade()
            t3.e_normal(0)
            t3.e_normal(-1)


        t3.math(r'\square A = EH^2 = \square EH', colours = box_colours)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t3.math(r'\square A = \square EH', transform_from=-1, colours=box_colours)
        with self.simultaneous():
            sA.e_normal()
            t3.e_fade()
            t3.e_normal(0)
            t3.e_normal(-1)
            G.e_fade()
            F.e_fade()
            sR.e_fade()
            sGHE.e_fade()
            E.e_normal()

        self.next_page()


