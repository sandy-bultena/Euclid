from __future__ import annotations

from euclidlib.Objects import Line
from euclidlib.Objects.EucidMObject import *

def parallelogram(*coords: EMObject | Vect3) -> Tuple[Vect3, Vect3, Vect3, Vect3]:
    assert len(coords) == 3
    x, y, z = map(convert_to_coord, coords)
    diff = y - x
    return x, y, z, z - diff

def square_from_side(p1: EMObject | Vect3, p2: EMObject | Vect3, right=False) -> Tuple[Vect3, Vect3, Vect3, Vect3]:
    p1 = convert_to_coord(p1)
    p2 = convert_to_coord(p2)
    vect = p2 - p1
    vect = mn.rotate_vector(vect, PI/2 * (-1 if right else 1))
    return square(p1, p2, p2+vect)

def square_from_corners(p1: EMObject | Vect3, p2: EMObject | Vect3) -> Tuple[Vect3, Vect3, Vect3, Vect3]:
    p1 = convert_to_coord(p1)
    p2 = convert_to_coord(p2)
    mid = mn.midpoint(p1, p2)
    half_vec = (p2 - p1)/2
    return p1, mid + mn.rotate_vector(half_vec, -PI/2), p2, mid + mn.rotate_vector(half_vec, PI/2)


def square(*coords: EMObject | Vect3) -> Tuple[Vect3, Vect3, Vect3, Vect3]:
    assert len(coords) == 3
    x, y, z = map(convert_to_coord, coords)
    diff = y - x
    return z, x, y, z + diff