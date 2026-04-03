import sys
import os
sys.path.append(os.getcwd())

from euclidlib.Scenes.PropScene import PropScene
from euclidlib.Objects import *

class Book1Prop1(PropScene):
    title = "To construct an equilateral triangle on a given finite straight line."
    steps = []

    def run_full(self):
        down()

    def go(self):
        pass

def down():
    t1 = TextBox(mn_coord(20, 20))
    t1.explain("hi")
    t1.down()
    t1.down()
    t1.down()
    t1.down()
    t1.explain("bonjour")
    t2 = TextBox(mn_coord(120, 20))
    t2.explain("hi")
    t2.down()
    t2.explain("bonjour")
    t2.explain("adieu")
    t1.explain("adieu")

def append():
    t1 = TextBox(mn_coord(20, 20))
    t1.explain("Hello")
    t1.e_append(-1," World")
    t1.e_append(-1,"!")
    t1.math("a=b")
    t1.math("x=y")
    t1.e_append(-2,r"\quad ...")

def colouring():
    t1 = TextBox(mn_coord(20, 20))
    t1.explain("green")
    t1.explain("green")
    t1.green(1)


def bulletted_list():
    t1 = TextBox(mn_coord(20, 20))
    t1.explain("No bullet")
    t1.set_bullet_symbol("*")
    t1.explain("point 1")
    t1.explain("point 2")
    t1.reset_bullet_symbol()
    t1.explain("Denouement")

def parts_aligning_eqns():
    t1 = TextBox(mn_coord(20, 20))
    t1.math('a+b+c+d+e=15',break_into_parts=['a+','c+','=15'])
    t1.math('a+b+c+d+e=21',break_into_parts=['a+','e','=21'])
    t1.math('a+b+c+d+e=3',break_into_parts=['b+','d+e','=3'])
    t1.math('a+b+c+d+e=9',break_into_parts=['d+','e','=9'])

def parts_basic():
    t1 = TextBox(mn_coord(20, 20))
    eq = t1.math('z=x+y',break_into_parts=['z','=x+y'])
    eq1,eq2 = eq.parts
    eq1.red()
    eq2.blue()

def transform_and_place():
    t1 = TextBox(mn_coord(20, 20))
    f = t1.math(r'a + b \alpha + c+\beta + \gamma = \rightangle + \rightangle', is_axiom=True,
                break_into_parts=(r'\alpha + \beta', '=', r'\rightangle + \rightangle'))
    eq1, eq2 = f.parts[0], f.parts[2]


    # at = t1.math(r'\alpha + \theta =',)
    # ab = t1.math(r'\alpha + \beta',
    #          same_line=True,
    #          transform_from=eq1)

def transform_3():
    t1 = TextBox(mn_coord(20,20))
    t1.explainM(r"transforming $\quad a^2\rightarrow x$, $\quad b^2\rightarrow y$, $\quad c\rightarrow f$")
    t1.math(r'a^2 + b = c')
    t1.math(r'x+y=f', transform_from=-1, transform_args=dict(key_map={'a^2':'x','b':'y','c':'f'}))
    t1.down()
    t1.explainM(r"transforming $\quad a^2\rightarrow y$, $\quad b^2\rightarrow x$, $\quad c\rightarrow f$")
    t1.math(r'a^2 + b = c')
    t1.math(r'x+y=f', transform_from=-1, transform_args=dict(key_map={'a^2': 'y', 'b': 'x', 'c': 'f'}))


def transform_2():
    t1 = TextBox(mn_coord(20, 20))
    t1.math(r'a = 2 b',)
    t1.math(r'2 b = a',
            transform_from=-1,
    )

def transform_1():
    t1 = TextBox(mn_coord(20, 20))
    t1.math(r'x=\sin^2\theta + \cos^2\theta')
    t1.math(r'x=1',
            transform_from=-1,
            transform_args=dict(
                # matched_keys=[r'\measuredangle CAD', r'\measuredangle CAB', r'='],
                #key_map={'a': r'c'},
                #path_arc=90 * DEGREES,
            ))


def alignment_not_previous():
    t1 = TextBox(mn_coord(20, 20))
    eq = t1.math("a + b + d = 3")
    t1.math("a = 3", align_str="a", align_index=eq)
    t1.math("b = 4", align_str="b", align_index=eq)
    t1.math("d = 3 - 4 - 3 = -4", align_str="d", align_index=eq)

def simple_alignment2():
    t1 = TextBox(mn_coord(20, 20))
    t1.math("a + b + d = 3")
    t1.math("f = 10",align_str=("b","f"))

def line_continuation():
    t1 = TextBox(mn_coord(20, 20))
    t1.math("a + b = 3")
    t1.math("b = 2")
    t1.math(r"\quad \leftarrow \text{see!!}", same_line=True)


def simple_alignment():
    t1 = TextBox(mn_coord(20, 20))
    t1.math("a + b = 3")
    t1.math("f = 10",align_str="=")

def property_change():
    t1 = TextBox(mn_coord(20, 20))
    t1.explain("normal")
    t1.explain("red fill, green outline", fill_color=RED, stroke_color=GREEN, stroke_width=1, font_size=30)

def font_change():
    t1 = TextBox(mn_coord(20, 20))
    t1.explain("font size is whatever the default is")
    t1.explain('font_size = 32', font_size=32)
    t1.explain("font_size = 8", font_size=8)

def vertical_spacing():
    t1 = TextBox(mn_coord(20, 20))
    t1.explain("line one")
    t1.explain("line two")
    t1.down()
    t1.down()
    t1.explain("line three")

def various_styles():
    pass
    t1 = TextBox(mn_coord(20, 20))
    t1.title_screen("This is 'title_screen' text")
    t1.title("This is 'title' text")
    t1.explain("This is 'explain' text")
    t1.explainM(r"This is 'explainM' text, can imbed math ($\alpha + \beta = \gamma)$")
    t1.sidenote("This is 'sidenote' text")
    t1.normal("This is 'normal' text")
    t1.fancy("This is 'fancy' text")
    t1.math(r"\text{math:}\quad sin^2\theta + cos^2\theta = 1")
    """
        if sys.platform == 'darwin':  # MAC CHECK
        fonts = dict(
            title=(Text.EMarkupText, dict(font_size=24, font='Gotu')),
            explain=(Text.EMarkupText, dict(font_size=16, font='Gotu')),
            sidenote=(Text.EMarkupText, dict(font_size=16, font='Gotu', slant='ITALIC')),
            explainM=(Text.ETexText, dict(font_size=16, font='Gotu')),
            normal=(Text.EText, dict(font_size=14, font='Gotu')),
            math=(Text.ETex, dict(font_size=22)),
            fancy=(Text.EText, dict(font_size=24, font='Charm')),
            title_screen=(Text.EText, dict(font_size=48, font='Bradley Hand')),
        )
    """

def buff_size():
    t1 = TextBox(mn_coord(20, 20))
    t1.explain("Line one")
    t1.explain("Line two")
    t1.explain("Line three")

    t2 = TextBox(mn_coord(20, 120), buff_size=mn.SMALL_BUFF*3)
    t2.explain("Line one")
    t2.explain("Line two")
    t2.explain("Line three")

def line_width_and_alignment():
    lorem = "".join("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor "
               "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud "
               "exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure "
               "dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
               "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit "
               "anim id est laborum.")
    t2 = TextBox(mn_coord(800, 200), alignment='w')
    t2.explain(lorem)
    t3 = TextBox(mn_coord(800, 250))
    t3.explain(lorem)
    t4 = TextBox(mn_coord(800, 300), line_width=mn_scale(500), alignment='w')
    t4.explain(lorem)
    t5 = TextBox(mn_coord(800, 550), line_width=mn_scale(500))
    t5.explain(lorem)
