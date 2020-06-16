#!/usr/bin/perl
use strict;
use warnings;

package CalculatePoints;
use Geometry::Validate;
our $NO_COMPLAIN = 1;

=head1 NAME

CalculatePoints - some basic arithmetic to define the points of
given shapes, without actually drawing anything.

=head1 SYNOPSIS

    use Geometry::Geometry;
    local $, = ", ";
    
    print CalculatePoints->square(10,25,10,50),"\n";
    # 35, 25, 10, 25, 10, 50, 35, 50
    #
    #    pt2 (10,25)       (35,25) pt1
    #    pt3 (10,50)       (35,50) pt4
    
    print CalculatePoints->square(10,50,10,25),"\n";
    # -15, 50, 10, 50, 10, 25, -15, 25
    #
    #    pt4 (-15,25)      (10,25) pt3
    #    pt1 (-15,50)      (10,50) pt2


=head1 CLASS METHODS

=cut

# ============================================================================
# square
# ============================================================================

=head2 square ($x2,$y2, $x3, $y3)

Given two coordinates of a line, return all coordinates of a corresponding 
square.

Remember that the (0,0) corner is at the top right of the canvas.

The two coordinates are the 2nd and 3rd corner of a square, where the corners
are defined in a counter-clockwise manner around the square;

              1 *--------* 4
                |        |
                |        |
                |        |
              2 *--------* 3
 

B<Parameters>

=over 

=item * C<$x2,$y2> - second corner of the square

=item * C<$x3,$y3> - third corner of the square

=back

B<Returns>

=over

=item * C<(x1,y1, x2,y2, x3,y3, x4,y4)> - coordinates for all 
four corners of the square

=back

=cut

# -----------------------------------------------------------------------------
sub square {
    my $class = shift;
    Validate::Inputs( \@_, [qw(coord coord coord coord)]);

    my ( $p2x, $p2y, $p3x, $p3y ) = @_;

    # figure out the missing coordinates
    my $deltax = $p3x - $p2x;
    my $deltay = $p3y - $p2y;
    my $p1x    = $p2x + $deltay;
    my $p1y    = $p2y - $deltax;
    my $p4x    = $p3x + $deltay;
    my $p4y    = $p3y - $deltax;

    return $p1x, $p1y, $p2x, $p2y, $p3x, $p3y, $p4x, $p4y;

}

# ============================================================================
# right triangle
# ============================================================================

=head2 right_triangle ($x1,$y1, $x2,$y2, $h)

Given two coordinates of a line, a height, 
return all coordinates of a corresponding right triangle.

Remember that the (0,0) corner is at the top right of the canvas.

The two coordinates are the 1st and 2nd corner of a triangle, where the corners
are defined in a counter-clockwise manner around the triangle.

The right-angle will be on the second corner

                         * 3
                        /| 
                       / |
                      /  |
                     /   |
                  1 *----* 2
 

B<Parameters>

=over 

=item * C<$x1,$y1> - first corner of the triangle

=item * C<$x2,$y2> - second corner of the triangle

=item * C<$h> - height of triangle

=back

B<Returns>

=over

=item * C<(x1,y1, x2,y2, x3,y3)> - coordinates for all 
three corners of the triangle

=back

=cut

# -----------------------------------------------------------------------------
sub right_triangle {
    my $class = shift;
    Validate::Inputs( \@_, [qw(coord coord coord coord coord)] );

    # get coordinates
    my @coords = splice( @_, 0, 4 );
    my $height = shift || 25;

    # figure out the missing final 3rd coordinate
    my ( $p2x, $p2y, $p3x, $p3y ) = @coords;

    # define line that is perpendicular to base
    my $deltax = $p3x - $p2x;
    my $deltay = $p3y - $p2y;

    # get the correct length of line (x-x1) = r/d * deltay
    my $p4x = $height / sqrt( $deltay**2 + $deltax**2 ) * ($deltay) + $p3x;
    my $p4y = -$height / sqrt( $deltay**2 + $deltax**2 ) * ($deltax) + $p3y;

    return @coords, $p4x, $p4y;
}

# ============================================================================
# paralleogram
# ============================================================================

=head2 parallelogram ($x1,$y1, $x2,$y2, $x3,$y3)

Given three coordinates,  
return all coordinates of a corresponding parallelogram

The three coordinates are the 1st, 2nd and 3rd corner of a parallelogram. 

B<Parameters>

=over 

=item * C<$x1,$y1> - first corner of the parallelogram

=item * C<$x2,$y2> - second corner of the parallelogram

=item * C<$x3,$y3> - third corner of the parallelogram

=back

B<Returns>

=over

=item * C<(x1,y1, x2,y2, x3,y3, x4,y4)> - coordinates for all 
four corners of the parallelogram

=back

=cut

# -----------------------------------------------------------------------------
sub parallelogram {
    my $class = shift;
    Validate::Inputs( \@_, [qw(coord coord coord coord coord coord)] );

    # get coordinates
    my @coords = splice( @_, 0, 6 );

    # figure out the missing final 4th coordinate
    my $deltax = $coords[2] - $coords[0];
    my $deltay = $coords[3] - $coords[1];

    return @coords, $coords[4] - $deltax, $coords[5] - $deltay;

}

# ============================================================================
# equilateral_triangle
# ============================================================================

=head2 equilateral_triangle ($x1,$y1, $x2,$y2)

Given two coordinates of a line,  
return all coordinates of a corresponding equilateral triangle.

Remember that the (0,0) corner is at the top right of the canvas.

The two coordinates are the 1st and 2nd corner of a triangle, where the corners
are defined in a counter-clockwise manner around the triangle.

                         * 3
                        /\ 
                       /  \
                      /    \
                     /      \
                  1 *--------* 2
 

B<Parameters>

=over 

=item * C<$x1,$y1> - first corner of the triangle

=item * C<$x2,$y2> - second corner of the triangle

=back

B<Returns>

=over

=item * C<(x1,y1, x2,y2, x3,y3)> - coordinates for all 
three corners of the triangle

=back

=cut

# -----------------------------------------------------------------------------
sub equilateral_triangle {
    my $class = shift;
    Validate::Inputs( \@_, [qw(coord coord coord coord)] );

    # get coordinates
    my @coords = splice( @_, 0, 4 );

    # right angle triangle (1/2 the equilateral triangle)
    my ( $x1, $y1, $x2, $y2 ) = @coords;
    my $h = sqrt(3) / 2. * sqrt( ( $x2 - $x1 )**2 + ( $y2 - $y1 )**2 );
    my $xb = 0.5 * ( $x2 + $x1 );
    my $yb = 0.5 * ( $y2 + $y1 );
    my @right = $class->right_triangle( $x1, $y1, $xb, $yb, $h );

    # equilateral triangle
    return @coords, @right[ 4, 5 ];

}

# ============================================================================
# isosceles_triangle
# ============================================================================

=head2 isosceles_triangle ($x1,$y1, $x2,$y2, $h)

Given two coordinates of a line, a height, 
return all coordinates of a corresponding isosceles triangle.

Remember that the (0,0) corner is at the top right of the canvas.

The two coordinates are the 1st and 2nd corner of a triangle, where the corners
are defined in a counter-clockwise manner around the triangle.

                         * 3
                        /\ 
                      /    \
                    /        \
                  /            \
              1 *----------------* 2
 

B<Parameters>

=over 

=item * C<$x1,$y2> - first corner of the triangle

=item * C<$x2,$y2> - second corner of the triangle

=item * C<$h> - height of triangle (defaults to 25)

=back

B<Returns>

=over

=item * C<(x1,y1, x2,y2, x3,y3)> - coordinates for all 
three corners of the triangle

=back

=cut

sub isosceles_triangle {
    my $class = shift;
    Validate::Inputs( \@_, [qw(coord coord coord coord coord)] );

    # get coordinates
    my @coords = splice( @_, 0, 4 );
    my $r = shift || 25;

    my ( $x1, $y1, $x2, $y2 ) = @coords;

    # right angle triangle (1/2 the isosceles triangle)
    my $p3x = ( $x2 + $x1 ) / 2;
    my $p3y = ( $y1 + $y2 ) / 2;

    # define line that is perpendicular to base
    my $deltax = $p3x - $x1;
    my $deltay = $p3y - $y1;

    # get the correct length of line (x-x1) = r/d * deltay
    my $p4x = $r / sqrt( $deltay**2 + $deltax**2 ) * ($deltay) + $p3x;
    my $p4y = -$r / sqrt( $deltay**2 + $deltax**2 ) * ($deltax) + $p3y;

    # isosceles triangle
    return @coords, $p4x, $p4y;

}

# ============================================================================
# are_points
# ============================================================================

=head2 are_points (@array)

Verifies that the input parameters are floating point numbers 

B<Returns>

true/false

=cut

sub are_points {
    my $class = shift;
    foreach my $c (@_) {
        unless ( $c && $c =~ /^\s*[-]?\d*\.?\d*(e[+-]\d+)?\s*$/ ) {
            return 0;
        }
    }
    return 1;
}

=head1 AUTHOR

Sandy Bultena

=head1 COPYRIGHT

This module is copyright (c) 2014 Sandy Bultena. All rights reserved.

This library is free software; you may redistribute and/or modify it under 
the terms of either the GNU General Public License 
or the Perl Artistic License, as specified in the Perl 5.10.0 README file.

=cut

1;
