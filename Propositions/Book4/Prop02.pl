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
my $title = "In a given circle to inscribe a triangle equiangular "
  . "with a given triangle.";

$pn->title( 2, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 600 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 2 );
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

    my @c = ( 240, 500 );
    my $r = 160;
    my @d = ( 340, 300 );
    my @f = ( 500, 240 );
    my @e = ( 300, 100 );
    my @g = ( $c[0] - $r + 20, $c[1] + $r - 20 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $c{A} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );
        $p{D} = Point->new( $pn, @d )->label( "D", "bottom" );
        $p{E} = Point->new( $pn, @e )->label( "E", "top" );
        $p{F} = Point->new( $pn, @f )->label( "F", "right" );
        $s{DEF} = Triangle->join( $p{D}, $p{F}, $p{E} );
        $s{DEF}->set_angles( "\\{delta}", "\\{lambda}", "\\{epsilon}" );

        $t1->explain("Given a circle and a triangle DEF:");
        $t1->explain(
                "Draw a triangle within the circle, where the angles in "
              . "the new triangle equal the angles in triangle DEF"
        );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{1} = $c{A}->point(-25);
        $p{2} = $c{A}->point(-100);
        $p{3} = $c{A}->point(120);
        $l{1} = Line->join( $p{1}, $p{2}, 0, 1 );
        $l{2} = Line->join( $p{2}, $p{3}, 0, 1 );
        $l{3} = Line->join( $p{3}, $p{1}, 0, 1 );

    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $l{1}->remove;
        $l{2}->remove;
        $l{3}->remove;
        $p{1}->remove;
        $p{2}->remove;
        $p{3}->remove;
        $t1->title("Construction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a line GH touching the circle at point A (III.16)");
        $p{G} = Point->new( $pn, @g )->label( "G", "left" );
        $l{GA} = $c{A}->draw_tangent( $p{G}, 2, "negative" );
        $l{GA}->normal;
        my @p = $c{A}->intersect( $l{GA} );
        $p{A} = Point->new( $pn, @p[ 0, 1 ] )->label( "A", "bottom" );

        $l{clone} = $l{GA}->clone;
        $l{clone}->extend(200);
        $l{AH} = Line->new( $pn, $p{A}->coords, $l{clone}->end );
        $l{clone}->remove;
        $p{H} = Point->new( $pn, $l{AH}->end )->label( "H", "right" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "Copy the angle \\{epsilon} to line GH, at point\\{nb}A\\{nb}(I.23)"
        );
        $c{A}->grey;
        ( $l{a1}, $a{HAC} ) = $s{DEF}->a(3)->copy( $p{A}, $l{AH} );
        $a{HAC}->label("\\{epsilon}");
        $l{a1}->extend(200);
        my @p = $c{A}->intersect( $l{a1} );
        $p{C} = Point->new( $pn, @p[ 0, 1 ] )->label( "C", "right" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "Copy the angle \\{lambda} to line GH, at point\\{nb}A\\{nb}(I.23)"
        );
        $c{A}->grey;
        ( $l{a2}, $a{HAC} ) = $s{DEF}->a(2)->copy( $p{A}, $l{GA}, "negative" );
        $a{HAC}->label("\\{lambda}");
        $l{a2}->extend(200);
        my @p = $c{A}->intersect( $l{a2} );
        $p{B} = Point->new( $pn, @p[ 2, 3 ] )->label( "B", "left" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Connect B and C with a straight line");
        $l{BC} = Line->join( $p{B}, $p{C} );
        $t1->explain(   "The resulting triangle (circumscribed by the circle) "
                      . "is equiangular to the original triangle DEF" );
        $s{ACB} = Triangle->join( $p{A}, $p{C}, $p{B} )->fill($sky_blue);
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
        $t1->explain(
                  "Since GH touches the circle at A, and AC cuts the circle,"
                    . " the angle in the alternate segment of the circle (HAC) "
                    . "equals the angle "
                    . "between GH and AC\\{nb}(III.32)" );
        $t3->math("\\{angle}DEF = \\{angle}CAH = \\{angle}ABC = \\{epsilon}");
        $s{ACB}->set_angles( undef, undef, "\\{epsilon}" );
        $s{ACB}->a(3)->notice;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly for angles GAB and BCA");
        $s{ACB}->set_angles( undef, "\\{lambda}" );
        $t3->math("\\{angle}DFE = \\{angle}GAB = \\{angle}BCA = \\{lambda}");
        $s{ACB}->a(2)->notice;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "And finally, the sum of all angles in "
                      . "both triangles equals two right angles, "
                      . "it follows that the remaining angle is equal to EDF" );
        $s{ACB}->set_angles( "\\{delta}", undef, undef, 30 );
        $t3->math("\\{angle}EDF = \\{angle}BAC = \\{delta}");
        $s{ACB}->a(1)->notice;
    };

    return $steps;

}

