#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 6;

use Tk;
use Geometry::Geometry;

# create a canvas object
my $mw = MainWindow->new();
my $cn = $mw->Canvas()->pack();

# what is the distance between two coords
my $len = Point->distance_between( 10, 10, 50, 50 );
is( int( $len * 100 ), int( sqrt(2) * 40 * 100 ), "distance_between ok" );

# create and draw two points
my $p1 = Point->new( $cn, 50, 50 )->label( "A", "top" );
my $p2 = Point->new( $cn, 150, 150 )->label( "B", "right" );
$cn->toplevel->update;
isa_ok( $p1, 'Point' );
can_ok(
    $p1, qw(distance_between label distance_to move_to
      grey green normal notice new draw coords) );
my @coord = $p1->coords();
is_deeply( \@coord, [ 50, 50 ], "coords ok" );

# what is the distance between $p1 and (35,35)
my $dist = $p1->distance_to( 35, 35 );
is( int( $dist * 100 ), int( sqrt(2) * ( 50 - 35 ) * 100 ), "distance_to ok" );

# move $p2
$cn->toplevel->update;
sleep(1);
foreach my $i ( 0 .. 5 ) {
    $p2->move_to( 150 - $i * 10, 150 - $i * 10 );
    $cn->toplevel->update;
    sleep(1);
}
@coord = $p2->coords;
is_deeply( \@coord, [ 100, 100 ], "move_to ok" );
