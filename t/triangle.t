#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw(no_plan);    #tests => 31;
$Shape::DefaultSpeed = $Shape::DefaultSpeed * 3;
$Shape::AniSpeed     = 50;

use Tcl::Tk;
use Tk::Canvas;

my $int = new Tcl::Tk;
my $mw   = $int->mainwindow;

use Geometry::Geometry;
use Geometry::Bitmap::NormalText;


use Carp;
our @CARP_NOT;

# create a canvas object
my $cn = $mw->Canvas( -bg => "white", -width => 800, -height => 700 )->pack();
$cn->configure( "-scrollregion" => [ 0, 0, 800, 700 ], -closeenough => 2.0 );

# is my canvas a canvas? ... why do I need to call this before it is a real canvas?
$cn->createText(30,30,-text=>"hello");
    $cn->toplevel->update;
    $cn->delete('all');

if ($cn && ref($cn) && $cn->can('createText')) {
    ok("1","Canvas passes test");
    
}
else {
    ok("0","Canvas passes test");
}    
if (0) {
    my $line = eval{bless( {
                 '-objects' => [
                                 
                               ],
                 '-fast' => 1,
                 '-colour' => 'normal',
                 '-label' => undef,
                 '-m' => '1000000',
                 '-y1' => 40,
                 '-x1' => 240,
                 '-cn' => $cn,
                 '-dash' => 0,
                 '-x2' => '239.967958267691',
                 '-sign' => -1,
                 '-y2' => '60.0000000189061'
               }, 'Line' );
    };
    my $pt = eval { bless(
        {
                 '-label' => [
                               168
                             ],
                 '-y' => '60.0000000208051',
                 '-cn' => $cn,
                 '-x' => '247.999976417982',
                 'Shape::what' => 'p44',
                 'Shape::where' => 'right',
                 '-objects' => [
                                 
                               ]
               }, 'Point' );
    };
    $line->draw;
    $pt->draw;
    my $l = $line->parallel( $pt )->blue;
    sleep(50);
}

if (0) {
    my @points = eval {bless( {
                                         '-objects' => [
                                                         7788
                                                       ],
                                         '-x' => '159.999988074879',
                                         '-label' => undef,
                                         '-colour' => 'grey',
                                         '-cn' => $cn,
                                         '-y' => '59.9999999999983'
                                       }, 'Point' ),
                                bless( {
                                         '-cn' => $cn,
                                         '-colour' => 'grey',
                                         '-y' => '39.9999999937124',
                                         '-x' => '160.000138564065',
                                         '-label' => undef,
                                         '-objects' => [
                                                         7789
                                                       ]
                                       }, 'Point' ),
                                bless( {
                                         '-objects' => [
                                                         7790
                                                       ],
                                         '-label' => undef,
                                         '-x' => 240,
                                         '-colour' => 'grey',
                                         '-y' => 40,
                                         '-cn' => $cn,
                                       }, 'Point' ),
                                bless( {
                                         '-x' => '239.967958267691',
                                         '-label' => undef,
                                         '-objects' => [
                                                         7791
                                                       ],
                                         '-y' => '60.0000000189061',
                                         '-colour' => 'grey',
                                         '-cn' => $cn,
                                       }, 'Point' )
    };
    
    my $poly = Polygon->join(4,@points);
    bless ($poly,"Parallelogram");
    
    my $line = Line->new($cn,80,92,280,92);
    $poly->copy_to_line($line);
    sleep(10);
}


# ===========================
# copy_to_parallelogram_on_line
# ===========================
if (0) {
    my @A = (120,80);
    my @B = (340,140);
    my @C = (160,140);
    my @D = (140,560);
    my @E = (80,540);
    my @F = (240,560);
    
    # need a right angle
    my $l1 = Line->new( $cn, 10, 40, 40, 40 );
    my $l2 = Line->new( $cn, 10, 40, 10, 10 );
    my $right = Angle->new( $cn, $l1, $l2 );

    # triangle
    my $tri = Triangle->new($cn,@A,@B,@C);
    my $line = Line->new($cn,67,427,267,427);
    
    # new polygon
  #  my $new = $tri->copy_to_parallelogram_on_line($line,$right);
  #  my $area = $tri->area;
  #  my $new_area = $new->area;
    
    # are the two areas within 1% of each other? (lots of round off errors)
  #  cmp_ok(abs($new_area-$area)/$area,"<",.01,"copy_to_parallelogram_on_line: Area of polygon within 1% of initial polygon");
    
  #  sleep(10);
  #  $new->remove;
  #  $l1->remove;
  #  $l2->remove;
  #  $right->remove;
  #  $line->remove;
  #  $tri->remove;

    # triangle
   $tri = Triangle->new($cn,@D,@E,@F);
   $line = Line->new($cn,80,92,280,92);
    
    # new polygon
    my $new = $tri->copy_to_parallelogram_on_line($line,$right);
    my $area = $tri->area;
    my $new_area = $new->area;
    
    # are the two areas within 1% of each other? (lots of round off errors)
    cmp_ok(abs($new_area-$area)/$area,"<",.01,"copy_to_parallelogram_on_line: Area of polygon within 1% of initial polygon");
    
    # is the angle correct?
    cmp_ok(abs($new->angle_value(1)-$right->arc),"<",0.1,"copy_to_parallelogram_on_point: Angle of polygon within 0.1 of specified angle");
    cmp_ok(abs($new->angle_value(1)-$new->angle_value(3)),"<",.1,"copy_to_parallelogram_on_line: First and third angle equal");
    cmp_ok(abs($new->angle_value(2)-$new->angle_value(4)),"<",.1,"copy_to_parallelogram_on_line: Second and fourth angle equal");
    
    sleep(50);
    $tri->remove;
    $new->remove;
    $l1->remove;
    $l2->remove;
    $right->remove;
    $line->remove;

}

