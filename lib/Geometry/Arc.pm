#!/usr/bin/perl

# ============================================================================
# PACKAGE ARC
# ============================================================================
package Arc;
use strict;
use warnings;

use Geometry::Point;
use Time::HiRes qw(usleep);
use Math::Trig qw(asin_real rad2deg deg2rad :radial);
use Geometry::Shape;
use Geometry::Line;
use Geometry::Circle;
use Geometry::CalculatePoints;
use Geometry::Validate;

our @ISA = qw(Circle);

=head1 NAME

Arc - create and manipulate arc objects (circles with a start and stop angle)

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;
    
    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();

    # data
    my @center = (10,10);
    my $radius = 90;
    my @pt1 = (10,100);
    my @pt2 = (50,10);

    # create and draw arc
    my $arc = Arc->new($cn,$radius,@pt1,@pt2);
    


=head1 Arc METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ($canvas, $radius, $x1,$y1, $x2,$y2, [$speed])

Creates and draw an Arc

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$radius> - radius of curvature for this arc

=item * C<$x1,$y1> - starting point of arc

=item * C<$x2,$y2> - ending point of arc

=item * C<speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Arc object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;
    return
      unless Validate::Inputs( \@_, [qw(canvas radius coord coord coord coord)],
                               [qw(speed big)] );
    my $cn   = shift;
    my $r    = shift;
    my $x1   = shift;
    my $y1   = shift;
    my $x2   = shift;
    my $y2   = shift;
    my $fast = shift || 1;
    my $big  = shift || 0;

    # is this do-able with the specified radius of curvature?
    my $d = VirtualLine->new( $x1, $y1, $x2, $y2 );
    if ( $r < ( $d->length / 2 ) ) {
        my $gr = int( $d->length / 2 );
        Validate::complain(   "radius of curvature too small for these points\n"
                            . "\tneed at least $gr" );
        return;
    }

    # find the center of the circle
    my $c1 = VirtualCircle->new( $x1, $y1, $x1 + $r, $y1 );
    my $c2 = VirtualCircle->new( $x2, $y2, $x2 + $r, $y2 );
    my @ps = $c1->intersect_circles($c2);

    my ( $x, $y ) = @ps[ 0, 1 ];

    # find the start and end angles of this arc
    my ( undef, $theta1, undef ) =
      cartesian_to_spherical( $x1 - $x, $y - $y1, 0 );
    my ( undef, $theta2, undef ) =
      cartesian_to_spherical( $x2 - $x, $y - $y2, 0 );
    my $diff = rad2deg( $theta2 - $theta1 );
    $diff = 360 + $diff if $diff < 0;

    # use other center of circle
    if ( ( $big && abs($diff) < 180 ) || ( abs($diff) > 180 && not $big ) ) {
        ( $x, $y ) = @ps[ 2, 3 ];
        ( undef, $theta1, undef ) =
          cartesian_to_spherical( $x1 - $x, $y - $y1, 0 );
        ( undef, $theta2, undef ) =
          cartesian_to_spherical( $x2 - $x, $y - $y2, 0 );
        $diff = rad2deg( $theta2 - $theta1 );
        $diff = 360 + $diff if $diff < 0;
    }

    # always use positive angles
    $theta1 = rad2deg($theta1);
    $theta2 = rad2deg($theta2);
    $theta1 = $theta1 + 360 if $theta1 < 0;
    $theta2 = $theta2 + 360 if $theta2 < 0;

    # create class
    my $self = {
                 -x      => $x,
                 -y      => $y,
                 -r      => $r,
                 -cn     => $cn,
                 -fast   => $fast,
                 -start  => $theta1,
                 -end    => $theta2,
                 -extent => $diff,
    };
    bless $self, $class;

    # draw
    if ( defined $x && defined $y && defined $r ) {
        $self->draw();
    }
    return $self;
}

# ============================================================================
# newbig
# ============================================================================

=head2 newbig ($canvas, $radius, $x1,$y1, $x2,$y2, [$speed])

Creates and draw an Arc over 180 degrees

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$radius> - radius of curvature for this arc

=item * C<$x1,$y1> - starting point of arc

=item * C<$x2,$y2> - ending point of arc

=item * C<speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Arc object

=back

=cut

# -----------------------------------------------------------------------------
sub newbig {
    my $class = shift;
    return
      unless Validate::Inputs( \@_, [qw(canvas radius coord coord coord coord)],
                               [qw(speed)] );
    my $cn   = shift;
    my $r    = shift;
    my $x1   = shift;
    my $y1   = shift;
    my $x2   = shift;
    my $y2   = shift;
    my $fast = shift || 1;

    return Arc->new( $cn, $r, $x1, $y1, $x2, $y2, $fast, 1 );
}

# ============================================================================
# join
# ============================================================================

=head2 join ($radius, $p1, $p2 [$speed])

Creates and draw an Arc

B<Parameters>

=over 

=item * C<$radius> - radius of curvature for this arc

=item * C<$p1,$p2> - starting and ending point of arc

=item * C<speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Arc object

=back

=cut

# -----------------------------------------------------------------------------
sub join {
    my $class = shift;
    return
      unless Validate::Inputs( \@_, [qw(radius Point Point)], [qw(speed big)] );
    my $r    = shift;
    my $p1   = shift;
    my $p2   = shift;
    my $fast = shift || 1;

    return Arc->new( $p1->canvas, $r, $p1->coords, $p2->coords, $fast, 0 );
}

# ============================================================================
# joinbig
# ============================================================================

=head2 joinbig ($radius, $p1, $p2 [$speed])

Same as join, but draws the larger arc

B<Parameters>

=over 

=item * C<$radius> - radius of curvature for this arc

=item * C<$p1,$p2> - starting and enditing point of arc

=item * C<speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Arc object

=back

=cut

# -----------------------------------------------------------------------------
sub joinbig {
    my $class = shift;
    return
      unless Validate::Inputs( \@_, [qw(radius Point Point)], [qw(speed big)] );
    my $r    = shift;
    my $p1   = shift;
    my $p2   = shift;
    my $fast = shift || 1;

    return Arc->new( $p1->canvas, $r, $p1->coords, $p2->coords, $fast, 1 );
}

# ============================================================================
# semi_circle
# ============================================================================

=head2 new ($canvas, $x1,$y1, $x2,$y2, [$speed])

Creates and draw an semi-circle between two points

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$x1,$y1> - starting point of arc

=item * C<$x2,$y2> - ending point of arc

=item * C<speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Arc object

=back

=cut

# -----------------------------------------------------------------------------
sub semi_circle {
    my $class = shift;
    return
      unless Validate::Inputs( \@_, [qw(canvas coord coord coord coord)],
                               [qw(speed)] );
    my $cn   = shift;
    my $x1   = shift;
    my $y1   = shift;
    my $x2   = shift;
    my $y2   = shift;
    my $fast = shift || 1;

    my $d = VirtualLine->new( $x1, $y1, $x2, $y2 );
    my $r = $d->length / 2 + .0001;

    return Arc->new( $cn, $r, $x1, $y1, $x2, $y2, $fast );
}

# ============================================================================
# draw
# ============================================================================

=head2 draw ( [$speed] )

Draw an already defined circle

B<Parameters>

=over 

=item * C<$start_angle> - [OPTIONAL] (default = 0) the angle to start drawing from

=item * C<$speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Arc object

=back

=cut

# -----------------------------------------------------------------------------
sub draw {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(speed)] );
    my $speed = shift || 0;

    my $cn     = $self->{-cn};
    my $x      = $self->{-x};
    my $y      = $self->{-y};
    my $r      = $self->{-r};
    my $start  = $self->{-start};
    my $end    = $self->{-end};
    my $fast   = $speed ? $speed : $self->{-fast};
    my $extent = $self->{-extent};

    # pick colours depending on how fast we are drawing
    my @cs = Shape->normal_colour;
    @cs = Shape->grey_colour if $speed > 1;

    # create canvas objects
    my @arcs;
    foreach my $w (@Shape::shape_sizes) {
        push @arcs,
          $cn->createArc(
                          $x + $r, $y + $r, $x - $r, $y - $r,
                          -extent  => 1,
                          -start   => $start,
                          -width   => $w,
                          -style   => 'arc',
                          -outline => $cs[ 4 - $w ]
          );
    }

    # create 'drawing' point
    my $p = Point->new( $cn,
                        $x + $r * cos( deg2rad($start) ),
                        $y - $r * sin( deg2rad($start) ) );

    # animate the drawing
    unless ($Shape::NoAnimation) {
        $self->animate(
            sub {
                my $i = shift;
                foreach my $arc (@arcs) {
                    $cn->itemconfigure( $arc, -extent => $i );
                }
                $p->move_to( $x + $r * cos( deg2rad( $start + $i ) ),
                             $y - $r * sin( deg2rad( $start + $i ) ) );
            },
            $fast,
            int($extent)
        );
    }

    # cleanup the animated canvas objects
    foreach my $arc (@arcs) { $cn->delete($arc) }
    $p->remove();

    # re-draw objects for a nice clean look
    my @objs;
    foreach my $w (@Shape::shape_sizes) {
        push @objs,
          $cn->createArc(
                          $x + $r, $y + $r, $x - $r, $y - $r,
                          -extent  => $extent,
                          -start   => $start,
                          -width   => $w,
                          -style   => 'arc',
                          -outline => $cs[ 4 - $w ]
          );
    }
    $self->{-objects} = \@objs;

    # colour as required, bind notice to object, and update image
    $self->grey() if $fast > 1;
    $self->_bind_notice();
    $cn->update();

    # return
    return $self;
}

# ============================================================================
# fill the chord with colour
# ============================================================================
sub fill {
    my $self = shift;
    my $cn   = $self->canvas;
    Validate::Inputs( \@_, [], ["colour"] );
    my $colour = shift;
    my $x      = $self->{-x};
    my $y      = $self->{-y};
    my $r      = $self->{-r};
    my $start  = $self->{-start};
    my $end    = $self->{-end};
    my $extent = $self->{-extent};
    my $fills = $self->{-fills};
    
    # remove prior colour
    if ( $fills ) {
        foreach my $obj (@$fills) {
            $cn->delete( $obj );
        }
    }
    
    if ($colour) {
        my @objs;
        my $pie =
          $cn->createArc(
            $x + $r, $y + $r, $x - $r, $y - $r,
            -extent  => $extent,
            -start   => $start,
            -style   => 'chord',
            -outline => undef,
             - fill => $colour
          );
          my $sa = $start * 3.14159/180.;
          my $ea = ($start+$extent)*3.14149/180.;
         # my $tri = $cn->createPolygon($x+$r*cos($sa),$y-$r*sin($sa),$x,$y,$x+$r*cos($ea),$y-$r*sin($ea),-fill=>$colour);
        $self->{-fill} = $colour;
        push @objs, $pie;#,$tri;
        $cn->lower($pie);
        #$cn->lower($tri);
        $self->{-fills} = \@objs;
        
    }

    $cn->update;
    return $self;
}

# ============================================================================
# fill the pie with colour
# ============================================================================
sub fillpie {
    my $self = shift;
    my $cn   = $self->canvas;
    Validate::Inputs( \@_, [], ["colour"] );
    my $colour = shift;
    my $x      = $self->{-x};
    my $y      = $self->{-y};
    my $r      = $self->{-r};
    my $start  = $self->{-start};
    my $end    = $self->{-end};
    my $extent = $self->{-extent};
    my $fills = $self->{-fills};
    
    # remove prior colour
    if ( $fills ) {
        foreach my $obj (@$fills) {
            $cn->delete( $obj );
        }
    }
    
    if ($colour) {
        my @objs;
        my $pie =
          $cn->createArc(
            $x + $r, $y + $r, $x - $r, $y - $r,
            -extent  => $extent,
            -start   => $start,
            -style   => 'pie',
            -outline => undef,
             - fill => $colour
          );
          my $sa = $start * 3.14159/180.;
          my $ea = ($start+$extent)*3.14149/180.;
         $self->{-fill} = $colour;
        push @objs, $pie;
        $cn->lower($pie);
        $self->{-fills} = \@objs;
        
    }

    $cn->update;
    return $self;
}

# ============================================================================
# bisect
# ============================================================================

=head2 bisect ( [$speed] )

Bisect the arc

B<Parameters>

=item * C<$speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Point on the arc that bisects it

=back

=cut

# -----------------------------------------------------------------------------
sub bisect {
    my $self = shift;
    my $cn   = $self->canvas;

    Validate::Inputs( \@_, [], [qw(speed)] );
    my $speed = shift || 1;

    # draw line between start and stop of arc, and find the midpoint
    my $p1   = $self->point( $self->start );
    my $p2   = $self->point( $self->end );
    my $line = Line->join( $p1, $p2 )->grey;
    my $p3   = $line->bisect($speed);

    # draw a line perpendicular to the first line, at the midpoint
    my $perp = $line->perpendicular($p3)->grey;

    # make sure that line is large enough to intersect both sides of
    # circle
    $perp->extend( 2 * $self->radius );
    $perp->prepend( 2 * $self->radius );

    # Find the intersect point
    my @p = $self->intersect($perp);

    # create the point
    my $result;
    if (@p) {
        $result = Point->new( $cn, @p[ 0, 1 ] );
    }

    # clean up
    $p1->remove;
    $p2->remove;
    $line->remove;
    $p3->remove;
    $perp->remove;

    # return
    return $result;

}

# ============================================================================
# intersect
# ============================================================================

=head2 intersect ($circle | $line)

Find the intersection points between the arc and the defined object

B<Parameters>

=over 

=item * C<$circle> - Circle object

=back

or

=over

=item * C<$line> - Line object

=back

B<Returns>

=over

=item * coordinates of intersection point(s) 

Nothing is returned if the two objects do not intersect!

=back

=cut

# -----------------------------------------------------------------------------
sub intersect {
    my $self = shift;
    Validate::Inputs( \@_, [qw(LineCircle)] );
    my $other = shift;

    my @p;

    # We want the intersection of this circle with another circle
    if ( $other->isa("VirtualCircle") ) {
        @p = $self->intersect_circles($other);
    }

    # We want the intersection of this circle with a line
    elsif ( $other->isa("VirtualLine") ) {
        @p = $self->intersect_line($other);
    }

    # do the points actually intersect the arc (as opposed to the
    # circle defining the arc?)
    my @c = $self->centre;
    my $virt = VirtualCircle->new( @c, $c[0] + $self->radius, $c[1] );

    my @results;
    my $start_angle =
      $self->start > $self->end ? $self->start - 360 : $self->start;
    my $end_angle = $self->end;
    if ( exists $p[0] && exists $p[1] ) {
        my $angle = $virt->angle( $p[0], $p[1] );
        if ( $angle >= $start_angle && $angle <= $end_angle ) {
            push @results, @p[ 0, 1 ];
        }
    }
    if ( exists $p[2] && exists $p[3] ) {
        my $angle = $virt->angle( $p[2], $p[3] );
        if ( $angle >= $start_angle && $angle <= $end_angle ) {
            push @results, @p[ 2, 3 ];
        }
    }

    return @results;
}

# ============================================================================
# start
# ============================================================================

=head2 start ( )

Returns the start angle of this arc in degrees

=cut

# -----------------------------------------------------------------------------
sub start {
    my $self = shift;
    return $self->{-start};
}

# ============================================================================
# end
# ============================================================================

=head2 end ( )

Returns the end angle of this arc in degrees

=cut

# -----------------------------------------------------------------------------
sub end {
    my $self = shift;
    return $self->{-end};
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
