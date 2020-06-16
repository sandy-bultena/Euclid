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
my $title = "The least numbers of those which have the same ratio with them ".
"measure those which have the same ratio the same number of times, the greater ".
"the greater and the less the less";

$pn->title( 20, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 20 );
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
    my $ds = 40;
    my $dx = 60;
    my $dy = 40;
    my $x1 = $ds;
    my $x2 = $dx + $x1;
    my $x3 = 2*$dx + $x2;
    my $x4 = $dx + $x3;
    my $x5 = $dx + $x4;
    my $x6 = $dx + $x5;
    my $A = 8*$dy;
    my $B = 6*$dy;
    my $C = 2/3*$A;
    my $E = 2/3*$B;
    my $G = 0.5 * $C;
    my $H = 0.5 * $E;
    my $yl = 180;
    my $y;
    my $yy;
    
    push @$steps, sub {
        $t1->down;
        $t1->title("Definition 20");
        $t1->explain("Numbers are proportional when the first is the same ".
        "multiple, or the same part, or the same parts, of the second that ".
        "the third is of the fourth");
        $t2->math("A:B = C:D");
        $t2->explain (" if ");
        $t2->math("A = (p/q)C");
        $t2->math("B = (p/q)D");
        $t2->wide_math(1);
    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Given a ratio A to B");
        $l{A}= Line->new($pn,$x1,$yl,$x1,$yl+$A)->label("A","right");
        $l{B}= Line->new($pn,$x2,$yl,$x2,$yl+$B)->label("B","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the numbers CD and EF be equal to the ratio A to B and ");
        $l{C}= Line->new($pn,$x3,$yl,$x3,$yl+$C);
        $l{E}= Line->new($pn,$x4,$yl,$x4,$yl+$E);
        $p{C} = Point->new($pn,$x3,$yl)->label("C","top");
        $p{D} = Point->new($pn,$x3,$yl+$C)->label("D","bottom");
        $p{E} = Point->new($pn,$x4,$yl)->label("E","top");
        $p{F} = Point->new($pn,$x4,$yl+$E)->label("F","bottom");
        $t1->explain("... and CD,EF are the smallest numbers whose ratio equals the ".
        "ratio of A to B");
        $t2->math("A:B = CD:EF");
        $t2->down;
        $t2->mathsmall("S = { (x,y) | x\\{elementof}\\{natural}, y\\{elementof}\\{natural}, ".
        "x:y=A:B }");
        $t2->mathsmall("(CD,EF)\\{elementof}S such thats CD\\{lessthanorequal}x, ".
        "EF\\{lessthanorequal}y, \\{forall}(x,y)\\{elementof}S");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then, CD measures A the same number of times that EF measures B");
        $t2->math("\\{then} A = \\{sum(i=1,n)} CD, B = \\{sum(i=1,n)} EF");
        $t1->down;
    };

#    # -------------------------------------------------------------------------
#    push @$steps, sub {
#        $t1->explain("NOTE: If CD measures A, then it is not parts of A");
#    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof by Contradiction");
        $t2->erase;
        $t2->math("A:B = CD:EF");
        $t2->down;
        $t2->mathsmall("S = { (x,y) | x\\{elementof}\\{natural}, y\\{elementof}\\{natural}, ".
        "x:y=A:B }");
        $t2->mathsmall("(CD,EF)\\{elementof}S such that CD\\{lessthanorequal}x, ".
        "EF\\{lessthanorequal}y, \\{forall}(x,y)\\{elementof}S");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Firstly, the ratio of A to CD is equal to B to EF (VII.13)");
        $t2->grey([1,2]);
        $t2->math("A:CD = B:EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that CD does not measure A, therefore CD is parts of\\{nb}A");
        $t2->math("CD = (p/q)A");
        $l{A}->show_parts(3,undef,"right",$pale_pink);
        $l{C}->show_parts(2,undef,"left",$pale_pink);
    };

     # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus EF is also the same parts of B that CD is of A (Def 20)");
        $t2->math("EF = (p/q)B");
        $l{B}->show_parts(3,undef,"right",$turquoise);
        $l{E}->show_parts(2,undef,"left",$turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore as many parts there are of A in CD, so many ".
        "parts there are of B in EF");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Divide CD into the parts of A (CG,GD), and EF into the ".
        "parts of B (EH,HF)");
        $t2->grey([0..20]);
        $t2->black([4,5]);
        $t2->math("CG = GD = (1/q)A");
        $t2->math("EH = HF = (1/q)B");
        $p{G} = Point->new($pn,$x3,$yl+$G)->label("G");
        $p{H} = Point->new($pn,$x4,$yl+$H)->label("H");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since CG,GD are equal and EH,HF are equal, the ratios CG ".
        "to EH and GD to HF are also equal");
        $t2->grey([0..20]);
        $t2->black([-1,-2]);
        $t2->math("CG:EH = GD:HF");
    };

   # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If ratios are equal, the ratio of the sum of all the antecedents to the ".
        "ratio of the sum of the consequents is also equal (VII.12)");
        $t2->grey([0..20]);
        $t2->black([-1]);
        $t2->math("CG:EH = (CG+GD):(EH+HF) = CD:EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, there is a ratio, CG to EH, which is equal ".
        "to the ratio CD to EF, where CG is less than CD");
        $t2->grey([0..20]);
        $t2->black([-1]);
        $t2->math("CG < CD, EH < EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Which contradicts the original hypothesis that CD, EF ".
        "are the lowest numbers that can have that ratio");
        $t2->grey([0..20]);
        $t2->red([1,2,-1,-2]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Therefore, CD is not parts of A, therefore it is a part of A (VII.4)");
        $t2->grey([0..20]);
        $t2->red([3]);
        $t2->math("CD = (1/q)A, A = q\\{dot}CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And CD measures A the same number of times that EF measures B (Def.20)");
        $t2->grey([0..20]);
        $t2->black([-1,0]);
        $t2->math("EF = (1/q)B, B = q\\{dot}EF");
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,1,2,-1,-2]);        
    };




    return $steps;

}

