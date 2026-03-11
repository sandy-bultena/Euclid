from __future__ import annotations
from typing_extensions import Unpack

from itertools import pairwise, zip_longest, chain, repeat
from typing import  Any,  TypedDict, TYPE_CHECKING, Optional

from euclidlib.Objects.em_object_base import *
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Utilities.coordinate_utilities import mn_scale, convert_to_coord, mn_coord, euclid_coord
from . import Triangle as Tri

from . import em_group_object as GroupObject

from . import Line
from . import Point
from . import Angle

EPSILON = mn_scale(1)

LABEL_ARG = (None | str |
             tuple[str, Unpack[tuple[Any, ...]], dict[str, Any]] |
             tuple[str, Unpack[tuple[Any, ...]]])

LABEL_ARGS = Iterable[LABEL_ARG]

FULL_ANGLES_ARG = (tuple[LABEL_ARG] |
                   tuple[LABEL_ARG, LABEL_ARG] |
                   tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG] |
                   tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG, float] |
                   tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG, float, float] |
                   tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG, float, float, float])

ANGLE_ARGS = (tuple[LABEL_ARG] |
              tuple[LABEL_ARG, LABEL_ARG] |
              tuple[LABEL_ARG, LABEL_ARG, LABEL_ARG])
ANGLE_SIZE_ARGS = (tuple[float] |
                   tuple[float, float] |
                   tuple[float, float, float])


class OPTIONS(TypedDict):
    point_labels: LABEL_ARG
    labels: LABEL_ARG
    angle_info: FULL_ANGLES_ARG
    fill: tuple[mn.Color, float] | None


# ---------------------------------------------------------------------------------------------------------------
# find the common vertices between lines (for forming a polygon)
# ---------------------------------------------------------------------------------------------------------------
def find_vertices(*lines: Line.ELine) -> Optional[list[mn.Vect3]]:
    coords = []
    for l1, l2 in pairwise((*lines, lines[0])):
        common, _, _ = Angle.angle_coords(l1, l2)
        if common is None:
            mn.log.warning("Your polygon lines should touch each other!")
            return []
        coords.append(common)
    return coords


# ===================================================================================================================
# EPolygon
# ===================================================================================================================
class EPolygon(GroupObject.EGroupedObjects, EMObject, mn.Polygon):
    _area: float | None

    MAX_SIZE = 0

    # ---------------------------------------------------------------------------------------------------------------
    # vectors
    # ---------------------------------------------------------------------------------------------------------------
    def IN(self, v: mn.Vect3):
        center = self.get_center_of_mass()
        direction = center - v
        return mn.normalize(direction)

    def OUT(self, v: mn.Vect3):
        center = self.get_center_of_mass()
        direction = v - center
        return mn.normalize(direction)

    # ---------------------------------------------------------------------------------------------------------------
    # change the size of the polygon - create properties l0,l1,l2 etc
    # ---------------------------------------------------------------------------------------------------------------
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

    # ---------------------------------------------------------------------------------------------------------------
    # assemble
    # ---------------------------------------------------------------------------------------------------------------
    @classmethod
    def assemble(cls,
                 lines: Optional[ list[Line.ELine] ] = None,
                 points: Optional[ list[Point.EPoint] ] = None,
                 angles: Optional[ list[Angle.EAngleBase]] = None,
                 **kwargs) -> Optional[EPolygon]:
        """
        Given line, point and angle objects, assemble them into a polygon object
        :param lines: a list of lines (in order) that define the polygon shape
        :param points: a list of points that define the polygon vertices
        :param angles: a list of angles that are part of the polygon
        :param kwargs: animation arguments
        :return: If the number of sides of the polygon equals the number of specified lines,
                and all the lines connect to one another appropriately, then EPolygon, else None
        """

        # if points were defined, get the coordinates of the vertices
        if points:
            coords = [p.get_center() for p in points]

        # if lines were defined, find the vertices where the lines touch
        elif lines:
            coords = find_vertices(*lines)
            if len(coords) == 0:
                return None
        else:
            mn.log.warning("Need to provide lines or points")
            return

        return cls(*coords, **kwargs, _assemble_flag=True, _lines=lines, _points=points, _angles=angles)

    # ---------------------------------------------------------------------------------------------------------------
    # constructor
    # ---------------------------------------------------------------------------------------------------------------
    def __init__(
            self, *points: mn.Vect3 | mn.Mobject | str,
            speed = None,
            point_labels: LABEL_ARG | None = None,
            labels: LABEL_ARG | None = None,
            angle_info: ANGLE_ARGS | None = None,
            fill: tuple[mn.Color, float] | None = None,
            z_index=-1,
            animate_part=('set_e_fill',),
            delay_anim=False,
            skip_anim=False,
            _assemble_flag=False,
            _lines: list[Line.ELine] | None = None,
            _points: list[Point.EPoint] | None = None,
            _angles: list[Angle.EAngleBase | None] | None = None,
            **kwargs
    ):
        """
        Create a polygon
        :param points: coordinates or EPoint
        :param speed: how fast to draw
        :param point_labels: labels for the points
        :param labels: labels for the lines
        :param angle_info: labels for each angle
        :param fill: what colour to fill the polygon, or colour, opacity
        :param z_index: where is this (on top of all others, below, etc)
        :param animate_part:
        :param delay_anim:
        :param skip_anim:
        :param kwargs:
        """

        # ------------------------------------------------------------------------------------------------------------
        #  save the vertices as coordinates
        # ------------------------------------------------------------------------------------------------------------
        # if lines were given instead of points, find the coordinates for the points
        # if all(isinstance(p, Line.ELine) for p in points):
        #     lines = [p for p in points]
        #     points = find_vertices(lines)
        # assert (points is not None)

        # save the vertices in self (coordinates, not EPoints)
        self.vertices = [convert_to_coord(p) for p in points]
        self.sides = len(self.vertices)
        self.update_size(self.sides)
        if self.sides:
            self.vertices.append(self.vertices[0])

        # ------------------------------------------------------------------------------------------------------------
        # create an options dictionary for point_labels, labels, angle_info and fill
        # ------------------------------------------------------------------------------------------------------------
        self.options: OPTIONS = {
            k: locals()[k]
            for k in ('point_labels', 'labels', 'angle_info', 'fill')
            if locals()[k] is not None
        }

        # ------------------------------------------------------------------------------------------------------------
        # define the speed (use current speed as default value)
        # ------------------------------------------------------------------------------------------------------------
        self.speed = speed
        if self.speed is None:
            scene = find_scene()
            self.speed = scene.get_current_speed()

        # ------------------------------------------------------------------------------------------------------------
        # if this polygon is built with pre-existing objects, save them
        # ------------------------------------------------------------------------------------------------------------
        self.lines: list[Line.ELine] = _lines if _assemble_flag and _lines else []
        self.points: list[Point.EPoint] = _points if _assemble_flag and _points else []
        self.angles: list[Angle.EAngleBase | None] = _angles if _assemble_flag and _angles else [None] * self.sides

        # ------------------------------------------------------------------------------------------------------------
        # create the generic EObject
        # ------------------------------------------------------------------------------------------------------------
        super().__init__(*self.vertices, stroke_width=0, z_index=z_index, animate_part=animate_part,
                         delay_anim=delay_anim, skip_anim=skip_anim, **kwargs)


        # ------------------------------------------------------------------------------------------------------------
        # create all the lines, points, etc, if they don't already exist
        # ------------------------------------------------------------------------------------------------------------
        self.define_sub_objs(delay_anim, skip_anim)

        # if lines etc already exist (via _assemble_flag), then set them all back to normal (no fade)
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


        # ------------------------------------------------------------------------------------------------------------
        # fill the polygon with colour
        # ------------------------------------------------------------------------------------------------------------
        if 'fill' in self.options:
            fill_option = self.options['fill']
            if isinstance(fill_option,str):
                fill_option = (fill_option,)
            if delay_anim:
                self.set_fill(*fill_option)
            else:
                self.e_fill(*fill_option)


    # ---------------------------------------------------------------------------------------------------------------
    # properties
    # ---------------------------------------------------------------------------------------------------------------
    @property
    def l(self)->list[Line.ELine]:
        return self.lines

    @property
    def p(self)->list[Point.EPoint]:
        return self.points

    @property
    def a(self)->list[Angle.EAngle]:
        return self.angles

    @property
    def v(self)->list[mn.Vect3]:
        return self.vertices

    if TYPE_CHECKING:
        l0: Line.ELine
        l1: Line.ELine
        l2: Line.ELine
        l3: Line.ELine
        l4: Line.ELine
        a0: Angle.EAngleBase
        a1: Angle.EAngleBase
        a2: Angle.EAngleBase
        a3: Angle.EAngleBase
        a4: Angle.EAngleBase
        p0: Point.EPoint
        p1: Point.EPoint
        p2: Point.EPoint
        p3: Point.EPoint
        p4: Point.EPoint

    # ---------------------------------------------------------------------------------------------------------------
    # fill and unfill
    # ---------------------------------------------------------------------------------------------------------------
    def e_fill(self, color: mn.ManimColor = None, opacity=1):
        self.options['fill'] = (color, opacity)
        return super().e_fill(color, opacity)

    def e_unfill(self):
        try:
            del self.options['fill']
            super().e_unfill()
        except KeyError:
            pass

    # ---------------------------------------------------------------------------------------------------------------
    # required for EGroupedObjects to return all the parts that make up the polygon
    # ---------------------------------------------------------------------------------------------------------------
    def get_group(self):
        return mn.VGroup(*self.l, *self.p, *(a for a in self.a if a is not None))

    # ---------------------------------------------------------------------------------------------------------------
    # define the lines and points and maybe angles of the polygon
    # ---------------------------------------------------------------------------------------------------------------
    def define_sub_objs(self, delay_anim=False, skip_anim=False):
        self.define_points(delay_anim=delay_anim, skip_anim=skip_anim)
        self.define_lines(delay_anim=delay_anim, skip_anim=skip_anim)

        with self.scene.simultaneous_speed(self.speed):
            if 'angle_info' in self.options:
                names, sizes = self.options['angle_info'][:self.sides], self.options['angle_info'][self.sides:]
                self.set_angles(names, sizes, delay_anim=delay_anim, skip_anim=skip_anim)

    # ---------------------------------------------------------------------------------------------------------------
    # define points
    # ---------------------------------------------------------------------------------------------------------------
    def define_points(self, delay_anim=False, skip_anim=False):

        # points already exist, do nothing
        if self.points:
            return

        # default labels is undefined
        labels = self.options.get('point_labels', [()] * self.sides)

        # create all the points
        with self.scene.simultaneous_speed(self.speed):
            self.points = [
                Point.EPoint(coord,
                         scene=self.scene,
                         label=self._filter_point_labels(args),
                         delay_anim=delay_anim,
                         skip_anim=skip_anim,
                         )
                for coord, args
                in zip(self.vertices, labels)]

    # ---------------------------------------------------------------------------------------------------------------
    # define lines
    # ---------------------------------------------------------------------------------------------------------------
    def define_lines(self, delay_anim=False, skip_anim=False):
        if self.lines:
            return
        with self.scene.simultaneous_speed(self.speed):
            labels = self.options.get('labels', [()] * self.sides)
            line_points = [(p0,p1) for p0,p1 in pairwise(self.vertices)]
            self.lines = [Line.ELine(*pts,
                                  delay_anim=True,
                                  label=self._filter_side_labels(args)
                                  )
                          for pts,args in zip(line_points,labels)]
            if not delay_anim:
                for l in self.lines:
                    l.e_draw(skip_anim=skip_anim)

    # ----------------------------------------------------------------------------------------------------------------
    # set up the angles
    # ----------------------------------------------------------------------------------------------------------------
    def set_angles(self, names: list[str], sizes: float[str] = None, delay_anim=False, skip_anim=False):
        sizes = [] if sizes is None else sizes
        names = names if names is not None else []

        names_and_sizes = zip_longest(names, sizes, fillvalue=ANGLE_SIZE)
        line_pairs = pairwise([self.lines[-1]] + self.lines)

        if not self.angles:
            self.angles = [
                Angle.EAngle(l1, l2, size=size, label=name, scene=self.scene, delay_anim=delay_anim,
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
                self.angles[i] = Angle.EAngle(l1, l2, size=size, label=name, scene=self.scene)
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # set line labels
    # ----------------------------------------------------------------------------------------------------------------
    def set_labels(self, *labels: LABEL_ARG):
        for l, label_data in zip(self.lines, labels):
            label_data = self._filter_side_labels(label_data)
            if label_data:
                l.add_label(*label_data)
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # set point labels
    # ----------------------------------------------------------------------------------------------------------------
    def set_point_labels(self, *labels: LABEL_ARG):
        for p, label_data in zip_longest(self.points, labels, fillvalue=None):
            label_data = self._filter_point_labels(label_data)
            if label_data:
                p.add_label(*label_data)
        return self

    # ----------------------------------------------------------------------------------------------------------------
    # convert point label args to either (str,) or (str,dict) or (str,str)
    # ----------------------------------------------------------------------------------------------------------------
    def _filter_point_labels(self, args: LABEL_ARG):
        return EPolygon._filter_point_labels_with_center(args, self.get_center_of_mass())

    # ----------------------------------------------------------------------------------------------------------------
    # filter label arguments to be compatible with what is required for add_label
    # ----------------------------------------------------------------------------------------------------------------
    @staticmethod
    def _filter_point_labels_with_center(args: LABEL_ARG, center):

        # no labels, do nothing
        if args is None:
            return None

        # if its a single string, turn it into a tuple
        if isinstance(args, str):
            args = (args,)

        # if direction is not specified, default to away_from='center'
        if len(args) == 1:
            args = *args, dict(away_from='center')

        # if args doesn't have a dictionary at the end, just return args
        if not (args and isinstance(args[-1], dict)):
            return args

        # if away_from=center or towards=center, replace center with the coordinates of the center of mass
        for x in ('away_from', 'towards'):
            if isinstance(y := args[-1].get(x), str) and y == 'center':
                args[-1][x] = center
        return args

    # ----------------------------------------------------------------------------------------------------------------
    # filter line labels to be compatible with what is required for add_label
    # ----------------------------------------------------------------------------------------------------------------
    @staticmethod
    def _filter_side_labels(args: LABEL_ARG):
        if args is None:
            return None
        if isinstance(args, str):
            args = (args,)
        if len(args) == 1:
            args = *args, dict(side=Line.LineLabelSide.OUTSIDE)
        return args

    # ----------------------------------------------------------------------------------------------------------------
    # remove angles
    # ----------------------------------------------------------------------------------------------------------------
    def remove_angles(self):
        if self.a is None:
            return
        for a in self.a:
            if a is not None:
                a.e_remove()

    # ----------------------------------------------------------------------------------------------------------------
    # draw angles
    # ----------------------------------------------------------------------------------------------------------------
    def draw_angles(self):
        if self.a is None:
            return
        for a in self.a:
            if a is not None:
                a.e_draw()


    # ----------------------------------------------------------------------------------------------------------------
    # highlight
    # ----------------------------------------------------------------------------------------------------------------
    def highlight(self):
        return self.animate(rate_func=mn.there_and_back).set_fill(mn.RED, opacity=1)

    # ----------------------------------------------------------------------------------------------------------------
    # replace line
    # ----------------------------------------------------------------------------------------------------------------
    def replace_line(self, index, newline: Line.ELine):
        self.lines[index].e_delete()
        self.lines[index] = newline

    # ----------------------------------------------------------------------------------------------------------------
    # replace point
    # ----------------------------------------------------------------------------------------------------------------
    def replace_point(self, index, newpoint: Point.EPoint):
        self.points[index].e_delete()
        self.points[index] = newpoint

    # ----------------------------------------------------------------------------------------------------------------
    # move point (move specific point an update polygon)
    # ----------------------------------------------------------------------------------------------------------------
    def move_point_to(self, index: int, dest: Point.EPoint | mn.Vect3):
        if hasattr(self, '_angle_values'):
            del self._angle_values

        # update stored info
        dest = convert_to_coord(dest)
        self.vertices[index] = dest
        self.vertices[-1] = self.vertices[0]

        # set the label updaters so that the labels move as the lines are modified
        all_parts = [*self.p, *self.a, *self.l]
        all_labels = [a.e_label for a in all_parts if a is not None and a.e_label is not None]

        for label in all_labels:
            label.enable_updaters()

        # move the point, lines, etc as required
        with self.scene.simultaneous():
            self.scene.play(self.p[index].animate.move_to(dest))
            self.scene.play(self.l[index].animate.put_start_and_end_on(dest, self.l[index].get_end()))
            self.scene.play(self.l[(index - 1) % self.sides].animate.put_start_and_end_on(
                self.l[(index - 1) % self.sides].get_start(), dest))

            for i in range(self.sides):
                if self.angles[i] is not None:
                    old_angle = self.angles[i]
                    l1 = Line.VirtualLine(self.vertices[(i - 1) % self.sides], self.vertices[i])
                    l2 = Line.VirtualLine(self.vertices[i], self.vertices[i + 1])
                    new_angle = Angle.EAngle(l1, l2, size=old_angle.size, delay_anim=True)
                    self.scene.play(mn.Transform(old_angle, new_angle))
                    l2.e_remove()
                    l1.e_remove()

            # update the actual Polygon object
            self.scene.play(self.animate.set_points_as_corners(self.vertices))

        for label in all_labels:
            label.disable_updaters()

    # ----------------------------------------------------------------------------------------------------------------
    # Creation/Removal Of
    # ----------------------------------------------------------------------------------------------------------------
    def CreationOf(self, *args, **kwargs):
        return [mn.FadeIn(self)]

    def RemovalOf(self, *args, **kwargs):
        return [mn.FadeOut(self)]

    # ----------------------------------------------------------------------------------------------------------------
    # intersects (to be updated later
    # ----------------------------------------------------------------------------------------------------------------
    def intersect(self, other: mn.Mobject, reverse=True):
        if isinstance(other, mn.Rectangle):
            return self.intersect_selection(other)
        super().intersect(other)

    def intersect_selection(self, other: mn.Rectangle):
        return False

    # ----------------------------------------------------------------------------------------------------------------
    # copy to parallelogram on a point
    # ----------------------------------------------------------------------------------------------------------------
    @log
    @copy_transform()
    def copy_to_parallelogram_on_point(self, point: Point.EPoint, angle: Angle.EAngleBase, /, negative=False):
        coords = convert_to_coord(point)
        line = Line.ELine(coords, coords + mn_scale(200 if not negative else -200, 0, 0))
        para = self.copy_to_parallelogram_on_line(line, angle, speed=0)
        line.e_remove()
        return para

    # ----------------------------------------------------------------------------------------------------------------
    # copy to parallelogram on line
    # ----------------------------------------------------------------------------------------------------------------
    @log
    @copy_transform()
    def copy_to_parallelogram_on_line(self, line: Line.ELine, angle: Angle.EAngleBase):

        # ------------------------------------------------------------------------
        # get a list of triangles that make up the polygon
        # ------------------------------------------------------------------------
        triangles = self.copy_to_triangles()

        # ------------------------------------------------------------------------
        # convert each triangle to a parallelogram
        # ------------------------------------------------------------------------
        parallels = []

        current_line = line.copy()
        coords = current_line.get_start_and_end()
        for tri in triangles:
            tri.e_fill(mn.RED)
            parallels.append(tri.copy_to_parallelogram_on_line(current_line, angle))

            with self.scene.simultaneous():
                parallels[-1].e_draw()
                tri.e_remove()
            current_line.e_delete()
            current_line = Line.ELine(*reversed(parallels[-1].l[2].get_start_and_end()),
                                   skip_anim=True,
                                   stroke_color=mn.RED)
        current_line.e_delete()
        from . import Parallelogram as Para
        poly = Para.EParallelogram(*coords, *reversed(current_line.get_start_and_end()))
        with self.scene.simultaneous():
            for x in parallels:
                x.e_remove()
        return poly

    # ----------------------------------------------------------------------------------------------------------------
    # copy to triangles
    # ----------------------------------------------------------------------------------------------------------------
    @log
    @anim_speed
    def copy_to_triangles(self) -> list[Tri.ETriangle]:
        '''Take a given polygon, and create a set of triangles, equivalent to the initial polygon'''

        triangles = []
        sides = self.sides
        coords = [p.get_center() for p in self.points]
        new = EPolygon(*coords)

        while sides > 3:

            # calculate the index with the smallest angle
            min_index, min_angle = min(enumerate(new.angle_values), key=lambda a: a[1])

            # chop this section off - step 1 calculate points
            if min_index == new.sides - 1:
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
            new.e_remove()
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

    @property
    def is_clockwise(self):
        if not hasattr(self, '_is_clockwise'):
            self._calculate_angle_values()
        return self._is_clockwise

    def _calculate_angle_values(self):
        # clockwise
        values = list(Angle.calculateAngle(l1, l2) for l1, l2 in pairwise([self.lines[-1]] + self.lines))
        self._is_clockwise = True

        # counter_clockwise
        if sum(values) > (self.sides - 2) * mn.PI + 0.0001:
            self._is_clockwise = False
            values = list(Angle.calculateAngle(l2, l1) for l1, l2 in pairwise([self.lines[-1]] + self.lines))
        self._angle_values = values

    @log
    @copy_transform()
    def copy_to_rectangle(self, point: EMObject | mn.Vect3):
        # need a right angle
        with self.scene.simultaneous():
            l1 = Line.ELine(mn.LEFT, mn.ORIGIN).e_fade()
            l2 = Line.ELine(mn.LEFT, mn.UL).e_fade()
        right = Angle.EAngle(l1, l2)
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

    @log
    @copy_transform()
    def copy_to_similar_shape(self, line: Line.ELine):
        from . import Triangle as Tri
        # array of points for new polygon
        first_vec = self.l0.get_unit_vector()
        ref_line = line.get_unit_vector()

        if np.dot(first_vec, ref_line) >= 0:
            points: list[Point.EPoint] = [Point.EPoint(line.get_start()), Point.EPoint(line.get_end())]
        else:
            points: list[Point.EPoint] = [Point.EPoint(line.get_end()), Point.EPoint(line.get_start())]

        # --------------------------------------------------------------------------
        # create individual triangles and copy them
        # --------------------------------------------------------------------------
        line_to_draw_on = Line.ELine(*points, skip_anim=True).red()
        for third_point in self.p[2:]:
            # create new triangle
            t = Tri.ETriangle(self.p0, self.p1, third_point, fill=(mn.PINK, 0.5))

            # create two new angles
            with self.scene.simultaneous():
                a1 = Angle.EAngle(t.l0, t.l2)
                a2 = Angle.EAngle(t.l1, t.l0)

            # copy these angles to the line to draw on
            with self.scene.simultaneous():
                pt1 = Point.EPoint(line_to_draw_on.get_start())
                pt2 = Point.EPoint(line_to_draw_on.get_end())
            with self.scene.simultaneous():
                l1, a1tmp = a1.copy_to_line(pt1, line_to_draw_on)
                l2, a2tmp = a2.copy_to_line(pt2, line_to_draw_on, negative=True)

            # find the intersection of the new lines
            pt3 = Point.EPoint(l1.intersect_line(l2)[0])
            points.append(pt3)

            # clean up
            with self.scene.simultaneous():
                t.e_remove()
                a1.e_remove()
                a2.e_remove()
                l1.e_remove()
                l2.e_remove()
                a1tmp.e_remove()
                a2tmp.e_remove()
                pt1.e_remove()
                pt2.e_remove()
            # if third_point is not self.p[-1]:
            #     line_to_draw_on = Line.ELine(pt1, pt3).red()

        line_to_draw_on.e_remove()
        poly = EPolygon.assemble(points=points)
        return poly

    @log
    @copy_transform()
    def copy_to_polygon_shape(self, point: EMObject | mn.Vect3, poly: EPolygon):
        # need a right angle
        l1 = Line.VirtualLine(mn_coord(10, 40), mn_coord(40, 40))
        l2 = Line.VirtualLine(mn_coord(10, 40), mn_coord(10, 10))
        right = Angle.EAngle(l1, l2, delay_anim=True)

        # Create a rectangle equal in area to other BCLE (I.45)
        # drawn on it's base
        t1 = poly.copy_to_parallelogram_on_line(poly.l0, right)

        # copy self to rectangle alongside of previous CFME
        if self.is_clockwise == t1.is_clockwise:
            t2 = self.copy_to_parallelogram_on_line(t1.l1, right)
        else:
            t2 = self.copy_to_parallelogram_on_line(t1.l3, right)
        t2.blue()

        # create a line GH (starting at point $pt) such that it is
        # the mean proportional of BC, CF (VI.13)
        line3 = Line.ELine.mean_proportional(t1.l0, t2.l1, point, 0)

        # finally, draw a copy of the polygon onto the new line
        # (the final polygon will be the size of self, but similar to polygon)
        final = poly.copy_to_similar_shape(line3)

        # cleanup
        with self.scene.simultaneous():
            t1.e_remove()
            t2.e_remove()
            line3.e_remove()

        return final

    # def transform_to(self, other: Self, *sub_animations, anim: Type[mn.Animation] = mn.TransformFromCopy):
    #     repeat_last = lambda a: chain(a[:-1], repeat(a[-1]))
    #     line_transforms = [us.transform_to(them, anim=anim) for us, them in zip(repeat_last(self.l), other.lines)]
    #     point_transforms = [us.transform_to(them, anim=anim) for us, them in zip(repeat_last(self.p), other.points)]
    #     angle_transforms = [us.transform_to(them, anim=anim)
    #                         for us, them in zip(self.a, other.angles)
    #                         if us is not None and them is not None]
    #     return super().transform_to(other, *line_transforms, *point_transforms, *angle_transforms, *sub_animations,
    #                                 anim=anim)

    # # not used
    # def reposition(self, *new_coords, anim=False):
    #     assert (len(self.points) == len(new_coords))
    #     new_poly = EPolygon(*new_coords, **self.options, delay_anim=True)
    #     if anim:
    #         self.scene.play(self.transform_to(new_poly, anim=mn.ReplacementTransform))
    #     else:
    #         self.scene.remove(*self.get_e_family())
    #     self.lines = new_poly.lines
    #     self.angles = new_poly.angles
    #     self.points = new_poly.points
    #     self.become(new_poly)
    #     self.scene.add(*self.get_e_family())
    #     if anim:
    #         self.scene.remove(new_poly)

    def area(self) -> float:
        return self.get_arc_length()

    def true_area(self) -> float:
        if hasattr(self, '_area'):
            return self._area
        with self.scene.pause_animations_for():
            triangles = self.copy_to_triangles()
            area = sum(t.true_area() for t in triangles)
            for t in triangles:
                t.e_delete()
        self._area = area
        return area

    # -----------------------------------------------------------------------------------------------------------------
    # polygons don't have labels
    # -----------------------------------------------------------------------------------------------------------------
    def add_label(self, *args, **kwargs):
        pass
