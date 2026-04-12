"""
BookScene contains the table of contents and first image for a specific book

inherits from PropScene

"""
import re
from dataclasses import dataclass
from itertools import pairwise

from euclidlib.Objects import *
from euclidlib.CONSTANTS import *
from euclidlib.Scenes.animate_state import AnimState
from euclidlib.Utilities import Colour


from euclidlib.Scenes.PropScene import PropScene
import roman

DEG = mn.PI/180

@dataclass
class TOCEntry:
    prop_num: int
    text:str
    diagram: Callable[[float,float],mn.VGroup]    # returns height of all new objects

class TOC:
    def __init__(self, title="", book=""):
        self.title = title
        self.book = book
        self.entries:list[TOCEntry] = []
    def add_entry(self, entry:TOCEntry):
        self.entries.append(entry)
    def get_entries(self):
        return self.entries


class AttrDict[K, T](dict[K, T]):
    __slots__ = ()
    __getattr__ = dict[K, T].__getitem__
    __setattr__ = dict[K, T].__setitem__


class BookScene(PropScene):
    book: int
    prop: int

    def __init__(self, *args, **kwargs):
        cls = type(self)
        self.l: dict[str | int, ELine] = {}
        self.p: dict[str | int, EPoint] = {}
        self.c: dict[str | int, ECircle] = {}
        self.t: dict[str | int, ETriangle] = {}
        self.a: dict[str | int, EAngleBase] = {}
        cls.book, cls.prop = cls.get_prop_number()
        super().__init__(*args, **kwargs)


    # -----------------------------------------------------------------------------------------------------------------
    # get objects from object names
    # -----------------------------------------------------------------------------------------------------------------
    def points(self, name:str):
        pts = []
        for c in name:
            if c not in self.p:
                raise IndexError(f"{name=} p[{c}] does not exists")
            pts.append(self.p[c])
        return [self.p.get(a,None) for a in name if a in self.p]

    def lines(self, name: str, num=None):
        lines = []
        if num is None:
            num = len(name)
        for c1,c2 in pairwise(name):
            if f"{c1}{c2}" not in self.l and f"{c2}{c1}" not in self.l:
                raise IndexError(f"neither l[{c1}{c2}] nor l[{c2}{c1}] exists")
            if f"{c1}{c2}" in self.l:
                lines.append(self.l[f"{c1}{c2}"])
            else:
                lines.append(self.l[f"{c2}{c1}"])
        return lines[:num]

    # -----------------------------------------------------------------------------------------------------------------
    # title page
    # -----------------------------------------------------------------------------------------------------------------
    def title_page(self):
        t = TextBox((0, mn_scale(350), 0),
                    buff_size=mn.MED_LARGE_BUFF,
                    alignment='n'
                    )

        t.title_screen("Euclid's Elements", write_simultaneous=True)
        t.title(f"Book {roman.toRoman(self.book)}", write_simultaneous=True)

    # -----------------------------------------------------------------------------------------------------------------
    # table of contents
    # -----------------------------------------------------------------------------------------------------------------
    def get_toc(self) -> TOC:
        return TOC()

    def table_of_contents(self, index=0):
        y_padding = 0.5
        x_padding = 0.6
        toc = self.get_toc()

        # define columns (3 columns)
        col_width = M_FRAME_WIDTH / 3
        cols = [M_LEFT_BORDER, M_LEFT_BORDER + col_width, M_LEFT_BORDER + 2 * col_width]

        # write the title
        tb_title = TextBox(mn_coord(500, 40, 0))
        tb_title.title(toc.title)

        # starting ypos and xpos
        ypos = tb_title.get_bottom()[1] - y_padding
        xpos = cols.pop(0)

        # foreach proposition, and toc entry, place in scene
        for prop, entry in enumerate(toc.get_entries(), start=1):

            # make it faster by not animating the output
            self.animateState.append(AnimState.SKIP)

            # write the proposition number
            tb1 = TextBox([xpos + 0.1, ypos, 0])
            tb1.math(f"{entry.prop_num}.")

            # draw any required diagram
            g = entry.diagram(xpos, ypos)

            # write any required text
            tb2 = TextBox([xpos + y_padding, ypos, 0], line_width=col_width)
            if isinstance(entry.text, str):
                tb2.math(entry.text, font_size=18)
            else:
                for t in entry.text:
                    tb2.math(t, font_size=18)

            # if we are at the bottom of the column, define the new location in the next column
            if ypos - y_padding - g.get_height() - tb2.get_height() < M_BOTTOM_BORDER + y_padding:
                xpos = cols.pop(0)
                ypos = tb_title.get_bottom()[1] - y_padding

            # move the textboxes and the diagrams to the required location
            tb1.move_to([xpos + 0.1, ypos, 0], aligned_edge=UL)
            g.move_to([xpos + x_padding, ypos, 0], aligned_edge=UL)
            tb2.move_to([xpos + x_padding, ypos - y_padding / 4 - g.get_height(), 0], aligned_edge=UL)

            # if this toc is for prop 'index', outline the entry so indicate
            if prop == index:
                total_height = mn.VGroup(tb1, g, tb2).get_height() + y_padding
                width = col_width - x_padding
                r = EPolygon((0, 0),(width,0),(width,total_height),(0,total_height), fill=TOC_HIGHLIGHT_BG)

                # make the rectangle a little less cluttered
                [p.e_remove() for p in r.p]
                [l.grey() for l in r.l]
                r.e_move_to([xpos+x_padding/2, ypos + y_padding / 2, 0], aligned_edge=UL)()

            ypos = ypos - y_padding - g.get_height() - tb2.get_height()
            self.animateState.pop()

    # -----------------------------------------------------------------------------------------------------------------
    # reset
    #  - clears all the objects in the scene, and then  sets the title
    # -----------------------------------------------------------------------------------------------------------------
    def reset(self):
        self.clear()

        # print the title
        if self.title and self.prop:
            t = TextBox(mn_coord(700, 50),
                        line_width=mn_scale(1000),
                        alignment='n'
                        )
            t.title(f"Proposition {self.prop} of Book {self.book}")
            t.normal(self.title)

        # draw the grid
        line_options = dict(
            stroke_color=STROKE_COLOUR,
            stroke_width=0.5,
            stroke_opacity=BOOK_SCENE_GRID_OPACITY,
        )

        grid = mn.NumberPlane(
            background_line_style=line_options,
            axis_config=line_options,
            faded_line_style=line_options,
        )
        grid.fix_in_frame()
        self.play(mn.FadeIn(grid))

        t=TextBox(mn_coord(10,780))
        t.sidenote(COPYRIGHT)

    # -----------------------------------------------------------------------------------------------------------------
    # get proposition number from the file name (ie. Propposition_python/Book2/Prop05.py)
    # -----------------------------------------------------------------------------------------------------------------
    @classmethod
    def get_prop_number(cls):
        match = re.search(r"Book(\d+).Prop(\d+)", cls.__module__)
        if not match:
            return 0,0
        return int(match.group(1)), int(match.group(2))

    # -----------------------------------------------------------------------------------------------------------------
    # last page with credits etc
    # -----------------------------------------------------------------------------------------------------------------
    def last_page(self):
        tb = TextBox(mn_coord(300, 150))
        tb.fancy(COPYRIGHT, font_size=36)
        tb.bold(CODE_CC)
        tb.explain(GENERIC_CC)
        tb.down()
        tb.down()
        tb.title("Resources:")
        tb.bold(f"Youtube Videos: ")
        tb.sidenote(YOUTUBE_LINK, same_line=True)
        tb.bold(f"PDFs: ")
        tb.explain(f"{GITHUB_PDFS_LINK}", same_line=True)
        tb.down()
        tb.down()
        tb.title("Additional Credits")
        tb.bold("Source code to create videos:")
        tb.sidenote(f"© {EUCLID_LIB_AUTHOR} - {GITHUB_EUCLID_LINK}")
        tb.down()
        tb.down()
        tb.explain("This code could not have been created without the use of the manimgl libraries:")
        tb.sidenote(f"© {MANIMGL_AUTHOR} - {GITHUB_MANIMGL_LINK}")



# # =====================================================================================================================
# # Book 1
# # =====================================================================================================================
#
# class Book1Scene(BookScene):
#
#     # -----------------------------------------------------------------------------------------------------------------
#     # title page for Book 1
#     # -----------------------------------------------------------------------------------------------------------------
#     def title_page(self):
#         xc = 0
#         yc = mn_scale(100)
#         quote_box = TextBox([xc,yc,0],
#                             line_width=mn_scale(550),
#                             alignment='e'
#                             )
#
#         with self.simultaneous():
#             super().title_page()
#             quote_box.fancy("If Euclid did not kindle your youthful enthusiasm, "
#                             "you were not born to be a scientific thinker.", font_size=24, write_simultaneous=True)
#             quote_box.explain("-Albert Einstein", font_size=18)
#
#             top = 400
#             bot = top + 100
#             A_base = np.array([250, top, 0])
#             B_base = np.array([175, bot, 0])
#
#             slope = -1 * (B_base[0] - A_base[0]) / (bot - top)
#             b = A_base[1] - slope * A_base[0]
#             C_base = np.array([(1 / slope) * (bot - b), bot, 0])
#
#             A = mn_coord(*A_base)
#             B = mn_coord(*B_base)
#             C = mn_coord(*C_base)
#
#             tABC = ETriangle(A,B,C, point_labels=['A','B','C'])
#
#             sB = ESquare(A, B).e_fill(mn.BLUE)
#             sA = ESquare(C, A).e_fill(mn.GREEN)
#             sC = ESquare(B, C)
#             l0 = ELine(A, sC.p0)
#             l1 = ELine(sB.p3, C)
#             l2 = ELine(B, sA.p0)
#             l3 =  ELine(A, sC.p3)
#             with self.pause_animations_for():
#                 lAlx = sC.l2.parallel(tABC.p0)
#             p = lAlx.intersect_line(sC.l3)
#             pL = EPoint(lAlx.intersect_line(sC.l3)[0], label=('L', mn.DOWN))
#             sBDL = EParallelogram(C, sC.p3, pL).e_fill(mn.GREEN)
#             sCEL = EParallelogram(B, sC.p0, pL).e_fill(mn.BLUE)
#
#         with self.simultaneous():
#             sABD = ETriangle.assemble(lines=[tABC.l0, sC.l0 , l0]).e_fill(mn.BLUE)
#             sFBC = ETriangle.assemble(lines=[sB.l2, tABC.l1, l1]).e_fill(mn.BLUE)
#             sBCK = ETriangle.assemble(lines=[tABC.l1, sA.l0, l2]).e_fill(mn.GREEN)
#             sECA = ETriangle.assemble(lines=[sC.l2, tABC.l2, l3]).e_fill(mn.GREEN)
#
#
# # =====================================================================================================================
# # Book 2
# # =====================================================================================================================
# class Book2Scene(BookScene):
#     def title_page(self):
#         title_box = TextBox(mn_scale(0, 100, 0),
#                             line_width=mn_scale(600),
#                             alignment='e'
#                             )
#         with self.simultaneous():
#             super().title_page()
#
#             with self.pause_animations_for():
#                 title_box.fancy("It is a remarkable fact in the history of geometry, "
#                                 "that the Elements of Euclid, "
#                                 "written two thousand years ago, are still regarded by many as the best "
#                                 "introduction to the mathematical sciences.", font_size=24, write_simultaneous=True)
#                 title_box.explain("""
#                 - Florian Cajori,
#                   A History of Mathematics (1893)
#                 """, font_size=18)
#
#                 title_box[-1].align_to(title_box[-2], mn.RIGHT)
#
#                 title_box.down()
#                 title_box.explain('<b>Definitions:</b>')
#                 title_box.explain("Any rectangular parallelogram is said to "
#                                   "be contained by the two straight "
#                                   "lines containing the right angle.")
#                 title_box.explain("And in any parallelogrammic area let any one whatever of "
#                                   "the parallelograms about its diameter with the two complements "
#                                   "be called a gnomon.")
#
#                 para = EPolygon(
#                     mn_coord(450, 700),
#                     mn_coord(600, 700),
#                     mn_coord(650, 600),
#                     mn_coord(500, 600))
#                 gnomon = EPolygon(
#                     mn_coord(450, 700),
#                     mn_coord(600, 700),
#                     mn_coord(617, 667),
#                     mn_coord(517, 667),
#                     mn_coord(550, 600),
#                     mn_coord(500, 600),
#                 )
#                 gnomon.e_fill(mn.BLUE_D)
#
#                 diag = ELine(mn_coord(450, 700), mn_coord(650, 600))
#                 l1 = ELine(mn_coord(500, 700), mn_coord(550, 600))
#                 cross = l1.intersect(diag)[0]
#                 p = EPoint(cross)
#                 l2 = para.l0.parallel(p)
#                 l3 = ELine(
#                     l2.intersect_line(para.l3)[0],
#                     l2.intersect_line(para.l1)[0],
#                 )
#                 ar1 = ELine(mn_coord(650, 660),
#                             mn_coord(690, 660))
#                 ar2 = ELine(mn_coord(650, 660),
#                             mn_coord(660, 650))
#                 ar3 = ELine(mn_coord(650, 660),
#                             mn_coord(660, 670))
#
#             with self.staggered_animation():
#                 for x in title_box:
#                     x.e_draw()
#             with self.simultaneous():
#                 para.e_draw()
#                 gnomon.e_draw()
#                 diag.e_draw()
#                 l1.e_draw()
#                 l3.e_draw()
#                 ar1.e_draw()
#                 ar2.e_draw()
#                 ar3.e_draw()
#
#
# # =====================================================================================================================
# # Book 3
# # =====================================================================================================================
# class Book3Scene(BookScene):
#     def title_page(self):
#         title_box = TextBox(mn_scale(0, 100, 0),
#                             line_width=mn_scale(550),
#                             alignment='e'
#                             )
#         with self.simultaneous():
#             super().title_page()
#
#             with self.pause_animations_for() as draw:
#                 title_box.fancy("A circle is a round straight line with a hole in the middle.", font_size=24,
#                                 write_simultaneous=True)
#                 title_box.indent()
#                 title_box.explain("""
#                 - <b>Mark Twain</b>,
#                   quoting a schoolchild in "-English as She Is Taught-"
#                 """, font_size=16)
#
#                 title_box.unindent()
#                 title_box.down()
#                 title_box.down()
#                 title_box.down()
#                 title_box.down()
#                 title_box.fancy("If people stand in a circle long enough, "
#                                 "they'll eventually begin to dance.", font_size=24, write_simultaneous=True)
#                 title_box.indent()
#                 title_box.explain("""
#                 <b>George Carlin</b>, Napalm and Silly Putty (2001)
#                 """, font_size=16)
#                 #title_box[-1].align_to(title_box[-2], mn.RIGHT)
#                 draw.append(title_box)
#
#             c1 = mn_coord(260, 360)
#             r1 = mn_scale(180)
#             c2 = c1 + mn_scale(80, 0, 0)
#
#             with self.pause_animations_for() as draw:
#                 cA = ECircle(c1, c1 + r1 * mn.RIGHT)
#                 pE = EPoint(c1, label=('E', mn.DL))
#                 pF = EPoint(c2, label=('F', mn.DR))
#
#                 pA = cA.e_point_at_angle(mn.PI).add_label('A', away_from=c2)
#                 lFA = ELine(c2, pA)
#
#                 pD = cA.e_point_at_angle(0).add_label('D', away_from=c2)
#                 lFD = ELine(c2, pD)
#
#                 pB = cA.e_point_at_angle(140 * DEG).add_label('B', away_from=c2)
#                 lFB = ELine(c2, pB)
#
#                 pC = cA.e_point_at_angle(100 * DEG).add_label('C', away_from=c2)
#                 lFC = ELine(c2, pC)
#
#                 pG = cA.e_point_at_angle(mn.PI/4).add_label('G', away_from=c2)
#                 lFG = ELine(c2, pG)
#
#                 pH = cA.e_point_at_angle(-mn.PI/4).add_label('H', away_from=c2)
#                 lFH = ELine(c2, pH)
#
#                 draw.extend([cA, pE, pF, pA, lFA, pD, lFD, pB, lFB, pC, lFC, pG, lFG, pH, lFH])
#                 draw.append(ELine(pB, pE))
#                 draw.append(ELine(pC, pE))
#                 draw.append(ELine(pG, pE))
#                 draw.append(ELine(pH, pE))
#
#
#
