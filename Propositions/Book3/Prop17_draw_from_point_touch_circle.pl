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
  "From a given point to draw a straight line touching a given circle.";

$pn->title( 17, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 840, 150, -width => 480 );
my $t3 = $pn->text_box( 470, 180 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 17 );
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

    my @c1 = ( 240, 380 );
    my $r1 = 100;
    my $f  = 0.6;
    my $ao = 40 * 3.14159 / 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words ");
        $t1->explain(   "The methods required to draw a line from "
                      . "a given point such that it touches the given circle" );
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{A} =
          Point->new( $pn, $c1[0], $c1[1] - $r1 - 120 )->label( "A", "top" );
    };

    push @$steps, sub {
        $p{B} = $c{A}->point(135);
        local $Shape::AniSpeed = 50000;
        $l{ABt} = Line->join( $p{A}, $p{B}, 1, 1 );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Construction");
        $l{ABt}->remove;
        $p{B}->remove;
    };

    push @$steps, sub {
        $t1->explain("Find the centre of the circle E (III.1)");
        $p{E} = Point->new( $pn, @c1 )->label( "E", "right" );
    };

    push @$steps, sub {
        $t1->explain("Draw the line AE");
        $l{AE} = Line->join( $p{A}, $p{E} );
        my @p = $c{A}->intersect( $l{AE} );
        $p{D} = Point->new( $pn, @p[ 0, 1 ] )->label( "  D", "top" );
    };

    push @$steps, sub {
        $t1->explain("Construct a circle with the centre at E, and radius AE");
        $c{B} = Circle->new( $pn, $p{E}->coords, $p{A}->coords );
    };

    push @$steps, sub {
        $t1->explain(   "Construct a line perpendicular to AE from point D, "
                      . "intersecting the larger circle at F" );
        $l{DFt} = $l{AE}->perpendicular( $p{D} )->grey;
        $l{DFt}->prepend(200);
        $l{DFt}->extend(200);
        my @p = $c{B}->intersect( $l{DFt} );
        $p{F} = Point->new( $pn, @p[ 2, 3 ] )->label( "F", "left" );
        $l{FD} = Line->join( $p{F}, $p{D} );
        $l{DFt}->remove;
        $t3->math("\\{angle}FDE = \\{right}");
        $t3->allblue;

    };

    push @$steps, sub {
        $t1->explain(
                    "Draw line FE, intersecting the smaller circle at point B");
        $l{FE} = Line->join( $p{E}, $p{F} );
        my @p = $c{A}->intersect( $l{FE} );
        $p{B} = Point->new( $pn, @p[ 0, 1 ] )->label( "B ", "top" );
    };

    push @$steps, sub {
        $t1->explain("Draw line AB, which touches the circle at B");
        $l{AB} = Line->join( $p{A}, $p{B} );
        $c{B}->grey;
        $l{AE}->grey;
        $l{FE}->grey;
        $l{FD}->grey;
    };

    push @$steps, sub {
        $t1->down;
        $t1->title("Proof");
    };

    push @$steps, sub {
        $t1->explain("Lines AE,FE are equal, as are DE and BE");
        $c{A}->grey;
        $c{B}->normal;
        $l{AB}->grey;
        $l{AE}->normal;
        $l{FE}->normal;
        $t3->math("AE = FE");
    };

    push @$steps, sub {
        $c{B}->grey;
        $c{A}->normal;
        $l{AE}->grey;
        $l{FE}->grey;
        $l{DE} = Line->join( $p{D}, $p{E} );
        $l{BE} = Line->join( $p{B}, $p{E} );
        $t3->math("DE = BE");
    };

    push @$steps, sub {
        $c{A}->grey;
        $t1->explain( "Two triangles with two sides equal to two "
                . "sides and a common angle at E, are equivalent (I.4) (SAS)" );
        $p{x} = Point->new( $pn, $l{AB}->intersect( $l{FD} ) );
        $s{EBD} = Polygon->join( 4, $p{E}, $p{D}, $p{x}, $p{B} )->fill($blue);
        $s{AD} = Triangle->join( $p{A}, $p{x}, $p{D} )->fill($sky_blue);
        $s{FB} = Triangle->join( $p{F}, $p{B}, $p{x} )->fill($sky_blue);
        $t3->math("\\{triangle}ABE \\{equivalent} \\{triangle}FDE");
    };

    push @$steps, sub {
        $t1->explain(   "So angle ABE is equal to FDE, which is a "
                      . "right angle by construction, therefore ABE is right" );
        $a{EDF} = Angle->new( $pn, $l{FD}, $l{DE} );
        $a{ABE} = Angle->new( $pn, $l{BE}, $l{AB} );
        $t3->down;
        $t3->allgrey;
        $t3->black(-1);
        $t3->blue(0);
        $t3->math("\\{angle}FDE = \\{angle}ABE");
        $t3->math("\\{therefore} \\{angle}ABE = \\{right}");

    };

    push @$steps, sub {
        $t1->explain("EB is the radius, and a line drawn at perpendicular "
                   . "to the diameter of a circle "
                   . "(at the extremities), touches the circle\\{nb}(III.16)" );
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("EB \\{perp} AB");
        $s{EBD}->remove;
        $s{AD}->remove;
        $s{FB}->remove;
        $c{A}->normal;
        $l{AB}->normal;
        $p{x}->remove;
        $l{DE}->remove;
        $a{EDF}->remove;
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain("Therefore, the line AB touches the circle at B");
        $a{ABE}->remove;
        $l{BE}->grey;
        $t3->allgrey;
        $t3->black(-1);
        $t3->blue(0);
    };

    return $steps;

}

