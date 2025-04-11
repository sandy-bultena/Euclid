import sys
import os

sys.path.append(os.getcwd())

from euclidlib.Propositions.BookScene import Book2Scene
from euclidlib.Objects import *
from typing import Dict


class Prop5(Book2Scene):
    steps = []
    title = ("If a straight line be cut into equal and unequal segments, "
             "the rectangle contained by the unequal "
             "segments of the whole together with the square on the straight line between the "
             "points of section is equal to the square on the half")

    def define_steps(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(550))
        t2 = TextBox(mn_coord(200, 500))
        t3 = TextBox(mn_coord(200, 500))
        t4 = TextBox(mn_coord(800, 150), line_width=mn_h_scale(480))
        t5 = TextBox(mn_coord(820, 150), line_width=mn_h_scale(480))

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, EPoint] = {}
        c: Dict[str | int, ECircle] = {}
        t: Dict[str | int, ETriangle] = {}
        s: Dict[str | int, EPolygon] = {}
        a: Dict[str | int, EAngleBase] = {}
        eq: Dict[str | int, EStringObj] = {}
        ex: Dict[str | int, Mobject] = {}

        A = mn_coord(125, 200)
        B = mn_coord(600, 200)
        D = mn_coord(450, 200)

        # ----------------------------------------------
        # In Other Words
        # ----------------------------------------------
        @self.push_step
        def i01_AB_bisect_at_C_with_D():
            t4.title("In other words:")
            t4.explain("Let AB be a straight line, bisected at point C, "
                       "and cut at an arbitrary point D")
            p['A'] = EPoint(A, label=('A', UP))
            p['B'] = EPoint(B, label=('B', UP))
            l['A'] = ELine('BA')
            with self.pause_animations_for():
                p['C'] = l['A'].bisect()
            p['C'].add_label('C', UP)
            p['C'].e_draw()
            p['D'] = EPoint(D, label=('D', UP))

            t2.math(r'AC = CB\ ,\ AD = AC+AD\ ,\ DB = BC-CD', fill_color=BLUE)
            t3.next_to(t2, DOWN)

        @self.push_step
        def i02_formulation():
            t4.explain("The rectangle formed by the uneven segments "
                       "(AD and{nb}DB) added to the "
                       "square of the tiny segment CD, is equal to the half segment "
                       "(CB) all squared.")
            with self.delayed():
                t2.math(r'AD \cdot DB + CD \cdot CD = CB \cdot CB\ \\ '
                        r'AD \cdot DB = CB \cdot CB - CB \cdot CB')

        @self.push_step
        def i03_draw_lines():
            nonlocal p
            with self.simultaneous():
                l['x'] = ELine('AC', label=('x', UP))
                l['y'] = ELine('CD', label=('y', UP))
                l['xy'] = ELine('DB', label=('x-y', UP))

            t2.math(r'(x+y) \cdot (x-y) = x^2 - y^2')

        # ----------------------------------------------
        # Construction
        # ----------------------------------------------
        @self.push_step
        def c00_draw_BE_square():
            with self.simultaneous():
                for t in t2[1:]:
                    t.e_remove()

            t1.next_to(t4, DOWN, aligned_edge=LEFT)
            t1.down()
            t1.title("Construction:")
            t1.explain("Draw a square CEFB on the line CB{nb}(I.46) "
                       "and draw the diagonal BE")

            s["CF"] = ESquare(p["B"], p["C"], point_labels=["F", None, None, "E"])
            p["F"] = s["CF"].p0
            p["E"] = s["CF"].p3
            l["BE"] = ELine("BE")

        # ----------------------------------------------
        @self.push_step
        def c01_draw_parallel_to_CE():
            t1.explain("From point D, draw a line parallel to either CE of BF{nb}(I.31)")

            l["Dt"] = s["CF"].l2.parallel(p["D"])
            p["G"] = EPoint(l["Dt"].intersect(s["CF"].l3), label=("G", DOWN))
            l["D"] = ELine("DG")
            p["H"] = EPoint(l["Dt"].intersect(l["BE"]), label=("H", UL))
            l["Dt"].e_remove()

        # ----------------------------------------------
        @self.push_step
        def c02_draw_parallel_to_AB():
            t1.explain("From point H, draw a line parallel to either AB or EF{nb}(I.31)")

            l["Ht"] = l["A"].parallel(p["H"])
            p["M"] = EPoint(l["Ht"].intersect(s["CF"].l0), label=("M", DR))
            p["L"] = EPoint(l["Ht"].intersect(s["CF"].l2), label=("L", DL))
            l["Ht"].extend(mn_scale(150))

        @self.push_step
        def c03_draw_parallel_to_CL():
            t1.explain("From point A, draw a line parallel to either "
                       "CL or BM{nb}(I.31)")

            l["Kt"] = s["CF"].l2.parallel(p["A"])
            p['K'] = EPoint(l['Kt'].intersect((l['Ht'])), label=('K', DOWN))

            self.wait(0.5, ignore_presenter_mode=True)
            with self.simultaneous():
                l['Kt'].e_remove()
                l['Ht'].e_remove()
                p['M'].add_label('M', RIGHT)

            self.wait(0.5, ignore_presenter_mode=True)
            with self.simultaneous():
                l['KL'] = ELine('KH')
                l['LM'] = ELine('HM')
                l['K'] = ELine('AK')
                l['y2'] = ELine('MF', label=('y', RIGHT))
                l['xy2'] = ELine('BM', label=('x-y', RIGHT, dict(buff=0.3)))

        # ----------------------------------------------
        # Proof
        # ----------------------------------------------
        @self.push_step
        def p00_sum_of_complements():
            nonlocal p
            with self.simultaneous():
                t1.e_remove()
            t1.next_to(t4, DOWN, aligned_edge=LEFT)
            t1.down()
            t1.title("Proof:")
            t1.explain("The complements CH and HF are equal{nb}(I.43), "
                       "and if we add the rectangle DM, "
                       "then the rectangles CM and DF are equal")

            s['CH'] = EPolygon('CLHD', skip_anim=True).e_fill(BLUE_E)
            s['HF'] = EPolygon('HGFM', skip_anim=True).e_fill(BLUE_E)
            s['DM'] = EPolygon('DHMB', skip_anim=True).e_fill(BLUE)

            l['BE'].e_fade()

            with self.simultaneous():
                t3.e_fade()
            t3.math(r'\square CH = \square HF\\ \therefore\  \square CM = \square DF')

        @self.push_step
        def p01_rectangles_are_eq():
            nonlocal p
            t1.explain("The rectangles CM and AL are equal{nb}(I.36)")
            s['AL'] = EPolygon('AKLC', skip_anim=True).e_fill(GREEN)
            with self.simultaneous():
                s['HF'].e_unfill()
                s['DM'].e_fill(BLUE_E)
                s['CH'].e_fill(BLUE_E)

            with self.simultaneous():
                t3.e_fade()
            t3.math(r'\square AL = \square CM')

        @self.push_step
        def p02_AL_and_DF_are_eq():
            t1.explain("which means that AL and DF are also equal")
            t3.e_append(-1, r"= \square DF")
            with self.simultaneous():
                l['D'].e_normal()
                l['LM'].e_fade()
                s['DM'].e_fill(BLUE_E)
                s['HF'].e_fill(BLUE_E)
                s['CH'].e_unfill()

        @self.push_step
        def p03_AH_eq_gnomom():
            nonlocal l, p
            t1.explain("Let CH be added to each of AL and DF. "
                       "Now AH is equal to gnomon NOP")
            a['NOP'] = EAngle('LHG', size=mn_scale(60), label=(list('ONP'),), gnomon=True)
            s['CH'].e_fill(TEAL)
            t3.math(r'\square AH = NOP')

        @self.push_step
        def p04_see_b2p4():
            nonlocal l, p
            t1.explain("For a proof showing that DM and LG are squares, see II.4 ")
            with self.simultaneous():
                t3.e_fade()
            t3.math(r'DH = DB\ ,\ \square LG = \square CD')

        @self.push_step
        def p05_AH_eq_rect_ADDH_and_ADBD():
            nonlocal l, p
            t1.explainM("AH is equal to the rectangle formed by $AD,DH$, "
                        r"and also by $AD,DB$, therefore $AD \cdot DB$ "
                        "is equal to the gnomon $NOP$")
            with self.simultaneous():
                t3.e_fade()
                t3.e_normal(-1, -2)
            t3.math(r'\square AH = AD \cdot DB = NOP')

        @self.push_step
        def p06_LG_eq_CD_add_to_both():
            nonlocal l, p
            t1.explain("LG is equal to the square on CD, add it "
                       "to both AH and NOP, retaining the equality")

            s['LG'] = EPolygon('LEGH', skip_anim=True).e_fill(PINK)

            with self.simultaneous():
                t3.e_fade()
                t3.e_normal(-2)
            t3.math(r"AD \cdot DB + CD \cdot CD = NOP + \square LG")

        @self.push_step
        def p06_but_CF_eq_CB_eq_NOP():
            nonlocal l, p
            t1.explain("But CF is equal to the square on CB, which is also equal "
                       "to the gnomon NOP added to the rectangle LG, "
                       "we have demonstrated the proof for this postulate")

            with self.simultaneous():
                t3.e_fade()
                t3.e_normal(-1)
            t3.math(r"AD \cdot DB + CD \cdot CD = CB \cdot CB")

        @self.push_step
        def p06_QED():
            with self.simultaneous():
                t3.e_fade()
                t3.e_normal(-1)
