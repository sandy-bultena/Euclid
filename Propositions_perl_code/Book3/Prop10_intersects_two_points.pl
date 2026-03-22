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
my $title = "A circle does not cut a circle at more points than two.";

$pn->title( 10, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 550, 240 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 10 );
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
    my $r1 = 180;
    my @c2 = ( $c1[0] + $r1 * .6, $c1[1] - $r1 * 2.3 );

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume we have two circles which intersect at 4 points");
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{H} = $c{A}->point(155)->label( "H", "left" );
        $p{F} = $c{A}->point(205)->label( "F", "left" );
        $p{B} = $c{A}->point(45)->label( "B", "top" );
        $p{G} = $c{A}->point(320)->label( "G", "bottom" );
        $c{BG} = Arc->new( $pn, .7 * $r1,  $p{G}->coords, $p{B}->coords );
        $c{HF} = Arc->new( $pn, .5 * $r1,  $p{H}->coords, $p{F}->coords );
        $c{BH} = Arc->new( $pn, 1.7 * $r1, $p{B}->coords, $p{H}->coords );
        $c{FG} = Arc->new( $pn, 1.7 * $r1, $p{F}->coords, $p{G}->coords );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{BG}->grey;
        $c{HF}->grey;
        $c{BH}->grey;
        $c{FG}->grey;
        $t1->explain("Join BH and bisect at point K");
        $l{BH} = Line->join( $p{B}, $p{H} );
        $p{K} = $l{BH}->bisect->label( "K", "topright" );
        $t3->math("HK = KB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Construct a line perpendicular to HB, at point K");
        $l{ACi} = $l{BH}->perpendicular( $p{K} )->prepend(300)->grey;
        my @p = $c{A}->intersect( $l{ACi} );
        $l{AC} = Line->new( $pn, @p );
        $p{A} = Point->new( $pn, @p[ 2, 3 ] )->label( "A", "top" );
        $p{C} = Point->new( $pn, @p[ 0, 1 ] )->label( "C", "bottom" );
        $l{ACi}->remove;
        $t3->math("AC \\{perp} HB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "From proposition III.1, we know that the "
                      . "centre of the circle lies on the line AC" );
        $l{BH}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AC}->grey;
        $t1->explain("Join BG and bisect at point L");
        $l{BG} = Line->join( $p{B}, $p{G} );
        $p{L} = $l{BG}->bisect->label( "L", "topright" );
        $t3->math("BL = LG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Construct a line perpendicular to BG, at point L");
        $l{NOi} = $l{BG}->perpendicular( $p{L} )->prepend(400)->grey;
        my @p = $c{A}->intersect( $l{NOi} );
        $l{NO} = Line->new( $pn, @p );
        $p{N} = Point->new( $pn, @p[ 2, 3 ] )->label( "N", "bottomright" );
        $p{O} = Point->new( $pn, @p[ 0, 1 ] )->label( "O", "bottomright" );
        $l{NOi}->remove;
        $t3->math("NO \\{perp} BG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "From proposition III.1, we know that the centre of "
                      . "the circle ABC lies on the line NO" );
        $l{BG}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AC}->normal;
        $t1->explain(   "If the centre of the circle is on AC and NO, "
                      . "then the centre of the circle ABC must be point P" );
        $p{P} =
          Point->new( $pn, $l{NO}->intersect( $l{AC} ) )
          ->label( "P", "bottomright" );
        $t3->explain("P is the centre of ABC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{A}->grey;
        $l{NO}->grey;
        $l{AC}->grey;
        $c{BG}->normal;
        $c{HF}->normal;
        $c{BH}->normal;
        $c{FG}->normal;
        $t1->down;
        $t1->explain(   "Using the same logic, it can be demonstrated "
                      . "that P is also the centre of DEF" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{BH}->normal;
        my @p1 = $c{BH}->intersect( $l{AC} );
        my @p2 = $c{FG}->intersect( $l{AC} );
        $l{DC} = Line->new( $pn, @p1, @p2 );
        $p{D} = Point->new( $pn, @p1 )->label( "D", "topleft" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        my $l = $l{NO}->clone->grey;
        $l->prepend(150);
        $l->extend(150);
        my @p1 = $c{BG}->intersect($l);
        my @p2 = $c{HF}->intersect($l);
        $l{DC}->grey;
        $l{BH}->grey;
        $p{M} = Point->new( $pn, @p2[ 0, 1 ] )->label( "M", "left" );
        $p{E} = Point->new( $pn, @p1[ 0, 1 ] )->label( "E", "right" );
        $l{ME} = Line->join( $p{M}, $p{E} );
        $l{BG}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t3->explain("P is the centre of DEF");
        $l{DC}->normal;
        $l{BG}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "But two intersecting circles cannot have the same centre "
              . "(III.5), hence a contradiction"
        );
        $c{A}->normal;
        $l{DC}->grey;
        $l{ME}->grey;
        $t3->allgrey;
        $t3->red([-1,-2]);
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->bold("Thus two circles cannot intersect at more than two points");
        $t3->allgrey;
    };

    return $steps;

}

