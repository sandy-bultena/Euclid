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
my $title = "If an unit measure any number, and another number measure any ".
"other number the same number of times, alternately also, the unit will measure ".
"the third number the same number of times that the second measures the fourth.";

$pn->title( 15, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 280);
my $t5 = $pn->text_box( 80, 300);
my $tp = $pn->text_box( 600, 180 );
$t4->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 15 );
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
    my (%p,%c,%s,%t,%l);
    my $ds = 200;
    my $dx = 3;
    my $dy = 50;
    my $dy1 = $ds;
    my $dy2 = $ds + $dy;
    my $dy3 = $ds + 2*$dy;
    my $dy4 = $ds + 3*$dy;
    my $dy5 = $ds + 4*$dy;
    my $dy6 = $ds + 5*$dy;
    my $A = 20*$dx;
    my $B = $A + 40;
    my $C = $B + 3*$A;
    my $D = 2*$A;
    my $E = 0;
    my $F = 3*$D;
    my $G = $B + $A;
    my $H = $G + $A;
    my $K = $D;
    my $L = $K + $D;
    my $xl = 40;
    

#our @EXPORT = qw($sky_blue $lime_green $pale_pink $blue $pink $pale_yellow
#  $turquoise $green $teal $blue $tan $purple
#  $yellow $orange);
   
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->title("In other words");
        $t1->explain("Let A (a unit measure) measure BC");
        $t1->explain("Let the number D measure EF by the same amount");
        $t4->down;
        $t4->down;
        $t4->math("A = 1");
        $t4->math("BC = \\{sum(i=1,bc)} A");
        $t4->math("EF = \\{sum(i=1,bc)} D");
       $l{A} = Line->new($pn,$xl,$dy1,$xl+$A,$dy1)->label("A","top");
       $l{pA} = $l{A}->show_parts(1,6,"top",$pale_pink);
       $l{B} = Line->new($pn,$xl+$B,$dy1,$xl+$C,$dy1);
       $l{pCB} = $l{B}->show_parts(($C-$B)/$A,6,"top",$pale_pink);
       $l{D} = Line->new($pn,2*$xl,$dy2,2*$xl+$D,$dy2)->label("D","top");
       $l{pDt} = $l{D}->show_parts(1,6,"top",$turquoise);
       $l{E} = Line->new($pn,$xl,$dy3,$xl+$F    ,$dy3);
       $l{pE} = $l{E}->show_parts($F/$D,6,"top",$turquoise);
        $p{B} = Point->new($pn,$l{B}->start)->label("B","top");
        $p{E} = Point->new($pn,$l{E}->start)->label("E","top");
        $p{C} = Point->new($pn,$l{B}->end)->label("C","top");
        $p{F} = Point->new($pn,$l{E}->end)->label("F","top");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
       $t1->explain("Then, as A measures D, ...");
       $l{pD} = $l{D}->show_parts($D/$A,6,"bottom",$pale_pink);
       $t4->down;
       $t4->math("D  = \\{sum(i=1,d)} A");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
       $t1->explain("... the same number of times that BC measures EF");
       $l{pB} = $l{B}->show_parts(1,6,"bottom",$purple);
       $l{pEF} = $l{E}->show_parts($F/($C-$B),6,"bottom",$purple);
       $t4->math("EF = \\{sum(i=1,d)} BC");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->down;
        $t4->down;
        $t1->down;
        foreach my $l (@{$l{pD}}) {$l->remove}
        foreach my $l (@{$l{pB}}) {$l->remove}
        foreach my $l (@{$l{pEF}}) {$l->remove}
        $t1->title("Proof");
        $t4->math("A = 1");
        $t4->math("BC = \\{sum(i=1,bc)} A");
        $t4->math("EF = \\{sum(i=1,bc)} D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("There are as many units in BC as there are parts equal to D in EF, ".
        "so divide BC and EF into that many units/parts");
        $p{G} = Point->new($pn,$xl+$G,$dy1)->label("G","top");
        $p{H} = Point->new($pn,$xl+$H,$dy1)->label("H","top");
        $p{K} = Point->new($pn,$xl+$K,$dy3)->label("K","top");
        $p{L} = Point->new($pn,$xl+$L,$dy3)->label("L","top");
        $t4->down;
        $t4->math("BG = GH = HC = A");
        $t4->math("EK = KL = LF = D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("BG,GH,HC are all equal to each other, EK,KL,LF are all equal to ".
        "each other, and there as as many numbers BG,GH,HC as there are numbers EK,KL,LF ...");
        $t1->explain("... the ratio of BG to EK is equal to the ratio GH to KL ".
        "is equal to the ratio HC to LF");
        $t4->grey([0..20]);
        $t4->black([-1,-2]);
        $t4->math("BG:EK = GH:KL = HC:LF"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("However, the ratio of the sum of the antecedents to the sum ".
        "of the consequents will also be equal to BG to EK (VII.12)");
        $t4->grey([0..20]);
        $t4->black([-1]);
        $t4->math("(BG + GH + HC):(EK + KL + LF) = BC:EF = BG:EK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But BG is equal to A, and EK equals D, so BC to EF equals A to D");
        $t4->grey([0..20]);
        $t4->black([-1,3,4]);
        $t4->math("BC:EF = A:D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("By the definition of proportional, the unit A measures the number D the same ".
        "number of times that BC measures EF");
        $t4->grey([0..20]);
        $t4->black([-1]);        
        $t4->math("D  = \\{sum(i=1,d)} A");
        $t4->math("EF = \\{sum(i=1,d)} BC");
        foreach my $l (@{$l{pD}}) {$l->draw->colour($pale_pink)}
        foreach my $l (@{$l{pB}}) {$l->draw->colour($purple)}
        foreach my $l (@{$l{pEF}}) {$l->draw->colour($purple)}
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->grey([0..20]);
        $t4->blue([-1,0..2,-2]);        
    };





    return $steps;

}

