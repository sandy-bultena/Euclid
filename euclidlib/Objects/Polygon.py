from __future__ import annotations

from itertools import pairwise, zip_longest
from typing import Tuple, Iterable

from euclidlib.Objects.EucidMObject import *
from . import EucidGroupMObject as G
from . import Line as L
from . import Point as P
from . import Angel as A

EPSILON = mn_scale(1)

class EuclidPolygon(G.PsuedoGroup, EMObject, mn.Polygon):
    def __init__(
            self, *points: mn.Vect3 | mn.Mobject | str,
            speed: float = 1,
            point_labels: List[Tuple[str, Vect3]] | None = None,
            labels: List[Tuple[str, Vect3]] | None = None,
            angles: List | None = None,
            angle_sizes: List | None = None,
            fill: mn.Color = None,
            z_index=-1,
            animate_part=('set_e_fill',),
            **kwargs
    ):
        if points and isinstance(points[0], str):
            from inspect import currentframe
            point_names = list(points[0])
            f = currentframe()
            while (f := f.f_back) is not None:
                if 'p' in f.f_locals or all(p in f.f_locals for p in point_names):
                    break
            if f is None:
                raise Exception("Can't Find Scene")
            points = [f.f_locals.get(p, f.f_locals.get('p', {}).get(p)) for p in point_names]

        if all(isinstance(p, L.EuclidLine) for p in points):
            lines = [p for p in points]
            tmp_lines = lines + [points[0]]
            points = []
            for l1, l2 in pairwise(tmp_lines):
                s1, e1 = l1.get_start_and_end()
                s2, e2 = l2.get_start_and_end()
                if (abs(np.linalg.norm(s2 - s1)) < EPSILON or
                        abs(np.linalg.norm(e2 - s1)) < EPSILON):
                    points.append(e1)
                else:
                    points.append(s1)

        assert all(p is not None for p in points)

        self.options = {
            k: locals()[k]
            for k in ('point_labels', 'labels', 'angles', 'fill')
            if locals()[k] is not None
        }
        self._sub_group = G.EGroup()
        self.speed = speed
        self.vertices = [convert_to_coord(p) for p in points]
        self.sides = len(self.vertices)
        if not hasattr(self, 'lines'):
            self.lines: List[L.EuclidLine] = []
        self.points: List[P.EuclidPoint] = []
        self.angles: List[A.EuclidAngle | None] = [None] * self.sides
        super().__init__(*self.vertices, stroke_width=0, z_index=z_index, animate_part=animate_part, **kwargs)
        if self.sides:
            self.vertices.append(self.vertices[0])
        self.define_sub_objs()
        self.cached_opacity = 0
        self.cached_fade = 1

    def set_e_fill(
            self,
            color: ManimColor | Iterable[ManimColor] = None,
            opacity: float | Iterable[float] | None = None,
            border_width: float | None = None,
            recurse: bool = True
    ) -> Self:
        self.cached_fade = opacity
        return self.set_fill(color, opacity * self.cached_opacity, border_width, recurse)

    def get_group(self):
        return mn.VGroup(*self._sub_group)

    def define_points(self):
        with self.scene.simultaneous_speed(self.speed):
            if 'point_labels' in self.options:
                self.points = [
                    P.EuclidPoint(coord, scene=self.scene, label=label, label_dir=pos)
                    for coord, (label, pos)
                    in zip(self.vertices, self.options['point_labels'])]

    def define_lines(self):
        if self.lines:
            return
        with self.scene.simultaneous_speed(self.speed):
            self.lines = [L.EuclidLine(p0, p1, scene=self.scene) for p0, p1 in pairwise(self.vertices)]

    def define_sub_objs(self):
        self.define_points()
        self.define_lines()

        self._sub_group.add(*self.lines, *self.points)

        with self.scene.simultaneous_speed(self.speed):
            if 'labels' in self.options:
                self.set_labels(*self.options['labels'])
        with self.scene.simultaneous_speed(self.speed):
            if 'angles' in self.options:
                self.set_angles(*self.options['angles'])

    def e_fill(self, color: ManimColor = None, opacity=0.5):
        self.scene.play(
            self.animate.set_fill(color=color, opacity=opacity * self.cached_fade, recurse=False)
        )
        self.cached_opacity = opacity
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
        names_and_sizes = zip_longest(names, sizes, fillvalue=mn_scale(40))
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

    def replace_line(self, index, newline: L.EuclidLine):
        self.lines[index].e_delete()
        self.lines[index] = newline
        self._sub_group.set_submobjects([*self.lines, *self.points, *(a for a in self.angles if a is not None)])

    def move_point_to(self, index: int, dest: P.EuclidPoint):
        self.vertices[index] = dest.get_center()
        self.vertices[-1] = self.vertices[0]

        with self.scene.simultaneous():
            self.scene.play(self.p[index].animate.move_to(dest))
            self.scene.play(self.l[index].animate.put_start_and_end_on(dest.get_center(), self.l[index].get_end()))
            self.scene.play(self.l[(index - 1) % self.sides].animate.put_start_and_end_on(
                self.l[(index - 1) % self.sides].get_start(), dest.get_center()))

            for i in range(self.sides):
                if self.angles[i] is not None:
                    old_angle = self.angles[i]
                    l1 = L.VirtualLine(self.vertices[i - 1], self.vertices[i])
                    l2 = L.VirtualLine(self.vertices[i], self.vertices[i + 1])
                    new_angle = A.EuclidAngle(l1, l2, size=old_angle.size)
                    self.scene.play(mn.Transform(old_angle, new_angle))
            self.vertices[index] = dest.get_center()
            self.vertices[-1] = self.vertices[0]
            self.scene.play(self.animate.set_points_as_corners(self.vertices))
        pass

    def CreationOf(self, *args, **kwargs):
        return [mn.FadeIn(self)]

    def RemovalOf(self, *args, **kwargs):
        return [mn.FadeOut(self)]
