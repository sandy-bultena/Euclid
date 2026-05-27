
import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *

PPURPLE       = Colour.add( PURPLE,    PURPLE )
REALLY_PURPLE = Colour.add( PPURPLE, PURPLE )

class Prop5(Book2Scene):
    title = "If a straight line be cut at random, the rectangles contained by the whole and both of the segments " \
            "are equal to the square on the whole"


    def go(self):
        # -------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500))
        t5 = TextBox(mn_coord(100, 480))
        t3 = TextBox(mn_coord(500, 480))

        A = mn_coord(200,200)
        B = mn_coord(450,200)
        C = mn_coord(300,200)

        AF_colour = SKY_BLUE
        CE_colour = PALE_PINK
        AE_colour = Colour.add(AF_colour, CE_colour)

        box_colours = {
            'AF':AF_colour,
            'CE':CE_colour,
            'AE':AE_colour,
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
        t1.explain(   "Then the area of the square formed by line AB "
                       "is equal in area to the sum of the rectangles "
                       "formed by line AB and AC, and line AB and BC" )
        with self.simultaneous():
            t5.math(r"AB^2 = AB\cdot AC + AB\cdot BC")
            t3.math(r"(x + y)^2 = (x+y)\,x + (x+y)\,y")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t1.delete_until_last_marker()
            t1.math(r"AB^2 = AB\cdot AC + AB\cdot BC", transform_from=t5[-1])
        t1.down()
        t1.title("Proof:")
        with self.simultaneous():
            t5.delete_last()
            t3.e_remove()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Draw a square ABED on the line {nb:AB (I.46)} and "
                    "draw a line CF parallel to either AD or {nb:BE (I.31)}" )

        with self.simultaneous():
            sAB = ESquare(lA.start, lA.end)
            pD, pA, pB, pE = sAB.p
            lDB, lBA, lAE, lDE = sAB.l
            pE.add_label('E', mn.RIGHT)
            pD.add_label('D', mn.LEFT)

        # cheating here, supposed to be drawing parallel to BE, but drawing perpendiculars is easier
        with self.simultaneous():
            lC = lAC.perpendicular(pC, length = lA.length)
            pF =EPoint( lC.intersect( lDE )[0], label=('F', mn.DOWN))

        t5.math("AB = AD = CF")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The rectangle AE is the sum of the rectangles AF {nb:and CE}")
        with self.simultaneous():
            sAF = EPolygon( pA, pD, pF, pC, fill = AF_colour )
            sCE = EPolygon( pC, pF, pE, pB, fill = CE_colour)
            lC.e_remove()
        with self.simultaneous():
            sAF.add_label("(x+y)x")
            sCE.add_label("(x+y)y")

        t5.e_fade(-1)
        t5.math(r"\square AE = \square AF + \square CE", colours = box_colours)
        t5.down()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Since AD is equal in length to AB, the rectangle "
                       "AE is equal to the square contained by line AB" )

        with self.simultaneous():
            sAB.e_fill(AE_colour)
            sAB.add_label("(x+y)^2")
            sCE.e_fade()
            sAF.e_fade()
            lC.e_hide()

        t5.e_fade(-1)
        t5.e_normal(-2)
        t5.math(   r"\square AE = AB\cdot AD, \quad\quad  "
                    r"\therefore\quad  \square AE = AB^2", colours = box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Similarly, the rectangle AF is equal to "
                       "the rectangle contained by lines AB and AC" )
        with self.simultaneous():
            sAB.e_unfill()
            sAB.add_label(" ")
            sAF.e_normal()
        t5.e_fade(-1)

        t5.math(   r"\square AF = AD\cdot AC,  \quad\quad "
                    r"\therefore\quad  \square AF = AB\cdot AC", colours =box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Since AB equals CF (I.34), CE is equal to "
                       "the rectangle contained by lines AB and CB" )
        with self.simultaneous():
            sAF.e_fade()
            sCE.e_normal()
        t5.e_fade(-1)

        t5.math(   r"\square CE = CF\cdot CB,  \quad\quad "
                    r"\therefore\quad  \square CE = AB\cdot CB", colours = box_colours )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.down()
        t1.explain(
              "Thus the square of AB is equal to the rectangle formed by AB,AC "
                 "and the rectangle formed by AB,CB" )
        sAF.e_normal()
        t5.down()
        with self.simultaneous():
            t5.e_normal()
            t5.e_fade(1)
            t5.math(r"AB^2 = AB\cdot AC + AB\cdot CB")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t5.e_fade()
            t5.e_normal(-1)
            t5.e_normal(0)
            t5.math(r", \quad\quad(x+y)^2 = (x+y)\,x + (x+y)\,y", same_line=True)
        self.next_page()



