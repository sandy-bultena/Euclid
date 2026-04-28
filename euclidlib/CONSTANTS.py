import sys

from .Utilities import coordinate_utilities
from .Utilities import Colour
import manimlib.constants as mn_constants

# --------------------------------------------------------
# Default speed for running animations
# --------------------------------------------------------
DEFAULT_SPEED = 2
DEFAULT_TEXT_SPEED = 200

# --------------------------------------------------------
# copyright
# --------------------------------------------------------
AUTHOR = "Sandy Bultena"
YEAR = "2026"
CODE_CC = """CC BY-NC-SA 4.0"""
COPYRIGHT = f"Copyright © {YEAR} by {AUTHOR}"
GENERIC_CC = """The video and PDF content is licensed under Creative Commons Attribution-NonCommercial 4.0 International. 
To view a copy of this license, visit https://creativecommons.org/licenses/by-nc/4.0/"""
YOUTUBE_LINK = "https://www.youtube.com/c/SandyBultena"
GITHUB_PDFS_LINK = "https://github.com/sandy-bultena/Euclid/tree/python-manim/Propositions_PDFs"
GITHUB_EUCLID_LINK = "https://github.com/sandy-bultena/Euclid/tree/python-manim"
GITHUB_MANIMGL_LINK = "https://github.com/3b1b/manim"
MANIMGL_AUTHOR = "3Blue1Brown"
EUCLID_LIB_AUTHOR = "Alex Emily Oxorn"


# --------------------------------------------------------
# size of the screen in old style coordinates
# --------------------------------------------------------
E_FRAME_WIDTH = coordinate_utilities.E_WIDTH
E_FRAME_HEIGHT = coordinate_utilities.E_HEIGHT
M_FRAME_WIDTH = coordinate_utilities.M_WIDTH
M_FRAME_HEIGHT = coordinate_utilities.M_HEIGHT
M_LEFT_BORDER = -M_FRAME_WIDTH/2
M_RIGHT_BORDER = M_FRAME_WIDTH/2
M_TOP_BORDER = M_FRAME_HEIGHT/2
M_BOTTOM_BORDER = -M_FRAME_HEIGHT/2

# --------------------------------------------------------
# what is the 'smallest' measurement for comparing floats
# --------------------------------------------------------
EPSILON = coordinate_utilities.mn_scale(1)
ANGLE_EPSILON = .5 * mn_constants.DEGREES

# --------------------------------------------------------
# Look'n'Feel of output
# --------------------------------------------------------

# how faded will the objects be (obj.e_fade())
DEFAULT_FADE_OPACITY = 0.25
DEFAULT_TEXT_FADE_OPACITY = 0.25

# default 'max' opacity for fill colour
E_FILL_OPACITY_FACTOR = .5

# what is the default runtime for transformations
DEFAULT_TRANSFORM_RUNTIME = 0.25

# default edge buffer between objects (
DEFAULT_EDGE_BUFFER = mn_constants.DEFAULT_MOBJECT_TO_EDGE_BUFFER

# label buff for EMObject
LABEL_BUFF = mn_constants.MED_SMALL_BUFF*.8
LINE_LABEL_BUFF = 0.15
POINT_LABEL_BUFF = mn_constants.MED_SMALL_BUFF*.75

# showing parts
LINE_SHOW_PARTS_BUFF = mn_constants.SMALL_BUFF * 0.7

# default radius of angle indicator
ANGLE_SIZE = coordinate_utilities.mn_scale(40)

# default size of a point
DEFAULT_POINT_SIZE = coordinate_utilities.mn_scale(5)

# for notice()
NOTICE_FRAC_SPEED = 0.5
NOTICE_SCALE_FACTOR = 3
NOTICE_COLOUR = mn_constants.RED

# --------------------------------------------------------
# default color scheme
# --------------------------------------------------------
STROKE_COLOUR = mn_constants.BLACK
FILL_COLOUR = mn_constants.BLACK
POINT_STROKE_COLOR = mn_constants.WHITE
TEXT_REMOVAL_STROKE_COLOUR = mn_constants.BLUE
E_BLUE = Colour.darken("#0000FF",5)
E_GREEN = Colour.darken(mn_constants.GREEN,20)
E_RED = Colour.darken(mn_constants.RED,20)
BOOK_SCENE_GRID_OPACITY = .1
TOC_HIGHLIGHT_BG = mn_constants.YELLOW

# --------------------------------------------------------
# some default colours
# --------------------------------------------------------
SKY_BLUE = "#b3e6ff"
LIME_GREEN = "#ccffcc"
PALE_PINK = "#ffcce0"
PALE_YELLOW = "#ffffcc"
TURQUOISE = "#abefcd"
GREEN = Colour.darken(LIME_GREEN, 5)
BLUE = Colour.add(SKY_BLUE, SKY_BLUE)
DARK_BLUE = Colour.add(BLUE, BLUE)
TEAL = Colour.add(BLUE, LIME_GREEN)
PINK = Colour.add(PALE_PINK, PALE_PINK)
TAN = Colour.add(LIME_GREEN, PALE_PINK)
PURPLE = Colour.add(SKY_BLUE, PALE_PINK)
YELLOW = Colour.add(PALE_YELLOW, PALE_YELLOW)
ORANGE = Colour.add(PALE_YELLOW, PALE_PINK)

# --------------------------------------------------------
# Fonts
# --------------------------------------------------------
if sys.platform == 'darwin':  # MAC CHECK
    # Font Contenders:
    # Consolas, Arial, Gotu, Menlo, Lucida Grande, Monaco, Optima, Verdana
    TITLE_FONT = dict(font_size=24, font='Verdana')
    EXPLAIN_FONT = dict(font_size=16, font='Verdana')
    EXPLAINM_FONT = dict(font_size=16, font='Verdana')
    SIDENOTE_FONT = dict(font_size=16, font='Verdana', slant='ITALIC')
    NORMAL_FONT = dict(font_size=16, font='Verdana')
    BOLD_FONT = dict(font_size=16, font='Verdana', weight='BOLD')
    MATH_FONT = dict(font_size=20)
    FANCY_FONT =  dict(font_size=24, font='Charm')
    TITLE_SCREEN_FONT = dict(font_size=48, font='Bradley Hand')
    LABEL_FONT_SIZE = 18

elif sys.platform == 'linux':
    TITLE_FONT = dict(font_size=30, font='Arimo', weight='BOLD')
    EXPLAIN_FONT = dict(font_size=18, font='Arimo')
    EXPLAINM_FONT = dict(font_size=18, font='Arimo')
    SIDENOTE_FONT = dict(font_size=18, font='Arimo', slant='ITALIC')
    NORMAL_FONT = dict(font_size=16, font='Arimo')
    BOLD_FONT = dict(font_size=16, font='Arimo', weight='BOLD')
    MATH_FONT = dict(font_size=20)
    FANCY_FONT = dict(font_size=36, font='Z003')
    TITLE_SCREEN_FONT = dict(font_size=48, font='Karumbi')
    LABEL_FONT_SIZE = 18
else:
    TITLE_FONT = dict(font_size=30, weight='BOLD')
    EXPLAIN_FONT = dict(font_size=18)
    EXPLAINM_FONT = dict(font_size=18)
    SIDENOTE_FONT = dict(font_size=18, slant='ITALIC')
    NORMAL_FONT = dict(font_size=16)
    BOLD_FONT = dict(font_size=16, weight='BOLD')
    MATH_FONT = dict(font_size=20)
    FANCY_FONT = dict(font_size=36)
    TITLE_SCREEN_FONT = dict(font_size=48)
    LABEL_FONT_SIZE = 18
