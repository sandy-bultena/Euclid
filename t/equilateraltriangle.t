#!/usr/bin/perl
use strict;
use warnings;

$Shape::DefaultSpeed = $Shape::DefaultSpeed * 3;
$Shape::AniSpeed     = 50;
use Test::More tests => 13;

use Tk;
use Geometry::EquilateralTriangle;
my $tri;
my ( @pt1, @pt2, $h, @coords );

# create a canvas object
my $mw = MainWindow->new();
my $cn = $mw->Canvas()->pack();

@pt1 = ( 20,  100 );
@pt2 = ( 100, 100 );
$h = sqrt( ( $pt2[0] - $pt1[0] )**2 + ( $pt2[1] - $pt2[1] )**2 );

$tri = EquilateralTriangle->build( $cn, @pt1, @pt2 );
isa_ok( $tri, 'Triangle' );
isa_ok( $tri, 'Polygon' );

# not a complete list... but at least we know it inherits from polygon
can_ok( $tri, 'draw', 'lines', 'points', 'angles', 'l', 'p', 'a', 'fill' );
$tri->remove();

# checking that we are using the correct point
{
    @pt1 = ( 20,  100 );
    @pt2 = ( 100, 100 );
    my $l = 80;
    $h = sqrt(3) / 2. * $l;

    $tri = EquilateralTriangle->build( $cn, @pt1, @pt2 );
    my @p3 = $tri->p(3)->coords;
    is( $p3[0], 60, 'x-pos ok 1' );
    is( int( abs( $p3[1] - ( 100 - $h ) ) ), 0, 'y-pos ok 1' );
    sleep(1);

    $tri->remove();
    $tri = EquilateralTriangle->build( $cn, @pt2, @pt1 );
    @p3 = $tri->p(3)->coords;
    is( $p3[0], 60, 'x-pos ok 2' );
    is( int( abs( $p3[1] - ( 100 + $h ) ) ), 0, 'y-pos ok 2' );
    sleep(1);
    $tri->remove();
}

{
    @pt1 = ( 100, 20 );
    @pt2 = ( 100, 100 );
    my $l = 80;
    $h = sqrt(3) / 2. * $l;

    $tri = EquilateralTriangle->build( $cn, @pt1, @pt2 );
    my @p3 = $tri->p(3)->coords;
    is( $p3[1], 60, 'y-pos ok 3' );
    is( int( abs( $p3[0] - ( 100 + $h ) ) ), 0, 'x-pos ok 3' );
    sleep(1);

    $tri->remove();
    $tri = EquilateralTriangle->build( $cn, @pt2, @pt1 );
    @p3 = $tri->p(3)->coords;
    is( $p3[1], 60, 'y-pos ok 4' );
    is( int( abs( $p3[0] - ( 100 - $h ) ) ), 0, 'x-pos ok 4' );
    sleep(1);
    $tri->remove();
}

############### FAST? ########################
$Shape::AniSpeed = 50000;
$Shape::DefaultSpeed = 1;
{
    $cn->toplevel->update;
    $cn->createText(10,10,-text=>"Fast?");
    @pt1 = ( 100, 20 );
    @pt2 = ( 100, 100 );
    my $l = 80;
    $h = sqrt(3) / 2. * $l;

    $tri = EquilateralTriangle->build( $cn, @pt1, @pt2 , -1);
    my @p3 = $tri->p(3)->coords;
    is( $p3[1], 60, 'y-pos ok 3' );
    is( int( abs( $p3[0] - ( 100 + $h ) ) ), 0, 'x-pos ok 3' );
    $cn->toplevel->update;
    sleep(1);
}

