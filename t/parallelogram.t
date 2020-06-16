#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 11;
$Shape::AniSpeed = 50;

use Tk;
use Geometry::Geometry;

# create a canvas object
my $mw = MainWindow->new();
my $cn = $mw->Canvas( -bg => "white", -width => 800, -height => 700 )->pack();
$cn->configure( "-scrollregion" => [ 0, 0, 800, 700 ], -closeenough => 2.0 );

# create parallelogram
my $poly = Parallelogram->new(
    $cn, 150, 350, 450, 350, 400, 200, undef,
    -points => [qw(A left B right C top D top)],
    -labels => [qw(x bottom y right z top xx left)],
    -angles => [qw(a b c d)]
                             );
isa_ok( $poly, "Parallelogram" );
isa_ok( $poly, "Polygon" );
can_ok( $poly, qw(new copy_to_point copy_to_line) );

my $p = Point->new( $cn, 200, 500 );
my $copy = $poly->copy_to_point($p);
isa_ok( $copy, "Parallelogram" );
my @poly = $poly->coords;
my @copy = $copy->coords;
is( $copy[2], 200, 'point x2 copy to point' );
is( $copy[3], 500, 'point y2 copy to point' );
is( int( $copy[4] * 100 ),
    int( ( 200 + $copy->l(2)->length ) * 100 ),
    'point x3 copy to point' );
is( $copy[5], 500, 'point y3 copy to point' );

$cn->toplevel->update;

my $l = Line->new( $cn, 200, 550, 300, 550 );
my $resize = $poly->copy_to_line($l);
$l->notice;
isa_ok( $resize, "Parallelogram" );
my $poly_size   = 300 * 150;
my @resize      = $resize->coords;
my $resize_size = ( $resize[2] - $resize[0] ) * ( $resize[3] - $resize[5] );
$resize_size = abs($resize_size);
is( int( $resize_size + .5 ), $poly_size, "copy to line size ok" );
is_deeply( [ @resize[ 0 .. 3 ] ], [ $l->coords ], "copy to line position ok" );

$cn->toplevel->update;
