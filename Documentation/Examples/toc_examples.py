import sys
import os


sys.path.append(os.getcwd())

from euclidlib.Scenes.animate_state import AnimState
from euclidlib.Scenes.PropScene import PropScene
from euclidlib.CONSTANTS import *
from euclidlib.Objects import *


class Book1Prop1(PropScene):
    title = ""
    steps = []

    def run_full(self):
        print(mn.__version__)
        make_toc(self,9)

    def go(self):
        pass
def text(scene):
    t1 = TextBox(mn_coord(20, 20))
    t1.title("some text")


def make_toc(scene, index=0):
    y_padding = 0.5
    x_padding = 0.6
    toc = TOC2("Table of Contents - Book 2")
    col_width = M_FRAME_WIDTH/3
    cols = [M_LEFT_BORDER, M_LEFT_BORDER+ col_width, M_LEFT_BORDER+ 2*col_width]
    tb_title = TextBox(mn_coord(500,40,0))
    tb_title.title(toc.title)
    print()
    print("=========")
    print(f"{M_TOP_BORDER=}, {y_padding=}, {tb_title.get_bottom()}")
    print("=========")
    print()

    ypos = tb_title.get_bottom()[1] - y_padding
    xpos = cols.pop(0)

    for prop,entry in enumerate(toc.get_entries(),start=1):
        scene.animateState.append(AnimState.SKIP)
        tb1 = TextBox([xpos+0.1, ypos, 0])
        tb1.math(f"{entry.prop_num}.")
        g = entry.diagram(xpos, ypos)
        tb2 = TextBox([xpos+y_padding, ypos, 0], line_width=col_width)
        if isinstance(entry.text, str):
            tb2.math(entry.text,font_size=18)
        else:
            for t in entry.text:
                tb2.math(t,font_size=18)

        if ypos - y_padding - g.get_height() - tb2.get_height() < M_BOTTOM_BORDER + y_padding:
            xpos = cols.pop(0)
            ypos = tb_title.get_bottom()[1] - y_padding

        tb1.move_to([xpos+0.1, ypos, 0], aligned_edge=UL)
        g.move_to([xpos+x_padding,ypos,0], aligned_edge=UL)
        tb2.move_to([xpos+x_padding, ypos - y_padding/4 - g.get_height(), 0],aligned_edge=UL)

        if prop==index:
            r = mn.Rectangle(col_width,mn.VGroup(tb1,g,tb2).get_height()+y_padding,
                             z_index=-1, stroke_width=1, fill_color=mn.BLACK, opacity=1)
            r.set_fill(TOC_HIGHLIGHT_BG, opacity=0.25)
            r.set_stroke(STROKE_COLOUR)
            r.move_to([xpos,ypos+y_padding/2,0],aligned_edge=UL)
            scene.add(r)
        ypos = ypos - y_padding - g.get_height() - tb2.get_height()
        scene.animateState.pop()







from dataclasses import dataclass
from typing import Callable

from euclidlib.Utilities.coordinate_utilities import mn_scale
from euclidlib.Objects import *


@dataclass
class TOCEntry:
    prop_num: int
    text:str
    diagram: Callable[[float,float],mn.VGroup]    # returns height of all new objects

class TOC:
    def __init__(self, title, book):
        self.title = title
        self.book = book
        self.entries:list[TOCEntry] = []
    def add_entry(self, entry:TOCEntry):
        self.entries.append(entry)
    def get_entries(self):
        return self.entries


class TOC2(TOC):
    def __init__(self,title):
        super().__init__(title, 'II')

        self.add_entry(TOCEntry(1, r'A\cdot BC = A\cdot BD + A\cdot DE + A\cdot EC', self.prop01))
        self.add_entry(TOCEntry(2, r"(AB)^2 = AB\cdot AC + AB\cdot BC", self.prop02_03_04))
        self.add_entry(TOCEntry(3, r'AB\cdot CB = AC\cdot CB + (CB)^2', self.prop02_03_04))
        self.add_entry(TOCEntry(4, r'(AB)^2 = (AC)^2 + (CB)^2 + 2\cdot AC\cdot CB', self.prop02_03_04))
        self.add_entry(TOCEntry(5, r'AD\cdot DB + (CD)^2 = (CB)^2', self.prop05_09))
        self.add_entry(TOCEntry(6, r'AD\cdot DB + (CB)^2 = (CD)^2', self.prop06_10))
        self.add_entry(TOCEntry(7, r'(AB)^2 + (BC)^2 = (AC)^2 + 2\cdot AB\cdot BC', self.prop02_03_04))
        self.add_entry(TOCEntry(8, r'4\cdot AB\cdot BC + (AC)^2 = (AB+BC)^2', self.prop02_03_04))
        self.add_entry(TOCEntry(9, r'(AD)^2 + (DB)^2 = 2\cdot ((AC)^2 + (CD)^2)', self.prop05_09))
        self.add_entry(TOCEntry(10, r'(AD)^2 + (DB)^2 = 2\cdot ((AC)^2 + (CD)^2)', self.prop06_10))
        self.add_entry(TOCEntry(11, r'\text{Find H such that:}\quad  AB\cdot BH = (AH)^2', self.prop_11))
        self.add_entry(TOCEntry(12, [r'\text{Cosine Law}', r'(BC)^2 = (AB)^2+(AC)^2+2\cdot AD\cdot AC'], self.prop_12))
        self.add_entry(TOCEntry(13, [r'\text{Cosine Law}.', r'(AC)^2 = (AB)^2+(BC)^2-2\cdot BD\cdot BC'], self.prop_13))
        self.add_entry(TOCEntry(14, r'\text{Construct square equal to polygon}', self.prop_14))

    @staticmethod
    def prop01(xpos, ypos)->mn.VGroup:
        group = E_VGroup(
            EPoint((xpos + 0.8, ypos      )).add_label('A', mn.LEFT),
            EPoint((xpos + 0.8, ypos + 0.4)).add_label('B', mn.LEFT),
            EPoint((xpos + 3.0, ypos + 0.4)).add_label('C', mn.RIGHT),
            EPoint((xpos + 2.0, ypos + 0.4)).add_label('D', mn.UP),
            EPoint((xpos + 2.5, ypos + 0.4)).add_label('E', mn.UP),
            ELine( (xpos + 0.8, ypos, 0   ), (xpos + 2.0, ypos      )),
            ELine( (xpos + 0.8, ypos + 0.4), (xpos + 3.0, ypos + 0.4)),
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


"""
        "Find square of polygon",

            my $s = Polygon->new(
                                  $pn,       4,        $xs + 40,  $ys + 80,
                                  $xs + 250, $ys + 80, $xs + 280, $ys + 40,
                                  $xs + 180, $ys
            );
            $s->fill($sky_blue);
            return 120;
        },
}


"""