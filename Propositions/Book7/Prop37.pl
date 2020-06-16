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
my $title = "If a number be measured by any number, the number which is ".
"measured will have a part called by the same name as the measuring number";
$pn->title( 37, $title, 'VII' );

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
push @$steps, Proposition::toc7( $pn, 37 );
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
    my $B = 2*$dx;
    my $C = 4*$dx;
    my $D = 1*$dx;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("If A is measured by B, then ...");
        $l{A}= Line->new($pn,$ds,$yl,$ds+$A,$yl);
        $p{A}= Point->new($pn,$ds,$yl)->label("A","left");
        $l{B}= Line->new($pn,$ds,$y2,$ds+$B,$y2);
        $p{B}= Point->new($pn,$ds,$y2)->label("B","left");
        $t3->math("A = c\\{dot}B");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... then there exists another part of A, which is equal to the fraction (1/B)");
        $t3->math("A = b\\{dot}C");
        $t3->math("C = (1/b)A");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof");
        $t3->erase;
        $t3->math("A = c\\{dot}B");
        $l{A}->parts($A/$B,6,'top',$sky_blue);
        $l{B}->parts($B/$B,6,'top',$sky_blue);
        $t2->y($t3->y);
        $t3->allblue;
        $t2->down;        
    };

     # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the unit measure be D");
        $l{D}= Line->new($pn,$ds,$y4,$ds+$D,$y4);
        $p{D}= Point->new($pn,$ds,$y4)->label("D","left");
        $t2->math("D = 1");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let C have as many units that is equal to ".
        "the number of times that B measures A");
        $t2->math("C = c\\{dot}1");
        $l{C}= Line->new($pn,$ds,$y3,$ds+$C,$y3);
        $p{C}= Point->new($pn,$ds,$y3)->label("C","left");
        $l{C}->parts($C/$D,6,"top",$turquoise);
        $l{D}->parts($D/$D,6,"top",$turquoise);
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("B measures A according to the units in C, and the ".
        "unit D also measures the number C according to the units in it...");
        $t2->math("C = c\\{dot}D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... therefore ".
        "D measures the number C the same number of times as B measures A");
        $t2->allgrey;
        $t2->black([-1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Consequently, D measures the number B the same number of ".
        "times as C measures A (VII.15)");
        $t2->allgrey;
        $t2->black([-1]);
        $t2->math("B = b\\{dot}D");
        $t2->math("A = b\\{dot}C");
        $l{B}->parts($B/$D,6,"bottom",$turquoise);
        $l{A}->parts($A/$C,6,"bottom",$pale_pink);
        $l{C}->parts($C/$C,6,"bottom",$pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So whatever part D is of the number B, so is the part C of A");
        $t2->allgrey;
        $t3->allgrey;
        $t2->black([-1,-2]);
        $t2->math("D = (1/b)B");
        $t2->math("C = (1/b)A");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But the unit D is a part of the number B called by the same name as it");
        $t2->allgrey;
        $t2->black([-2]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore A has a part C, which is called by the same number as B");
        $t2->allgrey;
        $t2->black([-1]);
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t2->allgrey;
        $t2->black([-1]);
        $t3->blue([-1]);
    };



    
    return $steps;

}

