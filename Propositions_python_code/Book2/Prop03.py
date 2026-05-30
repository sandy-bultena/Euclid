import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *

PPURPLE       = Colour.add( PURPLE,    PURPLE )
REALLY_PURPLE = Colour.add( PPURPLE, PURPLE )

class Prop3(Book2Scene):
    title =     "If a straight line be cut at random, the rectangle " \
                "contained by the whole and one of the segments " \
                "is equal to the rectangle contained by the segments and the " \
                "square on the aforesaid segment."



    def go(self):
        # -------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500))
        t5 = TextBox(mn_coord(100, 480), name="math")
        t3 = TextBox(mn_coord(500, 480), name="aside")

        A = mn_coord(200,200)
        B = mn_coord(450,200)
        C = mn_coord(300,200)

        CB_colour = SKY_BLUE
        AC_colour = PALE_PINK
        AB_colour = Colour.add(CB_colour, AC_colour)

        box_colours = {
            'AD':AC_colour,
            'CE':CB_colour,
            'AE':AB_colour,
        }

        # -------------------------------------------------------------------------------------------------------------
        # Construction
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
        t1.add_marker()
        t1.explain( "Then the area of the rectangle formed by "
                "line AB and CB is equal in area to the sum of the rectangles "
                "formed by line CB and AC, and line CB and CB" )
        t5.math(r"CB\cdot AB = CB\cdot AC + CB^2")
        t3.math("y\,(x+y) = yx + y^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.math(r"CB\cdot AB = CB\cdot AC + CB^2", transform_from=t5[-1])
        t1.down()
        with self.simultaneous():
            t5.delete_last()
            t3.e_remove()
        t1.title("Proof:")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Draw a square CDEB on the line CB (I.46) and draw a line AF parallel to either "
                       "CD or BE (I.31).  Extend DE to the point F" )

        with self.simultaneous():
            sCB = ESquare( pC, pB, label=r'y^2' )
            pD, pC, pB, pE = sCB.p
            lCD, lBC, lBE, lDE = sCB.l
            pD.add_label('D', mn.DOWN)
            pE.add_label('E', mn.RIGHT)
        with self.simultaneous():
            lAF = lA.perpendicular(pA, length=lBC.length)
            lDF = lCD.perpendicular(pD, length = lAC.length, side=LineLabelSide.INSIDE)
            lAF.add_label('y')
            pF = EPoint(lAF.intersect(lDF)[0]).add_label("F", mn.DL)

        t5.math("CB = BE = CD = AF")
        t5.down()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The rectangle AE is the sum of the rectangles AF and CE")
        sAE = EPolygon(pA, pF, pE, pB, skip_anim=True)
        sAD = EPolygon(pA, pF, pD, pC, skip_anim=True)
        with self.simultaneous():
            sCB.e_fill(CB_colour)
            sAD.add_line_labels(('y',))
            sAD.e_fill(AC_colour)
            sCE = sCB
            lAF.e_remove()
            lDF.e_remove()
            sAD.add_label('yx')

        t5.e_fade(-1)
        t5.math(r"\square AE = \square AD + \square CE", colours = box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "Since AF is equal in length to CB (I.34), "
                     "the rectangle AE is equal to the rectangle contained by "
                    "lines AB and CB" )
        with self.simultaneous():
            sAE.e_fill(AB_colour)
            sAD.e_fade()
            sCE.e_fade()
            sAE.add_label("y(x+y)")
            sAE.add_line_labels('y')
            pE.e_normal()
        with self.simultaneous():
            t5.e_normal(-2)
            t5.e_fade(-1)
            t5.math(   r"\square AE = AF\cdot AB,\quad\quad\therefore\quad  \square AE = CB\cdot AB",
                       colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Similarly, the rectangle AD is equal to the rectangle contained by lines CB and AC" )
        with self.simultaneous():
            sAE.e_fade()
            sAD.e_normal()
            t5.e_fade(-1)
            pD.e_normal()
        t5.math(   r"\square AD = AF\cdot AC,\quad\quad\therefore\quad  \square AD = CB\cdot AC" ,
                   colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Since CD equals AF (I.34), CE is equal to the rectangle contained by lines CB and CB" )
        with self.simultaneous():
            sCE.e_normal()
            sAD.e_fade()
            t5.e_fade(-1)
        t5.math(   r"\square CE = CD\cdot CB,\quad\quad\therefore\quad  \square CE = CB^2",
                   colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "Thus, the rectangle formed by CB,AB is equal to the sum "
                      "of the rectangles formed by CB,AC and CB,CB" )
        with self.simultaneous():
            sAD.e_normal()
        with self.simultaneous():
            t5.e_fade(1)
            t5.e_normal(slice(2,5))
            t3.black( slice(2,5) )

            t5.down()
            t5.math(r"CB\cdot AB = CB\cdot AC + CB^2", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t5.e_fade(slice(2,6))
        t5.math(",\quad\quad y\,(x+y) = yx + y^2", same_line=True)
        self.next_page()

