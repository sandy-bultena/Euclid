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
my $title = "Equal magnitudes have the same ratio, as also has the same "
  . "to equal magnitudes";

$pn->title( 7, $title, 'V' );

my $down    = 50;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t4      = $pn->text_box( 550, 375, -width => 480 );
my $t3      = $pn->text_box( 160, 200 + 3 * $down );
my $t2      = $pn->text_box( 400, 200 + 3 * $down );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 7 );
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
    my $p  = 1 / 1.2;
    my $k  = 4;
    my $k2 = 3;
    my $a  = 45;
    my $c  = 65;
    my @A  = ( 150, 200 );
    my @B  = ( 150, 200 + $down );
    my @C  = ( 150, 200 + 2 * $down );
    my @D  = ( 250, 200 );
    my @E  = ( 250, 200 + $down );
    my @F  = ( 250, 200 + 2 * $down );

    # -------------------------------------------------------------------------
    # Definitions
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Definitions");
        $tdot->y($t1->y);
        $tindent->y($t1->y);

        $tdot->explain("5.");
        $tindent->explain("Magnitudes are said to BE IN THE SAME RATIO, the first ".
        "to the second and the third to the fourth, when, if any equimultiples ".
        "whatever be taken of the first and third, and any equimultiples whatever ".
        "of the second and fourth, the former equimultiples alike exceed, ".
        "are alike equal to, or alike fall short of, the latter equimultiples ".
        "respectively taken in corresponding order");
        $tdot->y($tindent->y);

        $t3->math("The ratio A:B = C:D if, for any number 'p' and 'q'");
        $t3->math("  if pA > qB then pC > qD");
        $t3->math("  if pA < qB then pC < qD");
        $t3->math("  if pA = qB then pC = qD");
        $t3->down;
        $t3->math("if   A:B = C:D");
        $t3->math("then pA >=< qB \\{then} pC >=< qD");
    };

    push @$steps, sub {
        $tdot->erase;
        $tindent->erase;
        $t3->erase;
        $t1->erase;
    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let A,B be equal, and C not equal");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );

        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $l{B} = Line->new( $pn, @B, $B[0] + $a, $B[1] );

        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $t3->math("A = B \\{notequal} C");
        $t3->blue(0);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Then the ratio of A to C is the same as the ratio of B to C ");
        $t3->math("A:C = B:C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                 "And the ratio of C to A is the same as the ratio of C to B ");
        $t3->math("C:A = C:B");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->down();
        $t1->title("Proof");
        $t3->math("A = B \\{notequal} C");
        $t3->blue(0);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let equimultiples D,E, be taken of magnitudes A,B");

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $l{D} = Line->new( $pn, @D, $D[0] + $k * $a, $D[1] )->tick_marks($a);
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $l{E} = Line->new( $pn, @E, $E[0] + $k * $a, $E[1] )->tick_marks($a);

        $t3->math("D = nA");
        $t3->math("E = nB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And let another multiple F be taken of C");

        $p{F} = Point->new( $pn, @F )->label( "F", "top" );
        $l{F} = Line->new( $pn, @F, $F[0] + $k2 * $c, $F[1] )->tick_marks($c);
        $t3->math("F = mC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since D is the same multiple of A that E is of B, and "
                      . "A is equal to B, then D is equal to E" );

        $t3->grey(3);
        $t3->math("D = E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "F is another arbitrary magnitude, so if D is greater than "
                      . "F, then so E is also greater than F, and so on" );

        $t3->grey( [ 1, 2 ] );
        $t2->down;
        $t2->down;
        $t2->math("D  >=< F  \\{then} E  >=< F");
        $t2->math("nA >=< mC \\{then} nB >=< mC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("This is the requirement for equal ratios, so...");
        $t1->explain("... A is to C as B is to C\\{nb}(V Def 5)");

        $t3->grey(3);
        $t3->grey(4);
        $t2->grey(0);
        $t2->math("A:C = B:C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Going back to D is equal to E, and F being an arbitrary "
                      . "magnitude..." );
        $t1->explain(
                    "If F is greater than "
                      . "D, then so F is also greater than E, and so on" );

        $t2->down;
        $t3->black(4);
        $t2->grey([1,2]);
        $t2->math("F  >=< D  \\{then} F  >=< E");
        $t2->math("mC >=< nA \\{then} mC >=< nB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("This is the requirement for equal ratios, so...");
        $t1->explain("... A is to C as B is to C\\{nb}(V Def 5)");

        $t3->grey(4);
        $t2->grey([3]);
        $t2->math("C:A = C:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey(4);
        $t2->black(2);
    };
    
    return $steps;

}

