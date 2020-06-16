#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 31;
$Shape::AniSpeed = 50;

use Tk;
use Geometry::Geometry;

# create a canvas object
my $mw = MainWindow->new();
my $cn = $mw->Canvas( -bg => "white", -width => 800, -height => 700 )->pack();
$cn->configure( "-scrollregion" => [ 0, 0, 800, 700 ], -closeenough => 2.0 );

# create and draw two lines
my $l1 = Line->new( $cn, 50,  50, 150, 150 )->label( "A", "top" );
my $l2 = Line->new( $cn, 150, 50, 50,  150 )->label( "B", "right" );
isa_ok( $l1, 'Line' );
isa_ok( $l1, 'VirtualLine' );
can_ok(
    $l1, qw(new draw label extend prepend split rotateTo clone
      copy copy_to_line subtract bisect normal green red notice
      endpoints start end slope length angle point length_from_start
      length_from_end)
);
$l1->label( "Hello Sandy", "top" );
$cn->toplevel->update();
sleep(1);

# get info about lines
my $sl1 = $l1->slope();
my $a1  = $l1->angle();
my $d1  = $l1->length();
is( $sl1,     1,                    'slope ok' );
is( $a1,      -45,                  'angle ok' );
is( int($d1), int( sqrt(2) * 100 ), 'length ok' );
my @coords = $l1->endpoints();
is_deeply( \@coords, [ 50, 50, 150, 150 ], 'coords ok' );
@coords = $l1->start();
is_deeply( \@coords, [ 50, 50 ], 'start ok' );
@coords = $l1->end();
is_deeply( \@coords, [ 150, 150 ], 'end_ok' );

# clone & make the line longer
my $l5=$l1->clone->extend(20);
$l5->prepend(10);
@coords = $l5->endpoints();
$cn->toplevel->update();
foreach my $c (@coords) { $c = int($c) }
is_deeply(
           \@coords,
           [
              int( 50 - 10 / sqrt(2) ),
              int( 50 - 10 / sqrt(2) ),
              int( 150 + 20 / sqrt(2) ),
              int( 150 + 20 / sqrt(2) )
           ],
           'prepend/extend ok'
         );
# cloned line unchanged?
@coords = $l1->endpoints;
foreach my $c (@coords) { $c = int($c) }
is_deeply(
           \@coords,
           [50,50,150,150],
           'clone unchanged'
         );
$l1->remove;
$l1 = $l5;


# define a point a distance 20 from the start
my ( $px1, $py1 ) = $l1->point(10);
is_deeply( [ int($px1), ($py1) ], [ 50, 50 ], 'coord dist from ok' );

# what is the distance beween this point, and line 2?
my $p20  = Point->new( $cn, $px1, $py1 );
my $len1 = $l2->length_from_start($p20);
my $len2 = $l2->length_from_end($p20);
is( int( $len1 + .5 ), 100, 'length from start ok' );
is( int( $len2 + .5 ), 100, 'length from end ok' );

# what is the intersection point between these two lines
my ( $x1, $y1 ) = $l1->intersect($l2);
is_deeply( [ int($x1), int($y1) ], [ 100, 100 ], 'intersection ok' );

# split the line at the intersection point
my $p = Point->new( $cn, $x1, $y1 );
my ( $l3, $l4 ) = $l1->split($p);
isa_ok( $l3, 'Line', 'split 1 line ok' );
isa_ok( $l4, 'Line', 'split 2 line ok' );

# make the line segment stand out temporarily
$l3->notice();

# rotate the line segment to 90 degrees
$l3->rotateTo(90);
is( int( $l3->angle ), 90, 'rotateTo ok' );
$l3->rotateTo(45);
is ($l3->slope,-1,'rotateTo update slope ok');


# copy line3 back to the intersection point
( $l5, my $p2 ) = $l3->copy($p);

# clean-up
$l1->remove();
$l2->remove();
$l3->remove();
$l4->remove();
$l5->remove();
$p2->remove();
$p->remove();
$cn->toplevel->update();

# make a line, and copy it
# starting at point $p, and laying congruent with second line
$l1 = Line->new( $cn, 50, 50, 170, 50 )->label( "A", "top" );
$l2 = Line->new( $cn, 150, 150, 150, 350 )->label( "B", "right" );
$cn->toplevel->update();
$p = Point->new( $cn, $l2->start );
( $l3, $p2 ) = $l1->copy_to_line( $p, $l2 );
@coords = $l3->endpoints;
for my $c (@coords) { $c = int( $c + .5 ) }
is_deeply( \@coords, [ 150, 150, 150, 150 + 120 ], 'copy_to_line ok' );

$p2->notice();

# this is what happens if the starting point isn't on line2
$p->remove();
$p = Point->new( $cn, 120, 120 );
( $l4, my $p5 ) = $l1->copy_to_line( $p, $l2 );
is( int( $l4->length + .5 ), int( $l1->length + .5 ), 'copy_to_line length ok' );
@coords = $l4->end;
is( int( $coords[0] + .5 ), 150, 'copy_to_line endpoint ok' );

$p5->notice();
$l4->remove();
$p->remove();
$p = Point->new( $cn, 10, 10 );
( $l4, my $p6 ) = $l1->copy_to_line( $p, $l2 );
$p6->notice();
isa_ok( $l4, 'Line', 'copy_to_line no intersect ok' );

# cleanup
$l1->remove();
$l2->remove;
$p->remove;
$l3->remove;
$p2->remove;
$p5->remove;
$l4->remove;
$p6->remove;

# subtract
$l1 = Line->new( $cn, 50, 50, 170, 50 )->label( "A", "top" );
$l2 = Line->new( $cn, 150, 150, 150, 350 )->label( "B", "right" );
$cn->toplevel->update();
$l3 = $l2->subtract($l1);
is( int( $l3->length + .5 ), int( $l2->length - $l1->length + .5 ),
    'subtract length ok' );
@coords = $l3->endpoints;
for my $c (@coords) { $c = int( $c + .5 ) }
is_deeply( \@coords, [ 150, 150, 150, 350 - 120 ], 'subtract coords ok' );
$l3->notice();

$l1->remove();
$l2->remove();
$l3->remove();
$l1 = Line->new( $cn, 50, 50, 170, 50 )->label( "A", "top" );
$l2 = Line->new( $cn, 150, 150, 150, 350 )->label( "B", "right" );
$cn->toplevel->update();
$l3 = $l1->subtract($l2);
is_deeply( [ $l3->coords ], [ $l1->coords ], 'subtract cannot ok' );
$l3->notice();
$l3->remove();

# bisect
$p      = $l2->bisect();
@coords = $p->coords;
for my $c (@coords) { $c = int( $c + .5 ) }
is_deeply( \@coords, [ 150, 250 ], 'bisect ok' );
$p->notice();

# parallel
$l2 = Line->new( $cn, 75, 90, 50, 135 );
$l3 = $l2->parallel( Point->new( $cn, 200, 200 ) );
is( int( $l3->slope + .5 ), int( $l2->slope ), "parallel ok" );

# perpendicular (on line)
$l3->remove();
$l3 = $l2->perpendicular( Point->new( $cn, $l2->start ) );

# if perp, dot product should be approx 0
my @l2 = $l2->endpoints;
my @l3 = $l3->endpoints;
my $dot =
  ( ( $l2[2] - $l2[0] ) * ( $l3[2] - $l3[0] ) +
    ( $l2[3] - $l2[1] ) * ( $l3[3] - $l3[1] ) );
is( int($dot), 0, 'perpendicular on-line ok' );
$l4 = $l2->perpendicular( Point->new( $cn, $l2->end ), undef, 'negative' );
$l5 = Line->new( $cn, $l3->end, $l4->end );
is( int( $l5->slope ), int( $l2->slope ), 'perpendicular negative ok' );

# perpendicular (off line)
$l2->remove();
$l4->remove();
$l5->remove();
$l3->remove();
$l2 = Line->new( $cn, 117, 290, 350, 335 );
$p = Point->new( $cn, 250,150  );
$p->notice;
$l3 = $l2->perpendicular( $p );
$cn->toplevel->update;

# if perp, dot product should be approx 0
@l2 = $l2->endpoints;
@l3 = $l3->endpoints;
$dot =
  ( ( $l2[2] - $l2[0] ) * ( $l3[2] - $l3[0] ) +
    ( $l2[3] - $l2[1] ) * ( $l3[3] - $l3[1] ) );
is( int($dot), 0, 'perpendicular off line ok' );

############### FAST? ########################
$Shape::AniSpeed = 5000;
$Shape::DefaultSpeed = 1;

$l1=Line->new($cn,50,250,200,250,-1);
$l1->green;
$l1->rotateTo(90,-1);

$p = Point->new($cn,$l1->start);
$p2 = Point->new($cn,$l1->end);
$cn->toplevel->update;

$p2 = Point->new($cn,400,400);
$l2=$l1->copy($p2,-1);
$cn->toplevel->update;

$l2->remove();
$p2->remove();

sleep(1);
$p2=$l1->bisect(-1);
$cn->toplevel->update;
sleep(1);

$l1=Line->new($cn,150,550,300,550,-1);
$l1->red;
my $p3 = Point->new($cn,200,400);
$l4=$l1->parallel($p3,-1);
$cn->toplevel->update;
sleep(1);

$l4->remove;
$l4=$l1->perpendicular($p3,-1);
$cn->toplevel->update;
sleep(3);
