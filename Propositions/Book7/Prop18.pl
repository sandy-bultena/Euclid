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
my $title = "If two numbers by multiplying any number make certain numbers, ".
"the numbers so produced will have the same ratio as the multipliers";

$pn->title( 18, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 18 );
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
    my $dy4 = $dy3 + $dy;
    my $dy5 = $dy4 + $dy;
    my $dy6 = $dy5 + $dy;
    my $A = 3*$dx;
    my $B = 4*$dx;
    my $C = 2*$dx;
    my $D = 6*$dx;
    my $E = 8*$dx;
    my $xl = 240;
    my $y;
    my $yy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->title("In other words");
        $t1->explain("The ratio A to B is equal to the ratio as A times C to B times C");
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->math("D = A\\{times}C");
        $t4->math("E = B\\{times}C");
        $t4->math("\\{then} A:B = D:E");
        $p{A}= Point->new($pn,$xl,$dy1)->label("A","left");
        $p{B}= Point->new($pn,$xl,$dy2)->label("B","left");
        $p{D}= Point->new($pn,$xl,$dy3)->label("D","left");
        $p{E}= Point->new($pn,$xl,$dy4)->label("E","left");
       $l{A} = Line->new($pn,$xl,$dy1,$xl+$A,$dy1);
       $l{B} = Line->new($pn,$xl,$dy2,$xl+$B,$dy2);
       $l{D} = Line->new($pn,$xl,$dy3,$xl+$D,$dy3);
       $l{E} = Line->new($pn,$xl,$dy4,$xl+$E,$dy4);
       $l{C} = Line->new($pn,$xl-$C-100,$dy1,$xl-100,$dy1)->label("C","bottom");
    };

    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->down;
        $t4->down;
        $t4->down;
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Let D be the result of A times C, and let E be the result of B times C");
        $t4->math("D = A\\{times}C");
        $t4->math("E = B\\{times}C");
        $t4->down;
        $yy = $t4->y;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since D is equal to A multiplied by C, D is also equal to ".
        "C multiplied by A (VII.16)");
        $t4->grey([1..20]);
        $t4->math("D = C\\{times}A");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, E is equal to C multiplied by B");
        $t4->grey([0..20]);
        $t4->black(1);
        $t4->math("E = C\\{times}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, the numbers D,E have been made by multiplying ".
        "C by A,B, and thus A is to B as D is to E (VII.17)");
        $t4->grey([0..20]);
        $t4->black([-1,-2]);
        $t4->math("A:B = D:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->grey([0..20]);
        $t4->blue([0,1,-1]);        
    };





    return $steps;

}

