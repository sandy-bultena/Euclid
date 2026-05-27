import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Scenes.book02 import Book2Scene
from euclidlib.Objects import *

class Prop5(Book2Scene):
    steps = []
    title = ("If a straight line be cut into equal and unequal segments, "
             "the rectangle contained by the unequal "
             "segments of the whole together with the square on the straight line between the "
             "points of section is equal to the square on the half")

    def go(self):

        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550), name='explain')
        t2 = TextBox(mn_coord(600, 420), name='aside')
        t3 = TextBox(mn_coord(100, 420), name='math')
        t4 = TextBox(mn_coord(800, 150), line_width=mn_scale(480))
        t5 = TextBox(mn_coord(200, 650), name="summary")

        l: dict[str | int, ELine] = {}
        p: dict[str | int, EPoint] = {}
        c: dict[str | int, ECircle] = {}
        t: dict[str | int, ETriangle] = {}
        s: dict[str | int, EPolygon] = {}
        a: dict[str | int, EAngleBase] = {}
        eq: dict[str | int, EStringObj] = {}
        ex: dict[str | int, mn.Mobject] = {}

        A = mn_coord(125, 170)
        B = mn_coord(550, 170)
        D = mn_coord(425, 170)

        CH_colour = SKY_BLUE
        HF_colour = ORANGE
        AL_colour = YELLOW
        DM_colour = GREEN
        CM_colour = Colour.add(CH_colour,DM_colour)
        DF_colour = Colour.add(DM_colour,HF_colour)
        LG_colour = PINK
        CF_colour = Colour.add(LG_colour, CH_colour, DM_colour, HF_colour)
        AH_colour = Colour.add(AL_colour, CM_colour)
        NOP_colour = Colour.add(CM_colour, DF_colour)
        box_colours = ({'CH':CH_colour,'HF':HF_colour, 'AL':AL_colour,
                        'DF':DF_colour, 'CM':CM_colour, 'DM':DM_colour,
                        'LG':LG_colour, 'AH':AH_colour, 'NOP':NOP_colour,
                        'CF':CF_colour})



        # -------------------------------------------------------------------------------------------------------------
        # In Other Words
        # -------------------------------------------------------------------------------------------------------------
        t4.title("In other words:")
        t4.explain("Let AB be a straight line, bisected at point C, "
                   "and cut at an arbitrary point D")

        with self.simultaneous():
            pA = EPoint(A, label=('A', UP))
            pB = EPoint(B, label=('B', UP))
            lA = ELine(B,A)

            pC = EPoint(lA.bisect()).add_label("C",mn.UP)
            C = pC.coords
            pD = EPoint(D, label=('D', UP))

            lx = ELine(A,C, label=('x', UP))
            ly = ELine(C,D, label=('y', UP))
            lxy = ELine(D,B, label=('x-y', UP))
            lAC = lx
            lCD = ly
            lBD = lxy

        with self.simultaneous():
            t3.math(r'AC = CB,\quad AD = AC+AD,\quad DB = CB-CD', is_axiom=True)
            t3.add_marker()
            t2.math(r'AC = x, \quad CB = x, \quad CD = y')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t4.add_marker()
        t4.explain("The rectangle formed by the uneven segments "
                   "(AD and{nb}DB) added to the "
                   "square of the tiny segment CD, is equal to the half segment "
                   "(CB) all squared.")
        with self.simultaneous():
            t3.math(r'AD \cdot DB + CD^2 = CB^2')
            t2.math(r'(x+y) \cdot (x-y) + y^2 = x^2')

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t4.delete_until_last_marker()
        t4.math(r'AD \cdot DB + CD^2 = CB^2', transform_from=t3[-1])
        with self.simultaneous():
            t2.delete_until_last_marker()
            t3.delete_until_last_marker()

        t1.next_to(t4, DOWN, aligned_edge=LEFT)
        t1.down()
        t1.title("Construction:")
        t1.explain("Draw a square CEFB on the line CB{nb}(I.46) and draw the diagonal BE")

        sCF = ESquare(pC, pB, point_labels=["E", None, None, "F"])
        F = pF = sCF.p3
        E = pE = sCF.p0
        lBE = ELine(B,E)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("From point D, draw a line parallel to either CE of BF (I.31)")

        with self.simultaneous():
            lD = ly.perpendicular(D,length=lx.length+.01)
            G = pG = EPoint(lD.intersect_line(sCF.l3)[0], label=("G", DOWN))
            H = pH = EPoint(lD.intersect_line(lBE)[0], label=("H", UL))

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("From point H, draw a line parallel to either AB or EF{nb}(I.31)")

        with self.simultaneous():
            lHK = lD.perpendicular(pH, length = lAC.length + lCD.length)
            lHM = lD.perpendicular(pH, length = lBD.length, side=LineLabelSide.INSIDE)
            L=pL = EPoint(lHK.intersect(sCF.l0)[0], label=("L", DL))
            M =pM = EPoint(lHM.intersect(sCF.l2)[0], label=("M", RIGHT))

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("From point A, draw a line parallel to either "
                   "CL or BM{nb}(I.31)")

        with self.simultaneous():
            lAK = lAC.perpendicular(pA, length=lBD.length)
            K = pK = EPoint(lAK.intersect((lHK))[0], label=('K', DOWN))

        lKL = ELine(K,H, skip_anim=True)
        lLM = ELine(H,M, skip_anim=True)
        lK = ELine(A,K, skip_anim=True)
        ly2 = ELine(M,F, skip_anim=True)
        lxy2 = ELine(B,M, skip_anim=True)
        lHK.e_remove()
        lHM.e_remove()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            t1.e_remove()
        t1.next_to(t4, DOWN, aligned_edge=LEFT)
        t1.down()
        t1.title("Proof:")
        t1.explain("The complements CH and HF are equal{nb}(I.43), "
                   "and if we add the rectangle DM, "
                   "then the rectangles CM and DF are equal")

        lBE.e_fade()
        with self.simultaneous():
            sCH = EPolygon(C,L,H,D, skip_anim=True).e_fill(CH_colour)
            sHF = EPolygon(H,G,F,M, skip_anim=True).e_fill(HF_colour)
        with self.simultaneous():
            eq = t3.math(r'\square CH = \square HF', colours=box_colours)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        sDM = EPolygon(D, H, M, B, skip_anim=True).e_fill(DM_colour)
        with (self.simultaneous()):
            sCH.e_normal()
            lBE.e_hide()

        t3.math(r'\square CH + \square DM = \square HF + \square DM', transform_from=eq,
                transform_args=dict(key_map=
                                    {r'\square CH':r'\square CH + \square DM',
                                     r'\square HF':r'\square HF + \square DM'},
                                    ),
                 colours=box_colours)

        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        sCH.e_normal()
        sHF.e_normal()
        t3.math(r':\quad\quad \therefore\  \square CM = \square DF',
                transform_from=-1, colours=box_colours, same_line=True)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("The rectangles CM and AL are equal (I.36)")
        sAL = EPolygon(A,K,L,C, skip_anim=True)
        sCM = EPolygon(pC, pL, pM, pB, skip_anim=True)
        with self.simultaneous():
            sHF.e_hide()
            sAL.e_fill(AL_colour)
            sCM.e_fill(CM_colour)
            sHF.remove_label()
            sCH.remove_label()
            sDM.remove_label()
            sDM.e_hide()
            sCH.e_hide()

        with self.simultaneous():
            t3.e_fade()
            t3.e_normal(-1)
            t3.math(r'\square AL = \square CM', colours=box_colours)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("which means that AL and DF are also equal")
        t3.e_append(-1, r"= \square DF", colours=box_colours)
        sDF = EPolygon(pD, pG, pF, pB, skip_anim=True)

        with self.simultaneous():
            lD.e_normal()
            lLM.e_fade()
            sDF.e_fill(DF_colour)
            sCH.e_hide()

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Let CH be added to each of AL and DF. Now AH is equal to {nb:gnomon NOP}")
        sCH.remove_label()
        lLH=ELine(L,H, skip_anim=True).e_hide()
        lHG=ELine(H,G, skip_anim=True).e_hide()
        sAH = EPolygon(A,pK, pH, D, skip_anim=True)
        sNOP = EPolygon(C, B, F, G, H, L, skip_anim=True)
        t3.math(r'\square AL + \square CH = \square DF + \square CH',
                colours=box_colours, transform_from=-1, transform_args=dict(
                key_map={
                    r'\square AL =': r'\square AL + \square CH =',
                    r'\square DF': r'\square DF + \square CH'
                }
            ))

        with self.simultaneous():
            sAL.e_hide()
            sCM.e_hide()
            sDF.e_hide()
            sAH.e_fill(AH_colour)
            sNOP.e_fill(NOP_colour)


        aNOP = EAngle(lLH,lHG, size=mn_scale(60), label=(*'NOP',), gnomon=True)

        #sCH.e_fill(CH_colour)
        t3.math(r'\square AH = \square NOP', align_str="=",
                colours=box_colours)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("For a proof showing that DM and LG are squares, see II.4 ")
        with self.simultaneous():
            t3.e_fade()
            lBM = sDM.l[2].e_normal()
            lFM = sHF.l[2].e_normal()
        with self.simultaneous():
            sDM.add_line_labels('','',('x-y',dict(buff=1.5*LABEL_BUFF)),'')
            sHF.add_line_labels('','','y','')
        sLG = EPolygon(L,E,G,H, skip_anim=True).e_fill(PINK)
        t3.math(r'DH = DB\ ,\ \square LG = CD^2', colours=box_colours)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explainM("AH is equal to the rectangle formed by $AD,DH$, "
                    r"and also by $AD,DB$, therefore $AD \cdot DB$ "
                    "is equal to the gnomon $NOP$")
        with self.simultaneous():
            t3.e_fade()
            sDM.e_remove_line_labels()
            sHF.e_remove_line_labels()
            t3.e_normal(-1, -2)
        t3.math(r'\square AH = AD \cdot DB = \square NOP', colours=box_colours, align_str="=")

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("LG is equal to the square on CD, add it "
                   "to both AH and NOP, retaining the equality")

        with self.simultaneous():
            t3.e_fade()
            t3.e_normal(-1)
        t3.math(r"AD \cdot DB + CD^2 = \square NOP + \square LG = \square CF", colours=box_colours,
                transform_from=-1, transform_args=dict(key_map= {
                r'\square AH = ':'',
                r'AD \cdot DB =':r'AD \cdot DB + CD^2 =',
                r'\square NOP':r'\square NOP + \square LG'
            }))

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("But CF is equal to the square on CB, which is also equal "
                   "to the gnomon NOP added to the rectangle LG, "
                   "thus we have demonstrated the proof for this proposition")

        with self.simultaneous():
            t3.e_fade()
            t3.e_normal(-1)
        t3.math(r"AD \cdot DB + CD^2 = CB^2")

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            t3.e_fade()
            t3.e_normal(0)
            t3.e_normal(-1)
            #t3.math(r'(x+y) \cdot (x-y) + y^2 = x^2')
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # pictorial
        # -------------------------------------------------------------------------------------------------------------
        t3.delete_all()
        #sDF = EParallelogram(pD, pG, pF, pB, skip_anim=True)
        with self.simultaneous():
            pass
            aNOP.remove_label()
            pK.remove_label()
            pL.remove_label()
            pE.remove_label()
            pG.remove_label()
            lBE.e_remove()
            sCF.e_hide()
            aNOP.e_remove()
            pH.remove_label()
            pG.remove_label()
            pF.remove_label()
            pM.remove_label()
            lBM.remove_label()
            lFM.remove_label()
            sDM.e_remove()
            lLM.e_remove()
            pM.e_remove()
            sDF.e_hide()
            sCH.e_hide()
            lD.e_hide()

        with self.simultaneous():
            pass
            sLG.add_label('y^2')
            sLG.add_line_labels('y')

            lBF = ELine(pF,pB,skip_anim=True).add_label('x')
            lEF = ELine(pE,pF, skip_anim=True)

        buffer = 0.5
        y_delta = [0, -lAC.length - buffer , 0]
        with self.simultaneous():
            pass
            lAKt = lKL.perpendicular(pK, length = 1.5*buffer + lBD.length + lCD.length, skip_anim=True).dash()
            lDGt = lEF.perpendicular(pG, length = 1.5*buffer  + lBD.length, skip_anim=True).dash()
            lBFt = lEF.perpendicular(pF, length = 1.5*buffer  + lBD.length, skip_anim=True).dash()

            sNOP.add_label("(x+y)(x-y)")
            sNOP.add_line_labels("","","","","",('x-y',dict(buff=2*LABEL_BUFF, side=LineLabelSide.INSIDE)))
            sAH.add_label('(x+y)(x-y)')
            sAH.add_line_labels(('x-y',dict(buff=2*LABEL_BUFF)),'','','x+y')
        with self.simultaneous():
            sAH.e_move(y_delta)(run_time=2)


        t5.math(r"AD \cdot DB + CD^2 = CB^2")
        t5.math(r'(x+y)(x-y) + y^2 = x^2', align_str="=", transform_from=-1,
                transform_args=dict(key_map={
                    'AD':'(x+y)', 'DB':'(x-y)', 'CD^2':'y^2', 'CB^2':'x^2'
                }))



        self.next_page()
