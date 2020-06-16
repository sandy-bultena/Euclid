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
    "If a first magnitude be the same multiple of a second that a third "
  . "is of a fourth, and a fifth also be the same multiple of the second that a "
  . "sixth is of the fourth, the sum of the first and fifth will also be the same "
  . "multiple of the second that the sum of the third and sixth is of the fourth";

$pn->title( 2, $title, 'V' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 550, 175, -width => 480 );
my $t3 = $pn->text_box( 100, 400 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 2 );
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

    #    push @$steps, Proposition::title_page4($pn);
    my ( %l, %p, %c, %s, %a );
    my $k  = 3;
    my $k2 = 2;
    my @A  = ( 150, 200 );
    my @B  = ( 300, 200 );
    my @C  = ( 150, 250 );
    my @D  = ( 150, 300 );
    my @E  = ( 350, 300 );
    my @F  = ( 150, 350 );
    my @G  = ( $B[0] + ( $B[0] - $A[0] ) * $k2 / $k, 200 );
    my @H  = ( $E[0] + ( $E[0] - $D[0] ) * $k2 / $k, 300 );

    my @c = ( 240, 400 );
    my $r = 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain(
                    "If we have two lines (AB and DE) that are equal multiples "
                      . "of two other lines (C and F respectively) and ..." );
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{DE} = Line->join( $p{D}, $p{E} );
        $l{C} =
          Line->new( $pn, @C, $C[0] + ( 1 / $k ) * $l{AB}->length, $C[1] );
        $l{F} =
          Line->new( $pn, @F, $F[0] + ( 1 / $k ) * $l{DE}->length, $F[1] );

        $l{AB}->tick_marks( $l{C}->length );
        $l{DE}->tick_marks( $l{F}->length );

        $t4->math("AB = first line");
        $t4->math("C  = second line");
        $t4->math("DE = third line");
        $t4->math("F  = fourth line");

        $t3->math("If   AB=n\\{dot}C, DE=n\\{dot}F");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain(
                    "we have another two lines (BG and EH) that are also equal "
                      . "multiples of lines C and F, then..." );
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
        $l{BG} = Line->join( $p{B}, $p{G} );
        $l{EH} = Line->join( $p{E}, $p{H} );
        $l{BG}->tick( $l{C}->length );
        $l{EH}->tick( $l{F}->length );
        $t3->math("and  BG=m\\{dot}C, EH=m\\{dot}F");
        $t3->allblue;

        $t4->math("BG = fifth line");
        $t4->math("EH = sixth line");
    };

    push @$steps, sub {
        $t1->explain(
                  "the line AG will be the same multiplier of C as DH is to F");
        $t3->math("then AG=k\\{dot}C and DH=k\\{dot}F");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof");
        $t3->erase();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "Since AB and DE are the same multiples of C and F respectively, "
              . "then there are the an equal number of magnitudes (line segments) in AB and DE"
        );
        $t3->math("AB = n\\{dot}C,  DE = n\\{dot}F");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
               "For the same reason, there is an equal number of magnitudes in "
                 . "lines BG and EH" );
        $t3->math("BG = m\\{dot}C,  EH = m\\{dot}F");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Thus, the total number of magnitudes of "
            . "size C in line AG       (m+n) "
            . "is equal to the total number of magnitudes of size F in line DH  (m+n)"
        );
        $t3->math("AG = AB + BG = n\\{dot}C + m\\{dot}C = (n+m)\\{dot}C");
        $t3->math("DH = DE + EH = n\\{dot}F + m\\{dot}F = (n+m)\\{dot}F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain( "Or, AG is the same multiple of C that DG is of F");
    };

    return $steps;

}

