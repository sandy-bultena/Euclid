#!/usr/bin/perl
package Triangle;
use strict;
use warnings;
use Geometry::Polygon;
use Math::Trig;
use Carp;
our @CARP_NOT;

my $default = 10;
our @ISA = (qw(Polygon));

sub new {
    my $class = shift;
    my $cn    = shift;
    my $sides = 3;

    return Triangle->SUPER::new( $cn, $sides, @_ );
}

# ============================================================================
# join
# ============================================================================

=head2 join ($p1,$p2,$p3, [$speed])

Create and draw a triangle, given Point objects

B<Parameters>

=over 

=item * C<$p>I<i> - I<i>th Point (object)

=item * C<speed> - [OPTIONAL] how fast to draw the polygon  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Triangle object

=back

=cut

# -----------------------------------------------------------------------------
sub join {
    my $class = shift;
    my $t = Triangle->SUPER::join( 3, @_ );
    bless $t, "Triangle";
    return $t;
}

sub SAS {
    my $class = shift;
    my $cn    = shift;

    my @coord = splice( @_, 0, 2 );
    my $r1    = shift;
    my $arc   = shift;
    my $r2    = shift;
    my $speed = shift;
    carp("Invalid inputs to Triangle->SAS") if @_ % 2;
    my %args = (@_);

    # calculate the new points, with base horizontal
    my ( $x2, $y2, $x3, $y3 ) =
      Triangle->calculate_SAS( @coord, $r1, $arc, $r2 );

    # create triangle
    return Triangle->new( $cn, @coord, $x2, $y2, $x3, $y3, $speed, %args );
}

sub calculate_SAS {
    my $class = shift;
    my ( $x1, $y1 ) = splice( @_, 0, 2 );
    my $r1  = shift;
    my $arc = shift;
    my $r2  = shift;

    # calculate the points, with base horizontal
    my $theta  = 3.14159 / 180.0 * $arc;
    my $theta1 = atan( ( $r1 - $r2 * cos($theta) ) / ( $r2 * sin($theta) ) );
    my $h1     = $r1 * cos($theta1);
    my $d1     = $r1 * sin($theta1);
    my $d2     = $r2 * sin( $arc * 3.14159 / 180. - $theta1 );

    my $x2 = $x1 - $d1;
    my $x3 = $x1 + $d2;
    my $y3 = my $y2 = $y1 + $h1;

    # return two new points defining triangle
    return ( $x2, $y2, $x3, $y3, $d1 + $d2 );
}

# create a triangle given the length of three sides, and a starting coordinate
sub SSS {
    my $class = shift;
    my $cn    = shift;

    my @coord = splice( @_, 0, 2 );
    my $r1    = shift;
    my $r2    = shift;
    my $r3    = shift;
    my $speed = shift;
    carp("Invalid inputs to Triangle->SSS") if @_ % 2;
    my %args = (@_);

    # calculate the points, where 2nd line is base and horizontal
    my ( $x3, $y3 ) = ( $coord[0] + $r2, $coord[1] );
    my $c1 = Circle->new( $cn, @coord, $coord[0] + $r1, $coord[1] )->grey;
    my $c2 = Circle->new( $cn, $x3, $y3, $x3 + $r3, $y3 )->grey;
    my @p3s = $c1->intersect_circles($c2);
    unless (@p3s) {
        carp("circles don't intersect");
        $c1->remove;
        $c2->remove;
        return @p3s;
    }
    my ( $x1, $y1 );
    if ( $p3s[1] < $p3s[3] ) {
        ( $x1, $y1 ) = @p3s[ 0, 1 ];
    }
    else {
        ( $x1, $y1 ) = @p3s[ 2, 3 ];
    }

    # create triangle
    my $new = Triangle->new( $cn, $x1, $y1, @coord, $x3, $y3, $speed, %args );
    $c1->remove;
    $c2->remove;
    return $new;
}

sub assemble {
    my $class = shift;
    my $cn    = shift;
    my $self  = $class->SUPER::assemble( $cn, 3, @_ );
    return $self;
}

sub parallelogram {

    # I.42
    my $triangle = shift;
    my $angle    = shift;
    my $speed    = shift || 1;
    my $cn       = $triangle->{-cn};

    # Bisect 2nd triangle line at point");
    my $point = $triangle->l(2)->bisect($speed)->label("P");

    # make line from point 2 to point 3
    # (in case triangle was built from lines that go
    #  in the wrong direction);
    my $l =
      Line->new( $cn,
                 $triangle->p(2)->coords(),
                 $triangle->p(3)->coords, $speed )->grey;
    my ( $l1, $l2 ) = $triangle->l(2)->clone()->split($point);
    $l1->red;
    $l2->blue;
    $l->remove();
    $l1->remove();
    $l2->remove();

    # Copy angle onto 2nd triangle line EC at bisect point
    my ( $side1, $angle2 ) = $angle->copy( $point, $l2, undef, $speed );
    $side1->extend(100);
    $side1->red;

    # Draw a line through triangle point 1, parallel triangle line 2
    my $line2 = $triangle->l(2)->parallel( $triangle->p(1), $speed )->blue;
    my $point2 = Point->new( $cn, $line2->intersect($side1) )->label("P2");

    # Draw a line through triangle point 3, parallel to side 1
    my $line3 = $side1->parallel( $triangle->p(3), $speed )->green;
    my $point3 = Point->new( $cn, $line3->intersect($line2) );

    # Construct polygon
    my $poly =
      Polygon->new( $cn, 4, $point2->coords(), $point->coords,
                    $triangle->p(3)->coords(),
                    $point3->coords(), $speed );
    bless $poly, "Parallelogram";
    $poly->normal();

    # cleanup
    $side1->remove();
    $line2->remove();
    $line3->remove();
    $l1->remove();
    $l2->remove();
    $point->remove();
    $point2->remove();
    $point3->remove();

    # return
    return $poly, $angle2;

}

sub copy_to_parallelogram_on_line {

    # I.44
    my $self = shift;
    Validate::Inputs( \@_, [qw(Line Angle)], [qw(speed)] );
    my $line  = shift;
    my $angle = shift;
    my $speed = shift || 1;

    # create parallelogram equal in size to triangle (I.42)
    my ( $s1, $a2 ) = $self->parallelogram( $angle, $speed );
    $s1->grey;
    $a2->remove;

    # copy this parallelogram to the line
    my $s4 = $s1->copy_to_line( $line, $speed, 1 );
    $s1->remove();

    # return the parallelogram
    return $s4;
}

sub circumscribe {
    my $triangle = shift;
    my $speed    = shift || 1;
    my $cn       = $triangle->{-cn};

    # bisect two sides of the triangle
    my ( %p, %l );
    $p{D} = $triangle->l(1)->bisect();
    $p{E} = $triangle->l(3)->bisect();

    # Find the centre of the circle
    $l{1} = $triangle->l(1)->perpendicular( $p{D} );
    $l{2} = $triangle->l(3)->perpendicular( $p{E} );
    my @p = $l{1}->intersect( $l{2} );

    # clean up
    $l{1}->remove;
    $l{2}->remove;
    $p{D}->remove;
    $p{E}->remove;

    # Draw the circle
    my $c = Circle->new( $cn, @p, $triangle->p(1)->coords );
    return $c;

}

sub golden {
    my $class = shift;
    my $line  = shift;
    my $speed = shift || 1;
    my $cn    = $line->canvas;
    Validate::error_trap( "Triangle", "you need a line to for this dummy!" )
      unless $line;
    my ( %p, %c, %l );

    $p{C}  = $line->golden_ratio($speed);
    $p{B}  = Point->new( $cn, $line->end );
    $c{A}  = Circle->new( $cn, $line->start, $line->end, $speed );
    $l{AC} = Line->new( $cn, $line->start, $p{C}->coords );
    $l{BD} = $l{AC}->copy_to_circle( $c{A}, $p{B}, $speed, "negative" );

    # which way to construct triangle? make sure angles are less than 90
    my $t;
    my $a = Angle->new( $cn, $line, $l{BD} );
    if ( $a->arc < 90 ) {
        $t =
          Triangle->new( $cn, $line->start, $l{BD}->start, $line->end, $speed );
    }
    else {
        $t =
          Triangle->new( $cn, $line->start, $line->end, $l{BD}->start, $speed );
    }
    $a->remove;

    # cleanup
    $p{C}->remove;
    $p{B}->remove;
    $l{AC}->remove;
    $l{BD}->remove;
    $c{A}->remove;
    return bless $t, $class;
}

sub copy_to_circle {
    my $self   = shift;
    my $circle = shift;
    my $speed  = shift || 1;
    my $cn     = $self->canvas;
    my ( %p, %l, %a );

    # get the angles of the triangle
    # (make new ones so we can delete them afterwards)
    my $angles;
    my $lines = $self->lines;
    foreach my $s ( 1 .. 3 ) {
        my $ss = $s - 1;
        $ss = 3 if $ss == -1;
        $angles->[ $s - 1 ] =
          Angle->new( $cn, $lines->[ $s - 1 ], $lines->[ $ss - 1 ] );
        $angles->[ $s - 1 ]->grey;
    }

    # Draw a line GH tangent to the cirle at point A
    $p{A} = $circle->point(90);
    my $r1 = Line->new( $cn, $circle->centre, $p{A}->coords, $speed );
    $l{GA} = $r1->perpendicular( $p{A}, $speed, 'negative' )->grey;
    $r1->remove;

    $l{clone} = $l{GA}->clone;
    $l{clone}->prepend( 2 * $circle->radius );
    $l{AH} = Line->new( $cn, $p{A}->coords, $l{clone}->start, $speed );
    $l{clone}->remove;
    $p{H} = Point->new( $cn, $l{AH}->end );

    # Copy the angle E to line GH, at point A (I.23)
    ( $l{a1}, $a{1} ) = $angles->[1]->copy( $p{A}, $l{AH}, "negative", $speed );
    $l{a1}->grey;
    $a{1}->grey;
    $l{a1}->extend( 2 * $circle->radius );
    my @p = $circle->intersect( $l{a1} );
    $p{C} = Point->new( $cn, @p[ 0, 1 ] );

    # Copy the angle L to line GH, at point A (I.23)
    ( $l{a2}, $a{2} ) = $angles->[2]->copy( $p{A}, $l{GA}, undef, $speed );
    $l{a2}->extend( 2 * $circle->radius );
    @p = $circle->intersect( $l{a2} );
    $p{B} = Point->new( $cn, @p[ 2, 3 ] );

    # create new triangle
    my $t = Triangle->join( $p{A}, $p{B}, $p{C}, $speed )->normal;

    # clean up
    foreach my $o ( \%l, \%p, \%a ) {
        foreach my $k ( keys %$o ) {
            $o->{$k}->remove;
        }
    }
    foreach my $i ( 0 .. 2 ) {
        $angles->[$i]->remove;
    }

    return $t;

}

sub area {

    # calculate and return area of triangle
    my $self = shift;
    my $area = 0;

    # heron's formula
    # A = sqrt(s(s-a)(s-b)(s-c)) where s = 1/2(a+b+c)
    my $a = $self->l(1)->length;
    my $b = $self->l(2)->length;
    my $c = $self->l(3)->length;
    my $s = 0.5 * ( $a + $b + $c );

    $area = sqrt( $s * ( $s - $a ) * ( $s - $b ) * ( $s - $c ) );
    return $area;

}
1;
