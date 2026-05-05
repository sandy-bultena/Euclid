from __future__ import annotations
from typing_extensions import Unpack

from itertools import pairwise, zip_longest, chain, repeat
from typing import  Any,  TypedDict, TYPE_CHECKING, Optional

from euclidlib.Objects.em_object_base import *
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Utilities.coordinate_utilities import mn_scale, convert_to_coord, mn_coord, euclid_coord

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
    angles: FULL_ANGLES_ARG
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
# EPolygonBase
# ===================================================================================================================
class EPolygonBase(GroupObject.EGroupedObjects, EMObject, mn.Polygon):

    MAX_SIZE = 0

    # ---------------------------------------------------------------------------------------------------------------
    # properties
    # ---------------------------------------------------------------------------------------------------------------

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
                 **kwargs) -> Optional[Self]:
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
            angles: ANGLE_ARGS | None = None,
            fill: tuple[mn.Color, float] | None = None,
            label: str | None = None,
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
        :param angles: labels for each angle
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
        if all(isinstance(p, Line.ELine) for p in points):
            lines = [p for p in points]
            points = find_vertices(*lines)
        assert (points is not None)

        # save the vertices in self (coordinates, not EPoints)
        vertices = [convert_to_coord(p) for p in points]
        self.sides = len(vertices)
        self.update_size(self.sides)
        if self.sides:
            vertices.append(vertices[0])

        # ------------------------------------------------------------------------------------------------------------
        # create an options dictionary for point_labels, labels, angles and fill
        # ------------------------------------------------------------------------------------------------------------
        self.options: OPTIONS = {
            k: locals()[k]
            for k in ('point_labels', 'labels', 'angles', 'fill')
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
        # define the fill colours
        # ------------------------------------------------------------------------------------------------------------
        fill_colour = None
        opacity = 0
        if 'fill' in self.options:
            fill_option = self.options['fill']
            if isinstance(fill_option,str):
                fill_colour = fill_option
                opacity = E_FILL_OPACITY_FACTOR
                self.options['fill'] = (fill_colour, 1)
            else:
                fill_colour = fill_option[0]
                opacity = fill_option[1] * E_FILL_OPACITY_FACTOR



        # ------------------------------------------------------------------------------------------------------------
        # create all the lines, points, etc, if they don't already exist
        # ------------------------------------------------------------------------------------------------------------
        self.scene = find_scene()
        with self.scene.simultaneous():
            super().__init__(*vertices, stroke_width=0, z_index=z_index, animate_part=animate_part,
                             fill_color=fill_colour, fill_opacity=opacity,
                             delay_anim=delay_anim, skip_anim=skip_anim, **kwargs)
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
        # add label if defined
        # ------------------------------------------------------------------------------------------------------------
        if label:
            self.add_label(label)

    # ---------------------------------------------------------------------------------------------------------------
    # properties
    # ---------------------------------------------------------------------------------------------------------------
    @property
    def vertices(self):
        return super().get_vertices()

    @property
    def area(self):
        # A = (1/2) \sum_{i=0}^{n-1} a_i \text{where} a_i = x_i y_{i+1} - x_{i+1} y_i
        a = 0
        pts = self.vertices
        for i in range(self.sides):
            a += pts[i][0]*pts[(i+1)%self.sides][1]-pts[(i+1)%self.sides][0]*pts[i][1]
        a = a/2
        return a

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
    # fade and normal
    # ---------------------------------------------------------------------------------------------------------------
    def e_fade(self):
        super().e_fill(opacity=0)
        super().e_fade()

    def e_normal(self):
        super().e_normal()
        if 'fill' in self.options:
            self.e_fill(*self.options['fill'])

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
            if 'angles' in self.options:
                names, sizes = self.options['angles'][:self.sides], self.options['angles'][self.sides:]
                self.set_angles(*self.options['angles'], delay_anim=delay_anim, skip_anim=skip_anim)

    # ---------------------------------------------------------------------------------------------------------------
    # define points
    # ---------------------------------------------------------------------------------------------------------------
    def define_points(self, delay_anim=False, skip_anim=False):

        # points already exist, do nothing
        if self.points:
            return

        # default labels is undefined
        labels = self.options.get('point_labels', [()] * self.sides)
        if self.sides > len(labels):
            labels.extend([()] * (self.sides - len(labels)))

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

        # default labels is undefined
        labels = self.options.get('labels', [()] * self.sides)
        if self.sides > len(labels):
            labels.extend([()]*(self.sides-len(labels)))

        with self.scene.simultaneous_speed(self.speed):
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
    def set_angles(self, *angles,  delay_anim=False, skip_anim=False):
        names_and_sizes = []
        for a in angles:
            if isinstance(a,str) or a is None:
                names_and_sizes.append((a,None))
            else:
                names_and_sizes.append((a[0],a[1]))
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

    # for naming consistency
    def add_angles(self, *angles,  delay_anim=False, skip_anim=False):
        return self.set_angles(*angles,  delay_anim=delay_anim, skip_anim=skip_anim)

    # ----------------------------------------------------------------------------------------------------------------
    # set line labels
    # ----------------------------------------------------------------------------------------------------------------
    def set_labels(self, *labels: LABEL_ARG):
        for l, label_data in zip(self.lines, labels):
            label_data = self._filter_side_labels(label_data)
            if label_data and label_data[0]:
                l.add_label(*label_data)
        return self

    # for naming consistency
    def add_line_labels(self, *labels: LABEL_ARG):
        return self.set_labels(*labels)

    # ----------------------------------------------------------------------------------------------------------------
    # set point labels
    # ----------------------------------------------------------------------------------------------------------------
    def set_point_labels(self, *labels: LABEL_ARG):
        for p, label_data in zip_longest(self.points, labels, fillvalue=None):
            label_data = self._filter_point_labels(label_data)
            if label_data:
                p.add_label(*label_data)
        return self

    # for naming consistency
    def add_point_labels(self, *labels: LABEL_ARG):
        return self.set_point_labels(*labels)

    # ----------------------------------------------------------------------------------------------------------------
    # convert point label args to either (str,) or (str,dict) or (str,str)
    # ----------------------------------------------------------------------------------------------------------------
    def _filter_point_labels(self, args: LABEL_ARG):
        return EPolygonBase._filter_point_labels_with_center(args, self.get_center_of_mass())

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
        vertices = self.vertices
        vertices[index] = dest
        vertices[-1] = vertices[0]

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
                    l1 = Line.VirtualLine(vertices[(i - 1) % self.sides], vertices[i])
                    l2 = Line.VirtualLine(vertices[i], vertices[i + 1])
                    new_angle = Angle.EAngle(l1, l2, size=old_angle.size, delay_anim=True)
                    self.scene.play(mn.Transform(old_angle, new_angle))
                    l2.e_remove()
                    l1.e_remove()

            # update the actual Polygon object
            self.scene.play(self.animate.set_points_as_corners(vertices))

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


    def _calculate_angle_values(self):
        # clockwise
        values = list(Angle.calculateAngle(l1, l2) for l1, l2 in pairwise([self.lines[-1]] + self.lines))
        self._is_clockwise = True

        # counter_clockwise
        if sum(values) > (self.sides - 2) * mn.PI + 0.0001:
            self._is_clockwise = False
            values = list(Angle.calculateAngle(l2, l1) for l1, l2 in pairwise([self.lines[-1]] + self.lines))
        self._angle_values = values



    # -----------------------------------------------------------------------------------------------------------------
    # polygons do have labels
    # -----------------------------------------------------------------------------------------------------------------
    if TYPE_CHECKING:
        # add_label is defined in em_object_base, which in turn calls self.init_label(*args,**kwargs)
        # which in turn uses e_label_location to figure out where to put the label
        def add_label(self, text: str, align=mn.ORIGIN) -> EPolygonBase: ...

    def e_label_location(self):
        """uses center of gravity"""
        # https://web.archive.org/web/20150708063910/http://proceedings.esri.com/library/userconf/proc01/professional/papers/pap388/p388.htm

        a = 0
        mu_x = 0
        mu_y = 0

        pts = self.vertices
        for i in range(self.sides):
            a_i = pts[i][0]*pts[(i+1)%self.sides][1]-pts[(i+1)%self.sides][0]*pts[i][1]
            a += a_i
            mu_x += (pts[(i+1)%self.sides][0] + pts[i][0]) * a_i
            mu_y += (pts[(i + 1) % self.sides][1] + pts[i][1]) * a_i
        a = a/2
        mu_x = mu_x/6
        mu_y = mu_y/6
        xc = mu_x/a
        yc = mu_y/a

        return [xc,yc,0]

    # -----------------------------------------------------------------------------------------------------------------
    # polygon transform_to
    # -----------------------------------------------------------------------------------------------------------------
    def transform_to(self, other: Self, *sub_animations, anim: Type[mn.Animation] = mn.TransformFromCopy):
        repeat_last = lambda a: chain(a[:-1], repeat(a[-1]))
        line_transforms = [us.transform_to(them, anim=anim) for us, them in zip(repeat_last(self.l), other.lines)]
        point_transforms = [us.transform_to(them, anim=anim) for us, them in zip(repeat_last(self.p), other.points)]
        angle_transforms = [us.transform_to(them, anim=anim)
                            for us, them in zip(self.a, other.angles)
                            if us is not None and them is not None]

        return super().transform_to(other, *line_transforms, *point_transforms, *angle_transforms, *sub_animations,
                                    anim=anim)

