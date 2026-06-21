
import math
class ENumbers:
    # ============================================================================
    # gcd
    # ============================================================================
    # Note, this is a terribly inefficient algorithm  :)
    @staticmethod
    def gcd(n,*rest):
        numbers = [n,*rest]
        b=n

        # find gcd, for each pair
        while len(numbers) > 1:
            a,b,*rest = numbers
            a,b = sorted((a,b))

            # for this pair, repeatedly subtract the smaller from the larger,
            # switching roles as required
            while 1 < b != a and a > 0:
                b, a = a, b%a
            numbers = [b,*rest]
        return b

    # ============================================================================
    # are_coprime
    # ============================================================================
    @staticmethod
    def are_coprime(n1, n2, *rest):
        """if the series of numbers are prime to each other, not if each
        individual number is prime"""
        return True if ENumbers.gcd(n1, n2, *rest) == 1 else False

    # ============================================================================
    # least_ratio
    # ============================================================================
    @staticmethod
    def least_ratio(n1, n2, *rest):
        """least ratio (VII.33)"""

        gcd = ENumbers.gcd(n1, n2, *rest)
        return list(map(lambda x: x//gcd, (n1, n2, *rest)))

    # ============================================================================
    # lcm
    # ============================================================================
    @staticmethod
    def lcm(n1, *rest):
        """least common multiple (VII.34)"""

        lcm = n1
        numbers = [n1, *rest]

        # find lcm for each pair iteratively
        while len(numbers) > 1:
            a,b,*rest = numbers
            if ENumbers.are_coprime(a,b):
                lcm = a * b
            else:
                least_ratio = ENumbers.least_ratio(a, b)
                lcm = least_ratio[1] * a
            numbers = [lcm, *rest]

        return lcm

    # ============================================================================
    # find_continued_proportion
    # ============================================================================
    @staticmethod
    def find_continued_proportion(n1, n2, size):
        """tuple of numbers in continuous proportion to 1st two numbers in (VIII.2)"""

        a,b = ENumbers.least_ratio(n1, n2)
        return [a**(size-i-1)*b**i for i in range(size)]

    # ============================================================================
    # find median(s) of similar (plane), or (solid) numbers
    # ============================================================================
    @staticmethod
    def find_median_plane(a1,a2, b1,b2):
        """ array of four numbers where the 1st two are the sides of the
            first plane number, and 2nd two are the sides of the second plane number.
            TWO PLANE NUMBERS MUST BE SIMILAR VIII.18"""
        if abs(a1/a2 - b1/b2) > 1E9:
            raise TypeError("the sides of the two plane numbers must be similar!")
        return a2*b1

    # ============================================================================
    # find plane numbers from 3 numbers proportional to each other
    # ============================================================================
    @staticmethod
    def find_plane_from_proportional(a,c, b):
        """Given three numbers in proportion, find the two sides of each plane number VIII.20"""
        if abs(a/c - c/b) > 1E9:
            raise TypeError(f"The three numbers {a}, {c}, {b} are not continuously proportional")
        d,e = ENumbers.least_ratio(a,c)
        return a//d, d, b//e, e

if __name__ == "__main__":

    print()
    print ("2,6 gcd? ",    ENumbers.gcd(2,6), math.gcd(2,6))
    print ("1,6 gcd? ",    ENumbers.gcd(1,6), math.gcd(1,6))
    print ("3,6 gcd? ",    ENumbers.gcd(3,6), math.gcd(3,6))
    print ("4,10 gcd? ",   ENumbers.gcd(4,10), math.gcd(4,10))
    print ("145,63 gcd? ", ENumbers.gcd(145,63), math.gcd(145,63))
    print ("2,6,3 gcd? ",   ENumbers.gcd(2,6,3), math.gcd(2,6,3))
    print ("12,6,18 gcd? ", ENumbers.gcd(12,6,18), math.gcd(12,6,18))
    print ("12,6,21 gcd? ", ENumbers.gcd(12,6,21), math.gcd(12,6,21))

    print ("2,6 least ratio? ", ENumbers.least_ratio(2,6))
    print ("1,6 least ratio? ", ENumbers.least_ratio(1,6))
    print ("3,6 least ratio? ", ENumbers.least_ratio(3,6))
    print ("4,10 least ratio? ", ENumbers.least_ratio(4,10))
    print ("143,63 least ratio? ", ENumbers.least_ratio(143,63))
    print ("2,6,3 least ratio? ", ENumbers.least_ratio(2,6,3))
    print ("12,6,18 least ratio? ", ENumbers.least_ratio(12,6,18))
    print ("12,6,21 least ratio? ", ENumbers.least_ratio(12,6,21))

    print ("2,6 LCM? ", ENumbers.lcm(2,6))
    print ("1,6 LCM? ", ENumbers.lcm(1,6))
    print ("3,6 LCM? ", ENumbers.lcm(3,6))
    print ("4,10 LCM? ", ENumbers.lcm(4,10))
    print ("143,63 LCM? ", ENumbers.lcm(143,63))
    print ("2,6,3 LCM? ", ENumbers.lcm(2,6,3))
    print ("12,6,18 LCM? ", ENumbers.lcm(12,6,18))
    print ("12,6,21 LCM? ", ENumbers.lcm(12,6,21))

    print ("2,6 conintued proportion? ", ENumbers.find_continued_proportion(2,6,5))
    print ("1,6 conintued proportion? ", ENumbers.find_continued_proportion(1,6,5))
    print ("3,6 conintued proportion? ", ENumbers.find_continued_proportion(3,6,5))
    print ("4,10 conintued proportion? ", ENumbers.find_continued_proportion(4,10,5))
    print ("143,63 conintued proportion? ", ENumbers.find_continued_proportion(143,63,5))
    print ("2,6 conintued proportion? ", ENumbers.find_continued_proportion(2,6,5))
    print ("12,6 conintued proportion? ", ENumbers.find_continued_proportion(12,6,3))
    print ("12,7 conintued proportion? ", ENumbers.find_continued_proportion(12,7,3))
    print(f"sides of plane numbers from sequence 3,12,48", ENumbers.find_plane_from_proportional(3,12,48))

