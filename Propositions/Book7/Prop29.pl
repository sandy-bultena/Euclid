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
my $title = "Any prime number is prime to any number which it does not measure.";

$pn->title( 29, $title, 'VII' );

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
push @$steps, Proposition::toc7( $pn, 29 );
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
    my $dx = 30;
    my $dy = 40;
    my $yl = 180;
    my $y1 = $yl;
    my $y2 = $dy + $y1;
    my $y3 = $dy + $y2;
    my $y4 = $dy + $y3;
    my $y5 = $dy + $y4;
    my $A = 4*$dx;
    my $B = 6*$dx;
    my $C = 2*$dx;
    my $ywrong;
    my @parts;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Let A be prime, and not measure B");
        $t2->math("A is prime");
         $t2->math("B \\{notequal} \\{sum(i=1,q)} A, q>1");
        $l{A}= Line->new($pn,$ds,$yl,$ds+$A,$yl);
        $p{A}= Point->new($pn,$ds+$A,$yl)->label("A","right");
        $l{B}= Line->new($pn,$ds,$y2,$ds+$B,$y2);
        $p{B}= Point->new($pn,$ds+$B,$y2)->label("B","right");
    };

    push @$steps, sub {
        $t1->explain("then A and B are prime to each other");
        $t2->math("gcd(A,B) = 1");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t2->erase;
        $t2->math("A is prime");
        $t2->math("B \\{notequal} \\{sum(i=1,q)} A, q>1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume B and A are not prime to one another");
        $t2->down;
        $t2->allgrey;
        $ywrong = $t2->y;   
        $t2->math("gcd(A,B) \\{notequal} 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then some number, C, will measure them");
        $t1->explain("Let that number be C");
        $l{C}= Line->new($pn,$ds,$y3,$ds+$C,$y3);
        $p{C}= Point->new($pn,$ds+$C,$y3)->label("C","right");
        push @parts,$l{A}->show_parts($A/$C,6,"bottom",$sky_blue);
        push @parts,$l{B}->show_parts($B/$C,6,"bottom",$purple);
        $t2->math("A = \\{sum(i=1,s)} C");
        $t2->math("B = \\{sum(i=1,r)} C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since C measures B, and A does not measure B, then ".
        "A and C are not equal");
        $t2->math("A \\{notequal} C");
        $t2->grey([0..20]);
        $t2->black([1,-1,-2]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But C measures A as well as B");
        $t2->grey([0..20]);
        $t2->black([-2,-3]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But A is prime and it cannot be measured by C ".
        "unless it is equal to C, which it is not"); 
        $t2->grey([0..20]);
        $t2->red([0,-3,-1]);
        $t2->black(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So the original assumption that A and B are not co-prime ".
        "is invalid");
        $t2->allgrey;
        $t2->black(0);
        $t2->red(2);
        my $tmp = $t2->y;
        $t2->y($ywrong);
        $t2->math("              \\{wrong}");
        $t2->red(-1);
        $t2->y($tmp);
    };





    # -------------------------------------------------------------------------
    push @$steps, sub {
        foreach my $ps (@parts) {
            foreach my $part (@$ps) {
                $part->remove;
            }
        }
    
        $t1->explain("A and B are co-prime");
        $t2->math("gcd(A,B) = 1");
        $t2->grey([0..20]);
        $t2->blue([0,1,-1]);
    };






    
    return $steps;

}

