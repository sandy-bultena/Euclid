from __future__ import annotations

from enum import EnumType, Enum
from itertools import pairwise

import numpy as np

from euclidlib.Objects import Point as P
from euclidlib.Objects import Circle
from euclidlib.Objects import Triangle as T
from euclidlib.Objects import Angel
import math
from euclidlib.Objects import EquilateralTriangle
from typing import Dict, Tuple
from euclidlib.Objects.EucidMObject import *

class ELine(EMObject, mn.Line):
    CONSTRUCTION_TIME = 0.5
    LabelBuff = 0.15

    @staticmethod
    def find_in_frame(name, loop=False):
        if loop:
            name = name + name[0]
        parts = [''.join(x) for x in pairwise(name)]
        from inspect import currentframe
        f = currentframe()
        while f.f_back:
            f = f.f_back
            if 'l' in f.f_locals:
                break
        if f.f_back is None:
            raise Exception("Can't Find Line Dict")
        lines = f.f_locals.get('l', {})

        lines = [lines.get(p, lines.get(p[::-1])) for p in parts]
        if all(l is not None for l in lines):
            return lines

        raise Exception(f"Can't find line(s) {', '.join( n for p, n in zip(lines, parts) if p is None)}")

    def IN(self):
        vec = self.get_unit_vector()
        return mn.rotate_vector(vec, PI/2)

    def OUT(self):
        vec = self.get_unit_vector()
        return mn.rotate_vector(vec, -PI/2)

    def __init__(self, start: EMObject | mn.Vect3, end: EMObject | mn.Vect3 | None = None, *args, **kwargs):
        if isinstance(start, str):
            start, end = P.EPoint.find_in_frame(start)

        self.e_start = self.pointify(start)
        self.e_end = self.pointify(end)
        super().__init__(self.e_start, self.e_end, *args, **kwargs)


    def e_label_point(self, direction: mn.Vect3=None, inside=None, outside=None, alpha=0.5, buff=None):
        try:
            point = self.point_from_proportion(alpha)
        except AssertionError:
            point = self.get_start()
        if inside:
            direction = self.IN()
        elif outside:
            direction = self.OUT()
        return point + (buff or self.LabelBuff) * direction


    def point(self, r: float):
        vec = self.get_unit_vector()
        return self.get_start() + r * vec

    def old_point(self, r: float):
        p3x, p3y, *_ = self.get_end()
        xs, ys, *_ = self.get_start()
        dx = p3x - xs
        dy = p3y - ys
        if dx == dy == 0:
            return xs, ys

        x = r / math.sqrt(dy**2 + dx**2) * dx + xs
        y = r / math.sqrt(dy**2 + dx**2) * dy + ys
        return x, y

    def highlight(self, color=RED, scale=2.0, **args):
        return (self.animate(rate_func=mn.there_and_back, **args)
                    .set_stroke(color=color, width=scale * float(self.get_stroke_width())))

    def intersect(self, other: Mobject, reverse=True):
        if isinstance(other, mn.Line):
            return self.intersect_line(other)
        if isinstance(other, mn.Rectangle):
            return self.intersect_selection(other)
        super().intersect(other)


    def intersect_selection(self, other: mn.Rectangle):
        if other.get_arc_length() < 1e-3:
            other = mn.Rectangle(0.2, 0.2).move_to(other)
        corners = [other.get_corner(x) for x in [UL, UR, DR, DL, UL]]
        return any(self.intersect_bound_line(mn.Line(x, y)) for x, y in pairwise(corners)) or (
            other.is_point_touching(self.get_start()) and other.is_point_touching(self.get_end())
        )


    def intersect_bound_line(self, l2: mn.Line):
        (x1, y1, _), (x2, y2, _) = self.get_start_and_end()
        (x3, y3, _), (x4, y4, _) = l2.get_start_and_end()
        uA = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1))
        uB = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1))

        if not (0 <= uA <= 1 and 0 <= uB <= 1):
            return False
        x = x1 + (uA * (x2 - x1))
        y = y1 + (uA * (y2 - y1))
        return x, y, 0


    def intersect_line(self, l2: mn.Line):
        (x00, y00, _), (x01, y01, _) = self.get_start_and_end()
        (x10, y10, _), (x11, y11, _) = l2.get_start_and_end()
        m1 = self.get_slope()
        m2 = l2.get_slope()

        if abs(m1 - m2) < 0.1:
            return

        if abs(m1) > 1e10:
            x = x00
            y = m2 * (x - x10) + y10
        elif abs(m2) > 1e10:
            x = x10
            y = m1 * (x - x00) + y00
        else:
            x = (y11 - y00 + m1 * x00 - m2 * x11) / (m1 - m2)
            y = m1 * (x - x00) + y00

        return x, y, 0

    def length_from_end(self, p: P.EPoint):
        return p.distance_to(self.get_end())

    def length_from_start(self, p: P.EPoint):
        return p.distance_to(self.get_start())

    def extend(self, r: float, rate_func=mn.smooth):
        if r < 0:
            return self.prepend(-r)
        self.e_end = self.point(r + self.get_length())
        self.scene.play(self.animate(rate_func=rate_func).set_points_by_ends(self.get_start(), self.e_end))
        return self

    def prepend(self, r: float, rate_func=mn.smooth):
        if r < 0:
            return self.extend(r)
        self.e_start = self.point(-r)
        self.scene.play(self.animate(rate_func=rate_func).set_points_by_ends(self.e_start, self.get_end()))
        return self

    def extend_and_prepend(self, r: float, rate_func=mn.smooth):
        r = abs(r)
        self.e_start = self.point(-r)
        self.e_end = self.point(r + self.get_length())
        self.scene.play(self.animate(rate_func=rate_func).set_points_by_ends(self.e_start, self.e_end))
        return self


    def extend_cpy(self, r: float):
        if r < 0:
            return self.prepend_cpy(-r)
        x2, y2, _ = self.point(r + self.get_length())
        return ELine(self.get_end(), (x2, y2, 0))

    def prepend_cpy(self, r: float):
        x2, y2, _ = self.point(-r)
        return ELine(self.get_start(), (x2, y2, 0))

    def copy_to_point(self, target: P.EPoint, speed=1) -> Tuple[ELine, P.EPoint]:
        A = self.get_start()
        B = self.get_end()
        C = self.pointify(target)

        l: Dict[str | int, ELine] = {}
        p: Dict[str | int, P.EPoint] = {}
        c: Dict[str | int, Circle.ECircle] = {}
        t: Dict[str | int, T.ETriangle] = {}

        with self.scene.animation_speed(speed):
            # ------------------------------------------------------------------------
            # If point is already on the line, just make a clone, and return results
            # ------------------------------------------------------------------------
            if abs(A[0] - C[0]) < 0.1 and abs(A[1] - C[1] < 0.1):
                lCF = self.copy()
                pF = P.EPoint(C, scene=self.scene)
                return lCF, pF

            # ------------------------------------------------------------------------
            # Copy the line to the new point using methods from proposition 2
            # ------------------------------------------------------------------------

            # join the two lines
            l['AC'] = ELine(A, C, scene=self.scene).e_fade()

            # construct equilateral on above line (D = apex of triangle)
            t[1] = EquilateralTriangle.build(A, C)
            p['D'] = t[1].p[-1]
            with self.scene.simultaneous():
                l['AD'] = t[1].l[2]
                l['CD'] = t[1].l[1]
            with self.scene.simultaneous():
                t[1].e_fade()
                l['AD'].e_normal()
                l['CD'].e_normal()

            def find_extended_intersection(p1, p2, circle, line, extend_dir=1, required_intersections=1):
                c[circle] = Circle.ECircle(p1, p2, scene=self.scene).e_fade()
                pts = c[circle].intersect(l[line])
                for _ in range(5):
                    if len(pts) >= required_intersections:
                        break
                    l[line].extend(mn_scale(100 * extend_dir), rate_func=mn.linear)
                    pts = c[circle].intersect(l[line])
                else:
                    raise Exception("Infinite Loop")
                l[line].e_fade()
                return pts

            pts = find_extended_intersection(A, B, 'C', 'AD', -1)

            p['E'] = P.EPoint(pts[0], scene=self.scene)
            p['B'] = P.EPoint(B, scene=self.scene)

            if p['D'].distance_to(pts[0]) > mn_scale(1):
                F = find_extended_intersection(p['D'], p['E'], 'D', 'CD', required_intersections=2)
            else:
                F = [p['E'].get_center()]

            new_end = min(F, key=lambda a: abs(self.get_length() - mn.get_dist(a, C)))
            pF = P.EPoint(new_end)
            lCF = ELine(C, new_end)

            with self.scene.simultaneous():
                for group in (p, l, c, t):
                    for obj in group.values():
                        obj.e_remove()

            return lCF, pF

    def copy_to_line(self, target: P.EPoint, target_line: ELine, speed=1):
        lx, px = self.copy_to_point(target, speed=speed)
        if lx is None or px is None:
            return

        with self.scene.animation_speed(speed):
            c = Circle.ECircle(target, lx.get_end())

            clone = target_line.copy()
            for _ in range(1000):
                p = c.intersect(clone)
                if p is not None:
                    break
                if target_line.length_from_end(target) > target_line.length_from_start(target):
                    clone.extend(mn_scale(10))
                else:
                    clone.prepend(mn_scale(10))
            else:
                print("Circle didn't intercept!!!\n")
                with self.scene.simultaneous():
                    px.e_remove()
                    lx.blue()
                    c.e_remove()
                    clone.e_remove()
                return lx, px

            np = P.EPoint(p[0])
            nl = ELine(target, np)

            if abs(self.get_length() - nl.get_length()) > mn_scale(0.1):
                np.e_remove()
                nl.extend(self.get_length() - nl.get_length())
                np = P.EPoint(nl.get_end())

            with self.scene.simultaneous():
                px.e_remove()
                lx.e_remove()
                c.e_remove()
                if clone.in_scene():
                    clone.e_remove()

            return nl, np

    def e_rotate_to(self, angle: float):
        theta = angle - self.get_angle()
        if theta > PI:
            theta -= TAU
        return self.e_rotate(self.get_start(), theta)

    def e_split(self, *points: Mobject | Vect3):
        cls = type(self)
        coords = [self.get_start(), *map(self.pointify, points), self.get_end()]
        lines = [
            cls(p1, p2, skip_anim=True).set_stroke(opacity=float(self.get_stroke_opacity()))
            for p1, p2 in pairwise(coords)
        ]
        self.e_delete()
        return lines

    def bisect(self, speed=1):
        cls = type(self)
        with self.scene.animation_speed(speed):
            c1 = Circle.ECircle(*self.get_start_and_end()[::-1]).e_fade()
            c2 = Circle.ECircle(*self.get_start_and_end()).e_fade()
            pts = c1.intersect(c2)
            l = cls(*pts).e_fade()

            pt = P.EPoint(l.intersect(self))
            with self.scene.simultaneous():
                c1.e_remove()
                c2.e_remove()
                l.e_remove()

        return pt

    def _perp_off_line(self, p: P.EPoint, dist_end: float, dist_start: float, /, speed=1):
        with self.scene.animation_speed(speed):
            A, B = self.get_start_and_end()
            C = self.pointify(p)
            p: Dict[str, P.EPoint] = {}
            c: Dict[str, C.ECircle] = {}
            l: ELine = self.copy().e_fade()
            l.extend_and_prepend(mn_scale(40))

            # draw a circle with the lesser of $re,$rs as the radius
            radius = min(dist_end, dist_start)
            c['C'] = Circle.ECircle(C, C + RIGHT * (radius + mn_scale(10)))

            # define two points equidistance from our initial point
            for num in range(0, 10):
                pts = c['C'].intersect(l)
                if len(pts) == 2:
                    break
                l.extend_and_prepend(mn_scale(100))

            p['D'] = P.EPoint(pts[0])
            p['E'] = P.EPoint(pts[1])
            c['C'].e_remove()

            lb = ELine(*pts).e_fade()
            pb = lb.bisect()
            lfinal = ELine(C, pb)
            with self.scene.simultaneous():
                p['D'].e_remove()
                p['E'].e_remove()
                lb.e_remove()
                pb.e_remove()
                l.e_remove()
        return lfinal

        pass

    def _perp_on_line(self, p: P.EPoint, dist_end: float, dist_start: float, /, speed=1, inside=False):
        with self.scene.animation_speed(speed):
            A, B = self.get_start_and_end()
            C = p.get_center()
            l: Dict[str, ELine] = {}
            p: Dict[str, P.EPoint] = {}
            c: Dict[str, Circle.ECircle] = {}
            ln: ELine = self.copy().e_fade()

            radius = max(dist_start, dist_end)
            ln.extend(dist_start - dist_end)
            c['C'] = Circle.ECircle(C, C + RIGHT * radius)

            # define two points equidistance from our initial point
            pts = c['C'].intersect(ln)
            p['D'] = P.EPoint(pts[0])
            p['E'] = P.EPoint(pts[1])

            c['C'].e_remove()

            # find 3rd point of equilateral triangle, without drawing lines
            c1 = Circle.ECircle(p['D'], p['E'])
            c2 = Circle.ECircle(p['E'], p['D'])
            pts = c1.intersect(c2)

            # if point is at either end of the line, check for positive/negative
            # options, otherwise go with defaults;
            if mn.get_norm(A - C) < mn_scale(.1) or mn.get_norm(B - C) < mn_scale(.1):
                l1 = ELine(C, pts[1], delay_anim=True)
                l2 = ELine(C, pts[0], delay_anim=True)
                a1 = Angel.calculateAngle(self, l1)
                a2 = Angel.calculateAngle(self, l2)

                if inside:
                    l2, l1 = l1, l2

                if abs(a1 - PI/2) < 0.1 * DEGREES:
                    l['CF'] = l1
                    l2.e_delete()
                elif abs(a2 - PI/2) < 0.1 * DEGREES:
                    l['CF'] = l2
                    l1.e_delete()
                else:
                    raise ArithmeticError(f"Bad Angles {a1=} and {a2=}")

                l['CF'].e_draw()
            else:
                l['CF'] = ELine(C, pts[int(inside)])

            with self.scene.simultaneous():
                p['D'].e_remove()
                p['E'].e_remove()
                c1.e_remove()
                c2.e_remove()
                ln.e_remove()
            return l['CF']

    def perpendicular(self, p: P.EPoint, /, speed=1, inside=False):
        rs = mn.get_norm(self.pointify(p) - self.get_start())
        re = mn.get_norm(self.pointify(p) - self.get_end())
        if (rs + re - self.get_length()) > mn_scale(0.1):
            return self._perp_off_line(p, re, rs, speed=speed)
        return self._perp_on_line(p, re, rs, inside=inside, speed=speed)

    def parallel(self, p: P.EPoint, /, speed=1):
        B, C = self.get_start_and_end()
        A = self.pointify(p)

        # make sure line goes from left to right
        if B[0] > C[0]:
            B, C = C, B

        # define a new line
        with self.scene.animation_speed(speed):
            tempC = C
            if mn.get_dist(B, C) < mn_scale(100):
                tempC = C + mn.normalize(C - B) * mn_scale(100)
            ln = ELine(B, tempC, stroke_color=GREEN)

            # is point on the line?
            rs = self.length_from_start(p)
            re = self.length_from_end(p)
            if abs(rs + re - self.get_length()) < mn_scale(0.1):
                clone = self.copy()
                ln.e_remove()
                return clone

            # create point D on the line
            pD = P.EPoint(ln.point_from_proportion(0.5))
            lBD, lDC = ln.e_split(pD)
            lAD = ELine(A, pD, stroke_color=BLUE)

            # copy angle
            aADC = Angel.EAngle(lDC, lAD)
            lEA, angle = aADC.copy_to_line(p, lAD, negative=True)

            # extend the line
            lEA.prepend(mn_scale(200))

            #cleanup
            with self.scene.delayed():
                aADC.e_remove()
                angle.e_remove()
                pD.e_remove()
                lAD.e_remove()
                lDC.e_remove()
                lBD.e_remove()
                ln.e_remove()

            return lEA





class VirtualLine(ELine):
    Virtual = True
