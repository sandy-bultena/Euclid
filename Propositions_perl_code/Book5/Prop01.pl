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
    "If there be any number of magnitudes whatever which are, "
  . "respectively, equimultiples of any magnitudes equal in  multitude, "
  . "then, whatever multiple one the magnitudes is of one, that "
  . "multiple also will all be of all";

$pn->title( 1, $title, 'V' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 480 );
my $t3      = $pn->text_box( 100, 350 );
my $t2      = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 1 );
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
    my $k = 2;
    my @A = ( 150, 200 );
    my @B = ( 300, 200 );
    my @E = ( 150, 250 );
    my @C = ( 350, 200 );
    my @D = ( 550, 200 );
    my @F = ( 350, 250 );

    my @c = ( 240, 400 );
    my $r = 180;

    # -------------------------------------------------------------------------
    # Definitions
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Definitions");
        $tdot->y( $t1->y );
        $tindent->y( $t1->y );
        $tdot->explain("1.");
        $tindent->explain(   "A magnitude is a PART of a magnitude, the less "
                           . "of the greater, when it measures the greater" );
        $tdot->y( $tindent->y );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{E} =
          Line->new( $pn, @E, $E[0] + ( 1 / $k ) * $l{AB}->length, $E[1] );
        $l{AB}->tick_marks( $l{E}->length );

        $t3->math("(1) E is a part of AB, it measures AB");
    };

    push @$steps, sub {
        $tdot->explain("2.");
        $tindent->explain(   "The greater is a MULTIPLE of the less when "
                           . "it is measured by the less" );
        $tdot->y( $tindent->y );

        $t3->math("(2) AB is a multiple of E");
    };

    push @$steps, sub {
        $tdot->erase;
        $tindent->erase;
        $t3->erase;
        $t1->erase;
        $p{A}->remove;
        $p{B}->remove;
        $p{E}->remove;
        $l{AB}->remove;
        $l{E}->remove;
    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain(
                 "If we have two lines (AB and CD) that are equal multiples of "
                   . "two other lines (E and F respectively) then ..." );
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{CD} = Line->join( $p{C}, $p{D} );
        $l{E} =
          Line->new( $pn, @E, $E[0] + ( 1 / $k ) * $l{AB}->length, $E[1] );
        $l{F} =
          Line->new( $pn, @F, $F[0] + ( 1 / $k ) * $l{CD}->length, $E[1] );

        $t3->math("If   AB = n\\{dot}E, CD = n\\{dot}F");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain(   "The sum of AB and CD will also be an equal "
                      . "multiple of the sum of E and F" );
        $t3->math("then AB + CD = n\\{dot}(E + F)");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof");
        $t3->erase();
        $t3->math("AB = 2E, CD = 2F");
        $t3->blue(0);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Let AB be divided into segments (magnitudes) of equal "
                      . "lengths, where each magnitude is equal to E" );
        $l{AB}->tick( $l{E}->length, 'G' );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Let CD be divided into equal lengths, where "
                      . "each length is equal to F" );
        $l{CD}->tick( $l{F}->length, 'H' );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Since AB and CD are equal multitudes of E and F respectively, "
                  . "they will be divided into the same number of magnitudes" );
        $t3->math("AG = GB = E");
        $t3->math("CH = HD = F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Now, since AG equals E, and CH equals F, then AG and CH "
                      . "together is equal to E and F" );
        $t3->math("AG + CH = E + F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Similarly, since GB equals E, and HD equals F, then GB and HD "
                  . "together is equal to E and F" );
        $t3->math("GB + HD = E + F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                   "Therefore for every length E within the length AB there is "
                     . "a length E+F in the sum of AB and CD" );
        $t3->grey( [ 1, 2 ] );
        $t3->math("AG+CH + GB+HD = (E+F) + (E+F) = 2(E+F)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "In more general terms, for however many "
                      . "magnitudes in AB equal to E, there are that "
                      . "many magnitudes in CD that are equal to F." );
        $t3->down();
        $t3->allgrey;
        $t3->math(
                 "If   AB=n\\{dot}E and CD=n\\{dot}F then AB+CD=n\\{dot}(E+F)");
    };

    return $steps;

}

