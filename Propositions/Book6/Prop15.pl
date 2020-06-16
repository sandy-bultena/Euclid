#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;


# ============================================================================
# Definitions
# ============================================================================
my $title = "In equal triangles which have one angle equal to one angle the ".
"sides about the equal angles are reciprocally proportional; and those triangles ".
"which have one angle equal to one angle, and in which the sides about the ".
"equal angles are reciprocally proportional, are equal.";

$pn->title( 15, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 400, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 15 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my (%p,%c,%s,%t,%l,%a);
    my $off = 30;
    my $yh = 200;
    my $yb = 450;
    my $dx1 = 180;
    my $xs = 100;
    
    my @D = ($xs+$dx1,$yh+20);
    my @F = ($xs+$off,$yh);
    my @B = ($xs,$yh);
    my @C = ($xs,$yb);
    
    my $lDC = VirtualLine->new(@D,@C);
    my $lBE = VirtualLine->new(@B,$B[0]+30,$B[1]+30);
    my @A = $lDC->intersect($lBE);
    my $lAB = VirtualLine->new(@B,@A);
    my $lAC = VirtualLine->new(@A,@C);
    my $lAD = VirtualLine->new(@A,@D);
    my $lenAE = $lAB->length * $lAC->length / $lAD->length;
    $lAB->extend($lenAE);
    my @E = $lAB->end ;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given two triangles with one equal angle, "."and the areas of the triangle are equal, ".
        "then the ratios of the sides around the equal angle is "."reciprocally proportional");
        $t1->explain("... or ... the multiplication of the two sides "."of two equal area triangles "
        ."on either side of two equal angles remains constant");
        $t1->down;
        $t1->explain("And the inverse");
        
        $p{A} = Point->new($pn,@A)->label("A","bottom");
        $p{B} = Point->new($pn,@B)->label("B","top");
        $p{D} = Point->new($pn,@D)->label("D","top");
        $p{E} = Point->new($pn,@E)->label("E","bottom");
        $p{C} = Point->new($pn,@C)->label("C","bottom");
        $t{ABC} = Triangle->join($p{A},$p{B},$p{C})->fill($sky_blue);
        $t{ADE} = Triangle->join($p{A},$p{D},$p{E})->fill($lime_green);
        $l{AD} = $t{ADE}->lines->[0];
        $l{DE} = $t{ADE}->lines->[1];
        $l{AE} = $t{ADE}->lines->[2];
        $l{AB} = $t{ABC}->lines->[0];
        $l{AC} = $t{ABC}->lines->[2];
        $l{BC} = $t{ABC}->lines->[1];
        $a{CAB} = Angle->new($pn,$l{AB},$l{AC},-size=>20)->label("\\{alpha}");
        $a{DAE} = Angle->new($pn,$l{AE},$l{AD},-size=>20)->label("\\{theta}");
        
        $t4->down;
        $t4->down;
        $t4->math("\\{alpha} = \\{theta}")->blue(0);
        $t4->math("\\{triangle}ABC = \\{triangle}DAE")->blue(1);
        
        $t4->math("AC:AD = AE:AB");
        $t4->down;
        $t4->math("\\{alpha} = \\{theta}")->blue(3);
        $t4->math("AC:AD = AE:AB")->blue(4);
        $t4->math("\\{triangle}ABC = \\{triangle}DAE");

       $t1->down;
        $t1->title("Note:");
        $t1->explain("Assume two objects 'x' and 'y', both with properties '1' and '2'");
        $t1->explain("Proportional:");$t1->math("   \\{x_1}:\\{y_1} = \\{x_2}:\\{y_2}");
        $t1->explain("Reciprocally Proportional:");
        $t1->math("   x\\{_1}:y\\{_1} = y\\{_2}:x\\{_2}, ".
        " x\\{_1}\\{dot}x\\{_2} = y\\{_1}\\{dot}y\\{_2}");
     };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof (Part 1)");
        $t4->erase;
       $t4->down;
        $t4->down;
        $t4->math("\\{alpha} = \\{theta}")->blue(0);
        $t4->math("\\{triangle}ABC = \\{triangle}DAE")->blue(1);
    };

    push @$steps, sub {
        $t1->explain("Let CA, AD be place in in a straight line, ".
        "therefore EA, AB are also in a straight line (I.14)");
        $t1->explain("Create the triangle BAD");
        $t{BAD} = Polygon->join(3,$p{B},$p{A},$p{D})->fill($pale_pink);
    };
    
    push @$steps, sub {
        $t1->explain("Since triangles ABC and DAE are equal, then the ratios ".
        "of these to the triangle BAD will also be equal (V.7)");
        $t4->down;
        $t4->math("\\{triangle}ABC:\\{triangle}BAD = \\{triangle}DAE:\\{triangle}BAD");
    };
    
    push @$steps, sub {
        $t1->explain("But, as the area ABC is to the area BAD, "
        ."so is the base AC to the base AD (VI.1) ");
        $t{ADE}->grey();
        $t4->allgrey;
        $t4->math("\\{triangle}ABC:\\{triangle}BAD = AC:AD");
    };
    
    push @$steps, sub {
        $t1->explain("and as DAE is to BAD, so is AE to AB (VI.1)");
        $t{ADE}->normal;
        $t{ABC}->grey;
        $t4->allgrey;
        $t4->math("\\{triangle}DAE:\\{triangle}BAD = AE:AB");
    };
    
    push @$steps, sub {
        $t1->explain("Therefore, as AC is to AD, so is AE to AB (V.11)");
        $t4->black([-1,-2,-3]);
        $t4->math("AC:AD = AE:AB");
        $t{ADE}->grey;
        $t{BAD}->grey;
        foreach my $l (keys %l) {
            $l{$l}->grey;
        }
        $l{AB}->normal;
        $l{AD}->normal;
        $l{AC}->normal;
        $l{AE}->normal;
    };
    
    push @$steps, sub {
        $t{BAD}->grey;
        $t{ABC}->normal;
        $t{ADE}->normal;
        $t1->down;
        $t1->explain("Thus, in the two triangles, the sides about the equal angles are ".
        "reciprocally proportional");
        $t4->allgrey;
        $t4->black(-1);
        $t4->blue([0,1]);
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{BAD}->normal;
        $t1->erase;
        $t1->down;
        $t1->title("Proof (Part 2)");
        $t4->erase;
        $t4->down;
        $t4->down;
        $t4->math("\\{alpha} = \\{theta}")->blue(0);
        $t4->math("AE:AB = AC:AD")->blue(1);
        $t1->explain("Let CA, AD be place in in a straight line, ".
        "therefore EA, AB are also in a straight line (I.14)");
        $t1->explain("Create the triangle BAD");
    };

    push @$steps, sub {
        $t1->explain("The ratio of AC to AD is equal to the ratio "
        ."of the triangles ABC to BAD (VI.1)");
        $t4->down;
        $t{ADE}->grey;
        $t4->allgrey;
        $t4->math("AC:AD = \\{triangle}ABC:\\{triangle}BAD");
    };

    push @$steps, sub {
        $t1->explain("The ratio of AE to AB is equal to the ratio "
        ."of the triangles DAE to BAD (VI.1)");
        $t{ADE}->normal;
        $t{ABC}->grey;
        $t4->allgrey;
        $t4->math("AE:AB = \\{triangle}DAE:\\{triangle}BAD");
    };

     push @$steps, sub {
        $t1->explain("Therefore the ratio of the triangles ABC to BAD "
        ."is equal to DAE to BAD (V.11)");
        $t{ADE}->normal;
        $t{ABC}->normal;
        $t4->black([-1,-2,-3]);
        $t4->math("\\{triangle}ABC:\\{triangle}BAD = \\{triangle}DAE:\\{triangle}BAD");
    };

     push @$steps, sub {
        $t1->explain("And thus the triangles ABC and DAE are equal (V.9)");
        $t4->down;
        $t{BAD}->grey;
        $t4->allgrey;
        $t4->black(-1);
        $t4->math("\\{triangle}ABC = \\{triangle}DAE");
    };

     push @$steps, sub {
         $t4->allgrey;
         $t4->black(-1);
         $t4->blue([0,1]);
    };
    return $steps;

}

