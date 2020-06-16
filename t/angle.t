#!/usr/bin/perl
use strict;
use warnings;

use Tk;
use Geometry::Line;
use Geometry::Angle;
$Shape::DefaultSpeed = $Shape::DefaultSpeed * 3;
$Shape::AniSpeed     = 50;
use Test::More tests => 19;

# create a canvas object
my $mw = MainWindow->new();
my $cn = $mw->Canvas()->pack();

# create and draw two lines that MUST intersect at an endpoint
# of each line
my $line1 = Line->new( $cn, 10, 10, 10,  100 );
my $line2 = Line->new( $cn, 10, 10, 100, 100 );

# did we calculate the arc length properly?
is( Angle->calculate( $line1, $line2 ), 45,  'calculate 1' );
is( Angle->calculate( $line2, $line1 ), 315, 'calculate 2' );

# create, draw and label the angle between the two lines
my $alpha = Angle->new( $cn, $line1, $line2 );
isa_ok( $alpha, 'Angle', 'new' );
can_ok( $alpha, qw(new draw copy label arc notice grey red green normal calculate) );
$mw->update();
sleep(1);
$alpha = $alpha->label("A");
isa_ok( $alpha, 'Angle', 'label' );
$mw->update();
sleep(1);
$alpha->label("B",60);
$mw->update();
sleep(1);

# did we calculate the arc length properly?
is( $alpha->arc(), 45, 'Arc length' );

# draw line, and copy angle to it
my $line3 = Line->new( $cn, 10, 200, 100, 200 );
my $point = Point->new( $cn, 10, 200 );
my ( $l, $a ) = $alpha->copy( $point, $line3 );
$mw->update();
sleep(1);
isa_ok( $a, 'Angle', 'copy' );
is( int( $a->arc + .5 ), $alpha->arc, "copy - equal angle" );

( $l, $a ) = $alpha->copy( $point, $line3, 'negative' );
$mw->update();
sleep(1);
isa_ok( $a, 'Angle', 'copy negative' );
isa_ok( $l, 'Line',  'copy negative' );
is( int( $a->arc + .5 ), $alpha->arc, "copy - equal angle - negative" );

# do we catch ok when two lines don't meet at point?
my ( $x, $y, $v1, $v2 ) = Angle->angle_coords( $line1, $line2 );
is( $x, 10, 'vertex x' );
is( $y, 10, 'vertex y' );
is_deeply( $v1, [ 0,  -90 ], 'vector 1' );
is_deeply( $v2, [ 90, -90 ], 'vector 2' );

#
my $line5 = Line->new( $cn, 20, 10, 10,  100 );
my $line4 = Line->new( $cn, 30, 10, 100, 100 );
( $x, $y, $v1, $v2 ) = Angle->angle_coords( $line5, $line4 );
is( $x, undef, 'no common vertex x' );
is( $y, undef, 'no common vertex y' );

# bisect the angle
my ( $line, @others ) = $alpha->bisect();
isa_ok( $line, 'Line', 'bisect' );
my $b      = Angle->new( $cn, $line, $line2 );
my $newarc = $b->arc;
my $oldarc = $alpha->arc;
is( $newarc, $oldarc / 2, 'bisect - half angle' );
$mw->update();
sleep(1);

############### FAST? ########################
$Shape::AniSpeed = 50000;
$Shape::DefaultSpeed = 1;

$line->remove;
$b->remove;
( $line, @others ) = $alpha->bisect(-1);
$mw->update();
sleep(3);

