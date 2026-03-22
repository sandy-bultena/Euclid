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
my $title = "Any composite number is measured by some prime number";
$pn->title( 31, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);
$t4->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 31 );
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
    my $ds = 60;
    my $dx = 12;
    my $dy = 40;
    my $yl = 180;
    my $y1 = $yl;
    my $y2 = $dy + $y1;
    my $y3 = $dy + $y2;
    my $y4 = $dy + $y3;
    my $y5 = $dy + $y4;
    my $A = 18*$dx;
    my $B = 9*$dx;
    my $C = 3*$dx;
    my $D = 2*$dx;
    my $E = 9*$dx;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Let A be a number that is constructed by multiplying ".
        "two other numbers");
        $t2->math("A = i \\{times} j");
        $l{A}= Line->new($pn,$ds,$yl,$ds+$A,$yl);
        $p{A}= Point->new($pn,$ds+$A,$yl)->label("A","right");

    };

    push @$steps, sub {
        $t1->explain("Then A will be a multiple of some prime number");
        $t2->math("A = \\{sum(i=1,q)} D");
        $t2->math("D is prime");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("A = i \\{times} j");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A is composite, it is measured by some number. ".
        "Let that number be B");
        $t2->down;
        $l{B}= Line->new($pn,$ds,$y2,$ds+$B,$y2);
        $p{B}= Point->new($pn,$ds+$B,$y2)->label("B","right");
        $t2->math("A = \\{sum(i=1,r)} B");
        $l{B}->parts($B/$B,6,"top",$pale_pink);
        $l{A}->parts($A/$B,6,"top",$pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If B is prime, then A is measure by a prime number");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If B is not prime, then let some number measure B. ".
        "Let that number be C");
        $l{C}= Line->new($pn,$ds,$y3,$ds+$C,$y3);
        $p{C}= Point->new($pn,$ds+$C,$y3)->label("C","right");
        $t2->math("B = \\{sum(i=1,s)} C");
         $l{B}->parts($B/$C,12,"top",$purple);
        $l{C}->parts($C/$C,6,"top",$purple);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since C measures B, and B measures A, C also measures A");
        $t2->math("A = \\{sum(i=1,r)} (\\{sum(j=1,s)} C)");
        $l{A}->parts($A/$C,12,"top",$purple);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If C is prime, then A is measure by a prime number");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And if C is not a prime, we continue the process ".
        "until we reach a prime number that measures A");
        $t1->down;
        $t1->explain("For, if it is not found, an infinite series of numbers ".
        "will measure the number A, each of which is less than the other: ".
        "which is impossible in numbers.(*)");
        
        $t1->sidenote("* By numbers, Euclid means the set of integers {2,3,...}");
    };
    



    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Therefore a prime number measures A");
        $t2->grey([0..20]);
        $t2->blue([0,1,2,-1]);
    };






    
    return $steps;

}

