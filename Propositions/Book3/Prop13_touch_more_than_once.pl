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
my $title = "A circle does not touch a circle at more points than one, "
  . "whether it touch it internally or externally.";

$pn->title( 13, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 500, 240 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 13 );
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

    my @c1 = ( 260, 360 );
    my $r1 = 150;
    my $r2 = 125;
    my $r3 = 75;
    my @c2 = ( $c1[0], $c1[1] - ( $r2 - $r1 ) );
    my @c3 = ( .707 * ( $r1 + $r3 ) + $c1[0], -.707 * ( $r1 + $r3 ) + $c1[1] );
    my $deltax = 15;
    my $deltay = 25;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $c{B} = Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] );
        $c{E} = Circle->new( $pn, @c3, $c3[0] + $r3, $c3[1] );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof by Contradiction");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Assume that the inner circle EBD touches "
                      . "the green circle ABDC at two points B and D" );
        $t1->explain(   "Assume that the outer circle ACK touches "
                      . "the green circle ABDC at two points A and C" );
        $c{E}->remove;
        $c{B}->remove;
        $p{B} = $c{A}->point( 180 + 45 )->label( "B", "bottom" );
        $p{D} = $c{A}->point(-45)->label( "D", "bottom" );
        $c{A}->green;
        $c{Bb} = Arc->new( $pn, 1.5 * $r1, $p{B}->coords, $p{D}->coords );
        $c{Bt} =
          Arc->newbig( $pn, 130, $p{D}->coords, $p{B}->coords )->fill($sky_blue)
          ->label( "E", "top" );
        $c{E} =
          Circle->new( $pn, $c3[0] - 25, $c3[1], $c3[0] + $r3 - 25, $c3[1] )
          ->label( "K", "topright" );
        my @p = $c{A}->intersect( $c{E} );
        $p{A} = Point->new( $pn, @p[ 0, 1 ] )->label( "A", "left" );
        $p{C} = Point->new( $pn, @p[ 2, 3 ] )->label( "C", "bottom" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain(
            "Let G be the centre of ABDC, and H be the centre of the circle EBD"
        );
        $c{E}->grey;
        $l{BD} = Line->join( $p{B}, $p{D} );
        $p{G} =
          Point->new( $pn, $p{B}->x + ( 1 / 3 ) * $l{BD}->length, $p{B}->y )
          ->label( "G", "top" );
        $p{H} =
          Point->new( $pn, $p{B}->x + ( 2 / 3 ) * $l{BD}->length, $p{B}->y )
          ->label( "H", "top" );
        $l{BD}->remove;
        $t3->math("BG = GD");
        $t3->math("BH = HD");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The straight line GH will intersect the points "
                      . "where the circles touch\\{nb}(III.11)" );
        $l{BD} = Line->join( $p{B}, $p{D} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("GD is greater than HD");
        $t3->allgrey;
        $t3->math("GD > HD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Therefore BG is greater than HD, since BG and GD are "
                      . "equal (radii of the same circle)" );
        $t3->allgrey;
        $t3->black( [ -1, -3 ] );
        $t3->math("\\{therefore} BG > HD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, BH is much much greater than HD");
        $t2->y( $t3->y );
        $t3->allgrey;
        $t3->black( [-1] );
        $t3->math("BH > BG > HD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But H is the centre of the circle, so BH equals HD ");
        $t3->allgrey;
        $t3->black(1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Which is a contradiction");
        $t3->allgrey;
        $t3->red( [ 1, -1 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Thus demonstrating that "
            . "an inner circle cannot touch an outer circle in more than one place"
        );
        $t3->allgrey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{BD}->grey;
        $c{Bb}->grey;
        $c{Bt}->grey;
        $c{E}->normal;
        $t1->erase;
        $t1->title("Proof by Contradiction");
        $t1->explain(   "Assume that the inner circle EBD touches "
                      . "the green circle ABDC at two points B and D" );
        $t1->explain(   "Assume that the outer circle ACK touches "
                      . "the green circle ABDC at two points A and C" );
        $t1->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Join AC");
        $l{AC} = Line->join( $p{A}, $p{C} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "According to III.2, a line joining two points on a "
                      . "circle lies within the circle" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "... but if circle ACK only touches circle ABDC, then "
                      . "the line must lie outside of ACK" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "This is impossible, so an outer circle cannot touch "
                      . "another circle in more than one place" );
    };

    return $steps;

}

