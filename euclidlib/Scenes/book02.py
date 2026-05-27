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


class Book2Scene(BookScene):

    def title_page(self):
        title_box = TextBox(mn_scale(0, 100, 0),
                            line_width=mn_scale(600),
                            alignment='e'
                            )
        with self.simultaneous():
            super().title_page()

            title_box.fancy("It is a remarkable fact in the history of geometry, "
                            "that the Elements of Euclid, "
                            "written two thousand years ago, are still regarded by many as the best "
                            "introduction to the mathematical sciences.", font_size=24, write_simultaneous=True)
            title_box.explain("""
            - Florian Cajori,
              A History of Mathematics (1893)
            """, font_size=18)

            title_box[-1].align_to(title_box[-2], mn.RIGHT)

            title_box.down()
            title_box.down()
            title_box.down()
            title_box.explain('<b>Definitions:</b>')
            title_box.explain("Any rectangular parallelogram is said to "
                              "be contained by the two straight "
                              "lines containing the right angle.")
            title_box.explain("And in any parallelogrammic area let any one whatever of "
                              "the parallelograms about its diameter with the two complements "
                              "be called a gnomon.")

        # --------------------------------------------------------------------------------------------------------
        # square a polygon
        # --------------------------------------------------------------------------------------------------------
        square_box = TextBox(mn_coord(350,300))
        square_box.math(r'A=CB\cdot CD = (EH)^2')
        A = (mn_coord(150, 200), mn_coord(300, 225), mn_coord(250, 350), mn_coord(90, 275))
        K = mn_coord(100, 450)
        sA = EPolygon(*A, label='A', fill=PALE_PINK)
        pK = EPoint(K)
        sR = sA.copy_to_rectangle(pK)
        sR.add_point_labels(*"BEDC")
        sR.e_fill(PINK)
        pB,pE,pD,pC,*rest = sR.p
        pE.add_label("E",mn.UR)
        lBFt = sR.l[0].vcopy()
        lBFt.extend(mn_scale(100))
        cE = ECircle(sR.p[1], sR.p[2]).e_fade()
        pF = EPoint(cE.intersect(lBFt)[0],label=["F",mn.UR])
        lBF = ELine(pB,pF)
        pG = lBF.bisect().add_label("G",mn.UL)
        cG = ECircle(pG, pF).e_fade()
        lH1t = sR.l[1].vcopy().prepend(mn_scale(200))
        pH = EPoint(cG.intersect(lH1t)[0]).add_label("H", mn.DOWN)
        lH = ELine(pE, pH)
        lG = ELine(pG, pH)
        sEH = ESquare(lH.end, lH.start, fill=Colour.add(PINK, PALE_PINK))

        with self.simultaneous():
            # --------------------------------------------------------------------------------------------------------
            # definition
            # --------------------------------------------------------------------------------------------------------
            para = EPolygon(
                mn_coord(450, 700),
                mn_coord(600, 700),
                mn_coord(650, 600),
                mn_coord(500, 600))
            gnomon = EPolygon(
                mn_coord(450, 700),
                mn_coord(600, 700),
                mn_coord(617, 667),
                mn_coord(517, 667),
                mn_coord(550, 600),
                mn_coord(500, 600),
            )
            gnomon.e_fill(mn.BLUE)

            diag = ELine(mn_coord(450, 700), mn_coord(650, 600))
            l1 = ELine(mn_coord(500, 700), mn_coord(550, 600))
            cross = l1.intersect(diag)[0]
            p = EPoint(cross)
            l2 = para.l0.parallel(p)
            l3 = ELine(
                l2.intersect_line(para.l3)[0],
                l2.intersect_line(para.l1)[0],
            )
            ar1 = ELine(mn_coord(650, 660),
                        mn_coord(690, 660))
            ar2 = ELine(mn_coord(650, 660),
                        mn_coord(660, 650))
            ar3 = ELine(mn_coord(650, 660),
                        mn_coord(660, 670))

        l2.e_remove()
        """
        """

    def next_page_func(self):
        self.next_page()
        self.clear()

    def draw_table_of_contents(self, index=0):
        toc = TOC2("Table of Contents - Book 2", y_padding=0.35, next_page_func=self.next_page_func)
        self.animateState.append(AnimState.SKIP)
        toc.draw(self.prop)
        self.animateState.pop()


class TOC2(TOC):
    def __init__(self,title,book='II', **kwargs):
        super().__init__(title,book, **kwargs)

        self.add_entry(TOCEntry(1, r'$a\, (x+y+z) = ax + ay + az$', self.prop01))
        self.add_entry(TOCEntry(2, r"$(x+y)^2 = x\, (x+y) + y\, (x+y)$", self.prop02_03_04))
        self.add_entry(TOCEntry(3, r'$y\, (x+y) = yx + y^2$', self.prop02_03_04))
        self.add_entry(TOCEntry(4, r'$(x+y)^2 = x^2 + y^2 + 2xy$', self.prop02_03_04))
        self.add_entry(TOCEntry(5, r'$(x+y)(x-y) + y^2 = x^2$', self.prop05_09))
        self.add_entry(TOCEntry(6, r'$y\, (2x+y) + x^2 = (x+y)^2$', self.prop06_10))
        self.add_entry(TOCEntry(7, r'$(x+y)^2 + y^2 = x^2 + 2y\, (x+y)$', self.prop02_03_04))
        self.add_entry(TOCEntry(8, r'$(x+2y)^2 = 4y\, (x+y) + x^2$', self.prop02_03_04))
        self.add_entry(TOCEntry(9, r'$(x+y)^2 + (x-y)^2 = 2\,(x^2 + y^2)$', self.prop05_09))
        self.add_entry(TOCEntry(10, r'$(2x+y)^2 + y^2 = 2\,(\,x^2 + (x+y)^2\,)$', self.prop06_10))
        self.add_entry(TOCEntry(11, r'Find H such that: $\quad  y\,(x+y) = x^2$', self.prop_11))
        self.add_entry(TOCEntry(12, r'Cosine Law, $a^2 = b^2 + c^2 - 2bc\cos\theta$', self.prop_12))
        self.add_entry(TOCEntry(13, r'Cosine Law. $a^2 = b^2 + c^2 - 2bc\cos\theta$', self.prop_13))
        self.add_entry(TOCEntry(14, r'Construct a square equal to the polygon', self.prop_14))

    @staticmethod
    def prop01(xpos, ypos)->mn.VGroup:
        group = E_VGroup(
            EPoint((xpos + 0.8, ypos + 0.3)),
            EPoint((xpos + 0.8, ypos )),
            EPoint((xpos + 1.8, ypos )),
            EPoint((xpos + 2.5, ypos )),
            EPoint((xpos + 3.0, ypos )),
            ELine((xpos + 0.8, ypos + 0.3), (xpos + 2.0, ypos + 0.3), label=['a', dict(side=LineLabelSide.INSIDE)]),
            ELine((xpos + 0.8, ypos), (xpos + 1.8, ypos), label=['x', dict(side=LineLabelSide.INSIDE)]),
            ELine((xpos + 1.8, ypos), (xpos + 2.5, ypos), label=['y', dict(side=LineLabelSide.INSIDE)]),
            ELine((xpos + 2.5, ypos), (xpos + 3.0, ypos), label=['z', dict(side=LineLabelSide.INSIDE)]),
        )
        return group

    @staticmethod
    def prop02_03_04(xpos,ypos)->mn.VGroup:
        group = E_VGroup(
            EPoint( (xpos + 0.8, ypos) ),
            EPoint( (xpos + 2.3, ypos) ),
            EPoint( (xpos + 3.0, ypos) ),
            ELine((xpos + 0.8, ypos), (xpos + 2.3, ypos), label=['x', dict(side=LineLabelSide.INSIDE)]),
            ELine((xpos + 2.3, ypos), (xpos + 3.0, ypos), label=['y', dict(side=LineLabelSide.INSIDE)]),
        )
        return group

    @staticmethod
    def prop05_09(xpos,ypos)->mn.VGroup:
        m = (3.0-0.8)/2 + 0.8
        group = E_VGroup(
            EPoint( (xpos + 0.8,   ypos) ),
            EPoint( (xpos + m,     ypos) ),
            EPoint( (xpos + m+0.5, ypos) ),
            EPoint( (xpos + 3.0,   ypos) ),
            ELine ( (xpos + 0.8,   ypos), (xpos + m, ypos),       label=['x', dict(side=LineLabelSide.INSIDE)]),
            ELine(  (xpos + m,     ypos), (xpos + m + 0.5, ypos), label=['y', dict(side=LineLabelSide.INSIDE)]),
            ELine(  (xpos + m+0.5, ypos), (xpos + 3.0,     ypos), label=['x-y', dict(side=LineLabelSide.INSIDE)]),
        )
        return group

    @staticmethod
    def prop06_10(xpos,ypos)->mn.VGroup:
        m = (3.0-0.8)/2 + 0.8
        group = E_VGroup(
            EPoint( (xpos + 0.8,   ypos) ),
            EPoint( (xpos + m,     ypos) ),
            EPoint( (xpos + 3.0,   ypos) ),
            EPoint( (xpos + 3.4,   ypos) ),
            ELine(  (xpos + 0.8,   ypos), (xpos + m,     ypos), label=['x', dict(side=LineLabelSide.INSIDE)]),
            ELine(  (xpos + m,     ypos), (xpos + 3.0,   ypos), label=['x', dict(side=LineLabelSide.INSIDE)]),
            ELine(  (xpos + 3.0,   ypos), (xpos + 3.4,   ypos), label=['y', dict(side=LineLabelSide.INSIDE)]),

        )
        return group

    @staticmethod
    def prop_11(xpos,ypos)->mn.VGroup:
        group = E_VGroup(
            EPoint((xpos + 0.8, ypos)),
            EPoint((xpos + 3.0, ypos)),
            EPoint((xpos + 2.2, ypos)).add_label("H?", mn.UP),

            ELine((xpos + 0.8, ypos), (xpos + 2.2, ypos), label=['x', dict(side=LineLabelSide.INSIDE)]),
            ELine((xpos + 2.2, ypos), (xpos + 3.0, ypos), label=['y', dict(side=LineLabelSide.INSIDE)]),
        )
        return group

    @staticmethod
    def prop_12(xpos,ypos)->mn.VGroup:
        group = E_VGroup(
            ETriangle( (xpos + 1.0, ypos + 0.0), # A
                       (xpos + 3.0, ypos + 0.0), # C
                       (xpos + 0.4, ypos + 1), # B
                       labels=['b', 'a', 'c'],
                       fill=mn.BLUE,
                       ),
            EAngle(VirtualLine((xpos + 1.0, ypos + 0.0),(xpos + 3.0, ypos + 0.0)),
                   VirtualLine((xpos + 1.0, ypos + 0.0), (xpos + 0.4, ypos + 1)),
                   label=r"\theta", size=.5*ANGLE_SIZE),
         )


        return group

    @staticmethod
    def prop_13(xpos,ypos)->mn.VGroup:
        group = E_VGroup(
            ETriangle( (xpos + 1.8, ypos + 0.8), # A
                       (xpos + 0.4, ypos + 0.0), # B
                       (xpos + 3.0, ypos + 0.0), # C
                       labels=("c", "b", "a"),
                       fill=mn.BLUE,
                       ),
            EAngle(VirtualLine((xpos + 1.8, ypos + 0.8), (xpos + 0.4, ypos + 0.0)),
                   VirtualLine((xpos + 3.0, ypos + 0.0), (xpos + 0.4, ypos + 0.0)),
                   label=r"\theta", size=.5 * ANGLE_SIZE),
        )
        return group

    @staticmethod
    def prop_14(xpos,ypos)->mn.VGroup:
        group = E_VGroup(
            EPolygon(  (xpos + 0.4, ypos - 0.8),
                       (xpos + 2.5, ypos - 0.8),
                       (xpos + 2.8, ypos - 0.4),
                       (xpos + 1.8, ypos - 0.0),
                       fill=mn.BLUE,
                       ),
        )
        return group

