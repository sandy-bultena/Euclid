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
    "The straight line drawn at right angles to the diameter of a circle "
  . "from its extremity will fall outside the circle, and into the space "
  . "between the straight line and the circumference another straight line "
  . "cannot be interposed; further the angle of the semicircle is greater, "
  . "and the remaining angle less, than any acute rectilineal angle.";

$pn->title( 16, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 840, 150, -width => 480 );
my $t3 = $pn->text_box( 470, 180 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 16 );
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

    my @c1 = ( 400, 210 );
    my $r1 = 300;
    my $f  = 0.6;
    my $ao = 40 * 3.14159 / 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words ");
        $t1->explain(
               "Given a circle, with AB as a diameter, and D as the centre...");
        $c{At} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        my $p1 = $c{At}->point(180);
        my $p2 = $c{At}->point(-75);
        $p1->remove;
        $p2->remove;
        $c{At}->remove;
        $l{AD} = Line->new( $pn, @c1, $c1[0], $c1[1] + $r1 );
        $l{Adot} = Line->new( $pn, $c1[0], $c1[1] - 50, @c1, 1, 1 );
        $p{B} = Point->new( $pn, $c1[0], $c1[1] - 50 )->label( "B", "right" );
        $p{D} = Point->new( $pn, @c1 )->label( "D", "right" );
        $p{A} = Point->new( $pn, $c1[0], $c1[1] + $r1 )->label( "A", "bottom" );
        $c{A} = Arc->new( $pn, $r1, $p1->coords, $p2->coords )->red;
    };

    push @$steps, sub {
        $t1->explain("Draw a line AE from point A, perpendicular to AB");
        $l{AEt} = $l{AD}->perpendicular( $p{A} )->grey;
        $p{E} = Point->new( $pn, $l{AEt}->point($r1) )->label( "E", "left" );
        $l{AEt}->remove;
        $l{AE} = Line->join( $p{A}, $p{E} );
    };

    push @$steps, sub {
        $t4->y( $t1->y );
        $t1->explain("(1)");
        $t4->explain("The Line AE falls outside of the circle");
        $t1->y( $t4->y );
    };

    push @$steps, sub {
        $t4->y( $t1->y );
        $t1->explain("(2)");
        $t4->explain(   "No other line from point A can squeeze "
                      . "between the circumference, and the line AE" );
        $t1->y( $t4->y );
        my @p = $l{AE}->end;
        $p{F} = Point->new( $pn, $p[0] + 20, $p[1] - 20 );
        $l{FA} = Line->join( $p{A}, $p{F}, 1, 1 );
    };

    push @$steps, sub {
        $l{FA}->remove;
        $p{F}->remove;
        $t4->y( $t1->y );
        $t1->explain("(3)");
        $t4->explain(   "- The angle between AB and the circumference "
                      . "of the circle cannot be less than "
                      . "a right angle," );
        $t4->explain(   "- and the angle between AE and the "
                      . "circumference cannot be greater than zero" );
        $t1->y( $t4->y );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase();
        $t1->erase();
        $t1->down;
        $t1->title("In other words ");
        $t1->explain(
               "Given a circle, with AB as a diameter, and D as the centre...");
        $t4->y( $t1->y );
        $t1->explain("(1)");
        $t4->explain("The Line AE falls outside of the circle");
        $t1->y( $t4->y );
        $t1->down;
        $t1->title("Proof by Contradiction (1)");
    };

    push @$steps, sub {
        $t1->explain(   "Assume that the line perpendicular to AB lies "
                      . "within the circle, such as line AC" );
        $l{AE}->grey;
        $p{E}->remove;
        $p{C} = $c{A}->point(-130)->label( "C ", "bottom" );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $t3->math("AC \\{perp} AB");
        $a{DAC} = Angle->new( $pn, $l{AD}, $l{AC} )->label("\\{alpha}");
        $t3->math("\\{angle}DAC = \\{alpha} = \\{right}");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain("Draw the line DC");
        $l{DC} = Line->join( $p{C}, $p{D} );
        $t3->allgrey;
        $t3->math("DC = AC");
    };

    push @$steps, sub {
        $t1->explain( "DC equals AC, therefore the triangle is an "
              . "isosceles triangle, and the angles DAC and DCA are equal (I.5)"
        );
        $a{DCA} = Angle->new( $pn, $l{AC}, $l{DC} )->label("\\{alpha}");
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{angle}DAC = \\{angle}DCA = \\{alpha}");
    };

    push @$steps, sub {
        $t1->explain(   "DAC is right, which means DCA is also right, and "
                      . "their sum is equal to two right angles" );
        $t3->allgrey;
        $t3->blue(1);
        $t3->black(-1);
        $t3->math("\\{angle}DAC + \\{angle}DCA = 2\\{dot}\\{right}");
    };

    push @$steps, sub {
        $t1->explain(   "The sum of any two angles in a triangle must be "
                      . "less than two right angles (I.17)" );
        $t3->allgrey;
        $t3->math("\\{angle}DAC + \\{angle}DCA < 2\\{dot}\\{right}");
    };

    push @$steps, sub {
        $t1->explain("Thus we have a contradiction");
        $t3->allgrey;
        $t3->red( [ -1, -2 ] );

    };
    push @$steps, sub {
        $t1->explain( "The angle DAC " . "cannot be a right angle" );
        $t3->allgrey;
        $t3->red(1);

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $a{DAC}->remove;
        $a{DCA}->remove;
        $l{AE}->draw;
        $p{E}->draw;
        $l{AE}->normal;
        $l{AC}->remove;
        $l{DC}->remove;
        $p{C}->remove;
        $t4->erase();
        $t1->erase();
        $t1->down;
        $t1->title("In other words ");
        $t1->explain(
               "Given a circle, with AB as a diameter, and D as the centre...");
        $t4->y( $t1->y );
        $t1->explain("(2)");
        $t4->explain(   "No other line from point A can squeeze between "
                      . "the circumference, and the line AE" );
        $t1->y( $t4->y );
        $t1->down;
        $t1->title("Proof by Contradiction (2)");
        $t3->math("\\{angle}DAE = \\{right}");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain( "Assume that the line FA lies between the circumference "
                      . "of the circle and the line AE" );
        my @p = $l{AE}->end;
        $p{F} = Point->new( $pn, $p[0] + 20, $p[1] - 40 )->label( "F", "left" );
        $l{AF} = Line->join( $p{A}, $p{F} );
        $a{DAG} = Angle->new( $pn, $l{AD}, $l{AF} )->label("\\{beta}");
        $t3->math("\\{angle}DAF = \\{beta} < \\{angle}DAE");
        $t3->math("\\{beta} < \\{right}");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain(   "Draw a perpendicular line from D to line FA, "
                      . "intersecting at the point G" );
        $l{AE}->grey;
        $p{G} = Point->new( $pn, $l{AF}->point(150) )->label( "G", "bottom" );
        $l{DG} = Line->join( $p{D}, $p{G} );
        $l{GA} = Line->join( $p{G}, $p{A} );
        $a{DGA} = Angle->new( $pn, $l{GA}, $l{DG} )->label("\\{alpha}");
        $t3->allgrey;
        $t3->math("\\{angle}DGA = \\{alpha} = \\{right}");
    };

    push @$steps, sub {
        $t1->explain(   "Angle DGA (\\{alpha}) is right, and DAG (\\{beta}) is "
                      . "less than a right angle, so DGA is greater than DAG" );
        $t3->allgrey;
        $t3->black(-1);
        $t3->blue(-2);
        $t3->math("\\{therefore} \\{alpha} > \\{beta}");
    };

    push @$steps, sub {
        $t1->explain(   "In a triangle, the larger line is opposite the "
                      . "larger angle, thus DA is larger than DG (I.19)" );
        $s{DGA} = Triangle->join( $p{D}, $p{G}, $p{A} )->fill($sky_blue);
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("DA > DG");
    };

    push @$steps, sub {
        $t1->explain("DG is larger than DH");
        $s{DGA}->remove;
        $p{H} =
          Point->new( $pn, $c{A}->intersect( $l{DG} ) )->label( "H ", "top" );
        $t3->down;
        $t3->allgrey;
        $t3->math("DG > DH");
    };

    push @$steps, sub {
        $t1->explain(   "DH and DA are equal (radii of the same circle), "
                      . "thus DG is larger than DA" );
        $t3->math("DA = DH");
        $t3->math("DG > DA");
    };

    push @$steps, sub {
        $t1->explain("Thus we have a contradiction");
        $t3->allgrey;
        $t3->red( [ -1, -4 ] );
    };
    push @$steps, sub {
        $t1->explain(
            "The line FA cannot exist between the line AE and the circumference"
        );
        $t3->allgrey;
        $t3->red( [1] );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AF}->remove;
        $p{H}->remove;
        $l{DG}->remove;
        $l{GA}->remove;
        $a{DGA}->remove;
        $a{DAG}->remove;
        $p{G}->remove;
        $p{F}->remove;
        $t3->erase();
        $t4->erase();
        $t1->erase();
        $t1->down;
        $t1->title("In other words ");
        $t1->explain(
               "Given a circle, with AB as a diameter, and D as the centre...");
        $t4->y( $t1->y );
        $t1->explain("(3)");
        $t4->explain(   "- The angle between AB and the circumference "
                      . "of the circle cannot be less than "
                      . "a right angle," );
        $t4->explain(   "- and the angle between AE and the "
                      . "circumference cannot be less than zero" );
        $t1->y( $t4->y );
        $t1->y( $t4->y );
        $t1->down;
        $t1->title("Proof by Contradiction (3)");
        $t3->math("\\{angle}DAE = \\{right}");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain(   "Assume that the angle between AB and "
                      . "the circumference is less than a right angle, "
                      . "and that the angle between AE and the circumference "
                      . "is greater than zero" );
        $c{A}->remove;
        $l{AE}->remove;
        $p{A}->remove;
        $p{E}->remove;
        $l{AD}->remove;

        $c{At} =
          Circle->new( $pn, $c1[0] + 100, $c1[1], $c1[0] + $r1 + 100, $c1[1] )
          ->grey;
        my $p1 = $c{At}->point(180);
        my $p2 = $c{At}->point(-75);
        $p1->remove;
        $p2->remove;
        my @p = $c{At}->intersect( $l{AD} );
        $c{At}->remove;
        $p{A} = Point->new( $pn, @p[ 0, 1 ] )->label( "A", "bottom" );
        $l{AD} = Line->join( $p{A}, $p{D} );
        $c{A} = Arc->new( $pn, $r1, $p1->coords, $p2->coords )->red;

        $l{vr} =
          Line->new( $pn, $c1[0] + 100, $c1[1], $p{A}->coords, -1 )->grey;
        $l{vr2} = $l{vr}->perpendicular( $p{A}, -1 )->grey;
        $l{vr}->remove;
        $a{C1} = Angle->new( $pn, $l{AD}, $l{vr2} )->label( "\\{alpha}", 30 );

        $l{AEt} = $l{AD}->perpendicular( $p{A} )->grey;
        $p{E} = Point->new( $pn, $l{AEt}->point($r1) )->label( "E", "left" );
        $l{AEt}->remove;
        $l{AE} = Line->join( $p{A}, $p{E} );
        $a{C2} = Angle->new( $pn, $l{vr2}, $l{AE} )->label( "\\{beta}", 50 );

        $t3->down;
        $t3->math("\\{alpha} < \\{right}");
        $t3->math("\\{beta} > 0");
        $t3->allblue;

    };

    push @$steps, sub {
        $t1->explain(
                     "Then the tangent (grey line) can be inserted between the "
                       . "circumference and the line EA, which "
                       . "was just proven to be impossible" );
        $t3->red( [ -2, -1 ] );
    };

    push @$steps, sub {
        $c{A}->remove;
        $l{AD}->remove;
        $l{AE}->remove;
        $p{A}->remove;
        $p{E}->remove;
        $a{C1}->remove;
        $a{C2}->remove;
        $l{vr2}->remove;

        $t3->erase();
        $t4->erase();
        $t1->erase();
        $t1->down;

        $c{At} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        my $p1 = $c{At}->point(180);
        my $p2 = $c{At}->point(-75);
        $p1->remove;
        $p2->remove;
        $c{At}->remove;
        $l{AD} = Line->new( $pn, @c1, $c1[0], $c1[1] + $r1 );
        $p{A} = Point->new( $pn, $c1[0], $c1[1] + $r1 )->label( "A", "bottom" );
        $c{A}   = Arc->new( $pn, $r1, $p1->coords, $p2->coords )->red;
        $l{AEt} = $l{AD}->perpendicular( $p{A} )->grey;
        $p{E}   = Point->new( $pn, $l{AEt}->point($r1) )->label( "E", "left" );
        $l{AEt}->remove;
        $l{AE} = Line->join( $p{A}, $p{E} );

        $t1->down;
        $t1->title("In other words ");
        $t1->explain(
               "Given a circle, with AB as a diameter, and D as the centre...");
        $t1->explain("Draw a line AE from point A, perpendicular to AB");
        $t4->y( $t1->y );
        $t1->explain("(1)");
        $t4->explain("The Line AE falls outside of the circle");
        $t1->y( $t4->y );
        $t4->y( $t1->y );
        $t1->explain("(2)");
        $t4->explain(   "No other line from point A can squeeze between "
                      . "the circumference, and the line AE" );
        $t1->y( $t4->y );
        $t4->y( $t1->y );
        $t1->explain("(3)");
        $t4->explain(   "- The angle between AB and the circumference of "
                      . "the circle cannot be less than "
                      . "a right angle," );
        $t4->explain(   "- and the angle between AE and the "
                      . "circumference cannot be greater than zero" );
        $t1->y( $t4->y );

        $t1->down;
        $t1->title("PORISM");
        $t1->explain(
                "A straight line drawn at right angles "
              . "to the diameter of a circle, "
              .
              "from one of the endpoints, touches the circle"
        );
    };

    return $steps;

}

