#!/usr/bin/perl
use strict;
use warnings;

package Point;
use Time::HiRes qw(usleep);
use Math::Trig qw(rad2deg deg2rad :radial);

use Geometry::Shape;
use Geometry::Validate;
our @ISA = qw(Shape);

=head1 NAME

Point - create and manipulate Point objects

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;
    
    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();
    
    # what is the distance between two coords 
    my $len = Point->distance_between(10,10,50,50);

    # create and draw two points
    my $p1 = Point->new( $cn, 50,50 )->label("A","top");
    my $p2 = Point->new( $cn, 150,150 )->label("B","right");
    
    # what is the distance between $p1 and (35,35)
    my $dist = $p1->distance_to(35,35);
    
    # move $p2 
    $p2->move_to(100,100);
    
    # get coordinates of a point
    my $l = Line->new($cn,20,20,100,75);
    my $p = $l->bisect();
    my ($x,$y) = $p->coords();

=head1 Line METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ($canvas, $x1,$y1)

Create and draw a point

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$x1,$y1> - coordinates for your point

=back

B<Returns>

=over

=item * Point object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;
    return unless Validate::Inputs( \@_, [qw(canvas coord coord)] );
    my $cn = shift;
    my $x  = shift;
    my $y  = shift;

    my $self = { -x => $x, -y => $y, -cn => $cn };
    bless $self, $class;

    if ( defined $x && defined $y ) {
        $self->draw();
    }
    return $self;
}

# ============================================================================
# draw
# ============================================================================

=head2 draw ()

Draw the point

B<Returns>

=over

=item * Point object

=back

=cut

# -----------------------------------------------------------------------------
sub draw {
    my $self = shift;
    my $cn   = $self->{-cn};
    my $x    = $self->x;
    my $y    = $self->y;

    # if point has already been drawn on the canvas, remove
    # those objects before redrawing the point
    my @cs = $self->normal_colour();
    if ( $self->{-objects} ) {
        foreach my $o ( @{ $self->{-objects} } ) {
            $cn->delete($o);
        }
    }

    # draw the point
    $self->{-objects} = [];
    foreach my $width (@Shape::shape_sizes ) {
        push $self->{-objects},
                          $cn->createOval(
                                           $x - $width-1, $y - $width-1, $x + $width+1, $y + $width+1,
                                           -fill    => $cs[4-$width],
                                           -outline => $cs[4-$width]
                                         );
    }
    
    # bind the mouse click to the notice method
    $self->_bind_notice();

    # label the point if desired
    $self->label( $self->label_is ) if $self->label_is;

    # update the canvas
    $cn->update();
    return $self;
}

# ============================================================================
# label
# ============================================================================

=head2 label ([$text, [$where]] )

Create a label for the point.  If no label defined, remove existing label.

B<Parameters>

=over 

=item * C<$text> - label text

=item * C<$where> - [OPTIONAL] where to draw the label, (default='right') 
top, bottom, left, right, topright, topleft

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
    my $what  = shift || '';
    my $where = shift || '';

    if ( $what || $self->label_is ) {
        my $cn = $self->{-cn};
        my $x  = $self->x || 0;
        my $y  = $self->y || 0;
        $self->_draw_label( $cn, $x, $y, $what, $where );
    }
    return $self;
}

# ============================================================================
# move_to
# ============================================================================

=head2 move_to ($x, $y)

Redraw the point at this new location

B<Parameters>

=over 

=item * C<$x1,$y1> - new coordinates for your point

=back

B<Returns>

=over

=item * Point object

=back

=cut

# -----------------------------------------------------------------------------
sub move_to {
    my $self = shift;
    Validate::Inputs( \@_, [qw(coord coord)] );
    my $x  = shift;
    my $y  = shift;
    my $cn = $self->{-cn};

    # move canvas objects
    foreach my $p ( @{ $self->{-objects} } ) {
        $cn->move( $p, $x - $self->x, $y - $self->y );
    }

    # reset object properties
    $self->{-x} = $x;
    $self->{-y} = $y;

    # redraw label
    $self->label( $self->label_is );

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
    my $cn   = $self->{-cn};
    my $x    = $self->x;
    my $y    = $self->y;
    my $obj  = @{ $self->{-objects} }[-2];
    my $width = $Shape::shape_sizes[0];

    my $sub = sub {
        my $i = shift;
        $cn->coords( $self->{-objects}->[-1], $x - ( 1 + $i + $width ), $y - ( 1 + $i + $width ), $x + ( 1 + $i + $width), $y + ( 1 + $i + $width ) );
    };
    $self->SUPER::notice($sub);
    return $self;
}

# ============================================================================
# coords
# ============================================================================

=head2 coords ( )

B<Returns>

=over

=item * coordinates of the point

=back

=cut

# ----------------------------------------------------------------------------
sub coords {
    my $self = shift;
    return $self->x, $self->y;
}

# ============================================================================
# x/y
# ============================================================================

=head2 x

B<Returns>

=over

=item * the x component of its position

=back

=cut

# ----------------------------------------------------------------------------
sub x {
    my $self = shift;
    return $self->{-x};
}

=head2 y

B<Returns>

=over

=item * the y component of its position

=back

=cut

# ----------------------------------------------------------------------------
sub y {
    my $self = shift;
    return $self->{-y};
}

# ============================================================================
# distance_to
# ============================================================================

=head2 distance_to ( )

What is the distance between this point, and a given coordinate

B<Parameters>

=over 

=item * C<$x1,$y1> - coordinates

=back

B<Returns>

=over

=item * distance between your point, and the given coordinates

=back

=cut

# ----------------------------------------------------------------------------
sub distance_to {
    my $self = shift;
    Validate::Inputs( \@_, [qw(coord coord)] );
    my $x2 = shift;
    my $y2 = shift;
    my ( $x1, $y1 ) = $self->coords();
    my ( $r, $theta, $phi ) = cartesian_to_spherical( $x2 - $x1, $y1 - $y2, 0 );
    return $r;
}

# ============================================================================
# distance between
# ============================================================================

=head2 distance_to ( )

What is the distance between two coordinates

B<Parameters>

=over 

=item * C<$x1,$y1> - coordinates

=item * C<$x2,$y2> - coordinates

=back

B<Returns>

=over

=item * distance between the given coordinates

=back

=cut

# ----------------------------------------------------------------------------
sub distance_between {
    my $self = shift;
    Validate::Inputs( \@_, [qw(coord coord coord coord)] );
    my $x1 = shift;
    my $y1 = shift;
    my $x2 = shift;
    my $y2 = shift;
    my ( $r, $theta, $phi ) = cartesian_to_spherical( $x2 - $x1, $y1 - $y2, 0 );
    return $r;
}

# ============================================================================
# grey
# ============================================================================

=head2 grey() / green() / red() / normal()

Change the colour of the object

If object colour is changed to grey, then the object labels will be hidden.

If object colour is changed from grey to any other colour, the object labels
will be redrawn.

B<Returns>

=over

=item * The Point object

=back 

=cut

sub grey {
    my $self = shift;
    $self->_set_colour( "-fill",    "grey" );
    $self->_set_colour( "-outline", "grey" );
    return $self;
}

# ============================================================================
# red
# ============================================================================
sub red {
    my $self = shift;
    $self->_set_colour( "-fill",    "red" );
    $self->_set_colour( "-outline", "red" );
    return $self;
}

# ============================================================================
# green
# ============================================================================
sub green {
    my $self = shift;
    $self->_set_colour( "-fill",    "green" );
    $self->_set_colour( "-outline", "green" );
    return $self;
}

# ============================================================================
# normal
# ============================================================================
sub normal {
    my $self = shift;
    $self->draw;
    return $self;
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
