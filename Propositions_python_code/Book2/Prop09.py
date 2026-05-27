import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *


class Prop9(Book2Scene):
    title = "If a straight line be cut into equal and unequal segments, the " \
            "squares on the unequal segments of the whole are double of the square on " \
            "the half and of the square on the straight line between the points of section."

    def go(self):
        # -------------------------------------------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500), name="explanation")
        t4 = TextBox(mn_coord(100, 450), name="squares")
        t5 = TextBox(mn_coord(460, 200), name="math_intro")
        t6 = TextBox(mn_coord(600, 400), name="equalities")
        t2 = TextBox(mn_coord(100, 450), name="math")
        t3 = TextBox(mn_coord(500, 450), name="aside")

        A = mn_coord(50, 400)
        B = mn_coord(450, 400)
        D = mn_coord(330, 400)

        # -------------------------------------------------------------------------------------------------------------
        # In other words
        # -------------------------------------------------------------------------------------------------------------
        t1.title("In other words")
        t1.explain("Let AB be a straight line, bisected at point C, and cut at an arbitrary point D")
        with self.simultaneous():
            pA = EPoint(A).add_label('A', mn.LEFT)
            pB = EPoint(B).add_label('B', mn.RIGHT)
            pD = EPoint(D).add_label("D", mn.DOWN)
            lAB = ELine(pA, pB,skip_anim=True).e_hide()
            pC = lAB.bisect().add_label('C', mn.DOWN)
            lAB.e_delete()
            lAC = ELine(pC, A).add_label("x", side=LineLabelSide.INSIDE)
            lCD = ELine(D, pC).add_label("y", side=LineLabelSide.INSIDE)
            lDB = ELine(B, D).add_label("x-y", side=LineLabelSide.INSIDE)

        t2.math(r"AC = BC,\quad AB = AC+CD+DB", is_axiom=True)
        t3.math('2x = x+y+(x-y)')
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The sum of the squares of AD and DB is equal to twice the sum of the squares of AC and DC" )
        t2.math("AD^2 + DB^2 = 2(AC^2 + CD^2)")
        t3.math("(x+y)^2 + (x-y)^2 = 2(x^2 + y^2)")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        t3.delete_until_last_marker()
        t5.math(r"AC = BC,\quad AB = AC+CD+DB", is_axiom=True, transform_from=t2[0])
        t2.delete_until_last_marker()
        t1.delete_until_last_marker()
        t1.title("Construction:")
        t1.explain( "Draw a line perpendicular to AB through {nb:point C (I.11)}, and make its "
                      "length equal to AC {nb:or CB  (I.3)" )
        cC = ECircle(pC, pA).e_fade()
        lCE = lAB.perpendicular(pC, length = lAC.length, side=LineLabelSide.INSIDE)
        pE = EPoint(lCE.end).add_label("E",mn.UP)
        aACE = EAngle(lCE, lAC )
        t6.math("AC = CE")
        t6.math("CB = CE")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        cC.e_remove()
        t1.explain("Connect AE and EB")
        lAE = ELine( pA, pE )
        lBE = ELine( pE, pB )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Draw a line parallel to EC through point D")
        lDFt = lCE.parallel( pD ).e_fade()
        pF = EPoint(lBE.intersect(lDFt)[0]).add_label("F",mn.RIGHT)
        lDF = ELine(pD, pF)
        lDFt.e_remove()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Draw a line parallel to AB through point F")
        lFGt = lCD.parallel( pF ).e_fade()
        pG = EPoint(lCE.intersect( lFGt )[0] ).add_label('G', mn.LEFT)
        lFG = ELine( pG, pF )
        lFGt.e_remove()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Join AF")
        lAF = ELine(A, pF)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof (Angles)
        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.add_marker()
        t1.title("Proof (sides and angles)")
        t1.explain( "Triangle AEC is a right angle triangle, "
               "and AC and CE are equal, therefore it is an isosceles triangle"
        )
        with self.simultaneous():
            lAE.e_fade()
            lAC.e_fade()
            lCD.e_fade()
            lDB.e_fade()
            lCE.e_fade()
            lFG.e_fade()
            lAF.e_fade()
            lDF.e_fade()
            lBE.e_fade()
            pG.remove_label()
        sACE = ETriangle(pA, pC, pE, fill=BLUE, angles=(r"\alpha", "", r"\alpha"))
        t6.e_fade(-1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Since the sum of the angles in a triangle equals two right {nb:angles (I.32)}, "
        "and ACE is a right angle, then the two base angles (being equal (I.5)) each equal one half a right angle (45 degrees)")
        aCAE, _, aCEA = sACE.a
        with self.simultaneous():
            aCAE.add_label(r"45")
            aCEA.add_label(r"45")
        t5.e_fade(0)
        t5.math(r"\measuredangle EAC = \measuredangle CEA = 45^\circ")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 66
        t1.explain("By the same reason, angles CEB and CBE are each half a right angle, which makes AEB a right angle" )
        sCBE = ETriangle( pC, pB, pE, fill = PURPLE, angles=("", ("45", ANGLE_SIZE*0.5),("45",ANGLE_SIZE*1.2)))
        aAEB = EAngle(lAE, lBE, size=ANGLE_SIZE*0.8)
        t5.math(r"\measuredangle CEB = \measuredangle CBE = 45^\circ, \quad \measuredangle AEB = \rightangle")

        with self.simultaneous():
            t6.e_fade(-2)
            t6.e_normal(-1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 73
        t1.explain("Since AB and GF are parallel, and CE intersects them, "
                   "the opposite and interior angles are equal (I.29), so EGF is a right angle" )
        with self.simultaneous():
            sCBE.e_hide()
            sACE.e_hide()
            aAEB.e_hide()
        pG.add_label("G", mn.LEFT)
        lCE.e_normal()
        lFG.e_normal()
        z=VirtualLine(pE,pG)
        aEGF = EAngle(lFG, z)
        z.e_delete()

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 80
        t1.explain("The angle EFG is one half a right angle (I.32), and since two angles are equal, "
                       "EGF is isosceles (I.6), so EG equals GF" )
        with self.simultaneous():
            aACE.e_hide()
            lCE.e_fade()
        sEGF = ETriangle(pE, pG, pF, angles = (("45",.35*ANGLE_SIZE), "", ("45",.35*ANGLE_SIZE)), fill=PALE_YELLOW)
        t5.e_fade(-2)
        t5.math(r"\measuredangle GEF = \measuredangle EFG = 45^\circ")
        t6.e_fade(-1)
        t6.math("EG = GF")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 87
        t1.down()
        t1.explain("Using the same logic, FDB is also an isosceles triangle, and DB equals FD" )
        with self.simultaneous():
            sEGF.e_hide()
            aEGF.e_hide()
            lFG.e_fade()
        sFDB = ETriangle(pF, pD, pB, angles = (("45",.5*ANGLE_SIZE), "", ("45",.5*ANGLE_SIZE)), fill=PALE_YELLOW)

        t5.e_fade(-1,-2)
        t5.math(r"\measuredangle DFB = \measuredangle FBD = 45^\circ")
        t6.e_fade(-1)
        t6.math("DB=FD")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof (Squares)
        # -------------------------------------------------------------------------------------------------------------
        # 96
        t1.delete_until_last_marker()
        t1.title("Proof (squares)")
        t1.explain("The triangle AEC is a right angle triangle, thus the square on AE equals the "
                   "sum of the squares of AC and AE")
        with self.simultaneous():
            aEGF.e_hide()
            pG.e_fade()
            lFG.e_fade()
            sFDB.e_hide()
            sACE.e_normal()
            lAF.e_hide()

        with self.simultaneous():
            sACE.add_line_labels("","",(r"\sqrt{AC^2+AE^2}",dict(buff=2.3*LABEL_BUFF)))
        t6.e_fade()
        t5.e_fade()
        t4.math(r"AE^2 = AC^2 + EC^2")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 105
        t1.explain("Since AC equals CE, the sum of the squares of AC and CE equals twice the square of AC")
        t6.e_normal(0)
        sACE.add_line_labels("","",(r"\sqrt{2(AC)^2}",dict(buff=1.8*LABEL_BUFF)))
        t4.math(r"=2\cdot AC^2", same_line=True)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 117
        t1.explain("Since EG equals GF, the sum of the squares of EG and GF equals twice the square of GF " )
        t1.explain("The triangle EGF is a right angle, thus the square on EF equals the sum of the squares of EG and GF" )
        with self.simultaneous():
            sACE.e_hide()
            sEGF.e_normal()
            pG.e_normal()
        with self.simultaneous():
            sEGF.add_line_labels("","", (r"\sqrt{2(GF)^2}", dict(buff=1.8*LABEL_BUFF)))
        t6.e_fade()
        t6.e_normal(2)
        t4.math(r'EF^2 = EG^2 + GF^2')
        t4.math(r'=2\cdot GF^2', same_line=True)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 129
        t1.explain("GF equals CD (I.34), thus the square on EF equals twice the sum of CD" )
        t6.e_fade()
        with self.simultaneous():
            sEGF.add_line_labels("","", (r"\sqrt{2(CD)^2}", dict(buff=1.7*LABEL_BUFF)))
        t4.math(r"EF^2 = 2\cdot CD^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 136
        t1.explain("The triangle EAF is a right angle, thus the square on AF equals the sum of the squares of AE and EF" )
        with self.simultaneous():
            sEGF.e_hide()
            pG.e_hide()
        sEAF = ETriangle(pE, pA, pF, skip_anim=True).set_angles(" ")
        sEAF.e_fill(LIME_GREEN)
        with self.simultaneous():
            sEAF.add_line_labels(
                (r"", dict(buff=1.7*LABEL_BUFF)),
                (r"\sqrt{(AE)^2 + (EF)^2}", dict(buff=1.7 * LABEL_BUFF)),
                (r"", dict(buff=1.7*LABEL_BUFF)),
            )
        t4.e_fade()
        t4.math("AF^2 = AE^2 + EF^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 147
        t4.e_normal(0,1,4)
        with self.simultaneous():
            sEAF.add_line_labels(
                (r"\sqrt{2(AC)^2}", dict(buff=1.7*LABEL_BUFF)),
                (r"\sqrt{2(AC^2 + CD^2\,)}", dict(buff=1.7 * LABEL_BUFF)),
                (r"\sqrt{2(CD)^2}", dict(buff=1.7*LABEL_BUFF)),
            )
        t4.math(r"AF^2 = 2\cdot AC^2 + 2\cdot CD^2 = 2(AC^2 + CD^2)")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 153
        t1.explain("The triangle FAD is a right angle triangle, thus the square on AF equals the sum of the squares of AD and DF")
        sEAF.e_fade()
        with self.simultaneous():
            sEAF.e_hide()
            pC.e_hide()
        sADF = ETriangle(pA, pD, pF, skip_anim=True).set_angles(""," ","")
        sADF.e_fill(PALE_PINK)
        with self.simultaneous():
            sADF.add_line_labels(
                (r"", dict(buff=1*LABEL_BUFF)),
                "",
                (r"\sqrt{(AD)^2 + (FD)^2}", dict(buff=1.7*LABEL_BUFF)),
            )
        t4.e_fade()
        t4.math("AF^2 = AD^2 + FD^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 167
        t1.explain("But DF equals DB, so the square of AF is the sum of the squares of AD and BD")
        with self.simultaneous():
            sADF.add_line_labels(
                (r"", dict(buff=1*LABEL_BUFF)),
                ("", dict(buff=1.5 * LABEL_BUFF)),
                (r"\sqrt{(AD)^2 + (DB)^2}", dict(buff=1.7*LABEL_BUFF)),
            )
        t6.e_normal(-1)
        t4.math("AF^2 = AD^2 + DB^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 173
        t1.explain("Rearranging the equalities gives the original proposition")
        t6.e_fade()
        with self.simultaneous():
            lAF.e_normal()
            lAC.e_normal()
            lCD.e_normal()
            lDB.e_normal()
        with self.simultaneous():
            lFA = ELine(pF, pA, skip_anim=True).add_label(r"\sqrt{(AD)^2 + (DB)^2}",
                                                      dict(buff=1.8 * LABEL_BUFF))
            lAF.add_label(r"\sqrt{2(AC^2 + CD^2\,)}", dict(buff=1.8 * LABEL_BUFF, alpha=0.65))
            sADF.e_hide()
            pC.e_normal()
        with self.simultaneous():
            t4.e_fade()
            t4.e_normal(6,8)

        t4.math("AD^2 + DB^2 = 2(AC^2 + CD^2)")
        t4.math(r"\rightarrow (x+y)^2 + (x-y)^2 = 2(x^2 + y^2)", same_line=True, transform_from= -1,
                transform_args=dict(key_map={
                    "AD^2 +":r"(x+y)^2 +", "DB^2 =":"(x-y)^2 =", "2(AC^2 +": "2(x^2 +", "CD^2)":"y^2)"
                }))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # 183
        with self.simultaneous():
            t4.e_fade()
            t4.e_normal(-1,-2)
            t5.e_normal(0)
        self.next_page()
