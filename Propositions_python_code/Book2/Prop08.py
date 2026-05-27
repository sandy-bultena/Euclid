import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *

class Prop8(Book2Scene):
    title =  "If a straight line be cut at random, four times the rectangle contained by the whole and one of the segments together "\
   "with the square on the remaining segment is equal to the square described on the whole and "\
   "aforesaid segment as on one straight line."

    def go(self):

        # -------------------------------------------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500), name="explanation")
        t4 = TextBox(mn_coord(800, 150), line_width=mn_scale(480))
        t5 = TextBox(mn_coord(500, 200), name="math_intro")
        t2 = TextBox(mn_coord(100, 500), name="math")
        t3 = TextBox(mn_coord(500, 500), name="aside")

        A = mn_coord(120, 180)
        B = mn_coord(350, 180)
        C = mn_coord(280, 180)

        AG_colour = SKY_BLUE
        RF_colour = LIME_GREEN
        QL_colour = GREEN
        MQ_colour = BLUE
        CK_colour = Colour.add(AG_colour, QL_colour)
        BN_colour = Colour.add(RF_colour, AG_colour)
        KP_colour = Colour.add(MQ_colour, RF_colour)
        GR_colour = Colour.add(MQ_colour, QL_colour)
        OH_colour = PALE_PINK
        AK_colour = Colour.add(AG_colour, CK_colour)
        STU_colour = Colour.add(AG_colour, CK_colour, BN_colour, MQ_colour, GR_colour, KP_colour, QL_colour, RF_colour)

        box_colours = {"AG": AG_colour,
                       "RF": RF_colour,
                       "QL": QL_colour,
                       "MQ": MQ_colour,
                       "CK": CK_colour,
                       "BN": BN_colour,
                       "KP": KP_colour,
                       "GR": GR_colour,
                       "OH": OH_colour,
                       "AK": AK_colour,
                       "STU": STU_colour,
                       }

        # -------------------------------------------------------------------------------------------------------------
        # In other words
        # -------------------------------------------------------------------------------------------------------------
        t1.title("In other words")
        t1.explain("Let AB be a straight line, arbitrarily cut at point C")
        with self.simultaneous():
            pA = EPoint( A ).add_label('A', mn.LEFT)
            pB = EPoint( B ).add_label('B', mn.RIGHT)
            lAC = ELine(C,A).add_label("x")
            lBC = ELine(B, C).add_label("y")
            pC = EPoint( C ).add_label('C', mn.UP)
        lAB = ELine(A,B, skip_anim=True)
        t2.math("AB = AC + CB", is_axiom=True)
        t2.add_marker()
        t3.math('AB = x+y')
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.add_marker()
        t1.explain(    "Then four times the rectangle formed by lines AB and BC plus the "
                r"square of AC is equal to the square of AB {nb:added to BC}" )
        t2.math(r"4\cdot AB\cdot BC + AC^2 =(AB+BC)^2")
        t3.math("4(x+y)y + x^2 = (x+2y)^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.math(r"4\cdot AB\cdot BC + AC^2 =(AB+BC)^2", transform_from=t2[-1])
        with self.simultaneous():
            t2.delete_until_last_marker()
            t3.delete_until_last_marker()

        t1.add_marker()
        t1.down()
        t1.title("Construction:")
        t1.explain("Extend the line AB to point D such that CB is equal to BD")
        pB.add_label("B", mn.UP)
        laV = ELine(C,B).extend(mn_scale(200)).e_fade()
        c = ECircle(pB, pC).e_fade()
        pD = EPoint(laV.intersect(c)[0]).add_label("D", mn.UP)
        lBD = ELine(pD,B,label="y")
        laV.e_remove()
        t5.math("AB = AC + CB", is_axiom=True, transform_from=t2[-1])
        t5.math(r", \quad CB = BD", is_axiom=True, same_line=True)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Draw a square AEFD on the line AD (I.46), and draw the diagonal DE" )
        c.e_remove()
        sAF = ESquare(pD, pA, clockwise=True)
        pF,pD,pA,pE = sAF.p
        lDF, lAD, lAE, lEF = sAF.l
        with self.simultaneous():
            pF.add_label("F",mn.RIGHT)
            pE.add_label("E", mn.LEFT)
        lDE = ELine(pD, pE)
        self.next_page()


        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Draw lines CH,BL parallel to AE (I.31)")
        lCH = lBC.perpendicular(pC, length = lAB.length + lBD.length, side=LineLabelSide.INSIDE)
        pH = EPoint(lCH.end,label=("H", mn.DOWN))
        pQ = EPoint(lCH.intersect(lDE)[0]).add_label("Q",mn.DR)
        lBL = lBC.perpendicular(pB, length = lAB.length + lBD.length, side=LineLabelSide.INSIDE)
        pL = EPoint(lBL.end, label=("L", mn.DOWN))
        pK = EPoint(lBL.intersect(lDE)[0]).add_label("K",mn.DR)

        t1.explain("Draw lines MN,OP parallel to AD (I.31)")
        with self.simultaneous():
            lKM = lBL.perpendicular(pK, length = lBC.length+ lAC.length)
            lKN = lBL.perpendicular(pK, length = lBD.length, side=LineLabelSide.INSIDE)
            lOQ = lCH.perpendicular(pQ, length = lAC.length)
            lPQ = lCH.perpendicular(pQ, length = 2*lBD.length, side=LineLabelSide.INSIDE)

        with self.simultaneous():
            pM = EPoint(lKM.end, label=("M", mn.LEFT))
            pN = EPoint(lKN.end, label=("N", mn.RIGHT))
            pO = EPoint(lOQ.end, label=("O", mn.LEFT))
            pP = EPoint(lPQ.end, label=("P", mn.RIGHT))
            pG = EPoint(lKM.intersect(lCH)[0]).add_label("G",mn.UR)
            pR = EPoint(lPQ.intersect(lBL)[0]).add_label("R", mn.DR)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        lDE.e_fade()
        t1.down()
        t1.title("Proof:")
        t1.add_marker()
        t1.explain("Since CB is equal to BD, and CB is also equal to GK (I.34) "
        "and BD is equal to KN, then GK is equal to KN" )
        t1.explain("Similarly, QR is equal to RP")
        t5.math("GK = KN")
        t5.math("QR = RP ")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Thus CK and BN are equal, as are GR and KP (I.36)")
        sCK = EPolygon(pC, pG, pK, pB, skip_anim=True ).e_fill(CK_colour)
        sBN = EPolygon(pN, pK, pB, pD, skip_anim=True ).e_fill(BN_colour)
        sGR = EPolygon(pG, pQ, pR, pK, skip_anim=True ).e_fill(GR_colour)
        sKP = EPolygon(pK, pR, pP, pN, skip_anim=True ).e_fill(KP_colour)
        t5.math(r"\square CK = \square BN", colours=box_colours)
        t5.math(r"\square GR = \square KP ", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("CK and KP are equaL (I.43)")
        with self.simultaneous():
            sBN.e_fade()
            sGR.e_fade()
        t5.e_fade()
        t5.math(r"\square CK = \square KP", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.explain("Therefore CK, BN, GR, KP are all equal, and the sum equals four CK")
        t1.add_marker()
        with self.simultaneous():
            sBN.e_normal()
            sGR.e_normal()

        t5.e_normal(-1,-2,-3)
        t2.math(r"\square CK = \square BN = \square GR = \square KP", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Again, since CB is equal to BD, and BD is also equal to BK which is equal to CG, "
                      "and CB is equal to GK, which is equal to GQ, then CG is equal to GQ" )
        with self.simultaneous():
            sCK.e_fade()
            sGR.e_fade()
            sBN.e_fade()
            sKP.e_fade()

        t5.e_fade()
        t5.math("CG = GQ")
        t2.e_fade()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Thus AG and MQ are equal, as are QL and RF (I.36)")
        with self.simultaneous():
            sAG = EPolygon(pA, pM, pG, pC, skip_anim=True).e_fill(AG_colour)
            sMQ = EPolygon(pM,pO, pQ, pG, skip_anim=True).e_fill(MQ_colour)
            sQL = EPolygon(pQ, pH, pL, pR, skip_anim=True).e_fill(QL_colour)
            sRF = EPolygon(pL, pR, pP, pF, skip_anim=True).e_fill(RF_colour)
            lHQ = sQL.l[0]
        t5.math(r"\square AG = \square MQ", colours=box_colours)
        t5.math(r"\square QL = \square RF", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("MQ and QL are equal (I.43)")
        with self.simultaneous():
            sAG.e_fade()
            sRF.e_fade()
        t5.e_fade()
        t5.math(r'\square MQ = \square QL', colours = box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.explain("Therefore MQ,QL,AG,RF are all equal, and the sum of the areas is {nb:four AG}")
        with self.simultaneous():
            sAG.e_normal()
            sRF.e_normal()
        t5.e_normal(-1,-2,-3)
        t2.math(r"\square MQ = \square QL = \square AG = \square RF", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "The gnomon STU is equal to the sum of all eight areas, which is also equal to four times AG plus CK" )
        with self.simultaneous():
            sCK.e_normal()
            sBN.e_normal()
            sKP.e_normal()
            sGR.e_normal()
        aSTU = EAngle(lOQ, lHQ, gnomon=True, size=mn_scale(120), label=("S","T","U"))

        with self.simultaneous():
            t5.e_fade()
            t2.e_normal()
        t2.math(r"\square STU = 4\cdot (\square AG + \square CK) = 4\cdot \square AK", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "AK is the rectangle formed by AB, BD (since BK equals BD), hence four AK is equal to four"
                    " times AB, BD, which is also equal to the {nb:gnomon STU}")

        sAK= EPolygon(pA, pM, pK, pB, skip_anim=True)
        with self.simultaneous():
            sAK.e_fill(box_colours["AK"])
            sMQ.e_fade()
            sGR.e_fade()
            sBN.e_fade()
            sKP.e_fade()
            sQL.e_fade()
            sRF.e_fade()
            sAG.e_hide()
            sCK.e_hide()

        with self.simultaneous():
            t2.e_fade()
            t2.e_normal(-1)
        t2.math(r'\square STU = 4\cdot \square AK = 4\cdot AB\cdot BD', colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "Add the square of AC (which is also equal to OH) and we have four times the rectangle AB,BD plus "
                      "the square of AC is equal to the gnomon plus OH, which is equal to the {nb:square of AD}" )
        sSTU = EPolygon(pO,pQ,pH, pF, pD, pA, skip_anim=True)
        sOH = EPolygon(pE, pH, pQ, pO, skip_anim=True)
        with self.simultaneous():
            sAK.e_hide()
            sSTU.e_fill(STU_colour)
            sOH.e_fill(OH_colour)
            # sMQ.e_hide()
            # sQL.e_hide()
            # sRF.e_hide()
            #
            # sAK.e_hide()
            # sBN.e_hide()
            # sGR.e_hide()
            # sKP.e_hide()
            # sMQ.e_normal()
            # sGR.e_normal()
            # sBN.e_normal()
            # sKP.e_normal()
            # sQL.e_normal()
            # sRF.e_normal()
        t2.e_fade(-2)
        t2.math(r"\square STU + \square OH = AD^2 = 4\cdot AB \cdot BD + AC^2", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "And finally, since BD is equal to CB, and AD is equal to AB with BC added in a straight line, "
            "the square of AC added with quadruple the  rectangle of AB and AC, is equal to the square of AB added to BC")
        t2.e_fade(-2)
        t2.math(r"(AB+CB)^2 = 4\cdot AB\cdot BC + AC^2", transform_from=-1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t2.e_fade()
            t2.e_normal(0, -1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        buff = 0.5
        with self.simultaneous():
            sSTU.e_hide()
            pM.e_remove()
            pO.e_remove()
            pE.e_remove()
            pG.e_remove()
            pK.e_remove()
            pN.e_remove()
            pP.e_remove()
            pQ.e_remove()
            pR.e_remove()
            pL.e_remove()
            pF.e_remove()
            lDE.e_remove()
            aSTU.e_remove()
            t5.delete_until_last_marker()
            lGNt = lCH.perpendicular(pG,length=4*lKN.length + buff, side=LineLabelSide.INSIDE).dash()
            lPQt = lCH.perpendicular(pQ, length = 4*lKN.length + buff, side=LineLabelSide.INSIDE).dash()
            lEFt = lCH.perpendicular(pH, length = 4*lKN.length + buff, side=LineLabelSide.INSIDE).dash()
            lADt = lCH.perpendicular(pC, length = 4*lKN.length + buff, side=LineLabelSide.INSIDE).dash()
            # with self.simultaneous():
            lKN.e_remove()
            lKM.e_remove()
            lOQ.e_remove()
            lPQ.e_remove()
            lCH.dash()
            sAG.e_remove()
            sCK.e_remove()
            lBL.e_remove()
            sAK = EPolygon(pA, pM, pK, pB, skip_anim=True).e_fill(AG_colour)
            sAK.l[0].add_label("y")
            sMQ.e_remove()
            sGR.e_remove()
            sMR = EPolygon(pM, pO, pR, pK, skip_anim=True).e_fill(MQ_colour)
            sMR.l[0].add_label("y")
            sQL.e_remove()
            sGL = EPolygon(pG, pH, pL, pK, skip_anim=True).e_fill(QL_colour)
            sGL.l[3].add_label("y")
            sRF.e_remove()
            sKP.e_remove()
            sKF = EPolygon(pK, pL, pF, pN, skip_anim=True).e_fill(RF_colour)
            sKF.l[3].add_label("y")
            lOE = ELine(pO, pE, skip_anim=True).add_label("x")
            sBN.e_remove()
            sGL.add_label("y(x+y)")
            sKF.add_label("y(x+y)")
            sAK.add_label("y(x+y)")
            sMR.add_label("y(x+y)")
            sOH.add_label("x^2")
            sAF.e_fill(YELLOW, opacity=0.25)

        with self.simultaneous():
            sKF.e_move([2 * lKN.length + 0.5 * buff, 0,0])(run_time=2)
            sGL.e_move([2 * lKN.length + 0.5 * buff, 0, 0])(run_time=2)

        t2.math("(x+2y)^2 = 4y(x+y) + x^2")
        self.next_page()

