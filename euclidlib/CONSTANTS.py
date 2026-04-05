from .Utilities import coordinate_utilities
from .Utilities import Colour
import manimlib.constants as mn_constants

# what is the 'smallest' measurement for comparing floats
EPSILON = coordinate_utilities.mn_scale(1)
ANGLE_EPSILON = .5 * mn_constants.DEGREES

# how faded will the objects be (obj.e_fade())
DEFAULT_FADE_OPACITY = 0.25
DEFAULT_TEXT_FADE_OPACITY = 0.25

# what is the default runtime for transformations
DEFAULT_TRANSFORM_RUNTIME = 0.25

# default edge buffer between objects (
DEFAULT_EDGE_BUFFER = mn_constants.DEFAULT_MOBJECT_TO_EDGE_BUFFER

# Default speed for running animations
DEFAULT_SPEED = 2
DEFAULT_TEXT_SPEED = 20

# label buff for EMObject
LABEL_BUFF = mn_constants.MED_SMALL_BUFF*.8
LINE_LABEL_BUFF = 0.15
POINT_LABEL_BUFF = mn_constants.MED_SMALL_BUFF*.75

# showing parts
LINE_SHOW_PARTS_BUFF = mn_constants.SMALL_BUFF * 0.7

# default radius of angle indicator
ANGLE_SIZE = coordinate_utilities.mn_scale(40)

# default 'max' opacity for fill colour
E_FILL_OPACITY_FACTOR = .3

# default size of a point
DEFAULT_POINT_SIZE = coordinate_utilities.mn_scale(5)

# for notice()
NOTICE_FRAC_SPEED = 0.5
NOTICE_SCALE_FACTOR = 3
NOTICE_COLOUR = mn_constants.RED

# default color scheme
STROKE_COLOUR = mn_constants.BLACK
FILL_COLOUR = mn_constants.BLACK
POINT_STROKE_COLOR = mn_constants.WHITE
TEXT_REMOVAL_STROKE_COLOUR = mn_constants.BLUE
E_BLUE = Colour.darken("#0000FF",5)
E_GREEN = Colour.darken(mn_constants.GREEN,20)
E_RED = Colour.darken(mn_constants.RED,20)
BOOK_SCENE_GRID_OPACITY = .1

