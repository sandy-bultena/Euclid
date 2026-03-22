from __future__ import annotations

import math

import manimlib as mn
from euclidlib.Objects.em_object_base import *
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Utilities.coordinate_utilities import mn_scale, convert_to_coord, mn_coord

def parallelogram(*coords: EMObject | mn.Vect3) -> tuple[mn.Vect3, mn.Vect3, mn.Vect3, mn.Vect3]:
    assert len(coords) == 3
    x, y, z = map(convert_to_coord, coords)
    diff = y - x
    return x, y, z, z - diff

def square_from_side(p1: EMObject | mn.Vect3, p2: EMObject | mn.Vect3, right=False) -> tuple[mn.Vect3, mn.Vect3, mn.Vect3, mn.Vect3]:
    p1 = convert_to_coord(p1)
    p2 = convert_to_coord(p2)
    vect = p2 - p1
    vect = mn.rotate_vector(vect, mn.PI/2 * (-1 if right else 1))
    return square(p1, p2, p2+vect)

def square_from_corners(p1: EMObject | mn.Vect3, p2: EMObject | mn.Vect3) -> tuple[mn.Vect3, mn.Vect3, mn.Vect3, mn.Vect3]:
    p1 = convert_to_coord(p1)
    p2 = convert_to_coord(p2)
    mid = mn.midpoint(p1, p2)
    half_vec = (p2 - p1)/2
    return p1, mid + mn.rotate_vector(half_vec, -mn.PI/2), p2, mid + mn.rotate_vector(half_vec, mn.PI/2)


def square(*coords: EMObject | mn.Vect3) -> tuple[mn.Vect3, mn.Vect3, mn.Vect3, mn.Vect3]:
    assert len(coords) == 3
    x, y, z = map(convert_to_coord, coords)
    diff = y - x
    return z, x, y, z + diff

def right_triangle(*coords: EMObject | mn.Vect3, height=mn_scale(25)):
    assert len(coords) == 2
    p2, p3 = coords
    delta = p3 - p2
    p4 = mn.normalize(delta) * height + p3
    return *coords, p4

def equilateral_triangle(*coords: EMObject | mn.Vect3, height=mn_scale(25)):
    assert len(coords) == 2
    p1, p2 = coords
    h = math.sqrt(3)/2 * mn.get_norm(p2 - p1)
    m = mn.midpoint(p1, p2)
    right = right_triangle(p1, m, height=h)
    return *coords, right[-1]

def isosceles_triangle(*coords: EMObject | mn.Vect3, radius=mn_scale(25)):
    assert len(coords) == 2
    p1, p2 = coords
    m = mn.midpoint(p1, p2)
    delta = m - p1
    p4 = mn.normalize(delta) * radius + m
    return *coords, p4

