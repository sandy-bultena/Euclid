import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *

PPURPLE       = Colour.add( PURPLE,    PURPLE )
REALLY_PURPLE = Colour.add( PPURPLE, PURPLE )

class Prop7(Book2Scene):
    title = "If a straight line be cut at random, the square on the whole and that of one of the " \
        "segments both together are equal to twice the rectangle contained by the whole and the said segment " \
        "and the square on the remaining segment."

    def go(self):

        # -------------------------------------------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------------------------------------------
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500))
        t2 = TextBox(mn_coord(100, 490), name='math')
        t3 = TextBox(mn_coord(450, 490), name='aside')
        t4 = TextBox(mn_coord(200, 680), name="summary")


        A = mn_coord(200,180)
        B = mn_coord(400,180)
        C = mn_coord(320,180)

        AG_colour = BLUE
        GE_colour = GREEN
        CF_colour = RED
        AF_colour = Colour.add(AG_colour, GE_colour)
        CE_colour = Colour.add(GE_colour, CF_colour)
        DG_colour = PINK
        KLM_colour = Colour.add(AG_colour, CF_colour, GE_colour)
        AE_colour = Colour.add(KLM_colour, DG_colour)

        box_colours = {"AG":AG_colour,
                       "GE":GE_colour,
                       "CF":Colour.add(AF_colour, CE_colour),
                       "AF":AF_colour,
                       "CE":CE_colour,
                       "DG":DG_colour,
                       "KLM":KLM_colour,
                       "AE":AE_colour,
        }

        # -------------------------------------------------------------------------------------------------------------
        # In other words
        # -------------------------------------------------------------------------------------------------------------
        t1.title("In other words")
        t1.explain("Let AB be a straight line, arbitrarily cut at point C")
        with self.simultaneous():
            pA = EPoint( A, label=('A', mn.LEFT))
            pB = EPoint( B , label=('B', mn.RIGHT))
            pC = EPoint( C , label=('C', mn.UP))
            lAB = ELine( B, A)
            lAC = ELine( C, A, label = "x"  )
            lCB = ELine( B, C, label="y" )
        t2.math("AB = AC + CB", is_axiom=True)
        t2.add_marker()

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.add_marker()
        t1.explain(   "Then the squares formed by lines AB and BC are equal in area to the sum of the square "
                      "formed by line AC, plus twice the area of the rectangle formed by lines AB and CB" )
        t2.math(r"AB^2 + BC^2 = AC^2 + 2\cdot AB\cdot BC")
        t3.down()
        t3.math('(x+y)^2 + y^2 = x^2 + 2(x+y)y')
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t1.delete_until_last_marker()
        with self.simultaneous():
            t1.math(r"AB^2 + BC^2 = AC^2 + 2\cdot AB\cdot BC", transform_from=t2[-1])
            t2.delete_until_last_marker()
            t3.delete_until_last_marker()

        t1.add_marker()
        t1.down()
        t1.title("Construction:")
        t1.explain(   "Draw a square ADEB on the line AB (I.46), and draw the diagonal BD" )
        sAB = ESquare( pB, pA , clockwise=True)
        pE,_,_,pD = sAB.p
        pE.add_label("E", mn.RIGHT)
        pD.add_label("D", mn.DOWN)
        lBE, _, lAD, lDE = sAB.l
        lBD = ELine(pB, pD)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Draw a line CN parallel to AD (I.31), labelling the intersection with the diagonal as G" )
        t1.explain("Draw a line parallel to AB through the point G (I.31).")

        with self.simultaneous():
            lCN = lAB.perpendicular(pC, length=lAB.length + 0.01, side=LineLabelSide.INSIDE)
            pG = lCN.intersection_e_point(lBD)
            pN = lCN.intersection_e_point(lDE)
            lGH = lAD.perpendicular(pG)
            pH = EPoint(lGH.end)
            lFG = lBE.perpendicular(pG)
            pF = EPoint(lFG.end)
        lBF = ELine(pF,pB,skip_anim=True)
        lEF = ELine(pE,pF,skip_anim=True)
        with self.simultaneous():
            pG.add_label('G', mn.UL)
            pN.add_label('N', mn.DOWN)
            pH.add_label('H', mn.LEFT)
            pF.add_label('F', mn.RIGHT)
            lBF.add_label('y')
            lEF.add_label('x')
        lBD.e_fade()
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t1.delete_until_last_marker()
        t1.down()
        t1.title("Proof:")
        t1.explain(   "AG equals GE (I.43), add CF to both, thus preserving the equality" )

        sAF = EPolygon( pA, pH, pF, pB, skip_anim=True ).e_fill(AF_colour)
        sCE = EPolygon( pC, pN, pE, pB, skip_anim=True ).e_fill(CE_colour)

        t2.e_fade()
        t2.math(r"\square AF = \square CE", colours = box_colours)
        t2.math(r"\square AF + \square CE = 2\square AF", transform_from = -1, colours = box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("But AF plus CE is equal to the gnomon KLM plus CE, therefore the gnomon KLM and CE is twice AF" )

        lvHG = VirtualLine( pH, pG )
        lvGN = VirtualLine( pG, pN )
        aKLM = EAngle(lvGN, lvHG, gnomon=True, label=(*'KLM',), size=2*ANGLE_SIZE)
        t2.e_fade(-2)
        t2.math(   r"\square KLM + \square CF = \square AF + \square CE = 2\square AF", transform_from=-1, colours = box_colours )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Let DG, the square on AC, be added to each")
        sDG = EPolygon( pH, pD, pN, pG, skip_anim=True ).e_fill(DG_colour)
        t2.down()
        eq = t2.math(r"\square KLM + \square DG + \square CF = 2\square AF + \square DG ", transform_from=-1, colours = box_colours  )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Let DG, the square on AC, be added to each")
        t1.explain("But the gnomon KLM and DG equals the square AE")

        with self.simultaneous():
            t2.e_fade()
            t2.e_normal(-1)
        t2.math(r"\square AE+ \square CF = 2\square AF + \square DG", align_str="=", align_index=eq,
                colours = box_colours, transform_from=-1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("AE equals the square on AB, CF equals the square on CB, AF is the rectangle formed by AB and BC, "
               "and finally DG is the square on AC")
        with self.simultaneous():
            t2.e_fade()
            t2.e_normal(-1,-2)
        t2.math(r"AB^2 + CB^2 = 2\cdot AB\cdot BC + AC^2", colours = box_colours, align_str="=", transform_from=-1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t2.e_fade()
            t2.e_normal(-1)
            t2.e_normal(0)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # pictorial
        # -------------------------------------------------------------------------------------------------------------
        t2.e_remove()
        sCF = EPolygon( pC, pG, pF, pB, skip_anim=True )
        with self.simultaneous():
            sCF.e_fill(CF_colour)
            sCF.add_label('y^2')
            sCE.add_label(r'(x+y)\,y')
            sAF.add_label(r'(x+y)\,y')
            sDG.add_label(r'x^2')
            aKLM.remove_label()
            aKLM.e_remove()
            pH.e_remove()
            pD.e_remove()
            pN.e_remove()
            pG.e_remove()
            pF.e_remove()
            pE.e_remove()
            lCN.e_hide()
            lBD.e_remove()
            pA.add_label("A",mn.UP)
            pB.add_label("B",mn.UP)

        buffer = 0.4
        x_shift1 = [1*buffer+ lCB.length, 0, 0]
        x_shift2 = [4*buffer + lCB.length,0,0]
        with self.simultaneous():
            sCE.e_move(x_shift2)(run_time=2)
            sCF.e_move(x_shift1)(run_time=2)

        t4.math(r"AB^2 + BC^2 = AC^2 + 2\cdot AB\cdot BC")
        t4.math('(x+y)^2 + y^2 = x^2 + 2(x+y)y')

        self.next_page()


