from __future__ import annotations

from itertools import pairwise

from euclidlib.Objects.EucidMObject import *
from . import Line as L

class EuclidPolygonLineAccessors:
    def __init__(self, poly: EuclidPolygon):
        self.poly = poly

    def __getitem__(self, item: int):
        if (ret := self.poly.lines[item]) is not None:
            return ret
        line = L.EuclidLine(self.poly.vertices[item], self.poly.vertices[item+1], scene=self.poly.scene)
        self.poly.lines[item] = line
        self.poly.add(line)
        return line

    def __get__(self, instance, owner):
        return self


class EuclidPolygon(EMObject, mn.VGroup[EMObject]):
    def __init__(self, *points: mn.Vect3, scene: ps.PropScene, **kwargs):
        self.vertices = list(points)
        self.vertices.append(points[0])
        self.lines: List[L.EuclidLine | None] = [None] * len(points)
        self.l = EuclidPolygonLineAccessors(self)
        super().__init__(scene=scene, **kwargs)

    def CreationOf(self, *args, **kwargs):
        return []




