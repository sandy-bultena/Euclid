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
my $title =
    "If two circles touch one another internally, and their centres be "
  . "taken, the straight line joining their centres, if it be also produced, "
  . "will fall on the point of contact of the circles.";

$pn->title( 11, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 500, 240 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 11 );
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

    my @c1     = ( 260, 360 );
    my $r1     = 200;
    my $offset = 50;
    my $deltax = 15;
    my $deltay = 25;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain( "Given two circles, one inside the other, touching "
              . "at point A, where F and G are the centres of the circles..." );
        $c{A} =
          Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )
          ->label( "B", "bottomright" );
        $c{B} = Circle->new( $pn, $c1[0] - $offset,
                             $c1[1], $c1[0] + $r1 - 2 * $offset, $c1[1] )
          ->label( "C", "bottomright" );
        my @p = $c{A}->intersect( $c{B} );
        $p{A} = Point->new( $pn, @p[ 0, 1 ] )->label( "A", "left" );
        $p{F} = Point->new( $pn, @c1 )->label( "F", "bottom" );
        $p{G} =
          Point->new( $pn, $c1[0] - $offset, $c1[1] )->label( "G", "bottom" );

        $t3->explain("F center of AB");
        $t3->explain("G center of AC");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Then the line joining G and F, if extended, will "
                      . "intersect the point A" );
        $l{AF} = Line->join( $p{F}, $p{A} );

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t3->down;
        $l{AF}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{G}->remove;
        $p{G} =
          Point->new( $pn, $c1[0] - $deltax, $c1[1] - $deltay )
          ->label( "G", "topright" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Assume that the extension of the line FG does not "
                      . "fall on the point A" );
        $t1->explain(   "Let the line GF be extended such that it intersects "
                      . "the circles at D and H" );
        $l{FG} = Line->join( $p{F}, $p{G} );
        $l{FG}->extend(200)->grey;
        my @p = $c{A}->intersect( $l{FG} );
        $p{H} = Point->new( $pn, @p[ 0, 1 ] )->label( "H", "top" );
        @p    = $c{B}->intersect( $l{FG} );
        $p{D} = Point->new( $pn, @p[ 0, 1 ] )->label( "D", "bottom" );
        $l{FH} = Line->join( $p{F}, $p{H}, -1 );
        $l{FD} = Line->join( $p{F}, $p{D}, -1 );
        $t3->explain("F,G,A are not collinear");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Join the lines AG, and AF");
        $l{AG} = Line->join( $p{A}, $p{G} );
        $l{AF} = Line->join( $p{A}, $p{F} );
        $t3->math("AF = FH");
        $t3->math("AG = GD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The sum of two sides of a triangle is larger than "
                      . "the third\\{nb}(I.20)" );
        $s{AFG} =
          Triangle->new( $pn, $p{A}->coords, $p{F}->coords, $p{G}->coords )
          ->fill($sky_blue);
        $t3->allgrey;
        $t3->math("AG + GF > AF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But AF is equal to FH since the are radii of AB");
        $s{AFG}->remove;
        $t3->allgrey;
        $t3->black( [ -1, -3 ] );
        $t3->math("AG + GF > FH");
        $s{AFG}->grey;
        $l{AG}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Subtract GF from both sides, we have AG is "
                      . "greater than\\{nb}GH" );
        $l{AG}->normal;
        $l{FH}->grey;
        $l{GH} = Line->join( $p{G}, $p{H} );
        $l{AF}->grey;
        $l{FD}->grey;
        $t3->allgrey;
        $t3->black( [-1] );
        $t3->math("AG > FH - GF = GH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "AG is equal to GD since they are radii of AC, "
                      . "thus GD is greater than GH" );
        $t3->allgrey;
        $t3->black( [ -1, -4 ] );
        $t3->math("GD > GH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "But GD is the radius of the smaller circle, "
                      . "and GH is the radius of the larger circle" );
        $t3->allgrey;
        $t3->math("GD < GH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Hence the inconsistency");
        $t3->allgrey;
        $t3->red( [ -1, -2 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->red( [ 2 ] );
        $t3->blue([0,1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "And thus the straight "
                      . "line from G,F will fall on the "
                      . "intersection between the two circles" );
        $t3->allgrey;
        $t3->blue([0,1]);
        $t3->explain("F,G,A are collinear");
    };

    return $steps;

}

