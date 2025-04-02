from __future__ import annotations

from euclidlib.Objects import Polygon
from euclidlib.Objects.EucidMObject import *

def parallelogram(*coords: EMObject | Vect3) -> Tuple[Vect3, Vect3, Vect3, Vect3]:
    assert len(coords) == 3
    x, y, z = map(convert_to_coord, coords)
    diff = y - x
    return x, y, z, z - diff