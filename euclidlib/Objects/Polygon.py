from __future__ import annotations
from typing_extensions import Unpack

from itertools import pairwise, zip_longest
from typing import Tuple, Iterable, Any, Dict, TypedDict

from euclidlib.Objects.EucidMObject import *
from . import EucidGroupMObject as G
from . import Line as L
from . import Point as P
from . import Angel as A

EPSILON = mn_scale(1)

LABEL_ARG = (None | str |
             Tuple[str, Unpack[tuple[Any, ...]], Dict[str, Any]] |
             Tuple[str, Unpack[tuple[Any, ...]]])

LABEL_ARGS = Iterable[LABEL_ARG]

FULL_ANGLES_ARG = (Tuple[LABEL_ARG] |
                   Tuple[LABEL_ARG, LABEL_ARG] |
                   Tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG] |
                   Tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG, float] |
                   Tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG, float, float] |
                   Tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG, float, float, float])

ANGLE_ARGS = (Tuple[LABEL_ARG] |
              Tuple[LABEL_ARG, LABEL_ARG] |
              Tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG])
ANGLE_SIZE_ARGS = (Tuple[float] |
                   Tuple[float, float] |
                   Tuple[float, float, float])


class OPTIONS(TypedDict):
    point_labels: LABEL_ARG
    labels: LABEL_ARG
    angles: FULL_ANGLES_ARG
    fill: Tuple[mn.Color, float] | None


class EPolygon(G.PsuedoGroup, EMObject, mn.Polygon):
    MAX_SIZE = 0

    def IN(self, v: Vect3):
        center = self.get_center_of_mass()
        direction = center - v
        return mn.normalize(direction)

    def OUT(self, v: Vect3):
        center = self.get_center_of_mass()
        direction = v - center
        return mn.normalize(direction)

    @classmethod
    def update_size(cls, sizes):
        if cls.MAX_SIZE >= sizes:
            return
        for i in range(cls.MAX_SIZE, sizes):
            exec(f"""
def l(self):
    return self.l[{i}]
def a(self):
    return self.a[{i}]
def p(self):
    return self.p[{i}]
setattr(cls, 'l{i}', property(l))
setattr(cls, 'a{i}', property(a))
setattr(cls, 'p{i}', property(p))
            """)
        cls.MAX_SIZE = sizes

    @classmethod
    def assemble(cls,
                 lines: None | List[L.ELine] | str = None,
                 points: None | List[P.EPoint] | str = None,
                 angles: None | List[A.EAngleBase] = None,
                 **kwargs):
        if points:
            if isinstance(points, str):
                points = P.EPoint.find_in_frame(points)
            coords = [p.get_center() for p in points]
        elif lines:
            if isinstance(lines, str):
                lines = L.ELine.find_in_frame(lines, loop=True)
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
            point_labels: LABEL_ARG | None = None,
            labels: LABEL_ARG | None = None,
            angles: ANGLE_ARGS | None = None,
            angle_sizes: ANGLE_SIZE_ARGS | None = None,
            fill: mn.Color = None,
            z_index=-1,
            animate_part=('set_e_fill',),
            delay_anim=False,
            skip_anim=False,
            _assemble_flag=False,
            _lines: List[L.ELine] | None = None,
            _points: List[P.EPoint] | None = None,
            _angles: List[A.EAngleBase | None] | None = None,
            **kwargs
    ):
        if points and isinstance(points[0], str):
            point_names = list(points[0])
            points = P.EPoint.find_in_frame(point_names)

        if all(isinstance(p, L.ELine) for p in points):
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


        self.options: OPTIONS = {
            k: locals()[k]
            for k in ('point_labels', 'labels', 'angles', 'fill')
            if locals()[k] is not None
        }
        self.speed = speed
        self.vertices = [convert_to_coord(p) for p in points]
        self.sides = len(self.vertices)
        self.update_size(self.sides)
        if _assemble_flag and _lines:
            self.lines: List[L.ELine] = _lines
        else:
            self.lines: List[L.ELine] = []

        if _assemble_flag and _points:
            self.points: List[P.EPoint] = _points
        else:
            self.points: List[P.EPoint] = []

        if _assemble_flag and _angles:
            self.angles: List[A.EAngleBase | None] = _angles
        else:
            self.angles: List[A.EAngleBase | None] = [None] * self.sides

        super().__init__(*self.vertices, stroke_width=0, z_index=z_index, animate_part=animate_part,
                         delay_anim=delay_anim, skip_anim=skip_anim, **kwargs)
        if self.sides:
            self.vertices.append(self.vertices[0])
        self.define_sub_objs(delay_anim, skip_anim)
        if 'fill' in self.options:
            if delay_anim:
                self.set_fill(*self.options['fill'])
            else:
                self.e_fill(*self.options['fill'])

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


    def e_fill(self, color: ManimColor = None, opacity=0.5):
        self.options['fill'] = (color, opacity)
        super().e_fill(color, opacity)

    def e_unfill(self):
        del self.options['fill']
        super().e_unfill()

    def get_group(self):
        return mn.VGroup(*self.l, *self.p, *(a for a in self.a if a is not None))

    def _filter_point_labels(self, args: LABEL_ARG):
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

    @staticmethod
    def _filter_point_labels_with_center(args: LABEL_ARG, center):
        if args is None:
            return None
        if isinstance(args, str):
            args = (args,)
        if len(args) == 1:
            args = *args, dict(away_from='center')
        if not (args and isinstance(args[-1], dict)):
            return args
        for x in ('away_from', 'towards'):
            if isinstance(y := args[-1].get(x), str) and y == 'center':
                args[-1][x] = center
        return args

    @staticmethod
    def _filter_side_labels(args: LABEL_ARG):
        if args is None:
            return None
        if isinstance(args, str):
            args = (args,)
        if len(args) == 1:
            args = *args, dict(outside=True)
        return args

    def define_points(self, delay_anim=False, skip_anim=False):
        if self.points:
            return
        labels = self.options.get('point_labels', [()] * self.sides)
        with self.scene.simultaneous_speed(self.speed):
            self.points = [
                P.EPoint(coord,
                         scene=self.scene,
                         label_args=self._filter_point_labels(args),
                         delay_anim=delay_anim,
                         skip_anim=skip_anim,
                         )
                for coord, args
                in zip(self.vertices, labels)]

    def define_lines(self, delay_anim=False, skip_anim=False):
        if self.lines:
            return
        with self.scene.simultaneous_speed(self.speed):
            self.lines = [L.ELine(p0, p1, delay_anim=True) for p0, p1 in pairwise(self.vertices)]
            if 'labels' in self.options:
                self.set_labels(*self.options['labels'])
            if not delay_anim:
                for l in self.lines:
                    l.e_draw(skip_anim=skip_anim)

    def define_sub_objs(self, delay_anim=False, skip_anim=False):
        self.define_points(delay_anim=delay_anim, skip_anim=skip_anim)
        self.define_lines(delay_anim=delay_anim, skip_anim=skip_anim)

        with self.scene.simultaneous_speed(self.speed):
            if 'angles' in self.options:
                self.set_angles(*self.options['angles'], delay_anim=delay_anim, skip_anim=skip_anim)

    def set_labels(self, *labels: LABEL_ARG):
        for l, label_data in zip(self.lines, labels):
            label_data = self._filter_side_labels(label_data)
            if label_data:
                l.add_label(*label_data)
        return self

    def set_point_labels(self, *labels: LABEL_ARG):
        for p, label_data in zip(self.points, labels):
            label_data = self._filter_point_labels(label_data)
            p.add_label(*label_data)
        return self

    def set_angles(self, *angle_data: str | float | None, delay_anim=False, skip_anim=False):
        names, sizes = angle_data[:self.sides], angle_data[self.sides:]
        names_and_sizes = zip_longest(names, sizes, fillvalue=mn_scale(40))
        line_pairs = pairwise([self.lines[-1]] + self.lines)

        if not self.angles:
            self.angles = [
                A.EAngle(l1, l2, size=size, label_args=name, scene=self.scene, delay_anim=delay_anim,
                         skip_anim=skip_anim)
                for (l1, l2), (name, size) in zip(line_pairs, names_and_sizes)
                if name is not None
            ]
        else:
            for i, ((l1, l2), (name, size)) in enumerate(zip(line_pairs, names_and_sizes)):
                if not name:
                    continue
                old = self.angles[i]
                if old is not None:
                    old.e_remove()
                self.angles[i] = A.EAngle(l1, l2, size=size, label_args=name, scene=self.scene)
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

    if TYPE_CHECKING:
        l0: L.ELine
        l1: L.ELine
        l2: L.ELine
        l3: L.ELine
        l4: L.ELine
        a0: A.EAngleBase
        a1: A.EAngleBase
        a2: A.EAngleBase
        a3: A.EAngleBase
        a4: A.EAngleBase
        p0: P.EPoint
        p1: P.EPoint
        p2: P.EPoint
        p3: P.EPoint
        p4: P.EPoint

    def highlight(self):
        return self.animate(rate_func=mn.there_and_back).set_fill(RED, opacity=1)

    def replace_line(self, index, newline: L.ELine):
        self.lines[index].e_delete()
        self.lines[index] = newline

    def replace_point(self, index, newpoint: P.EPoint):
        self.points[index].e_delete()
        self.points[index] = newpoint

    def move_point_to(self, index: int, dest: P.EPoint | Vect3):
        if hasattr(self, '_angle_values'):
            del self._angle_values
        dest = convert_to_coord(dest)
        self.vertices[index] = dest
        self.vertices[-1] = self.vertices[0]

        all_parts = [*self.p, *self.a, *self.l]
        all_labels = [a.e_label for a in all_parts if a is not None and a.e_label is not None]

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
                    new_angle = A.EAngle(l1, l2, size=old_angle.size, delay_anim=True)
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

    def intersect(self, other: Mobject, reverse=True):
        if isinstance(other, mn.Rectangle):
            return self.intersect_selection(other)
        super().intersect(other)

    def intersect_selection(self, other: mn.Rectangle):
        return False

    def transform_to(self, other: Self, *sub_animations, anim: Type[mn.Animation] = mn.TransformFromCopy):
        line_transforms = [us.transform_to(them, anim=anim) for us, them in zip(self.l, other.lines)]
        point_transforms = [us.transform_to(them, anim=anim) for us, them in zip(self.p, other.points)]
        angle_transforms = [us.transform_to(them, anim=anim)
                            for us, them in zip(self.a, other.angles) 
                            if us is not None and them is not None]
        return super().transform_to(other, *line_transforms, *point_transforms, *angle_transforms, *sub_animations, anim=anim)


    @log
    @copy_transform()
    def copy_to_parallelogram_on_point(self, point: P.EPoint, angle: A.EAngleBase, /, negative=False):
        coords = convert_to_coord(point)
        line = L.ELine(coords, coords + mn_scale(200 if not negative else -200, 0, 0))
        para = self.copy_to_parallelogram_on_line(line, angle, speed=0)
        line.e_remove()
        return para

    @log
    @copy_transform()
    def copy_to_parallelogram_on_line(self, line: L.ELine, angle: A.EAngleBase):
        # ------------------------------------------------------------------------
        # get a list of triangles that make up the polygon
        # ------------------------------------------------------------------------
        triangles = self.copy_to_triangles(speed=0)

        # ------------------------------------------------------------------------
        # convert each triangle to a parallelogram
        # ------------------------------------------------------------------------
        parallels = []

        current_line = line.copy()
        coords = current_line.get_start_and_end()
        for tri in triangles:
            tri.e_fill(RED)
            with self.scene.pause_animations_for():
                parallels.append(tri.copy_to_parallelogram_on_line(current_line, angle, speed=0))

            with self.scene.simultaneous():
                parallels[-1].e_draw()
                tri.e_remove()
            current_line.e_delete()
            current_line = L.ELine(*reversed(parallels[-1].l[2].get_start_and_end()),
                                   skip_anim=True,
                                   stroke_color=RED)
        current_line.e_delete()
        from . import Parallelogram as Para
        poly = Para.EParallelogram(*coords, *reversed(current_line.get_start_and_end()))
        with self.scene.simultaneous():
            for x in parallels:
                x.e_remove()
        return poly

    @log
    @anim_speed
    def copy_to_triangles(self):
        from . import Triangle as Tri
        triangles = []
        sides = self.sides
        coords = [p.get_center() for p in self.points]
        new = EPolygon(*coords)
        while sides > 3:
            # calculate the index with the most 'narrow' extension
            min_index, min_angle = min(enumerate(self.angle_values), key=lambda a: a[1])

            # chop this section off - step 1 calculate points
            if min_index == self.sides - 1:
                triangle_points = [new.p[min_index - 1], new.p[min_index], new.p[0]]
                new_points = new.p[:-1]
            elif min_index == 0:
                triangle_points = [new.p[sides - 1], new.p[min_index], new.p[min_index + 1]]
                new_points = new.p[1:]
            else:
                triangle_points = [new.p[min_index + x] for x in (-1, 0, 1)]
                new_points = new.p[:min_index] + new.p[min_index + 1:]

            # create and save new triangle, update polygon
            triangles.append(Tri.ETriangle(*triangle_points))
            new2 = EPolygon(*new_points, delay_anim=True)
            self.scene.play(mn.ReplacementTransform(new, new2))
            new = new2
            sides = new.sides

        last = Tri.ETriangle(*new.p)
        new.e_remove()
        triangles.append(last)
        return triangles

    @property
    def angle_values(self):
        if not hasattr(self, '_angle_values'):
            self._calculate_angle_values()
        return self._angle_values

    def _calculate_angle_values(self):
        # clockwise
        values = list(A.calculateAngle(l1, l2) for l1, l2 in pairwise([self.lines[-1]] + self.lines))

        # counter_clockwise
        if sum(values) > (self.sides - 2) * PI:
            values = list(A.calculateAngle(l2, l1) for l1, l2 in pairwise([self.lines[-1]] + self.lines))
        self._angle_values = values

    @log
    @copy_transform()
    def copy_to_rectangle(self, point: EMObject | Vect3):
        # need a right angle
        with self.scene.simultaneous():
            l1 = L.ELine(LEFT, ORIGIN).e_fade()
            l2 = L.ELine(LEFT, UL).e_fade()
        right = A.EAngle(l1, l2)
        with self.scene.simultaneous():
            l1.e_remove()
            l2.e_remove()

        # create parallelogram
        pll = self.copy_to_parallelogram_on_point(point, right, speed=0)
        right.e_remove()

        # - points might not be exactly square, due to round offs, or slight
        #   misalignment, so fix it.
        p = pll.vertices
        p[2][0] = p[1][0]
        p[3][0] = p[0][0]
        p[1][1] = p[0][1]
        p[3][1] = p[2][1]

        rect = EPolygon(*p, delay_anim=True)
        self.scene.play(mn.ReplacementTransform(pll, rect))
        return rect

    def reposition(self, *new_coords, anim=False):
        assert(len(self.points) == len(new_coords))
        new_poly = EPolygon(*new_coords, **self.options, delay_anim=True)
        if anim:
            self.scene.play(self.transform_to(new_poly, anim=mn.ReplacementTransform))
        else:
            self.scene.remove(*self.get_e_family())
        self.lines = new_poly.lines
        self.angles = new_poly.angles
        self.points = new_poly.points
        self.become(new_poly)
        self.scene.add(*self.get_e_family())
        if anim:
            self.scene.remove(new_poly)


    def area(self) -> float:
        return self.get_arc_length()
