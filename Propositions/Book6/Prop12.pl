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
my $title = "To three given straight lines to find a fourth proportional.";

$pn->title( 12, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 12 );
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
    my $off = 20;
    my $yh = 180;
    my $yb = 350;
    my $dx1 = 200;
    my $dx2 = 0.9*$dx1;
    my $dx3 = $dx1*$dx1/$dx2;
    my $xs = 500;
    
    my @A = ($xs,$yh,$xs+$dx1,$yh);
    my @B = ($xs,$yh+$off,$xs+.75*$dx1,$yh+$off);
    my @C = ($xs,$yh+2*$off,$xs+.80*$dx1,$yh+2*$off);
    my @D = (50,$yb);
    my @maybe = ($xs,$yh+4*$off,$xs+($C[2]-$C[0])*($B[2]-$B[0])/($A[2]-$A[0]),$yh+4*$off);
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given three line segments A,B,C, find a fourth proportional ?, ".
        "such that A is to B as C is to ?");
        
        $p{A} = Point->new($pn,@A[0,1])->label("A","left");
        $p{B} = Point->new($pn,@B[0,1])->label("B","left");
        $p{C} = Point->new($pn,@C[0,1])->label("C","left");
        $l{A} = Line->new($pn,@A);
        $l{B} = Line->new($pn,@B);
        $l{C} = Line->new($pn,@C);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{maybe} = Point->new($pn,@maybe[0,1])->label("?","left");      
        $l{maybe} = Line->new($pn,@maybe)->dash->blue; 
        $t3->math("A:B = C:?");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{maybe}->remove;
        $l{maybe}->remove;
        $t1->down;
        $t1->title("Construction");
        $t3->erase();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw two arbitrary lines, set out at any angle at D");
        $p{D} = Point->new($pn,@D)->label("D","left");
        $l{d1} = Line->new($pn,@D,$D[0]+300,$D[1]);
        $l{d2} = Line->new($pn,@D,$D[0]+350,$yh);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Define points such that DG is equal to A, GE is ".
        "equal to B, and DH is equal to C");
        $t3->math("DG = A");
        $t3->math("GE = B");
        $t3->math("DH = C");
        $t3->blue([0..10]);
        $l{d1}->grey;
        $l{d2}->grey;
        ($l{DG},$p{G}) = $l{A}->copy_to_line($p{D},$l{d2},-1);
        $p{G}->label("G","top");
        ($l{EG},$p{E}) = $l{B}->copy_to_line($p{G},$l{d2},-1);
        $p{E}->label("E","top");
        ($l{DH},$p{H}) = $l{C}->copy_to_line($p{D},$l{d1},-1);
        $p{H}->label("H","bottom");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw line GH, and draw another line EF, parallel to GH (I.31)");
        $l{GH} = Line->join($p{G},$p{H});
        $l{EFx} = $l{GH}->parallel($p{E},-1)->prepend(200);
        my @p = $l{EFx}->intersect($l{d1});
        $p{F} = Point->new($pn,@p)->label("F","bottom");
        $l{EF} = Line->join($p{E},$p{F});
        $l{EFx}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("HF is the fourth proportional");
        $t3->down;
        $t3->math("A:B = C:HF");
        $l{HF} = Line->join($p{H},$p{F});
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
     #   $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t3->erase();
        $t3->math("DG = A");
        $t3->math("GE = B");
        $t3->math("DH = C");
        $t3->blue([0..10]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since GH is parallel to the base EF of the triangle DEF, ".
        "then DG is to GE as DH is to HF (VI.2)");
        $t{DEF} = Triangle->join($p{D},$p{E},$p{F})->fill($sky_blue);
        $t3->math("DG:GE = DH:HF");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t1->down;
        $t1->explain("But DG is equal to A, GE equals B, and DH equals C, ".
        "so A is to B as C is to HF");
        $t3->math("A:B = C:HF");
    };

    

    return $steps;

}

