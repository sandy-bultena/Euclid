#!/usr/bin/perl
package Parallelogram;
use strict;
use warnings;
use Geometry::Polygon;
use Geometry::CalculatePoints;
use Geometry::Validate;

our @ISA = (qw(Polygon));

=head1 NAME

Line - create and manipulate Line objects

=head1 SYNOPSIS

    use Tk;
    use Geometry::Geometry;
    
    # create a canvas object
    my $mw   = MainWindow->new();
    my $cn   = $mw->Canvas()->pack();

    # create polygon
    my $poly = Parallelogram->new(
        $cn, 150, 350, 450, 350, 400, 200, undef,
        -points => [qw(A left B right C top D top)],
        -labels => [qw(x bottom y right z top xx left)],
        -angles => [qw(a b c d)]
                                 );

    # copy to a point
    my $p = Point->new( $cn, 200, 500 );
    my $copy = $poly->copy_to_point($p);

    # copy to a line (resize as necessary)
    my $l = Line->new( $cn, 200, 550, 300, 550 );
    my $resize = $poly->copy_to_line($l);

=head1 Line METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ($canvas, $x1,$y1, $x2,$y2, $x3,$y3, [$speed])

Create and draw a parallelogram by specifying three corners (the fourth
is calculated for you to insure that the polygon is indeed a parallelogram)

B<Parameters>

=over 

=item * Tk canvas - or any canvas object that mimics the methods from Tk

=item * C<$x1,$y1> - first corner of your parallelogram

=item * C<$x2,$y2> - second corner of your parallelogram

=item * C<$x3,$y3> - third corner of your parallelogram

=item * C<speed> - [OPTIONAL] how fast to draw the line  
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

=item * Parallelogram object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;
    return
      unless Validate::Inputs(
                               \@_,
                               [ "canvas", ("coord") x 6 ],
                               [qw(speed)],
                               {
                                  -points     => 'array',
                                  -labels     => 'array',
                                  -angles     => 'array',
                                  -fill       => 'text',
                                  -anglesizes => 'array'
                               }
                             );
    my $cn = shift;

    # get coordinates
    my @coords = splice( @_, 0, 6 );
    my $speed = shift;

    # what are the points for this parallelogram
    my @pts = CalculatePoints->parallelogram(@coords);

    # create the polygon
    my $sides = 4;
    my $para = Polygon->new( $cn, $sides, @pts, $speed, @_, );

    return bless $para, $class;
}

# ============================================================================
# copy_to_point
# ============================================================================

=head2 copy_to_point ($point, [$speed])

Copies the rectangle to a given point, where side 2 of the parallelogram 
will be horizontal.

B<Parameters>

=over 

=item * C<$point> - where to draw the parallelogram

=item * C<speed> - [OPTIONAL] how fast to draw the line  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * new Parallelogram object

=back

=cut

# -----------------------------------------------------------------------------
sub copy_to_point {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Point)], [qw(speed)] );
    my $point = shift;
    my $speed = shift || 1;
    my $cn    = $self->{-cn};
    my $np2   = $point;

    # create a starting line, starting at point $point
    my @xy = $np2->coords();
    my $l2 =
      Line->new( $cn, @xy, $xy[0] + 50 + $self->l(2)->length(), $xy[1], $speed )
      ->grey;

    # copy line 2 to the baseline
    my ( $nl2, $np3 ) = $self->l(2)->copy_to_line( $np2, $l2, $speed );
    $l2->remove();
    $nl2->grey;

    # copy angle2 to line2
    my $flag = 0;
    unless ( defined $self->a(2) ) {
        $self->set_angles( undef, " ", undef );
        $flag++;
    }

    my ( $l1, $a2 ) = $self->a(2)->copy( $np2, $nl2, undef, $speed );
    $l1->extend( $self->l(1)->length() );
    $l1->grey;
    $self->a(2)->remove() if $flag;

    # copy side 1
    my ( $nl1, $np1 ) = $self->l(1)->copy_to_line( $np2, $l1, $speed );
    $nl1->grey;
    $l1->remove();
    $cn->update();

    my @coords = ( $np1->coords(), $np2->coords, $np3->coords() );

    foreach my $o ( $l1, $a2, $nl1, $np1, $nl2, $np3 ) { $o->remove() }

    my $paral = Parallelogram->new( $cn, @coords, $speed );
    $paral->normal;
    return $paral;
}

# ============================================================================
# copy_to_line
# ============================================================================

=head2 copy_to_line ($line, [$speed])

Copies the rectangle to a given line, resizing it as necessary (the area of the
parallelogram will not be changed, but the lengths of the side will change).

B<Parameters>

=over 

=item * C<$line> - where to draw the parallelogram

=item * C<speed> - [OPTIONAL] how fast to draw the line  
(default C<$Shape::DefaultSpeed>)

NB: a speed of -1 suppresses the animation

=back

B<Returns>

=over

=item * new Parallelogram object

=back

=cut

# -----------------------------------------------------------------------------
sub copy_to_line {
    my $self = shift;
    Validate::Inputs( \@_, [qw(Line)], [qw(speed number)] );
    my $line  = shift;
    my $speed = shift || 1;
    my $cn    = $self->{-cn};

    # extend 3rd line
    my $t1 = $self->l(3)->clone()->prepend( $line->length + 50 );
    my ( $t2, $junk ) = $t1->split( $self->p(3) );
    $junk->remove();
    $t1->grey;
    $t2->grey;

    # copy line to our extension
    my ( $l4, $p4 ) = $line->copy_to_line( $self->p(3), $t2, $speed );
    $l4->red;
    $t2->remove();
    $p4->remove();

    # create the complement with the given line at point 3
    my $x = $self->_create_complement( $l4, $speed );
    $x->grey;
    my $p6 = Point->new( $cn, $line->start() );
    my $p7 = Point->new( $cn, $line->end() );
    my $y = $x->_move_to_edge( $p6, $p7, $speed );
    $x->remove();
    $l4->remove();
    $p6->remove;
    $p7->remove;
    return bless $y, "Parallelogram";

}

# ============================================================================
# creates a complement, on the extension of line 3, where the input line
# defines this extension.
# !!! For internal use only !!!
# ============================================================================
sub _create_complement {
    my $self  = shift;
    my $line  = shift;
    my $speed = shift || 1;
    my $cn    = $self->{-cn};

    # defines point 1 and 2 of 1st line of new parallelogram
    my $p1 = Point->new( $cn, $line->start() )->label("p1");
    my $p2 = Point->new( $cn, $line->end() )->label("p2");

    # construct parallel to 2nd line of parallelogram at point 2
    my $l2p2 = $self->l(2)->parallel( $p2, $speed )->grey;

    # Find intersect of 1st line of parallelogram to parallel line l2p2
    my $p22 = Point->new( $cn, $l2p2->intersect( $self->l(1) ) )->label("p22");

    # Draw diagonal, find intersection with 4th line of parallelogram
    my $diag = Line->new( $cn, $p22->coords(), $p1->coords, $speed )->grey;
    my $p44 = Point->new( $cn, $diag->intersect( $self->l(4) ) )->label("p44");

    # Draw a line at point p44, parallel to 3rd line of parallelogram
    #   $self->l(3)->#;

    my $l3p44 = $self->l(3)->parallel( $p44, $speed )->blue;

    # Find intersect of l2p2 and l3p44
    my $p3 = Point->new( $cn, $l2p2->intersect($l3p44) )->label("p3");

    # Find intersect of 2nd line of parallelogram to parallel line KL
    my $p4 = Point->new( $cn, $self->l(2)->intersect($l3p44) )->label("p4");

    # construct parallelogram
    my $poly = Polygon->join( 4, $p1, $p2, $p3, $p4, $speed );

    #$poly->set_points(qw(1 top 2 top 3 top 4 top));

    # cleanup
    $diag->remove();
    $p2->remove();
    $p1->remove();
    $p3->remove();
    $p4->remove();
    $p22->remove();
    $p44->remove();
    $l2p2->remove();
    $l3p44->remove();
    print "\nComplement area = ", $poly->area, "\n" if (0);

    # return
    $poly->normal;
    return bless $poly, "Parallelogram";
}

# ============================================================================
# once the complement has been created, it can now be copied to the edge of
# another object defined by the two input points.
# !!! For internal use only !!!
# ============================================================================
sub _move_to_edge {
    my $self   = shift;
    my $point1 = shift;
    my $point2 = shift;
    my $speed  = shift || 1;

    my $np1 = $point1;
    my $np2 = $point2;
    my $cn  = $self->{-cn};

    # line 1 of new polygon
    my $l1 =
      Line->new( $cn, $point1->coords(), $point2->coords(), $speed )->grey;

    # copy angle2 to create line2
    my $flag = 0;
    unless ( defined $self->a(2) ) {
        $self->set_angles( undef, " ", undef );
        $flag++;
    }

    my ( $l2, $a2 ) = $self->a(2)->copy( $np2, $l1, "negative", $speed );
    $self->a(2)->remove() if $flag;
    $l2->grey;

    # copy line 2
    $l2->extend( $self->l(2)->length() );
    $l2->grey;
    my ( $nl2, $np3 ) = $self->l(2)->copy_to_line( $np2, $l2, $speed );
    $l2->remove();

    my @coords = ( $np1->coords(), $np2->coords, $np3->coords() );

    foreach my $o ( $l1, $a2, $nl2, $np3 ) { $o->remove() }

    my $parall = Parallelogram->new( $cn, @coords, $speed );
    $parall->normal;
    return $parall;
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
