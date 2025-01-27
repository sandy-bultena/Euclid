from __future__ import annotations

from enum import EnumType, Enum

from euclidlib.Objects import Point as P
from euclidlib.Objects import Circle
from euclidlib.Objects import Triangle as T
from euclidlib.Objects import Text as Tx
import math
from euclidlib.Objects import EquilateralTriangle
from typing import Dict, Tuple
from euclidlib.Objects.EucidMObject import *

class EuclidLine(EMObject, mn.Line):
    CONSTRUCTION_TIME = 0.5
    LabelBuff = 0.15

    def IN(self):
        vec = self.get_unit_vector()
        return mn.rotate_vector(vec, PI/2)

    def OUT(self):
        vec = self.get_unit_vector()
        return mn.rotate_vector(vec, -PI/2)

    def __init__(self, start: EMObject | mn.Vect3, end: EMObject | mn.Vect3 | None = None, *args, **kwargs):
        if isinstance(start, str):
            from inspect import currentframe
            point_names = list(start)
            f = currentframe()
            while (f := f.f_back) is not None:
                if 'p' in f.f_locals or all(p in f.f_locals for p in point_names):
                    break
            if f is None:
                raise Exception("Can't Find Scene")
            s, e = start
            start = f.f_locals.get(s, f.f_locals.get('p', {}).get(s))
            end = f.f_locals.get(e, f.f_locals.get('p', {}).get(e))

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


    def intersect(self, l2: EuclidLine):
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

    def length_from_end(self, p: P.EuclidPoint):
        p.distance_to(self.get_end())

    def length_from_start(self, p: P.EuclidPoint):
        p.distance_to(self.get_start())

    def extend(self, r: float, rate_func=mn.smooth):
        if r < 0:
            return self.prepend(-r)
        x2, y2, _ = self.point(r + self.get_length())
        self.e_end = (x2, y2, 0)
        self.scene.play(self.animate(rate_func=rate_func).set_points_by_ends(self.get_start(), self.e_end))

    def prepend(self, r: float, rate_func=mn.smooth):
        x2, y2, _ = self.point(-r)
        self.e_start = (x2, y2, 0)
        self.scene.play(self.animate(rate_func=rate_func).set_points_by_ends(self.e_start, self.get_end()))

    def extend_cpy(self, r: float):
        if r < 0:
            return self.prepend_cpy(-r)
        x2, y2, _ = self.point(r + self.get_length())
        return EuclidLine(self.get_end(), (x2, y2, 0))

    def prepend_cpy(self, r: float):
        x2, y2, _ = self.point(-r)
        return EuclidLine(self.get_start(), (x2, y2, 0))

    def copy_to_point(self, target: P.EuclidPoint, speed=1) -> Tuple[EuclidLine, P.EuclidPoint]:
        A = self.get_start()
        B = self.get_end()
        C = self.pointify(target)

        l: Dict[str | int, EuclidLine] = {}
        p: Dict[str | int, P.EuclidPoint] = {}
        c: Dict[str | int, Circle.EuclidCircle] = {}
        t: Dict[str | int, T.EuclidTriangle] = {}

        with self.scene.animation_speed(speed):
            # ------------------------------------------------------------------------
            # If point is already on the line, just make a clone, and return results
            # ------------------------------------------------------------------------
            if abs(A[0] - C[0]) < 0.1 and abs(A[1] - C[1] < 0.1):
                lCF = self.copy()
                pF = P.EuclidPoint(C, scene=self.scene)
                return lCF, pF

            # ------------------------------------------------------------------------
            # Copy the line to the new point using methods from proposition 2
            # ------------------------------------------------------------------------

            # join the two lines
            l['AC'] = EuclidLine(A, C, scene=self.scene).e_fade()

            # construct equilateral on above line (D = apex of triangle)
            t[1], p['D'] = EquilateralTriangle.build(A, C)
            with self.scene.simultaneous():
                l['AD'] = t[1].l[2]
                l['CD'] = t[1].l[1]
            with self.scene.simultaneous():
                t[1].e_fade()

            def find_extended_intersection(p1, p2, circle, line, extend_dir=1):
                c[circle] = Circle.EuclidCircle(p1, p2, scene=self.scene).e_fade()
                pts = c[circle].intersect(l[line])
                for _ in range(100):
                    if pts:
                        break
                    l[line].extend(mn_scale(100 * extend_dir), rate_func=mn.linear)
                    pts = c[circle].intersect(l[line])
                else:
                    raise Exception("Infinite Loop")
                l[line].e_fade()
                return pts

            pts = find_extended_intersection(A, B, 'C', 'AD', -1)

            p['E'] = P.EuclidPoint(pts[0], scene=self.scene)
            p['B'] = P.EuclidPoint(B, scene=self.scene)

            if p['D'].distance_to(pts[0]) > mn_scale(1):
                F = find_extended_intersection(p['D'], p['E'], 'D', 'CD')
            else:
                F = [p['E'].get_center()]

            pF = P.EuclidPoint(F[0])
            lCF = EuclidLine(C, F[0])

            with self.scene.simultaneous():
                for group in (p, l, c, t):
                    for obj in group.values():
                        obj.e_remove()

            return lCF, pF

    def copy_to_line(self, target: P.EuclidPoint, target_line: EuclidLine, speed=1):
        lx, px = self.copy_to_point(target, speed=speed)
        if lx is None or px is None:
            return

        with self.scene.animation_speed(speed):
            c = Circle.EuclidCircle(target, lx.get_end())

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

            np = P.EuclidPoint(p[0])
            nl = EuclidLine(target, np)

            if abs(self.get_length() - nl.get_length()) > mn_scale(0.1):
                np.e_remove()
                nl.extend(self.get_length() - nl.get_length())
                np = P.EuclidPoint(nl.get_end())

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


class VirtualLine(EuclidLine):
    Virtual = True
