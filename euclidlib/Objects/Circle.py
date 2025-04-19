from __future__ import annotations

import math
from itertools import pairwise

from euclidlib.Objects.EucidMObject import *
from euclidlib.Objects import Line as L
from euclidlib.Objects import Arc
from euclidlib.Objects import Point
import manimlib as mn
from euclidlib.Objects import Dashable as Da


class ECircle(mn.Circle, Arc.AbstractArc):
    CONSTRUCTION_TIME = 0.75
    AUX_CONSTRUCTION_TIME = 0.25

    def CreationOf(self, *args, **kwargs):
        tmpLine = L.ELine(self.e_center, self.get_end(),
                          stroke_color=mn.RED,
                          label=self.temp_line_label,
                          delay_anim=True)
        if self.scene.animateState[-1] == ps.AnimState.NORMAL:
            self.animation_objects.append(tmpLine)
            tmpLine.e_draw(
                anim_args=dict(
                    run_time=self.AUX_CONSTRUCTION_TIME if not self.temp_line_label else self.AUX_CONSTRUCTION_TIME * 2
                ))
            tmpLine.f_always.set_points_by_ends(lambda: self.e_center, lambda: self.get_end())
            if tmpLine.e_label is not None:
                tmpLine.e_label.enable_updaters()
        return super().CreationOf(*args, **kwargs)

    def e_label_point(self, angle: float, outside=True, buff=None):
        direction = np.array([np.cos(angle), np.sin(angle), 0.0])
        try:
            edge = self.point_at_angle(angle)
        except AssertionError:
            try:
                edge = self.point_from_proportion((angle%TAU)/TAU)
            except AssertionError:
                edge = self.get_right()
        return edge + direction * (buff or self.LabelBuff) * (1 if outside else -1)

    def __init__(self, center, point, temp_line_label=None, *args, **kwargs):
        self.e_center = convert_to_coord(center)
        self.e_point = convert_to_coord(point)
        self.temp_line_label = temp_line_label
        if 'stoke_color' not in kwargs:
            kwargs['stroke_color'] = mn.WHITE

        dx = self.e_point[0] - self.e_center[0]
        dy = self.e_point[1] - self.e_center[1]
        radius = math.sqrt(dx ** 2 + dy ** 2)
        angle = math.atan2(dy, dx)

        super().__init__(
            start_angle=angle,
            arc_center=self.e_center,
            radius=radius,
            *args,
            **kwargs
        )

    def angle_of_point(self, point: Point.EPoint | Vect3):
        p = convert_to_coord(point)
        c = self.center
        vec = p - c
        return mn.angle_of_vector(vec) % TAU


    @log
    @anim_speed
    def draw_tangent(self, point: Mobject | Vect3, negative=False):
        # draw line from point to centre of circle
        pC = Point.EPoint(self.v)
        lC = L.ELine(point, pC)

        # if point is inside circle, then we can't do this
        if lC.get_length() - self.r < mn_scale(-1):
            raise ValueError("Cannot draw a line from INSIDE circle that touches circle!")

        to_remove = [pC, lC]

        # if the point is on the circle, then draw a line perpendicular
        # to the radius
        if abs(lC.get_length() - self.r) < mn_scale(2):
            l = lC.perpendicular(point, speed=0, inside=negative)
            l.extend(self.r)
        # else draw a line from the point tangent to the circle
        else:
            # find where line from centre intersects small circle
            p: Tuple[Vect3, Vect3] = self.intersect(lC)
            pD = Point.EPoint(p[0]).e_fade()
            # draw larger circle, and where line from centre intersects small circle
            cL = ECircle(self.v, point).e_fade()
            # find line perpendicular to d, and find
            # intersection with larger circle
            lPerp = lC.perpendicular(pD, speed=0, inside=negative).e_fade()
            lPerp.extend(lC.get_length())
            p = cL.intersect(lPerp)
            pF = Point.EPoint(p[0]).e_fade()
            # draw line from point F to centre of circle
            lF = L.ELine(pF, pC).e_fade()
            # find intersection of this line with original circle
            p = self.intersect(lF)
            # fiddle around because round off errors might make point B
            # just outside the circle
            radial = L.ELine(self.get_center(), p[0])
            if radial.get_length() > self.radius:
                p = (radial.point(self.radius),)
            radial.e_remove()
            pB = Point.EPoint(p[0]).e_fade()
            # draw the tangent
            l = L.ELine(point, pB)

            to_remove.extend([pB, radial, lF, pF, lPerp, cL, pD])

        with self.scene.simultaneous():
            for x in to_remove:
                x.e_remove()

        return l



class VirtualCircle(ECircle):
    Virtual = True
