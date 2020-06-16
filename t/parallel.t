#!/usr/bin/perl
use strict;
use warnings;
$Shape::AniSpeed = 50;

use Test::More tests=>10;

use Geometry::Geometry;
use Tk;
    my $mw   = MainWindow->new();
    my $cn = $mw->Canvas( -bg => "white", -width => 800, -height => 700 )->pack();
    $cn->configure( "-scrollregion" => [ 0, 0, 1400, 800 ], -closeenough => 2.0 );

# ----------------------------------------------------------------------------
if (1) {
    my $top = 200;
    my $bot = 400;
    my @A = ( 230, $top );
    my @B = ( 125, $bot );
    my @D = ( 300, $top );
    my @F = ( 500, $bot );
    my @C = ( $B[0]+125, $bot );
    my @E = ( $F[0]-125, $bot );
    my @G = ($A[0]-150,$top);
    my @H = ($D[0]+150,$top);
    my $l1 = Line->new($cn,@A,@C);
    my $p1 = Point->new($cn,@B);
    my $l2 = $l1->parallel($p1);
    is(int($l1->slope-$l2->slope),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();

}

if (1) {
    my @D = ( 300, 200 );
    my @F = ( 500, 400 );
    my @E = ( $F[0]-125, 400 );
    my $l1 = Line->new($cn,@D,@E);
    my $p1 = Point->new($cn,@F);
    my $l2 = $l1->parallel($p1);
    is(int($l1->slope-$l2->slope),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();

}

if (1) {
{   
    my @A=(300,300);
    my @B=(500,300);
    my @C=(350,100);
    my $l1 = Line->new($cn,@A,@B);
    my $p1 = Point->new($cn,@C);
    my $l2 = $l1->parallel($p1);
    is(int($l1->slope-$l2->slope),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();
}
{   
    my @A=(300,300);
    my @B=(500,300);
    my @C=(525,100);
    my $l1 = Line->new($cn,@A,@B);
    my $p1 = Point->new($cn,@C);
    my $l2 = $l1->parallel($p1);
    is(int($l1->slope-$l2->slope),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();
}
{   
    my @B=(300,300);
    my @A=(500,300);
    my @C=(350,100);
    my $l1 = Line->new($cn,@A,@B);
    my $p1 = Point->new($cn,@C);
    my $l2 = $l1->parallel($p1);
    is(int($l1->slope-$l2->slope),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();
}

{   
    my @B=(300,300);
    my @A=(500,300);
    my @C=(350,500);
    my $l1 = Line->new($cn,@A,@B);
    my $p1 = Point->new($cn,@C);
    my $l2 = $l1->parallel($p1);
    is(int($l1->slope-$l2->slope),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();
}

}

if(1){   
    my @A=(200,300);
    my @B=(550,350);
    my @C=(350,150);
    my $l1 = Line->new($cn,@A,@B);
    my $p1 = Point->new($cn,@C);
    my $l2 = $l1->parallel($p1);
    is(int($l1->slope-$l2->slope),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();
}
if(1){   
   
    my @A=(200,300);
    my @B=(500,300);
    my @C=(350,100);
    my $l1 = Line->new($cn,@A,@B);
    my $p1 = Point->new($cn,@C);
    my $l2 = $l1->parallel($p1);
    is(int($l1->slope-$l2->slope),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();
}
if(1){
        my @A=(300,150);
    my @B=(300,350);
    my @C=(50,250);
    my $l1 = Line->new($cn,@A,@B);
    my $p1 = Point->new($cn,@C);
    my $l2 = $l1->parallel($p1);
    my $s = $l2->slope;
    if (abs($s) > 2500) {$s = $s> 0 ? 1e6: -1e6}
    is(int(abs($l1->slope)-abs($s)),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();
}

if(1){
        my @A=(300,150);
    my @B=(300,350);
    my @C=(650,250);
    my $l1 = Line->new($cn,@A,@B);
    my $p1 = Point->new($cn,@C);
    my $l2 = $l1->parallel($p1);
    my $s = $l2->slope;
    if (abs($s) > 2500) {$s = $s> 0 ? 1e6: -1e6}
    is(int(abs($l1->slope)-abs($s)),0);
    $l2->remove();
    $l1->remove();
    $p1->remove();
}
