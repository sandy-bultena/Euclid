import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *


class Prop11(Book2Scene):
    title = ("In obtuse-angled triangles the square on the side subtending the "
   "obtuse angle is greater than the squares on the sides containing the "
   "obtuse angle by twice the rectangle contained by one of the sides about "
   "the obtuse angle, namely that on which the perpendicular falls, and the "
   "straight line cut off outside by the perpendicular towards the obtuse angle.")

    def go(self):
        # -------------------------------------------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500), name="explain")
        t3 = TextBox(mn_coord(160, 500))

        A = mn_coord(260, 400)
        B = mn_coord(140, 200)
        C = mn_coord(460, 400)
        D = (B[0],A[1],0)

        ACB_Colour = SKY_BLUE
        BDC_Colour = PINK
        BDA_Colour = GREEN

        box_colours = {"ACB": ACB_Colour,
                       "BDC": BDC_Colour,
                       "BDA": BDA_Colour,
                       }
        # -------------------------------------------------------------------------------------------------------------
        # In other words
        # -------------------------------------------------------------------------------------------------------------
        t1.down()
        t1.title("In other words")
        t1.explain("Given an obtuse triangle ABC where the obtuse angle is at point A and the base is AC:" )
        t1.add_marker()
        t1.explain("The square of BC equals the sum of the squares of AB and AC, plus...")
        t1.explain("... twice the rectangle formed by base AC and the extension of the base, AD, "
                   "where AD is the length from the base to the perpendicular from B to the base")

        sACB = ETriangle(A, C, B, point_labels=("A","C","B")).e_fill(ACB_Colour)
        pA, pC, pB = sACB.p
        lAC, lCB, lBA = sACB.l
        lAD = ELine(D,A)
        lBD = ELine(B,D)
        pD = EPoint(D).add_label("D",mn.DOWN)

        t1.add_marker()
        eq = t1.math(r"BC^2 = AB^2 + AC^2 + 2\cdot AD\cdot AC")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.down()
        t1.explain("Or... the cosine law")
        with self.simultaneous():
            lAC.add_label("b")
            lCB.add_label("a")
            lBA.add_label("c")
        t1.math(r"BC = a, \quad AB = c, \quad AC = b")
        aBAD = EAngle(lBA, lAD, label=r"\alpha", size=ANGLE_SIZE)
        t1.math(r"AD = c\cos \alpha")
        aBAC = EAngle(lBA, lAC, label=r"\theta", size=0.8*ANGLE_SIZE)
        t1.math(r" = -c\cos\theta", same_line=True)

        t1.math(r"a^2 = c^2 + b^2 - 2bc\cos\theta", transform_from=eq,
                transform_args=dict(key_map={'BC^2':'a^2','AB^2':'c^2', 'AC^2':'b^2', r'+ 2\cdot AD\cdot AC':r'- 2bc\cos\theta'}))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.delete_until_last_marker()
        t1.math(r"BC^2 = AB^2 + AC^2 = 2\cdot AD \cdot AC")
        t1.down()
        t1.title("Proof")
        with self.simultaneous():
            lAC.remove_label()
            lBA.remove_label()
            lCB.remove_label()
            aBAD.e_hide()
            aBAC.e_hide()
        t1.explain("Since the line DC is cut at point A, then we know that the square of DC is equal to the squares "
                   "of DA and AC plus twice the rectangle formed by DA and AC (II.4)")
        t3.math(r"DC^2 = DA^2 + AC^2 + 2\cdot DA\cdot AC", is_axiom = True)
        t3.add_marker()
        with self.simultaneous():
            lAD.add_label("x")
            lAC.add_label("y")
        t3.math(r"(x+y)^2 = x^2 + y^2 + 2xy", transform_from=-1,
                transform_args=dict(key_map={
                    "DC":"(x+y)", "DA^2":"x^2","AC^2":"y^2",r"2\cdot DA\cdot AC":"2xy"
                }))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t3.delete_until_last_marker()
        t1.explain("Add the square of DB to both sides of the equality")
        with self.simultaneous():
            lAD.e_remove_label()
            lAC.e_remove_label()
        t3.math(r"(DC^2 + DB^2) = (DA^2 + DB^2) + AC^2 + 2\cdot DA\cdot AC", transform_from=-1,
                transform_args=dict(key_map={"DC^2":"(DC^2 + DB^2)", "= DA^2":"= (DA^2 + DB^2)"}))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The squares of DC and DB equals the square of BC (I.47)")
        sBDC = ETriangle(pB, pD, pC, skip_anim=True)
        with self.simultaneous():
            sACB.e_hide()
            pB.e_normal()
            pC.e_normal()
            sBDC.e_fill(BDC_Colour)
            lBA.e_fade()
            pA.e_normal()
        t3.e_fade()
        t3.math("DC^2 + DB^2 = BC^2")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t3.e_normal(-2)
        t3.math(r"BC^2 = (DA^2 + DB^2) + AC^2 + 2\cdot DA\cdot AC", transform_from=t3[-2],
                transform_args=dict(key_map={'(DC^2 + DB^2)':'BC^2'}))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The squares of DA and DB equals the square of AB (I.47)")
        sBDA = ETriangle(pB, pD, pA, skip_anim=True)
        with self.simultaneous():
            sBDC.e_hide()
            sBDA.e_fill(BDA_Colour)
            lAC.e_fade()
            lCB.e_fade()
        t3.e_fade()
        t3.math("DA^2 + DB^2 = AB^2")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t3.e_normal(-2)
        t3.math(r"BC^2 = AB^2 + AC^2 + 2\cdot DA\cdot AC", transform_from=t3[-2],
                transform_args=dict(key_map={'BC^2':'BC^2', '(DA^2 + DB^2)':'AB^2'}))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Thus the square of BC is equal to the sum of the squares of AB and AC, plus the rectangle "
                   "formed by DA,AC")
        with self.simultaneous():
            sBDA.e_hide()
            sACB.e_normal()
        t3.e_fade()
        t3.e_normal( -1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            lAC.add_label("b")
            lCB.add_label("a")
            lBA.add_label("c")
            lAD.add_label(r"-c\cos\theta")
            aBAC.e_normal()
        t3.math(r"a^2 = c^2 + b^2 - 2bc\cos\theta",  transform_from=-1,
                transform_args=dict(key_map={'BC^2':'a^2','AB^2':'c^2', 'AC^2':'b^2', r'+ 2\cdot AD\cdot AC':r'- 2bc\cos\theta'}))
        self.next_page()




