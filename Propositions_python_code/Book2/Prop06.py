import sys
import os

from isort.parse import skip_line

sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *

PPURPLE       = Colour.add( PURPLE,    PURPLE )
REALLY_PURPLE = Colour.add( PPURPLE, PURPLE )

class Prop6(Book2Scene):
    title = "If a straight line be bisected and a straight line be added to it in a straight line, "\
            "the rectangle contained by the whole with the added straight line and the added " \
            "straight line together with the square on the half is equal to the square on the " \
            "straight line made up of the half and the added straight line."



    def go(self):
        # -------------------------------------------------------------------------------------------------------------
        # Definitions
        # -------------------------------------------------------------------------------------------------------------
        t4 = TextBox(mn_coord(800, 150), line_width=mn_scale(480), name='explanation')
        t2 = TextBox(mn_coord(100, 490), name="math")
        t1 = TextBox(mn_coord(600, 490), name="aside")
        t3 = TextBox(mn_coord(200, 650), name="summary")
        A = mn_coord(200,200)
        B = mn_coord(500,200)
        Df = mn_scale(75)
        D = ( B[0] + Df, B[1] )

        CH_colour = SKY_BLUE
        HF_colour = ORANGE
        BM_colour = Colour.lighten(GREEN,20)
        AL_colour = YELLOW
        CM_colour = Colour.add(CH_colour, BM_colour)
        BF_colour = Colour.add(BM_colour, HF_colour)
        LG_colour = PINK
        CF_colour = Colour.add(LG_colour, CH_colour, BM_colour, HF_colour)
        AH_colour = Colour.add(AL_colour, CM_colour)
        NOP_colour = Colour.lighten(Colour.add(CM_colour, BF_colour))
        AM_colour = Colour.add(AL_colour, CH_colour, BM_colour)
        box_colours = {'CH': CH_colour, 'HF': HF_colour, 'AL': AL_colour,
                        'BF': BF_colour, 'CM': CM_colour, 'BM': BM_colour,
                        'LG': LG_colour, 'AH': AH_colour, 'NOP': NOP_colour,
                        'CF': CF_colour, 'AM':AM_colour}
        # -------------------------------------------------------------------------------------------------------------
        # In other words
        # -------------------------------------------------------------------------------------------------------------
        t4.down()
        t4.title("In other words")
        t4.explain(   "Let AB be a straight line, bisected at point C, and extend the line AB to an arbitrary point D" )
        with self.simultaneous():
            pA = EPoint(A, label=('A', mn.LEFT))
            pB = EPoint( B, label=('B', mn.UP))
            lA = ELine( A, B )
            pC = lA.bisect()
            lA.extend(Df)
            pD = EPoint( lA.e_end, label=('D', mn.UR))
            lAC = ELine(pA,pC, label=('x',dict(side=LineLabelSide.INSIDE)))
            lCB = ELine(pC, pB, label=('x', dict(side=LineLabelSide.INSIDE)))
            lBD = ELine(pB, pD, label=('y', dict(side=LineLabelSide.INSIDE)))
            pC.add_label('C', mn.UP)
        t2.math(r"AD=AB+BD,\quad AC = CB,\quad CD=CB+BD", is_axiom=True)
        t1.math(r"AD=2x+y,\quad CD=(x+y)")

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t4.add_marker()
        t4.explain("The rectangle formed by the extended line AD, and the extension BD plus the square on CB "
            "is equal to the square on CD" )
        eq = t2.math(r"AD\cdot DB + CB^2 = CD^2")
        t1.math(r"(2x+y)\,y + x^2 = (x+y)^2")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        t4.delete_until_last_marker()
        t4.math(r"AD\cdot DB + CB^2 = CD^2", transform_from=eq)
        t4.add_marker()
        t4.down()
        with self.simultaneous():
            t2.delete_last()
            t1.e_remove()
        t4.title("Construction:")
        t4.explain(   "Draw a square CEFB on the line CD (I.46) and draw the diagonal DE" )

        sCF = ESquare( pC, pD)
        pE,_,_,pF = sCF.p
        lCE, lCD, lDF, lEF = sCF.l
        with self.simultaneous():
            pE.add_label('E', mn.DOWN)
            pF.add_label('F', mn.DOWN)
        lDE = ELine( pD, pE, skip_anim=True )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t4.explain("From point B, draw a line parallel to either CE or DF (I.31)")
        with self.simultaneous():
            lBG = lCB.perpendicular( pB, length = lCB.length + lBD.length + 0.01)
            pG = EPoint( lBG.intersect( lEF )[0], label=('G', mn.DOWN))
            pH = EPoint( lBG.intersect( lDE )[0],label=('H', mn.UL))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t4.explain("From point H, draw a line parallel to either AB or EF (I.31)")
        with self.simultaneous():
            lHK = lBG.perpendicular( pH, length=2*lCB.length + 0.01 )
            lHM = lBG.perpendicular( pH, length=lBD.length + 0.01, side=LineLabelSide.INSIDE )
            pM = EPoint(lHM.intersect(lDF)[0],label=('M', mn.RIGHT))
            pL = EPoint(lHK.intersect(lCE)[0], label=('L', mn.DL))
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t4.explain("From point A, draw a line parallel to either CL or BH (I.31)")
        lBH = ELine(pB, pH, skip_anim=True).e_hide()
        with self.simultaneous():
            lAK = lAC.perpendicular(pA, length = lBD.length+0.01)
            pK = EPoint( lAK.intersect( lHK )[0] ,label=('K', mn.DOWN))
            lDM = ELine(pM,pD,skip_anim=True).add_label("y")
            lFM = ELine(pF,pM,skip_anim=True).add_label("x")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t4.delete_until_last_marker()
        t4.down()
        t4.title("Proof:")
        t4.explain("Since AC equals CB, then AL equals CH (I.36), and CH equals HF (I.43), "
                "then AL = HF" )
        with self.simultaneous():
            lDE.e_fade()
            sCH = EPolygon(pC, pL, pH, pB, skip_anim=True).e_fill(CH_colour)
            sHF = EPolygon(pH, pG, pF, pM, skip_anim=True).e_fill(HF_colour)
            sAL = EPolygon(pA, pK, pL, pC, skip_anim=True).e_fill(AL_colour)
            sBM = EPolygon(pB, pH, pM, pD, skip_anim=True).e_fill(BM_colour)
        t2.math(r"\square AL = \square CH = \square HF ",colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t2.e_fade(0)
        t2.math(r",\quad\quad\square AL = \square HF" ,
                colours=box_colours, same_line=True)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t4.explain("Add CM to both AL and HF")

        lvHG = ELine( pH, pG, skip_anim=True).e_hide()
        lvHL = ELine( pH, pL, skip_anim=True).e_hide()
        with self.simultaneous():
            sBM.e_hide()
            sCH.e_hide()
            lCE.e_fade()
            lBG.e_fade()
            lEF.e_fade()
            lDF.e_fade()
            sCM = EPolygon( pC, pD, pM, pL,skip_anim=True).e_fill(CM_colour)
            aNOP = EAngle(lvHG, lvHL, gnomon=True, label=(*'NOP',),size=1.5*ANGLE_SIZE)
            lDE.e_hide()

        t2.e_fade(-2)

        t2.math(r"\square AL + \square CM = \square HF + \square CM",
                transform_from=-1, colours=box_colours,
                # transform_args=dict(key_map={
                # r"\square AL =":r"\square AL + \square CM =",
                # r"\square HF":r"\square HF + \square CM"
                # })
                )
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        sNOP = EPolygon(pC, pL, pH, pG, pF, pD, skip_anim=True)
        sAM = EPolygon(pA, pK, pM, pD, skip_anim=True)
        with self.simultaneous():
            sAL.e_hide()
            sCM.e_hide()
            sHF.e_hide()
            sAM.e_fill(AM_colour)
            sNOP.e_fill(NOP_colour)
            pH.e_hide()

        t2.math(r"\square AM =  \square NOP", transform_from=-1,  colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t4.explain("Since DB equals DM, AM is the rectangle formed from AD and DB")
        t2.e_fade()
        with self.simultaneous():
            sNOP.e_hide()
            lDF.e_fade()
        t2.math(r"\square AM = AD\cdot DB", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t4.explain("LG is the square of CB")
        t2.e_fade()
        sLG = EPolygon( pL, pE, pG, pH, skip_anim=True)

        with self.simultaneous():
            sAM.e_hide()
            sLG.e_fill(LG_colour)
        t2.math(r"\square LG = CB^2", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t4.explain("Add LG to AM and the gnomon NOP")
        with self.simultaneous():
            sAM.e_normal()
            sNOP.e_normal()
        with self.simultaneous():
            t2.e_fade()
            t2.e_normal(  -1, -2, -3  )
        t2.math(r"AD\cdot DB + CB^2 = \square NOP + CB^2", colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t4.explain("But LG added to the gnomon NOP is also equal to the square on CD, therefore AM plus LG is equal to CF")
        with self.simultaneous():
            sCM.e_fill(YELLOW)
            sHF.e_fill(BLUE)
            sAL.e_fade()
            sCM.e_fill(Colour.add(YELLOW, BLUE))
            sHF.e_fill(Colour.add(YELLOW, BLUE))
        with self.simultaneous():
            t2.e_fade()
            t2.e_normal(-1)
        t2.math(r"AD\cdot DB + CB^2 = CD^2", transform_from=-1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        with self.simultaneous():
            t2.e_fade()
            t2.e_normal(0)
            t2.e_normal(-1)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # pictorial
        # -------------------------------------------------------------------------------------------------------------
        t2.delete_all()
        buffer = 0.5
        y_delta = [0, -lBD.length - lFM.length - buffer , 0]
        with self.simultaneous():
            sLG.e_normal()
            aNOP.e_hide()
            lDE.e_remove()
            pH.e_remove()
            pE.remove_label()
            pG.remove_label()
            pF.remove_label()
            pK.remove_label()
            pL.remove_label()
            pM.remove_label()
            sAM.add_label(r"(2x+y)\,y")
            sCM.add_label(r"(x+y)\,y")
            sHF.add_label(r'xy')
            sLG.add_label(r'x^2')
            lDFt = lEF.perpendicular(pF, length = 2*buffer + lBD.length, side=LineLabelSide.INSIDE, skip_anim=True).dash()
            # lBGt = lEF.perpendicular(pG, length = 2*buffer  + lBD.length, side=LineLabelSide.INSIDE, skip_anim=True).dash()
            # lCEt = lEF.perpendicular(pE, length = 2*buffer  + lBD.length, side=LineLabelSide.INSIDE, skip_anim=True).dash()
            lAKt = lHK.perpendicular(pK, length = 2*buffer  + lBD.length + lFM.length, side=LineLabelSide.INSIDE, skip_anim=True).dash()


        sAM.e_move(y_delta)(run_time=2)


        eq1 = t3.math(r"AD\cdot DB + CB^2 = CD^2", font_size=20)
        t3.math('(2x+y)y + x^2 = (x+y)^2',transform_from=eq1,
                transform_args=dict(key_map={r'AD\cdot DB': '(2x+y)y', 'CB^2': 'x^2', 'CD^2': '(x+y)^2',}),
                font_size=20)
        self.next_page()


