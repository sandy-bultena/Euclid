from __future__ import annotations

import math

from euclidlib.Objects.EucidMObject import *
from euclidlib.Objects import Line as L
import manimlib as mn

class EuclidCircle(EMObject, mn.Circle):
    CONSTRUCTION_TIME=0.75
    AUX_CONSTRUCTION_TIME = 0.25

    def CreationOf(self, *args, **kwargs):
        tmpLine = mn.Line(self.e_center, self.get_end(), stroke_color=mn.RED)
        self.animation_objects.append(tmpLine)
        self.scene.play(mn.ShowCreation(tmpLine, run_time=self.AUX_CONSTRUCTION_TIME))
        tmpLine.f_always.set_points_by_ends(lambda: self.e_center, lambda: self.get_end())
        return super().CreationOf(*args, **kwargs)

    def e_label_point(self, angle: float, direction: Vect3 = None, outside=True, buff=None):
        direction = direction or np.array([np.cos(angle), np.sin(angle), 0.0])
        edge = self.get_bounding_box_point(direction)
        return edge + direction * (buff or self.LabelBuff) * (1 if outside else -1)

    def __init__(self, center, point, *args, **kwargs):
        self.e_center = convert_to_coord(center)
        self.e_point = convert_to_coord(point)

        dx = self.e_point[0] - self.e_center[0]
        dy = self.e_point[1] - self.e_center[1]
        self.radius = math.sqrt(dx ** 2 + dy ** 2)
        angle = math.atan2(dy, dx)

        super().__init__(
            start_angle=angle,
            arc_center=self.e_center,
            radius=self.radius,
            stroke_color=mn.WHITE,
            *args,
            **kwargs
        )

    def intersect_circle(self, other: EuclidCircle) -> Vect3 | None:
        p2, r2 = other.e_center, other.radius
        base = L.VirtualLine(self.e_center, p2, scene=self.scene, stroke_color=BLUE)
        d = base.get_length()

        d1 = 1 / (2 * d) * (d ** 2 + self.radius ** 2 - r2 ** 2)
        d2 = d - d1

        hsqr = r2 ** 2 - d2 ** 2
        if abs(hsqr) < 0.2:
            hsqr = 0

        if hsqr < 0:
            base.e_remove()
            return None

        h = math.sqrt(hsqr)

        sx, sy, *_ = base.get_start()
        if d1 < 1:
            sx, sy, *_ = base.get_end()
        px, py, _ = base.point(d1)

        p4x = px + py - sy
        p4y = py - px + sx
        p1x = px - py + sy
        p1y = py + px - sx

        hline1 = L.VirtualLine((px, py), (p4x, p4y), scene=self.scene)
        hline2 = L.VirtualLine((px, py), (p1x, p1y), scene=self.scene)

        h1 = hline1.point(h)
        h2 = hline2.point(h)

        hline1.e_remove()
        hline2.e_remove()
        base.e_remove()

        if h1[1] < h2[1]:
            return h2, h1, 0
        else:
            return h1, h2, 0

    def intersect_line(self, other: L.EuclidLine) -> Vect3 | None:
        x, y, _ = self.e_center
        r = self.radius

        x0, y0, _ = other.get_start()
        x1, y1, _ = other.get_end()
        m = other.get_slope()

        if abs(m) < 1e90:
            # math:
            # circle eq'n: (x-$x)^2 + (y-$y)^2 = $r^2
            # line eq'n:   y = mx+b, (b = $y1 - $m * $x1)
            # Intersection of line & circle solves the following eq'n for x:
            #   (x-$x)^2 + ($m x + $b - $y)^2 = $r^2

            i = y0 - m * x0
            a = 1 + m**2
            b = 2 * m * (i - y) - 2 * x
            c = (i - y)**2 + x**2 - r**2
            sqr = b**2 - 4 * a * c

            if sqr < 0:
                return None

            x3 = (-b + math.sqrt(sqr)) / (2 * a)
            x4 = (-b - math.sqrt(sqr)) / (2 * a)
            y3 = m * x3 + i
            y4 = m * x4 + i
        else:
            # math:
            # circle eq'n: (x-$x)^2 + (y-$y)^2 = $r^2
            # line eq'n:   x = $x1,
            # Intersection of line & circle solves the following eq'n for y:
            #   ($x1-$x)^2 + (y-$y)^2 = $r^2
            # binomial eq'n (-b +/- sqrt(b^2 - 4ac)) / 2a

            a = 1
            b = -2 * y
            c = (x0 - x)**2 + y**2 - r**2

            sqr = b**2 - 4 * a * c

            if sqr < 0:
                return None

            x3 = x0
            x4 = x0
            y3 = (-b + math.sqrt(sqr)) / (2 * a)
            y4 = (-b - math.sqrt(sqr)) / (2 * a)

        results = []
        max_x = max(x1, x0)
        min_x = min(x1, x0)
        max_y = max(y1, y0)
        min_y = min(y1, y0)
        
        epsilon = mn_scale(1)

        if min_x - epsilon <= x3 <= max_x + epsilon and min_y - epsilon <= y3 < max_y + epsilon:
            results.append((x3, y3, 0))
        if min_x - epsilon <= x4 <= max_x + epsilon and min_y - epsilon <= y4 < max_y + epsilon:
            results.append((x4, y4, 0))

        return results




    def intersect(self, other: EMObject) -> Vect3 | None:
        match other:
            case EuclidCircle():
                return self.intersect_circle(other)
            case L.EuclidLine():
                return self.intersect_line(other)


class VirtualCircle(EuclidCircle):
    Virtual = True
