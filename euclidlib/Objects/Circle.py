from __future__ import annotations

import math
import manimlib as mn
import numpy as np

from euclidlib.Objects.em_object_decorators import *
from euclidlib.Utilities.coordinate_utilities import mn_scale, convert_to_coord
if TYPE_CHECKING:
    pass
    #import euclidlib.Scenes.PropScene as ps
from . import Line
from . import Arc
from . import Point

# =====================================================================================================================
# Circle
# =====================================================================================================================
class ECircle(mn.Circle, Arc.AbstractArc):
    CONSTRUCTION_TIME = 2.00
    AUX_CONSTRUCTION_TIME = 0.25

    # -----------------------------------------------------------------------------------------------------------------
    # initialization
    # -----------------------------------------------------------------------------------------------------------------
    def __init__(self, center, point, temp_line_label=None, *args, **kwargs):
        """
        :param center: centre of circle
        :param point: point on circle circumference
        :param temp_line_label: maybe initial line has a label?
        """
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

    # -----------------------------------------------------------------------------------------------------------------
    # CreationOf - how to animate the drawing of a circle
    # -----------------------------------------------------------------------------------------------------------------
    def CreationOf(self, *args, **kwargs):
        tmpLine = Line.ELine(self.e_center, self.get_end(),
                          stroke_color=mn.RED,
                          label=self.temp_line_label,
                          delay_anim=True)
        # normal animation
#        if self.scene.animateState[-1] == ps.AnimState.NORMAL:

        # draw the line to create the 'swoop' of drawing a circle
        self.animation_objects.append(tmpLine)
        tmpLine.e_draw(
            anim_args=dict(
                run_time=self.AUX_CONSTRUCTION_TIME if not self.temp_line_label else self.AUX_CONSTRUCTION_TIME * 2
            ))

        # at every frame, set the points of the line to the animation of the drawing circle
        tmpLine.f_always.set_points_by_ends(lambda: self.e_center, lambda: self.get_end())

        # as the temp line is being drawn, if it has a label, allow label to be updated as the circle is drawn
        if tmpLine.e_label is not None:
            tmpLine.e_label.enable_updaters()

        return super().CreationOf(*args, **kwargs)

    def e_label_location(self, angle: float, outside=True, buff=None):
        direction = np.array([np.cos(angle), np.sin(angle), 0.0])
        try:
            edge = self.point_at_angle(angle)
        except AssertionError:
            try:
                edge = self.point_from_proportion((angle%mn.TAU)/mn.TAU)
            except AssertionError:
                edge = self.get_right()
        return edge + direction * (buff or self.LabelBuff) * (1 if outside else -1)


    def angle_of_point(self, point: Point.EPoint | mn.Vect3):
        p = convert_to_coord(point)
        c = self.center
        vec = p - c
        return mn.angle_of_vector(vec) % mn.TAU


    @log
    @anim_speed
    def draw_tangent(self, point: mn.Mobject | mn.Vect3, negative=False):
        # draw line from point to centre of circle
        pC = Point.EPoint(self.v)
        lC = Line.ELine(point, pC)

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
            p: tuple[mn.Vect3, mn.Vect3] = self.intersect(lC)
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
            lF = Line.ELine(pF, pC).e_fade()
            # find intersection of this line with original circle
            p = self.intersect(lF)
            # fiddle around because round off errors might make point B
            # just outside the circle
            radial = Line.ELine(self.get_center(), p[0])
            if radial.get_length() > self.radius:
                p = (radial.point(self.radius),)
            radial.e_remove()
            pB = Point.EPoint(p[0]).e_fade()
            # draw the tangent
            l = Line.ELine(point, pB)

            to_remove.extend([pB, radial, lF, pF, lPerp, cL, pD])

        with self.scene.simultaneous():
            for x in to_remove:
                x.e_remove()

        return l



class VirtualCircle(ECircle):
    Virtual = True
