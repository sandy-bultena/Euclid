from .Line import EuclidLine
from manimlib import TAU
import math

def calculateAngle(l1: EuclidLine, l2: EuclidLine):
    # assert l1.get_start() == l2.get_start()
    th1 = math.atan2(
        l1.get_end()[1] - l1.get_start()[1],
        l1.get_end()[0] - l1.get_start()[0],
    )
    th2 = math.atan2(
        l2.get_end()[1] - l2.get_start()[1],
        l2.get_end()[0] - l2.get_start()[0],
    )

    th_diff = th2 - th1
    return th_diff % (2 * TAU)