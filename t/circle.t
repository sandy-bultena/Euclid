#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 15;

use Geometry::Circle;
use Geometry::Point;
use Geometry::Validate;
$Validate::QUIET_MODE = 1;


$Shape::AniSpeed = 50;
use Tk;
my $mw = MainWindow->new();
my $cn = $mw->Canvas( -bg => "white", -width => 800, -height => 700 )->pack();
$cn->configure( "-scrollregion" => [ 0, 0, 800, 700 ], -closeenough => 2.0 );
if (1) {

{
    my @A = ( 300, 300 );
    my @B = ( 500, 300 );
    my $c1 = Circle->new( $cn, @A, @B, -1 );
    isa_ok( $c1, 'Circle', 'new' );
    can_ok( $c1, qw(new draw intersect notice grey red green normal) );
    $cn->delete('all');
    $cn->update;
}

# ----------------------------------------------------------------------------
# move
# ----------------------------------------------------------------------------
{
    my @A = ( 120, 90 );
    my @B = ( 200, 90 );
    my $c1 = Circle->new( $cn, @A, @B);
    my @old = $c1->center;
    $cn->update;
    sleep(1);
    $c1->move(50,90);
    my @new = $c1->center;
    is_deeply(\@new,[$old[0]+50,$old[1]+90],"new circle center ok after move");
    sleep(1);
    $cn->delete('all');
    $cn->update;
}

# ----------------------------------------------------------------------------
# Circle intersections
# ----------------------------------------------------------------------------
{
    my @A = ( 300, 300 );
    my @B = ( 500, 300 );
    my $c1 = Circle->new( $cn, @A, @B);
    my $c2 = Circle->new( $cn, @B, @A );
    my @p  = $c1->intersect($c2);
    my $p1 = Point->new( $cn, @p[ 0, 1 ] );
    my $p2 = Point->new( $cn, @p[ 2, 3 ] );
    sleep(1);
    is( scalar(@p), 4, 'horizontal intersection' );
    $cn->delete('all');
}
{
    my @A = ( 300, 300 );
    my @B = ( 300, 500 );
    my $c1 = Circle->new( $cn, @A, @B );
    my $c2 = Circle->new( $cn, @B, @A );
    my @p  = $c1->intersect($c2);
    my $p1 = Point->new( $cn, @p[ 0, 1 ] );
    my $p2 = Point->new( $cn, @p[ 2, 3 ] );
    is( scalar(@p), 4, 'vertical intersection' );
    sleep(1);
    $cn->delete('all');
}
{
    my @A = ( 300, 300 );
    my @B = ( 500, 300 );
    my @C = ( 400, 300 );
    my $c1 = Circle->new( $cn, @A, @C );
    my $c2 = Circle->new( $cn, @B, @C );
    my @p  = $c1->intersect($c2);
    my $p1 = Point->new( $cn, @p[ 0, 1 ] );
    my $p2 = Point->new( $cn, @p[ 2, 3 ] );
    is( scalar(@p), 4, 'horizontal intersection just touch' );
    sleep(1);
    $cn->delete('all');
}
{
    my @A = ( 300, 300 );
    my @B = ( 300, 500 );
    my @C = ( 300, 400 );
    my $c1 = Circle->new( $cn, @A, @C );
    my $c2 = Circle->new( $cn, @B, @C );
    my @p  = $c1->intersect($c2);
    my $p1 = Point->new( $cn, @p[ 0, 1 ] );
    my $p2 = Point->new( $cn, @p[ 2, 3 ] );
    is( scalar(@p), 4, 'vertical intersection just touch' );
    sleep(1);
    $cn->delete('all');
}
{
    my @A = ( 300, 300 );
    my @B = ( 500, 500 );
    my @C = ( 400, 300 );
    my $c1 = Circle->new( $cn, @A, @B );
    my $c2 = Circle->new( $cn, @B, @A );
    my @p  = $c1->intersect($c2);
    my $p1 = Point->new( $cn, @p[ 0, 1 ] );
    my $p2 = Point->new( $cn, @p[ 2, 3 ] );
    is( scalar(@p), 4, 'intersect 45' );
    sleep(1);
    $cn->delete('all');
}
{
    my @A = ( 300, 300 );
    my @B = ( 500, 100 );
    my @C = ( 400, 300 );
    my $c1 = Circle->new( $cn, @A, @B);
    my $c2 = Circle->new( $cn, @B, @A );
    my @p  = $c1->intersect($c2);
    my $p1 = Point->new( $cn, @p[ 0, 1 ] );
    my $p2 = Point->new( $cn, @p[ 2, 3 ] );
    is( scalar(@p), 4, 'intersect -45' );
    sleep(1);
    $cn->delete('all');
}
{
    my @A = ( 300, 300 );
    my @B = ( 350, 350 );
    my @C = ( 500, 300 );
    my @D = ( 450, 350 );
    my $c1 = Circle->new( $cn, @A, @C );
    my $c2 = Circle->new( $cn, @B, @D );
    my @p  = $c1->intersect($c2);
    is( scalar(@p), 0, 'do not touch inner' );
    sleep(1);
    $cn->delete('all');
}
{
    my @A = ( 300, 300 );
    my @B = ( 600, 350 );
    my @C = ( 350, 300 );
    my @D = ( 700, 350 );
    my $c1 = Circle->new( $cn, @A, @C );
    my $c2 = Circle->new( $cn, @B, @D );
    my @p  = $c1->intersect($c2);
    is( scalar(@p), 0, 'do not touch outer' );
    sleep(1);
    $cn->delete('all');
}
}
{
    my ($x1,$y1,$x2,$y2,$r) = (300,300,500,300,250);
    my $c1 = Circle->new( $cn,$x1, $y1, $x1 + $r, $y1 )->grey;
    my $c2 = Circle->new( $cn,$x2, $y2, $x2 + $r, $y1 )->grey;
    my @ps = $c1->intersect($c2);
    Point->new($cn,@ps[0,1])->notice;
    Point->new($cn,@ps[2,3])->notice;
    sleep(1);
    $cn->delete('all');
}

{
    my ($x1,$y1,$x2,$y2,$r) = (300,300,300,500,250);
    my $c1 = Circle->new( $cn,$x1, $y1, $x1 + $r, $y1 )->grey;
    my $c2 = Circle->new( $cn,$x2, $y2, $x2 + $r, $y1 )->grey;
    my @ps = $c1->intersect($c2);
    is_deeply(\@ps,[50,300,550,300],"intersect d1 = 0 ok");
    sleep(1);
    $cn->delete('all');
}

# ----------------------------------------------------------------------------
# Line intersections
# ----------------------------------------------------------------------------
{
    my @A = ( 300, 300 );
    my @B = ( 500, 300 );
    my $c1 = Circle->new( $cn, @A, @B, -1 );
    my $c2 = Line->new( $cn, @B, @A, -1 );
    my @p = $c1->intersect($c2);
    is( scalar(@p), 2, 'line intersection 1 point' );
    my $p1 = Point->new( $cn, @p[ 0, 1 ] );
    sleep(1);
    $c1->remove();
    $c2->remove();
    $p1->remove();
}
{
    my @A = ( 300, 300 );
    my @B = ( 500, 300 );
    my @C = ( 200, 510 );
    my $c1 = Circle->new( $cn, @A, @B, -1 );
    my $c2 = Line->new( $cn, @B, @C, -1 );
    my @p = $c1->intersect($c2);
    is( scalar(@p), 4, 'line intersection 2 pts' );
    my $p1 = Point->new( $cn, @p[ 0, 1 ] );
    my $p2 = Point->new( $cn, @p[ 2, 3 ] );
    sleep(1);
    $c1->remove();
    $c2->remove();
    $p1->remove();
    $p2->remove();
}
{
    my @A = ( 300, 300 );
    my @B = ( 500, 300 );
    my @C = ( 300, 510 );
    my @D = ( 500, 510 );
    my $c1 = Circle->new( $cn, @A, @B, -1 );
    my $c2 = Line->new( $cn, @C, @D, -1 );
    my @p = $c1->intersect($c2);
    is( scalar(@p), 0, 'line no intersection' );
    sleep(1);
    $c1->remove();
    $c2->remove();
}
