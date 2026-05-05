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
        tb.title("Content:")
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



