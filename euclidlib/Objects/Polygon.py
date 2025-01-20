from __future__ import annotations

from itertools import pairwise, zip_longest
from typing import Tuple

from euclidlib.Objects.EucidMObject import *
from . import EucidGroupMObject as G
from . import Line as L
from . import Point as P
from . import Angel as A


class EuclidPolygon(G.PsuedoGroup, EMObject, mn.Polygon):
    def __init__(
            self, *points: mn.Vect3,
            speed: float = 1,
            point_labels: List[Tuple[str, Vect3]] | None = None,
            labels: List[Tuple[str, Vect3]] | None = None,
            angles: List | None = None,
            angle_sizes: List | None = None,
            fill: mn.Color = None,
            z_index=-1,
            **kwargs
    ):
        self.options = {
            k: locals()[k]
            for k in ('point_labels', 'labels', 'angles', 'fill')
            if locals()[k] is not None
        }
        self._sub_group = G.EGroup()
        self.speed = speed
        self.vertices = [convert_to_coord(p) for p in points]
        self.sides = len(self.vertices)
        self.lines: List[L.EuclidLine] = []
        self.points: List[P.EuclidPoint] = []
        self.angles: List[A.EuclidAngle | None] = [None] * self.sides
        super().__init__(*self.vertices, stroke_width=0, z_index=z_index, **kwargs)
        self.vertices.append(self.vertices[0])
        self.define_sub_objs()

    def get_group(self):
        return self._sub_group

    def define_sub_objs(self):
        with self.scene.simultaneous_speed(self.speed):
            if 'point_labels' in self.options:
                self.points = [
                    P.EuclidPoint(coord, scene=self.scene, label=label, label_dir=pos)
                    for coord, (label, pos)
                    in zip(self.vertices, self.options['point_labels'])]
        with self.scene.simultaneous_speed(self.speed):
            self.lines = [L.EuclidLine(p0, p1, scene=self.scene) for p0, p1 in pairwise(self.vertices)]

        self._sub_group.add(*self.lines, *self.points)

        with self.scene.simultaneous_speed(self.speed):
            if 'labels' in self.options:
                self.set_labels(*self.options['labels'])
        with self.scene.simultaneous_speed(self.speed):
            if 'angles' in self.options:
                self.set_angles(*self.options['angles'])

    def e_fill(self, color: ManimColor = None, opacity=0.5):
        self.scene.play(
            self.animate.set_fill(color=color, opacity=opacity, recurse=False)
        )
        return self

    def e_unfill(self):
        return self.e_fill(opacity=0)

    def set_labels(self, *labels: Tuple[str | None, Vect3 | None]):
        for l, (label, pos) in zip(self.lines, labels):
            if label:
                l.add_label(label, pos)
        return self

    def set_point_labels(self, *labels: Tuple[str | None, Vect3 | None]):
        for p, (label, pos) in zip(self.points, labels):
            if label:
                p.add_label(label, pos)
        return self

    def set_angles(self, *angle_data: str | float | None):
        names, sizes = angle_data[:self.sides], angle_data[self.sides:]
        names_and_sizes = zip_longest(names, sizes, fillvalue=to_manim_v_scale(40))
        line_pairs = pairwise([self.lines[-1]] + self.lines)

        if not self.angles:
            self.angles = [
                A.EuclidAngle(l1, l2, size=size, label=name, scene=self.scene)
                for (l1, l2), (name, size) in zip(line_pairs, names_and_sizes)
                if name
            ]
            self._sub_group.add(*self.angles)
        else:
            for i, ((l1, l2), (name, size)) in enumerate(zip(line_pairs, names_and_sizes)):
                if not name:
                    continue
                self.angles[i] = A.EuclidAngle(l1, l2, size=size, label=name, scene=self.scene)
                self._sub_group.add(self.angles[i])
        return self

    @property
    def l(self):
        return self.lines

    @property
    def p(self):
        return self.points

    @property
    def a(self):
        return self.angles

    def CreationOf(self, *args, **kwargs):
        return [mn.FadeIn(self)]

    def RemovalOf(self, *args, **kwargs):
        return [mn.FadeOut(self)]
