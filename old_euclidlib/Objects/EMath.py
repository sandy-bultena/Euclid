import math
import itertools as it
import operator as op

import numpy as np

gcd = math.gcd


def is_coprime(*nums: int):
    return gcd(*nums) == 1


def least_ratio(*nums: int):
    if len(nums) < 2:
        return nums
    divisor = gcd(*nums)
    return tuple(x // divisor for x in nums)


lcm = math.lcm


def find_continued_proportion(a: float, b: float, length: int):
    if length < 2:
        return a,
    if length == 2:
        return a, b
    prop = b/a
    return tuple(it.accumulate(it.repeat(prop, length-1), lambda a, b: int(a * b), initial=int(a ** (length - 1))))


def find_median_plane(x: int, y: int, z: int, w: int):
    assert abs(x // y - z // w) < 0.01
    return y * z


def find_plane_from_proportional(A: int, B: int, C: int, *, which: int):
    assert which in (1, 2, 3)
    assert abs(A // B - B // C) < 0.01

    # calculate sides
    D, E = least_ratio(A, C)
    F = A / D
    G = C / D

    # return appropriate sides
    if which == 1:
        return sorted([F, D])
    elif which == 2:
        return sorted([D, G])
    else:
        return sorted([G, E])


if __name__ == '__main__':
    print(f"{find_continued_proportion(2, 3, length=5) = }")
    print(f"{gcd(2, 6) = }")
    print(f"{gcd(1, 6) = }")
    print(f"{gcd(3, 6) = }")
    print(f"{gcd(4, 10) = }")
    print(f"{gcd(145, 63) = }")
    print(f"{gcd(2, 6, 3) = }")
    print(f"{gcd(12, 6, 18) = }")
    print(f"{gcd(12, 6, 21) = }")
    print()
    print(f"{least_ratio(2, 6) = }")
    print(f"{least_ratio(1, 6) = }")
    print(f"{least_ratio(3, 6) = }")
    print(f"{least_ratio(4, 10) = }")
    print(f"{least_ratio(145, 63) = }")
    print(f"{least_ratio(2, 6, 3) = }")
    print(f"{least_ratio(12, 6, 18) = }")
    print(f"{least_ratio(12, 6, 21) = }")
    print()
    print(f"{lcm(2, 6) = }")
    print(f"{lcm(1, 6) = }")
    print(f"{lcm(3, 6) = }")
    print(f"{lcm(4, 10) = }")
    print(f"{lcm(145, 63) = }")
    print(f"{lcm(2, 6, 3) = }")
    print(f"{lcm(12, 6, 18) = }")
    print(f"{lcm(12, 6, 21) = }")
