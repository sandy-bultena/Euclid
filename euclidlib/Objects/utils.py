import math

from euclidlib.Objects import convert_to_coord
import numpy as np


def call_or_get(func):
    return func() if callable(func) else convert_to_coord(func)

def angle_to_vector(angle: float):
    return np.array([np.cos(angle), np.sin(angle), 0])

def get_dist(a,b):
    a = convert_to_coord(a)
    b = convert_to_coord(b)
    return math.sqrt((a[0]-b[0])**2 + (a[1]-b[1])**2 + (a[2]-b[2])**2)
