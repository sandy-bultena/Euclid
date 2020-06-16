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
    "If a point be taken outside a circle and from the point there fall "
  . "on the circle two straight lines, if one of them cut the circle, and the other "
  . "fall on it, and if further the rectangle contained by the whole of the straight "
  . "line which cuts the circle and the straight line intercepted on it outside "
  . "between the point and the convex circumference be equal to the square on the "
  . "straight line which falls on the circle, and the straight line which falls on "
  . "it will touch the circle.";

$pn->title( 37, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 480, 200 );
my $t2 = $pn->text_box( 400, 650 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 37 );
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

    my @c1 = ( 300, 350 );
    my $r1 = 125;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->down;
        $t3->down;
        $t4->down;
        $t4->title("In other words");
        $t4->explain("Let point D be outside of the circle");
        $t4->explain(   "Let a line DA cut the circle at C and A, "
                      . "and let line DB fall on the circle" );
        $t4->explain(   "If the product AD,CD equals BD squared, "
                      . "then DB touches the circle" );
        $c{1} = Circle->new( $pn, $c1[0], $c1[1], $c1[0], $c1[1] + $r1 );
        $p{A} = $c{1}->point(-50)->label( " A",  "right" );
        $p{C} = $c{1}->point(180)->label( "C  ", "bottom" );
        $p{F} = Point->new( $pn, @c1 )->label( "F", "right" );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{AD} = $l{AC}->clone->extend(125);
        $p{D}  = Point->new( $pn, $l{AD}->end )->label( "D ", "top" );

        $l{DB} = $c{1}->draw_tangent( $p{D}, 1, 'negative' );
        $p{B} = Point->new( $pn, $l{DB}->end )->label( "B", "bottom" );

        $t3->math("AD\\{dot}CD = BD\\{squared}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof");
    };

    push @$steps, sub {
        $t4->explain("Draw DE such that it touches the circle (III.17)");
        $l{DE} = $c{1}->draw_tangent( $p{D} );
        $p{E} = Point->new( $pn, $l{DE}->end )->label( "E", "top" );
    };

    push @$steps, sub {
        $t4->explain(   "Since DE touches the circle, the product "
                      . "AD,CD equals DE squared (III.36)" );
        $t4->explain("Therefore DE equals BD");
        $t3->math("AD\\{dot}CD = DE\\{squared}");
        $t3->math("BD = DE");
    };

    push @$steps, sub {
        $t4->explain("Draw EF, where F is the centre of the circle");
        $t4->explain("Angle FED is right (III.18)");
        $l{EF} = Line->join( $p{E}, $p{F} );
        $a{FED} = Angle->new( $pn, $l{DE}, $l{EF} );
    };

    push @$steps, sub {
        $t4->explain("Compare the two triangles DEF and DBF");
        $l{AC}->grey;
        $l{AD}->grey;
        $p{C}->grey;
        $c{1}->grey;
        $p{A}->grey;
        $t3->down;
        $s{DEF} = Triangle->join( $p{D}, $p{E}, $p{F} )->fill($sky_blue);
        $s{DBF} = Triangle->join( $p{D}, $p{B}, $p{F} )->fill($lime_green);
        $t3->math("EF = BF");
    };

    push @$steps, sub {
        $t4->explain(   "Since all three sides of the triangle are "
                      . "equal (I.8), then angle FBD is also right" );
        $l{FB} = Line->join( $p{F}, $p{B} );
        $a{FBD} = Angle->new( $pn, $l{FB}, $l{DB} );
    };

    push @$steps, sub {
        $t4->explain(
                "If the angle FBD is right (and since B is at "
              . "the extremity of the diameter), "
              . "then BD touches the circle (III.16)"
        );
        $s{DEF}->grey;
        $s{DBF}->grey;
        $l{DE}->grey;
        $l{EF}->grey;
        $c{1}->normal;
        $p{E}->grey;
        $a{FED}->grey;
    };

    return $steps;

}

