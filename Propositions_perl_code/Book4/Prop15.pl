#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 5;

# ============================================================================
# Definitions
# ============================================================================
my $title = "In a given circle to inscribe an equilateral and equiangular hexagon.";

$pn->title( 15, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 440, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 15 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();
my ( %l, %p, %c, %s, %a );

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $r = 140;
    my @c = ( 200, 300 );
    my @a = ( $c[0]+$r+60, $c[1]+$r );
    my @b = ( $c[0]+$r+60+2*$r*cos(72/180*3.14), $c[1]+$r-2*$r*sin(72/180*3.14) );
    my @info;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a circle, draw a six sided polygon with equal sides ".
        "and equal angles on the inside of the circle.");

        $c{a} = Circle->new($pn,@c,$c[0]+$r,$c[1]);
        
        foreach my $i (1..6) {
            $p{$i} = Point->new($pn,$c{a}->coords(-90 - ($i-1)*360/6));
        }
        $p{A} = $p{1}->label("A","bottom");
        $p{B} = $p{2}->label("B","bottomleft");
        $p{C} = $p{3}->label("C","topleft");
        $p{D} = $p{4}->label("D","top");
        $p{E} = $p{5}->label("E","topright");
        $p{F} = $p{6}->label("F","bottomright");
        $s{a} = Polygon->join(6,$p{1},$p{2},$p{3},$p{4},$p{5},$p{6});
        
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $s{a}->remove;
        foreach my $p ("A" .. "F") {
            $p{$p}->remove;
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw the diameter AD through the centre of the circle\\{nb}G");
        $p{A} = Point->new($pn,$c{a}->coords(-90))->label("A","bottom");
        $p{D} = Point->new($pn,$c{a}->coords(90))->label("D","top");
        $l{AD} = Line->join($p{A},$p{D});
        $p{G} = Point->new($pn,@c)->label("G  ","bottom");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a circle with D as the centre, and DG as the radius");
        $c{b} = Circle->new($pn,$p{D}->coords,$p{G}->coords);
        my @p = $c{a}->intersect($c{b});
        $p{C} = Point->new($pn,@p[0,1])->label("C","left");
        $p{E} = Point->new($pn,@p[2,3])->label("E","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw the lines CG and EG");
        $c{b}->grey;
        $l{CG} = Line->join($p{C},$p{G});
        $l{EG} = Line->join($p{E},$p{G});
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Extend the lines CG and EG to the other side of the circle "
        . "at points F and B respectively");
        $l{CF} = $l{CG}->clone;
        $l{CF}->extend($c{a}->radius);
        $p{F} = Point->new($pn,$l{CF}->end)->label("F","right");
        $l{EB} = $l{EG}->clone;
        $l{EB}->extend($c{a}->radius);
        $p{B} = Point->new($pn,$l{EB}->end)->label("B","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw lines AB, BC, CD, DE, EA");
        $t1->explain("The resulting hexagon is ".
        "equilateral and equiangular");
        $s{a} = Polygon->join(6,$p{A},$p{B},$p{C},$p{D},$p{E},$p{F});
        $l{CF}->grey;
        $l{AD}->grey;
        $l{EB}->grey;
        $l{CG}->grey;
        $l{EG}->grey;
    };



    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The lines DG and EG are radii of the same circle, and ".
        "thus are equal");
        $s{a}->grey;
        $l{DG} = Line->join($p{D},$p{G});
        $l{EG}->normal;
        $t3->math("DG = EG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The lines DG and DE are radii of the same circle, and ".
        "thus are equal");
        $c{b}->normal;
        $c{a}->grey;
        $l{DE} = Line->join($p{D},$p{E});
        $l{EG}->grey;
        $t3->math("DG = DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the triangle DGE is an equilateral triangle");
        $s{DGE} = Triangle->join($p{D},$p{G},$p{E})->fill($sky_blue);
        $c{b}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("An equilateral triangle is also "."an isosceles triangle, ".
        "regardless of which side is "."chosen as its base, therefore, all the angles "
        ."within the triangle are equal\\{nb}(I.5)");
        $s{DGE}->set_angles("\\{alpha}","\\{alpha}","\\{alpha}",20,20,20);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The sum of all the angles within a triangle is two right ".
        "angles (I.32), therefore the angle EGD is one-third of two right angles");
        $t3->allgrey;
        $t3->math("\\{angle}DGE = \\{alpha} = (1/3)\\{dot}2\\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, it can be shown that CGD is also one-third ".
        "of two right angles");
        $s{DGE}->grey;
        $l{CG}->normal;
        $l{DG}->normal;
        $l{DE}->grey;
        $l{EG}->normal;
        $a{DGE} = Angle->new($pn,$l{EG},$l{DG})->label("\\{alpha}",20);
        $a{CGE} = Angle->new($pn,$l{DG},$l{CG})->label("\\{epsilon}",23);
        $t3->math("\\{angle}CGD = \\{epsilon} = (1/3)\\{dot}2\\{right}");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The line CG cuts the straight line BE, "."therefore the angles ".
        "CGE and CGB equal two right angles");
        $l{EB}->normal;
        $l{BG} = Line->join($p{B},$p{G});
        $a{BGC} = Angle->new($pn,$l{CG},$l{BG})->label("\\{gamma}",30);
        $t3->allgrey;
        $t3->math("(\\{epsilon}+\\{alpha}) + \\{gamma} = 2\\{right}")
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, angle BGC is also one third of two right angles ".
        "and all of the angles are equal");
        $t3->allgrey;
        $t3->black([-1,-2,-3]);
        $t3->math("\\{gamma} = \\{epsilon} = \\{alpha} = (1/3)\\{dot}2\\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The angles vertical to BGC, CGD, DGE are also equal (I.15)");
        $l{AG}=Line->join($p{A},$p{G});
        $l{FG} = Line->join($p{F},$p{G});
        $p{G}->grey;
        $a{AGB} = Angle->new($pn,$l{BG},$l{AG})->label("\\{alpha}",20);
        $a{FGA} = Angle->new($pn,$l{AG},$l{FG})->label("\\{epsilon}",25);
        $a{EGF} = Angle->new($pn,$l{FG},$l{EG})->label("\\{gamma}",30);
        $t3->allgrey;
        $t3->black(-1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Equal angles subtend equal circumferences (III.26) and ".
        "equal circumferences are subtended by equal straight lines (III.29)");
        $t1->explain("Therefore the six lines are equal");
        $s{a}->normal;
        $t3->math("AB = BC = CD = DE = EF");
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->explain("The hexagon was proven to be equilateral");
        $t1->explain("It is also equiangular");
        $t1->down;
        $t1->title("Proof (cont)");
        $t3->down;
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The circumference FA is equal to the circumference ED");
        greyall();
        $a{FA} = Arc->join($c{a}->radius,$p{A},$p{F});
        $a{ED} = Arc->join($c{a}->radius,$p{E},$p{D});
        $t3->allgrey;
        $t3->math("\\{arc}DE = \\{arc}FA");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the circumference ABCD be added to each of FA and\\{nb}ED ".
        "maintaining the equality" );

        $a{FA}->grey;
        $a{ED}->grey;
        $l{f} = VirtualLine->new($c{a}->centre,$p{F}->coords);
        $l{f}->extend(10);
        $l{d} = VirtualLine->new($c{a}->centre,$p{D}->coords);
        $l{d}->extend(10);
        
        $c{b} = Arc->newbig($pn,$c{a}->radius+ 10,$l{d}->end,$l{f}->end)->red;
        
        $l{e} = VirtualLine->new($c{a}->centre,$p{E}->coords);
        $l{e}->extend(15);
        $l{a} = VirtualLine->new($c{a}->centre,$p{A}->coords);
        $l{a}->extend(15);
        
        $c{c} = Arc->newbig($pn,$c{a}->radius+15,$l{e}->end,$l{a}->end)->green;
        
        $t3->math("\\{arc}ABCD + \\{arc}DE = \\{arc}FA + \\{arc}ABCD");
        $t3->down();
        $t3->math("\\{arc}ABCDE = \\{arc}FABCD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Equal circumferences have equal angles, therefore the angles ".
        "are also equal (III.27)");
        $c{c}->grey;
        $l{DE} = Line->join($p{D},$p{E});
        $l{EF} = Line->join($p{E},$p{F});
        $a{DEF} = Angle->new($pn,$l{DE},$l{EF})->label("\\{beta}");
        $s{tmp1} = Triangle->join($p{D},$p{E},$p{F})->fill($pink);
        $s{tmp2} = Arc->newbig($pn,$c{a}->radius,$p{D}->coords,$p{F}->coords)->fill($pale_pink);
        my $y = $t3->y;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{angle}DEF = ");
        $t3->y($y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{tmp1}->remove;
        $s{tmp2}->fill;
        $s{tmp2}->remove;
        $c{b}->grey;
        $l{DE}->grey;
        $l{FA} = Line->join($p{F},$p{A});
        $c{c}->normal;
        $c{c}->green;
        $a{DEF}->grey;

        $s{tmp1} = Triangle->join($p{A},$p{E},$p{F})->fill($green);
        $s{tmp2} = Arc->newbig($pn,$c{a}->radius,$p{E}->coords,$p{A}->coords)->fill($lime_green);

        $a{EFA} = Angle->new($pn,$l{EF},$l{FA})->label("\\{beta}");
        $t3->math("       \\{angle}EFA");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{tmp1}->remove;
        $s{tmp2}->fill;
        $s{tmp2}->remove;
        $t1->explain("Similarly, we can show that all the angles are equal");
        $c{c}->remove;
        $c{b}->remove;
        $a{DEF}->grey;
        $a{EFA}->grey;
        $s{a}->normal;
        $t3->allgrey;
        $t3->math("\\{angle}DCB = \\{angle}CBA = \\{angle}BAF");
        $t3->math(" = \\{angle}AFE = \\{angle}FED = \\{angle}EDC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The hexagon is both equilateral and equiangular");
        $t3->allgrey;
        $t3->black([-1,-2,-8]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Note:");
        $s{DGE}->normal;
        $t1->explain("From the first part of the proof, it can be noted that ".
        "the side of a hexagon is ".
        "equal to the radius of the circle.");
    };

    return $steps;

}

sub greyall {
    foreach my $o ( keys %l ) {
        $l{$o}->grey;
    }
    foreach my $o ( keys %a ) {
        $a{$o}->grey;
    }
    foreach my $o ( keys %s ) {
        $s{$o}->grey;
    }
    foreach my $o ( keys %p ) {
#        $p{$o}->grey;
    }
}

