import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *


class Prop10(Book2Scene):
    title = "If a straight line be bisected, and a straight line be added to it in a straight line, " \
    "the square on the whole with the added straight line and the square on the added straight line both " \
    "together are double of the square on the half and of the square described on the "\
    "straight line made up of the half and the added straight line as on one straight line."

    def go(self):
        # -------------------------------------------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500), name="explanation")
        t4 = TextBox(mn_coord(100, 510), name="squares")
        t5 = TextBox(mn_coord(460, 200), name="math_intro")
        t6 = TextBox(mn_coord(600, 440), name="equalities")
        t2 = TextBox(mn_coord(100, 500), name="math")
        t3 = TextBox(mn_coord(500, 500), name="aside")

        A = mn_coord(80, 380)
        B = mn_coord(360, 380)
        d=mn_scale(100)

        # -------------------------------------------------------------------------------------------------------------
        # In other words
        # -------------------------------------------------------------------------------------------------------------
        t1.down()
        t1.title("In other words")
        t1.explain("Let AB be a straight line, bisected at point C, and extended to an arbitrary point D")
        pA = EPoint( A ).add_label('A', mn.LEFT)
        pB = EPoint( B ).add_label('B', mn.DOWN)
        lAB = ELine( A, B )
        pC = lAB.bisect().add_label('C', mn.DOWN)
        lAB.extend(d)
        pD = EPoint( lAB.e_end ).add_label('D', mn.RIGHT)
        with self.simultaneous():
            lAC = ELine(A,pC, label="x")
            lCB = ELine(pC, pB, label="x")
            lBD = ELine(pB,pD, label="y")
        t2.math(r"AC = CB,\quad AD = AC + CB + BD", is_axiom=True)
        t2.add_marker()
        t3.math("AD = 2x + y")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.add_marker()
        t1.explain( "The sum of the squares of AD and DB is equal to twice the sum of the squares of AC and DC" )

        t2.math(r"AD^2 + DB^2  = 2\cdot (AC^2 + CD^2)")
        t3.math(r"(2x+y)^2 + y^2 = 2(x^2 + (x+y)^2)")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.math(r"AD^2 + DB^2  = 2\cdot (AC^2 + CD^2)", transform_from=t2[-1])
        t1.add_marker()
        t1.down()
        t1.title("Construction:")
        with self.simultaneous():
            t3.delete_until_last_marker()
            t2.delete_until_last_marker()
        t5.math(r"AC = CB,\quad AD = AC + CB + BD", is_axiom=True, transform_from=t2[-1])
        t2.delete_until_last_marker()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Draw a line perpendicular to AB through {nb:point C (I.11)}, and make its "
                       "length equal to AC {nb:or CB (I.3)}" )
        cC   = ECircle( pC, A ).e_fade()
        lCE = lAB.perpendicular( pC , length = lAC.length, side=LineLabelSide.INSIDE)
        pE   = EPoint( lCE.e_end).add_label('E', mn.UP)
        lCE.reverse_points()
        aACE = EAngle( lCE, lAC )
        t6.math("AC = CE")
        t6.math("CB = CE")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        cC.e_remove()
        t1.explain("Connect AE and EB")
        lAE = ELine( A, pE )
        lEB = ELine( pE, B )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Draw a line parallel to AD through point E (I.31)")
        lEF = lCE.perpendicular( pE, length = lCB.length + lBD.length, side=LineLabelSide.INSIDE )
        t1.explain("Draw a line parallel to EC through point D (I.31)")
        with self.simultaneous():
            lDF = lBD.perpendicular(pD, length = lCB.length, side=LineLabelSide.INSIDE)
            lDG = lBD.perpendicular(pD, length = lCB.length, side=LineLabelSide.OUTSIDE)
        pF = EPoint(lDF.e_end).add_label("F", mn.RIGHT)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Since EF crosses two parallel lines (EC and FD), "
                    "then the sum of the interior angles is two right angles (FEC and EFD)" )
        with self.simultaneous():
            lAE.e_fade()
            lAC.e_fade()
            lCB.e_fade()
            lBD.e_fade()
            lAB.e_hide()
            lEB.e_hide()
        aFEC = EAngle( lCE, lEF, label=r"\epsilon", no_right=True, size=0.5*ANGLE_SIZE)
        aEFD = EAngle( lEF, lDF, label=r"\gamma", no_right=True, size=0.5*ANGLE_SIZE)
        t4.math(r"\epsilon + \gamma = 2\rightangle")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.down()
        t1.explain("Thus the angles BEF and EFD sum to less than two right angles, "
                 "and from proposition 5, EB and FD will intersect. Label this intersection G" )
        lEB.e_normal()
        aFEC.add_label(r"\epsilon", alpha=0.2)
        aFEB = EAngle(lEF, lEB, label=r"\theta")
        p = lEB.intersect_line(lDG)[0]
        lBG = ELine(pB, p)
        pG = EPoint(p).add_label("G",mn.DR)
        t4.math(r"\theta + \gamma < 2\rightangle")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Draw line from A to G")

        with self.simultaneous():
            lDG.e_remove()
            lDG = ELine(pD, pG, skip_anim=True)
            lAE.e_normal()
            lAC.e_normal()
            lCB.e_normal()
            lBD.e_normal()
            aFEC.e_hide()
            aEFD.e_hide()
            aFEB.e_hide()
            lAC.remove_label()
            lCB.remove_label()
            lBD.remove_label()

        lAG = ELine(pA, pG)
        t4.delete_until_last_marker()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof (Angles)
        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t1.delete_until_last_marker()
        t1.add_marker()
        t1.title("Proof (sides and angles)")
        t1.explain("Triangle AEC is a right angle triangle, and AC and CE are equal, therefore it is an isosceles triangle")
        with self.simultaneous():
            lEB.e_fade()
            lBG.e_fade()
            lAG.e_fade()
            lCB.e_fade()
            lBD.e_fade()
            lEF.e_fade()
            lDF.e_fade()
            lDG.e_fade()
        sAEC = ETriangle(pA, pC, pE, skip_anim=True, fill=SKY_BLUE)
        t6.e_fade(-1)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Since the sum of the angles in a triangle equals two right angles (I.32) "
                   "and ACE is a right angle, then the two base angles (being equal (I.5)) "
                   "each angle equals one half a right angle (45 degrees)")
        sAEC.set_angles("45","","45")
        t5.indent(mn_scale(80))
        t5.down()
        t5.e_fade()
        t5.math(r"\measuredangle EAC = \measuredangle AEC = 45^\circ")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("By the same reason, angles CEB and CBE are each half a right angle, "
                   "which makes AEB a right angle")
        sCEB = ETriangle(pC, pE, pB, skip_anim=True, fill=PALE_PINK)
        sCEB.set_angles("", ("45", 1.2*ANGLE_SIZE), "45")
        aAEB = EAngle(lAE, lEB)
        t5.e_fade()
        t5.math(r"\measuredangle CEB = \measuredangle CBE = 45^\circ")
        with self.simultaneous():
            t6.e_fade(-2)
            t6.e_normal(-1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The angle CBE and GBD are equal (I.5)")
        aEBC = EAngle(lEB, lCB, skip_anim=True)
        aEBC.add_label("45")
        with self.simultaneous():
            lAE.e_fade()
            sAEC.e_hide()
            sCEB.e_hide()
            aAEB.e_hide()
            lEB.e_normal()
            lBG.e_normal()
            lAC.e_normal()
            lCB.e_normal()
            lBD.e_normal()
            lCE.e_fade()
            aACE.e_hide()
        aDBG = EAngle(lBD, lBG, label="45")
        t5.e_fade()
        t5.math(r"\measuredangle CBE = \measuredangle GBD = 45^\circ")
        t6.e_fade()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("EC and FG are parallel, thus opposite and interior angles are equal (I.29), therefore BDG is a right angle")
        with self.simultaneous():
            aEBC.e_hide()
            aDBG.e_hide()
            lEB.e_fade()
            lBG.e_fade()
            lCE.e_normal()
            lDF.e_normal()
            lDG.e_normal()
        with self.simultaneous():
            aECB = EAngle(lCE, lCB)
            aBDG = EAngle(lBD, lDG)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Then angle DBG is one half a right angle, therefore BGD is one half a "
                   "right angle (I.32), so BD equals DG (I.6)")
        with self.simultaneous():
            aECB.e_hide()
            aBDG.e_hide()
            lAC.e_fade()
            lCB.e_fade()
            lBD.e_fade()
            lCE.e_fade()
        sBGD = ETriangle(pB, pG, pD, skip_anim=True)
        sBGD.e_fill(PALE_YELLOW)
        sBGD.set_angles(("45", 0.5*ANGLE_SIZE), ("45", 0.5*ANGLE_SIZE))
        t5.math(r"\measuredangle BGD = \measuredangle GBD = 45^\circ")
        t6.math("BD = DG")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Using the same logic, FEG is also an isosceles triangle, and GF equals EF")
        sBGD.e_hide()
        sEGF = ETriangle(pE, pG, pF, skip_anim=True).e_fill(YELLOW)
        sEGF.set_angles("45", "45", " ")
        t5.e_fade()
        t5.math(r"\measuredangle FEG = \measuredangle EGF = 45^\circ")
        t6.e_fade()
        t6.math("GF = EF = CD")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof (squares)
        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.title("Proof (Squares)")
        t1.explain("The triangle AEC is a right angle, thus the square on AE equals the sum of the squares of AC and AE")
        with self.simultaneous():
            sEGF.e_hide()
            lDF.e_fade()
            lDG.e_fade()
            t6.e_fade()
            t5.e_fade()
        with self.simultaneous():
            sACE = ETriangle(pA, pC, pE, skip_anim=True).e_fill(SKY_BLUE)
            sACE.add_line_labels("", "", (r"\sqrt{(AC)^2 + (EC)^2}", dict(buff=2.5*LABEL_BUFF)))
        t4.math("AE^2 = AC^2 + EC^2")
        t6.e_normal(0)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Since AC equals CE, the sum of the squares of AC and CE equals twice the square of AC")
        with self.simultaneous():
            sACE.add_line_labels("", "", (r"\sqrt{2(AC)^2}",dict(buff=1.7*LABEL_BUFF)))
        t4.math(r"=2\cdot AC^2", same_line=True)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        sACE.e_hide()
        sEGF.e_normal()
        with self.simultaneous():
            pB.e_hide()
            sEGF.add_line_labels((r"\sqrt{2(CD)^2}",dict(buff=2*LABEL_BUFF,alpha=.35)),
                                 ("",dict(buff=1.2*LABEL_BUFF)),
                                 "")
        t6.e_fade()
        t6.e_normal(-1)
        t4.e_fade()
        t4.math(r"EG^2 = EF^2 + FG^2 = 2\cdot CD^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The triangle AGE is a right angle triangle, thus the square on AG equals "
                   "the sum of the squares of AE and EG")
        with self.simultaneous():
            sEGF.e_hide()
            pC.e_hide()
            sAGE = ETriangle(pA, pG, pE, skip_anim=True).e_fill(TEAL)
            sAGE.add_line_labels((r"\sqrt{(AE)^2+(EG)^2}", dict(buff=2 * LABEL_BUFF, alpha=.35)),"","")
        with self.simultaneous():
            t6.e_fade()
            t4.e_fade()
        t4.math("AG^2 = AE^2 + EG^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            pC.e_normal()
            pD.e_normal()
            sAGE.add_line_labels((r"\sqrt{2(\,(AC)^2+(CD)^2\,)}", dict(buff=2 * LABEL_BUFF, alpha=.35)),
                                 (r"\sqrt{2(CD)^2}", dict(buff=2 * LABEL_BUFF, alpha=.35)),
                                 (r"\sqrt{2(AC)^2}", dict(buff=1.7 * LABEL_BUFF)))
        t4.e_normal()
        t4.math(r"AG^2 = 2\cdot AC^2 + 2\cdot CD^2 = 2(AC^2 + CD^2)")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The triangle AGD is a right angle triangle, thus the square on AG equals the sum "
                   "of the squares of AD and DG")

        with self.simultaneous():
            sAGE.e_hide()
            sAGD=ETriangle(pA,pG, pD, skip_anim=True)
            sAGD.e_fill(PURPLE)
            sAGD.add_line_labels((r"\sqrt{(AD)^2 + (DG)^2}", dict(buff=2.5 * LABEL_BUFF, alpha=.35),))
            pC.e_hide()

        t4.e_fade()
        t4.math("AG^2 = AD^2 + DG^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("But DG equals DB, so the square of AG is the sum of the squares of AD and DB")
        with self.simultaneous():
            pB.e_normal()
            sAGD.add_line_labels((r"\sqrt{(AD)^2 + (DB)^2}", dict(buff=2.5 * LABEL_BUFF, alpha=.35)),
                                 "",
                                 r"")

        t6.e_normal(-2)
        t4.math("AG^2 = AD^2 + DB^2", transform_from=-1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Rearranging the equalities gives the original proposition")
        lGA = ELine(pG,pA, skip_anim=True)
        lAG.e_normal()
        lAG.add_label(r"\sqrt{(AD)^2 + (DB)^2}", buff=2.5 * LABEL_BUFF, alpha=.35)
        with self.simultaneous():
            pC.e_normal()
            sAGD.e_hide()
            lAE.e_normal()
            lCE.e_normal()
            lEF.e_normal()
            lDF.e_normal()
            lDG.e_normal()
            #lBG.e_normal()
            #lEB.e_normal()
            lAB.e_normal()
            lAC.e_normal()
            lBD.e_normal()

        with self.simultaneous():
            pC.add_label("C",mn.UR)
            pB.add_label("B",mn.UR)
            lAC.add_label("x",side=LineLabelSide.INSIDE)
            lCB.add_label("x",side=LineLabelSide.INSIDE)
            lBD.add_label("y",side=LineLabelSide.INSIDE)
        lGA.add_label(r"\sqrt{2(\,(AC)^2+(CD)^2\,)}", buff=1.7 * LABEL_BUFF, alpha=.25)
        with self.simultaneous():
            t4.e_fade(-2)
            t4.e_normal(-3)
            t6.e_fade()
        t4.math("AD^2 + DB^2 = 2(AC^2 + CD^2)")
        t4.math(r"\rightarrow (2x+y)^2 + y^2 = 2(\,x^2 + (x+y)^2\,)", same_line=True)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t5.e_normal(0)
        t4.e_fade(4,6)
        self.next_page()




