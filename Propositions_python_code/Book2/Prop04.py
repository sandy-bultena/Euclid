import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *

PPURPLE       = Colour.add( PURPLE,    PURPLE )
REALLY_PURPLE = Colour.add( PPURPLE, PURPLE )

class Prop4(Book2Scene):
    title =     "If a straight line be cut at random, the square on the whole is equal to " \
                "the squares on the segments and twice the rectangle contained by the segments."

    def go(self):
        # -------------------------------------------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500))
        t5 = TextBox(mn_coord(100, 480), name="math")
        t3 = TextBox(mn_coord(500, 480), name="aside")
        t2 = TextBox(mn_coord(500, 200))

        A = mn_coord(200,200)
        B = mn_coord(450,200)
        C = mn_coord(300,200)

        CK_colour= BLUE
        HF_colour = PINK
        AG_colour = GREEN
        GE_colour = GREEN

        box_colours = {
            'CK':CK_colour,
            'HF':HF_colour,
            'AG':AG_colour,
            'GE':GE_colour,
        }

        # -------------------------------------------------------------------------------------------------------------
        # In other words
        # -------------------------------------------------------------------------------------------------------------
        t1.title("In other words")
        t1.explain("Let AB be a straight line, arbitrarily cut at point C")
        with self.simultaneous():
            pA = EPoint( A, label=('A', mn.LEFT))
            pB = EPoint( B, label=('B', mn.RIGHT))
            lA = ELine( A, B )
            pC = EPoint( C, label=('C', mn.UP))
            lAC = ELine(A, C, label=('x', dict(side=LineLabelSide.INSIDE)))
            lBC = ELine(C, B, label=('y', dict(side=LineLabelSide.INSIDE)))
        with self.simultaneous():
            t5.math("AB = AC + CB", is_axiom=True)
            t3.math("a = x + y")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Then the square formed by line AB is equal in area to the sum of the squares "
                      "formed by line CB and AC, plus twice the area of the rectangles formed by lines AC and CB" )
        with self.simultaneous():
            t5.math(r"AB^2 = AC^2 + CB^2 + 2\cdot AC\cdot CB")
            t3.math("(x+y)^2 =  x^2 + y^2 + 2xy")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        t1.e_remove()
        t1.title("Construction:")
        with self.simultaneous():
            t5.delete_last()
            t3.e_remove()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Draw a square ADEB on the line AB (I.46), and draw the diagonal  BD" )
        with self.simultaneous():
            lA.e_remove()
            sAB = ESquare( pA, pB )
        with self.simultaneous():
            pD, pA, pB, pE = sAB.p
            lAD, lAB, lBE, lDE = sAB.l
            pE.add_label('E', mn.RIGHT)
            pD.add_label('D', mn.LEFT)
            aABE = EAngle(lAB, lBE)
        lBD = ELine( pB, pD )
        t2.math(r"AB = AD,\quad \measuredangle ABE = \rightangle", is_axiom=True)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Draw a line CF parallel to either AD or BE (I.31), labelling the intersection "
                      "with the diagonal as G." )

        with self.simultaneous():
            lCF = lAC.perpendicular( pC, length= lA.length )
            pF = EPoint( lCF.intersect( lDE )[0],label=('F', mn.DOWN))
            pG = EPoint( lCF.intersect( lBD )[0], label=('G', mn.UL))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "Draw a line parallel to AB through the point G (I.31).")

        with self.simultaneous():
            lGH = lCF.perpendicular(pG, length=lAC.length)
            lGK = lCF.perpendicular(pG, length= lBC.length, side=LineLabelSide.INSIDE)
            pH = EPoint( lGH.intersect( lAD)[0],label =('H', mn.LEFT))
            pK = EPoint( lGK.intersect( lBE)[0], label=('K', mn.RIGHT))
        lHK = ELine( pH, pK, skip_anim=True)
        lGH.e_delete()
        lGK.e_delete()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t1.e_remove()
        t1.title("Proof:")
        t1.add_marker()
        t1.explain( "Since BD crosses two parallel lines, (AD and CF), "
            "then the exterior angle is equal to the interior and opposite {nb:angle (I.29)}"
        )
        lvCG = VirtualLine( pG, pC )
        lvGB = VirtualLine( pG, pB )
        lvDB = VirtualLine( pD, pB )
        lvAD = VirtualLine( pA, pD )
        with self.simultaneous():
            lAB.e_fade()
            lAC.e_fade()
            lBC.e_fade()
            lBE.e_fade()
            lDE.e_fade()
            lHK.e_fade()
            aABE.e_fade()
            aCGB = EAngle( lvGB, lvCG, label= r'\alpha')
            aADB = EAngle( lvDB, lvAD, label=r'\alpha')

        with self.simultaneous():
            t5.e_fade()
            t2.e_fade()
            t2.math(r"\measuredangle CGB = \measuredangle ADB")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Since triangle ABD is an isosceles triangle, "
                      "then the angles at the base are also equal (I.5)")

        with self.simultaneous():
            lCF.e_fade()
            aCGB.e_fade()
            sABD = EPolygon( pB, pA, pD, skip_anim=True).e_fill(SKY_BLUE)
            aABD = EAngle( lBC, lBD, label=r'\alpha')

        with self.simultaneous():
            t2.e_normal(0)
            t2.e_fade(1)
            t2.math(r"\measuredangle ADB =\measuredangle ABD")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Since triangle BCG has two equal angles, it is an "
                       "isosceles triangle (I.6), therefore the sides "
                      "of the triangle are equal" )
        with self.simultaneous():
            sABD.e_remove()
            sCBG = EPolygon( pB, pC, pG, labels=('y','','',''),skip_anim=True).e_fill(BLUE)
            aCGB.e_normal()
            aADB.e_fade()
        with self.simultaneous():
            t2.e_fade(0)
            t2.e_normal(1)
            cg_cb = t2.math("CG=CB")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "CB and GK are parallel, CG and BK are parallel, "
                       "so the opposite sides equal on another (I.34), "
                       "and since CB equals CG, all sides are equal, "
                       "therefore CK is equilateral",t2c={"CK is equilateral": E_BLUE} )
        with self.simultaneous():
            aCGB.e_remove()
            aADB.e_remove()
            aABD.e_remove()
            sCBG.e_remove()
            lBD.e_fade()
            lAD.e_fade()
            sCGKB = EPolygon(pC, pG, pK, pB, labels=('','','','y'), skip_anim=True).e_fill(CK_colour)
            lCG, lGK, lBK, lBC = sCGKB.l
        with self.simultaneous():
            t2.e_fade()
            t2.math(r"CB \parallel GK, \quad CG \parallel BK")
            t2.math(r"\therefore  CB=GK, \quad CG=BK")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Since CG is parallel to BK, then the sum of the interior "
                       "angles is two right angles (I.29)" )
        t1.explain(   "We know that angle CBK is right, so then angle BCG is also right." )

        with self.simultaneous():
            aABE.e_normal()
            aABE.add_label(r'\theta')
            aFCB = EAngle(lCF, lBC, label=r'\theta')

        with self.simultaneous():
            t2.e_normal(0)
            t2.e_fade(1,2,3,4,5)
            t2.math(r"\measuredangle GCB + \measuredangle ABE = \rightangle +\rightangle  ")
            t2.math(r"\measuredangle GCB  = \rightangle")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The angles opposite one another are equal in a parallelogram, so the other two angles are right "
                  "angles as well (I.34)." )
        with self.simultaneous():
            aBCF = EAngle(lCG, lGK)
            aBKG = EAngle(lBK, lGK)

        with self.simultaneous():
            t2.e_normal(3)
            t2.e_fade(-2)
            t2.math(r'\measuredangle CGK = \rightangle')
            t2.math(r'\measuredangle BKG = \rightangle')
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t1.explain("So CK is a square, equal to the square of CB")
            t1.blue(-1)
            t2.down()
            sq_ck = t2.math(r"\square CK = CB^2", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            lBC.e_normal()
            t1.delete_until_last_marker()
            aBCF.e_remove()
            aBKG.e_remove()
            aFCB.e_remove()
            aABE.e_remove()
        t1.explain("CK is a square, equal to the square of CB")
        sCGKB.add_label(r'~\quad  y^2')

        t5.math('CG=CB', transform_from=cg_cb)
        t5.math(r"\square CK = CB^2", transform_from=sq_ck, colours=box_colours)
        t2.e_remove()

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Similarly, HDFG is a square, equal to the square of AC")
        with self.simultaneous():
            sCGKB.e_fade()
            sHDFG = EPolygon(pH, pD, pF, pG, skip_anim=True,).e_fill(HF_colour).add_label('x^2').add_line_labels(['x'])
            sHDFG.add_label('x^2')
        t5.e_fade()
        t5.math(r"\square HF = AC^2", colours=box_colours)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "Rectangles AG and GE are equal (complements of a parallelogram) (I.43), "
               "and are equal to the rectangle formed from lines AC and CB" )

        with self.simultaneous():
            sHDFG.e_fade()
            lBD.e_normal()
            t5.e_fade(-1)
            sAHGC = EPolygon( pA, pH, pG, pC, skip_anim=True).e_fill(AG_colour).add_label('xy').add_line_labels('y','','','x')
            sGFEK = EPolygon( pG, pF, pE,pK , skip_anim=True).e_fill(GE_colour).add_label('xy').add_line_labels=('x','','','y')

        t5.math(r"\square AG = \square GE", colours=box_colours)
        t5.math(r"\square AG = AC\cdot CG = AC\cdot CB", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The sum of all the rectangles equals the square on AB")
        with self.simultaneous():
            sHDFG.e_normal()
            sCGKB.e_normal()
            lBD.e_remove()

        with self.simultaneous():
            t5.e_normal()
            t5.math(   r"\square AE = \square CK + \square HF + \square AG + \square GE",
                       colours=box_colours)
            t5.math(r"AB^2 = CB^2 + AC^2 + 2(AC\cdot CB)")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t5.e_fade()
            t5.e_normal(0)
            t5.e_normal(-1)
        t5.math(r',\quad\quad (x+y)^2 = x^2 + y^2 + 2xy',same_line=True)
        self.next_page()


