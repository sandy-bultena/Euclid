#!/usr/bin/perl
use strict;
use warnings;

package Gnomon;
use Time::HiRes qw(usleep);
use Math::Trig qw(asin_real rad2deg deg2rad :radial);

use Geometry::Validate;
use Geometry::Point;
use Geometry::Circle;
use Geometry::Angle;
use Geometry::Shape;

our $NO_COMPLAIN = 1;

our @ISA = qw(Shape);

=head1 NAME

Gnomon - create and label arc to display a gnomon

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;

    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();

    $l{vHG} = VirtualLine->new(10,10,100,10);
    $l{vHL} = VirtualLine->new(10,10,10,100);
    $a{NOP} = Gnomon->new($pn,$l{vHG},$l{vHL},-size=>60)->label("NOP");

=head1 CLASS METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ($cn, $l1, $l2, [-size=>$number], [-center=>$offset])

Creates and draw the gnomon arc between the two lines specified.

The 'center' of the circle can be modified in order to offset the arc line.

The gnomon is always 270 degrees, with one of the lines horizontal, and the other
vertical.  If it is not 270 degrees, returns nothing!

Program exits with a failure if both lines do not meet at a common point.

If uncertain about your lines, use Angle->angle_coords to verify lines before calling C<new>.

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<l1> - Line object for line 1

=item * C<l2> - Line object for second line

=item * C<-size> => size of the arc from the center

=item * C<-center> => $offset - how far to move the center of the circle away
from the real vertex

=back

B<Returns>

=over

=item * Gnomon object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;
    return unless Validate::Inputs( \@_, [qw(canvas Line Line)], [],
                      {qw(-size number -center number)} );
    my $cn      = shift;
    my $l1      = shift;
    my $l2      = shift;
    my @options = @_;

    my $self = { -cn => $cn, -l1 => $l1, -l2 => $l2, -firsttime => 1, @options };
    bless $self, $class;

    # draw the gnomon
    $self->draw();

    return $self;

}

=head1 OBJECT METHODS

=cut

# ============================================================================
# draw
# ============================================================================

=head2 draw ()

Draws the gnomon object (object must already be defined)

Program exits with a failure if both lines do not meet at a common point.

If uncertain about your lines, use Angle->angle_coords to verify lines before calling C<new>.

B<Returns>

=over

=item Gnomon object

=back

=cut

# -----------------------------------------------------------------------------
sub draw {
    my $self   = shift;
    my $cn     = $self->{-cn};
    my $size   = $self->{-size} || 40;
    my $center = $self->{-center} || 0;

    # ------------------------------------------------------------------------
    # find a common vertex
    # ------------------------------------------------------------------------
    my ( $vx, $vy, $vec1, $vec2 ) = Angle->angle_coords( $self->{-l1}, $self->{-l2} );

    unless ( defined $vx && defined $vy ) {
        Validate::complain("Cannot find a common vertex for this angle");
        return;
    }

    # ------------------------------------------------------------------------
    # convert vectors to angles
    # ------------------------------------------------------------------------
    my ( $start, $dtheta ) = _vector_to_angle( $vec1, $vec2 );

    if ( $self->{-firsttime} && abs( $dtheta - 270 ) > .2 ) {
        Validate::complain("This is not a valid gnomon!, theta = $dtheta");
        return;
    }

    # ------------------------------------------------------------------------
    # do we readjust the center of the arc?
    # ------------------------------------------------------------------------
    if ( $self->{-firsttime} && $center ) {

        my $ovx = $vx;
        my $ovy = $vy;

        # define new 'vertex'
        if ( $vec1->[0] < -0.2 ) {
            $vx = $vx + $center;
            $vy = $vy + $center;
        }
        elsif ( $vec1->[0] > 0.2 ) {
            $vx = $vx - $center;
            $vy = $vy - $center;
        }
        elsif ( $vec1->[1] < -0.2 ) {
            $vx = $vx + $center;
            $vy = $vy - $center;
        }
        elsif ( $vec1->[1] > 0.2 ) {
            $vx = $vx - $center;
            $vy = $vy + $center;
        }

        # calculate new 'lines' 
        $self->{-size} = $self->{-size} + $self->{-center};
        $size = $self->{-size};
        my $c  = VirtualCircle->new( $vx, $vy, $vx + $size, $vy );
        my @p1 = $c->intersect_line( $self->{-l1} );
        my @p2 = $c->intersect_line( $self->{-l2} );

        $self->{-l1} = VirtualLine->new( $vx, $vy, @p1 );
        $self->{-l2} = VirtualLine->new( $vx, $vy, @p2 );

        # calculate new angle
        ( $vx, $vy, $vec1, $vec2 ) = Angle->angle_coords( $self->{-l1}, $self->{-l2} );
        ( $start, $dtheta ) = _vector_to_angle( $vec1, $vec2 );

    }

    $self->{-firsttime} = 0;

    # ------------------------------------------------------------------------
    # create the canvas objects
    # ------------------------------------------------------------------------
    my @cs = $self->normal_colour();

    foreach my $width ( @Shape::shape_sizes ) {
        my @inputs = ( -outline => $cs[ 4 - $width ], -width => $width, );

        my $o;

        # arc
        $o = $cn->createArc(
                             $vx + $size, $vy + $size, $vx - $size, $vy - $size,
                             @inputs,
                             -extent => $dtheta,
                             -start  => $start,
                             -style  => "arc",
                             -dash   => [ 6, 6 ],
                           );

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
    $self->label($self->label_is);

    $cn->update();
    return $self;

}

sub _vector_to_angle {
    my $vec1 = shift;
    my $vec2 = shift;
    my ( $r1, $theta1, $phi1 ) = cartesian_to_spherical( @$vec1, 0 );
    my ( $r2, $theta2, $phi2 ) = cartesian_to_spherical( @$vec2, 0 );

    $theta1 = rad2deg($theta1);
    $theta2 = rad2deg($theta2);

    my $dtheta = abs( $theta1 - $theta2 );
    my $start  = $theta1;

    if ( $theta1 > $theta2 ) { $dtheta = 360 - $dtheta }
    return $start, $dtheta;
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

=item * gnomon object

=back

=cut

# -----------------------------------------------------------------------------
sub label {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(text number)] );
    my $text = shift || "";
    my $size = shift;

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
    my $v  = $self->{-v};

    # ------------------------------------------------------------------------
    # redraw if size has changed
    # ------------------------------------------------------------------------
    if ( $size && $size != $o ) {
        $self->remove();
        $self->{-size} = $size;
        $o = $size;
        $cn->update();
        $self->draw();
    }

    # ------------------------------------------------------------------------
    # determine position of the start, mid-arc, and end-arc
    # ------------------------------------------------------------------------
    my $xe = $v->[0] + cos( deg2rad( $s - .18*(360-$e) ) ) * ($o);
    my $ye = $v->[1] - sin( deg2rad( $s - .18*(360-$e) ) ) * ($o);
    my $xm = $v->[0] + cos( deg2rad( $s + 0.5 * $e ) ) * ( $o + 10 );
    my $ym = $v->[1] - sin( deg2rad( $s + 0.5 * $e ) ) * ( $o + 10 );
    my $xs = $v->[0] + cos( deg2rad( $s + .2*(360-$e) + $e ) ) * ($o);
    my $ys = $v->[1] - sin( deg2rad( $s + .2*(360-$e) + $e ) ) * ($o);
    
    # ------------------------------------------------------------------------
    # create the label
    # ------------------------------------------------------------------------
    my @text = split( "", $text );
    $self->_draw_label($cn,[$xs,$ys,$text[0],'exactly'],[$xm,$ym,$text[1],'exactly']
    ,[$xe,$ye,$text[2],'exactly']);

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
