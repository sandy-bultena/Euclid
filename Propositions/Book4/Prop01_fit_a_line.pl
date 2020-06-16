#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);

# ============================================================================
# Definitions
# ============================================================================
my $title = "Into a given circle to fit a straight line equal to a given "
  . "straight line which is not greater than the diameter of the circle.";

$pn->title( 1, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc4( $pn, 1 );
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
    push @$steps, Proposition::title_page4($pn);
    my ( %l, %p, %c, %s, %a );

    my @c = ( 240, 400 );
    my $r = 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $c{A} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );
        $l{D} = Line->new( $pn, 275, 150, 430, 150 )->label( "D", "top" );

        $t1->explain("Given a circle and a straight line D, ");
        $t1->explain("  where D is less than the diameter of the circle");
        $t1->explain(
                "draw another line, with the same length "
              . "as D, in the circle such that the two ends touch the "
              . "circumference of the circle"
        );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{CDt} = Line->new( $pn, $c[0] + $r, $c[1], $c[0], $c[1] - $r, 0, 1 );

    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $l{CDt}->remove;
        $t1->title("Construction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw the diameter of the circle BC (III.1)");
        $p{B} = Point->new( $pn, $c[0] - $r, $c[1] )->label( "B", "left" );
        $p{C} = Point->new( $pn, $c[0] + $r, $c[1] )->label( "C", "right" );
        $l{BC} = Line->join( $p{B}, $p{C} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If BC equals D in length, then we are done");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "If BC is less than D, construct a line CE "
                      . "such that it is equal to D\\{nb}(I.2)" );
        ( $l{DE}, $p{E} ) = $l{D}->copy_to_line( $p{C}, $l{BC} );
        $p{E}->label( "E", "top" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                 "Draw another circle where C is the centre, with a radius CE");
        $c{F} = Circle->new( $pn, $p{C}->coords, $p{E}->coords )->grey;
        $t1->explain("Label the intersection A");
        my @p = $c{F}->intersect( $c{A} );
        $p{A} = Point->new( $pn, @p[ 0, 1 ] )->label( "A", "top" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw the line AC.  It is equal to line D");
        $l{AC} = Line->join( $p{A}, $p{C} );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("By construction, CE equals D");
        $t1->explain(
                   "CE equals AC since they are both radii of the same circle");
        $t1->explain("Hence, AC equals D");
    };

    return $steps;

}

