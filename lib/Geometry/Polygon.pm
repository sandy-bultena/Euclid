#!/usr/bin/perl
package Polygon;
use strict;
use warnings;
use Geometry::Point;
use Geometry::Line;
use Geometry::Circle;
use Geometry::Angle;
use Geometry::CalculatePoints;
use Geometry::Validate;
use Math::Trig qw(rad2deg deg2rad :radial);

our @ISA = ("Shape");

=head1 NAME

Polygon - create and manipulate polygon objects

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;
    
    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();
    
    # create a polygon
    my @A = ( 150, 160, 300, 185, 250, 310, 90, 235 );
    $s{A} = Polygon->new( $cn, 4, @A)->fill("#ffffee");
    $s{A}->set_labels(qw(a bottom b right c top d left));
    $s{A}->set_points(qw(C left D right E topright B left));        
    $s{A}->set_angles(qw(A B C D));
    
    # highlight 3rd line of polygon
    $s{A}->l(3)->notice;    

=head2 Methods Summary

Creating/drawing

  new       ($canvas, $sides, $x1,$y1, ... $xn,$yn)
  join      ($sides, $p1, $p2, ... )
  assemble  ($sides, -lines=>[$line_obj1, ... $line_objn])

Additional Properties

  set_points ($text1,$pos1, $text2,$pos2... )
  set_labels ($text1,$pos1, $text2,$pos2 ... )
  set_angles ($text1,$text2, ... $size1,$size2 ... )

Access components of the Polygon
  
  lines  ( )
  points ( ) 
  angles ( )
  a      ( $i )
  l      ( $i )
  p      ( $i )
  coords ( )

Drawing (or redrawing)

  draw         ( [$speed] )
  points_draw  ( )
  lines_draw   ( )
  angles_draw  ( )
  move         ( $x, $y, [$inc, [$speed]] )
  rotate       ( $x, $y, $angle, [$inc, [$speed]] )
  copy_to_rectangle ($point [$speed])  

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


=head1 Line METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ($canvas, $sides, $x1,$y1, ... $xn,$yn, [$speed])

Create and draw a point

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$sides> - number of sides of your polygon

=item * C<$x1,$y1> - first corner of your polygon

=item * C<$x3,$y3> - third corner of your parallelogram

=item * C<$xn,$yn> - last corner of your polygon

=item * C<speed> - [OPTIONAL] how fast to draw the objects  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Options>

=over 

=item * C<-points> => [I<label1, where1, label2, where2 ...>]

=item * C<-labels> => [I<label1, where1, label2, where2 ...>]

=item * C<-angles> => [I<label1, label2, ...>];

=item * C<-anglesizes> => [I<size1, size2, ...>];

=item * C<-fill> => I<colour>

=back

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------

sub new {
    my $class = shift;

    # -------------------------------------------------------------------------
    # inputs
    # -------------------------------------------------------------------------

    # canvas and number of sides
    my @initial = splice( @_, 0, 2 );
    return unless Validate::Inputs( \@initial, [qw(canvas number)] );
    my $cn    = shift @initial;
    my $sides = shift @initial;

    # rest of inputs
    return
      unless Validate::Inputs(
                               \@_,
                               [ (qw(coord)) x ( 2 * $sides ) ],
                               [qw(speed)],
                               {
                                  -points     => 'array',
                                  -labels     => 'array',
                                  -angles     => 'array',
                                  -fill       => 'text',
                                  -anglesizes => 'array'
                               }
                             );
    my @coords = splice( @_, 0, 2 * $sides );
    my $speed = shift || 1;
    my %args = (@_);
    push @coords, $coords[0], $coords[1];

    # -------------------------------------------------------------------------
    # define the basic polygon
    # -------------------------------------------------------------------------

    # define points/lines/angles arrays
    my $points = [ (undef) x $sides ];
    my $lines  = [ (undef) x $sides ];
    my $angles = [ (undef) x $sides ];

    # save the info
    my $fill = $args{-fill};
    my $self = {
                 -args   => \%args,
                 -cn     => $cn,
                 -lines  => $lines,
                 -points => $points,
                 -angles => $angles,
                 -sides  => $sides,
                 -coords => \@coords,
                 -fill   => $fill,
               };

    bless $self, $class;
    _new( $self, $speed );
}

sub _new {
    my $self   = shift;
    my $speed  = shift || 1;
    my $cn     = $self->{-cn};
    my @coords = @{ $self->{-coords} };
    my $points = $self->{-points};
    my $lines  = $self->{-lines};
    my $fill   = $self->{-fill};
    my %args   = %{ $self->{-args} };
    my $sides  = $self->{-sides};
    my @sizes  = ();
    @sizes = @{ $args{-anglesizes} } if $args{-anglesizes};

    # create the polygon
    my $poly = $cn->createPolygon( @coords, -fill => undef, -outline => undef );
    my @bb = $cn->coords($poly);
    if ( @bb && ref( $bb[0] ) && $bb[0]->isa("Tcl::List") ) {
        @bb = $bb[0];
    }
    $cn->lower($poly);
    $self->{-poly} = $poly;
    $self->{-x}    = $bb[0];
    $self->{-y}    = $bb[1];
    $self->{-x1}   = $bb[0];
    $self->{-y1}   = $bb[1];
    $self->{-x2}   = $bb[2];
    $self->{-y2}   = $bb[3];

    # -------------------------------------------------------------------------
    # create all the points and lines
    # -------------------------------------------------------------------------

    # loop through the sides
    foreach my $s ( 1 .. $sides ) {
        my $off = ( $s - 1 ) * 2;

        # point?
        my ( $label, $position ) = @{ $args{-points} }[ $off, $off + 1 ];
        $points->[ $s - 1 ] =
          Point->new( $cn, @coords[ $off, $off + 1 ] )
          ->label( $label, $position );

        # line
        $lines->[ $s - 1 ] =
          Line->new( $cn, @coords[ $off .. $off + 3 ], $speed );

    }

    # set line labels
    $self->set_labels( @{ $args{-labels} } ) if $args{-labels};

    # set angles
    $self->set_angles( @{ $args{-angles} }, @sizes ) if $args{-angles};

    # -------------------------------------------------------------------------
    # colour it, and return
    # -------------------------------------------------------------------------
    $self->fill($fill);

    $self->bind_notice();
    return $self;
}

sub reposition {
    my $self       = shift;
    my @new_coords = @_;
    push @new_coords, $new_coords[0], $new_coords[1];

    $self->remove;
    $self->{-coords} = \@new_coords;
    $self->{-args} = {} unless $self->{-args};
    _new( $self, -1 );
}

sub x {
    my $self = shift;
    my @bb   = $self->{-cn}->coords( $self->{-poly} );
    $self->{-x} = $bb[0];
    return $self->{-x};
}

sub y {
    my $self = shift;
    my @bb   = $self->{-cn}->coords( $self->{-poly} );
    $self->{-y} = $bb[1];
    return $self->{-y};
}

# ============================================================================
# join
# ============================================================================

=head2 join ($sides, $p1,$p2,..., [$speed])

Create and draw a polygon, given Point objects

B<Parameters>

=over 

=item * C<$sides> - number of points

=item * C<$p>I<i> - I<i>th Point (object)

=item * C<speed> - [OPTIONAL] how fast to draw the polygon  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub join {
    my $class = shift;

    # canvas and number of sides
    my $sides = shift @_;
    return unless Validate::Inputs( [$sides], [qw(number)] );
    return
      unless Validate::Inputs( \@_, [ (qw(Point)) x $sides ], [qw(speed)], );
    my @inputs;
    my $cn;
    foreach my $i ( 1 .. $sides ) {
        my $p = shift @_;
        $cn = $p->canvas;
        push @inputs, $p->coords;
    }
    my $speed = shift @_ || 1;
    push @inputs, $speed;

    # define object
    return Polygon->new( $cn, $sides, @inputs );
}

# ============================================================================
# assemble
# ============================================================================

=head2 assemble ($sides, -lines=> [$line_obj1, $line_obj2...])

Given line, point and angle objects, assemble them into a polygon object

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$sides> - number of sides of your polygon

=item * C<-lines> => [line_obj1, ... , line_objI<n>]

=back

B<Options>

=over 

=item * C<-points> => [point_obj1, ... , point_objI<n>]

=item * C<-angles> => [object_obj1, ... , object_objI<n>]

=item * C<-fill> => I<colour>

=back

B<Returns>

If the number of sides of the polygon equals the number of specified lines,
I<and> all the lines connect to one another appropriately, then

=over

=item * Polygon object

=back

else

=over

=item * I<undef>

=back

=cut

# -----------------------------------------------------------------------------
sub assemble {
    my $class = shift;

    # -------------------------------------------------------------------------
    # inputs
    # -------------------------------------------------------------------------
    return
      unless Validate::Inputs(
                               \@_,
                               [qw(canvas number)],
                               [],
                               {
                                  -points => 'array',
                                  -lines  => 'array',
                                  -angles => 'array',
                                  -fill   => 'text',
                               }
                             );
    my $cn     = shift;
    my $sides  = shift;
    my %inputs = @_;

    my $self = bless {}, $class;
    $self->{-sides}  = $sides;
    $self->{-lines}  = $inputs{-lines} || [];
    $self->{-points} = $inputs{-points} || [];
    $self->{-angles} = $inputs{-angles} || [];
    $self->{-cn}     = $cn;
    my $fill = $inputs{-fill};

    unless ( $sides == scalar( @{ $self->{-lines} } ) ) {
        Validate::complain("Need to specify $sides lines");
        return;
    }

    # -------------------------------------------------------------------------
    # figure out the coordinates for the polygon
    # -------------------------------------------------------------------------
    my @coords;
    my %ends;
    my $i = 0;
    my @lines = ( @{ $self->{-lines} }, $self->{-lines}->[0] );

    foreach my $i ( 0 .. $sides - 1 ) {

        # find vertex between lines
        my @pts = Angle->angle_coords( $lines[$i], $lines[ $i + 1 ] );
        push @coords, @pts[ 0, 1 ];

        # lines don't meet in a vertex... BAIL OUT!
        unless ( defined $pts[0] ) {
            Validate::complain("Your polygon lines should touch each other!");
            return;
        }

        # increment counters
        my $s = $i + 1;
        if ( $s == $sides ) { $s = 0 }

        # create new point if one not already defined
        unless ( defined $self->{-points}->[$s] ) {
            $self->{-points}->[$s] = Point->new( $cn, @pts[ 0, 1 ] );
        }
    }

    # -------------------------------------------------------------------------
    # create polygon, and save coordinates
    # -------------------------------------------------------------------------
    my $poly = $cn->createPolygon( @coords, -fill => undef, -outline => undef );
    $self->{-coords} = \@coords;

    $cn->lower($poly);

    # save the info
    $self->{-poly} = $poly;
    $self->fill($fill);

    $self->bind_notice();

    return $self;
}

# ============================================================================
# bind notice
# ============================================================================

=head2 bind_notice ()

Allows the polygon to be 'noticed' by clicking on any of its objects

=cut

sub bind_notice {
    my $self    = shift;
    my @objects = $self->{-poly};
    foreach my $line ( $self->lines ) {
        push @objects, @{ $line->{-objects} };
    }
    $self->{-objects} = \@objects;
    $self->_bind_notice();
    return $self;
}

sub unbind_notice {
    my $self = shift;
    $self->_unbind_notice();
    return $self;
}

sub notice {
    my $self = shift;
    my $cn   = $self->{-cn};

    foreach my $o ( $self->cn_objects ) {
        $cn->raise($o);
    }

    my @lines = $self->lines;
    my $obj   = @{ $lines[0]->{-objects} }[-1];
    my $width = $cn->itemcget( $obj, -width );

    my $sub = sub {
        my $i = shift;
        foreach my $line (@lines) {
            my $obj = @{ $line->{-objects} }[-1];
            $cn->itemconfigure( $obj, -width => $i + $width );
        }
    };

    $self->SUPER::notice($sub);
}

# ============================================================================
# set_points
# ============================================================================

=head2 set_points ($label, $where, $label, $where ...)

Set and draw the labels for each point.

B<Parameters>

=over 

=item * C<$label> - label for the specific point (if C<undef> no label is drawn))

=item * C<$where> - where to draw the label 
( top | bottom | right | left | topright | topleft | bottomright | bottomleft ) 

=back

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub set_points {
    my $self = shift;

    my $sides = $self->{-sides};
    Validate::Inputs( \@_, [], [ ( qw(text where) x $sides ) ] );
    my @labels = @_;

    my $side = 0;
    foreach my $p ( @{ $self->points() } ) {
        next unless $p;
        my $off = $side * 2;
        my ( $label, $position ) = @labels[ $off, $off + 1 ];
        $p->label( $label, $position ) if $label;
        $side++;
    }
    return $self;
}

# ============================================================================
# set_labels
# ============================================================================

=head2 set_labels ($label, $where, $label, $where ...)

Set and draw the labels for each line.

B<Parameters>

=over 

=item * C<$label> - label for the specific line (if C<undef> no label is drawn))

=item * C<$where> - where to draw the label 
( top | bottom | right | left | topright | topleft | bottomright | bottomleft ) 

=back

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub set_labels {
    my $self = shift;

    my $sides = $self->{-sides};
    Validate::Inputs( \@_, [], [ ( qw(text where) x $sides ) ] );
    my @labels = @_;

    # draw labels if defined for each line
    my $side = 0;
    foreach my $l ( @{ $self->lines() } ) {
        next unless $l;
        my $off = $side * 2;
        my ( $label, $position ) = @labels[ $off, $off + 1 ];
        $l->label( $label, $position ) if $label;
        $side++;
    }
    return $self;
}

# ============================================================================
# set_angles
# ============================================================================

=head2 set_angles ($label, ..., [$size, ...])

Set and draw the labels for each angle.

B<Parameters>

=over 

=item * C<$label> - label for the specific angle (if C<undef> no label is drawn))

=item * C<$size> - how large to draw the angle (defaults to 40)

=back

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub set_angles {
    my $self  = shift;
    my $sides = $self->{-sides};

    Validate::Inputs( \@_, [], [ (qw(text)) x $sides, (qw(number)) x $sides ] );
    my @names = splice( @_, 0, $sides );
    my @sizes = splice( @_, 0, $sides );
    my $cn    = $self->{-cn};
    my $lines = $self->lines();
    my $angles = $self->angles();

    # loop through the angles
    foreach my $s ( 1 .. $sides ) {
        my $name = $names[ $s - 1 ];
        my $size = $sizes[ $s - 1 ] || 40;
        if ($name) {
            my $ss = $s - 1;
            $ss = $sides if $ss == -1;
            $angles->[ $s - 1 ]->remove() if $angles->[ $s - 1 ];
            $angles->[ $s - 1 ] =
              Angle->new( $cn,
                          $lines->[ $s - 1 ],
                          $lines->[ $ss - 1 ],
                          -size => $size )->label($name);
        }
    }
    return $self;
}

# ============================================================================
# coords/lines/points/angles/a/l/p
# ============================================================================

=head2 coords ()

Returns the coordinates of all the polygon vertices

=head2 points ()

Returns the point objects of the polygon

=head2 lines ()

Returns the line objects of the polygon

=head2 angles ()

Returns the angle objects of the polygon

=head2 p (I<i>)

Returns the I<i>th point object of the polygon object

=head2 l (I<i>)

Returns the I<i>th line object of the polygon object

=head2 a (I<i>)

Returns the I<i>th angle object of the polygon object

=cut

# -----------------------------------------------------------------------------
sub coords {
    my $self = shift;
    $self->{-coords} = [] unless $self->{-coords};
    return @{ $self->{-coords} };
}

# returns array (or pointer to)
sub lines {
    my $self = shift;
    my $x = $self->{-lines} || [];
    if (wantarray) {
        return @$x;
    }
    else {
        return $x;
    }
}

# returns array (or pointer to)
sub points {
    my $self = shift;
    my $x = $self->{-points} || [];
    if (wantarray) {
        return @$x;
    }
    else {
        return $x;
    }
}

# returns array (or pointer to)
sub angles {
    my $self = shift;
    my $x = $self->{-angles} || [];
    if (wantarray) {
        return @$x;
    }
    else {
        return $x;
    }
}

# returns object at index (1-based)
sub a {
    my $self = shift;
    my $side = shift;
    return $self->{-angles}[ $side - 1 ];
}

# returns object at index (1-based)
sub l {
    my $self = shift;
    my $side = shift;
    return $self->{-lines}[ $side - 1 ];
}

# returns object at index (1-based)
sub p {
    my $self = shift;
    my $side = shift;
    return $self->{-points}[ $side - 1 ];
}

# ============================================================================
# draw
# ============================================================================

=head2 draw ($speed)

Draw the polygon (good if it has been removed, this redraws)

B<Parameters>

=over 

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
sub draw {
    my $self  = shift;
    my $speed = shift;
    $self->angles_draw();
    $self->lines_draw($speed);
    $self->points_draw();

    # create the polygon if it was removed
    my $poly = $self->poly;
    unless ($poly) {
        my $cn = $self->{-cn};
        my $p = $cn->createPolygon(
                                    $self->coords,
                                    -outline => undef,
                                    -fill    => undef
                                  );
        $cn->lower($p);
        $self->{-poly} = $p;
    }
    $self->fill( $self->{-fill} );

}

# ============================================================================
# points_draw
# ============================================================================

=head2 points_draw ()

Draw the points for this polygon (useful if they have been removed)

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub points_draw {
    my $self   = shift;
    my $points = $self->points();
    foreach my $p (@$points) {
        $p->draw()   if $p;
        $p->normal() if $p;
    }
    return $self;
}

# ============================================================================
# lines_draw
# ============================================================================

=head2 lines_draw ()

Draw the lines for this polygon (useful if they have been removed)

B<Parameters>

=over 

=item * C<speed> - [OPTIONAL] how fast to draw the lines  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub lines_draw {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(speed)] );
    my $speed = shift;
    my $lines = $self->lines();

    foreach my $l (@$lines) {
        $l->draw($speed) if $l;
        $l->normal() if $l;
    }
    return $self;
}

# ============================================================================
# angles_draw
# ============================================================================

=head2 angles_draw ()

Draw the points for this polygon (useful if they have been removed)

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub angles_draw {
    my $self   = shift;
    my $angles = $self->angles();

    foreach my $a (@$angles) {
        $a->draw()   if $a;
        $a->normal() if $a;
    }
    return $self;
}

# ============================================================================
# sides
# ============================================================================

=head2 sides()

Returns number of sides of the polygon

=cut

sub sides {
    my $self = shift;
    return $self->{-sides};
}

# ============================================================================
# move
# ============================================================================

=head2 move ($x,$y, $inc, $speed)

Move the polygon 

B<Parameters>

=over 

=item * $x,$y - how much to move the polygon in x/y directions

=item * $inc - [OPTIONAL] what distance between each frame of animated move
(default = 0 => no animation)

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
sub move {
    my $self = shift;

    # inputs
    Validate::Inputs( \@_, [qw(coord coord)], [qw(number speed)] );
    my $x    = shift;
    my $y    = shift;
    my $inc  = shift || 0;
    my $fast = shift || 1;

    # object properties
    my $cn     = $self->{-cn};
    my $angles = $self->angles();
    my $lines  = $self->lines();
    my $points = $self->points();
    my $d      = sqrt( $x**2 + $y**2 );
    my $old_coords = $self->{-coords};
    return unless $d;

    # how much to move for each animation
    my $dx = $x / $d * $inc;
    my $dy = $y / $d * $inc;

    # ------------------------------------------------------------------------
    # animation sub
    # ------------------------------------------------------------------------
    my $move_sub = sub {
        my $i = shift;
        foreach my $p (@$points) {
            $p->move( $dx, $dy, 1 ) if $p;
        }
        foreach my $l (@$lines) {
            $l->move( $dx, $dy, 1 ) if $l;
        }
        foreach my $a (@$angles) {
            $a->move( $dx, $dy, 1 ) if $a;
        }
        $cn->move( $self->{-poly}, $dx, $dy );
        $cn->update;
    };

    # ------------------------------------------------------------------------
    # animate
    # ------------------------------------------------------------------------
    my $fx = 0;
    my $fy = 0;

    if ( $inc && !$Shape::NoAnimation ) {
        $self->animate( $move_sub, $fast, int( $d / $inc ), );
        $fx = $dx * int( $d / $inc );
        $fy = $dy * int( $d / $inc );
    }

    # ------------------------------------------------------------------------
    # final adjustment (in case there were round off errors, or no animation)
    # ------------------------------------------------------------------------
    foreach my $p (@$points) {
        $p->move( $x - $fx, $y - $fy, 1 ) if $p;
    }
    foreach my $l (@$lines) {
        $l->move( $x - $fx, $y - $fy, 1 ) if $l;
    }
    foreach my $a (@$angles) {
        $a->move( $x - $fx, $y - $fy, 1 ) if $a;
    }
    $cn->move( $self->{-poly}, $x - $fx, $y - $fy );
    $cn->update;

    # ------------------------------------------------------------------------
    # reset all the coordinates
    # ------------------------------------------------------------------------
    my @new    = ();
    my $sides  = $self->{-sides};

    # all the points
    foreach my $s ( 1 .. $sides ) {
        my $off = ( $s - 1 ) * 2;
        my $x2  = $old_coords->[$off] + $x;
        my $y2  = $old_coords->[ $off + 1 ] + $y ;
        push @new, $x2, $y2;
    }

    # repeat first point (to make the polygon
    push @new, $new[0], $new[1];

    # bounding box coords
    my @bb = $self->{-cn}->coords( $self->{-poly} );
    if ( $bb[0] && ref( $bb[0] ) && $bb[0]->isa("Tcl::List") ) {
        @bb = @{ $bb[0] };
    }
    $self->{-x} = $bb[0];
    $self->{-y} = $bb[1];

    # save and return
    $self->{-coords} = \@new;

    return $self;

}

# ============================================================================
# rotate
# ============================================================================

=head2 rotate ($x,$y, $angle, $inc, $speed)

Rotate the polygon around the point $x,$y, by an angle of $angle

B<Parameters>

=over 

=item * $x,$y - center of rotation

=item * $angle - how much to rotate

=item * $inc - [OPTIONAL] what angle between each frame of animated move
(default = 0 => no animation)

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
sub rotate {
    my $self = shift;
    Validate::Inputs( \@_, [qw(coord coord angle)], [qw(number speed)] );
    my $x1    = shift;
    my $y1    = shift;
    my $angle = shift;
    my $inc   = shift;
    my $fast  = shift || 1;

    my $sides  = $self->{-sides};
    my $coords = $self->{-coords};
    my @new    = ();

    # ------------------------------------------------------------------------
    # animation sub
    # ------------------------------------------------------------------------
    if ( $inc && !$Shape::NoAnimation ) {
        $self->animate(
            sub {
                my $i   = shift;
                my @new = ();
                foreach my $s ( 1 .. $sides ) {
                    my $off = ( $s - 1 ) * 2;
                    my $x2  = $coords->[$off];
                    my $y2  = $coords->[ $off + 1 ];

                    my ( $r, $theta, $phi ) =
                      cartesian_to_spherical( $x2 - $x1, $y1 - $y2, 0 );
                    my $angle = $theta + deg2rad( $inc * $i );
                    my ( $x, $y, $z ) =
                      spherical_to_cartesian( $r, $angle, $phi );
                    $x2 = $x1 + $x;
                    $y2 = $y1 - $y;
                    push @new, $x2, $y2;
                }

                # make a new polygon
                my $x = Polygon->new( $self->{-cn}, $sides, @new, -1,
                                      %{ $self->{-args} } );
                $x->fill( $self->{-fill} );
                $self->remove();
                undef %$self;
                %$self = (%$x);

            },
            $fast,
            int( $angle / $inc ),
                      );
    }

    # ------------------------------------------------------------------------
    # final adjustment (in case there were round off errors, or no animation)
    # ------------------------------------------------------------------------
    undef @new;
    foreach my $s ( 1 .. $sides ) {
        my $off = ( $s - 1 ) * 2;
        my $x2  = $coords->[$off];
        my $y2  = $coords->[ $off + 1 ];

        my ( $r, $theta, $phi ) =
          cartesian_to_spherical( $x2 - $x1, $y1 - $y2, 0 );
        my $angle = $theta + deg2rad($angle);
        my ( $x, $y, $z ) = spherical_to_cartesian( $r, $angle, $phi );
        $x2 = $x1 + $x;
        $y2 = $y1 - $y;
        push @new, $x2, $y2;
    }

    # ------------------------------------------------------------------------
    # make a new polygon
    # ------------------------------------------------------------------------
    my $x = Polygon->new( $self->{-cn}, $sides, @new, -1, %{ $self->{-args} } );
    $x->fill( $self->{-fill} );
    $self->remove();
    undef %$self;
    %$self = (%$x);
    return $self;
}

# ============================================================================
# area
# ============================================================================

=head2 area

Calculates and returns the area of the polygon

B<Parameters>

=back

B<Returns>

=over

=item * The area of the parallelogram

=back

=cut

# -----------------------------------------------------------------------------
sub area {
    my $self = shift;
    my $cn   = $self->{-cn};
    return $self->{-area} if $self->{-area};

    # ------------------------------------------------------------------------
    # get a list of triangles that make up the polygon
    # ------------------------------------------------------------------------
    my @triangles = $self->copy_to_triangles();

    # ------------------------------------------------------------------------
    # add up area of triangles
    # ------------------------------------------------------------------------
    my $area = 0;
    foreach my $triangle (@triangles) {
        $area = $triangle->area + $area;
        $triangle->remove;
    }
    $self->{-area} = $area;
    return $area;
}

# ============================================================================
# copy_to_polygon_shape
# ============================================================================

=head2 copy_to_polygon_shape ($point, $polygon, $speed)

Given this polygon ($self) "A", create a new polygon, similar in shape to 
another polygon "B", equal in size to the "A"

(VI.25)

B<Parameters>

=over 

=item * C<$point> - the point where you want the new polygon drawn

=item * C<$polygon> - the shape that you want the final polygon to be similar to

=item * C<speed> - [OPTIONAL] how fast to draw the objects  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * A polygon object defining the new polygon

=back

=cut

# -----------------------------------------------------------------------------
sub copy_to_polygon_shape {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point Polygon)], [qw(speed)] );
    my $pt      = shift;
    my $polygon = shift;
    my $speed   = shift;
    my $sides   = $self->{-sides};
    my $cn      = $self->{-cn};

    my %p;

    # need a right angle
    my $l1 = Line->new( $cn, 10, 40, 40, 40, $speed )->grey;
    my $l2 = Line->new( $cn, 10, 40, 10, 10, $speed )->grey;
    my $right = Angle->new( $cn, $l1, $l2 );
    $l1->remove;
    $l2->remove;
    $right->remove;

    # Create a rectangle equal in area to other BCLE (I.45)
    # drawn on it's base
    my $t1 =
      $polygon->copy_to_parallelogram_on_line( $polygon->l(1), $right, $speed );
    $p{B} = $t1->p(4)->label( "B", "top" );
    $p{C} = $t1->p(3)->label( "C", "top" );
    $p{E} = $t1->p(2)->label( "E", "bottom" );

    # copy self to rectangle along side of previous CFME
    my $t2 = $self->copy_to_parallelogram_on_line( $t1->l(2), $right,$speed );

    # create a line GH (starting at point $pt) such that it is
    # the mean proporitional of BC, CF (VI.13)
    my $line3 = Line->mean_proportional( $t1->l(1), $t2->l(2), $pt, 0 );
    $p{H} = Point->new( $cn, $line3->end )->label( "H", "right" );

    # finally, draw a copy of the polygon onto the new line
    # (the final polygon will by the size of self, but similar to polygon)
    my $final = $polygon->copy_to_similar_shape($line3);
    
    # clean up
    $t1->remove;
    $t2->remove;
    $line3->remove;
    foreach my $p (keys %p) {
        $p{$p}->remove;
    }

    return $final;

}

# ============================================================================
# copy_to_similar_shape
# ============================================================================

=head2 copy_to_similar_shape ($line, $speed)

Given a polygon, create a new polygon, similar in shape to itself,
copied onto a new line

(VI.18)

B<Parameters>

=over 

=item * C<$line> - the point where you want the new polygon drawn

=item * C<speed> - [OPTIONAL] how fast to draw the objects  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * A polygon object defining the new polygon

=back

=cut

# -----------------------------------------------------------------------------
sub copy_to_similar_shape {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Line)], [qw(speed)] );
    my $line    = shift;
    my $polygon = shift;
    my $speed   = shift;
    my $sides   = $self->{-sides};
    my $cn      = $self->{-cn};

    # array of pointf for new polygon
    my @points;
    push @points, Point->new( $cn, $line->start );
    push @points, Point->new( $cn, $line->end );

    # --------------------------------------------------------------------------
    # create individual triangles and copy them
    # --------------------------------------------------------------------------
    my $line_to_draw_on = $line->clone->red;
    foreach my $i ( 3 .. $sides ) {

        # create new triangle
        my $t =
          Triangle->join( $self->p(1), $self->p( $i - 1 ), $self->p($i) )
          ->fill("pink");

        # create two new angles
        my $a1 = Angle->new( $cn, $t->l(1), $t->l(3) );
        my $a2 = Angle->new( $cn, $t->l(2), $t->l(1) );

        # copy these angles to the line to draw on
        my $pt1 = Point->new( $cn, $line_to_draw_on->start );
        my $pt2 = Point->new( $cn, $line_to_draw_on->end );
        my ( $l1, $a1tmp ) = $a1->copy( $pt1, $line_to_draw_on, 'positive' );
        my ( $l2, $a2tmp ) = $a2->copy( $pt2, $line_to_draw_on, 'negative' );

        # find the intersection of the new lines
        my $pt3 = Point->new( $cn, $l1->intersect($l2) );
        push @points, $pt3;

        # clean up
        $line_to_draw_on->remove;
        $t->remove;
        $a1->remove;
        $a2->remove;
        $l1->remove;
        $l2->remove;
        $a1tmp->remove;
        $a2tmp->remove;
        $pt1->remove;
        $pt2->remove;

        # create new line to draw on
        $line_to_draw_on = Line->join( $pt1, $pt3 )->red;

    }

    # remove last line to draw on, and drawn points
    $line_to_draw_on->remove;
    foreach my $pt (@points) {
        $pt->remove;
    }

    # create and return new polygon
    return Polygon->join( $self->sides, @points );
}

# ============================================================================
# copy_to_rectangle
# ============================================================================

=head2 copy_to_rectangle ($point, $speed)

Given a polygon, create a rectangle that is equal in area to
the original polygon.

Rectangle is created such that the top right corner is at C<$point>

(I.45)

B<Parameters>

=over 

=item * C<$point> - the point where you want the rectangle drawn

=item * C<speed> - [OPTIONAL] how fast to draw the objects  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * A polygon object defining the new rectangle

=back

=cut

# -----------------------------------------------------------------------------
sub copy_to_rectangle {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point)], [qw(speed)] );
    my $pt    = shift;
    my $speed = shift;
    my $sides = $self->{-sides};
    my $cn    = $self->{-cn};

    # need a right angle
    my $l1 = Line->new( $cn, 10, 40, 40, 40, $speed )->grey;
    my $l2 = Line->new( $cn, 10, 40, 10, 10, $speed )->grey;
    my $right = Angle->new( $cn, $l1, $l2 );
    $l1->remove;
    $l2->remove;

    # create parallelogram
    my $pll = $self->copy_to_parallelogram_on_point( $pt, $right );
    $right->remove;

    # - points might not be exactly square, due to round offs, or slight
    #   misalignament, so fix it.
    my @p = $pll->coords();
    $p[4] = $p[2];
    $p[6] = $p[0];
    $p[3] = $p[1];
    $p[7] = $p[5];
    $pll->remove;

    return Polygon->new( $cn, 4, @p[ 0 .. 7 ], $speed );
}

# ============================================================================
# copy_to_parallelogram_on_point
# ============================================================================

=head2 copy_to_parallelogram_on_point ($point, $angle, $speed)

Given a polygon, create a parallelogram at a given point,
and with a given angle, that is equal in area to
the original polygon (I.45)

Rectangle is created such that the top right corner is at C<$point>

B<Parameters>

=over 

=item * C<$point> - the point where you want the parallelogram drawn

=item * C<$angle> - an angle object used to define the angle of the parallelogram 

=item * C<speed> - [OPTIONAL] how fast to draw the objects  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * A parallelogram object defining the new parallelogram

=back

=cut

# -----------------------------------------------------------------------------
sub copy_to_parallelogram_on_point {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point Angle)], [qw(speed)] );
    my $pt    = shift;
    my $angle = shift;
    my $speed = shift;
    my $cn    = $self->{-cn};

    # create an arbitrary line on the point
    my @coords = $pt->coords;
    my $line = Line->new( $cn, @coords, $coords[0] + 200, $coords[1] );

    # create the parallelogram, and then delete this line
    my $para = $self->copy_to_parallelogram_on_line( $line, $angle, $speed );
    $line->remove;

    # all done
    return $para;
}

# ============================================================================
# copy_to_parallelogram_on_line
# ============================================================================

=head2 copy_to_parallelogram_on_line ($line, $angle, $speed)

Given a polygon, create a parallelogram at a given point,
and with a given angle, that is equal in area to
the original polygon (I.45)

Parallelogram is created such that the top right corner is at the start 
of the line (to make it at the bottom left, draw your line right to left)

B<Parameters>

=over 

=item * C<$line> - the line where you want the parallelogram drawn

=item * C<$angle> - an angle object used to define the angle of the parallelogram 

=item * C<speed> - [OPTIONAL] how fast to draw the objects  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * A parallelogram object defining the new parallelogram

=back

=cut

# -----------------------------------------------------------------------------
sub copy_to_parallelogram_on_line {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Line Angle)], [qw(speed)] );
    my $line  = shift;
    my $angle = shift;
    my $speed = shift;
    my $cn    = $self->{-cn};
    my $sides = $self->{-sides};

    # ------------------------------------------------------------------------
    # get a list of triangles that make up the polygon
    # ------------------------------------------------------------------------
    my @triangles = $self->copy_to_triangles();

    # ------------------------------------------------------------------------
    # convert each triangle to a parallelogram
    # ------------------------------------------------------------------------
    my $current_line = $line->clone;
    my @coords       = $current_line->coords;

    foreach my $triangle (@triangles) {

        # copy triangle to line
        $triangle->normal;
        my $pll =
          $triangle->copy_to_parallelogram_on_line( $current_line, $angle,
                                                    $speed );
        $triangle->remove;

        ########
        if (0) {
            print "\ncurrent line ", CORE::join( ", ", $current_line->coords );
            print "\ncurrent triangle ", CORE::join( ", ", $triangle->coords );
            print "\ncurrent polygon ",  CORE::join( ", ", $pll->coords );
            print "\ntriangle area ",    $triangle->area;
            print "\nrectangle area ",   $pll->area;
            print "\n";
        }
        ########

        # remove stuff as we make it, so we don't have to clean up afterwards
        $current_line->remove;
        $pll->remove;

        # update new line, and coords for final parallelogram
        $current_line =
          Line->new( $cn, $pll->l(3)->end, $pll->l(3)->start, -1 )->red;
        my @new = $pll->coords;
        @coords[ 4 .. 7 ] = @new[ 4 .. 7 ];

    }
    $current_line->remove;

    # final parellelogram
    my $poly = Polygon->new( $cn, 4, @coords[ 0 .. 7 ], $speed );
    return $poly;
}

# ============================================================================
# copy_to_triangles
# ============================================================================

=head2 copy_to_triangles ($speed)

Take a given polygon, and create a set of triangles, equivalent to the initial
polygon

B<Parameters>

=over 

=item * C<speed> - [OPTIONAL] how fast to draw the objects  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * an array of triangle objects

=back

=cut

# -----------------------------------------------------------------------------
sub copy_to_triangles {

    # ------------------------------------------------------------------------
    # create as many triangles as needed
    # ------------------------------------------------------------------------
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(speed)] );
    my $speed = shift;
    my $sides = $self->{-sides};
    my $cn    = $self->{-cn};

    my @triangles;
    my @coords = $self->coords;
    my $new =
      Polygon->new( $cn, $sides, @coords[ 0 .. ( $sides * 2 - 1 ) ], $speed );
    while ( $sides > 3 ) {

        # calculate the index with the most 'narrow' extension
        my $min_angle = 360;
        my $index     = 0;
        foreach my $i ( 1 .. $sides ) {
            if ( $new->angle_value($i) < $min_angle ) {
                $min_angle = $new->angle_value($i);
                $index     = $i;
            }
        }

        # chop this section off - step 1 calculate points
        my @triangle_points;
        my @new_points;
        if ( $index == $sides ) {
            @triangle_points =
              ( $new->p( $index - 1 ), $new->p($index), $new->p(1) );
            foreach my $i ( 1 .. $sides - 1 ) {
                push @new_points, $new->p($i);
            }
        }
        elsif ( $index == 1 ) {
            @triangle_points =
              ( $new->p($sides), $new->p($index), $new->p( $index + 1 ) );
            foreach my $i ( 2 .. $sides ) {
                push @new_points, $new->p($i);
            }
        }
        else {
            @triangle_points =
              ( $new->p( $index - 1 ), $new->p($index), $new->p( $index + 1 ) );
            foreach my $i ( 1 .. $index - 1, $index + 1 .. $sides ) {
                push @new_points, $new->p($i);
            }
        }

        # create and save new triangle, update polygon
        push @triangles, Triangle->join( @triangle_points, $speed );
        $new->remove;
        $new = Polygon->join( $sides - 1, @new_points, $speed );
        $sides = $new->{-sides};
    }
    push @triangles, bless( $new, "Triangle" );

    return @triangles;
}

# ============================================================================
# angle_value(index)
# ============================================================================

=head2 angle_value($index)

Calculate the angle value at the given index for this polygon index
(1-based)

B<Parameters>

=over 

=item * C<index> at which point do you want the angle

=back

B<Returns>

=over

=item * number of degrees of angle

=back

=cut

# -----------------------------------------------------------------------------
sub angle_value {
    my $self = shift;
    Validate::Inputs( \@_, [qw(number)], [qw(speed)] );
    my $index = shift;
    my $sides = $self->{-sides};

    $index = 1 if ( $index < 1 || $index > $sides );

    # if we have not already calculated this, do so now
    unless ( exists $self->{-angle_value} ) {
        my $tot = 0;

        # clockwise
        foreach my $i ( 1 .. $sides ) {
            my $i2 = $i - 1;
            $i2 = $sides if $i2 < 1;
            my $angle = Angle->calculate( $self->l($i2), $self->l($i) );
            push @{ $self->{-angle_value} }, $angle;
            $tot = $tot + $angle;
        }

        # if total angle is too high, then polyon is drawn counter clockwise
        if ( $tot > ( $sides - 2 ) * 180 + 3 )
        {    # NB: plus three is just in case of roundoff errors

            undef $self->{-angle_value};

            # counter clock-wise
            foreach my $i ( 1 .. $sides ) {
                my $i2 = $i - 1;
                $i2 = 1 if $i2 > $sides;
                my $angle = Angle->calculate( $self->l($i), $self->l($i2) );
                push @{ $self->{-angle_value} }, $angle;
            }
        }
    }

    # return angle
    return $self->{-angle_value}->[ $index - 1 ];

}

# ============================================================================
# remove
# ============================================================================

=head2 remove ()

Removes the polygon from the canvas.  Use method "draw" to redraw it if required

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub remove {
    my $self = shift;
    foreach my $o ( $self->objects() ) {
        $o->remove();
    }
    my $cn = $self->{-cn};
    $cn->delete( $self->poly() ) if $self->poly;
    undef $self->{-poly};
    $self->remove_labels;
    $cn->update;
    return $self;
}

# ============================================================================
# scale the whole polygon
# ============================================================================

=head2 scale

Scales the whole polygon, with all of its objects

B<Parameters>

=over

=item * C<scale> How much to 'magnify'

=item * C<orig> where to 'fix' the starting point for scaling

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub scale {
    my $self  = shift;
    my $scale = shift;
    my @orig  = @_;

    my $cn    = $self->canvas;
    
    # scale all Geometry objects in the polygon
    my %o = map { ( $_, $_ ) } $self->objects;
    foreach my $obj (values %o) {
        $obj->scale($scale,@orig);
    }
    
    # scale the Tk polygon (which isn't a generic shape object)
    foreach my $obj ( $self->poly ) {
        next unless $obj;
        $cn->scale( $obj, @orig, $scale, $scale );
    }
        
    # update the Tk canvas
    $cn->update;
}

# ============================================================================
# scale only the inner Tk polygon
# ============================================================================

=head2 scale_inner

Scales the whole polygon, with all of its objects

B<Parameters>

=over

=item * C<scale> How much to 'magnify'

=item * C<orig> where to 'fix' the starting point for scaling

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub scale_inner {
    my $self  = shift;
    my $scale = shift;
    my @orig  = @_;

    my $cn    = $self->canvas;
    
    # scale the Tk polygon (which isn't a generic shape object)
    foreach my $obj ( $self->poly ) {
        next unless $obj;
        $cn->scale( $obj, @orig, $scale, $scale );
    }
        
    # update the Tk canvas
    $cn->update;
}

# ============================================================================
# remove_?
# ============================================================================

=head2 remove_angles, remove_lines, remove_points, remove_labels

Removes the angles, lines, points, line labels

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub remove_angles {
    my $self   = shift;
    my $cn     = $self->{-cn};
    my $angles = $self->angles();

    foreach my $a (@$angles) {
        no warnings;
        $a->remove() if $a;
    }
    return $self;
}

# ============================================================================
# remove_lines
# ============================================================================
sub remove_lines {
    my $self  = shift;
    my $cn    = $self->{-cn};
    my $lines = $self->lines();

    foreach my $l (@$lines) {
        $l->remove() if $l;
    }
    $self->{-lines} = $lines;
    return $self;
}

# ============================================================================
# remove_points
# ============================================================================
sub remove_points {
    my $self   = shift;
    my $cn     = $self->{-cn};
    my $points = $self->points();

    foreach my $p (@$points) {
        $p->remove() if $p;
    }
    return $self;
}

# ============================================================================
# remove_labels
# ============================================================================
sub remove_labels {
    my $self  = shift;
    my $lines = $self->lines();
    foreach my $l (@$lines) {
        $l->remove_label() if $l;
    }
    $self->remove_label();
    delete $self->{-args};
    return $self;
}
# ============================================================================
# remove_labels
# ============================================================================
sub remove_line_labels {
    my $self  = shift;
    my $lines = $self->lines();
    foreach my $l (@$lines) {
        $l->remove_label() if $l;
    }
    return $self;
}

# ============================================================================
# fill
# ============================================================================

=head2 fill ($colour)

Colours the inside of the polygon with the specified colour.  If colour is
not defined, then any existing fill colour will be removed

B<Parameters>

=over 

=item * $colour - a string defining a colour name recognized by the graphics
tool (Tk by default), or a standard "#ff0033" type string defining the rgb
characteristics of the colour

=back

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub fill {
    my $self = shift;
    Validate::Inputs( \@_, [], ["colour"] );
    my $colour = shift;
    my $cn     = $self->{-cn};
    my $poly   = $self->poly();
    $self->{-fill} = $colour;
    $cn->itemconfigure( $poly, -fill => $colour );
    $cn->update;
    return $self;
}

# ============================================================================
# fillover
# ============================================================================

=head2 fill ($polygon, $colour)

Colours the inside of the polygon with the specified colour.  If colour is
not defined, then any existing fill colour will be removed.  

Moves this polygon above the other specified polygon object 

B<Parameters>

=over 

=item * $polygon - another polygon object

=item * $colour - a string defining a colour name recognized by the graphics
tool (Tk by default), or a standard "#ff0033" type string defining the rgb
characteristics of the colour

=back

B<Returns>

=over

=item * Polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub fillover {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Polygon)], [qw(colour)] );
    my $obj = shift;
    $self->fill(@_);
    my $cn = $self->{-cn};
    $cn->raise( $self->poly(), $obj->poly() );
    return $self;
}

# ============================================================================
# lines_grey
# ============================================================================

=head2 lines_grey() / lines_green() / lines_red() / lines_normal()

Change the colour of the lines of the polygon object

If object colour is changed to grey, then the object labels will be hidden.

If object colour is changed from grey to any other colour, the object labels
will be redrawn.

B<Returns>

=over

=item * The Polygon object

=back 

=cut

# ----------------------------------------------------------------------------
sub lines_grey {
    my $self  = shift;
    my $lines = $self->lines();

    foreach my $l (@$lines) {
        $l->grey() if $l;
    }
    return $self;
}

# ============================================================================
# lines_normal
# ============================================================================
sub lines_normal {
    my $self  = shift;
    my $lines = $self->lines();

    foreach my $l (@$lines) {
        $l->normal() if $l;
    }
    return $self;
}

# ============================================================================
# lines_red
# ============================================================================
sub lines_red {
    my $self  = shift;
    my $lines = $self->lines();

    foreach my $l (@$lines) {
        $l->red() if $l;
    }
    return $self;
}

# ============================================================================
# lines_green
# ============================================================================
sub lines_green {
    my $self  = shift;
    my $lines = $self->lines();

    foreach my $l (@$lines) {
        $l->green() if $l;
    }
    return $self;
}

# ============================================================================
# points_grey
# ============================================================================

=head2 points_grey() / points_green() / points_red() / points_normal()

Change the colour of the points of the polygon object

If object colour is changed to grey, then the object labels will be hidden.

If object colour is changed from grey to any other colour, the object labels
will be redrawn.

B<Returns>

=over

=item * The Polygon object

=back 

=cut

# ----------------------------------------------------------------------------
sub points_grey {
    my $self   = shift;
    my $points = $self->points();

    foreach my $l (@$points) {
        $l->grey() if $l;
    }
    return $self;
}

# ============================================================================
# points_normal
# ============================================================================
sub points_normal {
    my $self   = shift;
    my $points = $self->points();

    foreach my $l (@$points) {
        $l->normal() if $l;
    }
    return $self;
}

# ============================================================================
# points_red
# ============================================================================
sub points_red {
    my $self   = shift;
    my $points = $self->points();

    foreach my $l (@$points) {
        $l->red() if $l;
    }
    return $self;
}

# ============================================================================
# points_green
# ============================================================================
sub points_green {
    my $self   = shift;
    my $points = $self->points();

    foreach my $l (@$points) {
        $l->green() if $l;
    }
    return $self;
}

# ============================================================================
# angles_grey
# ============================================================================

=head2 angles_grey() / angles_green() / angles_red() / angles_normal()

Change the colour of the lines of the polygon object

If object colour is changed to grey, then the object labels will be hidden.

If object colour is changed from grey to any other colour, the object labels
will be redrawn.

B<Returns>

=over

=item * The Polygon object

=back 

=cut

# ----------------------------------------------------------------------------
sub angles_grey {
    my $self   = shift;
    my $angles = $self->angles();
    foreach my $a (@$angles) {
        $a->grey() if $a;
    }
    return $self;
}

# ============================================================================
# angles_normal
# ============================================================================
sub angles_normal {
    my $self   = shift;
    my $angles = $self->angles();

    foreach my $a (@$angles) {
        $a->normal() if $a;
    }
    return $self;
}

# ============================================================================
# angles_green
# ============================================================================
sub angles_green {
    my $self   = shift;
    my $angles = $self->angles();

    foreach my $a (@$angles) {
        $a->green() if $a;
    }
    return $self;
}

# ============================================================================
# angles_red
# ============================================================================
sub angles_red {
    my $self   = shift;
    my $angles = $self->angles();

    foreach my $a (@$angles) {
        $a->red() if $a;
    }
    return $self;
}

# ============================================================================
# grey/green/red/normal
# ============================================================================

=head2 grey() / green() / red() / normal()

Change the colour of the lines and angles of the polygon object

If object colour is changed to grey, then the object labels will be hidden.

If object colour is changed from grey to any other colour, the object labels
will be redrawn.

B<Returns>

=over

=item * The Polygon object

=back 

=cut

sub grey {
    my $self = shift;
    $self->lines_grey();
    $self->angles_grey();
    $self->points_grey();
    my $tmp = $self->{-fill} || '';
    $self->fill();
    $self->{-fill} = $tmp;
    return $self;
}

# ============================================================================
# red
# ============================================================================
sub red {
    my $self = shift;
    $self->lines_red();
    $self->fill( $self->{-fill} );
    return $self;
}

# ============================================================================
# green
# ============================================================================
sub green {
    my $self = shift;
    $self->lines_green();
    $self->fill( $self->{-fill} );
    return $self;
}

# ============================================================================
# normal
# ============================================================================
sub normal {
    my $self = shift;
    $self->lines_normal();
    $self->angles_normal();
    $self->points_normal();
    $self->fill( $self->{-fill} );
    return $self;
}

# ============================================================================
# objects
# ============================================================================

=head2 objects

B<Returns>

=over

=item * All the drawn objects of the polygon (Lines, Points, Angles)

=back

=cut

# -----------------------------------------------------------------------------
sub objects {
    my $self = shift;
    my @o;
    foreach
      my $o ( @{ $self->lines() }, @{ $self->points }, @{ $self->angles } )
    {
        push @o, $o if $o;
    }
    return @o;
}

# ============================================================================
# label
# ============================================================================

=head2 label ([$label])

Add label to polygon.  If no label is specified, the current label is removed.

B<Parameters>

=over 

=item * C<$label> - text used for the label

=back

B<Returns>

=over

=item * object

=back

=cut

# -----------------------------------------------------------------------------
sub label {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(text)] );
    my $text = shift || "";

    # ------------------------------------------------------------------------
    # get info from the object data
    # ------------------------------------------------------------------------
    my $cn = $self->{-cn};

    # ------------------------------------------------------------------------
    # determine 'middle' of the polygon
    # ------------------------------------------------------------------------
    my @coords = $self->coords;
    my $minx   = 99999;
    my $maxx   = 0;
    my $miny   = 999999;
    my $maxy   = 0;
    foreach my $i ( 1 .. @coords / 2 ) {
        my $x = @coords[ ( $i - 1 ) * 2 ];
        my $y = @coords[ ( $i - 1 ) * 2 + 1 ];
        $minx = $x < $minx ? $x : $minx;
        $miny = $y < $miny ? $y : $miny;
        $maxx = $x > $maxx ? $x : $maxx;
        $maxy = $y > $maxy ? $y : $maxy;
    }
    my $x = ( $minx + $maxx ) / 2;
    my $y = ( $miny + $maxy ) / 2;

    # ------------------------------------------------------------------------
    # create the label
    # ------------------------------------------------------------------------
    $self->SUPER::_draw_label( $cn, $x, $y, $text, 'exactly' );
    return $self;
}

# ============================================================================
# poly
# ============================================================================

=head2 poly

B<Returns>

=over

=item * The canvas polygon object

=back

=cut

# -----------------------------------------------------------------------------
sub poly { my $self = shift; return $self->{-poly}; }

=head1 AUTHOR

Sandy Bultena

=head1 COPYRIGHT

This module is copyright (c) 2014 Sandy Bultena. All rights reserved.

This library is free software; you may redistribute and/or modify it under 
the terms of either the GNU General Public License 
or the Perl Artistic License, as specified in the Perl 5.10.0 README file.

=cut

1;

