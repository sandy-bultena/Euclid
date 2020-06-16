#!/usr/bin/perl
package EquilateralTriangle;
use strict;
use warnings;

use Geometry::Triangle; 
use Geometry::Validate;
our @ISA = (qw(Triangle));

=head1 NAME

EquilateralTriangle - build an equilateral triangle from a 
two points defining the base

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;
    
    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();

    # create and draw an Equilateral Triangle
    my @base = (10,10,50,10);
    my $tri = EquilateralTriangle->build( $cn, @base );

=head1 CLASS METHODS

=cut

# ============================================================================
# build
# ============================================================================

=head2 build ($cn, $x1,$y1, $x2,$y2, [$speed])

Builds an equilateral triangle on a line specified by
the given coordinates.  Note that the third point will be defined
such that the points 1,2,3 are in a counter-clockwise motion

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$x1,$y1> - coordinates of one end of the base of the triangle

=item * C<$x2,$y2> - coordinates of the other end of the base of the triangle

=item * C<$speed> - [OPTIONAL] how fast to build the triangle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Triangle object

=back

=cut

# -----------------------------------------------------------------------------
sub build {
    my $class = shift;
    return unless Validate::Inputs(\@_,[qw(canvas coord coord coord coord)],[qw(speed)]);
    my $cn    = shift;
    my $x1    = shift;
    my $y1    = shift;
    my $x2    = shift;
    my $y2    = shift;
    my $speed = shift || 1;
    
    my @A     = ( $x1, $y1 );
    my @B     = ( $x2, $y2 );

    # draw two circle from the end points of the base
    my $c1 = Circle->new( $cn, @A, @B, $speed )->grey;
    my $c2 = Circle->new( $cn, @B, @A, $speed )->grey;

    # intersection points of these two triangles
    my @pts = $c1->intersect($c2);
    
    # which of the two intersection points do we want?
    # ... the lines should be less than 180 degrees
    my $l1 = VirtualLine->new($x1,$y1,$x2,$y2);
    my $l2 = VirtualLine->new($x2,$y2,$pts[0],$pts[1]);
    
    my @C;
    if (Angle->calculate($l2,$l1) < 180) {
        @C = @pts[0,1];
    }
    else {
        @C = @pts[2,3];
    }
    
    # draw point, and rest of triangle, cleanup
    my $p = Point->new( $cn, @C );

    my $t = Triangle->new( $cn, @A, @B, @C, $speed );
    $c1->remove();
    $c2->remove();
    $p->remove();

    return $t;

}

=head1 Methods Inherited from Triangle

=head2 Parallelogram

Create a parallelogram equal in area to the triangle, containing
the specified angle

=head1 Methods Inherited from Polygon

see L<Geometry::Polygon> for description of additional methods.

Access components of the Polygon
  
  lines  ( )
  points ( ) 
  angles ( )
  a      ( $i )
  l      ( $i )
  p      ( $i )

Labelling

  set_labels ($text1,$pos1, $text2,$pos2 ... )
  set_angles ($text1,$text2, ... $size1,$size2 ... )
  set_points ($text1,$pos1, $text2,$pos2... )

Drawing (or redrawing)

  draw         ( [$speed] )
  angles_draw  ( )
  lines_draw   ( )
  points_draw  ( )
  move         ( $x, $y, [$inc, [$speed]] )
  rotate       ( $x, $y, $angle, [$inc, [$speed]] )
  
Removing from canvas

  remove        ( )
  remove_angles ( )
  remove_lines  ( )
  remove_points ( )
  remove_labels ( )

Colours

  fill          ( [$colour] )
  fillover      ( $object, [$colour] )
  lines_normal  ( )
  lines_grey    ( )
  lines_red     ( )
  lines_green   ( )
  angles_normal ( )
  angles_grey   ( )
  grey          ( )
  red           ( )
  green         ( )
  normal        ( )

Canvas objects

  poly          ( )
  objects       ( )


=head1 AUTHOR

Sandy Bultena

=head1 COPYRIGHT

This module is copyright (c) 2014 Sandy Bultena. All rights reserved.

This library is free software; you may redistribute and/or modify it under 
the terms of either the GNU General Public License 
or the Perl Artistic License, as specified in the Perl 5.10.0 README file.

=cut


1;
