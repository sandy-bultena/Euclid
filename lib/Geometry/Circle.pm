#!/usr/bin/perl
package Circle;
use strict;
use warnings;

use Geometry::Point;
use Time::HiRes qw(usleep);
use Math::Trig qw(asin_real rad2deg deg2rad :radial);
use Geometry::Shape;
use Geometry::Line;
use Geometry::CalculatePoints;
use Geometry::Validate;

our @ISA = qw(Shape VirtualCircle);

=head1 NAME

Circle - create and manipulate circle objects

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;
    
    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();

    # create and draw two circles (center point, point on circle)
    my $c1 = Circle->new( $cn, 10,10 ,100,100 );
    my $c2 = Circle->new( $cn, 100,100,10,10 );

    # what is the intersection point between these two circles
    my ($x1,$y1,$x2,$y2) = $c1->intersect($c2);
    print "No intersection!\n" unless defined $x1;
    
    # intersection points between a circle and a line
    my $line1 = Line->new( $cn, 0,0 ,110,110 );
    my @coords = $c1->intersect($line1);
    print "No intersection!\n" unless @coords;
    
    # make the circle stand out temporarily
    $c1->notice();

    # ---------------------
    # do the same virtually (i.e. no drawing or animation
    # ---------------------
    my $c1 = VirtualCircle->new( 10,10 ,100,100 );
    my $c2 = VirtualCircle->new( 100,100,10,10 );

    my ($x1,$y1,$x2,$y2) = $c1->intersect($c2);
    
    my $line1 = VirtualLine->new( $cn, 0,0 ,110,110 );
    ($x1,$y1,$x2,$y2) = $c1->intersect($line1);
    


=head1 Circle METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ($canvas, $xc,$yc, $x,$y, [$speed, $dash])

Creates and draw a circle

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$xc,$yc> - coordinates of center of circle

=item * C<$x,$y> - any point on the circle

I<i.e.> the radius of the circle will be the distance
between the two coordinates specified above  

=item * C<speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=item * C<dash> - [OPTIONAL] draw dashed circle if true


=back

B<Returns>

=over

=item * Circle object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;
    return
      unless Validate::Inputs( \@_, [qw(canvas coord coord coord coord)],
                               [qw(speed dash)] );
    my $cn   = shift;
    my $xc   = shift;
    my $yc   = shift;
    my $sx   = shift;
    my $sy   = shift;
    my $fast = shift || 1;
    my $dash = shift || 0;

    # convert given radius from cartesian to spherical
    my ( $r, $theta, $phi ) = cartesian_to_spherical( $sx - $xc, $yc - $sy, 0 );

    # create class
    my $self = {
                 -x    => $xc,
                 -y    => $yc,
                 -r    => $r,
                 -cn   => $cn,
                 -fast => $fast,
                 -dash => $dash,
                 -fill => undef
               };
    bless $self, $class;

    # draw
    if ( defined $xc && defined $yc && defined $r ) {
        $self->draw( rad2deg($theta) );
    }

    return $self;
}

# ============================================================================
# draw
# ============================================================================

=head2 draw ( [$start_angle, [$speed]] )

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

=item * Circle object

=back

=cut

# -----------------------------------------------------------------------------
sub draw {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(float speed)] );
    my $angle = shift || 0;
    my $speed = shift || 0;

    my $cn   = $self->{-cn};
    my $x    = $self->{-x};
    my $y    = $self->{-y};
    my $r    = $self->{-r};
    my $fast = $speed ? $speed : $self->{-fast};

    # pick colours depending on how fast we are drawing
    # (black for normal, grey for quick-draw)
    my @cs = Shape->normal_colour;
    @cs = Shape->grey_colour if $fast > 1;

    # create canvas objects
    my @arcs;
    foreach my $w (@Shape::shape_sizes) {
        push @arcs,
          $cn->createArc(
                          $x + $r, $y + $r, $x - $r, $y - $r,
                          -extent  => 1,
                          -start   => $angle,
                          -width   => $w,
                          -outline => $cs[ 4 - $w ]
                        );
    }

    # create 'drawing' point
    my $p = Point->new( $cn,
                        $x + $r * cos( deg2rad($angle) ),
                        $y - $r * sin( deg2rad($angle) ) );

    # animate the drawing
    unless ($Shape::NoAnimation) {
        $self->animate(
            sub {
                my $i = shift;
                foreach my $arc (@arcs) {
                    $cn->itemconfigure( $arc, -extent => $i );
                }
                $p->move_to( $x + $r * cos( deg2rad( $angle + $i ) ),
                             $y - $r * sin( deg2rad( $angle + $i ) ) );
            },
            $fast,
            360
                      );
    }

    # cleanup the animated canvas objects
    foreach my $arc (@arcs) { $cn->delete($arc) }
    $p->remove();

    # re-draw objects for a nice clean look
    my @objs;
    foreach my $w (@Shape::shape_sizes) {
        if ( $self->{-dash} ) {
            push @objs,
              $cn->createOval(
                               $x + $r, $y + $r, $x - $r, $y - $r,
                               -width   => $w,
                               -outline => $cs[ 4 - $w ],
                               -dash    => [ 6, 6 ],
                             );
        }
        else {
            push @objs,
              $cn->createOval(
                               $x + $r, $y + $r, $x - $r, $y - $r,
                               -width   => $w,
                               -outline => $cs[ 4 - $w ],
                             );
        }
    }
    $self->{-objects} = \@objs;
    $self->{-object}  = $objs[0];
    $self->fill( $self->{-fill} );

    # colour as required, bind notice to object, and update image
    $self->_bind_notice();
    $cn->update();

    # return
    return $self;
}

# ============================================================================
# label
# ============================================================================

=head2 label ([$text, [$where]] )

Create a label for the circle.  If no label defined, remove existing label.

B<Parameters>

=over 

=item * C<$text> - label text

=item * C<$where> - [OPTIONAL] where to draw the label, (default='top') 
top, bottom, left, right, topright, topleft, bottomright, bottomleft

=back

B<Returns>

=over

=item * Circle object

=back

=cut

# ----------------------------------------------------------------------------
sub label {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(text where)] );
    my $what = shift;
    my $where = shift || "top";

    my $cn = $self->{-cn};
    my ( $xc, $yc ) = $self->center;
    my $r = $self->radius;

    # define location where to draw label
    my ( $x, $y );
    if ( $where eq 'top' ) {
        $y = $yc - $r;
        $x = $xc;
    }
    elsif ( $where eq 'bottom' ) {
        $y = $yc + $r;
        $x = $xc;
    }
    elsif ( $where eq 'left' ) {
        $y = $yc;
        $x = $xc - $r;
    }
    elsif ( $where eq 'right' ) {
        $y = $yc;
        $x = $xc + $r;
    }
    elsif ( $where eq 'topright' ) {
        $y = $yc - .707 * $r;
        $x = $xc + .707 * $r;
    }
    elsif ( $where eq 'bottomleft' ) {
        $y = $yc + .707 * $r;
        $x = $xc - .707 * $r;
    }
    elsif ( $where eq 'topleft' ) {
        $y = $yc - .707 * $r;
        $x = $xc - .707 * $r;
    }
    elsif ( $where eq 'bottomright' ) {
        $y = $yc + .707 * $r;
        $x = $xc + .707 * $r;
    }

    # draw it
    $self->_draw_label( $cn, $x, $y, $what, $where );
    return $self;
}

# ============================================================================
# move
# ============================================================================

=head2 move ($x, $y)

Move the circle by this amount

B<Parameters>

=over 

=item * C<$x1,$y1> - amount (x,y) to move

=back

B<Returns>

=over

=item * Circle object

=back

=cut

# -----------------------------------------------------------------------------
sub move {
    my $self = shift;
    Validate::Inputs( \@_, [qw(coord coord)] );
    my $cn     = $self->{-cn};
    my $x      = shift;
    my $y      = shift;
    my $colour = $self->{-colour} || "";
    my @coords;
    foreach my $obj ( $self->cn_objects ) {
        $cn->move( $obj, $x, $y );
    }
    $self->{-x} = $self->{-x} + $x;
    $self->{-y} = $self->{-y} + $y;

    $cn->update();
}

# ============================================================================
# point
# ============================================================================

=head2 point ($angle)

Returns a Point object on the circumfrence of the circle at the specified angle

B<Parameters>

=over 

=item * C<$angle> in degrees

=back

B<Returns>

=over

=item * Point object

=back

=cut

# -----------------------------------------------------------------------------
sub point {
    my $self = shift;
    Validate::Inputs( \@_, [qw(angle)] );
    my @p = $self->coords(@_);

    my $cn = $self->{-cn};
    my $p = Point->new( $cn, @p );
    return $p;
}

# ============================================================================
# draw_tangent
# ============================================================================

=head2 draw_tangent ($point [$speed, [$dir]])

Returns a line object that comes from the specified point, and just touches 
the circle.

If the point is on the circle, draws a tangent at that point (from the point
clockwise)

B<Parameters>

=over 

=item * C<$point> (point object)

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=item * C<$dir> - Positive or negative angle direction 

=back

B<Returns>

=over

=item * Line object

=back

=cut

# -----------------------------------------------------------------------------
sub draw_tangent {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point)], [qw(speed dir)] );
    my $point = shift;
    my $speed = shift || 1;
    my $dir   = shift || 'positive';

    my $cn = $self->{-cn};
    my $r  = $self->radius;
    my @c  = $self->center;

    my $l;

    my %lines;
    my %points;
    my %circles;

    # draw line from point to centre of circle
    $points{centre} = Point->new( $cn, @c )->grey;
    $lines{centre} = Line->join( $point, $points{centre}, $speed )->grey;

    # if point is inside circle, then we can't do this
    if ( $lines{centre}->length - $r < -1 ) {
        Validate::complain(
                  "Cannot draw a line from INSIDE circle that touches circle!");
        return;
    }

    # if the point is on the circle, then draw a line perpendicular
    # to the radius
    if ( abs( $lines{centre}->length - $r ) < 2 ) {
        $l = $lines{centre}->perpendicular( $point, $speed, $dir );
        $l->extend($r);
    }

    # else draw a line from the point tangent to the circle
    else {

        # find where line from centre intersects small circle
        my @p = $self->intersect( $lines{centre} );
        $points{D} = Point->new( $cn, @p[ 0, 1 ] )->grey;

        # draw larger circle, and where line from centre intersects small circle
        $circles{large} = Circle->new( $cn, @c, $point->coords, $speed )->grey;

        # find line perpendicular to d, and find
        # interesection with larger circle
        $lines{perp} =
          $lines{centre}->perpendicular( $points{D}, $speed, $dir )->grey;
        $lines{perp}->extend( $lines{centre}->length );
        @p = $circles{large}->intersect( $lines{perp} );
        $points{F} = Point->new( $cn, @p[ 0, 1 ] )->grey;

        # draw line from point F to centre of circle
        $lines{F} = Line->join( $points{F}, $points{centre}, $speed )->grey;

        # find intersection of this line with original circle
        @p = $self->intersect( $lines{F} );

        # fiddle around because round off errors might make point B
        # just outside of the circle
        my $radial = Line->new( $cn, $self->centre, @p[ 0, 1 ] );
        if ( $radial->length > $self->radius ) {
            @p = $radial->point( $self->radius );
        }
        $radial->remove;
        $points{B} = Point->new( $cn, @p[ 0, 1 ] )->grey;

        # draw the tangent
        $l = Line->join( $point, $points{B}, $speed );

    }

    # clean up
    foreach my $type ( \%points, \%circles, \%lines ) {
        foreach my $obj ( keys %$type ) {
            if ( ref( $type->{$obj} ) ) {
                $type->{$obj}->remove;
            }
        }
    }

    return $l;
}

# ============================================================================
# angle
# ============================================================================

=head2 angle ($point)

Given a point object on the circle, return the angle (in degrees).
If the point is not on the circle, 0 is returned.

B<Parameters>

=over 

=item * C<$point> - any point on the circle

=back

B<Returns>

=over

=item * $angle

=back


=cut

# -----------------------------------------------------------------------------
sub angle {
    my $self = shift;
    Validate::Inputs( \@_, [qw(point)] );
    my $p = shift;
    return $self->SUPER::angle( $p->coords );
}

# ============================================================================
# intersect
# ============================================================================

=head2 intersect ($circle | $line)

Find the intersection points between the circle and the defined object

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

    # We want the intersection of this circle with another circle
    if ( $other->isa("VirtualCircle") ) {
        return $self->intersect_circles($other);
    }

    # We want the intersection of this circle with a line
    elsif ( $other->isa("VirtualLine") ) {
        return $self->intersect_line($other);
    }
}

# ============================================================================
# notice
# ============================================================================

=head2 notice ()

Makes the object go bold, and glow red, temporarily

B<Returns>

=over

=item * original circle object

=back

=cut

# -----------------------------------------------------------------------------
sub notice {
    my $self  = shift;
    my $cn    = $self->{-cn};
    my $obj   = @{ $self->{-objects} }[-1];
    my $width = $cn->itemcget( $obj, -width );
    my $sub =
      sub { my $i = shift; $cn->itemconfigure( $obj, -width => $i + $width ) };
    $self->SUPER::notice($sub);
    return $self;
}

# ============================================================================
# fill
# ============================================================================

=head2 fill ($colour)

Colours the inside of the circle with the specified colour.  If colour is
not defined, then any existing fill colour will be removed

B<Parameters>

=over 

=item * $colour - a string defining a colour name recognized by the graphics
tool (Tk by default), or a standard "#ff0033" type string defining the rgb
characteristics of the colour

=back

B<Returns>

=over

=item * Circle object

=back

=cut

# -----------------------------------------------------------------------------
sub fill {
    my $self = shift;
    Validate::Inputs( \@_, [], ["colour"] );
    my $colour = shift;
    my $cn     = $self->{-cn};
    my $poly   = $self->{-object};
    $self->{-fill} = $colour;
    $cn->itemconfigure( $poly, -fill => $colour );
    $cn->update;
    return $self;
}

# ============================================================================
# colours
# ============================================================================

=head2 grey() / green() / red() / normal()

Change the colour of the object

If object colour is changed to grey, then the object labels will be hidden.

If object colour is changed from grey to any other colour, the object labels
will be redrawn.

B<Returns>

=over

=item * original circle object

=back

=cut

sub grey {
    my $self = shift;
    $self->_set_colour( "-outline", "grey" );
    return $self;
}

sub red {
    my $self = shift;
    $self->_set_colour( "-outline", "red" );
    return $self;
}

sub green {
    my $self = shift;
    $self->_set_colour( "-outline", "green" );
    return $self;
}

sub normal {
    my $self = shift;
    $self->_set_colour( "-outline", "normal" );
    return $self;
}

##############################################################################
package VirtualCircle;
##############################################################################
use Geometry::Point;
use Time::HiRes qw(usleep);
use Math::Trig qw(asin_real rad2deg deg2rad :radial);
use Geometry::Shape;
use Geometry::Line;
use Geometry::Validate;

our $NO_COMPLAIN = 1;

=head1 VirtualCircle METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ($xc,$yc, $x,$y)

Creates virtual circle (no drawing)

B<Parameters>

=over 

=item * C<$xc,$yc> - coordinates of center of circle

=item * C<$x,$y> - any point on the circle

I<i.e.> the radius of the circle will be the distance
between the two coordinates specified above  

=back

B<Returns>

=over

=item * VirtualCircle object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;
    Validate::Inputs( \@_, [qw(coord coord coord coord)] );
    my $x  = shift;
    my $y  = shift;
    my $sx = shift;
    my $sy = shift;

    # convert given radius from cartesian to spherical
    my ( $r, $theta, $phi ) = cartesian_to_spherical( $sx - $x, $y - $sy, 0 );

    # create class
    my $self = { -x => $x, -y => $y, -r => $r, };
    bless $self, $class;

    return $self;
}

# ============================================================================
# center
# ============================================================================

=head2 center

Returns the center of the circle object (x and y coordinate)

=cut

# -----------------------------------------------------------------------------
sub centre { return center(@_) }

sub center {
    my $self = shift;
    return $self->{-x}, $self->{-y};
}

# ============================================================================
# radius
# ============================================================================

=head2 radius

Returns the radius of the circle object

=cut

# -----------------------------------------------------------------------------
sub radius {
    my $self = shift;
    return $self->{-r};
}

# ============================================================================
# angle
# ============================================================================

=head2 angle ($x,$y)

Given an x,y coordinate on the circle, return the angle (in degrees).
If the coordinates are not on the circle, 0 is returned.

B<Parameters>

=over 

=item * C<$x,$y> - any point on the circle

=back

B<Returns>

=over

=item * $angle

=back


=cut

# -----------------------------------------------------------------------------
sub angle {
    my $self = shift;
    Validate::Inputs( \@_, [qw(coord coord)] );
    my @p = @_[ 0, 1 ];
    my @c = $self->center;
    my ( $x1, $y1, $x2, $y2 ) = ( @c, @p );
    my ( $r, $theta, $phi ) = cartesian_to_spherical( $x2 - $x1, $y1 - $y2, 0 );

    # if point is not on circle, return;
    if ( abs( $r - $self->radius ) > 1 ) {
        return 0;
    }

    # always use positive angles
    $theta = rad2deg($theta);
    $theta = $theta + 360 if $theta < 0;

    # return the angle
    return $theta;

}

# ============================================================================
# tangent
# ============================================================================

=head2 tangent ($x,$y)

Given a point on a circle, return coordinates of a line that describes a tangent
at that point on the circle.

B<Parameters>

=over 

=item * C<$x,$y> - any point on the circle

=back

B<Returns>

=over

=item * $x,$y,$x1,$x2

=back


=cut

# -----------------------------------------------------------------------------
sub tangent {
    my $self = shift;
    Validate::Inputs( \@_, [qw(coord coord)] );
    my @c = $self->center;
    my @tr = CalculatePoints->right_triangle( @c, @_, 50 );
    return @tr[ 2 .. 5 ];
}

# ============================================================================
# intersect_line
# ============================================================================

=head2 intersect_line ($line)

Find the intersection points between the circle and the defined line

B<Parameters>

=over 

=item * C<line> - Line object (or VirtualLine object)

=back

B<Returns>

=over

=item * coordinates of intersection point(s) 

Nothing is returned if the two objects do not intersect!

=back

=cut

# -----------------------------------------------------------------------------
sub intersect_line {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Line)] );
    my $other = shift;

    my ( $x, $y, $r, $x1, $y1, $x2, $y2, $m );

    # init
    $x  = $self->{-x};
    $y  = $self->{-y};
    $r  = $self->{-r};
    $x1 = $other->{-x1};
    $y1 = $other->{-y1};
    $x2 = $other->{-x2};
    $y2 = $other->{-y2};
    $m  = $other->slope();

    my ( $a, $b, $c );
    my ( $x3, $x4, $y3, $y4 );

    # sloped line
    if ( abs($m) < 1e90) {
        # math:
        # circle eq'n: (x-$x)^2 + (y-$y)^2 = $r^2
        # line eq'n:   y = mx+b, (b = $y1 - $m * $x1)
        # Intersection of line & circle solves the following eq'n for x:
        #   (x-$x)^2 + ($m x + $b - $y)^2 = $r^2

        # y = mx+i, i = $y1-$m+$x1
        my $i = $y1 - $m * $x1;

        # binomial eq'n (-b +/- sqrt(b^2 - 4ac)) / 2a
        $a = 1 + $m**2;
        $b = 2 * $m * ( $i - $y ) - 2 * $x;
        $c = ( $i - $y )**2 + $x**2 - $r**2;

        my $sqr = $b**2 - 4 * $a * $c;

        # if sqr is less than zero, then there is no intersection of this
        # line and circle (even if the line were infinite)
        unless ( $sqr >= 0 ) {
            return;
        }

        # Possible intersection points
        $x3 = ( -$b + sqrt($sqr) ) / ( 2.0 * $a );
        $x4 = ( -$b - sqrt($sqr) ) / ( 2.0 * $a );
        $y3 = $m * $x3 + $i;
        $y4 = $m * $x4 + $i;

    }

    # vertical line
    else {
        # math:
        # circle eq'n: (x-$x)^2 + (y-$y)^2 = $r^2
        # line eq'n:   x = $x1,
        # Intersection of line & circle solves the following eq'n for y:
        #   ($x1-$x)^2 + (y-$y)^2 = $r^2
        # binomial eq'n (-b +/- sqrt(b^2 - 4ac)) / 2a
        $a = 1;
        $b = -2 * $y;
        $c = ( $x1 - $x )**2 + $y**2 - $r**2;

        my $sqr = $b**2 - 4 * $a * $c;

        # if sqr is less than zero, then there is no intersection of this
        # line and circle (even if the line were infinite)
        unless ( $sqr >= 0 ) {
            return;
        }

        # Possible intersection points
        $x3 = $x1;
        $x4 = $x1;
        $y3 = ( -$b + sqrt($sqr) ) / ( 2.0 * $a );
        $y4 = ( -$b - sqrt($sqr) ) / ( 2.0 * $a );
        
    }

    # Does the line actually extend far enought to intersect the circle?
    my @results;
    my $maxx = $x2 > $x1 ? $x2 : $x1;
    my $minx = $x2 > $x1 ? $x1 : $x2;
    my $maxy = $y2 > $y1 ? $y2 : $y1;
    my $miny = $y2 > $y1 ? $y1 : $y2;
    if (    $x3 >= $minx - 1
         && $x3 <= $maxx + 1
         && $y3 >= $miny - 1
         && $y3 <= $maxy + 1 )
    {
        push @results, ( $x3, $y3 );
    }

    if (    $x4 >= $minx - 1
         && $x4 <= $maxx + 1
         && $y4 >= $miny - 1
         && $y4 <= $maxy + 1 )
    {
        push @results, ( $x4, $y4 );
    }

    return @results;

}

# ============================================================================
# Intersection of two circles
# ============================================================================

=head2 intersect_circles ($circle)

Find the intersection points between the circle and the defined circle

B<Parameters>

=over 

=item * C<$circle> - Circle object (or VirtualCircle object)

=back

B<Returns>

=over

=item * coordinates of intersection point(s) 

Nothing is returned if the two objects do not intersect!

=back

=cut

# -----------------------------------------------------------------------------
sub intersect_circles {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Circle)] );
    my $other = shift;

    my ( $x1, $y1, $x2, $y2, $r1, $r2 );
    $x1 = $self->{-x};
    $y1 = $self->{-y};
    $r1 = $self->{-r};
    $x2 = $other->{-x};
    $y2 = $other->{-y};
    $r2 = $other->{-r};

    # --------------------------------------------------------------------
    # join center of two circles, (line d) and one point where the
    # circles intersect
    # --------------------------------------------------------------------

    # base of triangle
    my $base = VirtualLine->new( $x1, $y1, $x2, $y2 );
    my $d = $base->length();

    # divide d into d1, d2,
    # corresponding to the horizontal position of the vertex
    my $d1 = 1 / ( 2 * $d ) * ( $d**2 + $r1**2 - $r2**2 );
    my $d2 = $d - $d1;

    # calculate the height of the triangle
    my $hsqr = $r2**2 - $d2**2;
    $hsqr = 0 if abs($hsqr) < .2;

    # if hsqr is negative, then the circles don't intersect
    unless ( $hsqr >= 0 ) {
        Validate::complain("Circles don't intersect ($hsqr)");
        return;
    }

    my $h = sqrt($hsqr);

    # ------------------------------------------------------------------------
    # find x,y coordinates for d1 and h
    # ------------------------------------------------------------------------
    my ( $sx, $sy ) = $base->start();
    if ( $d1 < 1 ) { ( $sx, $sy ) = $base->end(); }
    my ( $px, $py ) = $base->point($d1);

    # coordinates of a line perpendicular to base
    my $p4x = $px + $py - $sy;
    my $p4y = $py - $px + $sx;
    my $p1x = $px - $py + $sy;
    my $p1y = $py + $px - $sx;

    # create two virtual lines, perpendicular to the base
    my $hline1 = VirtualLine->new( $px, $py, $p4x, $p4y );
    my $hline2 = VirtualLine->new( $px, $py, $p1x, $p1y );

    # figure out the missing coordinates
    my @h1 = $hline1->point($h);
    my @h2 = $hline2->point($h);

    # ------------------------------------------------------------------------
    # return points
    # ------------------------------------------------------------------------
    if ( $h1[1] > $h2[1] ) {
        return @h2, @h1;
    }
    else {
        return ( @h1, @h2 );
    }

}

# ============================================================================
# coords
# ============================================================================

=head2 coords ($angle)

Returns coordinates of a point on the circumference of the circle at the 
specified angle

B<Parameters>

=over 

=item * C<$angle> in degrees

=back

B<Returns>

=over

=item * Point object

=back

=cut

# -----------------------------------------------------------------------------
sub coords {
    my $self = shift;
    Validate::Inputs( \@_, [qw(angle)] );
    my $angle = shift;

    my $r = $self->radius;
    my @c = $self->center;

    $angle = deg2rad($angle);
    my @p = ( $c[0] + $r * cos($angle), $c[1] - $r * sin($angle) );
    return @p;
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
