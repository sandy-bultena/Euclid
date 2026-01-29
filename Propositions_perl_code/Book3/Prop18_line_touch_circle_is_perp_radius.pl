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
    "If a straight line touch a circle, and a straight line be joined from the "
  . "centre to the point of contact, the straight line so joined will be "
  . "perpendicular to the tangent.";

$pn->title( 18, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 840, 150, -width => 480 );
my $t3 = $pn->text_box( 470, 180 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 18 );
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

    my @c1 = ( 180, 280 );
    my $r1 = 150;
    my $f  = 0.6;
    my $ao = 40 * 3.14159 / 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words ");
        $t1->explain(   "If line ED touches a circle at point C, then it is "
                      . "perpendicular to the radius FC" );
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{F} = Point->new( $pn, @c1 )->label( "F", "left" );
        $p{C} = $c{A}->point(-40)->label( "C", "right" );
        $l{FC} = Line->join( $p{F}, $p{C} );
        $l{ED} = $l{FC}->perpendicular( $p{C} );
        $l{ED}->prepend(180);
        $p{E} = Point->new( $pn, $l{ED}->end )->label( "E", "bottom" );
        $p{D} = Point->new( $pn, $l{ED}->start )->label( "D", "top" );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
    };

    push @$steps, sub {
        $t1->explain(
             "If FCD is not a right angle, draw a line FG perpendicular to ED");
        $l{FGt} = Line->new( $pn, @c1, $c1[0] + 2 * $r1, $c1[1] )->grey;
        my @p = $l{FGt}->intersect( $l{ED} );
        $p{G} = Point->new( $pn, @p[ 0, 1 ] )->label( "G", "right" );
        $l{FG} = Line->join( $p{F}, $p{G} );
        $l{FGt}->remove;
        @p = $c{A}->intersect( $l{FG} );
        $p{B} = Point->new( $pn, @p[ 0, 1 ] )->label( "B  ", "top" );
        $l{CG} = Line->join( $p{C}, $p{G} );
        $a{G} = Angle->new( $pn, $l{FG}, $l{CG} )->label( "\\{alpha}", 15 );
        $t3->math("\\{beta} \\{notequal} \\{right}");
        $t3->math("\\{alpha} = \\{right}");
        $t3->allblue;
    };

    push @$steps, sub {
        $c{A}->grey;
        $l{ED}->grey;
        $t1->explain( "The sum of the angles in a triangle is less than "
                . "two right angles (I.17) "
                . "so if CGF (\\{alpha}) is a right angle, then FCG (\\{beta}) "
                . "must be less than a right angle" );

        $a{F} = Angle->new( $pn, $l{FC}, $l{FG} )->label("\\{gamma}");
        $a{C} =
          Angle->new( $pn, $l{CG}, $l{FC}, -noright => 1 )
          ->label( "\\{beta}", 20 );

        $t3->math("\\{alpha} + \\{beta} + \\{gamma} = 2\\{dot}\\{right}");
        $t3->math("\\{right} + \\{beta} + \\{gamma} = 2\\{dot}\\{right}");
        $t3->math("\\{beta} + \\{gamma} = \\{right}");
        $t3->math("\\{beta} < \\{right}");
        $t3->math("\\{beta} < \\{alpha}");
    };

    push @$steps, sub {
        $t1->explain(   "Since \\{beta} is less than \\{alpha}, "
                      . "and the side opposite the larger"
                      . " angle is larger (I.19), FC is larger than FG" );
        $t3->down;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("FC > FG");
    };

    push @$steps, sub {
        $t1->explain(   "But FB is equal to FC (radii), and FG is "
                      . "larger than FB, so FG is greater than FC" );
        $t3->down;
        $t3->allgrey;
        $t3->math("FB = FC");
        $t3->math("FG > FB");
        $t3->down;
        $t3->math("FG > FC");
    };

    push @$steps, sub {
        $t1->explain(   "FG cannot be both larger and smaller than FC, "
                      . "so we have a logical inconsistency" );
        $c{A}->normal;
        $l{FG}->grey;
        $l{ED}->normal;
        $a{F}->remove;
        $a{G}->remove;
        $t3->allgrey;
        $t3->red( [ -1, -4 ] );
    };

    push @$steps, sub {
        $t1->explain("So the initial assumption must be wrong");
        $t3->allgrey;
        $t3->red(0);
    };
    push @$steps, sub {
        $t1->explain(
                 "Therefore the angle \\{beta} must be equal to a right angle");
        $c{A}->normal;
        $l{FG}->grey;
        $l{ED}->normal;
        $a{F}->remove;
        $a{G}->remove;
        $t3->down;
        $t3->math("\\{therefore} \\{beta} = \\{right}");

    };

    return $steps;

}

