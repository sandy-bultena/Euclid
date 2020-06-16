#!/usr/bin/perl
use strict;
use warnings;

package Line;
use Geometry::Shape;
use Geometry::Validate;
use Colour;

use Time::HiRes qw(usleep);
use Math::Trig qw(rad2deg deg2rad :radial);

our @ISA = qw(CanvasLine);

=head1 NAME

Line - create and manipulate Line objects

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;
    
    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();

    # create and draw two lines
    my $l1 = Line->new( $cn, 50,50 ,150,150 )->label("A","top");
    my $l2 = Line->new( $cn, 150,50, 50,150 )->label("B","right");

    # get info about lines
    my $sl1 = $l1->slope();
    my $a1 = $l1->angle();
    my $d1 = $l1->length();

    # make the line longer, what are the new coordinates?
    $l1->extend(20);
    $l1->prepend(20);
    my @coords = $l1->endpoints();
    
    # define a point a distance 20 from the start
    my $p20 = Point->new($cn,$l1->point(20));  
    
    # what is the distance beween this point, and line 2?
    my $len1 = $l2->length_from_start($p20);
    my $len2 = $l2->length_from_end($p20);

    # what is the intersection point between these two lines
    my ($x1,$y1) = $l1->intersect($l2);
    print "No intersection!\n" unless defined $x1;

    # split the line at the intersection point
    my $p = Point->new($cn,$x1,$y1);
    my ($l3,$l4) = $l1->split($p);
    
    # make the line segment stand out temporarily
    $l3->notice();
    
    # rotate the line segment to 90 degrees
    $l3->rotateTo(90);
    
    # copy line3 back to the intersection point
    my ($l4,$p2) = $l3->copy($p);

    # make a line, and copy it starting at the beginning of $l2, 
    # and laying congruent with $l2
    $l1 = Line->new( $cn, 50,50 ,170,50 )->label("A","top");
    $l2 = Line->new( $cn, 150,150, 150,350 )->label("B","right");
    $p = Point->new($cn,$l2->start);
    ($l3,$p2) = $l1->copy_to_line($p,$l2);
    
    # subtract line1 from line2
    $l1 = Line->new( $cn, 50,50 ,170,50 );
    $l2 = Line->new( $cn, 150,150, 150,350 );
    $l3 = $l2->subtract($l1);
    $l2->remove();
    
    # bisect
    $p = $l3->bisect();
    
    # draw a line parallel to this one, through a specified point
    $l2->parallel(Point->new($cn,200,200));
    

    # ---------------------
    # no drawing or animation
    # ---------------------
    my $l1 = VirtualLine->new( $cn, 10,10 ,100,100 );
    my $l2 = virtualLine->new( $cn, 100,100,10,10 );

    # what is the intersection point between these two lines
    my ($x1,$y1) = $l1->intersect($l2);

=head1 Line METHODS

=cut

# ============================================================================
# join
# ============================================================================

=head2 join ($p1,$p2, [$speed])

Create and draw a line

B<Parameters>

=over 

=item * C<$p1> - start Point (object)

=item * C<$p2> - end Point (object)

=item * C<speed> - [OPTIONAL] how fast to draw the line  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Line object

=back

=cut

# -----------------------------------------------------------------------------
sub join {
    my $class = shift;
    return unless Validate::Inputs( \@_, [qw(Point Point)], [qw(speed dash)] );
    my $p1   = shift;
    my $p2   = shift;
    my $fast = shift || 1;
    my $dash = shift || 0;
    my $cn   = $p1->canvas;

    # define object
    return Line->new( $cn, $p1->coords, $p2->coords, $fast, $dash );
}

# ============================================================================
# label
# ============================================================================

=head2 label ([$text, [$where]] )

Create a label for the line.  If no label defined, remove existing label.

B<Parameters>

=over 

=item * C<$text> - label text

=item * C<$where> - [OPTIONAL] where to draw the label, (default='right') 
top, bottom, left, right, topright, topleft, bottomright, bottomleft

=back

B<Returns>

=over

=item * Line object

=back

=cut

# ----------------------------------------------------------------------------
sub label {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(text where)] );
    my $what  = shift;
    my $where = shift;

    my $cn = $self->canvas;
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();

    # define location where to draw label
    my $x = 0.5 * ( $x1 + $x2 );
    my $y = 0.5 * ( $y1 + $y2 );

    # draw it
    $self->_draw_label( $cn, $x, $y, $what, $where );
    return $self;
}

# ============================================================================
# tick
# ============================================================================

=head2 tick ($distance, [$label, [$where]], [$size] )

Create a tick mark on the line.  If label is defined, 
it will be written below the line, unless $where = "top"

B<Parameters>

=over 

=item * C<$length> - length from beginning of line

=item * C<$label> - [OPTIONAL] label text

=item * C<$where> - [OPTIONAL] where to draw the label, (default='top') 
top, bottom, left, right, topright, topleft, bottomright, bottomleft

=item * C<$size> - length of tick mark [OPTIONAL]

=back

B<Returns>

=over

=item * Original Line object

=back

=cut

# ----------------------------------------------------------------------------
sub tick {
    my $self = shift;
    Validate::Inputs( \@_, [qw(number)], [qw(text where number)] );
    my $r     = shift;
    my $label = shift;
    my $where = shift || 'top';
    my $size  = shift || 5;

    # can only put ticks on the line
    return unless $r <= $self->length + 0.5;
    return unless $r >= 0;

    # get location of tick mark
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();
    my @C = $self->_coords_dist( $x1, $y1, $r );

    # calculate a perpendicular line
    my $theta = deg2rad( $self->angle() + 90 );
    my @ends = (
                 $size * cos($theta) + $C[0],
                 $size * sin($theta) + $C[1],
                 -$size * cos($theta) + $C[0],
                 -$size * sin($theta) + $C[1]
    );

    # draw line and label
    my $cn = $self->canvas;
    my $tick_line = Line->new( $cn, @ends );
    $tick_line->_draw_label( $cn, @C, $label, $where );

    $self->{-tick_marks} = [] unless $self->{-tick_marks};
    push @{ $self->{-tick_marks} }, $tick_line;
    return $tick_line;
}

# ============================================================================
# tick_marks
# ============================================================================

=head2 tick_marks ($distance, [[$label, [$where]], [$size]] )

Create as many tick marks on the line as there is room.  
If label is defined, it will be written below the line, 
unless $where = "top".  Each label subsequent to the first will
be incremented with the "++" operator.

B<Parameters>

=over 

=item * C<$length> - length from beginning of line

=item * C<$label> - [OPTIONAL] label text

=item * C<$where> - [OPTIONAL] where to draw the label, (default='top') 
top, bottom, left, right, topright, topleft, bottomright, bottomleft

=item * C<$size> - length of tick mark [OPTIONAL]

=back

B<Returns>

Original Line element

=cut

# ----------------------------------------------------------------------------
sub tickmarks {
    return tick_marks(@_);
}

sub tick_marks {
    my $self = shift;
    Validate::Inputs( \@_, [qw(number)], [qw(text where number)] );
    my $r     = shift;
    my $label = shift;
    my $where = shift || 'bottom';
    my $size  = shift || 5;

    # loop over each possible tick mark
    my $rr = 0;
    foreach my $i ( 0 .. int( ( $self->length + .5 ) / $r ) ) {
        $label++ if $i && $label;
        $self->tick( $rr, $label, $where, $size );
        $rr = $rr + $r;
    }
    return $self;
}

# ============================================================================
# extend
# ============================================================================

=head2 extend ( $amount )

Extend the line by the amount specified

B<Parameters>

=over 

=item * C<$amount> - how much to add to the line

=back

B<Returns>

=over

=item * Line object

=back

=cut

# ----------------------------------------------------------------------------
sub extend {
    my $self = shift;
    Validate::Inputs( \@_, [qw(number)] );
    my $r = shift;

    my $l = $self;

    # get info from object
    my $cn = $self->canvas;
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();
    my $fast = $self->{-fast} || $Shape::DefaultSpeed;

    # save the new coordinates
    my ( $x, $y ) = $l->_coords_dist( $x1, $y1, $r + $self->length() );
    $l->{-x2} = $x;
    $l->{-y2} = $y;
    $self->_define_line_info;

    # if line has shrunk, then we must redraw it
    if ( $r < 0 ) {
        $l->remove();
        $l->draw($fast);
    }

    # draw the extension
    else {
        my $p = Point->new( $cn, $x2, $y2 );
        if ($Shape::NoAnimation) {
            CanvasLine::_animate( $self, $p, 1, $self->length() );
        }
        else {
            $l->animate( sub { CanvasLine::_animate( $l, $p, 1, @_ ) }, $fast, $r );
        }
        $p->remove();
    }

    return $l;

}

# ============================================================================
# prepend
# ============================================================================

=head2 prepend ( $amount )

Prepend the line by the amount specified

B<Parameters>

=over 

=item * C<$amount> - how much to add to the line

=back

B<Returns>

=over

=item * Line object

=back

=cut

# ----------------------------------------------------------------------------
sub prepend {
    my $self = shift;
    Validate::Inputs( \@_, [qw(number)] );
    my $r = shift;

    my $l = $self;

    # get info from object
    my $cn = $self->canvas;
    my ( $x1, $y1, $x2, $y2 ) = $l->endpoints();
    my $fast = $l->{-fast} || $Shape::DefaultSpeed;

    # save the new coordinates
    my ( $x, $y ) = $l->_coords_dist( $x1, $y1, -$r );
    $l->{-x1} = $x;
    $l->{-y1} = $y;
    $self->_define_line_info;

    # if line has shrunk, then we must redraw it
    if ( $r < 0 ) {
        $l->remove();
        $l->draw($fast);
    }

    # draw the extension
    else {
        my $p = Point->new( $cn, $x2, $y2 );
        if ($Shape::NoAnimation) {
            CanvasLine::_animate( $self, $p, 1, $self->length() );
        }
        else {
            $l->animate( sub { CanvasLine::_animate( $l, $p, -1, @_ ) }, $fast, $r );
        }
        $p->remove();
    }

    return $l;
}

# ============================================================================
# split
# ============================================================================

=head2 split ( $p1, $p2 ... )

Takes the given line, and splits at the specified points. 

Note that the points do not actually have to be on the line.

B<Parameters>

=over 

=item * C<$p1> - Point object defining where to split the line

=back

B<Returns>

A series of lines connected at the specified points 

=over

=item * All new line objects (the original is removed)

=back

=cut

# ----------------------------------------------------------------------------
sub split {
    my $self = shift;
    my @val  = ('Point') x scalar(@_);
    Validate::Inputs( \@_, \@val );
    my @pts = @_;

    my $cn = $self->canvas;
    my @lns;
    my @coords;

    # what points to create new lines
    push @coords, $self->start();
    foreach my $pt (@pts) {
        push @coords, $pt->coords();
    }
    push @coords, $self->end();

    # make new lines
    foreach my $i ( 0 .. scalar(@pts) ) {
        my $off = $i * 2;
        push @lns, Line->new( $cn, @coords[ $off .. $off + 3 ], -1 );
    }
    $self->remove();
    return @lns;
}

# ============================================================================
# rotateTo
# ============================================================================

=head2 rotateTo ( $angle, [$speed] )

Rotate the line to the angle specified (rotates around the starting pt)

B<Parameters>

=over 

=item * C<$angle> - Final angle position of the line

=item * C<$speed> - [OPTIONAL] how fast to rotate the line 
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

=cut

# ----------------------------------------------------------------------------
sub rotateTo {
    my $self = shift;
    Validate::Inputs( \@_, [qw(angle)], [qw(speed)] );
    my $a2 = shift;
    my $fast = shift || 1;

    # get info from object
    my $cn = $self->canvas;
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();
    my $a1  = $self->angle();
    my $r   = $self->length();
    my $phi = deg2rad(90);

    # animate the rotation
    $a2 = $a2 < 0 ? $a2 + 360 : $a2;

    if ( $fast > 0 ) {
        $self->animate(
            sub {
                my $i     = shift;
                my $angle = $a1 + $i;
                if ( $angle > 360 ) { $angle = $angle - 360 }
                if ( $angle < 0 )   { $angle = 360 + $angle }
                my ( $x, $y, $z ) =
                  spherical_to_cartesian( $r, deg2rad($angle), $phi );
                $x2 = $x1 + $x;
                $y2 = $y1 - $y;

                foreach my $l ( @{ $self->{-objects} } ) {
                    $cn->coords( $l, $x1, $y1, $x2, $y2 );
                }
            },
            $fast,
            abs( $a2 - $a1 + 1 ) % 360,
        );
    }

    # draw the final location (just in case animation doesn't work right
    my ( $x, $y, $z ) = spherical_to_cartesian( $r, deg2rad($a2), $phi );
    $self->{-x2} = $x2 = $x1 + $x;
    $self->{-y2} = $y2 = $y1 - $y;
    $self->_define_line_info;

    foreach my $l ( @{ $self->{-objects} } ) {
        $cn->coords( $l, $x1, $y1, $x2, $y2 );
    }

    return;

}

# ============================================================================
# clone
# ============================================================================

=head2 clone ( )

Creates a copy of the object (no animation, no moving, nothing!)

B<Returns>

=over

=item * The new line object

=back

=cut

# ----------------------------------------------------------------------------
sub clone {
    my $self = shift;
    my $cn   = $self->canvas;
    my $l    = Line->new( $cn, $self->endpoints(), -1 );
    return $l;
}

# ============================================================================
# copy
# ============================================================================

=head2 copy ( $pt, [$speed] )

Copies this line onto the specified point

B<Parameters>

=over 

=item * C<$pt> - Point object defining where to copy the line to

=item * C<$speed> - [OPTIONAL] how fast to animate the process
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * The new line object

=item * A new point object defining the end-point of the new line

=back

=cut

# ----------------------------------------------------------------------------
sub copy {
    require Geometry::EquilateralTriangle;

    my $self = shift;
    Validate::Inputs( \@_, [qw(Point)], [qw(speed)] );
    my $point = shift;
    my $speed = shift || 1;

    # get info from object
    my $cn     = $self->canvas;
    my @coords = $self->endpoints();
    my @A      = @coords[ 0, 1 ];
    my @B      = @coords[ 2, 3 ];
    my @C      = $point->coords();

    my %l;
    my %c;
    my %p;
    my %t;

    # ------------------------------------------------------------------------
    # If point is already on line, just make a clone, and return results
    # ------------------------------------------------------------------------
    if ( abs( $A[0] - $C[0] ) < 0.1 && abs( $A[1] - $C[1] ) < 0.1 ) {
        $l{CF} = $self->clone();
        $p{F} = Point->new( $cn, @C );
        return $l{CF}, $p{F};
    }

    # ------------------------------------------------------------------------
    # Copy the line to the new point using methods from proposition 2
    # ------------------------------------------------------------------------

    # join the two lines
    $l{AC} = Line->new( $cn, @A, @C, $speed )->grey;

    # construct equilateral on above line (D = apex of triangle)
    $t{1} = EquilateralTriangle->build( $cn, @A, @C, $speed )->grey;
    $l{AD} = $t{1}->l(3);
    $l{CD} = $t{1}->l(2);
    $p{D}  = $t{1}->p(3);

    # mark off length AB from AD (lengthen AD as required)
    $c{A} = Circle->new( $cn, @A, @B, $speed )->grey;
    my @p = $c{A}->intersect( $l{AD} );
    my $i;
    while ( scalar(@p) == 0 ) {
        $l{AD}->extend(100);
        @p = $c{A}->intersect( $l{AD} );
        $i++;
        if ( $i > 100 ) { die "Inside infinite loop\n" }
    }
    $l{AD}->grey();

    # mark off AD - AB = CD
    my @pd = $p{D}->coords();
    $p{E} = Point->new( $cn, @p );
    $p{B} = Point->new( $cn, @B );
    my @F;

    # if not the same point, do another subtraction
    if ( $p{D}->distance_to( @p[ 0, 1 ] ) > 1 ) {

        # mark off CD - AD = AB (extend as necessary)
        $c{D} =
          Circle->new( $cn, $p{D}->coords(), $p{E}->coords(), $speed )->grey;
        @F = $c{D}->intersect( $l{CD} );
        my $i = 0;
        while ( scalar(@F) == 0 ) {
            $l{CD}->prepend(100);
            @F = $c{D}->intersect( $l{CD} );
            $i++;
            if ( $i > 100 ) { die "Inside infinite loop\n" }
        }
        $l{CD}->grey;
    }

    # same point
    else {
        @F = $p{E}->coords();
    }

    # define objects
    $p{F} = Point->new( $cn, @F );
    $l{CF} = Line->new( $cn, @C, @F, $speed );

    # clean up
    $l{AC}->remove();
    $l{AD}->remove();
    $l{CD}->remove();
    $c{A}->remove();
    $c{D}->remove() if exists $c{D};
    $p{E}->remove();
    $p{B}->remove();
    $p{D}->remove();
    $l{CF}->normal();
    $p{Z}->remove()  if exists $p{Z};
    $l{BZ}->remove() if exists $l{BZ};
    $t{1}->remove();

    # I am not going to debug this now.
    if ( abs( $l{CF}->length - $self->length ) < .01 ) {
        $l{CF}->extend( $self->length - $l{CF}->length );
        $p{F}->remove;
        $p{F} = Point->new( $cn, $l{CF}->end );
    }

    # return new line, endpoint, plus extra lines and circles
    return $l{CF}, $p{F};
}

# ============================================================================
# copy_to_line
# ============================================================================

=head2 copy_to_line ( $pt, $line, [$speed] )

Copies this line onto the specified point, with the endpoint laying 
upon the given line segment (if possible).

If new line cannot intersect with the given line, then this
method is identical to the 'copy' method.

B<Parameters>

=over 

=item * C<$pt> - Point object defining where to copy the line to

=item * C<$Line> - Line where we want the end point to lay upon 

=item * C<$speed> - [OPTIONAL] how fast to animate the process
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * The new line object

=item * A new point object defining the end-point of the new line

=back

=cut

# ----------------------------------------------------------------------------
sub copy_to_line {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point Line)], [qw(speed)] );
    my $pt    = shift;
    my $ln    = shift;
    my $speed = shift || 1;
    my $cn    = $self->canvas;

    # copy line on top of specified point
    my ( $lx, $px ) = $self->copy( $pt, $speed );
    return unless $lx && $px;

    # create circle with center at point, and radius equal to line)
    my $c = Circle->new( $cn, $pt->coords(), $lx->end, $speed );

    # keep increasing length of line to intersect with circle, until
    # it does intersect (stupid idea not to do this before!)
    my @p;
    my $clone = $ln->clone;
    my $iter  = 0;
    @p = $c->intersect($ln);

    while ( ( not defined $p[0] ) && $iter < 1000 ) {
        $iter++;

        # depending on where the point is on the original line, we
        # will either extend or prepend
        if ( $ln->length_from_end($pt) > $ln->length_from_start($pt) ) {
            $clone->extend(10);
        }
        else {
            $clone->prepend(10);
        }
        @p = $c->intersect($ln);
    }

    # if intersects, then define new line with endpoint touching $ln
    if ( defined $p[0] ) {
        my $np = Point->new( $cn, @p[ 0, 1 ] );
        my $nl = Line->new( $cn, $pt->coords(), $np->coords(), $speed );
        if ( abs( $self->length - $nl->length ) > .1 ) {
            $np->remove;
            $nl->extend( $self->length - $nl->length );
            $np = Point->new( $cn, $nl->end );
        }

        $nl->normal;
        $px->remove();
        $lx->remove();
        $c->remove();
        $clone->remove;
        return $nl, $np;
    }

    # else, if doesn't intersect, then just return the copied line
    else {
        print "Circle didn't intercept!!!\n";
        $px->remove();
        $lx->blue();
        $c->remove();
        $clone->remove;
        return $lx, $px;
    }
}

# ============================================================================
# subtract
# ============================================================================

=head2 subtract ( $line, [$speed] )

Subtracts the C<$line> from self, I<if and only if> the length
of C<$line> is less than self.

B<Parameters>

=over 

=item * C<$Line> - Line to subtract 

=item * C<$speed> - [OPTIONAL] how fast to animate the process
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * A new line object, where the it is equal to the original,
minus the specified C<$line>.

If the original is longer than self, a copy of self will be returned.

=back

=cut

# ----------------------------------------------------------------------------
sub subtract {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Line)], [qw(speed)] );
    my $line = shift;
    my $speed = shift || 1;

    # return if line is not smaller than self
    return $self->clone() unless $self->length() > $line->length;

    # get info from object
    my $cn = $self->canvas;

    # define starting point, and copy $line
    my $ps = Point->new( $cn, $self->end );
    my ( $lc, $pe ) = $line->copy_to_line( $ps, $self, $speed );

    # split line (don't use split because it deletes original line)
    my $subtracted = Line->new( $self->canvas,, $self->start, $pe->coords );
    $lc->remove();
    $ps->remove();
    $pe->remove();

    # all done
    return $subtracted;

}

# ============================================================================
# bisect
# ============================================================================

=head2 bisect ( [$speed] )

Finds the point that bisects the line

B<Parameters>

=over 

=item * C<$speed> - [OPTIONAL] how fast to animate the process
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * A new point object that defines the midpoint of the line.

=back

=cut

# ----------------------------------------------------------------------------
sub bisect {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(speed)] );
    my $speed = shift || 1;

    # draw two circles with the endpoints of the lines as
    # the center, and the radii equal to the lenght of the line
    my $cn = $self->canvas;
    my $c1 = Circle->new( $cn, $self->end(), $self->start, $speed )->grey;
    my $c2 = Circle->new( $cn, $self->start(), $self->end, $speed )->grey;

    # what are the two intersection points
    my @ps = $c1->intersect($c2);

    # New line joins the two intersection points
    my $l = Line->new( $cn, @ps, $speed );
    $l->grey();

    # point is defined as the intersection of the previous line,
    # and the original line
    my $pt = Point->new( $cn, $l->intersect($self) );
    $c1->remove();
    $c2->remove();
    $l->remove();

    # return point
    return $pt;
}

# ============================================================================
# parallel
# ============================================================================

=head2 parallel ( $point, [$speed])

Construct a line parallel to another, through a given point
B<Parameters>

=over 

=item * C<$point> - Point object, draw parallel line through this point

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * New line object

=back

=cut

# -----------------------------------------------------------------------------

sub parallel {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point)], [qw(speed)] );
    my $p = shift;
    my $speed = shift || 1;

    my $cn = $self->canvas;
    my $lg = $self;

    my @B = $lg->start();
    my @C = $lg->end();
    my @A = $p->coords();

    # make sure line goes from left to right
    if ( $B[0] > $C[0] ) {
        my @T = @B;
        @B = @C;
        @C = @T;
    }

    # define new line
    $lg = $self->clone;
    my $l = Line->new( $cn, @B, @C, $speed )->green();
    if ( $l->length < 100 ) { $l->extend(100) }
    my %l;
    my %p;
    my %c;
    my %a;

    # is point on line
    my $rs = $lg->length_from_start($p);
    my $re = $lg->length_from_end($p);
    if ( abs( $rs + $re - $lg->length() ) < 0.1 ) {

        # then return a clone of the original line
        my $clone = $self->clone();
        $l->remove;
        return $clone;
    }

    # create point D on line
    $p{D} = Point->new( $cn, $l->point( 0.5 * $l->length() ) )->label("D");
    ( $l{BD}, $l{DC} ) = $l->split( $p{D} );
    $p{D}->remove();
    $l{AD} = Line->new( $cn, @A, $p{D}->coords(), $speed )->blue;

    # copy angle
    $a{ADC} = Angle->new( $cn, $l{DC}, $l{AD} )->label("ADC");
    $a{ADC}->remove();
    ( $l{EA}, my $angle ) = $a{ADC}->copy( $p, $l{AD}, "negative", $speed );
    $angle->label("EA");
    $angle->remove();

    # extend line
    $l{EA}->prepend(200);

    # cleanup
    $a{ADC}->remove();
    $l{AD}->remove();
    $l->remove();
    $p{D}->remove();
    $l{BD}->remove();
    $l{DC}->remove();
    $angle->remove();
    $lg->remove;
    $cn->update();

    return $l{EA};
}

# ============================================================================
# perpendicular
# ============================================================================

=head2 perpendicular ( $point, [$speed, [$dir]], [dash])

Construct a line perpendicular to another, through a given point

B<Parameters>

=over 

=item * C<$point> - Point object, draw perpendicular line through this point

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=item * C<$dir> - Positive or negative angle direction 

=item * C<$dash> - Set the dash type of the new line

=back

B<Returns>

=over

=item * New line object

=back

=cut

# -----------------------------------------------------------------------------
sub perpendicular {
    my $lg = shift;
    Validate::Inputs( \@_, [qw(Point)], [qw(speed dir dash)] );
    my $p     = shift;
    my $speed = shift || 1;
    my $dir   = shift || "positive";
    my $dash  = shift;

    # length of line from point to either end of the line
    my $rs = $lg->length_from_start($p);
    my $re = $lg->length_from_end($p);

    # is point not on line
    if ( abs( $rs + $re - $lg->length() ) > 0.1 ) {
        return $lg->_perp1( $p, $re, $rs, $speed );
    }

    # construct a perp from a point on the line
    return $lg->_perp2( $p, $re, $rs, $dir, $speed, $dash );
}

sub _perp1 {
    my $lg    = shift;
    my $p     = shift;
    my $re    = shift;
    my $rs    = shift;
    my $speed = shift;

    my $cn = $lg->canvas;
    my @A  = $lg->start();
    my @B  = $lg->end();
    my @C  = $p->coords();
    my %p;
    my %c;
    my $l = $lg->clone()->grey();
    $l->extend(40);
    $l->prepend(40);

    # draw a circle with the lesser of $re,$rs as the radius
    my $radius = $re > $rs ? $rs : $re;
    $c{C} = Circle->new( $cn, @C, $C[0] + $radius + 10, $C[1], $speed )->grey;

    # define two points equidistance from our initial point
    my @p;
    my $num = 0;
    while ( @p < 4 && $num < 10 ) {
        @p = $c{C}->intersect($l);
        if ( @p < 4 ) {
            $l->extend(100);
            $l->prepend(100);
        }
        $num++;
    }
    $p{D} = Point->new( $cn, @p[ 0, 1 ] );
    $p{E} = Point->new( $cn, @p[ 2, 3 ] );

    $c{C}->remove();

    # bisect the line between our two points
    my $lb     = Line->new( $cn, @p, $speed )->grey;
    my $pb     = $lb->bisect($speed);
    my $lfinal = Line->new( $cn, @C, $pb->coords, $speed )->normal;

    $p{D}->remove();
    $p{E}->remove();
    $lb->remove;
    $pb->remove;
    $l->remove;

    $cn->update();
    return $lfinal;
}

sub _perp2 {
    my $lg    = shift;
    my $p     = shift;
    my $re    = shift;
    my $rs    = shift;
    my $dir   = shift;
    my $speed = shift;
    my $dash  = shift;
    my @C     = $p->coords();
    return _perp3( $lg, \@C, $re, $rs, $dir, $speed, $dash );
}

sub _perp3 {
    my $lg    = shift;
    my $aC    = shift;
    my $re    = shift;
    my $rs    = shift;
    my $dir   = shift;
    my $speed = shift;
    my $dash  = shift;

    my $cn = $lg->canvas;
    my @A  = $lg->start();
    my @B  = $lg->end();
    my @C  = @$aC;
    my %l;
    my %p;
    my %c;
    my $l = $lg->clone()->grey();

    # draw a circle with the larger of $re,$rs as the radius
    my $radius = $re;
    if ( $rs < $re ) {
        $l->prepend( $re - $rs );
        $radius = $re;
    }
    if ( $re < $rs ) {
        $l->extend( $rs - $re );
        $radius = $rs;
    }
    $c{C} = Circle->new( $cn, @C, $C[0] + $radius, $C[1], $speed );

    # define two points equidistance from our initial point
    my @p = $c{C}->intersect($l);
    $p{D} = Point->new( $cn, @p[ 0, 1 ] );
    $p{E} = Point->new( $cn, @p[ 2, 3 ] );

    $c{C}->remove();

    # find 3rd point of equilateral triangle, without drawing lines
    my $c1 = Circle->new( $cn, $p{D}->coords(), $p{E}->coords, $speed );
    my $c2 = Circle->new( $cn, $p{E}->coords(), $p{D}->coords, $speed );
    my @ps = $c1->intersect($c2);
    my $p1;

    # if point is at either end of the line, check for positive/negative
    # options, otherwise go with defaults;
    if (    ( abs( $A[0] - $C[0] ) < 0.1 && abs( $A[1] - $C[1] ) < 0.1 )
         || ( abs( $B[0] - $C[0] ) < 0.1 && abs( $B[1] - $C[1] ) < 0.1 ) )
    {
        my $l1 = Line->new( $cn, @C, @ps[ 2, 3 ], -1, $dash )->grey();
        my $l2 = Line->new( $cn, @C, @ps[ 0, 1 ], -1, $dash )->grey();

        my $a1 = Angle->calculate( $lg, $l1 );
        my $a2 = Angle->calculate( $lg, $l2 );

        if ( $dir eq "positive" ) {
            $l{CF} = $l1 if abs( $a1 - 90 ) < 0.1;
            $l{CF} = $l2 if abs( $a2 - 90 ) < 0.1;
        }
        else {
            $l{CF} = $l2 if abs( $a1 - 90 ) < 0.1;
            $l{CF} = $l1 if abs( $a2 - 90 ) < 0.1;
        }
        $l1->remove();
        $l2->remove();
        $l{CF}->draw($speed);
    }

    # if point is in middle of line, change direction if not 'positive'
    else {
        if ( $dir eq "positive" ) {
            $l{CF} = Line->new( $cn, @C, @ps[ 0, 1 ], $speed, $dash );
        }
        else {
            $l{CF} = Line->new( $cn, @C, @ps[ 2, 3 ], $speed, $dash );
        }
    }

    $p{D}->remove();
    $p{E}->remove();

    $l{CF}->normal();
    $c1->remove();
    $c2->remove();
    $l->remove();
    $cn->update();
    return $l{CF};
}

# ============================================================================
# golden_ratio
# ============================================================================

=head2 golden_ratio ( $line, [$speed, [$dir]])

Finds a point on the line such that the whole of the line, multiplied by the
second fragment is equal to the first fragment squared.

B<Parameters>

=over 

=item * line object

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=item * C<$dir> - Positive or negative (which end of the line will 
be the smaller part) 

=back

B<Returns>

=over

=item * New point object

=back

=cut

# -----------------------------------------------------------------------------
sub golden_ratio {
    my $line = shift;
    Validate::Inputs( \@_, [], [qw(speed dir)] );
    my $speed = shift || 1;
    my $dir   = shift || "positive";
    my $cn    = $line->canvas;

    # take care of negative/positive stuff
    my $op    = "negative";
    my @end   = $line->end;
    my @start = $line->start;
    if ( $dir eq "negative" ) {
        $op    = "positive";
        @end   = $line->start;
        @start = $line->end;
    }

    # drop a perpendicular from the starting point
    my $pA = Point->new( $cn, @start );
    my $l3t = $line->perpendicular( $pA, $speed )->grey;
    if ( $l3t->length < $line->length ) {
        $l3t->extend( $line->length );
    }
    $pA->remove;

    # make line $l3 equal to original line length
    my $c  = Circle->new( $cn, @start, @end, $speed );
    my @p  = $c->intersect($l3t);
    my $l3 = Line->new( $cn, @start, @p[ 0, 1 ], $speed );
    $l3t->remove;
    $c->remove;

    # bisect AC
    my $pE = $l3->bisect();

    # extend CA to point F, such that EF is equal to EB
    $l3->prepend( $l3->length );
    $c = Circle->new( $cn, $pE->coords, @end, $speed );
    @p = $c->intersect($l3);
    my $pF = Point->new( $cn, @p );
    $c->remove;

    # find point H such that AH equals AF
    $c = Circle->new( $cn, @start, $pF->coords, $speed );
    @p = $c->intersect($line);
    my $pH = Point->new( $cn, @p );

    # cleanup
    $pE->remove;
    $c->remove;
    $pF->remove;
    $l3->remove;

    # return point
    return $pH;

}

# ============================================================================
# third_mean, third_proportional
# ============================================================================

=head2 third_mean ( $line1, $line2, $point, $angle [$speed, [$dir]])

synonym for third_proportional

=head2 third_proportional ( $line1, $line2, $point, $angle [$speed, [$dir]])

Given two lines, draws a third such that the ratio of $line1 to $line2
is the same as $line2 to the returned line

Proposition 11

B<Parameters>

=over 

=item * First line object

=item * Second line object

=item * Point where the line will be drawn

=item * Angle at which to draw the line

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * New line object

=back

=cut

# -----------------------------------------------------------------------------
sub third_proportional { return third_mean(@_) }

sub third_mean {
    my $class = shift;

    Validate::Inputs( \@_, [qw(Line Line Point float)], [qw(speed)] );
    my $line1 = shift;
    my $line2 = shift;
    my $pt    = shift;
    my $angle = shift;
    my $speed = shift || 1;
    my $cn    = $line1->canvas;
    my ( %p, %l, %c );
    $l{AB} = $line1->clone;

    # -------------------------------------------------------------------------
    # Place both lines on a common vertex
    # -------------------------------------------------------------------------
    $p{A} = Point->new( $cn, $line1->end );
    $p{B} = Point->new( $cn, $line1->start );
    ( $l{AC}, $p{C} ) = $line2->copy( $p{A}, $speed );

    # -------------------------------------------------------------------------
    # Extend AB to D, where BD is equal to AC
    # -------------------------------------------------------------------------
    $l{AD} = Line->join( $p{A}, $p{B}, -1, 1 )->extend( $l{AC}->length );
    $p{D} = Point->new( $cn, $l{AD}->end );
    $l{BD} = Line->join( $p{B}, $p{D}, $speed );

    # -------------------------------------------------------------------------
    # Draw a line from BC, and draw a line parallel to BC from point D
    # -------------------------------------------------------------------------
    $l{BC} = Line->join( $p{B}, $p{C}, $speed );
    $l{DEx} = $l{BC}->parallel( $p{D}, $speed )->dash;

    # -------------------------------------------------------------------------
    # Extend line AC and define the intercept of AC and the previous parallel
    # line as point E
    # -------------------------------------------------------------------------
    my @p = $l{AC}->intersect( $l{DEx} );
    $p{E} = Point->new( $cn, @p );
    $l{CE} = Line->join( $p{C}, $p{E} );
    $l{DEx}->remove;

    # -------------------------------------------------------------------------
    # Copy CE to the desired point, and set the required angle
    # -------------------------------------------------------------------------
    my $line3;
    ( $line3, $p{x} ) = $l{CE}->copy( $pt, $speed );
    $line3->rotateTo($angle);

    # -------------------------------------------------------------------------
    # Clean up
    # -------------------------------------------------------------------------
    foreach my $type ( \%l, \%p, \%c ) {
        foreach my $o ( keys %$type ) {
            $type->{$o}->remove;
        }
    }

    # -------------------------------------------------------------------------
    # return line object
    # -------------------------------------------------------------------------
    return $line3;

}

# ============================================================================
# fourth_proportional
# ============================================================================

=head2 fourth_proportional ( $line1, $line2, $line3, $point, $angle [$speed, [$dir]])

Given three lines draw a fourth such that the ratio of $line1 to $line2
is the same as $line3 to the returned line

Proposition 12

B<Parameters>

=over 

=item * First line object

=item * Second line object

=item * Third line object (First:Second = Third:?)

=item * Point where the line will be drawn

=item * Angle at which to draw the line

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * New line object

=back

=cut

# -----------------------------------------------------------------------------
sub fourth_proportional {
    my ( %p, %l, %c );
    my $class = shift;

    Validate::Inputs( \@_, [qw(Line Line Line Point float)], [qw(speed)] );
    my $line1 = shift;
    my $line2 = shift;
    my $line3 = shift;
    my $pt    = shift;
    my $angle = shift;
    my $speed = shift || 1;
    my $cn    = $line1->canvas;
    my @D     = ( 50, 350 );

    # -------------------------------------------------------------------------
    # Draw two arbitrary lines, set out at any angle at D
    # -------------------------------------------------------------------------
    $p{D} = Point->new( $cn, @D );
    $l{d1} = Line->new( $cn, @D, $D[0] + 900, $D[1] );
    $l{d2} = Line->new( $cn, @D, $D[0] + 900, 580 );

    # -------------------------------------------------------------------------
    # Define points such that DG is equal to line1,
    # GE is equal to line2, and DH is equal to line3
    # -------------------------------------------------------------------------
    ( $l{DG}, $p{G} ) = $line1->copy_to_line( $p{D}, $l{d2}, -1 );
    ( $l{EG}, $p{E} ) = $line2->copy_to_line( $p{G}, $l{d2}, -1 );
    ( $l{DH}, $p{H} ) = $line3->copy_to_line( $p{D}, $l{d1}, -1 );

    # -------------------------------------------------------------------------
    # Draw line GH, and draw another line EF, parallel to GH
    # -------------------------------------------------------------------------
    $l{GH} = Line->join( $p{G}, $p{H} );
    $l{EFx} = $l{GH}->parallel( $p{E}, -1 )->prepend(200);
    my @p = $l{EFx}->intersect( $l{d1} );
    $p{F} = Point->new( $cn, @p );

    # -------------------------------------------------------------------------
    # HF is the fourth proportional ... copy it to where the user wants it
    # -------------------------------------------------------------------------
    $l{HF} = Line->join( $p{H}, $p{F} );
    my $line4;
    ( $line4, $p{x} ) = $l{HF}->copy( $pt, $speed );
    $line4->rotateTo($angle);

    # -------------------------------------------------------------------------
    # Clean up
    # -------------------------------------------------------------------------
    foreach my $type ( \%l, \%p, \%c ) {
        foreach my $o ( keys %$type ) {
            $type->{$o}->remove;
        }
    }

    # -------------------------------------------------------------------------
    # return line object
    # -------------------------------------------------------------------------
    return $line4;
}

# ============================================================================
# mean_proportional
# ============================================================================

=head2 fourth_proportional ( $line1, $line2, $point, $angle [$speed, [$dir]])

Given two lines draw a third ($line3) such that the ratio of $line1 to $line3
is the same as $line3 to $line2

Proposition 13

B<Parameters>

=over 

=item * First line object

=item * Second line object

=item * Point where the line will be drawn

=item * Angle at which to draw the line

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * New line object

=back

=cut

# -----------------------------------------------------------------------------
sub mean_proportional {
    my ( %p, %l, %c, %a );
    my $class = shift;

    Validate::Inputs( \@_, [qw(Line Line Point float)], [qw(speed)] );
    my $line1 = shift;
    my $line2 = shift;
    my $pt    = shift;
    my $angle = shift;
    my $speed = shift || 1;
    my $cn    = $line1->canvas;
    my @D     = ( 50, 350 );

  # -------------------------------------------------------------------------
  # Position the two lines so that they form a straight line (redraw both lines)
  # -------------------------------------------------------------------------
    my @A = ( 50, 450 );
    $p{A} = Point->new( $cn, @A );
    ( $l{A}, $p{B} ) = $line1->copy( $p{A}, $speed );
    $l{A}->rotateTo( 0, $speed );
    $p{B}->remove;
    $p{B} = Point->new( $cn, $l{A}->end );
    ( $l{B}, $p{C} ) = $line2->copy( $p{B}, $speed );
    $l{B}->rotateTo( 0, $speed );
    $p{C}->remove;

    # -------------------------------------------------------------------------
    # Draw a semi-circle on line AC
    # -------------------------------------------------------------------------
    my @C = $l{B}->end;
    $a{D} =
      Arc->new( $cn, ( $l{A}->length + $l{B}->length ) / 2, @C, @A, $speed );

    # -------------------------------------------------------------------------
    # Draw a line perpendicular to AC, from point B, intersecting ".
    # the semi-circle at point D
    # -------------------------------------------------------------------------
    $l{BDx} = $l{A}->perpendicular( $p{B}, 1, "negative", $speed );
    my @p   = $a{D}->intersect( $l{BDx} );
    my $inc = 0;
    while ( ( not @p ) && ( $inc < 20 ) ) {
        $inc++;
        $l{BDx}->extend(100);
        $l{BDx}->prepend(100);
        @p = $a{D}->intersect( $l{BDx} );
    }
    $p{D} = Point->new( $cn, @p );
    $l{BD} = Line->join( $p{B}, $p{D}, $speed );
    $l{BDx}->remove;

  # -------------------------------------------------------------------------
  # BD is the mean proportional to AB, BC ... copy it to where the user wants it
  # -------------------------------------------------------------------------
    my $line3;
    ( $line3, $p{x} ) = $l{BD}->copy( $pt, $speed );
    $line3->rotateTo($angle);

    # -------------------------------------------------------------------------
    # Clean up
    # -------------------------------------------------------------------------
    foreach my $type ( \%l, \%p, \%c, \%a ) {
        foreach my $o ( keys %$type ) {
            $type->{$o}->remove;
        }
    }

    # -------------------------------------------------------------------------
    # return line object
    # -------------------------------------------------------------------------
    return $line3;
}

# ============================================================================
# copy_to_circle
# ============================================================================

=head2 perpendicular ( $circle, $point, [$speed, [$dir]])

Finds a point on the line such that the whole of the line, multiplied by the
second fragment is equal to the first fragment squared.

B<Parameters>

=over 

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=item * C<$dir> - Positive or negative (which end of the line will 
be the smaller part) 

=back

B<Returns>

=over

=item * New point object

=back

=cut

# -----------------------------------------------------------------------------
sub copy_to_circle {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Circle)], [qw(Point speed dir)] );
    my $c     = shift;
    my $p     = shift;
    my $speed = shift || 1;
    my $dir   = shift || "positive";
    my $cn    = $self->canvas;

    my @centre = $c->centre();

    # if point not on the circle, choose random point on circle
    my $newpoint = 0;
    my $vl = VirtualLine->new( @centre, $p->coords );
    if ( abs( $vl->length - $c->radius ) > 1 ) {
        $p        = $c->point(0);
        $newpoint = 1;
    }

    # draw diameter of circle BC
    my $lBC =
      Line->new( $cn, $p->coords, @centre, $speed )->extend( $c->radius );

    # if original line is too big, abort
    if ( $lBC->length - $self->length < 1 ) {
        Validate::complain("your input line does not fit in the circle");
        $lBC->remove;
        $p->remove if $newpoint;
        return;
    }

    # if original line equals the diameter, we are done, cleanup and return
    if ( abs( $lBC->length - $self->length ) < 1 ) {
        $p->remove if $newpoint;
        return $lBC;
    }

    # construct a line CE such that it is equal to the original line
    my ( $lDE, $pE ) = $self->copy_to_line( $p, $lBC, $speed );

    # draw another circle, C centre, radius CE
    my $cF = Circle->new( $cn, $p->coords, $pE->coords, $speed );

    # find intersection points between two circles
    my @p = $cF->intersect($c);
    my $pA;
    if ( $dir eq "positive" ) {
        $pA = Point->new( $cn, @p[ 0, 1 ] );
    }
    else {
        $pA = Point->new( $cn, @p[ 2, 3 ] );
    }

    # draw line AC, it is equal to the original line
    my $lAC = Line->join( $pA, $p, $speed );

    # clean up
    $p->remove if $newpoint;
    $lBC->remove;
    $lDE->remove;
    $pE->remove;
    $cF->remove;
    $pA->remove;
    $lAC->normal;

    # return
    return $lAC;
}

# ============================================================================
# square
# ============================================================================

=head2 square ( [$speed, [$dir]])

Draws three more lines.  
Note that it does not return the "square" object.  
If you want that object, use the Square class.

B<Parameters>

=over 

=item * C<$speed> - [OPTIONAL] how fast to draw the animation  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=item * C<$dir> - Positive or negative 

=back

B<Returns>

=over

=item * 3 line objects used to create the square

=back

=cut

# -----------------------------------------------------------------------------
sub square {
    my $l2 = shift;
    Validate::Inputs( \@_, [], [qw(speed dir)] );
    my $speed = shift || 1;
    my $dir   = shift || "positive";
    my $cn    = $l2->canvas;

    my $p2 = Point->new( $cn, $l2->start );
    my $p3 = Point->new( $cn, $l2->end );
    if ( $dir eq "negative" ) {
        my $tmp = $p2;
        $p2 = $p3;
        $p3 = $tmp;
    }

    # draw line perpendicular to line 2, at point2
    my $l11 = $l2->perpendicular($p2);

    # define 1st point at correct distance, and make line 1
    my $c = Circle->new( $cn, $p2->coords(), $p3->coords, $speed );
    my $p1 = Point->new( $cn, $c->intersect($l11) );
    ( my $l1, $l11 ) = $l11->split($p1);
    $l11->remove();
    $c->remove();

    # draw line perpendicular to line 2, at point3
    my $l33 = $l2->perpendicular( $p3, $speed, 'negative' );

    # define 4th point at correct distance, and make line 3
    $c = Circle->new( $cn, $p3->coords(), $p2->coords, $speed );
    my $p4 = Point->new( $cn, $c->intersect($l33) );
    ( my $tl3, $l33 ) = $l33->split($p4);
    $l33->remove();
    $c->remove();

    # draw the correct 3rd and 4th line, and cleanup
    my $l3 = Line->new( $cn, $p3->coords(), $p4->coords, $speed );
    my $l4 = Line->new( $cn, $p4->coords(), $p1->coords, $speed );
    $tl3->remove();
    $l3->normal();
    $l4->normal();

    $p1->remove;
    $p2->remove;
    $p3->remove;
    $p4->remove;

    return ( $l3, $l4, $l1 );
}

# ============================================================================
# show_parts
# ============================================================================

=head2 show_parts ($number, [$distance], [$edge], [$colour] )

Draw "parts" (fractions) of a line next to this one

B<Parameters>

=over 

=item * C<$number> - number of parts to divide the line into

=item * C<$offset> distance between this line and the new lines - 
[OPTIONAL] default 6px

=item * C<$edge> - which edge to draw on (left/right, assuming line is drawn from
top to bottom) (top/bottom, assuming line is drawn right to left)
 [OPTIONAL] default = right 

=item * C<$colour> - colour of "part" lines [OPTIONAL] default = grey 

=back

B<Returns>

=over

=item * An array ref of line objects

=back

=cut

# ----------------------------------------------------------------------------
sub parts {my $self = shift; return $self->show_parts(@_);}
sub show_parts {
    my $self = shift;
    Validate::Inputs( \@_, [qw(number)], [qw(number text text)] );
    my $num    = shift;
    my $offset = shift || 6;
    my $edge   = shift || 'right';
    my $colour = shift || 'grey';
    my $cn     = $self->canvas;

    # can only divide the number if it is positive
    if ( $num < 0 ) {
        print "Line:show_parts: you idjit, num ($num) is less than zero\n";
        return;
    }
    if ($num == 0) {
        print "Line:show_parts: you idjit, num ($num) is equal to zero\n";
        return;
    }

    # get line endpoints
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();

    # length of "part"
    my $r = $self->length / $num;

    # line angles and offset angles
    my $phi   = deg2rad( $self->angle() );
    my $theta = deg2rad( $self->angle() + 90 );

    # need to know if we are adding/subtracting, etc
    my $sign = -1;
    if ( $edge eq "left" || $edge eq "top" ) {
        $sign = +1;
    }

    my $ysign = -1*sin($phi);
    my $xsign = -1*cos($phi);

    if ( $x2 > $x1 ) {
        $xsign = -$xsign;
    }
    if ( $y2 > $y1 ) {
        $ysign = -$ysign;
    }
    
    # adjust shift parameter if necessary
    my $shift = 5;
    if ($r < 30) {
        $shift = 3;
    }
    if ($r < 20) {
        $shift = 2;
    }

    # loop over each "part"
    my @line_parts = ();
    $num = int( $num + .5 );

    foreach my $i ( 1 .. $num ) {

        # my endpoints for the start and stop line - before shifting
        my @cs = $self->_coords_dist( $x1, $y1, $r * ( $i - 1 ) );
        my @ce = $self->_coords_dist( $x1, $y1, $r * $i );

        # shift line appropriately
        my @ends = (
               -$sign * $offset * cos($theta) + $xsign * $shift * cos($phi) + $cs[0],
               -$sign * $offset * sin($theta) + $ysign * $shift * sin($phi) + $cs[1],
               -$sign * $offset * cos($theta) - $xsign * $shift * cos($phi) + $ce[0],
               -$sign * $offset * sin($theta) - $ysign * $shift * sin($phi) + $ce[1]
        );
        my $new_colour = Colour->darken(5,$colour);
        push @line_parts, Line->new( $cn, @ends )->colour($new_colour);
    }

    return \@line_parts;
}

##############################################################################
package Arrow;
#############################################################################
use Geometry::Validate;
our @ISA = qw(CanvasLine);

# ============================================================================
# new
# ============================================================================

=head2 new ($canvas, $x1,$y1, $x2,$y2, $arrow)

Create and draw an arrow 

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$x1,$y1> - starting coordinates for your line

=item * C<$x2,$y2> - ending coordinates for your line

=item * $arrow "none", "first", "last", "both" (default: "none")

=back

B<Returns>

=over

=item * Arrow object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;

    my $cn    = shift;
    my $x1    = shift;
    my $y1    = shift;
    my $x2    = shift;
    my $y2    = shift;
    my $arrow = shift || "none";
    return
      unless Validate::Inputs( [ $cn, $x1, $y1, $x2, $y2 ],
                               [qw(canvas coord coord coord coord)] );

    # define object
    my $self = {
                 -x1    => $x1,
                 -y1    => $y1,
                 -x2    => $x2,
                 -y2    => $y2,
                 -cn    => $cn,
                 -fast  => -1,
                 -dash  => 0,
                 -arrow => $arrow,
    };
    bless $self, $class;
    my @pts;

    # draw the line
    $self->_define_line_info();
    $self->draw(-1);

    return $self;
}

##############################################################################
package CanvasLine;
#############################################################################
use Math::Trig qw(rad2deg deg2rad :radial);
use Geometry::Validate;
our @ISA = qw(Shape VirtualLine);

# ============================================================================
# new
# ============================================================================

=head2 new ($canvas, $x1,$y1, $x2,$y2, [$speed, [$dash] ])

Create and draw a line

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$x1,$y1> - starting coordinates for your line

=item * C<$x2,$y2> - ending coordinates for your line

=item * C<speed> - [OPTIONAL] how fast to draw the line  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=item * C<dash> - [OPTIONAL] draw dashed line if true


=back

B<Returns>

=over

=item * Line object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;
    return
      unless Validate::Inputs( \@_, [qw(canvas coord coord coord coord)],
                               [qw(speed dash)] );
    my $cn   = shift;
    my $x1   = shift;
    my $y1   = shift;
    my $x2   = shift;
    my $y2   = shift;
    my $fast = shift || 1;
    my $dash = shift || 0;

    # define object
    my $self = {
                 -x1   => $x1,
                 -y1   => $y1,
                 -x2   => $x2,
                 -y2   => $y2,
                 -cn   => $cn,
                 -fast => $fast,
                 -dash => $dash,
    };
    bless $self, $class;
    my @pts;

    # draw the line
    $self->_define_line_info();
    $self->draw($fast) if $fast < 100;

    return $self;
}

# ============================================================================
# draw
# ============================================================================

=head2 draw ( [$speed] )

Draw an already defined line

B<Parameters>

=over 

=item * C<$speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Line object

=back

=cut

# -----------------------------------------------------------------------------
sub draw {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(speed)] );
    my $speed = shift || 1;
    my $dash  = $self->{-dash};
    my $arrow = $self->{-arrow} || "none";

    # get info from object
    $self->_define_line_info();
    my $cn = $self->canvas;
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();
    my $fast = $speed || $self->{-fast} || 1;
    my @cs = $self->normal_colour();

    # create canvas objects
    foreach my $w (@Shape::shape_sizes) {
        my $o;

        unless ($dash) {
            $o = $cn->createLine(
                                  $x1, $y1, $x1, $y1,
                                  -width => $w,
                                  -fill  => $cs[ 4 - $w ],
                                  -arrow => $arrow,
            );
        }
        else {
            $o = $cn->createLine(
                                  $x1, $y1, $x1, $y1,
                                  -width => $w,
                                  -fill  => $cs[ 4 - $w ],
                                  -dash  => [ 6, 6 ],
                                  -arrow => $arrow,
            );
        }
        push @{ $self->{-objects} }, $o;
    }

    # if drawing fast, then grey out the line
    $self->grey() if $fast > 1;

    # ------------------------------------------------------------------------
    # animate the drawing of the line
    # ------------------------------------------------------------------------
    my $p = Point->new( $cn, $x1, $y1 );
    if ($Shape::NoAnimation) {
        _animate( $self, $p, 1, $self->length() );
    }
    else {
        $self->animate( sub { _animate( $self, $p, 1, @_ ) },
                        $fast, $self->length() );
    }
    $p->remove();

    # ------------------------------------------------------------------------
    # bind notice method to mouse click
    # ------------------------------------------------------------------------
    $self->_bind_notice();

    # ------------------------------------------------------------------------
    # write the label
    # ------------------------------------------------------------------------
    $self->label( $self->label_is );

    $cn->update();
    return $self;
}

# ============================================================================
# dash
# ============================================================================

=head2 dash

Redraw the line as a dashed line

B<Returns>

=over

=item * Line object

=back

=cut

# ----------------------------------------------------------------------------
sub dash {
    my $self = shift;
    $self->remove;
    $self->{-dash} = 1;
    $self->draw(-1);
}

# ============================================================================
# undash
# ============================================================================

=head2 undash

Redraw the line as single line (no dash)

B<Returns>

=over

=item * Line object

=back

=cut

# ----------------------------------------------------------------------------
sub undash {
    my $self = shift;
    $self->remove;
    $self->{-dash} = 0;
    $self->draw(-1);
}

# ============================================================================
# notice
# ============================================================================

=head2 notice ()

Makes the object go bold, and glow red, temporarily

=cut

# -----------------------------------------------------------------------------
sub notice {
    my $self  = shift;
    my $cn    = $self->canvas;
    my $obj   = @{ $self->{-objects} }[-1];
    my $width = $cn->itemcget( $obj, -width );
    my $sub =
      sub { my $i = shift; $cn->itemconfigure( $obj, -width => $i + $width ) };
    $self->SUPER::notice($sub);
}

# ============================================================================
# grey
# ============================================================================

=head2 grey() / green() / red() / normal()

If object colour is changed to grey, then the object labels will be hidden.

If object colour is changed from grey to any other colour, the object labels
will be redrawn.

Change the colour of the object

B<Returns>

=over

=item * the line object

=back

=cut

sub colour {
    my $self = shift;
    my $colour = shift || "normal";
    $self->_set_colour( "-fill", $colour );
    if ( $self->{-tick_marks} && ref( $self->{-tick_marks} ) ) {
        foreach my $tick_line ( @{ $self->{-tick_marks} } ) {
            $tick_line->colour($colour);
        }
    }
    return $self;
}

sub grey {
    my $self = shift;
    return $self->colour("grey");
}

sub red {
    my $self = shift;
    return $self->colour("red");
}

sub green {
    my $self = shift;
    return $self->colour("green");
}

sub blue {
    my $self = shift;
    return $self->colour("blue");
}

sub normal {
    my $self = shift;
    return $self->colour("normal");
}

# ============================================================================
# animate the drawing of the line
# ============================================================================
sub _animate {
    my $self = shift;
    my $p    = shift;
    my $dir  = shift;
    my $i    = shift;
    my $cn   = $self->canvas;

    my ( $x1, $y1 ) = $self->start();
    my ( $x2, $y2 ) = $self->end();
    my ( $x,  $y )  = $self->_coords_dist( $self->start, $i * $dir );

    $p->move_to( $x, $y );
    foreach my $l ( @{ $self->{-objects} } ) {
        $cn->coords( $l, $x1, $y1, $x,  $y )  if $dir > 0;
        $cn->coords( $l, $x,  $y,  $x2, $y2 ) if $dir < 0;
    }
}

# ============================================================================
# remove
# ============================================================================

=head2 remove ()

Removes the item from the canvas

=cut

sub remove {
    my $self = shift;
    if ( $self->{-tick_marks} ) {
        foreach my $tick ( @{ $self->{-tick_marks} } ) {
            $tick->remove;
        }
    }
    $self->SUPER::remove();
}

##############################################################################
package VirtualLine;
#############################################################################
use Math::Trig qw(rad2deg deg2rad :radial);
use Geometry::Validate;

=head1 VirtualLine Methods

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ( $x1,$y1, $x2,$y2 )

Create a line

B<Parameters>

=over 

=item * C<$x1,$y1> - starting coordinates for your line

=item * C<$x2,$y2> - ending coordinates for your line

=back

B<Returns>

=over

=item * VirtualLine object

=back

=cut

# ----------------------------------------------------------------------------
sub new {
    my $class = shift;
    return unless Validate::Inputs( \@_, [qw(coord coord coord coord)] );
    my $x1 = shift;
    my $y1 = shift;
    my $x2 = shift;
    my $y2 = shift;

    my $self = {
                 -x1 => $x1,
                 -y1 => $y1,
                 -x2 => $x2,
                 -y2 => $y2,
    };
    bless $self, $class;

    $self->_define_line_info();

    return $self;
}

# ============================================================================
# join
# ============================================================================

=head2 join ($p1,$p2)

Create a virtual line

B<Parameters>

=over 

=item * C<$p1> - start Point (object)

=item * C<$p2> - end Point (object)

=back

B<Returns>

=over

=item * VirtualLine object

=back

=cut

# -----------------------------------------------------------------------------
sub join {
    my $class = shift;
    return unless Validate::Inputs( \@_, [qw(Point Point)] );
    my $p1 = shift;
    my $p2 = shift;

    # define object
    return VirtualLine->new( $p1->coords, $p2->coords );
}

# ============================================================================
# intersect
# ============================================================================

=head2 intersect ( $line )

Finds intersection point between self and specified line.

The intersection point is calculated as if both lines were infinite

B<Parameters>

=over 

=item * C<$line> - Line, (or VirtualLine) object

=back

B<Returns>

=over

=item * coordinates of intersection point(s) 

Nothing is returned if the two objects do not intersect!

=back

=cut

# ----------------------------------------------------------------------------
sub intersect {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Line)] );
    my $l2 = shift;

    # define the four points of the two lines
    my ( $x11, $y11, $x12, $y12 ) = $self->endpoints();
    my ( $x21, $y21, $x22, $y22 ) = $l2->endpoints();

    # slopes
    my $m1 = $self->slope();
    my $m2 = $l2->slope();

    # if lines are parallel, then they don't intersect
    if ( abs( $m1 - $m2 ) < .01 ) {
        return;
    }

    # find the intersection point
    my ( $x, $y );
    if ( abs($m1) > 1e10 ) {
        $x = $x11;
        $y = $m2 * ( $x - $x21 ) + $y21;
    }
    elsif ( abs($m2) > 1e10 ) {
        $x = $x21;
        $y = $m1 * ( $x - $x11 ) + $y11;
    }
    else {
        $x = ( $y22 - $y11 + $m1 * $x11 - $m2 * $x22 ) / ( $m1 - $m2 );
        $y = $m1 * ( $x - $x11 ) + $y11;
    }

    return $x, $y;
}

# ============================================================================
# endpoints
# ============================================================================

=head2 endpoints ( )

B<Returns>

=over

=item * coordinates of the endpoints of the line object

=back

=cut

# ----------------------------------------------------------------------------
sub endpoints {
    my $self = shift;
    Validate::Inputs( \@_, [], [] );
    return $self->{-x1}, $self->{-y1}, $self->{-x2}, $self->{-y2};
}

# ============================================================================
# coords
# ============================================================================

=head2 coords ( )

Pseudonym for endpoints

=cut

# ----------------------------------------------------------------------------
sub coords {
    my $self = shift;
    Validate::Inputs( \@_, [], [] );
    return $self->endpoints();
}

# ============================================================================
# int_coords
# ============================================================================

=head2 int_coords ( )

Endpoints, rounded down to the nearest integer

=cut

# ----------------------------------------------------------------------------
sub int_coords {
    my $self = shift;
    Validate::Inputs( \@_, [], [] );
    my @e = map { int($_) } $self->endpoints;
    return @e;
}

# ============================================================================
# end
# ============================================================================

=head2 end ()

B<Returns>

=over

=item * end coordinates of the line object

=back

=cut

# ----------------------------------------------------------------------------
sub end {
    my $self = shift;
    Validate::Inputs( \@_, [], [] );
    return $self->{-x2}, $self->{-y2};
}

# ============================================================================
# start
# ============================================================================

=head2 start ( )

B<Returns>

=over

=item * start coordinates of the line object

=back

=cut

# ----------------------------------------------------------------------------
sub start {
    my $self = shift;
    Validate::Inputs( \@_, [], [] );
    return $self->{-x1}, $self->{-y1};
}

# ============================================================================
# slope
# ============================================================================

=head2 slope ()

B<Returns>

=over 

=item * slope of the line (maximum/minum = +/- 1e99)

=back

=cut

# ----------------------------------------------------------------------------
sub slope {
    my $self = shift;
    return $self->{-m};
}

# ============================================================================
# angle
# ============================================================================

=head2 angle ()

Returns the angle of the line.

Remember that the y-axis goes from top to bottom, so a slope of 1
will give you an angle of -45.

B<Returns>

=over 

=item * angle of line

=back

=cut

# ----------------------------------------------------------------------------
sub angle {
    my $self = shift;
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();
    my ( $r, $theta, $phi ) = cartesian_to_spherical( $x2 - $x1, $y1 - $y2, 0 );
    return rad2deg($theta);
}

# ============================================================================
# length
# ============================================================================

=head2 length ()

B<Returns>

=over 

=item * length of line

=back

=cut

# ----------------------------------------------------------------------------
sub length {
    my $self = shift;
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();
    my ( $r, $theta, $phi ) = cartesian_to_spherical( $x2 - $x1, $y1 - $y2, 0 );
    return $r;
}

# ============================================================================
# extend
# ============================================================================

=head2 extend ( $amount )

Extend the line by the amount specified

B<Parameters>

=over 

=item * C<$amount> - how much to add to the line

=back

B<Returns>

=over

=item * VirtualLine object

=back

=cut

# ----------------------------------------------------------------------------
sub extend {
    my $self = shift;
    my $r    = shift;

    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();
    my ( $x, $y ) = $self->_coords_dist( $x1, $y1, $r + $self->length() );
    $self->{-x2} = $x;
    $self->{-y2} = $y;
    $self->_define_line_info;

    return $self;

}

# ============================================================================
# prepend
# ============================================================================

=head2 prepend ( $amount )

Prepend the line by the amount specified

B<Parameters>

=over 

=item * C<$amount> - how much to add to the line

=back

B<Returns>

=over

=item * VirtualLine object

=back

=cut

# ----------------------------------------------------------------------------
sub prepend {
    my $self = shift;
    my $r    = shift;

    my $l = $self;

    my ( $x1, $y1, $x2, $y2 ) = $l->endpoints();
    my ( $x, $y ) = $l->_coords_dist( $x1, $y1, -$r );
    $l->{-x1} = $x;
    $l->{-y1} = $y;
    $self->_define_line_info;

    return $l;
}

# ============================================================================
# split
# ============================================================================

=head2 split ( $p1, $p ... )

Takes the given line, and splits at the specified points. 

Note that the points do not actually have to be on the line.

B<Parameters>

=over 

=item * C<$p1> - Point object defining where to split the line

=back

B<Returns>

A series of lines connected at the specified points 

=over

=item * All new VirtualLine objects (the original is removed)

=back

=cut

# ----------------------------------------------------------------------------
sub split {
    my $self = shift;
    my @val  = ('Point') x scalar(@_);
    Validate::Inputs( \@_, \@val );

    my @pts = @_;
    my @lns;
    my @coords;

    # what points to create new lines
    push @coords, $self->start();
    foreach my $pt (@pts) {
        push @coords, $pt->coords();
    }
    push @coords, $self->end();

    # make new lines
    foreach my $i ( 0 .. scalar(@pts) ) {
        my $off = $i * 2;
        push @lns, VirtualLine->new( @coords[ $off .. $off + 3 ], -1 );
    }
    return @lns;
}

# ============================================================================
# rotateTo
# ============================================================================

=head2 rotateTo ( $angle)

Rotate the line to the angle specified (rotates around the starting pt)

B<Parameters>

=over 

=item * C<$angle> - Final angle position of the line

=back

=cut

# ----------------------------------------------------------------------------
sub rotateTo {
    my $self = shift;
    Validate::Inputs( \@_, [qw(angle)], [qw(speed)] );
    my $a2 = shift;

    # get info from object
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();
    my $a1  = $self->angle();
    my $r   = $self->length();
    my $phi = deg2rad(90);

    # define the final location
    my ( $x, $y, $z ) = spherical_to_cartesian( $r, deg2rad($a2), $phi );
    $self->{-x2} = $x2 = $x1 + $x;
    $self->{-y2} = $y2 = $y1 - $y;
    $self->_define_line_info;

}

# ============================================================================
# point
# ============================================================================

=head2 point ($length)

Calculates the x,y coordinates of the point, distance $length from the
beginning of the line

B<Parameters>

=over 

=item * C<$length> - length from beginning of line

=back

B<Returns>

=over 

=item * C<$x,$y> coordinates

=back

=cut

# ----------------------------------------------------------------------------
sub point {
    my $self = shift;
    Validate::Inputs( \@_, [qw(number)] );
    my $r = shift;
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();
    return $self->_coords_dist( $x1, $y1, $r );
}

# ============================================================================
# length_from_end
# ============================================================================

=head2 length_from_end ($point)

B<Parameters>

=over 

=item * C<$point> - Point object

=back

B<Returns>

=over 

=item * length from end of line to point

=back

=cut

# ----------------------------------------------------------------------------
sub length_from_end {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point)] );
    my $p = shift;
    my ( $x1, $y1 ) = $self->end();
    my ( $x2, $y2 ) = $p->coords();
    my ( $r, $theta, $phi ) = cartesian_to_spherical( $x2 - $x1, $y1 - $y2, 0 );
    return $r;
}

# ============================================================================
# length_from_start
# ============================================================================

=head2 length_from_start ($point)

B<Parameters>

=over 

=item * C<$point> - Point object

=back

B<Returns>

=over 

=item * length from start of line to point

=back

=cut

# ----------------------------------------------------------------------------
sub length_from_start {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point)] );
    my $p = shift;
    my ( $x1, $y1 ) = $self->start();
    my ( $x2, $y2 ) = $p->coords();
    my ( $r, $theta, $phi ) = cartesian_to_spherical( $x2 - $x1, $y1 - $y2, 0 );
    return $r;
}

# ============================================================================
# give coordinates a distance $r from $xs, $ys
# ============================================================================
sub _coords_dist {
    my $self = shift;
    my $xs   = shift;
    my $ys   = shift;
    my $r    = shift;

    my ( $p3x, $p3y ) = $self->end();
    my $deltax = $p3x - $xs;
    my $deltay = $p3y - $ys;
    return $xs, $ys unless $deltax || $deltay;

    # get the correct length of line (x-x1) = r/d * deltax
    my $x = $r / sqrt( $deltay**2 + $deltax**2 ) * ($deltax) + $xs;
    my $y = $r / sqrt( $deltay**2 + $deltax**2 ) * ($deltay) + $ys;

    return $x, $y;
}

# ============================================================================
# calculate the slope of line, length, etc.
# ============================================================================
sub _define_line_info {
    my $self = shift;
    my ( $x1, $y1, $x2, $y2 ) = $self->endpoints();

    my $d = $self->length();
    my $sign = $self->{-sign} || 1;
    $sign = -1 if $x2 < $x1;
    $sign = 1  if $x2 > $x1;
    $self->{-sign} = $sign;

    my $m;

    if    ( abs( $x2 - $x1 ) < 0.1 && $y2 > $y1 )  { $m = 1e99 }
    elsif ( abs( $x2 - $x1 ) < 0.1 && $y2 <= $y1 ) { $m = -1e99 }
    else { $m = ( $y2 - $y1 ) / ( $x2 - $x1 ); }
    $self->{-m} = $m;

    return;
}

sub red    { return }
sub green  { return }
sub normal { return }
sub grey   { return }
sub notice { return }

=head1 AUTHOR

Sandy Bultena

=head1 COPYRIGHT

This module is copyright (c) 2014 Sandy Bultena. All rights reserved.

This library is free software; you may redistribute and/or modify it under 
the terms of either the GNU General Public License 
or the Perl Artistic License, as specified in the Perl 5.10.0 README file.

=cut

1;
