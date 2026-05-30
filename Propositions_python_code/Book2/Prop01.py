
import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *

PPURPLE       = Colour.add( PURPLE,    PURPLE )
REALLY_PURPLE = Colour.add( PPURPLE, PURPLE )

class Prop1(Book2Scene):
    title = ("If there be two straight lines, and of of them be cut into any number of segments whatever, "
        "the rectangle contained by the two straight lines is equal to the rectangles contained by "
        "the uncut straight line and each of the segments."
    )

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500))
        t5 = TextBox(mn_coord(100, 480))
        t3 = TextBox(mn_coord(500, 480))

        A = mn_coord(200, 200)
        Ap = mn_coord(350, 200)
        B = mn_coord(200, 250)
        C = mn_coord(550, 250)
        D = mn_coord(375, 250)
        E = mn_coord(500, 250)

        BK_colour = PURPLE
        DL_colour = GREEN
        EH_colour = ORANGE
        BH_colour = Colour.lighten(Colour.add(BK_colour, DL_colour, EH_colour),20)
        box_colours = {
            'BK': BK_colour,
            'DL': DL_colour,
            'EH': EH_colour,
            'BH': BH_colour
        }


        # -------------------------------------------------------------------------------------------------------------
        # In Other Words
        # -------------------------------------------------------------------------------------------------------------
        t1.title("In other words")
        t1.explain("Let A and BC be two straight lines")
        t1.explain("Let BC be arbitrarily cut at points D and E ")
        t1.add_marker()
        with self.simultaneous():
            pA = EPoint( A ,label=('A', mn.LEFT))
            lA = ELine( Ap, A, label='a' )
            pB = EPoint( B ,label=("B", mn.LEFT))
            pC = EPoint( C ,label=("C", mn.RIGHT))
            lBD = ELine( B, D, label=('x', dict(side=LineLabelSide.INSIDE)) )
            lDE = ELine( D, E, label=('y', dict(side=LineLabelSide.INSIDE)) )
            lCE = ELine( E, C, label=('z', dict(side=LineLabelSide.INSIDE)) )
            pD = EPoint( D ,label=("D", mn.UP))
            pE = EPoint( E ,label=("E", mn.UP))
        with self.simultaneous():
            t5.math("BC = BD + DE + CE", is_axiom=True)
            t3.math("b = x + y + z", is_axiom = True)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Then the area of the rectangle formed by line A "
                      "and BC is equal in area to the sum of the rectangles "
                      "formed by line A and BD, line A and DE, "
                      "and line A and EC" )
        with self.simultaneous():
            t5.math(r"A\cdot BC = A\cdot BD + A\cdot DE + A\cdot EC")
            t3.math("ab = ax + ay + az")
        self.next_page()


        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t5.delete_last()
            t3.e_remove()
            t1.delete_until_last_marker()
        t1.math(r"A\cdot BC = A\cdot BD + A\cdot DE + A\cdot EC", transform_from=t5[-1])
        t1.title("Proof:")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Draw a line BF perpendicular to BC (I.11)")
        lBF = lBD.perpendicular( pB, length=mn_scale(200))
        pF = EPoint( lBF.end ).add_label("F", mn.LEFT)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Define point G such that BG {nb:equals A (I.3)}")
        ( lBG, pG ) = lA.copy_to_line( pB, lBF )
        lBG.add_label("a")
        pG.add_label("G", mn.LEFT)
        t5.math("A = BG")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Draw GH parallel to BC, and DK, EL, and CH parallel to{nb: BG (I.31)}" )
        lGH = lBG.perpendicular( pG, length = lBD.length + lDE.length + lCE.length, side=LineLabelSide.INSIDE )
        with self.simultaneous():
            lDK = lBD.perpendicular(pD, length=lA.length)
            lEL = lDE.perpendicular( pE, length = lA.length )
            lCH = lCE.perpendicular( pC, length=lA.length )
            pK = EPoint( lDK.intersect( lGH )[0], label=["K",mn.DOWN])
            pL = EPoint( lEL.intersect( lGH )[0], label=("L", mn.DOWN))
            pH = EPoint( lCH.intersect( lGH )[0], label=("H", mn.DOWN))

        t5.math("= DK = EL = CH", same_line=True)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The rectangle BH is the sum of the rectangles BK DL{nb: and EH}")

        with self.simultaneous():
            sBK = EPolygon( pB, pG, pK, pD, fill=BK_colour, label="ax")
            sDL = EPolygon( pD, pK, pL, pE, fill=DL_colour, label="ay")
            sEH = EPolygon( pE, pL, pH, pC, fill=EH_colour, label="az" )
            sBH = EPolygon( pB, pG, pH, pC )
            lDK.e_remove()
            lEL.e_remove()

        with self.simultaneous():
            sBK.add_label("ax")
            sDL.add_label("ay")
            sEH.add_label("az")


        with self.simultaneous():
            t5.e_fade()
            t5.blue(0)

        eq3 = t5.math(r"\square BH = \square BK + \square DL + \square EH",
                     colours = box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain( "Since BG is equal in length to A, the rectangle "
                  "BH is equal to the rectangle contained by lines A and BC" )
        with self.simultaneous():
            sBK.e_fade()
            sDL.e_fade()
            sEH.e_fade()
            sBH.e_fill(BH_colour)
            sBH.add_label('a(x+y+z)')

        with self.simultaneous():
            eq3.e_fade()
            t5.normal_color(1)
        eq4 = t5.math(   r"\square BH = BG\cdot BC, \quad \therefore\quad \square BH = A\cdot BC",
                   colours = box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Similarly, the rectangle BK is equal to the "
                       "rectangle contained by lines A and BD" )
        with self.simultaneous():
            sBH.e_fade()
            sBK.e_normal()
        with self.simultaneous():
            t5.normal_color(2)
            eq4.e_fade()

        eq5 = t5.math(   r"\square BK = BG\cdot BD, \quad \therefore\quad \square BK = A\cdot BD",
                   colours = box_colours )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "Since BG equals DK (I.34), DL is equal to the rectangle "
                       "contained by lines A and DE" )
        with self.simultaneous():
            sBK.e_fade()
            sDL.e_normal()
        with self.simultaneous():
            t5.normal_color(2)
            eq5.e_fade()

        eq6 = t5.math(   r"\square DL = DK\cdot DE, \quad \therefore\quad \square DL = A\cdot DE",
                   colours = box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain(   "And finally, EH is equal to the rectangle "
                      "contained by lines A and EC" )
        with self.simultaneous():
            sDL.e_fade()
            sEH.e_normal()
        with self.simultaneous():
            t5.normal_color(2)
            eq6.e_fade()

        eq7 = t5.math(   r"\square EH = EL\cdot EC, \quad \therefore\quad \square EH = A\cdot EC",
                   colours = box_colours )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Thus the rectangle formed by A,BC is equal to the sum "
        "of the rectangles formed by A,BD, A,DE and A,EC")
        with self.simultaneous():
            sBK.e_normal()
            sEH.e_normal()
            sDL.e_normal()

        t5.e_normal( slice(3,8) )
        t5.down()
        t5.math(r"A\cdot BC = A\cdot BD + A\cdot DE + A\cdot EC")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t5.e_fade(slice(1, 8))

        self.next_page()
