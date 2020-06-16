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
    "If a first magnitude be the same multiple of a second that a "
  . "third is of a fourth, and if equimultiples be taken of the first and third, "
  . "then also, ex aequali, the magnitudes taken will be equimultiples respectively, "
  . "the one of the second, and the other of the fourth.";

$pn->title( 3, $title, 'V' );

my $down = 30;
my $t1   = $pn->text_box( 800, 150, -width => 500 );
my $t4   = $pn->text_box( 550, 375, -width => 480 );
my $t3   = $pn->text_box( 160, 200 + 6 * $down );
my $t2   = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 3 );
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
    my $k  = 3;
    my $b  = 75;
    my $d  = 50;
    my $k2 = 2;
    my @A  = ( 150, 200 );
    my @B  = ( 150, 200 + $down );
    my @C  = ( 150, 200 + 3 * $down );
    my @D  = ( 150, 200 + 4 * $down );
    my @E  = ( 150, 200 + 2 * $down );
    my @G  = ( 150, 200 + 5 * $down );
    my @H;
    my @F;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "If we have two lines (A and C) that are equal multiples "
                      . "of two other lines (B and D respectively) and ..." );
        $p{A} = Point->new( $pn, @A )->label( "A", "left" );
        $p{B} = Point->new( $pn, @B )->label( "B", "left" );
        $p{C} = Point->new( $pn, @C )->label( "C", "left" );
        $p{D} = Point->new( $pn, @D )->label( "D", "left" );

        $l{A} = Line->new( $pn, @A, $A[0] + $k * $b, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b,      $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $k * $d, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d,      $D[1] );

        $l{A}->tick_marks($b);
        $l{C}->tick_marks($d);

        $t3->math("If   A=n\\{dot}B, C=n\\{dot}D");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain(   "we draw two new lines (E and G), "
                      . "equimultiple to A and C respectively ..." );
        $p{G} = Point->new( $pn, @G )->label( "G", "left" );
        $p{E} = Point->new( $pn, @E )->label( "E", "left" );
        $l{E} = Line->new( $pn, @E, $E[0] + 2 * $l{A}->length, $E[1] );
        $l{G} = Line->new( $pn, @G, $G[0] + 2 * $l{C}->length, $G[1] );
        $l{E}->tick_marks( $l{A}->length );
        $l{G}->tick_marks( $l{C}->length );

        ( undef, undef, @H ) = $l{G}->endpoints();
        ( undef, undef, @F ) = $l{E}->endpoints();

        $p{H} = Point->new( $pn, @H )->label( "H", 'top' );
        $p{F} = Point->new( $pn, @F )->label( "F", 'top' );

        $t3->math("and  EF=m\\{dot}A, GH=m\\{dot}C");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain(   "then the lines EF and GH will be "
                      . "equimultiples of B and D respectively" );
        $t3->math("then EF=k\\{dot}B and GH=k\\{dot}D");
        $t3->math("where n,m,k are integers");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof");
        $t3->erase();
        $t3->math(" A=n\\{dot}B,  C=n\\{dot}D");
        $t3->math("EF=m\\{dot}A, GH=m\\{dot}C");
        $t3->blue( [ 0, 1 ] );
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "Since EF and GH are the same multiples of A and C respectively, "
               . "then there are the an equal number of magnitudes in EF and GH"
        );
        $t3->math("EF = m\\{dot}A,  GH = m\\{dot}C, m = 2");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Divide EF into equal segments of length A (EK,KF) and "
                      . "divide GH into equal segments of length C (GL,LH)" );
        $l{E}->tick( $l{A}->length, "K", 'top' );
        $l{G}->tick( $l{C}->length, "L", 'top' );
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->math("EK = KF = A");
        $t3->math("GL = LH = C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "So now, a first magnitude EK is the "
                      . "same multiple of a second B "
                      . "that a third GL is of a fourth D, " );
        $t3->allgrey;
        $t3->blue(0);
        $t3->black( [ -1, -2 ] );
        $t3->math("EK = A = n\\{dot}B");
        $t3->math("GL = C = n\\{dot}D");
        $t4->math("EK = first line");
        $t4->math("B  = second line");
        $t4->math("GL = third line");
        $t4->math("D  = fourth line");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "And a fifth KF is also the same multiple of "
                      . "the second B that a sixth LH is of the fourth D, " );
        $t3->allgrey;
        $t3->blue(0);
        $t3->black( [ -3, -4 ] );
        $t3->math("KF = A = n\\{dot}B");
        $t3->math("LH = C = n\\{dot}D");
        $t4->math("KF = fifth line");
        $t4->math("LH = sixth line");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                 "Thus EF is the same multiple of B as GH is of D \\{nb}(V.2)");
        $t3->allgrey;
        $t3->black( [ -1, -2, -3, -4 ] );
        $t3->math(   "EF = EK + KF = n\\{dot}B + n\\{dot}B "
                   . "= m\\{dot}n\\{dot}B = k\\{dot}B" );
        $t3->math(   "GH = GL + LH = n\\{dot}D + n\\{dot}D "
                   . "= m\\{dot}n\\{dot}D = k\\{dot}D" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->black( [ -1, -2 ] );
    };

    return $steps;

}

