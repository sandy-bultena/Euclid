import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.book08 import Book8Scene
from euclidlib.Objects import *
from euclidlib.Utilities.e_numbers import ENumbers

PPURPLE       = Colour.add( PURPLE,    PURPLE )
REALLY_PURPLE = Colour.add( PPURPLE, PURPLE )

class Prop27(Book8Scene):
    title = ("Similar solid numbers have to one another the ratio which a cube number has to a cube number"
    )

    def go(self):
        t1 = TextBox(mn_coord(800, 150), line_width=mn_scale(500), name="explanation")
        t2 = TextBox(mn_coord(140, 300), name="math")
        t3 = TextBox(mn_coord(500, 480))

        origin = mn_coord(100, 160)
        unit = mn_scale(5)
        dy = mn_scale(30)
        dx = mn_scale(50)
        mls = MultipleLines(origin, unit, dx, dy)

        n1, n2, n3, n4 = ENumbers.find_continued_proportion(2, 3, 4)

        mls.define_line_coordinates('A', 2 * n1)
        mls.define_line_coordinates('E', n1, after='ABCD', next_line=False)
        mls.define_line_coordinates('C', 2 * n2)
        mls.define_line_coordinates('F', n2, after='ABCD', next_line=False)
        mls.define_line_coordinates('D', 2 * n3)
        mls.define_line_coordinates('G', n3, after='ABCD', next_line=False)
        mls.define_line_coordinates('B', 2 * n4)
        mls.define_line_coordinates('H', n4, after='ABCD', next_line=False)

        # -------------------------------------------------------------------------------------------------------------
        # In Other Words
        # -------------------------------------------------------------------------------------------------------------
        t1.title("In other words")
        t1.explain("If A and B are similar solid numbers ...")
        mls.draw_lines('AB')
        t2.math(r"A \sim B \quad\quad (A=pqr,\, B=ijk\quad p\ratio q\ratio r = i\ratio j\ratio k)", is_axiom=True)
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("... then the ratio of A to B can also be expressed as a ratio of two cubes")
        t2.math(r"A\ratio B = x^3\ratio y^3")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        # Proof
        # -------------------------------------------------------------------------------------------------------------
        t1.e_remove()
        t2.delete_last()
        t2.down()
        t1.title("Proof")
        t1.explain("Since A and B are similar solid numbers, two mean proportionals fall between them (VIII.19)")
        mls.draw_lines("CD")
        t2.math(r"A\ratio C = C\ratio D = D\ratio B")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Let E, F, G, H be the least numbers that have the same ratio as A, C, D, B (VII.33) or (VIII.2)")
        t2.e_fade(0)
        mls.draw_lines("EFGH")
        t2.math(r"E\ratio F = F\ratio G = G\ratio H")
        t2.math(r"E\ratio H = A\ratio B \quad\quad (\text{E,H are least numbers})")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("Therefore the extremes E and H are cube (VIII.2.Por)")
        t2.e_fade(1,3)
        t2.math("E=x^3")
        t2.math("H=y^3")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t1.explain("And A is to B as E is to H, so the ratio of A and B can be expressed as a ratio of two cubes")
        t2.e_fade(2)
        t2.e_normal(3)
        t2.math(r"A\ratio B = x^3\ratio y^3")
        self.next_page()

        # -------------------------------------------------------------------------------------------------------------
        t2.e_fade(slice(1,-1))
        t2.e_normal(0,-1)
        self.next_page()

