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
    "If a straight line touch a circle, and from the point of contact a "
  . "straight line be drawn at right angles to the tangent, the centre of "
  . "the circle will be on the straight line so drawn.";

$pn->title( 19, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 840, 150, -width => 480 );
my $t3 = $pn->text_box( 470, 180 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 19 );
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

    my @c1 = ( 290, 320 );
    my $r1 = 165;
    my $f  = 0.6;
    my $ao = 40 * 3.14159 / 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words ");
        $t1->explain( "If line ED touches a circle, and a line AC is drawn "
               . "perpendicular to ED at the point where it touches the circle,"
               . " then AC will pass through the centre of the circle\\{nb}F" );
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{F} = Point->new( $pn, @c1 )->label( "F", "right" );
        $p{C} = $c{A}->point(-90)->label( "C", "bottom" );
        $l{DE} = Line->new( $pn,
                            $c1[0] - $r1 - 40,
                            $c1[1] + $r1,
                            $c1[0] + $r1 + 40,
                            $c1[1] + $r1 );
        $p{A} = $c{A}->point(90)->label( "A", "top" );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $p{D} = Point->new( $pn, $l{DE}->start )->label( "D", "bottom" );
        $p{E} = Point->new( $pn, $l{DE}->end )->label( "E", "bottom" );
        $l{CE} = Line->join( $p{C}, $p{E} );

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
    };

    push @$steps, sub {
        $t1->explain(   "Assume that AC does not pass through "
                      . "the centre of the circle\\{nb}F" );
        $p{F}->remove;
        $p{F} =
          Point->new( $pn, $c1[0] + .25 * $r1, $c1[1] )->label( "F", "right" );
    };

    push @$steps, sub {
        $t1->explain("Draw the line CF");
        $l{CF} = Line->join( $p{C}, $p{F} );
    };

    push @$steps, sub {
        $t1->explain(
                "Since line DE touches the circle, a line "
              . "drawn from the centre of the "
              . "circle to the line DE forms a right angle\\{nb}(III.18), "
              . "so FCE (\\{alpha}) is a right angle"
        );
        $a{FCE} = Angle->new( $pn, $l{CE}, $l{CF} )->label( "\\{alpha}", 60 );
        $l{AC}->grey;
        $t3->math("\\{alpha} = \\{right}");
    };

    push @$steps, sub {
        $t1->explain(
                   "ACE (\\{epsilon}) is also a right angle (by construction)");
        $l{CF}->grey;
        $l{AC}->normal;
        $a{ACE} =
          Angle->new( $pn, $l{CE}, $l{AC}, -noright => 1 )->label( " ", 50 );
        $a{ACEx} =
          Angle->new( $pn, $l{CF}, $l{AC}, -noright => 1 )
          ->label( "\\{epsilon}", 50 );
        $a{FCE}->grey;
        $t3->math("\\{epsilon} = \\{right}");
    };

    push @$steps, sub {
        $t1->explain("So FCE equals ACE");
        $t3->down;
        $t3->math("\\{therefore} \\{epsilon} = \\{alpha}");

    };

    push @$steps, sub {
        $t1->explain("This is impossible...");
        $l{CF}->normal;
        $a{FCE}->normal;
        $t3->allred;
    };

    push @$steps, sub {
        $t1->explain("... unless the line AC passes through the centre F");
        $p{F}->remove;
        $p{F} = Point->new( $pn, @c1 )->label( "F", "left" );
        $l{CF}->grey;
        $a{ACE}->grey;
        $a{ACEx}->grey;
        $a{FCE}->grey;
        $t3->allblack;
    };

    return $steps;

}

