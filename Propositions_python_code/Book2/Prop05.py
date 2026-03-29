import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.BookScene import Book2Scene
from euclidlib.Objects import *

class Prop5(Book2Scene):
    steps = []
    title = ("If a straight line be cut into equal and unequal segments, "
             "the rectangle contained by the unequal "
             "segments of the whole together with the square on the straight line between the "
             "points of section is equal to the square on the half")

    def go(self):

        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(550))
        t2 = TextBox(mn_coord(200, 500))
        t3 = TextBox(mn_coord(200, 500))
        t4 = TextBox(mn_coord(800, 150), line_width=mn_scale(480))
        t5 = TextBox(mn_coord(820, 150), line_width=mn_scale(480))

        l: dict[str | int, ELine] = {}
        p: dict[str | int, EPoint] = {}
        c: dict[str | int, ECircle] = {}
        t: dict[str | int, ETriangle] = {}
        s: dict[str | int, EPolygon] = {}
        a: dict[str | int, EAngleBase] = {}
        eq: dict[str | int, EStringObj] = {}
        ex: dict[str | int, mn.Mobject] = {}

        A = mn_coord(125, 200)
        B = mn_coord(600, 200)
        D = mn_coord(450, 200)

        # -------------------------------------------------------------------------------------------------------------
        # In Other Words
        # -------------------------------------------------------------------------------------------------------------
        t4.title("In other words:")
        t4.explain("Let AB be a straight line, bisected at point C, "
                   "and cut at an arbitrary point D")
        p['A'] = EPoint(A, label=('A', UP))
        p['B'] = EPoint(B, label=('B', UP))
        l['A'] = ELine(B,A)
        p['C'] = l['A'].bisect()
        C = p['C'].coords
        p['C'].add_label('C', UP)
        p['C'].e_draw()
        p['D'] = EPoint(D, label=('D', UP))

        t2.math(r'AC = CB,\quad AD = AC+AD,\quad DB = BC-CD', ).e_fill(mn.BLUE)
        t3.next_to(t2, DOWN)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t4.explain("The rectangle formed by the uneven segments "
                   "(AD and{nb}DB) added to the "
                   "square of the tiny segment CD, is equal to the half segment "
                   "(CB) all squared.")
        with self.staggered_animation():
            t2.math(r'AD \cdot DB + CD \cdot CD = CB \cdot CB')
            t2.math(r'AD \cdot DB = CB \cdot CB - CD \cdot CD')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            l['x'] = ELine(A,C, label=('x', UP))
            l['y'] = ELine(C,D, label=('y', UP))
            l['xy'] = ELine(D,B, label=('x-y', UP))

        t2.math(r'(x+y) \cdot (x-y) = x^2 - y^2')

        # -------------------------------------------------------------------------------------------------------------
        # Construction
        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        with self.simultaneous():
            for t in t2[1:]:
                t.e_remove()

        t1.next_to(t4, DOWN, aligned_edge=LEFT)
        t1.down()
        t1.title("Construction:")
        t1.explain("Draw a square CEFB on the line CB{nb}(I.46) "
                   "and draw the diagonal BE")

        s["CF"] = ESquare(p["C"], p["B"], point_labels=["E", None, None, "F"])
        F = p["F"] = s["CF"].p3
        E = p["E"] = s["CF"].p0
        l["BE"] = ELine(B,E)

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("From point D, draw a line parallel to either CE of BF{nb}(I.31)")

        l["Dt"] = s["CF"].l2.parallel(p["D"])
        G = p["G"] = EPoint(l["Dt"].intersect_line(s["CF"].l3)[0], label=("G", DOWN))
        l["D"] = ELine(D,G)
        H = p["H"] = EPoint(l["Dt"].intersect_line(l["BE"])[0], label=("H", UL))
        l["Dt"].e_fade()
        l["Dt"].e_remove()

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("From point H, draw a line parallel to either AB or EF{nb}(I.31)")

        l["Ht"] = l["A"].parallel(p["H"])
        p["M"] = EPoint(l["Ht"].intersect(s["CF"].l2)[0], label=("M", DR))
        L=p["L"] = EPoint(l["Ht"].intersect(s["CF"].l0)[0], label=("L", DL))
        l["Ht"].extend(mn_scale(150))

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("From point A, draw a line parallel to either "
                   "CL or BM{nb}(I.31)")

        l["Kt"] = s["CF"].l2.parallel(p["A"])
        K = p['K'] = EPoint(l['Kt'].intersect((l['Ht']))[0], label=('K', DOWN))

        self.wait(0.5, ignore_presenter_mode=True)
        with self.simultaneous():
            l['Kt'].e_remove()
            l['Ht'].e_remove()
            M = p['M'].add_label('M', RIGHT)

        self.wait(0.5, ignore_presenter_mode=True)
        with self.simultaneous():
            l['KL'] = ELine(K,H)
            l['LM'] = ELine(H,M)
            l['K'] = ELine(A,K)
            l['y2'] = ELine(M,F, label=('y', RIGHT))
            l['xy2'] = ELine(B,M, label=('x-y', RIGHT, dict(buff=0.3)))

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

        s['CH'] = EPolygon(C,L,H,D, skip_anim=True).e_fill(BLUE_E)
        s['HF'] = EPolygon(H,G,F,M, skip_anim=True).e_fill(BLUE_E)
        s['DM'] = EPolygon(D,H,M,B, skip_anim=True).e_fill(BLUE)

        l['BE'].e_fade()

        with self.simultaneous():
            t3.e_fade()
        t3.math(r'\square CH = \square HF\\ \therefore\  \square CM = \square DF')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("The rectangles CM and AL are equal{nb}(I.36)")
        s['AL'] = EPolygon(A,K,L,C, skip_anim=True).e_fill(GREEN)
        with self.simultaneous():
            s['HF'].e_unfill()
            s['DM'].e_fill(BLUE_E)
            s['CH'].e_fill(BLUE_E)

        with self.simultaneous():
            t3.green(1)
        t3.math(r'\square AL = \square CM')

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("which means that AL and DF are also equal")
        t3.e_append(-1, r"= \square DF")
        with self.simultaneous():
            l['D'].e_normal()
            l['LM'].e_fade()
            s['DM'].e_fill(BLUE_E)
            s['HF'].e_fill(BLUE_E)
            s['CH'].e_unfill()

        # -------------------------------------------------------------------------------------------------------------
        self.next_page()
        t1.explain("Let CH be added to each of AL and DF. "
                   "Now AH is equal to gnomon NOP")
        a['NOP'] = EAngle(l["LH"],l["HG"], size=mn_scale(60), label=(list('ONP'),), gnomon=True)
        s['CH'].e_fill(TEAL)
        t3.math(r'\square AH = NOP')

        # # -------------------------------------------------------------------------------------------------------------
        # self.next_page()
        # t1.explain("For a proof showing that DM and LG are squares, see II.4 ")
        # with self.simultaneous():
        #     t3.e_fade()
        # t3.math(r'DH = DB\ ,\ \square LG = \square CD')
        #
        # # -------------------------------------------------------------------------------------------------------------
        # self.next_page()
        # t1.explainM("AH is equal to the rectangle formed by $AD,DH$, "
        #             r"and also by $AD,DB$, therefore $AD \cdot DB$ "
        #             "is equal to the gnomon $NOP$")
        # with self.simultaneous():
        #     t3.e_fade()
        #     t3.e_normal(-1, -2)
        # t3.math(r'\square AH = AD \cdot DB = NOP')
        #
        # # -------------------------------------------------------------------------------------------------------------
        # self.next_page()
        # t1.explain("LG is equal to the square on CD, add it "
        #            "to both AH and NOP, retaining the equality")
        #
        # s['LG'] = EPolygon('LEGH', skip_anim=True).e_fill(PINK)
        #
        # with self.simultaneous():
        #     t3.e_fade()
        #     t3.e_normal(-2)
        # t3.math(r"AD \cdot DB + CD \cdot CD = NOP + \square LG")
        #
        # # -------------------------------------------------------------------------------------------------------------
        # self.next_page()
        # t1.explain("But CF is equal to the square on CB, which is also equal "
        #            "to the gnomon NOP added to the rectangle LG, "
        #            "we have demonstrated the proof for this postulate")
        #
        # with self.simultaneous():
        #     t3.e_fade()
        #     t3.e_normal(-1)
        # t3.math(r"AD \cdot DB + CD \cdot CD = CB \cdot CB")
        #
        # # -------------------------------------------------------------------------------------------------------------
        # self.next_page()
        # with self.simultaneous():
        #     t3.e_fade()
        #     t3.e_normal(-1)
