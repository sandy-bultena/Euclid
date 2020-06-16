#!/usr/bin/perl
package RegularPolygon;
use strict;
use warnings;
use Geometry::Point;
use Geometry::Line;
use Geometry::Circle;
use Geometry::Angle;
use Geometry::CalculatePoints;
use Geometry::Validate;
use Geometry::Triangle; 
use Math::Trig qw(rad2deg deg2rad :radial);

our @ISA = ("Polygon");

=head1 NAME

RegularPolygon - create and manipulate equiangular, equilateral polygon objects

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;
    
    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();
    
    # draw a hexagon, with centre at x,y and radius of r
    my @A = ( 150, 160, 90);
    $s{A} = RegularPolygon->hexagon( $cn, @A)->fill("#ffffee");
    $s{A}->set_labels(qw(a bottom b right c top d left));
    $s{A}->set_points(qw(C left D right E topright B left));        
    $s{A}->set_angles(qw(A B C D));
    
    # highlight 3rd line of polygon
    $s{A}->l(3)->notice;    

=head1 Line METHODS

=cut


# ============================================================================
# hexagon
# ============================================================================

=head2 hexagon ($cn, $x,$y,$r, [$speed])

Create and draw an equilateral, equiangular hexagon with the 
centre at $x,$y, and a radius of $r (from centre to vertex)

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$x,$y> - coordinates

=item * C<$r> - the radius of the hexagon

=item * C<speed> - [OPTIONAL] how fast to draw the objects  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------

sub hexagon {
    my $class = shift;

    # -------------------------------------------------------------------------
    # inputs
    # -------------------------------------------------------------------------

    # canvas and number of sides
    return unless Validate::Inputs( \@_, [qw(canvas coord coord number)],[qw(speed)] );
    my $cn = shift;
    my $x = shift;
    my $y = shift;
    my $r = shift;
    my $speed = shift || 1;
    
    # make circle where we will draw the hexagon
    my $c = Circle->new($cn,$x,$y,$x+$r,$y,$speed)->grey;
    
    # make an aribtrary straight line so that we can create a
    # "golden" rectangle
    my $xl = $x + 1.2*$r;
    my $yl = $y + $r;
    my $l = Line->new($cn,$xl,$yl,$xl,$yl+$r,$speed)->grey;
    my $gold = Triangle->golden($l,$speed)->grey;

    # copy this triangle into the circle
    my $g2 = $gold->copy_to_circle($c,$speed);
    $l->remove;
    $gold->remove;
    
    # bisect the angles at the base
    my $ac = Angle->new($cn,$g2->l(2),$g2->l(1))->grey;
    my $ad = Angle->new($cn,$g2->l(3),$g2->l(2))->grey;
    my $lx = $ac->clean_bisect($speed)->prepend(2.3*$r);
    my $ly = $ad->clean_bisect($speed)->prepend(2.3*$r);
    
    # find intersection points
    my @px = $c->intersect($lx);
    my @py = $c->intersect($ly);
    
    # define the points of the pentagon
    my @points;
    push @points,$g2->p(1)->coords;
    push @points,@py[2,3];
    push @points,$g2->p(2)->coords;
    push @points,$g2->p(3)->coords;
    push @points,@px[0,1];

    # make hexagon
    my $hex = Polygon->new($cn,5,@points,$speed)->normal();
    
    # cleanup
    $lx->remove;
    $ly->remove;
    $ac->remove;
    $ad->remove;
    $g2->remove;
    $c->remove;
    
    # return
    return $hex;
    
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

