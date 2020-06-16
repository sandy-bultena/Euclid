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
    "If a point be taken within a circle, and more than two equal straight"
  . " lines fall from the point on the circle, the point taken is the "
  . "centre of the circle.";

$pn->title( 9, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 500, 240 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 9 );
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
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words ");
        $t1->explain(   "If three lines (or more) from point D to the "
                      . "circle (DB, DA, DC) are equal, "
                      . "then D is the centre of the circle" );
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{D} = Point->new( $pn, @c1, )->label( "D", "bottomright" );
        $p{A} = $c{A}->point(230)->label( "A", "bottom" );
        $p{B} = $c{A}->point(130)->label( "B", "top" );
        $p{C} = $c{A}->point(10)->label( "C", "right" );
        $l{DA} = Line->join( $p{D}, $p{A} );
        $l{DB} = Line->join( $p{D}, $p{B} );
        $l{DC} = Line->join( $p{D}, $p{C} );
        $t3->math("DA = DB = DC");
        $t3->blue(0);
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
        $t1->explain("Join AB and BC and bisect them at points E and F");
        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{BC} = Line->join( $p{B}, $p{C} );
        $p{E}  = $l{AB}->bisect;
        $p{E}->label( "E", "bottomleft" );
        $p{F} = $l{BC}->bisect;
        $p{F}->label( "F", "topright" );
        $t3->math("AE = EB");
        $t3->math("BF = FC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw line ED, intersecting the circle at points K,G");
        $l{EDi} = Line->join( $p{E}, $p{D} )->grey->extend(300)->prepend(300);
        my @p = $c{A}->intersect( $l{EDi} );
        $l{KG} = Line->new( $pn, @p );
        $p{K} = Point->new( $pn, @p[ 2, 3 ] )->label( "K", "left" );
        $p{G} = Point->new( $pn, @p[ 0, 1 ] )->label( "G", "right" );
        $l{EDi}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Compare triangles AED and BED");
        $t1->explain("The sides AE,EB are equal, the sides DA,DB "
                   . "are equal, and the side ED is common, "
                   . "thus we have two triangles with three equal sides (SSS), "
                   . "and therefore are equivalent" );

        $t3->allgrey;
        $t3->blue(0);
        $t3->black(1);
        $t3->math("\\{triangle}AED \\{equivalent} \\{triangle}BED");

        foreach my $key ( keys %l ) {
            $l{$key}->grey;
        }

        $s{AED} =
          Triangle->new( $pn, $p{A}->coords, $p{D}->coords, $p{E}->coords )
          ->fill($sky_blue);
        $s{BED} =
          Triangle->new( $pn, $p{B}->coords, $p{E}->coords, $p{D}->coords )
          ->fill($lime_green);
        $a{alpha} =
          Angle->new( $pn, $s{AED}->l(3), $s{AED}->l(2) )
          ->label( "\\{alpha}", 30 );
        $a{beta} =
          Angle->new( $pn, $s{BED}->l(2), $s{BED}->l(1) )->label("\\{beta}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Hence \\{alpha} is equal to \\{beta} and are "
                      . "by definition, right angles" );

        $t3->allgrey;
        $t3->math("\\{alpha} = \\{beta} = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus the line KG bisects BA at right angles, "
                   . "and from (III.1) this implies "
                   . "that the centre of the circle lies on the line\\{nb}KG" );
        $l{KG}->normal;
        $l{AB}->normal;
        $s{AED}->remove;
        $s{BED}->remove;
        $t3->allgrey;
        $t3->black(-1);
        $t3->explain("Centre of circle lies on KG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw lines FD, intersecting the circle at points L,H");
        $l{FDi} = Line->join( $p{F}, $p{D} )->grey->extend(300)->prepend(300);
        my @p = $c{A}->intersect( $l{FDi} );
        $l{LH} = Line->new( $pn, @p );
        $p{L} = Point->new( $pn, @p[ 0, 1 ] )->label( "L", "top" );
        $p{H} = Point->new( $pn, @p[ 2, 3 ] )->label( "H", "bottom" );
        $l{FDi}->remove;
        $t3->allgrey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Using the same logic as before, \\{gamma} "
                      . "equals \\{delta} and both are right" );
        foreach my $key ( keys %l ) {
            $l{$key}->grey;
        }
        $a{alpha}->grey;
        $a{beta}->grey;

        $s{BDF} =
          Triangle->new( $pn, $p{B}->coords, $p{D}->coords, $p{F}->coords )
          ->fill($pale_pink);
        $s{FDC} =
          Triangle->new( $pn, $p{F}->coords, $p{D}->coords, $p{C}->coords )
          ->fill($pale_yellow);
        $a{gamma} =
          Angle->new( $pn, $s{BDF}->l(3), $s{BDF}->l(2) )
          ->label( "\\{gamma}", 30 );
        $a{delta} =
          Angle->new( $pn, $s{FDC}->l(1), $s{FDC}->l(3) )->label("\\{delta}");

        $t3->math("\\{gamma} = \\{delta} = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus the line HL bisects BC at right angles, and "
                   . "from (III.1) this implies "
                   . "that the centre of the circle lies on the line\\{nb}HL" );
        $l{LH}->normal;
        $l{BC}->normal;
        $s{BDF}->remove;
        $s{FDC}->remove;
        $t3->explain("Centre of circle lies on HL");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "If the center of the circle lies on both HL and KG, "
                      . "then it must be at point D" );
        $l{BC}->grey;
        $a{gamma}->grey;
        $a{delta}->grey;
        $l{KG}->normal;
        $t3->down;
        $t3->allgrey;
        $t3->black( [ 5, 7 ] );
        $t3->explain("The centre = D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{LH}->grey;
        $l{KG}->grey;
        $l{DA}->normal;
        $l{DB}->normal;
        $l{DC}->normal;
        $t3->allgrey;
        $t3->blue(0);
        $t3->black(-1);
    };

    return $steps;

}

