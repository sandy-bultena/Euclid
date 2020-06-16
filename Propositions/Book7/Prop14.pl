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
my $title = "If there be as many numbers as we please, and others equal to ".
"them in multitude, which taken two and two are in the same ratio, they will ".
"also be in the same ratio ex aequali";

$pn->title( 14, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 80, 300);
my $tp = $pn->text_box( 600, 180 );

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 14 );
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
    my $dy = 60;
    my $dy1 = $ds;
    my $dy2 = $ds + $dy;
    my $dy3 = $ds + 2*$dy;
    my $dy4 = $ds + 3*$dy;
    my $dy5 = $ds + 4*$dy;
    my $dy6 = $ds + 5*$dy;
    my $A = 60*$dx;
    my $B = 1/1.2*$A;
    my $C = $B/1.2;
    my $D = 80*$dx;
    my $E = 1/1.2*$D;
    my $F = 1/1.2*$E;
    my $xl = 40;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->title("In other words");
        $t1->explain("Given as many numbers as we please A,B,C");
        $t1->explain("And an equal number of others, D,E,F");
        $t1->explain("And let them be, two by two, in the same ratio (A is to B ".
        "as D is to E, B is to C as E is to F)");
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->math("A:B = D:E");
        $t4->math("B:C = E:F");
       $l{A} = Line->new($pn,$xl,$dy1,$xl+$A,$dy1)->label("A","bottom");
       $l{B} = Line->new($pn,$xl,$dy2,$xl+$B,$dy2)->label("B","bottom");
       $l{C} = Line->new($pn,$xl,$dy3,$xl+$C,$dy3)->label("C","bottom");
       $l{D} = Line->new($pn,$xl+$A+$xl,$dy1,$xl+$A+$xl+$D,$dy1)->label("D","bottom");
       $l{E} = Line->new($pn,$xl+$A+$xl,$dy2,$xl+$A+$xl+$E,$dy2)->label("E","bottom");
       $l{D} = Line->new($pn,$xl+$A+$xl,$dy3,$xl+$A+$xl+$F,$dy3)->label("F","bottom");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
       $t1->explain("Then, as A is to C, so is D to F");
       $t4->math("A:C = D:F");
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->math("A:B = D:E");
        $t4->math("B:C = E:F");
        $t1->down;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A is to B as D is to E, alternately, A is to ".
        "D as B is to E (VII.13)");
        $t4->grey([0..20]);
        $t4->black([-2]);
        $t4->math("A:D = B:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And since B is to C as E is to F, alternately, B is to ".
        "E as C is to F (VII.13)");
        $t4->grey([0..20]);
        $t4->black([-2]);
        $t4->math("B:E = C:F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The ratio of  B to E is the same as A to D and C to F, ".
        "consequently A to D equals C to F");
        $t4->grey([0..20]);
        $t4->black([-1,-2]);
        $t4->math("A:D = C:F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Alternately, A to C is equal to D to F (VII.13)");
        $t4->grey([0..20]);
        $t4->black([-1]);
        $t4->math("A:C = D:F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->grey([0..20]);
        $t4->blue([0,1,-1]);
    };




    return $steps;

}

