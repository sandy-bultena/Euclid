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
my $title = "If four straight lines be proportional, the rectilineal figures ".
"similar and similarly described upon them will also be proportional; and if ".
"the rectilineal figures similar and similarly described upon them be proportional,
 the straight lines will themselves also be proportional";

$pn->title( 22, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 450 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 22 );
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
    my $off = 40;
    my $yoff = 100;
    my $yh = 150;
    my $ym = 180;
    my $yb = 300;
    my $dx1 = 100;
    my $dx2 = 20;
    my $dx3 = 140;
    my $dx4 = 20;
    my $xs = 150;
    my $k = 1/1.5;
    my $k2 = 1/1.3;
    
    my @A = ($xs,$yb);
    my @B = ($A[0]+$dx1,$yb);
    my @K = ($A[0]+$dx2,$yh);

    my @C = ($B[0]+$off,$yb);
    my @D = ($C[0]+$k*$dx1,$yb);
    my @L = ($C[0]+$k*$dx2,$yb+$k*($yh-$yb));
    
    my @E = ($D[0]+$off,$yb);
    my @F = ($E[0]+$dx3,$yb);
    my @M = ($E[0]+$dx2,$ym);
    my @M1 = ($M[0]+$dx3,$ym);
    
    my @G = ($F[0]+$off,$yb);
    my @H = ($G[0]+$k*$dx3,$yb);
    my @N = ($G[0]+$k*$dx2,$yb+$k*($ym-$yb));
    my @N1 = ($N[0]+$k*$dx3,,$yb+$k*($ym-$yb));
    
    my @O = ($A[0],$A[1]+$yoff);
    my @P = ($C[0],$C[1]+$yoff);
    
    my @Q = ($E[0]+100,$E[1]+1.4*$yoff);
    my @R = ($Q[0]+$k*$dx3,$E[1]+1.4*$yoff);
    my @S = ($Q[0]+$k*$dx2,$R[1]+$k*($ym-$yb));
    my @S1 = ($S[0]+$k*$dx3,$R[1]+$k*($ym-$yb));

    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;

    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("If the line segments AB, CD, EF, GH are proportional, then if similar polygons "
        ."are drawn on AB,CD and other similar polygons are drawn on EF,GH, these polygons will also be "
        ."similar");
        $t1->explain("And vice-versa");
        
        $p{A} = Point->new($pn,@A)->label("A","bottom");
        $p{B} = Point->new($pn,@B)->label("B","bottom");
        $p{C} = Point->new($pn,@C)->label("C","bottom");
        $p{D} = Point->new($pn,@D)->label("D","bottom");
        $p{E} = Point->new($pn,@E)->label("E","bottom");
        $p{F} = Point->new($pn,@F)->label("F","bottom");
        $p{G} = Point->new($pn,@G)->label("G","bottom");
        $p{H} = Point->new($pn,@H)->label("H","bottom");
        
        $l{AB} = Line->join($p{A},$p{B});
        $l{CD} = Line->join($p{C},$p{D});
        $l{EF} = Line->join($p{E},$p{F});
        $l{GH} = Line->join($p{G},$p{H});
    
        $t3->math("AB:CD = EF:GH")->blue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{K} = Point->new($pn,@K)->label("K","top");
        $t{ABK} = Triangle->join($p{A},$p{B},$p{K});
        $p{L} = Point->new($pn,@L)->label("L","top");
        $t{CDL} = Triangle->join($p{C},$p{D},$p{L});
        $p{M} = Point->new($pn,@M)->label("M","top");
        $p{M1} = Point->new($pn,@M1);
        $t{EFM} = Polygon->join(4,$p{E},$p{F},$p{M1},$p{M});
        $p{N} = Point->new($pn,@N)->label("N","top");
        $p{N1} = Point->new($pn,@N1);
        $t{GHM} = Polygon->join(4,$p{G},$p{H},$p{N1},$p{N});
        $t3->math("\\{triangle}KAB:\\{triangle}LCD = \\{square}MF:\\{square}NH");
        
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof - Part 1");
        $t3->erase;
        $t3->math("AB:CD = EF:GH")->blue;
        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Create a third proportional (O) to AB, CD, and another ".
        "third proportional (P) to EF, GH (VI.11)");
        $p{O} = Point->new($pn,@O)->label("O","left");
        $p{P} = Point->new($pn,@P)->label("P","left");
        $l{O} = Line->third_proportional($l{AB},$l{CD},$p{O},0);
        $l{P} = Line->third_proportional($l{EF},$l{GH},$p{P},0);
        $t3->math("AB:CD = CD:O");
        $t3->math("EF:GH = GH:P");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus the ratios CD to O and GH to P are also equal");
        $t3->math("CD:O  = GH:P");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, ex aequali, AB is to O as EF is to P (V.22)");
        $t3->grey([1,2]);
        $t3->math("AB:O  = EF:P");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The ratios of similar triangles is equal to the duplicate ratio ".
        "of their sides about an equal angle (VI.19.Por), so KAB is to LCD as ".
        "AB is to O");
        $t3->grey([0..20]);
        $t3->black(1);
        $t3->math("\\{triangle}KAB:\\{triangle}LCD = AB:O");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Likewise, MF is to NH as EF is to P");
        $t3->grey([0..20]);
        $t3->black(2);
        $t3->math("\\{square}MF:\\{square}NH = EF:P");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, KAB is to LCD as MF is to NH (V.11)");
        $t3->grey([0..20]);
        $t3->black([4..6]);
        $t3->math("\\{triangle}KAB:\\{triangle}LCD = \\{square}MF:\\{square}NH");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..20]);
        $t3->blue(0);
        $t3->black(7);
    };

    # -------------------------------------------------------------------------
    # In othwe words, part 2
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("In other words - Part 2");
        $t1->explain("If KAB is to LCD as MF is to NH, then AB is to CD as EF is to GH");
        $t3->erase;
        $t3->math("\\{triangle}KAB:\\{triangle}LCD = \\{square}MF:\\{square}NH")->blue;
        $t3->math("\\{then} AB:CD = EF:GH");
        $l{O}->grey;
        $p{O}->grey;
        $l{P}->grey;
        $p{P}->grey;
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t3->erase;
        $t3->math("\\{triangle}KAB:\\{triangle}LCD = \\{square}MF:\\{square}NH")->blue;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that the ratio EF to GH is not equal to the ratio AB to CD");
        $t3->math("AB:CD \\{notequal} EF:GH");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Define QR such that EF to QR is equal to AB to CD");
        $t3->math("AB:CD = EF:QR");
        $p{Q} = Point->new($pn,@Q)->label("Q","bottom");
        $p{R} = Point->new($pn,@R)->label("R","bottom");
        $l{QR} = Line->join($p{Q},$p{R});
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw SR similar to either MF or NH (VI.18)");
        $p{S} = Point->new($pn,@S)->label("S","left");
        $p{S1} = Point->new($pn,@S1);
        $t{SR} = Polygon->join(4,$p{Q},$p{R},$p{S1},$p{S});
        $t2->down;
        $t2->down;
        $t2->math("      \\{square}SR ~ \\{square}NH")->blue;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since AB is to CD as EF is to QR, then KAB is to LCD, so is MF to SR");
        $t3->grey([0..20]);
        $t3->black(2);
        $t3->math("\\{triangle}KAB:\\{triangle}LCD = \\{square}MF:\\{square}SR");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But MF to NH is also equal to KAB to LCD, therefore MF is to ".
        "SR so is MF to NH (V.11)");
        $t3->grey([0..20]);
        $t3->black([0,3]);
        $t3->blue;
        $t3->math("\\{square}MF:\\{square}NH = \\{square}MF:\\{square}SR"); 
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("MF has the same ratio to SR as it does to NH, ".
        "therefore SR is equal to NH (V.9)");
        $t3->grey([0..20]);
        $t3->black([4]);
        $t3->math("\\{square}NH = \\{square}SR");
        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But NH and SR are similar, therefore GH = QR");
        $t3->grey([0..20]);
        $t3->black([5]);
        $t3->math("QH = GR");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If AB is to CD as EF is to QR, and QR is equal to GH, ".
        "then AB is to CE as EF is to GH ");
        $t3->grey([0..20]);
        $t3->black([2,6]);
        $t3->down;
        $t3->math("AB:CD = EF:GH");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..20]);
        $t3->black([7]);
        $t3->blue;
        $t2->grey;        
    };
    
    
    return $steps;

}

