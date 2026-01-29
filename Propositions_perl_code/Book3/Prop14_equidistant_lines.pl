#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
# ============================================================================
# Definitions
# ============================================================================
my $title =
    "In a circle equal straight lines are equally distant from the centre, and ".
    "those which are equally distant from the centre are equal to one another.";

$pn->title( 14, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 840, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 180 );
my $t2 = $pn->text_box( 60, 180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 14 );
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
    my ( %l, %p, %c, %s, %a );

    my @c1    = ( 260, 360 );
    my $r1    = 150;
    my $f     = 0.6;
    my $ao    = 40 * 3.14159/180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words ");
        $t1->explain("If E is the centre of the circle, EF perpendicular "."to BA, and EG perpendicular to DC, then");
        $t4->y($t1->y);
        $t1->explain("(1)");
        $t4->explain("If AB equals CD, then EG equals EF");
        $t1->y($t4->y);
        $t1->explain("(2)");
        $t1->y($t4->y);
        $t4->explain("If EF equals EG, then AB equals CD");
        $t1->y($t4->y);
        
        $t2->math("EF \\{perp} BA");
        $t2->math("EG \\{perp} DC");
        
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{E} = Point->new($pn, @c1)->label("E","top");

        $p{G} = Point->new($pn, $c1[0] + $f*$r1, $c1[1])->label("G","right");
        $l{EG} = Line->join($p{E},$p{G});
        $l{CDt} = Line->new($pn, $c1[0] + $f*$r1,$c1[1]-$r1, $c1[0] + $f*$r1,$c1[1]+$r1)->grey;
        my @p = $c{A}->intersect($l{CDt});
        $l{CD} = Line->new($pn,@p);
        $l{CDt}->remove;
        $p{D} = Point->new($pn,@p[2,3])->label("D","top");
        $p{C} = Point->new($pn,@p[0,1])->label("C","bottom");
        
        $p{F} = Point->new($pn,$c1[0] - $f*$r1*cos($ao),$c1[1]+$f*$r1*sin($ao))->label("F","left");
        $l{EF} = Line->join($p{E},$p{F});
        $l{BAt} = $l{EF}->perpendicular($p{F})->grey;
        $l{BAt}->extend($r1);
        $l{BAt}->prepend($r1);
        @p = $c{A}->intersect($l{BAt});
        $l{BAt}->remove;
        $p{B}=Point->new($pn,@p[2,3])->label("B ","top");
        $p{A}=Point->new($pn,@p[0,1])->label("A","bottom");
        $l{AB}=Line->join($p{A},$p{B});
        
        $l{CG} = Line->join($p{C},$p{G});
        $l{AF} = Line->join($p{A},$p{F});
        $a{G} = Angle->new($pn,$l{EG},$l{CG});
        $a{F} = Angle->new($pn,$l{AF},$l{EF});
        
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof");
    };

    push @$steps, sub {
        $t1->explain("The straight line EF bisects AB, and EG bisects DC (III.3), "
        ."therefore AB is twice AF, and DC is twice GC");
        $t3->math("AF = FB,  AB = 2\\{dot}AF");
        $t3->math("DG = GC,  DC = 2\\{dot}GC");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain("Join AE and CE");
        $l{AE}=Line->join($p{A},$p{E});
        $l{CE}=Line->join($p{C},$p{E});
    };

    push @$steps, sub {
        $t1->explain("Triangles EFA and ECG are right angle triangles, "."and therefore the sum of ".
        "the squares on the right angle equals the square "."of the line opposite (I.47)");
        $s{EFA}=Triangle->join($p{E},$p{F},$p{A})->fill($sky_blue);
        $s{EFA}->set_angles(""," ");
        $s{ECG}=Triangle->join($p{E},$p{C},$p{G})->fill($lime_green);
        #$s{ECG}->set_angles("",""," ");
        $t3->allgrey;
        $t3->math("EF\\{squared}+AF\\{squared} = AE\\{squared}");
        $t3->math("EG\\{squared}+GC\\{squared} = CE\\{squared}");
    };

    push @$steps, sub {
        $t1->explain("AE and CE are equal since they are the radii of the circle");
        $t3->down;
        $t3->allgrey;
        $t3->math("AE = CE");
    };

    push @$steps, sub {
        $t1->explain("Therefore the sum of the squares EF,AF "."equals the sum of the squares EG,GC");
        $t3->allgrey;
        $t3->black([-1,-2,-3]);
        $t3->math("EF\\{squared}+AF\\{squared} = EG\\{squared}+GC\\{squared}");        
    };

    push @$steps, sub {
        $t4->y($t1->y);
        $t1->explain("(1)");
        $t4->explain("If AB equals CD, then AF equals GC, and AF "."squared equals GC squared");
        $t3->allgrey;
        $t3->math("(1) if AB = CD");
        $t3->math("    2\\{dot}AF = 2\\{dot}GC");
        $t3->math("    AF = GC");
        $t3->math("    AF\\{squared} = GC\\{squared}");
    };

    push @$steps, sub {
        $t4->explain("Then EF squared equals EG squared, or EF equals EG");   
        $t1->y($t4->y);
        $t3->allgrey;
        $t3->black([-1,-5]);
        $t3->math("    EF\\{squared} = EG\\{squared}");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black([-1]);
        $t3->math("    EF = EG");
    };

    push @$steps, sub {
        $t4->y($t1->y);
        $t1->explain("(2)");
        $t4->explain("Similarly, if EF equals EG, then AF squared equals CG squared");
        $t3->down;
        $t3->allgrey;
        $t3->math("(2) if EF = EG");
        $t3->math("    EF\\{squared} = EG\\{squared}");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black([-1,-9]);
        $t3->math("    AF\\{squared} = CG\\{squared}");
    };

    push @$steps, sub {
        $t4->explain("AF equals CG, and AB equals CD");
        $t3->math("    AF = CG");
        $t3->math("    AB = CD");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->blue([0..3,6,12]);
        $t3->black([-1,-6]);
    };





    return $steps;

}

