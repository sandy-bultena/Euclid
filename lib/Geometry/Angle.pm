#!/usr/bin/perl
use strict;
use warnings;

package Angle;
use Time::HiRes qw(usleep);
use Math::Trig qw(asin_real rad2deg deg2rad :radial);

use Geometry::Validate;
use Geometry::Point;
use Geometry::Circle;

our $NO_COMPLAIN = 1;

our @ISA = qw(Shape);

=head1 NAME

Angle - create and manipulate angle objects

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;

    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();

    # create and draw two lines
    my $line1 = Line->new( $cn, 10,10 ,100,100 );
    my $line2 = Line->new( $cn, 10,10 ,10,100 );
    
    # what is the angle between these two lines?
    my $a = Angle->calculate($line1,$line2);

    # check if these two lines meet at a point
    my ($x,$y,$v1,$v2) = Angle->angle_coords($line1,$line2);
    
    # if they don't, complain
    unless (defined $x) {
        die "These two lines do not meet at a common point\n";
    }

    # else create, draw and label the angle between the two lines
    my $alpha = Angle->new($cn, $line1, $line2)->label("A");
    
    # draw a line that bisects the angle between the two lines
    my ($line,@others) = $alpha->bisect();

=head1 CLASS METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ($cn, $l1, $l2, [-size=>$number])

Creates and draw an arc between the two lines specified

Note that the arc is draw from the first line, to the second, in a 
counterclockwise direction

Program exits with a failure if both lines do not meet at a common point.

If uncertain about your lines, use Angle->angle_coords to verify lines before calling C<new>.

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<l1> - Line object for line 1

=item * C<l2> - Line object for second line

=item * C<-size> => size of the arc from the center

=back

B<Returns>

=over

=item * Angle object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;
    return
      unless Validate::Inputs(
                               \@_, [qw(canvas Line Line)],
                               [], {qw(-size number -noright number)}
                             );
    my $cn      = shift;
    my $l1      = shift;
    my $l2      = shift;
    my @options = @_;

    my $self = { -cn => $cn, -l1 => $l1, -l2 => $l2, @options };
    bless $self, $class;

    # draw the angle
    $self->draw();

    return $self;

}

# ============================================================================
# calculate
# ============================================================================

=head2 calculate ($l1, $l2)

B<Parameters>

=over 

=item * C<l1> - Line object for line 1

=item * C<l2> - Line object for second line

=back

B<Returns>

=over

=item Angle (in degrees) between the two lines (0 if the lines don't touch)

=back

=cut

# -----------------------------------------------------------------------------
sub calculate {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Line Line)] );
    my $l1 = shift;
    my $l2 = shift;

    # ------------------------------------------------------------------------
    # find a common vertex
    # ------------------------------------------------------------------------
    my ( $vx, $vy, $vec1, $vec2 ) = Angle->angle_coords( $l1, $l2 );

    unless ( defined $vx && defined $vy ) {
        Validate::complain("Cannot find a common vertex for this angle");
        return 0;
    }

    # ------------------------------------------------------------------------
    # convert vectors to angles
    # ------------------------------------------------------------------------
    my ( $r1, $theta1, $phi1 ) = cartesian_to_spherical( @$vec1, 0 );
    my ( $r2, $theta2, $phi2 ) = cartesian_to_spherical( @$vec2, 0 );

    $theta1 = rad2deg($theta1);
    $theta2 = rad2deg($theta2);

    my $dtheta = abs( $theta1 - $theta2 );
    my $start  = $theta1;

    if ( $theta1 > $theta2 ) { $dtheta = 360 - $dtheta }

    return $dtheta;
}

# ============================================================================
# angle_coords
# ============================================================================

=head2 angle_coords ($l1, $l2)

Determine the common point between two lines, and relative 
x,y position from vertex for both lines

B<Parameters>

=over 

=item * C<$l1> - Line object for first line

=item * C<$l2> - Line object for second line

=back

B<Returns>

=over

=item * C<x> x - position of the vertex

=item * C<y> y - position of the vertex

=item * C<\@v1> - array ref to (x,y) offset from vertex for first line

=item * C<\@v2> - array ref to (x,y) offset from vertex for second line

=back

NOTE:  The offset vectors (@v1,@v2) give the y offset in the normal cartesian
coordinate system (y up is positive) so that cartesian to spherical conversions
work as expected.

=cut

# -----------------------------------------------------------------------------
sub angle_coords {
    my $class = shift;
    Validate::Inputs( \@_, [qw(Line Line)] );
    my $l1 = shift;
    my $l2 = shift;

    my ( $l1_x1, $l1_y1, $l1_x2, $l1_y2 ) = $l1->endpoints();
    my ( $l2_x1, $l2_y1, $l2_x2, $l2_y2 ) = $l2->endpoints();
    my ( @v1,    @v2,    $vx,    $vy );

    # ------------------------------------------------------------------------
    # vertex is L1(start) and L2(start)
    # ------------------------------------------------------------------------
    if ( ( abs( $l1_x1 - $l2_x1 ) < 1 ) && ( abs( $l1_y1 - $l2_y1 ) < 1 ) ) {
        ( $vx, $vy ) = ( $l1_x1, $l1_y1 );
        @v1 = ( $l1_x2 - $vx, $vy - $l1_y2 );
        @v2 = ( $l2_x2 - $vx, $vy - $l2_y2 );
    }

    # ------------------------------------------------------------------------
    # vertex is L1(end) and L2(start)
    # ------------------------------------------------------------------------
    if ( ( abs( $l1_x2 - $l2_x1 ) < 1 ) && ( abs( $l1_y2 - $l2_y1 ) < 1 ) ) {

        ( $vx, $vy ) = ( $l1_x2, $l1_y2 );
        @v1 = ( $l1_x1 - $vx, $vy - $l1_y1 );
        @v2 = ( $l2_x2 - $vx, $vy - $l2_y2 );
    }

    # ------------------------------------------------------------------------
    # vertex is L1(end) and L2(end)
    # ------------------------------------------------------------------------
    if ( ( abs( $l1_x2 - $l2_x2 ) < 1 ) && ( abs( $l1_y2 - $l2_y2 ) < 1 ) ) {

        ( $vx, $vy ) = ( $l1_x2, $l1_y2 );
        @v1 = ( $l1_x1 - $vx, $vy - $l1_y1 );
        @v2 = ( $l2_x1 - $vx, $vy - $l2_y1 );
    }

    # ------------------------------------------------------------------------
    # vertex is L1(start) and L2(end)
    # ------------------------------------------------------------------------
    if ( ( abs( $l1_x1 - $l2_x2 ) < 1 ) && ( abs( $l1_y1 - $l2_y2 ) < 1 ) ) {

        ( $vx, $vy ) = ( $l1_x1, $l1_y1 );
        @v1 = ( $l1_x2 - $vx, $vy - $l1_y2 );
        @v2 = ( $l2_x1 - $vx, $vy - $l2_y1 );
    }
    return $vx, $vy, \@v1, \@v2;
}

=head1 OBJECT METHODS

=cut

# ============================================================================
# draw
# ============================================================================

=head2 draw ()

Draws the angle object (object must already be defined)

Note that the arc is draw from the first line, to the second, in a 
counterclockwise direction

Program exits with a failure if both lines do not meet at a common point.

If uncertain about your lines, use Angle->angle_coords to verify lines before calling C<new>.

B<Returns>

=over

=item Angle object

=back

=cut

# -----------------------------------------------------------------------------
sub draw {
    my $self    = shift;
    my $cn      = $self->{-cn};
    my $size    = $self->{-size} || 40;
    my $noright = $self->{-noright} || 0;

    # ------------------------------------------------------------------------
    # find a common vertex
    # ------------------------------------------------------------------------
    my ( $vx, $vy, $vec1, $vec2 ) =
      $self->angle_coords( $self->{-l1}, $self->{-l2} );

    unless ( defined $vx && defined $vy ) {
        $self->{-l1}->notice;
        $self->{-l2}->notice;
        Validate::complain("Cannot find a common vertex for this angle");
        Validate::complain(   "Line coords ("
                            . join( ",", $self->{-l1}->int_coords ) . ") ("
                            . join( ",", $self->{-l2}->int_coords ) );
        return;
    }

    # ------------------------------------------------------------------------
    # convert vectors to angles
    # ------------------------------------------------------------------------
    my ( $r1, $theta1, $phi1 ) = cartesian_to_spherical( @$vec1, 0 );
    my ( $r2, $theta2, $phi2 ) = cartesian_to_spherical( @$vec2, 0 );

    $theta1 = rad2deg($theta1);
    $theta2 = rad2deg($theta2);

    my $dtheta = abs( $theta1 - $theta2 );
    my $start  = $theta1;

    if ( $theta1 > $theta2 ) { $dtheta = 360 - $dtheta }

    # ------------------------------------------------------------------------
    # create decent size virtual lines (for copying, bisecting, etc)
    # ------------------------------------------------------------------------
    my $vl1 =
      VirtualLine->new( $vx, $vy, $vx + $vec1->[0], $vy - ( $vec1->[1] ) );
    my $vl2 =
      VirtualLine->new( $vx, $vy, $vx + $vec2->[0], $vy - ( $vec2->[1] ) );
    if ( $vl1->length < 100 ) { $vl1->extend(100); }
    if ( $vl2->length < 100 ) { $vl2->extend(100); }
    $self->{-vl1} = $vl1;
    $self->{-vl2} = $vl2;

    # ------------------------------------------------------------------------
    # if right angle, draw a square
    # ------------------------------------------------------------------------
    my ( @p1, @p2, @p3, @sq );
    my $right_angle = 0;
    if ( abs( $dtheta - 90 ) < 0.1 ) {
        $right_angle = 1 unless $noright;
    }

    # if a right angle, make it half the size
    if ($right_angle) {
        $size = 0.5 * $size;
        $self->{-size} = $size;

        # what is the point, a distance $size, from the vertex?
        @p1 = $vl1->point($size);

        # what are the coordinates of the square
        @sq = CalculatePoints->square( $vx, $vy, @p1 );
    }

    # ------------------------------------------------------------------------
    # create the canvas objects
    # ------------------------------------------------------------------------
    my @cs = $self->normal_colour();

    foreach my $width (@Shape::shape_sizes) {
        my @inputs = ( -outline => $cs[ 4 - $width ], -width => $width, );

        my $o;

        # arc
        if ( !$right_angle ) {
            $o = $cn->createArc(
                             $vx + $size, $vy + $size, $vx - $size, $vy - $size,
                             @inputs,
                             -extent => $dtheta,
                             -start  => $start,
                             -style  => "arc",
            );
        }

        # square
        else {
            $o = $cn->createPolygon(
                                     @sq,
                                     -fill => undef,
                                     @inputs
                                   );
        }
        push @{ $self->{-objects} }, $o;
    }

    # ------------------------------------------------------------------------
    # save data for this object
    # ------------------------------------------------------------------------
    $self->{-v}     = [ $vx, $vy ];
    $self->{-start} = $start;
    $self->{-arc}   = $dtheta;
    $self->{-x2}    = $vx + $size;
    $self->{-y2}    = $vy + $size;
    $self->{-x1}    = $vx - $size;
    $self->{-y1}    = $vy - $size;
    $self->label( $self->label_is );

    # ------------------------------------------------------------------------
    # bind the "notice" routine to mouse click
    # ------------------------------------------------------------------------
    $self->_bind_notice();

    $cn->update();
    return $self;

}

# ============================================================================
# label
# ============================================================================

=head2 label ([$label, [$size]])

Add label to angle.  If no label is specified, the current label is removed.

B<Parameters>

=over 

=item * C<$label> - text used for the label

=item * C<$size> - [OPTIONAL] re-size angle to this size 
(defaults to original size)

=back

B<Returns>

=over

=item * angle object

=back

=cut

# -----------------------------------------------------------------------------
sub label {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(text text)] );
    my $text = shift || "";
    my $size;
    eval { no warnings; $size = shift || ''; $size = int($size) };

    # ------------------------------------------------------------------------
    # properly defined angle?
    # ------------------------------------------------------------------------
    unless ( defined $self->{-v} && @{ $self->{-v} } ) {
        Validate::complain("Cannot label a badly defined angle");
        return;
    }

    # ------------------------------------------------------------------------
    # get info from the object data
    # ------------------------------------------------------------------------
    my $cn = $self->{-cn};
    my $e  = $self->{-arc};
    my $s  = $self->{-start};
    my $o  = $self->{-size} || 40;
    my $v  = [ $self->{-x2} - $o, $self->{-y2} - $o ];

    # ------------------------------------------------------------------------
    # redraw if size has changed
    # ------------------------------------------------------------------------
    if ( $size && $size != $o ) {
        $self->remove();
        $self->{-size} = $size;
        $cn->update();
        $self->draw();
        $o = $self->{-size};
    }

    # ------------------------------------------------------------------------
    # determine position of the mid-arc
    # ------------------------------------------------------------------------
    my $offset = 20;
    if ( abs( $e - 90 ) < .001 ) { $offset = 30 }
    my $x = $v->[0] + cos( deg2rad( $s + 0.5 * $e ) ) * ( $o + $offset );
    my $y = $v->[1] - sin( deg2rad( $s + 0.5 * $e ) ) * ( $o + $offset );

    # ------------------------------------------------------------------------
    # create the label
    # ------------------------------------------------------------------------
    $self->SUPER::_draw_label( $cn, $x, $y, $text, 'exactly' );
    return $self;
}

# ============================================================================
# remove
# ============================================================================

=head2 remove ()

Remove angle from canvas

=cut

# -----------------------------------------------------------------------------
sub remove {
    my $self = shift;
    Validate::Inputs( \@_, [], [] );
    $self->SUPER::remove();
}

# ============================================================================
# copy
# ============================================================================

=head2 copy ($p, $l, [$side, [$speed]])

Copy this angle onto another position

B<Parameters>

=over 

=item * C<$p> Point object - what point on the line, where to draw the angle

=item * C<$l> Line object - what line to draw the angle on

=item * C<$side> - [OPTIONAL] which direction to draw the angle

'positive' = anti-clockwise (default), 'negative' = clockwise

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * new line object (at an angle to input line)

=item * new angle object

=back

=cut

# -----------------------------------------------------------------------------
sub copy {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point Line)], [qw(side speed)] );
    my $point = shift;
    my $line  = shift;
    my $side  = shift || "positive";
    my $speed = shift || 1;
    my $cn    = $self->{-cn};

    my @v = @{ $self->{-v} };

    # ------------------------------------------------------------------------
    # if point is not one of the endpoints of the line, complain, and bail
    # ------------------------------------------------------------------------
    my @end   = $line->end();
    my @start = $line->start();
    if (
         ( abs( $point->x - $end[0] ) > 1 || abs( $point->y - $end[1] ) > 1 )
         && (    abs( $point->x - $start[0] ) > 1
              || abs( $point->y - $start[1] ) > 1 )
       )
    {
        Validate::complain(   "When copying an angle to a line, "
                            . "the point must be one of the endpoints" );
        return;
    }
    
    # ------------------------------------------------------------------------
    # the point should be at the start of the line
    # ------------------------------------------------------------------------
    my $clone;
    if ( abs( $point->x - $end[0] ) < 1 && abs( $point->y - $end[1] ) < 1 ) {
        $clone = Line->new($cn,@end,@start);
    }
    else {
        $clone = Line->new($cn,@start,@end);
    }
    $clone->blue;

    # ------------------------------------------------------------------------
    # extend the lines if the lines defining the angle are too small
    # ------------------------------------------------------------------------
    if ( $clone->length < 500 ) { $clone->extend(500) }

    # ------------------------------------------------------------------------
    # define minimum length of all lines
    # ------------------------------------------------------------------------
    my $min_length = 0;
    $min_length =
        $self->{-vl1}->length() > $self->{-vl2}->length()
      ? $self->{-vl2}->length()
      : $self->{-vl1}->length();

    $min_length =
        $min_length > $clone->length()
      ? $line->length()
      : $min_length;

    $min_length = $min_length - 10;

    # ------------------------------------------------------------------------
    # define point D and E on angle
    # ------------------------------------------------------------------------
    my $c1 = Circle->new( $cn, @v, $v[0] + $min_length, $v[1], $speed )->red;
    my @p1 = $c1->intersect( $self->{-vl1} );
    my @p2 = $c1->intersect( $self->{-vl2} );
    my $pn1 = Point->new( $cn, @p1 )->label("P1");
    my $pn2 = Point->new( $cn, @p2 )->label("P2");
    $c1->remove();

    # ------------------------------------------------------------------------
    # copy CE to AF
    # ------------------------------------------------------------------------
    my $l1 = Line->new( $cn, @v, @p1, -1 );
    my ( $ln1, @o ) = $l1->copy( $point, $speed );
    $ln1->green;
    my $c2 = Circle->new( $cn, $point->coords(), $ln1->end, $speed );
    foreach my $o ( $ln1, @o ) {
        $o->remove() if $o;
    }

    my @p3 = $c2->intersect($line);
    unless (@p3) {
        my $limit = 0;
        while ( scalar(@p3) == 0 && $limit < 5 ) {
            $limit++;
            $clone->extend(100);
            @p3 = $c2->intersect($clone);
        }
       # $clone->remove();
    }
    # line intersected with circle in two places,
    # pick the point that is closest to the vertex
 #   my $v = Point->new($cn,@{$self->{-v}})->label("V");
 
 #   if (@p3 > 2) {
 #       print "HELLO!!!\n";
 #       if (VirtualLine->new(@p3[2,3],@{$self->{-v}})->length < VirtualLine->new(@{$self->{-v}}[0,1],@p1)->length) {
 #           @p3[0,1] = @p3[2,3];
 #       }
 #   }
    my $pn3 = Point->new( $cn, @p3[ 0, 1 ] )->label("pn3");

    # ------------------------------------------------------------------------
    # copy line DE to point F
    # ------------------------------------------------------------------------
    my $l3 = Line->new( $cn, @p1, @p2, -1 )->grey();
#    $l3->remove();
    my ( $ln3, @o2 ) = $l3->copy( $pn3, $speed );
    my $c3 = Circle->new( $cn, $pn3->coords(), $ln3->end, $speed )->grey;
    foreach my $o ( $l1, $pn3, $pn1, $pn2, $l3, $ln3, @o2 ) {
      #  $o->remove() if $o;
    }

    # ------------------------------------------------------------------------
    # new lines creating the copied angle (undrawn)
    # ------------------------------------------------------------------------
    my @p4 = $c3->intersect($c2);
    unless ( CalculatePoints->are_points(@p4) ) {
        Validate::complain("WTF!");
        use Data::Dumper;
        print Dumper \@p4;
    }
    my $lt1 = Line->new( $cn, $point->coords(), $p4[0], $p4[1], $speed )->grey;
    my $lt2 = Line->new( $cn, $point->coords(), $p4[2], $p4[3], $speed )->grey;

    foreach my $o ( $l1, $pn3, $pn1, $pn2, $l3, $ln3, @o2 ) {
        $o->remove() if $o;
    }

    # ------------------------------------------------------------------------
    # which line/angle do we want?
    # ------------------------------------------------------------------------
    my $angle;
    eval {
        my ( $at1, $at2 );

        # negative angle
        if ( $side eq "negative" ) {
            $at1 = Angle->new( $cn, $lt1, $line );
            $at2 = Angle->new( $cn, $lt2, $line );
        }

        # positive angle
        else {
            $at1 = Angle->new( $cn, $line, $lt1 );
            $at2 = Angle->new( $cn, $line, $lt2 );
        }

        # so, which one is the one we want to copy?
        if ( abs( $at2->arc() - $self->arc() ) < 1 ) {
            my $tmp = $lt1;
            $lt1 = $lt2;
            $lt2 = $tmp;
            $at1->remove();
            $angle = $at2;
        }

        else {
            $angle = $at1;
            $at2->remove();
        }
    };

    $lt2->remove();
    $cn->update();

    # ------------------------------------------------------------------------
    # cleanup
    # ------------------------------------------------------------------------
    $c2->remove();
    $c3->remove();
    $lt1->normal;
    $clone->remove;
    return $lt1, $angle;
}

# ============================================================================
# bisect
# ============================================================================

=head2 bisect ([$speed])

Bisect the angle

B<Parameters>

=over 

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * new line object that bisects the angle

=item * new point object (intersection of the two circles)

=item * three new circle objects used in the construction 

=back

=cut

# -----------------------------------------------------------------------------
sub bisect {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(speed)] );
    my $speed = shift || 1;

    my $cn = $self->{-cn};
    my $l1 = $self->{-l1};
    my $l2 = $self->{-l2};

    # ------------------------------------------------------------------------
    # find the vertex of the two lines, and vectors from the
    # vertex to the end of each line
    # ------------------------------------------------------------------------
    my ( %l, %p, %c );
    my ( $vx, $vy, $v1, $v2 ) = Angle->angle_coords( $l1, $l2 );

    unless ( defined $vx && defined $vy ) {
        Validate::complain("Cannot find a common vertex to bisect this angle");
        return;
    }

    # ------------------------------------------------------------------------
    # make two temporary lines
    # ------------------------------------------------------------------------
    my $s1 = Line->new( $cn, $vx, $vy, $v1->[0] + $vx, $vy - $v1->[1], -1 );
    my $s2 = Line->new( $cn, $vx, $vy, $v2->[0] + $vx, $vy - $v2->[1], -1 );
    $s1->grey();
    $s2->grey();

    # ------------------------------------------------------------------------
    # define points B and C on the two lines, equidistance from the vertex
    # ------------------------------------------------------------------------

    # pick the shorter of the two lines to find the initial point
    my $short = $l1->length < $l2->length ? $l1 : $l2;
    my @p = $s1->point( 0.75 * $short->length() );
    $p{B} = Point->new( $cn, @p );

    $c{A} = Circle->new( $cn, $vx, $vy, $p{B}->coords(), $speed )->grey;
    @p = $c{A}->intersect($l2);
    $p{C} = Point->new( $cn, @p[ 0, 1 ] );

    # ------------------------------------------------------------------------
    # draw two circles, radius BC, centers: B & C.
    # - find the intersection points between two circles
    # ------------------------------------------------------------------------
    my $c1 = Circle->new( $cn, $p{B}->coords(), $p{C}->coords, $speed )->grey;
    my $c2 = Circle->new( $cn, $p{C}->coords(), $p{B}->coords, $speed )->grey;
    my @ps = $c1->intersect($c2);
    my $p1;
    if ( $ps[3] < $ps[1] ) {
        $p1 = Point->new( $cn, @ps[ 0, 1 ] );
    }
    else {
        $p1 = Point->new( $cn, @ps[ 2, 3 ] );
    }

    # ------------------------------------------------------------------------
    # draw a line to intersection
    # ------------------------------------------------------------------------
    $l{AD} = Line->new( $cn, $vx, $vy, $p1->coords(), $speed );

    # ------------------------------------------------------------------------
    # cleanup
    # ------------------------------------------------------------------------
    $c1->grey();
    $c2->grey();
    $c{A}->grey();

    $s1->remove();
    $s2->remove();
    $p{B}->remove();
    $p{C}->remove();

    # ------------------------------------------------------------------------
    # return new line, point, all circles
    # ------------------------------------------------------------------------
    return $l{AD}, $p1, $c1, $c2, $c{A};

}

# ============================================================================
# bisect
# ============================================================================

=head2 clean_bisect ([$speed])

Bisect the angle, only return the bisecting line

B<Parameters>

=over 

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * new line object that bisects the angle

=back

=cut

# -----------------------------------------------------------------------------
sub clean_bisect {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(speed)] );
    my @out = $self->bisect(@_);
    foreach my $i ( 1 .. scalar(@out) - 1 ) {
        $out[$i]->remove;
    }
    return $out[0];
}

# ============================================================================
# arc
# ============================================================================

=head2 arc ()

Returns the value of the angle

=cut

# -----------------------------------------------------------------------------
sub arc {
    my $self = shift;
    return $self->{-arc};
}

# ============================================================================
# notice
# ============================================================================

=head2 notice ()

Makes the object go bold, and glow red, temporarily

=cut

# -----------------------------------------------------------------------------
sub notice {
    my $self = shift;

    # get info from the object data
    my $cn    = $self->{-cn};
    my $obj   = @{ $self->{-objects} }[-1];
    my $width = $cn->itemcget( $obj, -width );

    # define callback sub used by "SUPER::notice"
    my $sub =
      sub { my $i = shift; $cn->itemconfigure( $obj, -width => $i + $width ) };

    # setup and execute SUPER::notice
    $self->{-l1}->red() if $self->{-l1};
    $self->{-l2}->red() if $self->{-l2};
    $self->SUPER::notice($sub);
    $self->{-l1}->normal() if $self->{-l1};
    $self->{-l2}->normal() if $self->{-l2};
}

# ============================================================================
# lines
# ============================================================================

=head2 lines ()

Returns the lines used to define the angle

=cut

# -----------------------------------------------------------------------------
sub lines {
    my $self = shift;
    return $self->{-l1}, $self->{-l2};
}

# ============================================================================
# grey
# ============================================================================

=head2 grey() / green() / red() / normal()

Change the colour of the object

If object colour is changed to grey, then the object labels will be hidden.

If object colour is changed from grey to any other colour, the object labels
will be redrawn.

=cut

sub grey {
    my $self = shift;
    $self->_set_colour( "-outline", "grey" );
    return $self;
}

# ============================================================================
# red
# ============================================================================
sub red {
    my $self = shift;
    $self->_set_colour( "-outline", "red" );
    return $self;
}

# ============================================================================
# green
# ============================================================================
sub green {
    my $self = shift;
    $self->_set_colour( "-outline", "green" );
    return $self;
}

# ============================================================================
# normal
# ============================================================================
sub normal {
    my $self = shift;
    $self->_set_colour( "-outline", "normal" );
    return $self;
}

1;

=head1 AUTHOR

Sandy Bultena

=head1 COPYRIGHT

This module is copyright (c) 2014 Sandy Bultena. All rights reserved.

This library is free software; you may redistribute and/or modify it under 
the terms of either the GNU General Public License 
or the Perl Artistic License, as specified in the Perl 5.10.0 README file.

=cut
