from __future__ import annotations

from itertools import pairwise, zip_longest
from typing import Tuple, Iterable, Any

from euclidlib.Objects.EucidMObject import *
from . import EucidGroupMObject as G
from . import Line as L
from . import Point as P
from . import Angel as A

EPSILON = mn_scale(1)


class EuclidPolygon(G.PsuedoGroup, EMObject, mn.Polygon):
    def IN(self, v: Vect3):
        center = self.get_center_of_mass()
        direction = center - v
        return mn.normalize(direction)

    def OUT(self, v: Vect3):
        center = self.get_center_of_mass()
        direction = v - center
        return mn.normalize(direction)

    @classmethod
    def assemble(cls,
                 lines: None | List[L.EuclidLine] | str = None,
                 points: None | List[P.EuclidPoint] | str = None,
                 angles: None | List[A.EuclidAngleBase] = None,
                 **kwargs):
        if points:
            if isinstance(points, str):
                points = P.EuclidPoint.find_in_frame(points)
            coords = [p.get_center() for p in points]
        elif lines:
            if isinstance(lines, str):
                lines = L.EuclidLine.find_in_frame(lines, loop=True)
            tmp_lines = lines + [lines[0]]
            coords = []
            for l1, l2 in pairwise(tmp_lines):
                common, _, _ = A.angle_coords(l1, l2)
                if common is None:
                    mn.log.warning("Your polygon lines should touch each other!")
                    return
                coords.append(common)
        else:
            mn.log.warning("Need to provide lines or points")
            return

        return cls(*coords, **kwargs, _assemble_flag=True, _lines=lines, _points=points, _angles=angles)

    def __init__(
            self, *points: mn.Vect3 | mn.Mobject | str,
            speed: float = 1,
            point_labels: Sized[Tuple[Any, ...]] | Sized[str] | None = None,
            labels: Sized[Tuple[str, Vect3] | str | None] | None = None,
            angles: List | None = None,
            angle_sizes: List | None = None,
            fill: mn.Color = None,
            z_index=-1,
            animate_part=('set_e_fill',),
            delay_anim=False,
            _assemble_flag=False,
            _lines: List[L.EuclidLine] | None = None,
            _points: List[P.EuclidPoint] | None = None,
            _angles: List[A.EuclidAngleBase] | None = None,
            **kwargs
    ):
        if points and isinstance(points[0], str):
            point_names = list(points[0])
            points = P.EuclidPoint.find_in_frame(point_names)

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
        if _assemble_flag and _lines:
            self.lines: List[L.EuclidLine] = _lines
        else:
            self.lines: List[L.EuclidLine] = []

        if _assemble_flag and _points:
            self.points: List[P.EuclidPoint] = _points
        else:
            self.points: List[P.EuclidPoint] = []

        if _assemble_flag and _angles:
            self.angles: List[A.EuclidAngleBase] = _angles
        else:
            self.angles: List[A.EuclidAngleBase | None] = [None] * self.sides

        super().__init__(*self.vertices, stroke_width=0, z_index=z_index, animate_part=animate_part, **kwargs)
        if self.sides:
            self.vertices.append(self.vertices[0])
        self.define_sub_objs(delay_anim)
        self.cached_opacity = 0
        self.cached_fade = 1

        if _assemble_flag:
            with self.scene.simultaneous():
                if _lines:
                    for l in _lines:
                        l.e_normal()

                if _points:
                    for p in _points:
                        p.e_normal()

                if _angles:
                    for a in _angles:
                        if a is not None:
                            a.e_normal()

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

    def _filter_point_labels(self, args):
        if args is None:
            return None
        if isinstance(args, str):
            args = (args,)
        if len(args) == 1:
            args = *args, dict(away_from='center')
        if not (args and isinstance(args[-1], dict)):
            return args
        for x in ('away_from', 'towards'):
            if isinstance(y := args[-1].get(x), str) and y == 'center_f':
                args[-1][x] = self.get_center_of_mass
            if isinstance(y, str) and y == 'center':
                args[-1][x] = self.get_center_of_mass()
        return args

    def _filter_side_labels(self, args):
        if args is None:
            return None
        if isinstance(args, str):
            args = (args,)
        if len(args) == 1:
            args = *args, dict(outside=True)
        return args

    def define_points(self, delay_anim=False):
        if self.points:
            return
        labels = self.options.get('point_labels', [()] * self.sides)
        with self.scene.simultaneous_speed(self.speed):
            self.points = [
                P.EuclidPoint(coord,
                              scene=self.scene,
                              label_args=self._filter_point_labels(args),
                              delay_anim=delay_anim,
                              )
                for coord, args
                in zip(self.vertices, labels)]

    def define_lines(self, delay_anim=False):
        if self.lines:
            return
        with self.scene.simultaneous_speed(self.speed):
            self.lines = [L.EuclidLine(p0, p1, delay_anim=delay_anim) for p0, p1 in pairwise(self.vertices)]

    def define_sub_objs(self, delay_anim=False):
        self.define_points(delay_anim=delay_anim)
        self.define_lines(delay_anim=delay_anim)

        self._sub_group.add(*self.lines, *self.points)

        with self.scene.simultaneous_speed(self.speed):
            if 'labels' in self.options:
                self.set_labels(*self.options['labels'])
        with self.scene.simultaneous_speed(self.speed):
            if 'angles' in self.options:
                self.set_angles(*self.options['angles'], delay_anim=delay_anim)

    def e_fill(self, color: ManimColor = None, opacity=0.5):
        self.scene.play(
            self.animate.set_fill(color=color, opacity=opacity * self.cached_fade, recurse=False)
        )
        self.cached_opacity = opacity
        return self

    def e_unfill(self):
        return self.e_fill(opacity=0)

    def set_labels(self, *labels: Tuple[Any, ...] | str):
        for l, label_data in zip(self.lines, labels):
            label_data = self._filter_side_labels(label_data)
            if label_data:
                l.add_label(*label_data)
        return self

    def set_point_labels(self, *labels: Tuple[Any, ...]):
        for p, label_data in zip(self.points, labels):
            label_data = self._filter_point_labels(label_data)
            p.add_label(*label_data)
        return self

    def set_angles(self, *angle_data: str | float | None, delay_anim=False):
        names, sizes = angle_data[:self.sides], angle_data[self.sides:]
        names_and_sizes = zip_longest(names, sizes, fillvalue=mn_scale(40))
        line_pairs = pairwise([self.lines[-1]] + self.lines)

        if not self.angles:
            self.angles = [
                A.EuclidAngle(l1, l2, size=size, label_args=name, scene=self.scene, delay_anim=delay_anim)
                for (l1, l2), (name, size) in zip(line_pairs, names_and_sizes)
                if name is not None
            ]
            self._sub_group.add(*self.angles)
        else:
            for i, ((l1, l2), (name, size)) in enumerate(zip(line_pairs, names_and_sizes)):
                if not name:
                    continue
                old = self.angles[i]
                if old is not None:
                    old.e_remove()
                    self._sub_group.remove(old)
                self.angles[i] = A.EuclidAngle(l1, l2, size=size, label_args=name, scene=self.scene)
                self._sub_group.add(self.angles[i])
        return self

    def remove_angles(self):
        if self.a is None:
            return
        for a in self.a:
            if a is not None:
                a.e_remove()

    def draw_angles(self):
        if self.a is None:
            return
        for a in self.a:
            if a is not None:
                a.e_draw()

    @property
    def l(self):
        return self.lines

    @property
    def p(self):
        return self.points

    @property
    def a(self):
        return self.angles

    @property
    def v(self):
        return self.vertices

    def replace_line(self, index, newline: L.EuclidLine):
        self.lines[index].e_delete()
        self.lines[index] = newline
        self._sub_group.set_submobjects([*self.lines, *self.points, *(a for a in self.angles if a is not None)])

    def replace_point(self, index, newpoint: P.EuclidPoint):
        self.points[index].e_delete()
        self.points[index] = newpoint
        self._sub_group.set_submobjects([*self.lines, *self.points, *(a for a in self.angles if a is not None)])

    def move_point_to(self, index: int, dest: P.EuclidPoint | Vect3):
        dest = convert_to_coord(dest)
        self.vertices[index] = dest
        self.vertices[-1] = self.vertices[0]

        all_parts = [*self.p, *self.a, *self.l]
        all_labels = [a.e_label for a in all_parts if a.e_label is not None]

        for label in all_labels:
            label.enable_updaters()

        with self.scene.simultaneous():
            pass
            self.scene.play(self.p[index].animate.move_to(dest))
            self.scene.play(self.l[index].animate.put_start_and_end_on(dest, self.l[index].get_end()))
            self.scene.play(self.l[(index - 1) % self.sides].animate.put_start_and_end_on(
                self.l[(index - 1) % self.sides].get_start(), dest))

            for i in range(self.sides):
                if self.angles[i] is not None:
                    old_angle = self.angles[i]
                    l1 = L.VirtualLine(self.vertices[(i - 1) % self.sides], self.vertices[i])
                    l2 = L.VirtualLine(self.vertices[i], self.vertices[i + 1])
                    new_angle = A.EuclidAngle(l1, l2, size=old_angle.size, delay_anim=True)
                    self.scene.play(mn.Transform(old_angle, new_angle))
                    l2.e_remove()
                    l1.e_remove()
        self.vertices[index] = dest
        self.vertices[-1] = self.vertices[0]
        self.scene.play(self.animate.set_points_as_corners(self.vertices))
        for label in all_labels:
            label.disable_updaters()

    def CreationOf(self, *args, **kwargs):
        return [mn.FadeIn(self)]

    def RemovalOf(self, *args, **kwargs):
        return [mn.FadeOut(self)]
