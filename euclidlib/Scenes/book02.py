# =====================================================================================================================
# Book 2
# =====================================================================================================================
from euclidlib.Scenes.BookScene import BookScene
from euclidlib.Scenes.table_of_contents import TOC, TOCEntry
from euclidlib.Objects import *
from euclidlib.CONSTANTS import *
from euclidlib.Scenes.animate_state import AnimState


class Book2Scene(BookScene):

    def title_page(self):
        title_box = TextBox(mn_scale(0, 100, 0),
                            line_width=mn_scale(600),
                            alignment='e'
                            )
        with self.simultaneous():
            super().title_page()

            with self.pause_animations_for():
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
                title_box.explain('<b>Definitions:</b>')
                title_box.explain("Any rectangular parallelogram is said to "
                                  "be contained by the two straight "
                                  "lines containing the right angle.")
                title_box.explain("And in any parallelogrammic area let any one whatever of "
                                  "the parallelograms about its diameter with the two complements "
                                  "be called a gnomon.")

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
                gnomon.e_fill(mn.BLUE_D)

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

            with self.staggered_animation():
                for x in title_box:
                    x.e_draw()
            with self.simultaneous():
                para.e_draw()
                gnomon.e_draw()
                diag.e_draw()
                l1.e_draw()
                l3.e_draw()
                ar1.e_draw()
                ar2.e_draw()
                ar3.e_draw()

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

        self.add_entry(TOCEntry(1, r'$A\cdot BC = A\cdot BD + A\cdot DE + A\cdot EC$', self.prop01))
        self.add_entry(TOCEntry(2, r"$(AB)^2 = AB\cdot AC + AB\cdot BC$", self.prop02_03_04))
        self.add_entry(TOCEntry(3, r'$AB\cdot CB = AC\cdot CB + (CB)^2$', self.prop02_03_04))
        self.add_entry(TOCEntry(4, r'$(AB)^2 = (AC)^2 + (CB)^2 + 2\cdot AC\cdot CB$', self.prop02_03_04))
        self.add_entry(TOCEntry(5, r'$AD\cdot DB + (CD)^2 = (CB)^2$', self.prop05_09))
        self.add_entry(TOCEntry(6, r'$AD\cdot DB + (CB)^2 = (CD)^2$', self.prop06_10))
        self.add_entry(TOCEntry(7, r'$(AB)^2 + (BC)^2 = (AC)^2 + 2\cdot AB\cdot BC$', self.prop02_03_04))
        self.add_entry(TOCEntry(8, r'$4\cdot AB\cdot BC + (AC)^2 = (AB+BC)^2$', self.prop02_03_04))
        self.add_entry(TOCEntry(9, r'$(AD)^2 + (DB)^2 = 2\cdot ((AC)^2 + (CD)^2)$', self.prop05_09))
        self.add_entry(TOCEntry(10, r'$(AD)^2 + (DB)^2 = 2\cdot ((AC)^2 + (CD)^2)$', self.prop06_10))
        self.add_entry(TOCEntry(11, r'Find H such that: $\quad  AB\cdot BH = (AH)^2$', self.prop_11))
        self.add_entry(TOCEntry(12, [r'Cosine Law', r'$(BC)^2 = (AB)^2+(AC)^2+2\cdot AD\cdot AC$'], self.prop_12))
        self.add_entry(TOCEntry(13, [r'Cosine Law.', r'$(AC)^2 = (AB)^2+(BC)^2-2\cdot BD\cdot BC$'], self.prop_13))
        self.add_entry(TOCEntry(14, r'Construct a square equal to the polygon', self.prop_14))

    @staticmethod
    def prop01(xpos, ypos)->mn.VGroup:
        group = E_VGroup(
            EPoint((xpos + 0.8, ypos      )).add_label('A', mn.LEFT),
            EPoint((xpos + 0.8, ypos + 0.3)).add_label('B', mn.LEFT),
            EPoint((xpos + 3.0, ypos + 0.3)).add_label('C', mn.RIGHT),
            EPoint((xpos + 2.0, ypos + 0.3)).add_label('D', mn.UP),
            EPoint((xpos + 2.5, ypos + 0.3)).add_label('E', mn.UP),
            ELine( (xpos + 0.8, ypos, 0   ), (xpos + 2.0, ypos      )),
            ELine( (xpos + 0.8, ypos + 0.3), (xpos + 3.0, ypos + 0.3)),
        )
        return group

    @staticmethod
    def prop02_03_04(xpos,ypos)->mn.VGroup:
        group = E_VGroup(
            EPoint( (xpos + 0.8, ypos) ).add_label("A", mn.LEFT),
            EPoint( (xpos + 3.0, ypos) ).add_label("B", mn.RIGHT),
            EPoint( (xpos + 2.3, ypos) ).add_label("C", mn.UP),
            ELine ( (xpos + 0.8, ypos), (xpos + 3.0, ypos)),
        )
        return group

    @staticmethod
    def prop05_09(xpos,ypos)->mn.VGroup:
        m = (3.0-0.8)/2 + 0.8
        group = E_VGroup(
            EPoint( (xpos + 0.8,   ypos) ).add_label("A", mn.LEFT),
            EPoint( (xpos + 3.0,   ypos) ).add_label("B", mn.RIGHT),
            EPoint( (xpos + m,     ypos) ).add_label("C", mn.UP),
            EPoint( (xpos + m+0.5, ypos) ).add_label("D", mn.UP),
            ELine ( (xpos + 0.8,   ypos), (xpos + 3.0, ypos)),
        )
        return group

    @staticmethod
    def prop06_10(xpos,ypos)->mn.VGroup:
        m = (3.0-0.8)/2 + 0.8
        group = E_VGroup(
            EPoint( (xpos + 0.8,   ypos) ).add_label("A", mn.LEFT),
            EPoint( (xpos + 3.0,   ypos) ).add_label("B", mn.UP),
            EPoint( (xpos + m,     ypos) ).add_label("C", mn.UP),
            EPoint( (xpos + 3.4,   ypos) ).add_label("D", mn.RIGHT),
            ELine ( (xpos + 0.8,   ypos), (xpos + 3.4, ypos)),
        )
        return group

    @staticmethod
    def prop_11(xpos,ypos)->mn.VGroup:
        group = E_VGroup(
            EPoint((xpos + 0.8, ypos)).add_label("A", mn.LEFT),
            EPoint((xpos + 3.0, ypos)).add_label("B", mn.RIGHT),
            EPoint((xpos + 2.2, ypos)).add_label("H?", mn.UP),
            ELine((xpos + 0.8, ypos), (xpos + 3.0, ypos)),
        )
        return group

    @staticmethod
    def prop_12(xpos,ypos)->mn.VGroup:
        group = E_VGroup(
            ETriangle( (xpos + 1.8, ypos + 0.0), # A
                       (xpos + 3.0, ypos + 0.0), # C
                       (xpos + 0.4, ypos + 0.8), # B
                       point_labels=['A', 'C', 'B'],
                       fill=mn.BLUE,
                       ),
            EPoint(    (xpos + 0.4, ypos + 0.0)).add_label("D", mn.DOWN),

            ELine (    (xpos + 0.4, ypos + 0.8), # B
                       (xpos + 0.4, ypos + 0.0), # D
            ),
            ELine((xpos + 1.8, ypos + 0.0),  # A
                  (xpos + 0.4, ypos + 0.0),  # D
                  ),
        )
        return group

    @staticmethod
    def prop_13(xpos,ypos)->mn.VGroup:
        group = E_VGroup(
            ETriangle( (xpos + 1.8, ypos + 0.8), # A
                       (xpos + 0.4, ypos + 0.0), # B
                       (xpos + 3.0, ypos + 0.0), # C
                       point_labels=['A', 'B', 'C'],
                       fill=mn.BLUE,
                       ),
            EPoint(    (xpos + 1.8, ypos + 0.0)).add_label("D", mn.DOWN),

            ELine (    (xpos + 1.8, ypos + 0.8), # A
                       (xpos + 1.8, ypos + 0.0), # D
            ),
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

