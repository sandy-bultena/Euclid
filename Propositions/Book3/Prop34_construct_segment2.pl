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
my $title = "From a given circle to cut off a segment admitting an angle "
  . "equal to a given rectilineal angle.";

$pn->title( 34, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 520, 200 );
my $t2 = $pn->text_box( 400, 500 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 34 );
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

    my @c1 = ( 300, 450 );
    my $r1 = 190;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("In other words");
        $t4->explain("Given an angle D, and a circle...");
        my $yend = $c1[1] - 1.6 * $r1;
        my $xend = 150;
        $l{C1} = Line->new( $pn, $xend - 100, $yend, $xend, $yend );
        $l{C2} =
          Line->new( $pn, $xend - .30 * $r1, $yend + .35 * $r1, $xend, $yend );
        $p{D} = Point->new( $pn, $xend, $yend )->label( "D", "right" );
        $c{1} = Circle->new( $pn, $c1[0], $c1[1], $c1[0], $c1[1] + $r1 );
        $a{D} = Angle->new( $pn, $l{C1}, $l{C2} );

    };

    push @$steps, sub {
        $t4->explain(   "... construct a circle segment such that "
                      . "the angle within the segment is equal to D" );
        $p{A}    = $c{1}->point(90);
        $p{B}    = $c{1}->point(190);
        $l{AB}   = Line->join( $p{A}, $p{B} );
        $p{tmp}  = $c{1}->point(-10);
        $l{tmp1} = Line->join( $p{A}, $p{tmp} );
        $l{tmp2} = Line->join( $p{B}, $p{tmp} );
        $a{tmp}  = Angle->new( $pn, $l{tmp1}, $l{tmp2} )->label("D");
        $c{tmp}  = Arc->joinbig( $r1, $p{B}, $p{A} );
        $c{1}->grey;
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t3->erase;
        $t4->erase;
        $t4->title("Construction");
        $c{1}->normal;
        $c{tmp}->remove;
        $p{tmp}->remove;
        $l{tmp1}->remove;
        $l{tmp2}->remove;
        $a{tmp}->remove;
        $p{B}->remove;
        $p{A}->remove;
        $l{AB}->remove;
    };

    push @$steps, sub {
        $t4->explain("Draw a line FE touching the circle at point B (III.17)");
        $p{F} =
          Point->new( $pn, $c1[0] - $r1, $c1[1] - .8 * $r1 )
          ->label( "F", "top" );
        $p{E} =
          Point->new( $pn, $c1[0] - $r1, $c1[1] + .8 * $r1 )
          ->label( "E", "bottom" );
        $p{B} = Point->new( $pn, $c1[0] - $r1, $c1[1] )->label( "B", "left" );
        $l{FB} = Line->join( $p{F}, $p{B} );
        $l{BE} = Line->join( $p{B}, $p{E} );
    };

    push @$steps, sub {
        $t4->explain(   "Copy the angle D to line FB, such that angle "
                      . "FBC equals\\{nb}D\\{nb}(I.23)" );
        ( $l{BCt}, $a{FBA} ) = $a{D}->copy( $p{B}, $l{FB}, 'negative' );
        $a{FBA}->label("D");
        $l{BCt}->grey->extend( 2 * $r1 );
        my @p = $c{1}->intersect( $l{BCt} );
        $p{C} = Point->new( $pn, @p[ 0, 1 ] )->label( "C", "top" );
        $l{BC} = Line->join( $p{C}, $p{B} );
        $l{BCt}->remove;
    };

    push @$steps, sub {
        $t4->explain("The circle segment BCA contains the angle D");
        $c{1}->grey;
        $p{A} = $c{1}->point(-10)->label( "A", "right" );
        $c{BAC} = Arc->joinbig( $r1, $p{B}, $p{C} );
        $l{BA} = Line->join( $p{B}, $p{A} );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $a{BAC} = Angle->new( $pn, $l{AC}, $l{BA} )->label("D");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof");
    };

    push @$steps, sub {
        $t4->explain( "Since EF touches the circle, the angle FBC "
                 . "equals the angle in the opposite circle segment (III.32)" );
        $t4->explain( "The angle FBC is equal to D by construction, "
                  . "so thus the angle in the segment BCA equals D" );
    };

    return $steps;

}

