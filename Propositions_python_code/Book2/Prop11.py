import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *


class Prop11(Book2Scene):
    title = ("To cut a given straight line so that the rectangle contained by the whole and one of the segments "
             "is equal to the square on the remaining segment.")

    def go(self):
        # -------------------------------------------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500), name="explain")
        t2 = TextBox(mn_coord(520, 200), name="lines")
        t6 = TextBox(mn_coord(500, 280), name="squares")

        A = mn_coord(160, 300)
        B = mn_coord(380, 300)
        Hp = (.7 * (B[0] - A[0]) + A[0], A[1])

        FH_colour =PALE_GREEN
        HD_colour = PALE_BLUE
        AD_colour = BLUE
        FK_colour = GREEN
        AEB_colour = YELLOW

        box_colours = {"FH": FH_colour,
                       "HD": HD_colour,
                       "AD": AD_colour,
                       "FK": FK_colour,
                       }
        # -------------------------------------------------------------------------------------------------------------
        # In other words
        # -------------------------------------------------------------------------------------------------------------
        t1.title("In other words")
        t1.explain("Find the point H on the line AB such that the rectangle formed by AB and BH is "
                   "equal to the square on AH" )
        pA = EPoint(A).add_label('A', mn.LEFT)
        pB = EPoint(B).add_label('B', mn.RIGHT)
        lAB = ELine(A, B)
        pHt = EPoint(Hp).add_label(" H?", mn.UP)
        t2.math(r"AB\cdot BH = AH^2")
        with self.simultaneous():
            lAH = ELine(A, Hp, label=("a", dict(side=LineLabelSide.INSIDE)))
            lHB = ELine(Hp, B, label=("b", dict(side=LineLabelSide.INSIDE)))
        t2.math(r"(a+b)\,b = a^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        t2.delete_until_last_marker()
        t1.add_marker()
        t1.down()
        t1.title("Construction")
        t1.explain("Draw a square ABCD on AB (I.46) and bisect AC (I.10) at {nb:point E}")
        with self.simultaneous():
            pHt.e_remove()
            lAH.e_hide()
            lHB.e_hide()
        sAB = ESquare (pA, pB)
        pC, _, _, pD = sAB.p
        lAB.e_delete()
        lAC, lAB, lBD, lCD = sAB.l
        pC.add_label("C",mn.DOWN)
        pD.add_label("D",mn.DOWN)
        pE = lAC.bisect().add_label("E",mn.LEFT)
        t6.math("AE = EC")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Let EB be joined, and extend CA to F such that EF {nb:equals AB}")

        lEB = ELine( pE, pB )
        lACt = ELine(pA,pC,skip_anim=True).e_fade()
        lACt.prepend(2)
        cE = ECircle( pE, pB ).e_fade()
        c = cE.intersect( lACt )[0]
        pF = EPoint( c ).add_label( "F", mn.UL )
        lAF = ELine( pA, pF )

        t6.math("EF = EB")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "Draw a square FAGH on FA, and extend GH to line CD at point K")
        with self.simultaneous():
            lACt.e_remove()
            cE.e_remove()

        sFH = ESquare(  pA, pF )
        pH,_,_,pG = sFH.p
        lAH, lAF, lFG, lGH = sFH.l
        pG.add_label("G", mn.RIGHT)
        pF.add_label("F", mn.LEFT)
        pH.add_label("H", mn.UR)

        lHK = lAB.perpendicular(pH, length = lAB.length)
        pK = EPoint(lHK.end, label=("K", mn.DOWN))
        t6.math("FA = AH")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "The point H has been defined such that FH equals HD " )
        t6.add_marker()
        sHD = EPolygon( pH, pK, pD, pB, skip_anim=True )
        sFH.e_fill(FH_colour)
        sHD.e_fill(HD_colour)
        print("COLOURS:", box_colours)
        t6.math(r"\square FH = \square HD", colours=box_colours)
        t6.math(r"AB\cdot BH = AH\cdot AH")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t1.down()
        t1.delete_until_last_marker()
        t6.delete_until_last_marker()
        t6.down()
        t1.add_marker()

        t1.title("Proof")
        t1.explain("From proposition 6 (II.6), if we have a bisected line, and an addition to that line, "
                "then the extended line CF times the extension AF plus the square on AE is equal to the square {nb:on EF}")

        with self.simultaneous():
            sFH.e_fade()
            sAB.e_hide()
            sHD.e_fade()
            lEB.e_fade()
            lHK.e_hide()
            lCD.e_fade()
            lAC.e_normal()
            pC.e_normal()
            pB.e_fade()
            pK.e_fade()


        t6.e_fade()
        t6.math(r"CF\cdot AF + AE^2 = EF^2", break_into_parts=(r"CF\cdot AF"," + AE^2 = EF^2"))
        t6.add_marker()
        with self.simultaneous():
            lEC = ELine(pE, pC, skip_anim=True).add_label("x")
            lAC = ELine(pA, pE, skip_anim=True).add_label("x")
            lAF.add_label("y", side=LineLabelSide.INSIDE)
        t6.math(r"(2x+y)\,y + x^2 = (x+y)^2")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t6.delete_until_last_marker()
        t1.explain("But EB equals EF")
        with self.simultaneous():
            pG.e_normal()
            lFG.e_normal()
            lGH.e_normal()
            lAB.e_normal()
            lEB.e_normal()
            pB.e_normal()
            pK.e_normal()
            pD.e_normal()
            pH.e_normal()
            lBD.e_normal()
            lCD.e_normal()
            lEC.remove_label()
            lAC.remove_label()
            lAF.remove_label()

        t6.e_normal(1)
        t6.math(r"CF\cdot AF + AE^2 = EB^2", break_into_parts=(r"CF\cdot AF"," + AE^2"," = EB^2"))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "Triangle AEB is right angle triangle, thus the square on AB plus the square on AE equals "
                    "the square on EB (I.47)" )
        tAEB = ETriangle(pA, pE, pB, skip_anim=True).e_fill(AEB_colour)
        t6.e_fade()
        t6.math(r"AB^2 + AE^2 = EB^2", align_str="=", break_into_parts=(r"AB^2"," + AE^2"," = EB^2"))

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "By comparing the equalities, we see that the square of AB is equal to the rectangle "
                    "formed by CF and AF" )
        with self.simultaneous():
            tAEB.e_hide()
        with self.simultaneous():
            t6.e_normal(-2)
            t6[-2].parts[1].green()
            t6[-1].parts[1].green()
            t6[-2].parts[2].green()
            t6[-1].parts[2].green()
        t6.math(r"AB^2 = CF\cdot AF")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The square of AB is the rectangle AD")
        sAD = EPolygon(pA, pC, pD, pB, skip_anim=True)
        with self.simultaneous():
            tAEB.e_hide()
            lEB.e_fade()
            sAD.e_fill(AD_colour)
        t6.e_fade()
        t6.math(r"AB^2 = \square AD", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "The rectangle CF,AF is the rectangle FK, since AF equal AH")
        sFK = EPolygon(pF, pC, pK, pG, skip_anim=True)
        with self.simultaneous():
            lAH.e_fade()
            lAB.e_hide()
            sAD.e_hide()
            sFK.e_fill(FK_colour)
        t6.e_fade()
        t6.math(r"CF\cdot AF = \square FK", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        sAD.e_normal()
        t6.e_normal(-1,-2,-3)
        t6.math(fr"\square AD = \square FK", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Subtract AK from both sides of the quality, and FH equals HD")
        with self.simultaneous():
            sFK.e_hide()
            sAD.e_hide()
            sFH.e_normal()
            sHD.e_normal()
        with self.simultaneous():
            t6.e_fade()
            t6.e_normal(-1)
        t6.math(r"\square FH = \square HD", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("But FH is formed as the square on AH, and HD is the rectangle formed by AB,BH since AB equals BD" )
        t1.explain("Thus AH squared is equal to AB times BH")

        t6.e_fade(-2)
        t6.math(r"AH\cdot AH = AB\cdot BH")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t6.e_normal(0,1,2)
            t6.e_fade(-2)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.down()
        t1.title("Golden Ratio")
        t1.explain("The golden ratio is defined as:")
        t1.math(r" {a\over b} = {a+b\over b},\quad \text{where}\quad a > b")
        t1.explain("Since AB is equal to AH + AB, this proposition find H such that")
        t1.math(r"AH\cdot AH = (AH + BH)\cdot BH")
        t1.explain("or, the golden ratio...")
        t1.math(r"{AH\over BH} = {AH + BH\over AH}")
        self.next_page()



