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
my $title = "If a number have any part whatever, it will be measured by a ".
"number called by the same name as the part";
$pn->title( 38, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 340, 240 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t3->wide_math(1);
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 38 );
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
    my $yl = 160;
    my $y1 = $yl;
    my $y2 = $dy + $y1;
    my $y3 = $dy + $y2;
    my $y4 = $dy + $y3;
    my $y5 = $dy + $y4;

    my $A = 8*$dx;
    my $B = 4*$dx;
    my $C = 2*$dx;
    my $D = 1*$dx;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("If A is divisible by any number it can also be measured ".
        "by that number");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If B is a part (fraction) of A, and C is a number equal ".
        "to the inverse of the fraction, then ...");
        $t3->math("B = (1/c)\\{dot}A");
        $t3->math("C = c");
        $l{A}= Line->new($pn,$ds,$yl,$ds+$A,$yl);
        $p{A}= Point->new($pn,$ds,$yl)->label("A","left");
        $l{B}= Line->new($pn,$ds,$y2,$ds+$B,$y2);
        $p{B}= Point->new($pn,$ds,$y2)->label("B","left");
        $l{C}= Line->new($pn,$ds,$y3,$ds+$C,$y3);
        $p{C}= Point->new($pn,$ds,$y3)->label("C","left");
        
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... C measures A");
        $t3->math("A = b\\{dot}C");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof");
        $t1->explain("Let the number A have a part (fraction) B, and let that fraction be called C");
        $t3->erase;
        $t3->math(" ");
        $t3->math("B = (1/c)\\{dot}A");
        $t3->math("C = c");
        $t2->y($t3->y);
        $t3->allblue;
        $t2->down;        
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t1->explain("Let the unit measure be D");
        $l{D}= Line->new($pn,$ds,$y4,$ds+$D,$y4);
        $p{D}= Point->new($pn,$ds,$y4)->label("D","left");
        $t3->math("D = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->blue([1]);
        $t1->explain("Since B is the same fraction of A as D is of C...");
        $t3->math("D = (1/c)\\{dot}C");
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->blue([0]);
        $t1->explain("Then the unit D measures the number C the same ".
        "number of times that B measures A");
        $t3->math("C = c\\{dot}D");
        $t3->math("A = c\\{dot}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Alternatively, D measures the number B the same number ".
        "of times that C measures A (VII.15)");
        $t3->allgrey;
        $t3->black([-1,-2]);
        $t3->math("B = b\\{dot}D");
        $t3->math("A = b\\{dot}C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore C measures A");
        $t3->allgrey;
        $t3->blue([-1]);
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->blue([-1,1]);
    };


    
    return $steps;

}

