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
    "If there be three magnitudes, and others equal to them in multitude, "
  . "which taken two and two are in the same ratio, "
  . "and if EX AEQUALI the first be greater than the third the fourth "
  . "will also be greater than the sixth; if equal, equal; and, if less, less.";

$pn->title( 20, $title, 'V' );

my $down    = 40;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 160, 200 + 4 * $down + $offset );
my $t4      = $pn->text_box( 160, 200 + 0 * $down );
my $t2      = $pn->text_box( 400, 200 + 4 * $down + $offset );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 20 );
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
    my $p1     = 2 / 3;
    my $p2     = 3/2.5;
    my $a      = 250;
    my $b      = $a * $p1;
    my $c      = $b * $p2;
    my $d      = 200;
    my $e      = $d * $p1;
    my $f      = $e * $p2;
    my $offset = 20;
    my @A      = ( 150, 200 );
    my @B      = ( 150, $A[1] + $down );
    my @C      = ( 150, $B[1] + $down );
    my @D      = ( 150 + $a + 60, $A[1] );
    my @E      = ( $D[0], $B[1] );
    my @F      = ( $D[0], $C[1] );

    # -------------------------------------------------------------------------
    # Definitions
    # -------------------------------------------------------------------------

    push @$steps, sub {

        $tdot->erase;
        $tindent->erase;
        $t4->erase;
        $t1->erase;
        $t1->title("Definitions");
        $tdot->y( $t1->y );
        $tindent->y( $t1->y );

        $tdot->explain("17.");
        $tindent->explain(
                "A ratio EX AEQUALI arises when, there being several "
              . "magnitudes and another set equal to them in multitude which taken "
              . "two and two are in the same proportion, as the first is to the last "
              . "among the the first magnitudes, so is the first is to the last among "
              . "the second magnitudes" );
              
        $tindent->explain(
               "Or, in other words, it means taking the extreme terms by virtue ".
               "of the removal of the intermediate terms.");

        $t4->math("ratio EX AEQUALI");
        $t4->math("  a:b = d:e");
        $t4->math("  b:c = e:f");
        $t4->math("\\{then} a:c = d:f");


    };

    push @$steps, sub {
        $tdot->erase;
        $tindent->erase;
        $t1->erase;
        $t4->erase;

    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain(   "Given two sets of numbers A,B,C and D,E,F where A is ".
                        "to B as D is to E, and "
                      . "where B is to C as E is to F" );
        $t1->explain( "Then if A is greater than C, D will be greater than F, "
                      . "and if A is equal to C, D will be equal to F, etc" );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );
        $l{E} = Line->new( $pn, @E, $E[0] + $e, $E[1] );
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] );

        $t3->math("A:B = D:E");
        $t3->math("B:C = E:F");
        $t3->down;
        $t3->blue( [ 0, 1 ] );
        $t3->math("A >=< C \\{then} D >=< F");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("A:B = D:E");
        $t3->math("B:C = E:F");
        $t3->blue( [ 0, 1 ] );
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let A be greater than C");

        $t3->math("A > C");
        $t3->blue(2);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "If A is greater than C, when compared to another magnitude, "
                      . "in this case B, A will have a greater ratio to B "
                      . "than C will have to B (V.8)" );

        $t3->math("A:B > C:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the ratio B to C equals the ratio E to F, ".
        "then inverse ratios (C to B and F to E) are also equal (V.13)");
        $t3->grey([0,2,3]);
        $t3->math("C:B = F:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A to B is greater than C to B, and C to B equals ".
        "F to E, then A to B is greater than F to E");
        $t3->black([3]);
        $t3->grey(1);
        $t3->math("A:B > F:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And since A to B equals D to E, then D to E ".
        "is also greater than F to E");
        $t3->blue([0]);
        $t3->black([3]);
        $t3->grey([1..4]);
        $t3->math("D:E > F:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If D to E is greater than F to E, then D is ".
        "greater than F (V.10)");
        $t3->grey([0..5]);
        $t3->math("D > F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..6]);
        $t3->blue(2);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, we can prove that if A is equal to C, then ".
        "D is equal to F, and if less, less");
        $t3->grey([0..20]);
        $t3->blue([0,1]);
        $t3->down;
        $t3->math("A >=< C \\{then} D >=< F");
    };

    return $steps;

}

