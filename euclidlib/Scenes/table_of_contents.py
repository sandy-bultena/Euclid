from dataclasses import dataclass
from typing import Optional, Callable
import manimlib as mn
from euclidlib.Objects import *
from euclidlib.CONSTANTS import *
from euclidlib.Scenes.animate_state import AnimState


@dataclass
# ====================================================================================================================
# TOCEntry
# ====================================================================================================================
class TOCEntry:
    prop_num: int
    text: str
    diagram: Optional[Callable[[float,float],mn.VGroup]] = None

# ====================================================================================================================
# DrawnTOCEntry
# ====================================================================================================================
class DrawnTOCEntry:
    prop_num: TextBox
    text: TextBox
    diagram: Optional[mn.VGroup]
    def remove(self):
        self.prop_num.e_remove()
        if self.diagram is not None:
            for o in self.diagram:
                o.e_remove()
        self.text.e_remove()

# ====================================================================================================================
# col start position generator
# ====================================================================================================================
def define_cols( num_cols):
    col_width = M_FRAME_WIDTH / num_cols
    while True:
        for i in range(num_cols):
            yield M_LEFT_BORDER + col_width * i
        yield None

# ====================================================================================================================
# TOC
# ====================================================================================================================
class TOC:
    def __init__(self, title="", book="",*, x_padding=0.6, y_padding=0.25, next_page_func:Callable=lambda: None):
        self.title = title
        self.book = book
        self.entries:list[TOCEntry] = []
        self.x_padding = x_padding
        self.y_padding = y_padding
        self.next_page_func = next_page_func
        self.col_width = (M_RIGHT_BORDER - M_LEFT_BORDER)/3
        self.cols_xpos = define_cols(3)
        self.bottom_padding = 0.2

    def add_entry(self, entry:TOCEntry):
        self.entries.append(entry)

    # -----------------------------------------------------------------------------------------------------------------
    # draw table of contents
    # -----------------------------------------------------------------------------------------------------------------
    def draw(self, index=0, num_cols=3):
        self.cols_xpos = define_cols(num_cols)
        self.col_width = M_FRAME_WIDTH / num_cols

        # write the title
        y_top = self.draw_header()

        # starting ypos and xpos
        ypos = y_top
        xpos = next(self.cols_xpos)

        # foreach proposition, and toc entry, place in scene
        for prop, entry in enumerate(self.entries, start=1):

            # draw the toc entry
            drawn_entry:DrawnTOCEntry = self.draw_toc_entry(entry, xpos, ypos)

            # if we are two far down, move to next column
            if drawn_entry.text.get_bottom()[1] - self.y_padding < M_BOTTOM_BORDER + self.bottom_padding:
                xpos = next(self.cols_xpos)
                if xpos is None:
                    xpos = next(self.cols_xpos)
                    drawn_entry = self.delete_and_redraw_entry(entry, drawn_entry, xpos)
                else:
                    drawn_entry = self.move_entry(drawn_entry, xpos, y_top)

            # if this toc is for prop 'index', outline the entry to indicate this proposition
            if prop == index:
                self.indicate_current_prop(xpos, drawn_entry)

            # reset for next toc entry
            ypos = drawn_entry.text.get_bottom()[1] - self.y_padding

    # -----------------------------------------------------------------------------------------------------------------
    # draw the header
    # -----------------------------------------------------------------------------------------------------------------
    def draw_header(self):
        tb_title = TextBox(mn_coord(500, 40, 0))
        tb_title.title(self.title)
        y_top = tb_title.get_bottom()[1] - 2*self.y_padding
        return y_top

    # -----------------------------------------------------------------------------------------------------------------
    # draw the toc entry
    # -----------------------------------------------------------------------------------------------------------------
    def draw_toc_entry(self, entry, xpos, ypos) -> DrawnTOCEntry:
        font_size=20

        drawn_entry = DrawnTOCEntry()

        # write the proposition number
        drawn_entry.prop_num = TextBox([xpos + 0.1, ypos, 0])
        drawn_entry.prop_num.math(f"{entry.prop_num}.", font_size=font_size)

        # draw any required diagram
        drawn_entry.diagram = None
        if entry.diagram is not None:
            drawn_entry.diagram = entry.diagram(xpos + self.x_padding, ypos)
            drawn_entry.diagram.move_to([xpos + self.x_padding, ypos, 0], aligned_edge=UL)
            ypos = drawn_entry.diagram.get_bottom()[1] - self.y_padding / 2

        # write any required text
        drawn_entry.text = TextBox([xpos + self.x_padding, ypos, 0], line_width=self.col_width - 1.5 * self.x_padding)
        if isinstance(entry.text, str):
            drawn_entry.text.explainM(entry.text, font_size=font_size)
        else:
            for t in entry.text:
                drawn_entry.text.explainM(t, font_size=font_size)

        return drawn_entry

    # -----------------------------------------------------------------------------------------------------------------
    # move entry to new location
    # -----------------------------------------------------------------------------------------------------------------
    def move_entry (self, drawn_entry, xpos, ypos) -> DrawnTOCEntry:

        # move the textboxes and the diagrams to the required location
        drawn_entry.prop_num.move_to([xpos + 0.10, ypos, 0], aligned_edge=UL)
        if drawn_entry.diagram is not None:
            drawn_entry.diagram.move_to([xpos + self.x_padding, ypos, 0], aligned_edge=UL)
            ypos = drawn_entry.diagram.get_bottom()[1] - self.y_padding / 2
        drawn_entry.text.move_to([xpos + self.x_padding, ypos, 0], aligned_edge=UL)

        return drawn_entry

    # -----------------------------------------------------------------------------------------------------------------
    # move current entry to the next page
    # -----------------------------------------------------------------------------------------------------------------
    def delete_and_redraw_entry(self, entry, drawn_entry, xpos):

        # remove what was already drawn
        drawn_entry.remove()

        # do whatever next_page is required
        self.next_page_func()

        # start new page
        ypos = self.draw_header()
        return self.draw_toc_entry(entry, xpos, ypos)

    # -----------------------------------------------------------------------------------------------------------------
    # draw rectangle around current proposition toc entry
    # -----------------------------------------------------------------------------------------------------------------
    def indicate_current_prop(self, xpos, drawn_entry):
        xl = xpos + 0.75 * self.x_padding
        xr = xl + self.col_width - self.x_padding
        yt = drawn_entry.prop_num.get_top()[1] + 0.5 * self.y_padding
        yb = drawn_entry.text.get_bottom()[1] - 0.5 * self.y_padding
        r = EPolygon((xl, yt), (xr, yt), (xr, yb), (xl, yb), fill=TOC_HIGHLIGHT_BG)

        # make the rectangle a little less cluttered
        [p.e_remove() for p in r.p]
        [l.grey() for l in r.l]

