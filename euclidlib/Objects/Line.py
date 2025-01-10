from __future__ import annotations
from euclidlib.Objects.EucidMObject import *

class EuclidLine(EMObject, Line):
    def __init__(self, start: EMObject | Vect3, end: EMObject | Vect3, *args, **kwargs):
        self.e_start = start.get_center() if isinstance(start, EMObject) else start
        self.e_end = end.get_center() if isinstance(end, EMObject) else end
        super().__init__(start, end, *args, **kwargs)

    def e_label_point(self, direction: Vect3):
        return midpoint(self.e_start, self.e_end)

    def point(self, r: float):
        p3x, p3y, *_ = self.get_end()
        xs, ys, *_ = self.get_start()
        dx = p3x - xs
        dy = p3y - ys
        if dx == dy == 0:
            return xs, ys

        x = r / math.sqrt(dy**2 + dx**2) * dx + xs
        y = r / math.sqrt(dy**2 + dx**2) * dy + ys
        return x, y


class VirtualLine(EuclidLine):
    Virtual = True