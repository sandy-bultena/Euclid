from __future__ import annotations

import math

from typing import Sized

import numpy as np
import numpy.typing as npt
import manimlib as mn

# ---------------------------------------------------------------------------------------------------------------------
# manim coordinates are ~ 8x14
# ---------------------------------------------------------------------------------------------------------------------

E_WIDTH = 1400
E_HEIGHT = 800
E_TO_M_SCALE = 0.01
M_WIDTH = 14
M_HEIGHT = 8

# ---------------------------------------------------------------------------------------------------------------------
# if its a function, call it, else convert to coordinates  (wtf?)
# ---------------------------------------------------------------------------------------------------------------------
def call_or_get(func):
    return func() if callable(func) else convert_to_coord(func)

# ---------------------------------------------------------------------------------------------------------------------
# convert angle to a vector
# ---------------------------------------------------------------------------------------------------------------------
def angle_to_vector(angle: float):
    return np.array([np.cos(angle), np.sin(angle), 0])

# ---------------------------------------------------------------------------------------------------------------------
# get distance between 'a' and 'b'
# ---------------------------------------------------------------------------------------------------------------------
def get_dist(a,b):
    a = convert_to_coord(a)
    b = convert_to_coord(b)
    return math.sqrt((a[0]-b[0])**2 + (a[1]-b[1])**2 + (a[2]-b[2])**2)

# ---------------------------------------------------------------------------------------------------------------------
# Conversions between the old Euclid coordinates and the manim coordinates
# ---------------------------------------------------------------------------------------------------------------------
def mn_coord(x: int | float, y: int | float, z: int | float = 0) -> npt.NDArray[float]:
    """
    convert euclid coordinates to manim coordinates
    :param x:
    :param y:
    :param z:
    :return: a numpy array with the appropriate coordinates
    """
    return np.array([
        (x - E_WIDTH/2) * E_TO_M_SCALE,  # (x - 700) * (8.0 * 16 / 1400 / 9),
        (E_HEIGHT/2 - y) * E_TO_M_SCALE,
        z * E_TO_M_SCALE
    ])

def euclid_coord(x: int | float, y: int | float, z: int | float = 0) -> npt.NDArray[float]:
    """
    convert manim coordinates to euclid coordinates
    :param x:
    :param y:
    :param z:
    :return: a numpy array with the appropriate coordinates
    """
    # a = (x-width)*scale, x-width = a/scale
    return np.array([
        x/E_TO_M_SCALE + E_WIDTH/2,
        E_HEIGHT/2 - y/E_TO_M_SCALE,
        z / E_TO_M_SCALE
    ])

def euclid_scale(x: float)->float:
    return x/E_TO_M_SCALE

def mn_scale(f, *rest) -> float | npt.NDArray[float]:
    """
    changes the euclid length and converts to the appropriate manim length
    :param f: a single number
    :param rest: the rest of the numbers (if there are any)
    :return: either a single float, or a numpy array of floats
    """
    if rest:
        return convert_to_coord(np.array([i * E_TO_M_SCALE for i in (f, *rest)]))
    return f * E_TO_M_SCALE

# ---------------------------------------------------------------------------------------------------------------------
# convert 2d to 3d, or return centre of manim object
# ---------------------------------------------------------------------------------------------------------------------
def convert_to_coord(obj: mn.Mobject | Sized[float])->mn.Vect3:
    """convert 2d to 3d, or return centre of manim object"""

    # if this is a manim object, then just get the center of all the points
    if isinstance(obj, mn.Mobject):
        return obj.get_center()
    else:
        # if array size is not size 3, then pad with zeros so that we always return x,y,z
        return np.array([*obj, *((0.0,) * (3 - len(obj)))])


