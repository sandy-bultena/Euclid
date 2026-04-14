# =====================================================================================================================
# Book 1
# =====================================================================================================================
from euclidlib.Scenes.BookScene import BookScene
from euclidlib.Scenes.animate_state import AnimState
from euclidlib.Scenes.table_of_contents import TOC, TOCEntry
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

    def next_page_func(self):
        self.next_page()
        self.clear()

    def draw_table_of_contents(self, index=0):
        toc = TOC1("Table of Contents - Book 1", next_page_func=self.next_page_func)
        self.animateState.append(AnimState.SKIP)
        toc.draw(self.prop)
        self.animateState.pop()


class TOC1(TOC):
    def __init__(self,title,book='I', **kwargs):
        super().__init__(title,book, **kwargs)
        self.add_entry(TOCEntry(1, r"Construct an equilateral triangle"))
        self.add_entry(TOCEntry(2, r'Copy a line'))
        self.add_entry(TOCEntry(3, r'Subtract one line from another'))
        self.add_entry(TOCEntry(4, r'Triangles are equal if same side-angle-side'))
        self.add_entry(TOCEntry(5, r'Isosceles triangle have equal base angles'))
        self.add_entry(TOCEntry(6, r'Equal base angles gives isosceles triangle'))
        self.add_entry(TOCEntry(7, r'Two sides of triangle meet at unique point'))
        self.add_entry(TOCEntry(8, r'Triangles are equal if same side-side-side'))
        self.add_entry(TOCEntry(9, r'Bisect an angle',) )
        self.add_entry(TOCEntry(10, r'Bisect a line'))
        self.add_entry(TOCEntry(11, r'Construct right angle from point on line'))
        self.add_entry(TOCEntry(12, r'Construct perpendicular line from point not on line'))
        self.add_entry(TOCEntry(13, r'Sum of angles on straight line = 180'))
        self.add_entry(TOCEntry(14, r'Two lines form a single line if angle = 180'))
        self.add_entry(TOCEntry(15, r'Vertical angles equal one another'))
        self.add_entry(TOCEntry(16, r'Exterior angle larger than interior angle'))
        self.add_entry(TOCEntry(17, r'Sum of two interior angles less than 180'))
        self.add_entry(TOCEntry(18, r'Greater side opposite of greater angle'))
        self.add_entry(TOCEntry(19, r'Greater angle opposite of greater side'))
        self.add_entry(TOCEntry(20, r'Sum of two sides greater than third'))
        self.add_entry(TOCEntry(21, r'Triangle within triangle has smaller sides'))
        self.add_entry(TOCEntry(22, r'Construct triangle from given lines'))
        self.add_entry(TOCEntry(23, r'Copy an angle'))
        self.add_entry(TOCEntry(24, r'Larger angle gives larger base'))
        self.add_entry(TOCEntry(25, r'Larger base gives larger angle'))
        self.add_entry(TOCEntry(26, r'Triangles are equal if same angle-side-angle'))
        self.add_entry(TOCEntry(27, r'If alternate angles are equal then lines parallel'))
        self.add_entry(TOCEntry(28, r'If sum of interior angles = 180 then lines parallel'))
        self.add_entry(TOCEntry(29, r'Lines parallel, alternate angles are equal'))
        self.add_entry(TOCEntry(30, r'Lines parallel to same line are parallel to themselves'))
        self.add_entry(TOCEntry(31, r'Construct one line parallel to another'))
        self.add_entry(TOCEntry(32, r'Sum of interior angles of a triangle = 180'))
        self.add_entry(TOCEntry(33, r'Lines joining ends of equal parallels are parallel'))
        self.add_entry(TOCEntry(34, r'Opposite sides-angles equal in parallelogram'))
        self.add_entry(TOCEntry(35, r'Parallelograms, same base-height have equal area'))
        self.add_entry(TOCEntry(36, r'Parallelograms, equal base-height have equal area'))
        self.add_entry(TOCEntry(37, r'Triangles, same base-height have equal area'))
        self.add_entry(TOCEntry(38, r'Triangles, equal base-height have equal area'))
        self.add_entry(TOCEntry(39, r'Equal triangles on same base, have equal height'))
        self.add_entry(TOCEntry(40, r'Equal triangles on equal base, have equal height'))
        self.add_entry(TOCEntry(41, r'Triangle is half parallelogram with same base / height'))
        self.add_entry(TOCEntry(42, r'Construct parallelogram with equal area as triangle'))
        self.add_entry(TOCEntry(43, r'Parallelogram complements are equal'))
        self.add_entry(TOCEntry(44, r'Construct parallelogram on line, equal to triangle'))
        self.add_entry(TOCEntry(45, r'Construct parallelogram equal to polygon'))
        self.add_entry(TOCEntry(46, r'Construct a square', ))
        self.add_entry(TOCEntry(47, r"Pythagoras' theorem"))
        self.add_entry(TOCEntry(48, r"Inverse Pythagoras' theorem"))


