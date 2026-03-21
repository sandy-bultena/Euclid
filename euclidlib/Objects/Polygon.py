from __future__ import annotations
from typing_extensions import Unpack

from itertools import pairwise, zip_longest, chain, repeat
from typing import  Any,  TypedDict, TYPE_CHECKING, Optional

from euclidlib.Objects.em_object_base import *
from euclidlib.Objects.em_object_decorators import *
from euclidlib.Objects.PolygonBase import *
from euclidlib.Utilities.coordinate_utilities import mn_scale, convert_to_coord, mn_coord, euclid_coord
from . import Triangle as Tri

from . import em_group_object as GroupObject

from . import Line
from . import Point
from . import Angle
import euclidlib.Utilities.Colour as Colour


# ===================================================================================================================
# EPolygon
# ===================================================================================================================
class EPolygon(EPolygonBase):

    # ----------------------------------------------------------------------------------------------------------------
    # copy to parallelogram on a point
    # ----------------------------------------------------------------------------------------------------------------
    @log
    @copy_transform()
    def copy_to_parallelogram_on_point(self, point: Point.EPoint, angle: Angle.EAngleBase, /, negative=False)->EPolygon:
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
    def copy_to_parallelogram_on_line(self, line: Line.ELine, angle: Angle.EAngleBase)->EPolygon:

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
        '''Take a given polygon and create a set of triangles, equivalent to the initial polygon'''

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


    # ----------------------------------------------------------------------------------------------------------------
    # copy to rectangle
    # ----------------------------------------------------------------------------------------------------------------
    @log
    @copy_transform()
    def copy_to_rectangle(self, point: EMObject | mn.Vect3)->EPolygon:
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

    # ----------------------------------------------------------------------------------------------------------------
    # copy to similar shape
    # ----------------------------------------------------------------------------------------------------------------
    @log
    @copy_transform()
    def copy_to_similar_shape(self, line: Line.ELine)->EPolygon:
        '''Create a new polygon that is similar in shape to the original, and whose first side alignes with "line" '''
        from . import Triangle as Tri

        # array of points for new polygon
        first_vec = self.l0.get_unit_vector()
        ref_line = line.get_unit_vector()

        if np.dot(first_vec, ref_line) >= 0:
            points: list[Point.EPoint] = [Point.EPoint(line.get_start()), Point.EPoint(line.get_end())]
        else:
            points: list[Point.EPoint] = [Point.EPoint(line.get_end()), Point.EPoint(line.get_start())]

        # create individual triangles and copy them
        line_to_draw_on = Line.ELine(*points, skip_anim=True).red()

        tmp_triangles = []
        colour = Colour.string(mn.PINK)

        for third_point in self.p[2:]:

            # create new triangle
            t = Tri.ETriangle(self.p0, self.p1, third_point, fill=colour)

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
            tmp_triangles.append(Tri.ETriangle(pt1,pt2,pt3).e_fill(colour))
            colour = Colour.darken(colour)


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

        with self.scene.simultaneous():
            for t in tmp_triangles:
                t.e_remove()

        line_to_draw_on.e_remove()
        poly = EPolygon.assemble(points=points)
        return poly

    # ----------------------------------------------------------------------------------------------------------------
    # copy to polygon shape
    # ----------------------------------------------------------------------------------------------------------------
    @log
    @copy_transform()
    def copy_to_polygon_shape(self, point: EMObject | mn.Vect3, poly: EPolygon):
        '''Create a new polygon which is similar to the polygon passed as a parameter, but it will have
        the same area as the original polygon (self).  It will be anchored at the point'''
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

