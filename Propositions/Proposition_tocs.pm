#!/usr/bin/perl
use strict;
use warnings;

package Proposition;
our $sky_blue;

# ============================================================================
# TOC for Book 1
# ============================================================================
sub toc {
    my $pn = shift;
    my $current = shift || 0;
    my @descr1 = (
                   "Construct an equilateral triangle",
                   "Copy a line",
                   "Subtract one line from another",
                   "Equal triangles if equal side-angle-side",
                   "Isosceles triangle gives equal base angles",
                   "Equal base angles gives isosceles triangle",
                   "Two sides of triangle meet at unique point",
                   "Equal triangles if equal side-side-side",
                   "How to bisect an angle",
                   "Bisect a line",
                   "Construct right angle, point on line",
                   "Construct perpendicular, point to line",
                   "Sum of angles on straight line = 180",
                   "Two lines form a single line if angle = 180",
                   "Vertical angles equal one another",
                   "Exterior angle larger than interior angle",
                   "Sum of two interior angles less than 180",
                   "Greater side opposite of greater angle",
                   "Greater angle opposite of greater side",
                   "Sum of two angles greater than third",
                   "Triangle within triangle has smaller sides",
                   "Construct triangle from given lines",
                   "Copy an angle",
                   "Larger angle gives larger base",
                   "Larger base gives larger angle",
                   "Equal triangles if equal angle-side-angle",
                   "Alternate angles equal then lines parallel",
                   "Sum of interior angles = 180 , lines parallel",
                   "Lines parallel, alternate angles are equal",
                   "Lines parallel to same line are parallel to themselves",
                   "Construct one line parallel to another",
                   "Sum of interior angles of a triangle = 180",
                   "Lines joining ends of equal parallels are parallel",
                   "Opposite sides-angles equal in parallelogram",
                   "Parallelograms, same base-height have equal area",
                   "Parallelograms, equal base-height have equal area",
                   "Triangles, same base-height have equal area",
                   "Triangles, equal base-height have equal area",
    );
    my @descr2 = (
                   "Equal triangles on same base, have equal height",
                   "Equal triangles on equal base, have equal height",
                   "Triangle is half parallelogram with same base and height",
                   "Construct parallelogram with equal area as triangle",
                   "Parallelogram complements are equal",
                   "Construct parallelogram on line, equal to triangle",
                   "Construct parallelogram equal to polygon",
                   "Construct a square",
                   "Pythagoras' theorem",
                   "Inverse Pythagoras' theorem",
    );
    return ( toc_sub( $pn, 1, $current, 0, \@descr1 ),
             toc_sub( $pn, 1, $current, 38, \@descr2 ), );
}

# ============================================================================
# TOC for Book 2
# ============================================================================
sub toc2 {
    my $pn      = shift;
    my $current = shift;
    my @descr = (
        "A\\{dot}BC = A\\{dot}BD + A\\{dot}DE + A\\{dot}EC",
        "AB\\{squared} = AB\\{dot}AC + AB\\{dot}BC",
        "AB\\{dot}CB = AC\\{dot}CB + CB\\{squared}",
        "AB\\{squared} = AC\\{squared} + CB\\{squared}"
          . " + 2\\{dot}AC\\{dot}CB",
        "AD\\{dot}DB + CD\\{squared} = CB\\{squared}",
        "AD\\{dot}DB + CB\\{squared} = CD\\{squared}",
        "AB\\{squared} + BC\\{squared} = AC\\{squared}"
          . " + 2\\{dot}AB\\{dot}BC",
        "4\\{dot}AB\\{dot}BC + AC\\{squared} = (AB+BC)\\{squared}",
        "AD\\{squared} + DB\\{squared} = 2\\{dot}(AC\\{squared}"
          . " + CD\\{squared})",
        "AD\\{squared} + DB\\{squared} = "
          . "2\\{dot}(AC\\{squared} + CD\\{squared})",
        "Find H.  AB\\{dot}BH = AH\\{squared}",
        "Cosine Law. BC\\{squared} = "
          . "AB\\{squared}+AC\\{squared}+2\\{dot}AD\\{dot}AC",
        "Cosine Law. AC\\{squared} = "
          . "AB\\{squared}+BC\\{squared}-2\\{dot}BD\\{dot}BC",
        "Find square of polygon",

    );
    my @code = (
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 200, $ys );
            Point->new( $pn, $xs + 80,  $ys + 40 )->label(qw(B left));
            Point->new( $pn, $xs + 300, $ys + 40 )->label(qw(C right));
            Line->new( $pn, $xs + 80, $ys + 40, $xs + 300, $ys + 40 );
            Point->new( $pn, $xs + 200, $ys + 40 )->label(qw(D top ));
            Point->new( $pn, $xs + 250, $ys + 40 )->label(qw(E top));
            return 70;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 300, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B right));
            Point->new( $pn, $xs + 224, $ys )->label(qw(C top));
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 300, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B right));
            Point->new( $pn, $xs + 224, $ys )->label(qw(C top));
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 300, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B right));
            Point->new( $pn, $xs + 224, $ys )->label(qw(C top));
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 300, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B right));
            Point->new( $pn, $xs + 190, $ys )->label(qw(C top));
            Point->new( $pn, $xs + 275, $ys )->label(qw(D top));
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 380, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B top));
            Point->new( $pn, $xs + 190, $ys )->label(qw(C top));
            Point->new( $pn, $xs + 380, $ys )->label(qw(D top));
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 300, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B right));
            Point->new( $pn, $xs + 224, $ys )->label(qw(C top));
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 300, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B right));
            Point->new( $pn, $xs + 224, $ys )->label(qw(C top));
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 300, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B right));
            Point->new( $pn, $xs + 190, $ys )->label(qw(C top));
            Point->new( $pn, $xs + 275, $ys )->label(qw(D top));
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 380, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B top));
            Point->new( $pn, $xs + 190, $ys )->label(qw(C top));
            Point->new( $pn, $xs + 380, $ys )->label(qw(D top));
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            Point->new( $pn, $xs + 80, $ys )->label(qw(A left));
            Line->new( $pn, $xs + 80, $ys, $xs + 300, $ys );
            Point->new( $pn, $xs + 300, $ys )->label(qw(B right));
            Point->new( $pn, $xs + 220, $ys )->label( " H?", "top" );
            return 30;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            my $s =
              Triangle->new( $pn,      $xs + 180, $ys + 80, $xs + 300,
                             $ys + 80, $xs + 40,  $ys );
            $s->set_points(qw(A bottom C bottom B top));
            $s->fill($sky_blue);
            my ( %l, %p );
            @l{ "AC", "CB", "BA" } = $s->lines;
            @p{ "A",  "C",  "B" }  = $s->points;

            $l{ADt} = $l{AC}->clone;
            $l{ADt}->prepend(200)->grey;
            $l{BD} = $l{ADt}->perpendicular( $p{B} );
            my @D = $l{ADt}->intersect( $l{BD} );
            Point->new( $pn, @D )->label( "D", "bottom" );
            Line->new( $pn, @D, $xs + 180, $ys + 80 );
            $l{ADt}->remove;
            return 140;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            my $s =
              Triangle->new( $pn,      $xs + 40,  $ys + 80, $xs + 300,
                             $ys + 80, $xs + 180, $ys );
            $s->set_points(qw(B bottom C bottom A top));
            $s->fill($sky_blue);
            my ( %l, %p );
            @l{ "BC", "CA", "AB" } = $s->lines;
            @p{ "B",  "C",  "A" }  = $s->points;
            $l{AD} = $l{BC}->perpendicular( $p{A} );
            my @D = $l{AD}->intersect( $l{BC} );
            Point->new( $pn, @D )->label( "D", "bottom" );
            Line->new( $pn, @D, $xs + 40, $ys + 80 );
            return 140;
        },
        sub {
            my $pn = shift;
            my $xs = shift;
            my $ys = shift;
            my $s = Polygon->new(
                                  $pn,       4,        $xs + 40,  $ys + 80,
                                  $xs + 250, $ys + 80, $xs + 280, $ys + 40,
                                  $xs + 180, $ys
            );
            $s->fill($sky_blue);
            return 120;
        },
    );
    return (
        sub {
            local $Shape::AniSpeed = 100 * $Shape::AniSpeed;
            $pn->clear();
            my ( $x, $y ) = $pn->center_coords();
            my $cn = $pn->Tk_canvas();
            $cn->createText(
                             $x, $y - 350,
                             -text   => "Table of Contents, Chapter 2",
                             -font   => "title",
                             -anchor => "n",
            );

            for my $i ( 1 .. 14 ) {
                proptoc( $pn, $i, $descr[ $i - 1 ], $code[ $i - 1 ], $current );
            }
          }

    );
}

# ============================================================================
# TOC for Book 3
# ============================================================================
sub toc3 {
    my $pn      = shift;
    my $current = shift;
    my @descr1 = (
        "To find the centre of a circle",
        "A chord of a circle always lies inside the circle",
        "A line through the centre of a circle bisects "
          . "a chord, and vice versa",
        "A line not through the centre of a circle "
          . "does not bisect a chord",
        "If two circles cut one another, they will "
          . "not have the same center",
        "If two circles touch one another, they will "
          . "not have the same center",
        "Consider two lines from a point inside a "
          . "circle to the edge, the longer "
          . "one will be the one closest to the longest part of the diameter passing "
          . "through the original point",
        "Consider two lines from a point outside a circle to the edge, "
          . "the line closest to the centre will be longer on the concave side and "
          . "shorter on the convex side",
        "If three lines, starting at a point 'A' and touching "
          . "the circle, are all equal, then 'A' is the centre of the circle",
        "A circle does not cut a circle at more points than two",
        "Point of contact between two internal circles, "
          . "and their centres, are collinear",
        "Point of contact between two external circles, "
          . "and their centres, are collinear",
        "A circle does not touch a circle at more points than one, "
          . "whether it touch it internally "
          . "or externally.",
        "In a circle equal straight lines are equally "
          . "distant from the centre, and "
          . "those which are equally distant from the centre "
          . "are equal to one another.",
        "The longest line in a circle is its diameter, "
          . "shorter the farther away from the diameter",
        "A line on the circle, perpendicular to the "
          . "diameter, lies outside the circle",
        "From a given point to draw a straight "
          . "line touching a given circle",
        "If line touches a circle, then it is "
          . "perpendicular to the diameter "
          . "that touches that point",
        "If line touches a circle, then the centre of the circle "
          . "lies on a line perpendicular to the original",
        "The angle at the centre of a circle is twice "
          . "that from an angle from the circumference",
        "In a circle the angles in the same segment are equal to one another",
        "The opposite angles of quadrilaterals in circles are equal to "
          . "two right angles",
        "On the same straight line there cannot be constructed two similar "
          . "and unequal segments of circles on the same side",
        "Similar segments of circles on equal straight lines are "
          . "equal to one another",
    );
    my @descr2 = (
        "Given a segment of a circle, to describe the complete "
          . "circle of which it is a segment.",
        "In equal circles equal angles stand on equal circumferences",
        "In equal circles angles standing on equal circumferences "
          . "are equal to one another",
        "In equal circles equal straight lines cut off equal circumferences",
        "In equal circles equal circumferences are "
          . "subtended by equal straight lines",
        "To bisect a given circumference",
        "In a circle the angle in the semicircle is right ...",
        "The angle between a tangent and a "
          . "straight line cutting a circle is equal to the angle "
          . "in the alternate segment",
        "Construct a circle segment on a given line, such that the angle "
          . "within the segment is equal to a given angle",
        "Construct a circle segment on a given circle, such that the angle "
          . "within the segment is equal to a given angle",
        "If two circle chords intersect, the segments on one "
          . "multiplied together equals the segments of the other multiplied together",
        "Secant-tangent law",
        "Converse of the secant-tangent law",
    );
    return ( toc_sub( $pn, 3, $current, 0, \@descr1 ),
             toc_sub( $pn, 3, $current, 24, \@descr2 ), );
}

# ============================================================================
# TOC for Book 4
# ============================================================================
sub toc4 {
    my $pn      = shift;
    my $current = shift;
    my @descr1 = (
        "Fit a given straight line into a given circle, if the "
          . "line is less than the diameter",
        "In a given circle to inscribe a triangle equiangular "
          . "with a given triangle",
        "About a given circle to circumscribe a triangle "
          . "equiangular with a given triangle",
        "In a given triangle, to inscribe a circle",
        "About a given triangle to circumscribe a circle",
        "In a given circle to inscribe a square",
        "About a given circle to circumscribe a square",
        "In a given square, to inscribe a circle",
        "About a given square, to circumscribe a circle",
        "To construct an isosceles triangle having each of the angles at "
          . "the base double of the remaining one",
        "In a given circle to inscribe an equilateral and equiangular pentagon",
        "About a given circle to circumscribe an equilateral "
          . "and equiangular pentagon",
        "In a given pentagon, which is equilateral and equiangular,"
          . " to inscribe a circle",
        "About a given pentagon, which is equilateral and equiangular, to "
          . "circumscribe a circle",
        "In a given circle to inscribe an equilateral and equiangular hexagon",
        "In a given circle to inscribe a fifteen angled figure which shall "
          . "be both equilateral and equiangular",
    );
    return ( toc_sub( $pn, 4, $current, 0, \@descr1 ), );

}

# ============================================================================
# TOC for Book 5
# ============================================================================
sub toc5 {
    my $pn      = shift;
    my $current = shift;
    my @descr1 = (
                "n\\{dot}X + n\\{dot}Y = n\\{dot}(X + Y)",
                "if n\\{dot}C + m\\{dot}C = k\\{dot}C then\n"
                  . "   n\\{dot}F + m\\{dot}F = k\\{dot}F",
                "if E=m\\{dot}(n\\{dot}B) and G=m\\{dot}(n\\{dot}D) then\n"
                  . "   E=k\\{dot}B and G=k\\{dot}B",
                "if A:B=C:D     "
                  . "then\n   (p\\{dot}A):(q\\{dot}B)=(p\\{dot}C):(q\\{dot}D)",
                "n\\{dot}X - n\\{dot}Y = n\\{dot}(X - Y)",
                "if n\\{dot}E - m\\{dot}E = k\\{dot}E then\n"
                  . "   n\\{dot}F - m\\{dot}F = k\\{dot}F",
                "if A = B \\{notequal} C then\n" . "   A:C = B:C and C:A = C:B",
                "if A > B \\{notequal} D then\n" . "   A:D > B:D and D:A < D:B",
                "if A:C = B:C, or C:A = C:B then\n" . "   A = B",
                "if A:C > B:C, or A:C < B:C then\n"
                  . "   A > B, or A < C, respectively",
                "if A:B = C:D and C:D = E:F then\n" . "   A:B = E:F",
                "if A:B = C:D = E:F then\n" . "   (A+C+E):(B+D+F) = A:B",
                "if A:B = C:D and C:D > E:F then\n" . "   A:B > E:F",
                "if A:B = C:D and A > C then\n" . "   B > D",
                "if A = n\\{dot}C and B = n\\{dot}D then\n" . "   A:B = C:D",
                "if A:B = C:D then\n" . "   A:C = B:D",
                "if (A+B):B = (C+D):D then\n" . "   A:B = C:D",
                "if A:B = C:D then\n" . "   (A+B):B = (C+D):D",
                "if (A+C):(B+D) = C:D then\n" . "   (A+C):(B+D) = A:B",
                "if A:B = D:E, B:C = E:F\n" . "   and if A > C, then D > F",
                "if A:B = E:F, B:C = D:E\n" . "   and if A > C, then D > F",
                "if A:B = D:E, B:C = E:F then\n" . "   A:C = D:F",
                "if A:B = E:F, B:C = D:E then\n" . "   A:C = D:F",
                "if A:C = D:F, B:C = E:F then\n" . "   (A+B):C = (D+E):F",
                "if A:B = C:D and\n"
                  . "   A > B,C,D and D < A,B,C then\n"
                  . "   (A+D) > (B+C)",
    );
    return ( toc_sub( $pn, 5, $current, 0, \@descr1 ), );

}

# ============================================================================
# TOC for Book 6
# ============================================================================
sub toc6 {
    my $pn      = shift;
    my $current = shift;
    my @descr1 = (
        "If the height of two triangles are equal, then the ratio "
          . "of the areas is equal to the ratio of the bases",
        "If a line cuts a triangle, parallel to its base, "
          . "it will cut the sides of the triangle proportionally",
        "If an angle of a triangle is bisected and the straight line cutting "
          . "the angle also cuts the base, the segments of the base will have the same ratio "
          . "as the remaining sides of the triangle",
        "If two triangles have equal angles, then the sides opposite the equal "
          . "angles are proportional, as well, the sides of the triangles on either "
          . "side of the equal angles are also proportional",
        "It two triangles have proportional sides, the triangles will "
          . "be equiangular",
        "If two triangles have one angle equal to one angle and the sides "
          . "about the equal angles are proportional, then the triangles "
          . "will be equiangular",
        "If two triangles have one angle equal to one angle, and the sides "
          . "about other angles are proportional, and the "
          . "remaining angles either both less "
          . "or both not less than a right angle, "
          . "then triangles will be equiangular",
        "If in a right-angled triangle a perpendicular be drawn from the "
          . "right angle to the base, the triangles adjoining the "
          . "perpendicular are similar "
          . "both to the whole and to one another",
        "From a given straight line to cut off a given fraction",
        "To cut a given uncut straight line similarly to a "
          . "given cut straight line",
        "To two given straight lines to find a third proportional",
        "To three given straight lines to find a fourth proportional",
        "To two given straight lines to find a mean proportional",
        "In equal and equiangular parallelograms, the sides about the "
          . "equal angles are reciprocally proportional; and vice versa",
        "In equal triangles which have one angle equal to one angle the "
          . "sides about the equal angles are reciprocally proportional; and vice versa",
        "If four straight lines are proportional, the rectangle contained "
          . "by the extremes is equal to the rectangle contained by the means, and vice versa",
        "If three straight lines are proportional, the rectangle contained "
          . "by the extremes is equal to the square on the mean; and vice versa",
        "On a given straight line to describe a rectilineal figure similar "
          . "and similarly situated to a given rectilineal figure",
        "Similar triangles are to one another in the duplicate ratio "
          . "of the corresponding sides",

    );
    my @descr2 = (
        "Similar polygons are divided into the same number of "
          . "similar triangles, "
          . "which have the same ratio as the wholes, and the "
          . "polygons have duplicate ratios to their corresponding sides",
        "Figures which are are similar to the same rectilineal "
          . "figure are also similar to one another",
        "If four straight lines are proportional, similar rectilineal figures "
          . "will also be proportional; and vice versa",
        "Equiangular parallelograms have to one another the ratio "
          . "compounded of the ratios of their sides",
        "In any parallelogram the parallelograms about the diameter are "
          . "similar both to the whole and to one another",
        "To construct one and the same figure similar to a given rectilineal "
          . "figure and equal to another given rectilineal figure",
        "If from a parallelogram a similar parallelogram with a common angle "
          . "is subtracted, it is about the same diameter as the original",
        "Of all the parallelograms applied to the same straight line "
          . "and deficient by parallelogrammic figures similar to a parallelogram "
          . "drawn on half the said line, the largest will be one that is drawn on half "
          . "of the straight line and "
          . "is similar to the defect",
        "To a given straight line, apply a parallelogram equal "
          . "to a given rectilineal figure and deficient by a parallelogrammic "
          . "figure similar to a given one",
        "To a given straight line, apply a parallelogram equal "
          . "to a given rectilineal figure and exceeding by a parallelogrammic "
          . "figure similar to a given one",
        "To cut a finite straight line in extreme ratio",
        "In right-angled triangles the figure on the side subtending the "
          . "right angle is equal to the similar and similarly described figures "
          . "on the sides containing the right angle",
        "If two triangles having two sides proportional to two sides be "
          . "placed together at one angle so that their corresponding sides are also "
          . "parallel, the remaining sides of the triangle will be in a straight line",
        "In equal circles angles have the same ratio as the "
          . "circumferences on which they stand, whether they stand at the centres or at "
          . "the circumferences",
    );
    return ( toc_sub( $pn, 6, $current, 0, \@descr1 ),
             toc_sub( $pn, 6, $current, 19, \@descr2 ), );

}

# ============================================================================
# TOC for Book 7
# ============================================================================
sub toc7 {
    my $pn      = shift;
    my $current = shift;
    my @descr1 = (
        "Determine if two numbers are relatively prime",
        "Find the greatest common divisor for two numbers",
        "Find the greatest common divisor for three numbers",
        "Given two natural numbers, A and B, either B is part of A, "
          . "or there exists a natural "
          . "number (a part) that can measure both A and B",
        "If B\\{nb}=\\{nb}\\{nb}(1/q)\\{dot}A and "
          . "D\\{nb}=\\{nb}(1/q)\\{dot}C, then (B+D)\\{nb}=\\{nb}(1/q)\\{dot}(A+C)",
        "If B\\{nb}=\\{nb}(p/q)\\{dot}A and D\\{nb}=\\{nb}(p/q)\\{dot}C, then "
          . "(B+D)\\{nb}=\\{nb}(p/q)\\{dot}(A+C)",
        "If B\\{nb}=\\{nb}A/q and D\\{nb}=\\{nb}C/q, "
          . "B>D, then (B-D)\\{nb}=\\{nb}(A-C)/q",
        "If B\\{nb}=\\{nb}(p/q)\\{dot}A and "
          . "D\\{nb}=\\{nb}(p/q)\\{dot}C, B>D, then "
          . "(B-D)\\{nb}=\\{nb}(p/q)\\{dot}(A-C)",
        "If B\\{nb}=\\{nb}(1/q)\\{dot}A and D\\{nb}=\\{nb}(1/q)\\{dot}C, and "
          . "If B\\{nb}=\\{nb}(r/s)\\{dot}D, then A\\{nb}=\\{nb}(r/s)\\{dot}C",
        "If B\\{nb}=\\{nb}(p/q)\\{dot}A and D\\{nb}=\\{nb}(p/q)\\{dot}C, and "
          . "If B\\{nb}=\\{nb}(r/s)\\{dot}D, then A\\{nb}=\\{nb}(r/s)\\{dot}C",
        "If A:B\\{nb}=\\{nb}C:D, then (A-C):(B-D)\\{nb}=\\{nb}A:B",
        "If A:B\\{nb}=\\{nb}C:D, then (A+C):(B+C)\\{nb}=\\{nb}A:B",
        "If A:B\\{nb}=\\{nb}C:D, then A:C\\{nb}=\\{nb}B:D",
        "If A:B\\{nb}=\\{nb}D:E and B:C\\{nb}=\\{nb}E:F, "
          . "then A:C\\{nb}=\\{nb}D:F",
        "If B\\{nb}=\\{nb}i\\{dot}1 and E\\{nb}=\\{nb}i\\{dot}D, and "
          . "if D\\{nb}=\\{nb}j\\{dot}1 then E\\{nb}=\\{nb}j\\{dot}B",
        "A\\{nb}\\{times}\\{nb}B\\{nb}=\\{nb}B\\{nb}\\{times}\\{nb}A",
        "If D\\{nb}=\\{nb}A\\{nb}\\{times}\\{nb}B and "
          . "E\\{nb}=\\{nb}A\\{nb}\\{times}\\{nb}C then "
          . "D:E\\{nb}=\\{nb}B:C",
        "If D\\{nb}=\\{nb}B\\{nb}\\{times}\\{nb}A and "
          . "E\\{nb}=\\{nb}C\\{nb}\\{times}\\{nb}A then "
          . "D:E\\{nb}=\\{nb}B:C",
        "If A:B\\{nb}=\\{nb}C:D then "
          . "A\\{nb}\\{times}\\{nb}D\\{nb}=\\{nb}B\\{nb}\\{times}\\{nb}C\n"
          . "If A\\{nb}\\{times}\\{nb}D\\{nb}=\\{nb}B\\{nb}\\{times}\\{nb}C "
          . "then A:B\\{nb}=\\{nb}C:D",
        "Given the ratio A:B and C,D are the smallest numbers such that "
          . "A:B\\{nb}=\\{nb}C:D then A\\{nb}=\\{nb}n\\{dot}C and "
          . "B\\{nb}=\\{nb}n\\{dot}D",
        "If A,B are relatively prime, then A,B are the smallest whole numbers "
          . "that can be used to describe the ratio A:B",
        "If A,B are the smallest whole numbers "
          . "that can be used to describe the ratio A:B, then "
          . "A,B are relatively prime",
        "If A,B are relatively prime and if A\\{nb}=\\{nb}n\\{dot}C, then "
          . "B,C are relatively prime",
        "If A,C are relatively prime and B,C are relatively prime "
          . "then the A\\{nb}\\{times}\\{nb}B is relatively prime to C",
        "If A,B are relatively prime then A\\{^2},B are relatively prime",
        "If A is relatively prime to C and D, and if B is also "
          . "relatively prime to C and D, then "
          . "A\\{nb}\\{times}\\{nb}B is relatively prime to "
          . "C\\{nb}\\{times}\\{nb}D",
        "If A,B are relatively prime, then A\\{^2},B\\{^2} "
          . "are relatively prime, and A\\{^3},B\\{^3} are relatively "
          . "prime, and so on",
    );
    my @descr2 = (
        "If A,B are relatively prime, then A,(A+B) are relatively prime",
        "If A is prime, and B\\{nb}\\{notequal}\\{nb}n\\{dot}A, then A,B are "
          . "relatively prime",
        "If C\\{nb}=\\{nb}A\\{times}B and C\\{nb}=\\{nb}i\\{dot}D where "
          . "D is prime, then either A\\{nb}=\\{nb}j\\{dot}D or "
          . "B\\{nb}=\\{nb}j\\{dot}D",
        "If A\\{nb}=\\{nb}B\\{times}C, then A\\{nb}=\\{nb}j\\{dot}D "
          . "where D is prime",
        "If A is a number then it is either prime, or A\\{nb}=\\{nb}j\\{dot}D "
          . "where D is prime",
        "Find the smallest numbers X,Y,Z where the ratio X:Y:Z is equal "
          . "to the given ratio A:B:C",
        "Find the lowest common denominator of 2 numbers",
        "If E is the lowest common denominator of A,B, and if "
          . "C\\{nb}=\\{nb}n\\{nb}\\{dot}A\\{nb}=\\{nb}m\\{dot}B, then "
          . "C\\{nb}=\\{nb}i\\{dot}E",
        "Find the least common multiple of 3 numbers",
        "If A\\{nb}=\\{nb}p\\{dot}B, then A\\{nb}=\\{nb}q\\{dot}C "
          . "where C\\{nb}=\\{nb}p\\{dot}1",
        "If A\\{nb}=\\{nb}(1/c)\\{dot}B and C\\{nb}=\\{nb}c\\{dot}1 "
          . "then A\\{nb}=\\{nb}n\\{dot}C",
        "Find the smallest number that has the fractions 1/a, 1/b, 1/c",

    );
    return ( toc_sub( $pn, 7, $current, 0, \@descr1 ),
             toc_sub( $pn, 7, $current, 27, \@descr2 ), );

}

# ============================================================================
# TOC for Book 8
# ============================================================================
sub toc8 {
    my $pn      = shift;
    my $current = shift;
    my @descr1 = (
        "If A:B = B:C = C:D ... X:Z, and A,Z are relatively prime, then "
          . "these are the least numbers with the ratio A:B",
        "Given a ratio of A:B, create a list of the least N numbers such that "
          . "X1:X2 = X2:X3 = ... = X(n-1):Xn = A:B",
        "If A:B = B:C = C:D ... X:Z, and these are the least numbers "
          . "with the ratio A:B, then A,Z are relatively prime",
        "Given A1:A2, B1:B2, C1:C2 ..., where each ratio is the least, "
          . "find the least numbers in "
          . "continued proportion such that X1:X2 = A1:A2, X2:X3 = B1:B2, "
          . "X3:X4 = C1:C2, etc",
        "If A\\{nb}=\\{nb}C\\{nb}x\\{nb}D and\\{nb}B\\{nb}="
          . "\\{nb}E\\{nb}x\\{nb}F, then\\{nb}A:B\\{nb}=\\{nb}CxD:ExF",
        "If S1, S2, S3 ... Sn is a series of numbers in continuous proportion "
          . "where S2 > S1, and S2 \\{notequal} p\\{dot}S1, then "
          . "Sj\\{nb}\\{notequal}\\{nb}q\\{dot}Si for any integer\\{nb}i,j",
        "If S1, S2, S3 ... Sn is a series of numbers in continuous proportion "
          . "where S2 > S1, and Sn = p\\{dot}S1, then "
          . "S2\\{nb}=\\{nb}q\\{dot}S1",
        "If A:B = C:D, then the length of the proportional series "
          . "A,S1,S2\\{nb}...\\{nb}"
          . "Sn,B, will be equal to length of the proportional series "
          . "C,T1,T2\\{nb}...\\{nb}Tn,D",
        "Prove that there are as many "
          . "proportional numbers between 1 and p^(n-1) as there proportional "
          . "numbers between p^(n-1) and\\{nb}q^(n-1)",
        "If there are two series of equal length, of type 1 to p^(n-1) and "
          . "1 to q^(n-1), then there will exist another series of equal length of "
          . "the form p^(n-1) and\\{nb}q^(n-1)",
        "If A = C^2 and B\\{nb}=\\{nb}D^2, then there exists "
          . "one number\\{nb}E "
          . "such that A:E\\{nb}=\\{nb}E:B, and\\{nb}A:B is the "
          . "duplicate ratio of\\{nb}C:D",
        "If A = C^3 and B\\{nb}=\\{nb}D^3, then "
          . "there exists two numbers\\{nb}H and\\{nb}K "
          . "such that\\{nb}A:H\\{nb}=\\{nb}H:K\\{nb}=\\{nb}K:B, "
          . "and\\{nb}A:B is the triplicate ratio of\\{nb}C:D",
        "If A:B = B:C then A^2:B^2\\{nb}=\\{nb}B^2:C^2, and "
          . "A^3:B^3\\{nb}=\\{nb}B^3:C^3",
        "If A\\{nb}=\\{nb}C^2, B\\{nb}=\\{nb}D^2 and if B\\{nb}"
          . "=\\{nb}iA, then D\\{nb}=\\{nb}jC, and vice versa",
        "If A\\{nb}=\\{nb}C^3, B\\{nb}=\\{nb}D^3 and if B\\{nb}"
          . "=\\{nb}iA, then D\\{nb}=\\{nb}jC, and vice versa",
        "If A\\{nb}=\\{nb}C^2, B\\{nb}=\\{nb}D^2 and if B\\{nb}"
          . "\\{notequal}\\{nb}iA, then D\\{nb}\\{notequal}\\{nb}jC, "
          . "and vice versa",
        "If A\\{nb}=\\{nb}C^3, B\\{nb}=\\{nb}D^3 and if B\\{nb}"
          . "\\{notequal}\\{nb}iA, then D\\{nb}\\{notequal}\\{nb}jC, "
          . "and vice versa",
        "If A,B are similar plane numbers, A\\{nb}=\\{nb}CD, "
          . "B\\{nb}=\\{nb}EF and C:D=E:F, then A:B is the duplicate "
          . "ratio of C:E and D:F, and there is one mean number "
          . "between A and B",
        "If A,B are similar solid numbers, A\\{nb}=\\{nb}CDE, "
          . "B\\{nb}=\\{nb}FGH and C:D=F:G and D:E=G:H, then "
          . "A:B is the triplicate "
          . "ratio of C:F, D:G, E:H, and there are two mean numbers "
          . "between A and B",
    );

    my @descr2 = (
        "If A:C\\{nb}=\\{nb}C:B, then A and B are similar plane "
          . "numbers, A\\{nb}=\\{nb}ij, "
          . "B\\{nb}=\\{nb}pq and i:p\\{nb}=\\{nb}j:q,",
        "If A:C\\{nb}=\\{nb}C:D\\{nb}=\\{nb}D:B, then A and B are similar solid "
          . "numbers, A\\{nb}=\\{nb}ijk, "
          . "B\\{nb}=\\{nb}pqr and i:p = j:q = r:k",
        "If A,B,C are in continued proportion, and A is square, then C is also square",
        "If A,B,C,D are in continued proportion, and A is cube, then D is also cube",
        "If A:B\\{nb}=\\{nb}C:D, and C,D and A are square, then B is also square",
        "If A:B\\{nb}=\\{nb}C:D, and C,D and A are cube, then B is also cube",
        "If A and B are similar plane numbers, then the ratio of A:B can ".
        "be expressed as a ratio of two square numbers",
        "If A and B are similar solid numbers, then the ratio of A:B can ".
        "be expressed as a ratio of two cube numbers",
    );
    return ( toc_sub( $pn, 8, $current, 0, \@descr1 ),
             toc_sub( $pn, 8, $current, 19, \@descr2 ) );

}

# ============================================================================
# table of content basic sub
# ============================================================================
{
    my ( $t2, $t3 );
    my $borderwidth = 30;              # borderwidth
    my $xs          = $borderwidth;    # current "w" location of text box
    my $ys          = 125;
    my $leftwidth   = 110;             # column separation
    my $cn_width     = PropositionCanvas::Width();
    my $cn_height    = PropositionCanvas::Height();
    my $bot_margin   = 200;
    my $maxY         = $cn_height - $bot_margin;
    my $columns      = 3;
    my $width        = ( $cn_width - 2 * $borderwidth ) / $columns - $leftwidth;
    my $image_height = 0;
    my $indent       = 40;
    my $yskip        = 5;
    my $yskip_image  = 35;

  # ============================================================================
  # reset the toc for next page
  # ============================================================================
    sub toc_reset {
        $xs = $borderwidth;    # current "w" location of text box
        $ys = 125;
        undef $t2;
        undef $t3;
    }

  # ============================================================================
  # write the propostion to the table of contents
  # ============================================================================
    sub proptoc {
        my $pn      = shift;
        my $num     = shift;
        my $expl    = shift;
        my $image   = shift;
        my $current = shift || 0;

        # define text boxes if not already defined
        unless ( defined $t2 && defined $t3 ) {
            $t2 = $pn->text_box( $xs, $ys, -anchor => "w", -width => $width );
            $t3 =
              $pn->text_box(
                             $xs + $indent, $ys,
                             -anchor => "w",
                             -width  => $width
              );
        }

        # set number
        $t3->y( $t2->y );
        if ( $num == $current ) {
            $t2->bold("$num");
        }
        else {
            $t2->explain($num);
        }

        # draw image if defined
        if ($image) {
            my $yd;
            eval { $yd = $image->( $pn, $xs, $t3->y ) };
            $t3->y( $t3->y + $yd );
        }

        # write the explanation
        if ( $num == $current ) {
            $t3->bold($expl);
        }
        else {
            $t3->explain($expl);
        }

        # get ready for next entry
        $t2->y( $t3->y + $yskip );
        $t2->y( $t3->y + $yskip_image ) if $image;

        # goto next column for next entry if necessary
        my $reset_flag = 0;
        if ( $t2->y > $maxY
             || ( $t2->y > $maxY - $image_height && $image ) )
        {
            $xs = $xs + $width + $leftwidth;
            $t2 = $pn->text_box( $xs, $ys, -anchor => "w", -width => $width );
            $t3 =
              $pn->text_box(
                             $xs + $indent, $ys,
                             -anchor => "w",
                             -width  => $width
              );
            if ( $xs / ( $width + $leftwidth ) > 3 ) {
                $reset_flag = 1;
            }
        }

        # return a "time for reset flag"
        return $reset_flag;
    }
}

# ============================================================================
# one page of a table of contents
# ============================================================================
sub toc_sub {
    my $pn      = shift;
    my $chapter = shift;
    my $current = shift;
    my $offset  = shift;
    my $descr   = shift;

    return sub {
        toc_reset();
        local $Shape::AniSpeed = 100 * $Shape::AniSpeed;
        $pn->clear();
        my ( $x, $y ) = $pn->center_coords();
        my $cn = $pn->Tk_canvas();
        $cn->createText(
                         $x, $y - 350,
                         -text   => "Table of Contents, Chapter $chapter",
                         -font   => "title",
                         -anchor => "n",
        );

        for my $i ( 1 .. scalar(@$descr) ) {
            proptoc( $pn, $i + $offset, $descr->[ $i - 1 ], undef, $current );
        }
    };
}

1;
