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
my $title = "If two numbers by multiplying one another make some number, ".
"and any prime number measure the product, it will also measure one of ".
"the original numbers.";
$pn->title( 30, $title, 'VII' );

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
push @$steps, Proposition::toc7( $pn, 30 );
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
    my $ds = 20;
    my $dx = 20;
    my $dy = 40;
    my $yl = 180;
    my $y1 = $yl;
    my $y2 = $dy + $y1;
    my $y3 = $dy + $y2;
    my $y4 = $dy + $y3;
    my $y5 = $dy + $y4;
    my $A = 2*$dx;
    my $B = 6*$dx;
    my $C = 12*$dx;
    my $D = 3*$dx;
    my $E = $C/$D*$dx;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Let C equal A multiplied by B");
        $t2->math("C = A \\{times} B");
        $l{A}= Line->new($pn,$ds,$yl,$ds+$A,$yl);
        $p{A}= Point->new($pn,$ds+$A,$yl)->label("A","right");
        $l{B}= Line->new($pn,$ds,$y2,$ds+$B,$y2);
        $p{B}= Point->new($pn,$ds+$B,$y2)->label("B","right");
        $l{C}= Line->new($pn,$ds,$y3,$ds+$C,$y3);
        $p{C}= Point->new($pn,$ds+$C,$y3)->label("C","right");

    };

    push @$steps, sub {
        $t1->explain("Let D, a prime number, measure C");
        $t2->math("D is prime");
        $t2->math("C = \\{sum(i=1,q)} D");
        $l{D}= Line->new($pn,$ds,$y4,$ds+$D,$y4);
        $p{D}= Point->new($pn,$ds+$D,$y4)->label("D","right");
        $l{C}->parts($C/$D,6,"bottom",$sky_blue);
        $l{D}->parts($D/$D,6,"bottom",$sky_blue);
    };

    push @$steps, sub {
        $t1->explain("then D measures either A or B");
        $t2->math("A = \\{sum(i=1,r)} D , or B = \\{sum(i=1,r)} D");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("C = A \\{times} B");
        $t2->math("D is prime");
        $t2->math("C = \\{sum(i=1,q)} D");
        $t2->math("A = \\{sum(i=1,r)} D , or B = \\{sum(i=1,r)} D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->down;
        $t1->explain("Assume that D does not measure A");
        $t2->math("A \\{notequal} \\{sum(i=1,r)} D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("D is prime, and does not measure A, so therefore A and D ".
        "are prime to one another (VII.29)");
        $t2->grey([0..20]);
        $t2->black([-1,-4]);
        $t2->math("gcd(D,A) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("As many times as D measures C, let there be so many units (ones) in E");
        $t2->grey([0..20]);
        $t2->black([2]);
        $t2->math("E = \\{sum(i=1,q)} 1 = q");        
        $l{E}= Line->new($pn,$ds,$y5,$ds+$E,$y5);
        $p{E}= Point->new($pn,$ds+$E,$y5)->label("E","right");
        $l{E}->parts($C/$D,6,"bottom",$purple);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since D measures C according to the units in E, ".
        "then C is equal to D multiplied by E (VII.Def.15)");
        $t2->grey([0..20]);
        $t2->black([2,-1]);
        $t2->math("C = D \\{times} E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("C is the product of A and B and also equal to the product of A and B");
        $t2->grey([0..20]);
        $t2->black([0,-1]);
        $t2->math("D\\{times}E = B\\{times}A");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus D is to A as B is to E (VII.19)");
        $t2->grey([0..20]);
        $t2->black([-1]);
        $t2->math("D:A = B:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But D and A are prime to one another, and as such they are the ".
        "smallest possible numbers that can create the ratio of B to E (VII.21)");
        $t2->grey([0..20]);
        $t2->black([5,-1]);
        $t5->y($t2->y);
  #      $t5->mathsmall("S = { (x,y) | x\\{elementof}\\{natural}, y\\{elementof}\\{natural}, ".
  #      "x:y=D:A }");
  #      $t5->mathsmall("(D,A)\\{elementof}S such that D\\{lessthanorequal}x, ".
  #      "A\\{lessthanorequal}y, \\{forall}(x,y)\\{elementof}S"); 
        $t5->math("D < B, A < E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus D measures B and A measures E equally (VII.20)");
        $l{B}->parts($B/$D,6,"top",$tan);
        $l{D}->parts($D/$D,6,"top",$tan);
        $l{A}->parts($A/$A,6,"top",$pale_pink);
        $l{E}->parts($E/$A,6,"top",$pale_pink);
        $t2->grey([0..20]);
        $t2->black([-5,-1]);
        $t2->math("D < B, A < E");
        $t2->math("E = \\{sum(i=1,s)} A");
        $t2->math("B = \\{sum(i=1,s)} D");
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Therefore D measures B");
        $t2->grey([0..20]);
        $t2->blue([0,1,2,-1]);
    };






    
    return $steps;

}

