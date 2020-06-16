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
my $title = "To construct a square equal to a given rectilineal figure.";

$pn->title( 14, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 200, 530 );
my $t3 = $pn->text_box( 500, 200 );

my $steps;
push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 14 );
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

    my @A = ( 150, 160, 300, 185, 250, 310, 90, 235 );
    my @K = ( 100, 400 );

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Construction");
        $t1->explain("Let A be the given rectilinear figure.");
        $s{A} = Polygon->new( $pn, 4, @A, 1,
                              -labels => [ undef, undef, "A  ", "left" ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Copy A to a rectangle\\{nb}(I.45)");
        $p{K} = Point->new( $pn, @K );
        $s{R} = $s{A}->copy_to_rectangle( $p{K}, -1 );
        $s{R}->set_points(qw(C left D right E topright B left));
        $s{R}->set_points(qw(B left E topright D right C left));
        $t3->math("\\{square}A = \\{square}BD");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If BE does not equal ED, and if BE is the larger, then");
        $t1->explain("extend BE to F, where EF equals ED");
        $p{B}  = $s{R}->p(1);
        $l{BF} = $s{R}->l(1)->clone();
        $l{BF}->extend(100);
        $c{E} =
          Circle->new( $pn, $s{R}->p(2)->coords, $s{R}->p(3)->coords )->grey;
        my @cuts = $c{E}->intersect( $l{BF} );
        $p{F} = Point->new( $pn, @cuts[ 0, 1 ] )->label(qw(F bottom));
        $l{BF}->remove;
        $l{BF} = Line->join( $p{B}, $p{F} );
        $t3->math("EF = BD");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Bisect BF (and label it point G)");
        $c{E}->remove();
        $p{G} = $l{BF}->bisect()->label(qw(G topleft));
        $t3->math("BG = GF");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a circle with G as the center and GF as the radii");
        $c{G} = Circle->new( $pn, $p{G}->coords, $p{F}->coords )->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Extend DE to intersect with the circle at "
                      . "point H, and let GH be joined" );
        $l{H1} = $s{R}->l(2)->clone->prepend(200);
        $p{H} =
          Point->new( $pn, $c{G}->intersect( $l{H1} ) )->label(qw(H topright));
        $p{E} = $s{R}->p(2);

        $l{H} = Line->join( $p{E}, $p{H} );
        $l{H1}->remove;
        $l{G} = Line->join( $p{G}, $p{H} );

        $t3->math("GH = GF");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The square on HE is equal in area to figure A");
        $s{EH} = Square->new( $pn, $l{H}->end, $l{H}->start );
        $s{A}->fill($sky_blue);
        $s{EH}->fill($lime_green);
        $t2->allblue;
        $t3->math("\\{square}HE = \\{square}A");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase;
        $t3->math("\\{square}A = \\{square}BD");
        $t3->math("EF = BD");
        $t3->math("BG = GF");
        $t3->math("GH = GF");
        $t3->allblue;

        $t1->down;
        $t1->erase;
        $t1->title("Proof:");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{A}->fill($sky_blue);
        $s{R}->fill($sky_blue);
        $s{EH}->grey;
        $l{H}->grey;
        $l{BF}->grey;
        $l{G}->grey;

        $t1->explain("Polygon A equals the polygon BD by construction");

        $t3->blue(-1);

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{A}->grey;
        $s{EH}->grey;
        $s{R}->grey;
        $l{BF}->normal;
        $p{B}->normal;
        $p{E}->normal;

        $t1->explain(   "Line BF is divided into equal (G) and unequal "
                      . "segments\\{nb}(E), thus the rectangle formed by BE,EF "
                      . "plus the square "
                      . "of EG is equal to the square on GF\\{nb}(II.5)" );

        $t3->allgrey;
        $t3->blue(2);
        $t3->math("BE\\{dot}EF + EG\\{squared} = GF\\{squared}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(  "Since GHE is a right triangle, and GH is equal to GF, "
                     . "the square of GF is equal to the sum of the squares on "
                     . "EG and GH (I.47)" );

        $s{GHE} =
          Triangle->new( $pn, $p{G}->coords, $p{H}->coords, $p{E}->coords, -1 );
        $s{GHE}->fill($pale_pink);

        $t3->allgrey;
        $t3->blue(3);
        $t3->math("GH\\{squared} = EG\\{squared} + EH\\{squared}");
        $t3->math("GF\\{squared} = EG\\{squared} + EH\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(  "Thus the rectangle formed"
                     . " by BE,EF plus the square of EG is equal to the sum of "
                     . "the squares "
                     . "on EG and GH" );

        $s{GHE}->fill();

        $t3->allgrey;
        $t3->black( [ -1, -3 ] );
        $t3->math(
                 "BE\\{dot}EF + EG\\{squared} = EG\\{squared} + EH\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->blue(3);
        $t1->explain(   "Subtracting EG from both sides of the equality, "
                      . "gives BE,EF equals the square of EH" );
        $t3->allgrey;
        $t3->black( [-1] );
        $t3->math("BE\\{dot}EF = EH\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "The rectangle formed by BE,EF is BD, since EF equals ED ");

        $s{R}->normal->fill($sky_blue);
        $t3->allgrey;
        $t3->blue(1);
        $t3->math("BE\\{dot}EF = \\{square}BD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore BD equals the square on EH");

        $s{EH}->normal->fill($sky_blue);

        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("\\{square}BD = EH\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore polygon 'A' equals the square on EH");
        $s{A}->normal->fill($sky_blue);
        $t3->allgrey;
        $t3->blue(0);
        $t3->black(-1);
        $t3->math("\\{square}A = EH\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->blue(0);
        $t3->black(-1);
    };

    return $steps;

}

