from .Utilities import coordinate_utilities
import manimlib.constants as mn_constants

# what is the 'smallest' measurement for comparing floats
EPSILON = coordinate_utilities.mn_scale(1)
ANGLE_EPSILON = .5 * mn_constants.DEGREES

# how faded will the objects be (obj.e_fade())
DEFAULT_FADE_OPACITY = 0.30
DEFAULT_TEXT_FADE_OPACITY = 0.30

# what is the default runtime for transformations
DEFAULT_TRANSFORM_RUNTIME = 0.25

# default edge buffer between objects (
DEFAULT_EDGE_BUFFER = mn_constants.DEFAULT_MOBJECT_TO_EDGE_BUFFER

# The Book Scene has a grid, change opacity to see if it
BOOK_SCENE_GRID_OPACITY = .3

# Default speed for running animations
DEFAULT_SPEED = 2
DEFAULT_TEXT_SPEED = 2

# label buff for EMObject
LABEL_BUFF = mn_constants.MED_SMALL_BUFF*.8
LINE_LABEL_BUFF = 0.15
POINT_LABEL_BUFF = mn_constants.MED_SMALL_BUFF

# showing parts
LINE_SHOW_PARTS_BUFF = mn_constants.SMALL_BUFF * 0.7

# default radius of angle indicator
ANGLE_SIZE = coordinate_utilities.mn_scale(40)

# default 'max' opacity for fill colour
E_FILL_OPACITY_FACTOR = .5

# default size of a point
DEFAULT_POINT_SIZE = coordinate_utilities.mn_scale(5)
