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
my $cn = $mw->Canvas( -bg => "white", -width => 1000, -height => 700 )->pack();
$cn->configure( "-scrollregion" => [ 0, 0, 800, 700 ], -closeenough => 2.0 );

my $poly;

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

=head1 Creating/drawing

  new       ($canvas, $sides, $x1,$y1, ... $xn,$yn)
  assemble  ($sides, -lines=>[$line_obj1, ... $line_objn])

=cut

if (1) {
    local $Validate::QUIET_MODE = 1;

    # new
    my $s1 = Polygon->new( $cn, 3, 50, 50, 150, 350, 200, 200 );
    isa_ok( $s1, 'Polygon', 'new ok' );
    can_ok( $s1, qw(new assemble) );

    # new - bad inputs
    $s1 = Polygon->new( $cn, 3, 50, 50, 150, 350, 200 );
    is( $s1, undef, 'bad inputs to new' );
    $s1 = Polygon->new( $cn, 3, 50, 50, 150, 350, 200, "abc" );
    is( $s1, undef, 'bad inputs to new' );

    # assemble - ok
    my @A = ( 30,  30 );
    my @B = ( 390, 30 );
    my @C = ( 200, 400 );
    my @D = ( 210, 400);

    my $l1 = Line->new( $cn, @A, @B );
    my $l2 = Line->new( $cn, @B, @C );
    my $l3 = Line->new( $cn, @C, @A );
    my $l4 = Line->new( $cn, @C, @D );
    my $p1 = Point->new( $cn, @A )->label("A");
    my $p2 = Point->new( $cn, @B )->label("B");
    my $p3 = Point->new( $cn, @C )->label("C");
    my $a1 = Angle->new( $cn, $l1, $l2 )->label("a");
    my $a2 = Angle->new( $cn, $l2, $l3 )->label("b");
    my $a3 = Angle->new( $cn, $l3, $l1 )->label("c");

    my $s2 = Polygon->assemble(
                                $cn, 3,
                                -lines  => [ $l1, $l2, $l3 ],
                                -fill   => 'pink',
                                -points => [ $p1, $p2, $p3 ],
                                -angles => [ $a1, $a2, $a3 ]
                              );
    $cn->toplevel->update;
    sleep(1);

    isa_ok( $s2, 'Polygon', 'assemble ok' );
    is( $s2->l(1), $l1, "line same for assemble" );
    is( $s2->a(1), $a1, "angle same for assemble" );
    is( $s2->p(1), $p1, "point same for assemble" );

    # assemble - bad input - number lines doesn't equal number of sides
    $s2 = Polygon->assemble(
                                $cn, 3,
                                -lines  => [ $l1, $l2, $l3, $l4 ],
                              );
    is( $s2, undef, "assemble bad line number failed ok" );

    # assemble - bad input - lines don't connect
    $s2 = Polygon->assemble(
                                $cn, 3,
                                -lines  => [ $l1, $l2, $l3, $l3 ],
                              );
    is( $s2, undef, "assemble lines don't connect failed ok" );
    $cn->toplevel->update;
    $cn->delete('all');
}

=head1 Additional Properties

  set_points ($text1,$pos1, $text2,$pos2... )
  set_labels ($text1,$pos1, $text2,$pos2 ... )
  set_angles ($text1,$text2, ... $size1,$size2 ... )

=cut

if (1) {
    my @D = ( 30,  30 );
    my @C = ( 390, 30 );
    my @A = ( 150, 400 );
    my @B = ( 250, 400);
    $poly = Polygon->new( $cn, 4, @A,@B,@C,@D );
    can_ok( $poly, qw(set_points set_labels set_angles) );
    
    $poly->set_angles(qw(A B C D));
    $poly->set_labels(qw(a bottom b right c top d left));
    $poly->set_points(qw(A bottom B bottom C top D top));
    $cn->toplevel->update;
    
    is ($poly->l(1)->label_is,"a","line 1 label set ok");
    is ($poly->a(1)->label_is,"A","angle 1 label set ok");
    is ($poly->p(1)->label_is,"A","point 1 label set ok");
    $cn->toplevel->update;
    sleep(1);

    $cn->delete('all');     
}

=head1 Access components of the Polygon
  
  lines  ( )
  points ( ) 
  angles ( )
  a      ( $i )
  l      ( $i )
  p      ( $i )
  coords ( )

=cut

if (1) {
    my @D = ( 30,  30 );
    my @C = ( 390, 30 );
    my @A = ( 200, 400 );
    my @B = ( 250, 400);
    my $s1 = Polygon->new( $cn, 4, @A,@B,@C,@D )->set_angles(" "," "," "," ");
    can_ok( $s1, qw(lines points angles a l p coords) );
    sleep(1);

    # lines
    my @lines = $s1->lines;
    is_deeply([$lines[0]->coords],[@A,@B],"coords line 1 ok");
    is_deeply([$lines[1]->coords],[@B,@C],"coords line 2 ok");
    is_deeply([$lines[2]->coords],[@C,@D],"coords line 3 ok");
    is_deeply([$lines[3]->coords],[@D,@A],"coords line 4 ok");
    is ($lines[0],$s1->l(1),"line 1 ok");
    $s1->l(1)->notice;
    
    # points
    my @points = $s1->points;
    is_deeply([$points[0]->coords],[@A],"coords point 1 ok");
    is_deeply([$points[1]->coords],[@B],"coords point 2 ok");
    is_deeply([$points[2]->coords],[@C],"coords point 3 ok");
    is_deeply([$points[3]->coords],[@D],"coords point 4 ok");
    is ($points[0],$s1->p(1),"point 1 ok");
    $s1->p(1)->notice;
    
    # angles
    my @angles = $s1->angles;
    is ($angles[0],$s1->a(1),"angle 1 ok");
    my @als = $s1->a(1)->lines;
    is ($als[0],$s1->l(1),"line for angle ok");
    $s1->a(1)->notice;
    
    # coords
    is_deeply([$s1->coords],[@A,@B,@C,@D,@A],"coords ok");
    $cn->delete('all');     
}

=head1 Drawing (or redrawing)

  draw         ( [$speed] )
  points_draw  ( )
  lines_draw   ( )
  angles_draw  ( )
  move         ( $x, $y, [$inc, [$speed]] )
  rotate       ( $x, $y, $angle, [$inc, [$speed]] )
  copy_to_rectangle ($point [$speed])  

Removing from canvas

  remove        ( )
  remove_angles ( )
  remove_lines  ( )
  remove_points ( )
  remove_labels ( )

=cut


if (1){
    my @D = ( 110,  30 );
    my @C = ( 290, 30 );
    my @A = ( 100, 400 );
    my @B = ( 300, 400);
    my $os = $cn->find("all"); # Tcl::List
    my $s1 = Polygon->new( $cn, 4, @A,@B,@C,@D,1,
    -labels=>[qw(a bottom b right c top d left)],
    -angles=>[qw(A B C D)],-points=>[qw(A bottom B bottom C top D top)] );
    $s1->fill("pink");
    can_ok( $s1, qw(draw points_draw lines_draw angles_draw move rotate copy_to_rectangle) );
    $cn->toplevel->update;
    $os = $cn->find("all"); # returns a Tcl::List
    my $num_objs = scalar (@$os);
    
    sleep(1);

    # remove stuff, and redraw the polygon, everything should re-appear
    $s1->remove_angles;
    $s1->remove_points;
    $s1->remove_lines;
    $os = $cn->find("all"); # returns a Tcl::List
    is (scalar(@$os),1,'removed polygon piecemeal ok');  # canvas polygon still exists!
    sleep(1);
    
    
    $s1->points_draw;
    $os = $cn->find("all"); # returns a Tcl::List
    is (scalar(@$os),1+2*4,'points redrawn ok');
    sleep(1);
    $s1->lines_draw;
    $os = $cn->find("all");
    is (scalar(@$os),1+2*4+2*4,'lines redrawn ok');
    $s1->angles_draw;
    $os = $cn->find("all");
    is (scalar(@$os),1+2*4+2*4+2*4,'angles redrawn ok');
    sleep(1);
    
    is($s1->p(4)->label_is,'D','point 4 label redrawn ok');  
    is($s1->a(4)->label_is,'D','angle 4 label redrawn ok');  
    is($s1->l(4)->label_is,'d','line 4 label redrawn ok');  
    $s1->remove;
    $os = $cn->find("all"); # when no objects, no Tcl::List, just empty string
    is ($os,"",'removed polygon ok');  # canvas polygon doesn't exist
    sleep(1);

    $s1->draw;
    $os = $cn->find("all");
    is (scalar(@$os),$num_objs,'redrawn 2 ok');
    is($s1->p(4)->label_is,'D','point 4 label redrawn ok');  
    is($s1->a(4)->label_is,'D','angle 4 label redrawn ok');  
    is($s1->l(4)->label_is,'d','line 4 label redrawn ok');  
    sleep(1);

    # move
    my @s = $s1->coords;
    $s1->move( 100, 50, 10 );
    my @c = $s1->coords;
    @s = ($s[0]+100, $s[1]+50, $s[2]+100, $s[3]+50, $s[4]+100, $s[5]+50,
          $s[6]+100, $s[7]+50, $s[8]+100, $s[9]+50);
    is_deeply(\@c,\@s,"move coords ok");    
    sleep(1);

    # rotate
    my @pre = $s1->coords;
    $s1->rotate($B[0]+100,$B[1]+50,180,10);
    my @rot = $s1->coords;
    is(scalar(@rot),scalar(@pre),"rotate - perserve number of coords ok");
    is_deeply([@rot[0..3]],[$pre[0]+2*($pre[2]-$pre[0]),$pre[1],$pre[2],$pre[3]],"rotate - A,B coords ok");
    sleep(1);

    $cn->delete('all');     
    sleep(1);
}

# ====================
# angle value
# ====================
if (1) {
    # create hourglass shape
    my @A = (10,10);
    my @B = (110,10);
    my @C = (70,50);
    my @D = (110,90);
    my @E = (10,90);
    my @F = (50,50);
    
    # A->F
    my $poly = Polygon->new($cn,6,@A,@B,@C,@D,@E,@F);
    is ($poly->angle_value(1),45,"A-F: Angle 1");
    is ($poly->angle_value(2),45,"A-F: Angle 2");
    is ($poly->angle_value(3),270,"A-F: Angle 3");
    is ($poly->angle_value(4),45,"A-F: Angle 4");
    is ($poly->angle_value(5),45,"A-F: Angle 5");
    is ($poly->angle_value(6),270,"A-F: Angle 6");
    $poly->remove;

    # F->A
    $poly = Polygon->new($cn,6,@F,@E,@D,@C,@B,@A);
    is ($poly->angle_value(1),270,"F-A: Angle 1");
    is ($poly->angle_value(2),45,"F-A: Angle 2");
    is ($poly->angle_value(3),45,"F-A: Angle 3");
    is ($poly->angle_value(4),270,"F-A: Angle 4");
    is ($poly->angle_value(5),45,"F-A: Angle 5");
    is ($poly->angle_value(6),45,"F-A: Angle 6");

    # A->F->B
    $poly = Polygon->new($cn,6,@A,@F,@E,@D,@C,@B);
    is ($poly->angle_value(1),45,"A->F->B: Angle 1");
    is ($poly->angle_value(2),270,"A->F->B: Angle 2");
    is ($poly->angle_value(3),45,"A->F->B: Angle 3");
    is ($poly->angle_value(4),45,"A->F->B: Angle 4");
    is ($poly->angle_value(5),270,"A->F->B: Angle 5");
    is ($poly->angle_value(6),45,"A->F->B: Angle 6");
    
    
    sleep(1);

}
# ===========================
# copy_to_triangles
# ===========================
if (1) {
    my @A = (10,10);
    my @B = (110,10);
    my @C = (70,50);
    my @D = (110,90);
    my @E = (10,90);
    my @F = (50,50);
    
    my $poly = Polygon->new($cn,6,@A,@B,@C,@D,@E,@F);
    my @triangles = $poly->copy_to_triangles;
    my @tcoords = ( [@F,@A,@B,@F],[@F,@B,@C,@F],[@C,@D,@E,@C],[@C,@E,@F,@C]);
    foreach my $i (0 .. 3) {
        my @c = $triangles[$i]->coords;
        is_deeply(\@c,$tcoords[$i],"triangle $i coordinates");
    }
    sleep(1);
    $poly->remove;
    foreach my $t (@triangles) {$t->remove;}
}

# ===========================
# area (relies on copy to triangles)
# ===========================
if (1) {
    my @A = (120,80);
    my @B = (240,80);
    my @C = (400,200);
    my @D = (320,260);
    my @E = (40,260);
    my @F = (40,200);
    
    my $efy = abs($E[1]-$F[1]);
    my $edx = abs($E[0]-$D[0]);
    my $dcx = abs($D[0]-$C[0]);
    my $bcx = abs($B[0]-$C[0]);
    my $bfy = abs($B[1]-$F[1]);
    my $fax = abs($F[0]-$A[0]);
    my $abx = abs($A[0]-$B[0]);
    
    my $area = $efy*$edx + (1/2)*$dcx*$efy + (1/2)*$bcx*$bfy
    + (1/2)*$fax*$bfy + $abx*$bfy;
    
    # polygon
    my $poly = Polygon->new($cn,6,@A,@B,@C,@D,@E,@F);
    
    # is the area calculation good?
    is($poly->area,$area,"Area: calculated correctly");
    
    sleep(1);
    $poly->remove;
}

# ===========================
# copy_to_parallelogram_on_line
# ===========================
if (1) {
    my @A = (120,80);
    my @B = (240,80);
    my @C = (400,200);
    my @D = (320,260);
    my @E = (40,260);
    my @F = (40,200);
    
    # need a right angle
    my $l1 = Line->new( $cn, 10, 40, 40, 40 );
    my $l2 = Line->new( $cn, 10, 40, 10, 10 );
    my $right = Angle->new( $cn, $l1, $l2 );

    # polygon
    my $poly = Polygon->new($cn,6,@A,@B,@C,@D,@E,@F);
    my $line = Line->new($cn,40,400,240,400);
    
    # new polygon
    my $new = $poly->copy_to_parallelogram_on_line($line,$right);
    my $area = $poly->area;
    my $new_area = $new->area;
    
    # are the two areas within 1% of each other? (lots of round off errors)
    cmp_ok(abs($new_area-$area)/$area,"<",.01,"copy_to_parallelogram_on_line: Area of polygon within 1% of initial polygon");
    
    sleep(1);
    $new->remove;
    $l1->remove;
    $l2->remove;
    $right->remove;
    $line->remove;

    $line = Line->new($cn,240,400,40,400);
    
    # new polygon
    $new = $poly->copy_to_parallelogram_on_line($line,$right);
    $area = $poly->area;
    $new_area = $new->area;
    
    # are the two areas within 1% of each other? (lots of round off errors)
    cmp_ok(abs($new_area-$area)/$area,"<",.01,"copy_to_parallelogram_on_line: Area of polygon within 1% of initial polygon");
    
    # is the angle correct?
    cmp_ok(abs($new->angle_value(1)-$right->arc),"<",0.1,"copy_to_parallelogram_on_point: Angle of polygon within 0.1 of specified angle");
    cmp_ok(abs($new->angle_value(1)-$new->angle_value(3)),"<",.1,"copy_to_parallelogram_on_line: First and third angle equal");
    cmp_ok(abs($new->angle_value(2)-$new->angle_value(4)),"<",.1,"copy_to_parallelogram_on_line: Second and fourth angle equal");
    
    sleep(1);
    $poly->remove;
    $new->remove;
    $l1->remove;
    $l2->remove;
    $right->remove;
    $line->remove;

}

# ===========================
# copy_to_parallelogram_on_point
# ===========================
if (1) {
    my @A = (80,540);
    my @B = (240,540);
    my @C = (120,580);
    my @D = (340,640);
    my @E = (20,700);
    my @F = (160,640);
    my @G = (60,580);
    my @H = (140,560);
    
    # need a 45 degree angle
    my $l1 = Line->new( $cn, 10, 40, 40, 40 );
    my $l2 = Line->new( $cn, 10, 40, 40, 10 );
    my $right = Angle->new( $cn, $l1, $l2 );

    # polygon
    my $poly = Polygon->new($cn,8,@A,@B,@C,@D,@E,@F,@G,@H);
    my $area = $poly->area;
    my $pt = Point->new($cn,40,400);
    
    # new polygon
    
    my $new = $poly->copy_to_parallelogram_on_point($pt,$right);
    my $new_area = $new->area;
    
    # are the two areas within 1% of each other? (lots of round off errors)
    cmp_ok(abs($new_area-$area)/$area,"<",.01,"copy_to_parallelogram_on_point: Area of polygon within 1% of initial polygon");
    
    # is the angle correct?
    cmp_ok(abs($new->angle_value(1)-$right->arc),"<",0.1,"copy_to_parallelogram_on_point: Angle of polygon within 0.1 of specified angle");
    cmp_ok(abs($new->angle_value(1)-$new->angle_value(3)),"<",.1,"copy_to_parallelogram_on_point: First and third angle equal");
    cmp_ok(abs($new->angle_value(2)-$new->angle_value(4)),"<",.1,"copy_to_parallelogram_on_point: Second and fourth angle equal");
    
    sleep(1);
    $new->remove;
    $l1->remove;
    $l2->remove;
    $right->remove;
    $pt->remove;
    
    # need a right angle
    $l1 = Line->new( $cn, 10, 40, 40, 40 );
    $l2 = Line->new( $cn, 10, 40, 10, 10 );
    $right = Angle->new( $cn, $l1, $l2 );

    # new polygon
    $new = $poly->copy_to_parallelogram_on_point($poly->p(1),$right);
    $new_area = $new->area;
    
    # are the two areas within 1% of each other? (lots of round off errors)
    cmp_ok(abs($new_area-$area)/$area,"<",.01,"copy_to_parallelogram_on_point: Area of polygon within 1% of initial polygon");
    
    # is the angle correct?
    cmp_ok(abs($new->angle_value(1)-$right->arc),"<",0.1,"copy_to_parallelogram_on_point: Angle of polygon within 0.1 of specified angle");
    cmp_ok(abs($new->angle_value(1)-$new->angle_value(3)),"<",.1,"copy_to_parallelogram_on_point: First and third angle equal");
    cmp_ok(abs($new->angle_value(2)-$new->angle_value(4)),"<",.1,"copy_to_parallelogram_on_point: Second and fourth angle equal");
    
    sleep(1);
     $new->remove;
    $l1->remove;
    $l2->remove;
    $right->remove;
    $pt->remove;
    $poly->remove;
}

# ===========================
# copy_to_rectangle
# ===========================
if (1) {
    my @A = (120,80);
    my @B = (240,80);
    my @C = (400,200);
    my @D = (320,260);
    my @E = (40,260);
    my @F = (40,200);
    
    # polygon
    my $poly = Polygon->new($cn,6,@A,@B,@C,@D,@E,@F);
    my $area = $poly->area;
    my $pt = Point->new($cn,40,400);
    
    # new polygon
    my $new = $poly->copy_to_rectangle($pt);
    my $new_area = $new->area;
    
    # are the two areas within 1% of each other? (lots of round off errors)
    cmp_ok(abs($new_area-$area)/$area,"<",.01,"copy_to_rectangle: Area of polygon within 1% of initial polygon");
    
    # is the angle correct?
    cmp_ok(abs($new->angle_value(1)-90),"<",0.1,"copy_to_rectangle: Angle of polygon within 0.1 of right angle");
    cmp_ok(abs($new->angle_value(1)-$new->angle_value(3)),"<",.1,"copy_to_rectangle: First and third angle equal");
    cmp_ok(abs($new->angle_value(2)-$new->angle_value(4)),"<",.1,"copy_to_rectangle: Second and fourth angle equal");
    
    sleep(1);
    $new->remove;
    $pt->remove;
    $poly->remove;
}

# ===========================
# copy_to_similar_shape
# ===========================
if (1) {
    my @A = (120,80);
    my @B = (240,80);
    my @C = (400,200);
    my @D = (320,260);
    my @E = (40,260);
    my @F = (40,200);
    
    # polygon copying
    my $line = Line->new($cn,80,400,140,400);    
    my $poly = Polygon->new($cn,6,@A,@B,@C,@D,@E,@F);

    my $similar = $poly->copy_to_similar_shape($line);
    
    # similar?
    my $scale = $poly->l(1)->length/$line->length;
    foreach my $i (1 .. $poly->sides) {
        cmp_ok(abs($poly->l($i)->length/$similar->l($i)->length - $scale),"<",.1,"Side $i is similar");
    }
    
    sleep(1);
    $similar->remove;
    $poly->remove;
    $line->remove;
    
    # Odd shape
    @A = (80,40);
    @B = (240,40);
    @C = (120,80);
    @D = (340,140);
    @E = (20,200);
    @F = (160,140);
    my @G = (60,80);
    my @H = (140,60);
    
    # polygon
    $poly = Polygon->new($cn,8,@A,@B,@C,@D,@E,@F,@G,@H);
    $line = Line->new($cn,80,400,340,400);    
    $similar = $poly->copy_to_similar_shape($line);
    
    # similar?
    $scale = $poly->l(1)->length/$line->length;
    foreach my $i (1 .. $poly->sides) {
        cmp_ok(abs($poly->l($i)->length/$similar->l($i)->length - $scale),"<",.1,"Side $i is similar");
    }
    sleep(1);
    $similar->remove;
    $poly->remove;
    $line->remove;    
}

# =======================
# copy_to_polygon_shape
# =======================
if (1) {
    
    # two polygons
    my @A = (120,80);
    my @B = (240,80);
    my @C = (400,200);
    my @D = (320,260);
    my @E = (40,260);
    my @F = (40,200);
    
    my $one = Polygon->new($cn,6,@A,@B,@C,@D,@E,@F);
    
    @A = (480,40);
    @B = (640,40);
    @C = (520,80);
    @D = (740,140);
    @E = (420,200);
    @F = (560,140);
    my @G = (460,80);
    my @H = (540,60);
    
    my $pt = Point->new($cn,40,400);
    my $two = Polygon->new($cn,8,@A,@B,@C,@D,@E,@F,@G,@H);
    
    if (0) {
    my $l1 = Line->new($cn,480,640,640,640)->red;
    my $l2 = Line->new($cn,480,640,972,640)->blue;
    my $line3 = Line->mean_proportional( $l1, $l2, $pt, 0 );
    $line3->notice;
    sleep(900);
    }
    
    
    # create a copy of $two that is equal in area to $one
    my $copy = $one->copy_to_polygon_shape($pt,$two);
    print "copy area: ",$copy->area,"\n";
    print "one area:  ",$one->area,"\n";
    
    # are the two areas within 1% of each other? (lots of round off errors)
    cmp_ok(abs($copy->area-$one->area)/$one->area,"<",.01,"copy_to_polygon_shape: Area of polygon within 1% of initial polygon");
    
    # similar?
    my $scale = $two->l(1)->length/$copy->l(1)->length;
    foreach my $i (1 .. $two->sides) {
        cmp_ok(abs($two->l($i)->length/$copy->l($i)->length - $scale),"<",.1,"Side $i is similar");
    }
    sleep(1);
    
}

=head2 Colours

  fill          ( [$colour] )
  fillover      ( $object, [$colour] )
  lines_normal  ( )
  lines_grey    ( )
  lines_red     ( )
  lines_green   ( )
  angles_normal ( )
  angles_grey   ( )
  grey          ( )
  red           ( )
  green         ( )
  normal        ( )

Canvas objects

  poly          ( )
  objects       ( )

=cut

