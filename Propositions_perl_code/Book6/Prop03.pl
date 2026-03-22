#!/usr/bin/perl 
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

# ============================================================================
# Definitions
# ============================================================================
my $title =
  "If an angle of a triangle be bisected and the straight line cutting "
  . "the angle cut the base also, the segments of the base will have the same ratio "
  . "as the remaining sides of the triangle; and, if the segments of the base have "
  . "the same ratio as the remaining sides of the triangle, the straight line joined "
  . "from the vertex to the point of section will bisect the angle of the triangle.";

$pn->title( 3, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 480 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 3 );
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
    my ( %p, %c, %s, %t, %l, %a );
    my $yh  = 275;
    my $yb  = 400;
    my $dx1 = 250;
    my $dx2 = 75;
    my @B   = ( 150, $yb );
    my @A   = ( $B[0] + $dx1, $yh );
    my @C   = ( $A[0] + $dx2, $yb );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain( "Given a triangle ABC, and let angle BAC be bisected by "
                      . "the straight line BD" );
        $t1->explain(
                   "Then the ratio of BD to CD is equal to the ratio BA to AC");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );

        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} );
        $l{AB}  = $t{ABC}->lines->[0];
        $l{AC}  = $t{ABC}->lines->[2];
        $l{BC}  = $t{ABC}->lines->[1];
        $a{BAC} = Angle->new( $pn, $l{AB}, $l{AC}, -size => 20 );

        ( $l{bisector}, $p{x}, my $circ1, my $circ2, my $circ3 ) = $a{BAC}->bisect();
        $circ1->remove;
        $circ2->remove;
        $circ3->remove;
        $p{x}->remove;
        $l{bisector}->remove;
        $a{BAC}->remove;

        my @p = $l{bisector}->intersect( $l{BC} );
        $p{D} = Point->new( $pn, @p )->label( "D", "bottom" );
        $l{AD} = Line->join( $p{A}, $p{D} );
        $a{BAD} =
          Angle->new( $pn, $l{AB}, $l{AD}, -size => 30 )->label("\\{alpha}");
        $a{DAC} =
          Angle->new( $pn, $l{AD}, $l{AC}, -size => 40 )->label("\\{alpha}");
        $t3->down;
        $t3->math("\\{angle}BAD = \\{angle}DAC \\{then} BD:DC = BA:AC");
        $t3->math("BD:DC = BA:AC \\{then} \\{angle}BAD = \\{angle}DAC");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof (part 1)");
        $t3->erase();
        $t3->down;
        $t3->math("\\{angle}BAD = \\{angle}DAC")->blue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw a line parallel to DA from point C, and "
                      . "let the line BA extend to it at point E" );
        $l{x} = $l{AD}->parallel( $p{C} );
        my @p = $l{AB}->intersect( $l{x} );
        $p{E} = Point->new( $pn, @p )->label( "E", "right" );
        $l{CE} = Line->join( $p{C}, $p{E} );
        $l{AE} = Line->join( $p{A}, $p{E} );
        $l{x}->remove;
        $t3->math("CE \\{parallel} DA")->blue(1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "AC cuts two parallel lines AD and EC, therefore the "
                      . "opposite interior angle "
                      . "ACE is equal to DAC (I.29)" );
        $l{AB}->grey;
        $l{AE}->grey;
        $l{BC}->grey;
        $l{ADx} = Line->new( $pn, $l{AD}->endpoints(), -1, 1 );
        $l{CEx} = Line->new( $pn, $l{CE}->endpoints(), -1, 1 );
        $l{ADx}->extend(50);
        $l{ADx}->prepend(50);
        $l{CEx}->extend(50);
        $l{CEx}->prepend(50);
        $a{BAD}->grey;

        $a{ACE} = Angle->new( $pn, $l{CE}, $l{AC} )->label("\\{alpha}");
        $t3->grey(0);
        $t3->math("\\{angle}DAC = \\{angle}ACE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "BE cuts two parallel lines AD and EC, therefore the outside angle "
              . "BAD is equal to interior angle AEC (I.29)" );
        $l{AC}->grey;
        $l{AB}->normal;
        $l{AE}->normal;
        $a{BAD}->normal;
        $a{DAC}->grey;
        $a{ACE}->grey;
        $a{AEC} = Angle->new( $pn, $l{AE}, $l{CE} )->label("\\{alpha}");
        $t3->grey(-1);
        $t3->math("\\{angle}BAD = \\{angle}AEC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since angles BAD and DAC are equal by construction, "
                      . "angles ACE and AEC are also equal" );
        $a{ACE}->normal;
        $a{DAC}->normal;
        $l{AC}->normal;
        $t3->blue(0);
        $t3->grey(1);
        $t3->black(-2);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "Therefore, triangle AEC is an isosceles triangle, and the "
                      . "sides AE and AC are equal" );
        $l{AB}->grey;
        $l{AD}->grey;
        $a{DAC}->grey;
        $l{AC}->grey;
        $t{AEC} = Triangle->join( $p{E}, $p{A}, $p{C} )->fill($sky_blue);
        $a{ACE}->normal;
        $a{BAD}->grey;
        $t3->math("AE = AC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "Consider triangle BCE, with a line AD drawn parallel to one "
                    . "of the triangle's sides.  The ratio BA to AE is "
                    . "equal to the ratio BD to DC (VI.2)" );
        $t{AEC}->grey;
        $l{CEx}->remove;
        $a{ACE}->grey;
        $a{AEC}->grey;
        $t{BCE} = Triangle->join( $p{B}, $p{C}, $p{E} )->fill($pale_pink);
        $t3->allgrey;
        $t3->blue(1);
        $t3->math("BA:AE = BD:DC");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "And AE is equal to AC, therefore ratio BA to "
                      . "AC is equal to the ratio BD to DC" );
        $t{BCE}->grey;
        $l{AE}->grey;
        $l{CE}->grey;
        $t{ABC}->normal->fill($lime_green);
        $a{BAD}->normal;
        $a{DAC}->normal;
        $t3->down;
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("BA:AC = BD:DC");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
        $t3->blue(0);
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof (part 2)");
        $t3->erase();
        $t3->down;
        $t3->math("BA:AC = BD:DC")->blue;
        $t3->math("DA \\{parallel} CE")->blue(1);
        $a{BAD}->grey;
        $a{DAC}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since DA is parallel to CE, the ratio AB to AE is "
                      . "equal to the ratio BD to DC (VI.2)" );
        $t{ABC}->grey;
        $t{BCE}->normal;
        $t3->grey(0);
        $t3->math("BA:AE = BD:DC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "If two ratios are equal to the same, they "
                      . "are equal to each other (V.11), "
                      . "so the ratios BA to AC and BA to AE are also equal" );
        $t3->grey(1);
        $t3->blue(0);
        $t3->math("BA:AC = BA:AE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, AC equals AE (V.9)");
        $l{AC}->normal;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("AC = AE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
"If AC and AE are equal, then triangle ACE is an isosceles triangle, "
              . "and the angles AEC and ACE are equal (I.5)" );
        $t{BCE}->grey;
        $t{AEC}->normal;
        $a{ACE}->normal;
        $a{AEC}->normal;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{angle}ACE = \\{angle}AEC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The angle AEC is equal to the exterior angle "
                      . "BAD of the parallel lines AD and EC (I.29)" );
        $t{ABC}->normal;
        $a{BAD}->normal;
        $l{ADx}->normal;
        $l{CEx}->normal;
        $t3->allgrey;
        $t3->math("\\{angle}AEC = \\{angle}BAD");
    };
    push @$steps, sub {
        $t1->explain(
                "and the angle ACE is equal to the alternate angle CAD (I.29)");
        $a{DAC}->normal;
        $t3->allgrey;
        $t3->math("\\{angle}ACE = \\{CAD}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, the line AD bisects the angle BAC");
        $t3->allgrey;
        $t3->black( [ -1, -2, -3 ] );
        $t3->math("\\{angle}BAD = \\{angle}CAD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->black(-1);
    };
    return $steps;

}

