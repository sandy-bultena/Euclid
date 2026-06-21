# =====================================================================================================================
# Book 2
# =====================================================================================================================
from euclidlib.Scenes.BookScene import BookScene
from euclidlib.Scenes.table_of_contents import TOC, TOCEntry
from euclidlib.Objects import *
from euclidlib.CONSTANTS import *
from euclidlib.Scenes.animate_state import AnimState
from euclidlib.Utilities.coordinate_utilities import *
from euclidlib.Utilities.Colour import *


class Book8Scene(BookScene):

    def title_page(self):
        title_box = TextBox(mn_scale(0, 100, 0),
                            line_width=mn_scale(600),
                            alignment='e'
                            )
        with self.simultaneous():
            super().title_page()

            title_box.fancy("There is no excellent beauty that hath not "
                            "some strangeness in the proportion.", font_size=24, write_simultaneous=True)
            title_box.explain("""
            - Francis Bacon, """, font_size=18)

            title_box[-1].align_to(title_box[-2], mn.RIGHT)

        # --------------------------------------------------------------------------------------------------------
        # Picture
        # --------------------------------------------------------------------------------------------------------
        with self.skip_animations_for():
            p1 = mn_coord(150, 650)
            p2 = mn_coord(550, 250)
            r = ERectangle(p1, p2, fill=SKY_BLUE).e_remove_points()
            for i in range(8):
                pt = 0.5 * (p1 + p2)
                ERectangle(p1, pt, fill=YELLOW).e_remove_points()
                ELine([pt[0], p1[1], 0], [pt[0], p2[1], 0])
                ELine([p1[0], pt[1], 0], [p2[0], pt[1], 0])
                p1 = pt

    def next_page_func(self):
        self.wait(5)
        self.clear()

    def draw_table_of_contents(self, index=0):
        toc = TOC8("Table of Contents - Book 8", y_padding=0.35, next_page_func=self.next_page_func)
        self.animateState.append(AnimState.SKIP)
        toc.draw(self.prop)
        self.animateState.pop()


class TOC8(TOC):

    def __init__(self, title, book='II', **kwargs):
        super().__init__(title, book, x_padding=0.5, column_padding=1, **kwargs)

        self.add_entry(TOCEntry(1,
                                r"If $A\ratio B = B\ratio C = C\ratio D \, ...\, X\ratio Z$, and $A,Z$ are relatively prime, then "
                                r"these are the least numbers with the ratio $A\ratio B$"))
        self.add_entry(TOCEntry(2, r"Given a ratio of $A\ratio B$, create a list of the least $N$ numbers such that "
                                   r"$X_1\ratio X_2 = X_2\ratio X_3 = \, ...\, = X_{n-1}\ratio X_n = A\ratio B$"))
        self.add_entry(
            TOCEntry(3, r"If $A\ratio B = B\ratio C = C\ratio D \,...\, X\ratio Z$, and these are the least numbers "
                        r"with the ratio $A\ratio B$, then $A,Z$ are relatively prime"))
        self.add_entry(TOCEntry(4,
                                r"Given $A_1\ratio A_2,\, B_1\ratio B_2,\, C_1\ratio C_2 \, ...$, where each ratio is the least, "
                                r"find the least numbers in  continued proportion such that $X_1\ratio X_2 = A_1\ratio A_2,\, X_2\ratio X_3 = B_1\ratio B_2,\, "
                                r"X_3\ratio X_4 = C_1\ratio C_2$, etc"))
        self.add_entry(TOCEntry(5, r"If $A= C D$ and $B = E F$, then $A\ratio B = C D\ratio E F$"))
        self.add_entry(
            TOCEntry(6, r"If $S_1,\, S_2,\, S_3\, ...\, S_n$ is a series of numbers in continuous proportion "
                        r"where $S_2 > S_1$, and $S_2 \neq p S_1$, then "
                        r"$S_j \neq q S_i$ for any integer $i,j$"))
        self.add_entry(
            TOCEntry(7, r"If $S_1,\, S_2,\, S_3\, ...\, S_n$ is a series of numbers in continuous proportion "
                        r"where $S_2 > S_1$, and $S_n = p S_1$, then "
                        r"$S_2 = q S_1$"))
        self.add_entry(TOCEntry(8, r"If $A\ratio B = C\ratio D$, then the length of the proportional series "
                                   r"$A,\,S_1,\,S_2,\, ...,\, "
                                   r"S_n,\, B$, will be equal to length of the proportional series "
                                   r"$C,\,T_1,\,T_2,\, ...,\, T_n,\,D$"))
        self.add_entry(TOCEntry(9, r"Prove that there are as many "
                                   r"proportional numbers between $1$ and $p^{n-1}$ as there proportional "
                                   r"numbers between $p^{n-1}$ and $q^{n-1}$"))
        self.add_entry(TOCEntry(10, r"If there are two series of equal length, of type $1,\,... ,\, p^{n-1}$ and "
                                    r"$1,\, ...\,  q^{n-1}$, then there will exist another series of equal length of "
                                    r"the form $p^{n-1},\, ... ,\, q^{n-1}$"))
        self.add_entry(TOCEntry(11, r"If $A = C^2$ and $B = D^2$, then there exists "
                                    r"one number $E$ such that $A\ratio E = E\ratio B$, and $A\ratio B$ is the "
                                    r"duplicate ratio of $C\ratio D$"))
        self.add_entry(TOCEntry(12, r"If $A = C^3$ and $B = D^3$, then "
                                    r"there exists two numbers $H$ and $K$ "
                                    r"such that $A\ratio H = H\ratio K = K\ratio B$, "
                                    r"and $A\ratio B$ is the triplicate ratio of $C\ratio D$"))
        self.add_entry(TOCEntry(13, r"If $A\ratio B = B\ratio C$ then $A^2\ratio B^2 = B^2\ratio C^2$, and "
                                    r"$A^3\ratio B^3 = B^3\ratio C^3$"))
        self.add_entry(TOCEntry(14, r"If $A = C^2$, $B = D^2$ and if $B "
                                    r"= iA$, then $D = jC$, and vice versa"))
        self.add_entry(TOCEntry(15, r"If $A = C^3,\, B = D^3$ and if $B "
                                    r"= iA$, then $D = jC$, and vice versa"))
        self.add_entry(TOCEntry(16, r"If $A = C^2,\, B = D^2$ and if $B "
                                    r"\neq iA$, then $D \neq jC$, "
                                    r"and vice versa"))
        self.add_entry(TOCEntry(17, r"If $A = C^3,\, B = D^3$ and if $B "
                                    r"\neq iA$, then $D \neq jC$, "
                                    r"and vice versa"))
        self.add_entry(TOCEntry(18, r"If $A,B$ are similar plane numbers, and $A = CD,\, "
                                    r"B = EF$ and $C\ratio D=E\ratio F$, then $A\ratio B$ is the duplicate "
                                    r"ratio of $C\ratio E$ and $D\ratio F$, and there is one mean number "
                                    r"between $A$ and $B$"))
        self.add_entry(TOCEntry(19, r"If $A,B$ are similar solid numbers and $A = CDE$, "
                                    r"$B = FGH$ and $C\ratio D=F\ratio G$ and $D\ratio E=G\ratio H$, then $A\ratio B$ is the triplicate "
                                    r"ratio of $C\ratio F,\, D\ratio G,\, E\ratio H$, and there are two mean numbers between $A$ and $B$"))
        self.add_entry(TOCEntry(20, r"If $A\ratio C = C\ratio B$, then $A$ and $B$ are similar plane "
                                    r"numbers, $A = ij$, $B = pq$ and $i\ratio p = j\ratio q$"))
        self.add_entry(TOCEntry(21, r"If $A\ratio C = C\ratio D = D\ratio B$, then $A$ and $B$ are similar solid "
                                    r"numbers, $A = ijk$, "
                                    r"$B = pqr$ and $i\ratio p = j\ratio q = r\ratio k$"))
        self.add_entry(TOCEntry(22, r"If $A,B,C$ are in continued proportion, and $A$ is square, then $C$ is also square"))
        self.add_entry(TOCEntry(23, r"If $A,B,C,D$ are in continued proportion, and $A$ is cube, then $D$ is also cube"))
        self.add_entry(TOCEntry(24, r"If $A\ratio B = C\ratio D$, and $C,D$ and $A$ are square, then $B$ is also square"))

        self.add_entry(TOCEntry(25, r"If $A\ratio B = C\ratio D$, and $C,D$ and $A$ are cube, then $B$ is also cube"))
        self.add_entry(TOCEntry(26, r"If $A$ and $B$ are similar plane numbers, then the ratio of $A\ratio B$ can "
                                    r"be expressed as a ratio of two square numbers"))
        self.add_entry(TOCEntry(27, r"If $A$ and $B$ are similar solid numbers, then the ratio of $A\ratio B$ can "
                                    r"be expressed as a ratio of two cube numbers"))
