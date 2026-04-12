# =====================================================================================================================
# Book 1
# =====================================================================================================================
from euclidlib.Scenes.BookScene import BookScene
from euclidlib.Objects import *
from euclidlib.CONSTANTS import *


class Book1Scene(BookScene):

    # -----------------------------------------------------------------------------------------------------------------
    # title page for Book 1
    # -----------------------------------------------------------------------------------------------------------------
    def title_page(self):
        xc = 0
        yc = mn_scale(100)
        quote_box = TextBox([xc,yc,0],
                            line_width=mn_scale(550),
                            alignment='e'
                            )

        with self.simultaneous():
            super().title_page()
            quote_box.fancy("If Euclid did not kindle your youthful enthusiasm, "
                            "you were not born to be a scientific thinker.", font_size=24, write_simultaneous=True)
            quote_box.explain("-Albert Einstein", font_size=18)

            top = 400
            bot = top + 100
            A_base = np.array([250, top, 0])
            B_base = np.array([175, bot, 0])

            slope = -1 * (B_base[0] - A_base[0]) / (bot - top)
            b = A_base[1] - slope * A_base[0]
            C_base = np.array([(1 / slope) * (bot - b), bot, 0])

            A = mn_coord(*A_base)
            B = mn_coord(*B_base)
            C = mn_coord(*C_base)

            tABC = ETriangle(A,B,C, point_labels=['A','B','C'])

            sB = ESquare(A, B).e_fill(mn.BLUE)
            sA = ESquare(C, A).e_fill(mn.GREEN)
            sC = ESquare(B, C)
            l0 = ELine(A, sC.p0)
            l1 = ELine(sB.p3, C)
            l2 = ELine(B, sA.p0)
            l3 =  ELine(A, sC.p3)
            with self.pause_animations_for():
                lAlx = sC.l2.parallel(tABC.p0)
            p = lAlx.intersect_line(sC.l3)
            pL = EPoint(lAlx.intersect_line(sC.l3)[0], label=('L', mn.DOWN))
            sBDL = EParallelogram(C, sC.p3, pL).e_fill(mn.GREEN)
            sCEL = EParallelogram(B, sC.p0, pL).e_fill(mn.BLUE)

        with self.simultaneous():
            sABD = ETriangle.assemble(lines=[tABC.l0, sC.l0 , l0]).e_fill(mn.BLUE)
            sFBC = ETriangle.assemble(lines=[sB.l2, tABC.l1, l1]).e_fill(mn.BLUE)
            sBCK = ETriangle.assemble(lines=[tABC.l1, sA.l0, l2]).e_fill(mn.GREEN)
            sECA = ETriangle.assemble(lines=[sC.l2, tABC.l2, l3]).e_fill(mn.GREEN)


