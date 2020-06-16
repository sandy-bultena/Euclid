#!/usr/bin/perl
use strict;
use warnings;

use Test::More qw(no_plan);

use Geometry::Arc;
use Geometry::Validate;
#$Validate::QUIET_MODE = 1;


$Shape::AniSpeed = 50;
use Tcl::Tk;
    my $int = new Tcl::Tk;
my $mw = $int->mainwindow();
my $cn = $mw->Canvas( -bg => "white", -width => 800, -height => 700 )->pack();
$cn->configure( "-scrollregion" => [ 0, 0, 800, 700 ], -closeenough => 2.0 );

if(1){
    my @A = ( 300, 300 );
    my @B = ( 500, 300 );
    Point->new($cn,@A)->label("A","top");
    Point->new($cn,@B)->label("B","top");
    my $c1 = Arc->new( $cn, 250,@A, @B,);
    my $c2 = Arc->new( $cn, 250,@B, @A,)->red;
    my $c3 = Arc->semi_circle( $cn, @A, @B,);
    my $c4 = Arc->semi_circle( $cn, @B, @A,)->red;
    $cn->update;
    isa_ok( $c1, 'Arc', 'new' );
    can_ok( $c1, qw(new draw intersect notice grey red green normal) );
    sleep(1);
}

if(1){
    my @A = ( 300, 290 );
    my @B = ( 500, 300 );
    Point->new($cn,@A)->label("A","top");
    Point->new($cn,@B)->label("B","top");
    my $c1 = Arc->new( $cn, 250,@A, @B,);
    my $c2 = Arc->new( $cn, 250,@B, @A,)->red;
    my $c3 = Arc->semi_circle( $cn, @A, @B,);
    my $c4 = Arc->semi_circle( $cn, @B, @A,)->red;
    $cn->update;
    isa_ok( $c1, 'Arc', 'new' );
    can_ok( $c1, qw(new draw intersect notice grey red green normal) );
    sleep(1);
}

if(1){
    my @A = ( 300, 310 );
    my @B = ( 500, 300 );
    Point->new($cn,@A)->label("A","top");
    Point->new($cn,@B)->label("B","top");
    my $c1 = Arc->new( $cn, 250,@A, @B,);
    my $c2 = Arc->new( $cn, 250,@B, @A,)->red;
    my $c3 = Arc->semi_circle( $cn, @A, @B,);
    my $c4 = Arc->semi_circle( $cn, @B, @A,)->red;
    $cn->update;
    isa_ok( $c1, 'Arc', 'new' );
    can_ok( $c1, qw(new draw intersect notice grey red green normal) );
    sleep(1);
    $cn->delete('all');
}

{
    my @A = ( 300, 300 );
    my @B = ( 300, 500 );
    Point->new($cn,@A)->label("A","left");
    Point->new($cn,@B)->label("B","right");
    my $c1 = Arc->new( $cn, 250,@A, @B,);
    my $c2 = Arc->new( $cn, 250,@B, @A,)->red;
    my $c3 = Arc->semi_circle( $cn, @A, @B,);
    my $c4 = Arc->semi_circle( $cn, @B, @A,)->red;
    $cn->update;
    isa_ok( $c1, 'Arc', 'new' );
    can_ok( $c1, qw(new draw intersect notice grey red green normal) );
    sleep(1);
}
{
    my @A = ( 300, 300 );
    my @B = ( 290, 500 );
    Point->new($cn,@A)->label("A","left");
    Point->new($cn,@B)->label("B","right");
    my $c1 = Arc->new( $cn, 250,@A, @B,);
    my $c2 = Arc->new( $cn, 250,@B, @A,)->red;
    my $c3 = Arc->semi_circle( $cn, @A, @B,);
    my $c4 = Arc->semi_circle( $cn, @B, @A,)->red;
    $cn->update;
    isa_ok( $c1, 'Arc', 'new' );
    can_ok( $c1, qw(new draw intersect notice grey red green normal) );
    sleep(1);
}

{
    my @A = ( 300, 300 );
    my @B = ( 310, 500 );
    Point->new($cn,@A)->label("A","left");
    Point->new($cn,@B)->label("B","right");
    my $c1 = Arc->new( $cn, 250,@A, @B,);
    my $c2 = Arc->new( $cn, 250,@B, @A,)->red;
    my $c3 = Arc->semi_circle( $cn, @A, @B,);
    my $c4 = Arc->semi_circle( $cn, @B, @A,)->red;
    $cn->update;
    isa_ok( $c1, 'Arc', 'new' );
    can_ok( $c1, qw(new draw intersect notice grey red green normal) );
    sleep(1);
}
