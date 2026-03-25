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
    "If on a diameter of a circle a point be taken which is not the center "
  . "of the circle, and from the point straight lines fall upon the circle, "
  . "that will be the greatest on which the center is, the remainder on the "
  . "same diameter will be the least and of the rest the nearer to the straight "
  . "line through the center is always greater than the more remote, and only "
  . "two equal straight lines will fall from the point on the circle, "
  . "one on each side of the least straight line.";

$pn->title( 7, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 500, 240 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 7 );
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
    my @c2 = ( $c1[0] + 80, $c1[1] );
    my $r2 = 140;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->down;
        $t1->down;
        $t1->title("In other words ");
        $t1->explain(   "Let E be the center of a circle, "
                      . "and F be a point not at the center of the circle" );
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{E} = Point->new( $pn, @c1 )->label(qw(E bottomleft));
        $p{F} = Point->new( $pn, @c2 )->label(qw(F bottomright));
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The line FA, drawn through the center E, "
                      . "will be larger than the line FD, "
                      . "which is on the same diameter as FA" );
        $p{A} = $c{A}->point(180)->label( "A", "left" );
        $l{FA} = Line->new( $pn, @c2, $p{A}->coords );
        $p{D} = $c{A}->point(0)->label( "D", "right" );
        $l{FD} = Line->new( $pn, @c2, $p{D}->coords );
        $t3->math("FA > FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The line FB will be larger than FC because the line "
                      . "FB is closer to FA" );
        $p{B} = $c{A}->point(140)->label( "B", "left" );
        $l{FB} = Line->new( $pn, @c2, $p{B}->coords );
        $p{C} = $c{A}->point(100)->label( "C", "top" );
        $l{FC} = Line->new( $pn, @c2, $p{C}->coords );
        $p{G} = $c{A}->point(45)->label( "G", "right" );
        $l{FG} = Line->new( $pn, @c2, $p{G}->coords );
        $t3->math("FA>FB>FC>FG>FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain(   "Also, only two straight and equal lines from point "
                      . "F will fall on the circle, one on either side of FD" );
        $l{FB}->grey();
        $l{FA}->grey();
        $l{FC}->grey();
        $p{H} = $c{A}->point(-45)->label( "H", "right" );
        $l{FH} = Line->new( $pn, @c2, $p{H}->coords );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->down;
        $t1->down;
        $l{FH}->remove();
        $p{H}->remove;
        $l{FG}->grey();
        $l{FD}->grey();
        $t1->title("Proof (part 1)");
        $t3->erase;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Consider the triangle BEF, the sum of two sides of "
                      . "any triangle is larger than the third (I.20)" );
        $l{FB}->grey();
        $l{FA}->grey();
        $l{FD}->grey();
        $l{FC}->grey();
        $l{FG}->grey();
        $s{BEF} =
          Triangle->new( $pn, $p{B}->coords, $p{E}->coords, $p{F}->coords )
          ->fill($sky_blue);
        $t3->math("EB + FE > FB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The lines EA and EB are radii of the same circle, "
                      . "and thus are equal" );
        $l{FA}->normal;
        $t3->allgrey;
        $t3->math("EA = EB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Thus, EA plus FE is greater than FB, and since FA equal "
                      . "EA,FE, FA is greater than FB" );
        $t3->black(-2);
        $t3->math("EA + FE > FB");
        $t3->math("FA > FB");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{FA}->grey;
        $t1->explain( "Compare the triangles BEF and CEF, BE and CE are equal, "
                      . "and FE is common to both, "
                      . "so we have two triangles with two equal sides, " );
        $s{CEF} =
          Triangle->new( $pn, $p{C}->coords, $p{E}->coords, $p{F}->coords )
          ->fillover( $s{BEF}, $lime_green );
        my @p = $s{CEF}->l(1)->intersect( $l{FB} );
        $a{BEF} =
          Angle->new( $pn, $s{BEF}->l(2), $s{BEF}->l(1) )->label( ' ', 20 );
        $a{CEF} =
          Angle->new( $pn, $s{CEF}->l(2), $s{CEF}->l(1) )->label( " ", 30 );
        $s{CEFi} =
          Triangle->new( $pn, @p, $p{E}->coords, $p{F}->coords )
          ->fillover( $s{CEF}, $teal );
        $t3->allgrey;
        $t3->math("BE = CE");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since the angle BEF is larger than the angle CEF, "
                      . "FB is larger than FC (I.24)" );
        $t3->math("FB > FC");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, FC is larger than FG");
        $a{BEF}->remove;
        $s{BEF}->fill();
        $s{BEF}->grey();

        $s{CEFi}->remove;
        $s{GEF} =
          Triangle->new( $pn, $p{G}->coords, $p{E}->coords, $p{F}->coords )
          ->fillover( $s{CEF}, $pale_pink );
        $a{GEF} =
          Angle->new( $pn, $s{GEF}->l(2), $s{GEF}->l(1) )->label( " ", 40 );
        my @p = $s{GEF}->l(1)->intersect( $l{FC} );
        $s{GEFi} =
          Triangle->new( $pn, @p, $p{E}->coords, $p{F}->coords )
          ->fillover( $s{GEF}, $tan );
        $t3->math("FC > FG");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{GEF}->remove;
        $a{CEF}->remove;
        $s{CEF}->fill();
        $s{CEF}->grey();
        $s{GEFi}->remove;

        $t1->explain(
                 "Consider triangle GEF, FE plus FG is greater than GE (I.20)");
        $t3->allgrey;
        $t3->math("FE + FG > GE");
        $l{FD}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "But GE is equal to DE, which is equal to the sum of FE, FD");

        $t3->math("FE + FG > FE + FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Subtract FE from both sides of the inequality "
                      . "gives FG is greater than FD" );
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("FG > FD");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{GEF}->fill();
        $s{GEF}->grey();
        $l{FA}->normal;
        $l{FB}->normal;
        $l{FC}->normal;
        $l{FG}->normal;
        $l{FD}->normal;

        $t3->allgrey;
        $t3->black( [ 3, 5, 6, 9 ] );
        $t3->math("FA>FB>FC>FG>FD");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->down;
        $t1->down;
        $l{FA}->grey;
        $l{FB}->grey;
        $l{FC}->grey;
        $l{FG}->normal;
        $l{FD}->grey;
        $t1->title("Proof (part 2)");
        $t3->erase;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t1->explain(   "Construct a line EH such that the angle FEH "
                      . "equals FEG, and draw the line FH" );
        $l{FE} = Line->join( $p{E}, $p{F} );
        $l{EG} = Line->join( $p{E}, $p{G} );
        $a{FEG} = Angle->new( $pn, $l{FE}, $l{EG} )->label("\\{alpha}");
        ( $l{EHi}, $a{FEH} ) = $a{FEG}->copy( $p{E}, $l{FE}, 'negative' );
        $a{FEH}->label( "\\{alpha}", 30 );
        $l{EHi}->extend(200);
        my @p = $c{A}->intersect( $l{EHi} );
        $p{H} = Point->new( $pn, @p[ 0, 1 ] )->label( "H", "right" );
        $l{EH} = Line->join( $p{E}, $p{H} );
        $l{EHi}->remove;
        $l{FH} = Line->join( $p{F}, $p{H} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t1->explain( "EG equals EH (radii of the same circle) and "
                . "EF is common to both, so "
                . "with two triangles with side-angle-side SAS equal, "
                . "the triangles are equal and therefore FH equals FG\\{nb}(I.4)"
        );
        $t3->math("\\{triangle}EFH \\{equivalent} \\{triangle}EGF");
        $t3->math("FG = FH");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->bold(   "There is no other line that can fall from F "
                   . "to the circle equal in length to FG and FH" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof by contradiction:");
        $t1->explain("Assume a line FK exists, equal in length to FG");
        $l{EG}->grey;
        $l{EH}->grey;
        $a{FEG}->remove;
        $a{FEH}->remove;
        $p{K} = $c{A}->point(-65)->label( "K", "bottomright" );
        $l{FK} = Line->join( $p{F}, $p{K} );
        $t3->down;
        $t3->explain("Assume...");
        $t3->math("FK = FG");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "FK is equal to FG, but FG is equal to FH, therefore FK equals FH");
        my $y = $t3->y;
        $t3->math("FK = FH");
        $t3->y($y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "But, according to the first part of this proposition, "
              . "FK, being closer to FE, "
              . "is larger than FH, which contradicts the original statement" );
        $t3->math("        \\{wrong}");
        $t3->math("FK > FH");
        $t3->allgrey;
        $t3->red( [ -1, -2,-3 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Therefore there are only two lines of equal "
                      . "length from F to the circle circumference" );
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->red(3);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->math("FK \\{notequal} FG");
    };

    return $steps;

}

