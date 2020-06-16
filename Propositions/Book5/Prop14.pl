#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If a first magnitude have to a second the same ratio as a third ".
    "has to a fourth, and the first be greater than the third, the second ".
    "will also be greater than the fourth; if equal, equal; and if less, less.";

$pn->title( 14, $title, 'V' );

my $down    = 40;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 160, 200 + 2 * $down + $offset );
my $t4      = $pn->text_box( 160, 200 + 0 * $down );
my $t2      = $pn->text_box( 400, 200 + 2 * $down + $offset);
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 14 );
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
    my ( %l, %p, %c, %s, %a );
    my $p      = 1.8/3;
    my $k      = 2;
    my $k2     = 3;
    my $a      = 160;
    my $c      = 120;
    my $b      = $a * $p;
    my $d      = $c * $p;
    my $offset = 20;
    my @start  = (150,150+$a+100);
    my @A      = ( $start[0], 200 );
    my @C      = ( $start[1], 200 );
    my @B      = ( $start[0], $A[1] + $down );
    my @D      = ( $start[1], $C[1]  + $down);

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("If A is to B as C is to D, and A is greater than C ...");
        $t1->explain("... then B is also greater than D");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );

        $t3->math("A:B = C:D");
        $t3->math("A >=< C");
        $t3->blue( [ 0,1 ] );
        $t3->math("\\{then} B >=< D");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("A:B = C:D");
        $t3->math("A > C");
        $t3->blue( [ 0,1 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A is greater than C, and B is another arbitrary ".
        "magnitude, then the ratio of A to B is larger than the ratio C ".
        "to\\{nb}B (V.8)");
        $t3->down;
        $t3->grey(0);
        $t3->math("A:B > C:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But A is to B as C is to D, so the ratio of C to D is".
        " also greater than C is to B (V.13)");
        $t3->grey([0..20]);
        $t3->blue([0]);
        $t3->black(2);
        $t3->math("C:D > C:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If the C to D is greater than the ratio C to B, ".
        "then D is less than\\{nb}B (V.10)");
        $t3->grey([0..20]);
        $t3->black(3);
        $t3->math("D < B");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t3->blue([0,1]);
        $t1->explain("Thus, if A is greater than C, B is greater than D");
        $t3->math("B > D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->blue([0,1]);
        $t3->black(-1);
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t1->down;
        $t1->explain("Similarly, if A is equal to C, then B is equal to D, and "
        ."if A is less than C, then B is less than D");
        $t3->math("A = C \\{then} B = D");
        $t3->math("A < C \\{then} B < D");
    };

    return $steps;

}

