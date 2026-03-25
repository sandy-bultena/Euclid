#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 5;

# ============================================================================
# Definitions
# ============================================================================
my $title = "About a given circle to circumscribe a square.";

$pn->title( 7, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 400, 300 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 7 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();
my ( %l, %p, %c, %s, %a );

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $r = 140;
    my @b = ( 140, 400 );
    my @c = ( 200, 300 );
    my @a = ( 500, 140 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a circle, draw a square ABCD outside the circle");

        my @p = @c;
        $p[0] = $p[0] + $r;
        $c{a} = Circle->new( $pn, @c, @p );
        $l{AB} = Line->new( $pn,
                            $c[0] - $r,
                            $c[1] - $r,
                            $c[0] + $r,
                            $c[1] - $r,
                            undef, 1 );
        $l{BC} = Line->new( $pn,
                            $c[0] - $r,
                            $c[1] + $r,
                            $c[0] + $r,
                            $c[1] + $r,
                            undef, 1 );
        $l{CD} = Line->new( $pn,
                            $c[0] - $r,
                            $c[1] - $r,
                            $c[0] - $r,
                            $c[1] + $r,
                            undef, 1 );
        $l{DA} = Line->new( $pn,
                            $c[0] + $r,
                            $c[1] - $r,
                            $c[0] + $r,
                            $c[1] + $r,
                            undef, 1 );

    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $l{AB}->remove;
        $l{BC}->remove;
        $l{CD}->remove;
        $l{DA}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a diameter AC through the centre of the circle E");
        $p{E} = Point->new( $pn, $c{a}->centre() )->label( "E", "topleft" );
        $p{A} = $c{a}->point(90)->label( "A", "top" );
        $p{C} = $c{a}->point(-90)->label( "C", "bottom" );
        $l{AC} = Line->join( $p{A}, $p{C} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw a diameter BD, perpendicular to AC, "
                      . "through the centre of the circle E" );
        $l{BDt} = $l{AC}->perpendicular( $p{E} )->grey;
        $l{BDt}->prepend( $r * 1.1 );
        $l{BDt}->extend( $r * 1.1 );
        my @p = $c{a}->intersect( $l{BDt} );
        $p{B} = Point->new( $pn, @p[ 2, 3 ] )->label( "B", "left" );
        $p{D} = Point->new( $pn, @p[ 0, 1 ] )->label( "D", "right" );
        $l{BD} = Line->join( $p{B}, $p{D} );
        $l{BDt}->remove;
        $l{AE} = Line->join( $p{A}, $p{E} );
        $l{ED} = Line->join( $p{E}, $p{D} );
        $a{DEA} = Angle->new( $pn, $l{ED}, $l{AE} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "Draw lines at the points A,B,C and D such that they touch "
                      . "the circle (III.16)" );
        $l{top}    = $l{AC}->perpendicular( $p{A} )->prepend( 1.1 * $r );
        $l{bottom} = $l{AC}->perpendicular( $p{C} )->prepend( 1.1 * $r );
        $l{right}  = $l{BD}->perpendicular( $p{D} )->prepend( 1.1 * $r );
        $l{left}   = $l{BD}->perpendicular( $p{B} )->prepend( 1.1 * $r );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the points where these lines intersect be FGHK");
        $p{F} =
          Point->new( $pn, $l{top}->intersect( $l{right} ) )
          ->label( "F", "top" );
        $p{G} =
          Point->new( $pn, $l{top}->intersect( $l{left} ) )
          ->label( "G", "top" );
        $p{H} =
          Point->new( $pn, $l{bottom}->intersect( $l{left} ) )
          ->label( "H", "bottom" );
        $p{K} =
          Point->new( $pn, $l{bottom}->intersect( $l{right} ) )
          ->label( "K", "bottom" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("FGHK is a square");
        $s{FGHK} = Polygon->join( 4, $p{F}, $p{G}, $p{H}, $p{K} );
        $l{top}->remove;
        $l{bottom}->remove;
        $l{right}->remove;
        $l{left}->remove;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since GF touches the circle at point A, and AC passes "
             . "through the centre of the circle, GAE is a right angle (III.18)"
        );
        $s{FGHK}->grey;
        $l{BD}->grey;
        $l{ED}->grey;
        $a{DEA}->grey;
        $l{GA} = Line->join( $p{G}, $p{A} );
        $l{AF} = Line->join( $p{A}, $p{F} );
        $a{GAE} = Angle->new( $pn, $l{GA}, $l{AC} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, so are the angles at B, C and D");
        $a{DEA}->normal;
        $l{BD}->normal;

        $l{HB} = Line->join( $p{H}, $p{B} );
        $l{GB} = Line->join( $p{B}, $p{G} );
        $a{HBD} = Angle->new( $pn, $l{HB}, $l{BD} );

        $l{FD} = Line->join( $p{F}, $p{D} );
        $l{DK} = Line->join( $p{D}, $p{K} );
        $a{FDB} = Angle->new( $pn, $l{FD}, $l{BD} );

        $l{KC} = Line->join( $p{K}, $p{C} );
        $l{CH} = Line->join( $p{C}, $p{H} );
        $a{KCA} = Angle->new( $pn, $l{KC}, $l{AC} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Angle AEB is a right angle, as is GBE, "
                      . "therefore GH is parallel to AC (I.28)" );
        $c{a}->grey;
        $l{ED}->grey;
        $l{FD}->grey;
        $l{CH}->grey;
        $l{GA}->grey;
        $l{AF}->grey;
        $l{DK}->grey;
        $l{KC}->grey;
        $a{FDB}->grey;
        $a{KCA}->grey;
        $a{GAE}->grey;
        $t3->allgrey;
        $t3->math("GH \\{parallel} AC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("By the same reasons, AC is parallel to FK");
        $l{FD}->normal;
        $l{DK}->normal;
        $a{FDB}->normal;
        $t3->allgrey;
        $t3->math("AC \\{parallel} FK");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore FK is parallel to GH (III.30)");
        $l{AC}->grey;
        $a{DEA}->grey;
        $l{AE}->remove;
        $t3->black(-2);
        $t3->math("FK \\{parallel} GH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, GF, BD and HK are all parallel");
        $l{GB}->grey;
        $l{HB}->grey;
        $l{FD}->grey;
        $l{DK}->grey;
        $l{GA}->normal;
        $l{AF}->normal;
        $l{KC}->normal;
        $l{CH}->normal;
        $a{HBD}->grey;
        $a{FDB}->grey;
        $t3->allgrey;
        $t3->math("GF \\{parallel} BD \\{parallel} HK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "Since all these lines are parallel to each other, we have "
                    . "the following parallelograms and equalities (i.34)..." );
        $t1->explain("  The lines GH, AC and FK are all equal");
        greyall();
        $s{GC} = Polygon->join( 4, $p{G}, $p{A}, $p{C}, $p{H} )->fill($sky_blue);
        $s{AK} = Polygon->join( 4, $p{A}, $p{F}, $p{K}, $p{C} )->fill($lime_green);
        $t3->allgrey;
        $t3->black( [ -1, -2, -3, -4 ] );
        $t3->math("GH = AC = FK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("  The lines GF, BD and HK are all equal");
        $s{GC}->remove;
        $s{AK}->remove;
        $s{FB} = Polygon->join( 4, $p{G}, $p{F}, $p{D}, $p{B} )->fill($pale_pink);
        $s{BK} = Polygon->join( 4, $p{B}, $p{D}, $p{K}, $p{H} )->fill($pale_yellow);
        $t3->math("GF = BD = HK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "But BD equals AC (diameters of the same "
                      . "circle), so GF equals GH, "
                      . "and GFKH is an equilateral" );
        $s{FB}->remove;
        $s{BK}->remove;
        $s{GK} = Polygon->join( 4, $p{G}, $p{F}, $p{K}, $p{H} )->fill($teal);
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("AC = BD");
        $t3->math("\\{therefore} GF = GH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain(
                  "GBEA is a parallelogram, which means that the angle AGB is "
                    . "equal to the angle in the opposite corner, AEB (I.34)" );
        $s{GK}->remove;
        $s{GE} = Polygon->join( 4, $p{G}, $p{B}, $p{E}, $p{A} )->fill($purple);
        $s{GE}->set_angles( "\\{gamma}", undef, "\\{epsilon}", );
        $p{E}->grey;
        $t3->down;
        $t3->allgrey;
        $t3->math("\\{gamma} = \\{epsilon} = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Similarly, we can show that all the angles in GFKH are "
                      . "right angled, and thus... " );
        $s{GE}->remove;
        $s{GK} = Polygon->join( 4, $p{G}, $p{H}, $p{K}, $p{F} );
        $s{GK}->set_angles( "\\{gamma}", "\\{alpha}", "\\{beta}", "\\{theta}" );
        $t3->math("\\{gamma} = \\{alpha} = \\{beta} = \\{theta} = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("GFKH is a square");
        $t3->allgrey;
        $t3->black( [ -1, -3 ] );
    };

    return $steps;

}

sub greyall {
    foreach my $o ( keys %l ) {
        $l{$o}->grey;
    }
    foreach my $o ( keys %a ) {
        $a{$o}->grey;
    }
    foreach my $o ( keys %s ) {
        $s{$o}->grey;
    }
    foreach my $o ( keys %p ) {

        #        $p{$o}->grey;
    }
}

