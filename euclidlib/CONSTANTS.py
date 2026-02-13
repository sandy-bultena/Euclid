from .Utilities import coordinate_utilities
import manimlib.constants as mn_constants

# what is the 'smallest' measurement for comparing floats
EPSILON = coordinate_utilities.mn_scale(1)

# how faded will the objects be (obj.e_fade())
DEFAULT_FADE_OPACITY = 0.30
DEFAULT_TEXT_FADE_OPACITY = 0.30

# what is the default runtime for transformations
DEFAULT_TRANSFORM_RUNTIME = 0.25

# default edge buffer between objects (
DEFAULT_EDGE_BUFFER = mn_constants.DEFAULT_MOBJECT_TO_EDGE_BUFFER

# The Book Scene has a grid, change opacity to see if it
BOOK_SCENE_GRID_OPACITY = 0

# Default speed for running animations
DEFAULT_SPEED = .5
DEFAULT_TEXT_SPEED = .5

# label buff for EMObject
LABEL_BUFF = mn_constants.MED_SMALL_BUFF


