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
my $title = "If two numbers by multiplying one another make certain numbers, ".
"the numbers so produced will be equal to one another";

$pn->title( 16, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);
$t4->wide_math(1);
$t5->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 16 );
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
    my $ds = 180;
    my $dx = 40;
    my $dy = 40;
    my $dy1 = $ds;
    my $dy2 = $ds + $dy;
    my $dy3 = $ds + 2*$dy;
    my $dy4 = $ds + 3*$dy;
    my $dy5 = $ds + 4*$dy;
    my $dy6 = $ds + 5*$dy;
    my $A = 2*$dx;
    my $B = 3*$dx;
    my $C = 6*$dx;
    my $D = $C;
    my $E = $A/2;
    my $xl = 60;
    my $y;
    my $yy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Definition");
        $t4->erase;
            $t1->point("A number is said to multiply a number when that which is multiplied is added to itself as many times as there are units in the other, and thus some number is produced.",15);            
        $t1->title("In other words");
        $t1->explain("Commutative property... A times B equals B times A");
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->math("C = A\\{times}B");
        $t4->math("D = B\\{times}A");
        $t4->math("\\{then} C = D");
        $p{A}= Point->new($pn,$xl+$A,$dy1)->label("A","right");
        $p{B}= Point->new($pn,$xl+$B,$dy2)->label("B","right");
        $p{C}= Point->new($pn,$xl,$dy3)->label("C","left");
        $p{D}= Point->new($pn,$xl,$dy4)->label("D","left");
       $l{A} = Line->new($pn,$xl,$dy1,$xl+$A,$dy1);
       $l{B} = Line->new($pn,$xl,$dy2,$xl+$B,$dy2);
       $l{C} = Line->new($pn,$xl,$dy3,$xl+$C,$dy3);
       $l{D} = Line->new($pn,$xl,$dy4,$xl+$D,$dy4);
       
    };

    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->down;
        $t4->down;
        $t4->down;
        $t1->erase;
        $t1->title("In other words");
        $t1->explain("Commutative property... A times B equals B times A");
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Let C be the result of A times B, and let D be the result of B times A");
        $t4->math("C = A\\{times}B");
        $t4->math("D = B\\{times}A");
        $t4->down;
        $yy = $t4->y;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since C is equal to B multiplied by A, B measures ".
        "C the same number of times that the unit length E measures A");
        $t4->grey([1,3..20]);
        $t4->math("C = \\{sum(i=1,a)} B");
        $l{B}->show_parts(1,undef,undef,$turquoise);
        $l{C}->show_parts($C/$B,undef,undef,$turquoise);
        $t4->math("A = \\{sum(i=1,a)} E");
        $t4->math("E = 1");
        $p{E}= Point->new($pn,$xl+$E,$dy5)->label("E","right");
        $l{E} = Line->new($pn,$xl,$dy5,$xl+$E,$dy5);
        $l{E}->show_parts(1,undef,undef,$pale_pink);
        $l{A}->show_parts($A/$E,undef,undef,$pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, alternately, the unit E measures the number B".
        " the same number of times that A measures C (VII.15)");
        $t4->grey([0..20]);
        $t4->black([-1,-2,2]);
        $t4->math("B = \\{sum(i=1,b)} E");
        $y = $t4->y;
        $t4->math("C = \\{sum(i=1,b)} A");
        $l{B}->show_parts($B/$E,undef,"top",$pale_pink);
        $l{A}->show_parts(1,undef,"top",$purple);
        $l{C}->show_parts($C/$A,undef,"top",$purple);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t5->y($yy);
        $t1->explain("Similarly, since D is is equal to A  multiplied by B, A measures ".
        "D the same number of times that the unit E measures B");
        $t4->black([0..20]);
        $t4->grey([0,2..20]);
        $t5->math("D = \\{sum(i=1,b)} A");
        $l{D}->show_parts($D/$A,undef,"top",$purple);
        $t5->math("B = \\{sum(i=1,b)} E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But the unit E measured the number B the same number ".
        "of times that A measures C");
        $t4->grey([0..20]);
        $t4->black([-1,-2]);
        $t5->grey([0..20]);
        $t5->black([0,2,-1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore C equals D");
        $t4->grey([0..20]);
        $t4->black([-1]);
         $t5->grey([0..20]);
        $t5->black([0,2]);
        $t5->math("C = D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->grey([0..20]);
        $t5->grey([0..20]);
        $t4->blue([0,1]);        
        $t5->blue([-1]);        
    };





    return $steps;

}

