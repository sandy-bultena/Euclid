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
my $title = "If two numbers be prime to one another, the sum will also be ".
"prime to each of them; and, if the sum of two numbers be prime to any one of ".
"them, the original numbers will also be prime to one another";

$pn->title( 28, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 580, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);
$t4->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 28 );
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
    my $dx = 50;
    my $dy = 60;
    my $yl = 180;
    my $y1 = $yl;
    my $y2 = $dy + $y1;
    my $y3 = $dy + $y2;
    my $y4 = $dy + $y3;
    my $y5 = $dy + $y4;
    my $A = 0;
    my $B = 4*$dx;
    my $C = $B + 3*$dx;
    my $D = $dx;
    my @parts;
    my $ywrong;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t1->title("In other words (part a)");
        $t1->explain("Let AB and BC be relatively prime");
        $l{AC}= Line->new($pn,$ds,$yl,$ds+$C,$yl);
        $l{AB}= Line->new($pn,$ds,$yl,$ds+$B,$yl)->label("a","top");
        $l{BC}= Line->new($pn,$ds+$B,$yl,$ds+$C,$yl)->label("b","top");
        $p{A}= Point->new($pn,$ds,$yl)->label("A","bottom");
        $p{B}= Point->new($pn,$ds+$B,$yl)->label("B","bottom");
        $p{C}= Point->new($pn,$ds+$C,$yl)->label("C","bottom");
        
        $t2->down;
        $t2->down;
        $t3->y($t2->y);
        $t3->math("gcd(a,b) = 1");
        $t2->math("gcd(AB,BC) = 1");
        $t2->math("AC = AB + BC");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->y($t2->y);
        $t3->math("gcd(a,a+b) = 1");
        $t3->math("gcd(b,a+b) = 1");
        $t2->math("gcd(AB,AC) = 1");
        $t2->math("gcd(BC,AC) = 1");
        $t1->explain("Then the sum AC is relatively prime to AB and BC");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
#        $t1->erase;
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t2->erase;
        $t2->down;
        $t2->down;
        $t3->erase;
        $t3->y($t2->y);
        $t3->math("gcd(a,b) = 1");
        $t2->math("gcd(AB,BC) = 1");
        $t2->math("AC = AB + BC");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume AB and AC are not prime to each other. ".
        "Let D be a common measure of AC, AB");
        $t2->grey([0..20]);
        $t3->grey([0..20]);
        $ywrong = $t2->y;
        $t2->math("AC = \\{sum(i=1,p)} D");
        $t2->math("AB = \\{sum(i=1,q)} D");
        push @parts,$l{AC}->show_parts($C/$D,6,"top",$pale_pink);
        push @parts,$l{AB}->show_parts($B/$D,6,"bottom",$purple);
        $l{D}= Line->new($pn,$ds,$y2,$ds+$D,$y2)->label("D","bottom");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since D measures AC and AB, it will also measure the ".
        "remainder BC");
        $t2->grey([0..20]);
        $t2->black([1..20]);
        $t2->math("BC = \\{sum(i=1,p)} D - \\{sum(i=1,q)} D");
        $t2->math("BC = \\{sum(i=1,r)} D");
        push @parts,$l{BC}->show_parts(($C-$B)/$D,6,"bottom",$turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore D measures AB and BC, which are prime to ".
        "one another, ... ");
        $t2->grey([0..20]);
        $t2->black([0,3,5]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... which is impossible (VII.Def.12)");
        $t2->red([3,5]);
        $t2->black(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So, the original premise that there is a number D ".
        "that measures AB,AC is invalid");
        $t2->grey([1..20]);
         $t2->red([2,3]);
         $t2->y($ywrong);
         $t2->math("          \\{wrong}");
         $t2->math("          \\{wrong}");
         $t2->red([-1,-2]);
         $t2->math(" ");
         $t2->math(" ");
         $t2->math(" ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus there is no number D that measures AB,AC, so they ".
        "are prime to one another");
        $t3->y($t2->y);
        $t3->allblack;
        $t3->math("gcd(a,a+b) = 1");
        $t2->math("gcd(AB,AC) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("For the same reason, BC and AC are prime to each other");
        $t3->y($t2->y);
        $t3->math("gcd(b,a+b) = 1");
        $t2->math("gcd(BC,AC) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore AB and BC are both prime to the sum AB,BC");
        $t2->grey([0..20]);
        $t2->blue([0,1,-1,-2]);
        $t3->allblue();
    };





    # -------------------------------------------------------------------------
    # In other words part b
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t3->erase;
        foreach my $ap (@parts) {
            foreach my $part (@$ap) {
                $part->remove;
            }
        }
        $t1->title("In other words (part b)");
        $t1->explain("Let AB and AC be relatively prime");
        $l{AC}= Line->new($pn,$ds,$yl,$ds+$C,$yl);
        $p{A}= Point->new($pn,$ds,$yl)->label("A","bottom");
        $p{B}= Point->new($pn,$ds+$B,$yl)->label("B","bottom");
        $p{C}= Point->new($pn,$ds+$C,$yl)->label("C","bottom");
        
        $t2->down;
        $t2->down;
        $t3->y($t2->y);
        $t3->math("gcd(a+b,a) = 1");
        
        $t2->math("gcd(AC,AB) = 1");
        $t2->math("AC = AB + BC");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->y($t2->y);
        $t3->math("gcd(a,b) = 1");
        $t2->math("gcd(AB,BC) = 1");
        $t1->explain("Then the parts AB and BC will be relatively prime");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
#        $t1->erase;
        $t1->down;
        $t3->erase;
        $t1->title("Proof by Contradiction");
        $t2->erase;
        $t2->down;
        $t2->down;
        $t3->y($t2->y);
        $t3->math("gcd(a+b,a) = 1");
        $t2->math("gcd(AC,AB) = 1");
        $t2->math("AC = AB + BC");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume AB and BC are not prime to each other. ".
        "Let D be a common measure of AB, BC");
        $t2->grey([0..20]);
        $t3->allgrey;
        push @parts,$l{AB}->parts($B/$D,6,"bottom",$purple);
        push @parts,$l{BC}->parts(($C-$B)/$D,6,"bottom",$turquoise);
        $t2->math("AB = \\{sum(i=1,p)} D");
        $t2->math("BC = \\{sum(i=1,q)} D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since D measures AB and BC, it will also measure the ".
        "whole AC");
        push @parts,$l{AC}->show_parts($C/$D,6,"top",$pale_pink);
        $t2->math("AC = \\{sum(i=1,p)} D + \\{sum(i=1,q)} D");
        $t2->math("AC = \\{sum(i=1,r)} D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore D measures AB and AC, which are prime to ".
        "one another, ... ");
        $t2->grey([0..20]);
        $t2->black([0,2,5]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... which is impossible (VII.Def.12)");
        $t2->red([2,5]);
        $t2->black(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So, the original premise that there is a number D ".
        "that measures AB,BC is invalid");
        $t2->grey([1..20]);
         $t2->red([2,3]);
         $t2->y($ywrong);
         $t2->math("          \\{wrong}");
         $t2->math("          \\{wrong}");
         $t2->red([-1,-2]);
         $t2->math(" ");
         $t2->math(" ");
         $t2->math(" ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus there is no number D that measures AB,BC, so they ".
        "are prime to one another");
        $t3->y($t2->y);
        $t3->allblack;
        $t3->math("gcd(a,b) = 1");
        $t2->math("gcd(AB,BC) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,1,-1]);
        $t3->allblue;
    };






    
    return $steps;

}

