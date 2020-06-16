#!/usr/bin/perl
package Square;
use strict;
use warnings;
use Geometry::Polygon;
use Carp;
our @CARP_NOT;

our @ISA = (qw(Parallelogram));

sub new {
    my $class = shift;
    my $cn    = shift;

    # get coordinates
    my @coords = splice( @_, 0, 4 );
    if ( scalar(@_) % 2 ) {
        warn("invalid arguments passed to Square->new");
        return bless {}, $class;
    }
    my %props = @_;
    my $speed = $props{-speed} || $Shape::DefaultSpeed;

    # 2nd line, and points 2 & 3
    my $p2 = Point->new( $cn, @coords[ 0, 1 ] );
    my $p3 = Point->new( $cn, @coords[ 2, 3 ] );
    my $l2 = Line->new( $cn, @coords, $speed );

    # draw line perpendicular to line 2, at point2
    my $l11 = $l2->perpendicular( $p2 );

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

    # create the polygon
    my $sides = 4;
    my $para = Square->assemble(
                                 $cn, $sides,
                                 -lines  => [ $l1, $l2, $l3, $l4 ],
                                 -points => [ $p1, $p2, $p3, $p4 ]
                               );

    return $para;
}

1;
