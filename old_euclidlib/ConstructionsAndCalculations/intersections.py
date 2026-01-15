from manimlib import Mobject
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import manimlib as mn

# -----------------------------------------------------------------------------------------------------------------
# find intersection between two manim lines, or manim line and manim rectangle
# -----------------------------------------------------------------------------------------------------------------
def intersect(self, other: Mobject, reverse=True):
    if isinstance(other, mn.Line):
        return self.intersect_line(other)
    if isinstance(other, mn.Rectangle):
        return self.intersect_selection(other)
    return super().intersect(other)


# -----------------------------------------------------------------------------------------------------------------
# find intersection between line and rectangle
# -----------------------------------------------------------------------------------------------------------------
def intersect_selection(self, other: mn.Rectangle):
    if other.get_arc_length() < 1e-3:
        other = mn.Rectangle(0.2, 0.2).move_to(other)
    corners = [other.get_corner(x) for x in [UL, UR, DR, DL, UL]]
    return any(self.intersect_bound_line(mn.Line(x, y)) for x, y in pairwise(corners)) or (
            other.is_point_touching(self.get_start()) and other.is_point_touching(self.get_end())
    )


# -----------------------------------------------------------------------------------------------------------------
# find intersection between line, and another bound line (as opposed to an infinite line)
# -----------------------------------------------------------------------------------------------------------------
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


# -----------------------------------------------------------------------------------------------------------------
# find intersection of line, and other infinite line
# -----------------------------------------------------------------------------------------------------------------
def intersect_line(self, l2: mn.Line):
    (x00, y00, _), (x01, y01, _) = self.get_start_and_end()
    (x10, y10, _), (x11, y11, _) = l2.get_start_and_end()
    m1 = self.get_e_slope()
    m2 = l2.get_e_slope()

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

    return np.array([x, y, 0])
