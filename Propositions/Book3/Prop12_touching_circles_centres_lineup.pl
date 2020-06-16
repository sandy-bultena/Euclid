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
my $title = "If two circles touch one another externally, the straight "
  . "line joining their centres will pass through the point of contact.";

$pn->title( 12, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 500, 240 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 12 );
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

    my @c1     = ( 120, 220 );
    my $r1     = 85;
    my $offset = 50;
    my $deltax = 15;
    my $deltay = 25;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain( "Given two circles, external to each other, touching "
               . "at point A where F and G are the centres of the circles..." );
        $p{F} = Point->new( $pn, @c1 )->label( "F", "left" );
        $p{A} =
          Point->new( $pn, $c1[0] + $r1, $c1[1] + $offset )
          ->label( "A ", "top" );
        $p{G} =
          Point->new( $pn, $p{A}->x + 1.25 * $r1, $p{A}->y + 1.25 * $offset )
          ->label( "G", "bottom" );

        $c{B} =
          Circle->new( $pn, $p{F}->coords, $p{A}->coords )->label( "B", "top" );
        $c{E} =
          Circle->new( $pn, $p{G}->coords, $p{A}->coords )
          ->label( "E", "right" );

        $t3->explain("F center of AB");
        $t3->explain("G center of AE");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "Then the line joining G and F, will pass through the point\\{nb}A"
        );
        $l{FG} = Line->join( $p{F}, $p{G} );

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t3->down;
        $l{FG}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that the line FG does not pass through A...");
        my ( $x, $y ) = $p{G}->coords;
        $p{G}->remove;
        $p{G} =
          Point->new( $pn, $x - $deltax, $y + $deltay )->label( "G", "right" );
        ( $x, $y ) = $p{F}->coords;
        $p{F}->remove;
        $p{F} =
          Point->new( $pn, $x - $deltax, $y + $deltay )->label( "F", "left" );

        $t1->explain("The line FG intersects the circles at points C and D");
        $l{FG} = Line->join( $p{F}, $p{G} );
        my @p = $c{B}->intersect( $l{FG} );
        $p{C} = Point->new( $pn, @p[ 0, 1 ] )->label( "C",  "left" );
        @p    = $c{E}->intersect( $l{FG} );
        $p{D} = Point->new( $pn, @p[ 0, 1 ] )->label( " D", "bottom" );
        $t3->explain("Assume F,G,A are not collinear");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Join the lines AG, and AF");
        $l{AG} = Line->join( $p{A}, $p{G} );
        $l{AF} = Line->join( $p{A}, $p{F} );
        $t3->math("AF = FC");
        $t3->math("AG = GD");
        $t3->math("GF = GD + FC + CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The sum of two sides of a triangle is larger "
                      . "than the third\\{nb}(I.20)" );
        $s{AFG} =
          Triangle->new( $pn, $p{A}->coords, $p{F}->coords, $p{G}->coords )
          ->fill($sky_blue);
        $t3->allgrey;
        $t3->math("AG + AF > GF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "AF is equal to FC, and AG is equal to GD "
                      . "(radii of respective circles)" );
        $s{AFG}->remove;
        $t3->allgrey;
        $t3->black( [ -1, -3, -4 ] );
        $t3->math("GD + FC > GF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "But GF is the sum of GD, FC, and CD, so GD,FC "
                      . "together is less than GF" );
        $t3->allgrey;
        $t3->black(-3);
        $t3->math("GF > GD + FC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Therefore, we have a contradiction, and thus "
                      . "F, A, G must form a straight line." );
        $t3->allgrey;
        $t3->red( [ -1, -2 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Which means the original assumption is wrong");
        $t3->allgrey;
        $t3->red(2);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->explain("F,A,G are collinear");
    };

    return $steps;

}

