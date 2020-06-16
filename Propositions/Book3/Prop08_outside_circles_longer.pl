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
    "If a point be taken outside a circle and from the point straight "
  . "lines be drawn through to the circle, one of which is through the centre and "
  . "the others are drawn at random, then, of the straight lines which fall on the "
  . "concave circumference, that through the centre is greatest, while of the rest "
  . "the nearer to that through the centre is always greater than the more remote, "
  . "but, of the straight lines falling on the convex circumference, that between "
  . "the point and the diameter is least, while of the rest the nearer to the least "
  . "is always less than the more remote, and only two equal straight lines will "
  . "fall on the circle from the point, one on each side of the least.";

$pn->title( 8, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 500, 240 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 8 );
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

    my @c1 = ( 260, 560 );
    my $r1 = 140;
    my @c2 = ( $c1[0] + $r1 * .6, $c1[1] - $r1 * 2.3 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->down;
        $t1->down;
        $t1->title("In other words ");
        $t1->explain(   "Let M be the center of a circle, and D be "
                      . "a point outside of the circle" );
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{M} = Point->new( $pn, @c1 )->label(qw(M bottomright));
        $p{D} = Point->new( $pn, @c2 )->label(qw(D top));
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Draw lines from D to points A, E, F, C on "
            . "the far end of the circle, where DA passes through the center of the circle at point M"
        );
        $l{DA} = Line->new( $pn, @c2, $p{M}->coords )->extend($r1);
        my @p = $c{A}->intersect( $l{DA} );
        $p{A} = Point->new( $pn, @p[ 2, 3 ] )->label( "A", "bottom" );
        $p{E} = $c{A}->point(230)->label( "E", "bottom" );
        $p{F} = $c{A}->point(200)->label( "F", "bottomleft" );
        $p{C} = $c{A}->point(175)->label( "C", "left" );
        $l{DE} = Line->new( $pn, @c2, $p{E}->coords );
        $l{DF} = Line->new( $pn, @c2, $p{F}->coords );
        $l{DC} = Line->new( $pn, @c2, $p{C}->coords );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain( "Of the lines falling on the concave part "
                 . "of the circle, DA is the largest, DE the next, and so on" );
        $t3->math("DA > DE > DF > DC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain(   "Of the lines falling on the convex part of "
                      . "the circle, DG is the least, DK the next, and so on" );
        my @p = $c{A}->intersect( $l{DA} );
        $p{G} = Point->new( $pn, @p[ 0, 1 ] )->label( "G", "topright" );
        @p = $c{A}->intersect( $l{DE} );
        $p{K} = Point->new( $pn, @p[ 0, 1 ] )->label( "K", "top" );
        @p    = $c{A}->intersect( $l{DF} );
        $p{L} = Point->new( $pn, @p[ 0, 1 ] )->label( "L", "top" );
        @p    = $c{A}->intersect( $l{DC} );
        $p{H} = Point->new( $pn, @p[ 0, 1 ] )->label( "H", "topleft" );

        $l{DA}->grey;
        $l{DG} = Line->new( $pn, @c2, $p{G}->coords );
        $l{DE}->grey;
        $l{DK} = Line->new( $pn, @c2, $p{K}->coords );
        $l{DF}->grey;
        $l{DL} = Line->new( $pn, @c2, $p{L}->coords );
        $l{DC}->grey;
        $l{DH} = Line->new( $pn, @c2, $p{H}->coords );

        $t3->math("DG < DK < DL < DH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain( "Finally, only two straight and equal lines "
              . "from point D will fall on the circle, one on either side of DG"
        );
        $l{DG}->grey;
        $l{DE}->grey;
        $l{DF}->grey;
        $l{DL}->grey;
        $l{DC}->grey;
        $l{DH}->grey;
        $p{Bi} = $c{A}->point(65);
        $l{Atmp} = Line->new( $pn, @c2, $p{Bi}->coords );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $l{DK}->grey;
        $p{Bi}->remove;
        $l{Atmp}->remove;
        $t1->down;
        $t1->down;
        $t1->down;
        $t1->title("Proof (part 1)");
        $t3->erase;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Consider the triangle DEM, the sum of two sides "
                      . "of any triangle is larger than the third (I.20)" );
        $s{DEM} =
          Triangle->new( $pn, $p{D}->coords, $p{E}->coords, $p{M}->coords )
          ->fill($sky_blue);
        $t3->math("EM + DM > DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The lines EM and AM are radii of the same circle, "
                      . "and thus are equal" );
        $l{DA}->normal;
        $t3->math("EM = AM");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Thus, AM plus DM is greater than DE, and since DA "
                      . "equal AM,DM, DA is greater than DE" );
        $t3->math("AM + DM > DE");
        $t3->math("DA > DE");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{DA}->grey;
        $t1->explain(   "Compare the triangles DFM and DEM, FM and EM are "
                      . "equal, and DM is common to both, "
                      . "so we have two triangles with two equal sides, " );
        $s{DFM} =
          Triangle->new( $pn, $p{D}->coords, $p{F}->coords, $p{M}->coords )
          ->fillover( $s{DEM}, $lime_green );
        $a{DME} =
          Angle->new( $pn, $s{DEM}->l(3), $s{DEM}->l(2) )->label( " ", 20 );
        $a{DMF} =
          Angle->new( $pn, $s{DFM}->l(3), $s{DFM}->l(2) )->label( " ", 30 );
        my @p = $s{DFM}->l(2)->intersect( $l{DE} );
        $s{DFMi} =
          Triangle->new( $pn, @p, $p{M}->coords, $p{D}->coords )
          ->fillover( $s{DFM}, $teal );
        $t3->allgrey;
        $t3->math("FM = EM");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{DA}->grey;
        $t1->explain(   "Since the angle DME is larger than the angle DMF, "
                      . "DE is larger than DF (I.24)" );
        $t3->math("DE > DF");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, DF is larger than DC");
        $s{DEM}->fill();
        $s{DEM}->grey();
        $a{DME}->remove;

        $s{DFMi}->remove;
        $s{DCM} =
          Triangle->new( $pn, $p{D}->coords, $p{C}->coords, $p{M}->coords )
          ->fillover( $s{DFM}, $pale_pink);
        $a{DMC} =
          Angle->new( $pn, $s{DCM}->l(3), $s{DCM}->l(2) )->label( " ", 40 );
        my @p = $s{DCM}->l(2)->intersect( $l{DF} );
        $s{CDMi} =
          Triangle->new( $pn, @p, $p{M}->coords, $p{D}->coords )
          ->fillover( $s{DCM}, $tan );
        $t3->math("DF > DC");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{CDMi}->remove;
        $s{DCM}->remove;
        $s{CDMi}->remove;
        $s{DFM}->remove;
        $s{DEM}->remove;
        $a{DMF}->remove;
        $a{DMC}->remove;
        $l{DA}->normal;
        $l{DE}->normal;
        $l{DF}->normal;
        $l{DC}->normal;
        $t3->allgrey;
        $t3->black( [ 3, 5, 7, 6 ] );
        $t3->math("DA>DE>DF>DC");
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
        $l{DG}->grey;
        $l{DA}->grey;
        $l{DE}->grey;
        $l{DK}->grey;
        $l{DF}->grey;
        $l{DL}->grey;
        $l{DC}->grey;
        $l{DH}->grey;
        $t1->title("Proof (part 2)");
        $t3->erase;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "Consider triangle DKM, DK plus KM is greater than DM\\{nb}(I.20)");
        $s{DKM} =
          Triangle->new( $pn, $p{D}->coords, $p{K}->coords, $p{M}->coords )
          ->fill($blue);
        $t1->explain("But KM is equal to GM");
        $t1->explain(   "Subtract GM from both sides of the inequality "
                      . "gives DK is greater than DG" );
        $t3->math("DK + KM > DM");
        $t3->math("DK + KM > DG + GM");
        $t3->math("DK > DG");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Consider the two triangles DKM and DLM");
        $s{DLM} =
          Triangle->new( $pn, $p{D}->coords, $p{L}->coords, $p{M}->coords )
          ->fill($green);
        $s{DKM}->fill( Colour->add( $blue, $green ) );
        $t3->allgrey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The two lines DK and KM are wholly within the "
                      . "triangle DLM, therefore the sum of "
                      . "DK,KM is less than the sum of DL,LM\\{nb}(I.21)" );

        $t3->allgrey;
        $t3->math("DL + LM > DK + KM");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But LM is equal to KM");
        $t1->explain(   "Subtract KM from both sides of the inequality "
                      . "gives DL is greater than DK" );
        $t3->math("DL > DK");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{DKM}->remove;
        $t1->explain("Using the same logic, we have DH greater than DL");
        $s{DHM} =
          Triangle->new( $pn, $p{D}->coords, $p{H}->coords, $p{M}->coords )
          ->fill($pink);
        $s{DLM}->fill( Colour->add( $green, $pink ) );
        $t3->allgrey;
        $t3->math("DH > DL");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{DHM}->remove;
        $s{DLM}->remove;
        $l{DG}->normal;
        $l{DK}->normal;
        $l{DL}->normal;
        $l{DH}->normal;

        $t3->allgrey;
        $t3->black( [ 2, 4, 5 ] );
        $t3->math("DG<DK<DL<DH");
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
        $l{DG}->grey;
        $l{DK}->grey;
        $l{DL}->grey;
        $l{DH}->grey;
        $t1->title("Proof (part 3)");
        $t3->erase;
        $t1->explain(   "Construct a line MB such that the angle DMK "
                      . "equals DMB, and draw the line DB" );
        $l{KM} = Line->join( $p{K}, $p{M} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $l{DK}->normal;
        $l{DM} = Line->join( $p{D}, $p{M} );
        $a{GMK} = Angle->new( $pn, $l{DM}, $l{KM} )->label( "\\{alpha}", 90 );
        ( $l{BMi}, $a{GMB} ) = $a{GMK}->copy( $p{M}, $l{DM}, 'negative' );
        $a{GMB}->label( "\\{alpha}", 80 );
        $l{BMi}->extend(200);
        my @p = $c{A}->intersect( $l{BMi} );
        $p{B} = Point->new( $pn, @p[ 0, 1 ] )->label( "B", "topright" );
        $l{BM} = Line->join( $p{B}, $p{M} );
        $l{BMi}->remove;
        $l{DB} = Line->join( $p{D}, $p{B} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t1->explain( "MK equals MB (radii of the same circle) and MD "
                . "is common to both, so "
                . "with two triangles with side-angle-side SAS equal, "
                . "the triangles are equal and therefore KD equals BD\\{nb}(I.4)"
        );
        $t3->math("\\{triangle}DKM \\{equivalent} \\{triangle}DBM");
        $t3->math("DK = DB");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->bold(   "There is no other line that can fall from D to the "
                   . "circle equal in length to DK and DB" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof by contradiction:");
        $t1->explain("Assume a line DN exists, equal in length to DK");
        $l{KM}->remove;
        $l{BM}->remove;
        $l{DM}->grey;
        $a{GMK}->remove;
        $a{GMB}->remove;
        $p{N} = $c{A}->point(50)->label( "N", "topright" );
        $l{DN} = Line->join( $p{D}, $p{N} );
        $t3->down;
        $t3->explain("Assume...");
        $t3->math("DN = DK");
        $t3->blue( [ -1, -2 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "DK is equal to DB, but DN is equal to DK, therefore DN equals DB");
        my $y = $t3->y;
        $t3->math("DN = DB");
        $t3->y($y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "But, according to the second part of this proposition, "
                . "DB, being closer to DG, "
                . "is smaller than DN, which contradicts the original statement"
        );
        $t3->allgrey;
        $t3->math("        \\{wrong}");
        $t3->math("DB < DN");
        $t3->red( [ -1, -2, -3 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Therefore there are only two lines of equal "
                      . "length from D to the circle circumference" );
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->red(3);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->math("DN \\{notequal} DK");
    };
    return $steps;

}

