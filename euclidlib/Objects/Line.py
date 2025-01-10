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

    def extend(self, r: float):
        x2, y2 = self.point(r + self.get_length())
        self.e_end = (x2, y2, 0)
        self.scene.play(self.animate.set_points_by_ends(self.e_start, self.e_end))

    def prepend(self, r: float):
        x2, y2 = self.point(-r)
        self.e_start = (x2, y2, 0)
        self.scene.play(self.animate.set_points_by_ends(self.e_start, self.e_end))


class VirtualLine(EuclidLine):
    Virtual = True