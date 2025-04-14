from euclidlib.Objects import convert_to_coord
import manimlib as mn
import numpy as np


def call_or_get(func):
    return func() if callable(func) else convert_to_coord(func)

def angle_to_vector(angle: float):
    return np.array([np.cos(angle), np.sin(angle), 0])