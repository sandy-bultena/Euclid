#!/usr/bin/perl
package Oval;
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

Circle - create and manipulate oval objects

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;
    
    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();

    # create and draw oval based on rectangular coords
    my $c1 = Circle->new( $cn, 10,10 ,100,100 );


=head1 Oval METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ($canvas, $x1, $y1, $x2, $y2, [$speed, $dash])

Creates and draw a oval

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$x1, $y1, $x2, $y2> - two corners of a rectangle


=item * C<speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=item * C<dash> - [OPTIONAL] draw oval circle if true


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
    my $x1   = shift;
    my $y1   = shift;
    my $x2   = shift;
    my $y2   = shift;
    my $fast = shift || 1;
    my $dash = shift || 0;

    # create class
    my $self = {
                 -x1    => $x1,
                 -y1    => $y1,
                 -x2    => $x2,
                 -y2    => $y2,
                 -cn   => $cn,
                 -fast => $fast,
                 -dash => $dash,
                 -fill => undef
               };
    bless $self, $class;

    # draw
    $self->draw( );

    return $self;
}

# ============================================================================
# draw
# ============================================================================

=head2 draw (  )

Draw an already defined oval

B<Parameters>

=over 

=item * C<$speed> - [OPTIONAL] how fast to draw the circle  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * Oval object

=back

=cut

# -----------------------------------------------------------------------------
sub draw {
    my $self = shift;
    Validate::Inputs( \@_, [], [qw(float speed)] );
    my $angle = shift || 0;
    my $speed = shift || 0;

    my $cn   = $self->{-cn};
    my $x1    = $self->{-x1};
    my $y1    = $self->{-y1};
    my $x2    = $self->{-x2};
    my $y2    = $self->{-y2};
    my $fast = $speed ? $speed : $self->{-fast};

    # pick colours depending on how fast we are drawing
    # (black for normal, grey for quick-draw)
    my @cs = Shape->normal_colour;
    @cs = Shape->grey_colour if $fast > 1;

    # create canvas objects
    my @objs;
    foreach my $w (@Shape::shape_sizes) {
        if ( $self->{-dash} ) {
            push @objs,
          $cn->createArc(
                          $x1, $y1, $x2, $y2,
                          -width   => $w,
                          -outline => $cs[ 4 - $w ]
                               -dash    => [ 6, 6 ],
                             );
        }
        else {
            push @objs,
              $cn->createOval(
                          $x1, $y1, $x2, $y2,
                               -width   => $w,
                               -outline => $cs[ 4 - $w ],
                             );
        }
    }
    $self->{-objects} = \@objs;
    $self->{-object}  = $objs[0];
    $self->fill( $self->{-fill} );

    $cn->update();

    # return
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


=head1 AUTHOR

Sandy Bultena

=head1 COPYRIGHT

This module is copyright (c) 2014 Sandy Bultena. All rights reserved.

This library is free software; you may redistribute and/or modify it under 
the terms of either the GNU General Public License 
or the Perl Artistic License, as specified in the Perl 5.10.0 README file.

=cut

1;
