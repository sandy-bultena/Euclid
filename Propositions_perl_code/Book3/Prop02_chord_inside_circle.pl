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
    "If on the circumference on a circle two points be taken at random, "
  . "the straight line joining the points will fall within the circle.";

$pn->title( 2, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 2 );
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

    my @c = ( 225, 350 );
    my $r = 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{C} =
          Circle->new( $pn, @c, $c[0] + $r, $c[1] )->label( "C", "topright" );
        $t1->title("In other words ");
        $t1->explain(   "Let there be two points, A and B, randomly placed "
                      . "on the circumference of the circle" );
        $p{A} = $c{C}->point(200)->label( "A", "bottomleft" );
        $p{B} = $c{C}->point(270)->label( "B", "bottom" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The straight line AB will fall within the circle ");
        $l{AB} = Line->join( $p{A}, $p{B} );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by contradiction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AB}->remove;
        $t1->explain(   "Let E be a point on the straight line AB, "
                      . "and let it be outside of the circle" );
        $c{AB} = Arc->new( $pn, $r / 1.7, $p{A}->coords, $p{B}->coords );
        $p{E} = $c{AB}->point(235)->label( "E", "bottom" );
        $t3->explain("If AB is a straight line");
        $t3->explain("and E is outside the circle...");
        $t3->math("DE > DF");
        $t3->blue(-1);

        my $aside = $pn->text_box( $p{E}->x, $p{E}->y + 50 );
        $aside->sidenote("Pretend AB is a straight line");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(  "Find the center of the circle (D) (III.1) and "
                     . "draw lines DA,DB, and DE "
                     . "and point F is the intersection of DE and the circle" );
        $p{D} = Point->new( $pn, $c{C}->center )->label(qw(D top));
        $l{DA} = Line->join( $p{D}, $p{A} );
        $l{DE} = Line->join( $p{D}, $p{E} );
        $l{DB} = Line->join( $p{D}, $p{B} );
        $p{F} =
          Point->new( $pn, $c{C}->intersect( $l{DE} ) )->label(qw(F right));
        $t3->grey(-1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{C}->grey;
        $l{DE}->grey;
        $t1->explain("Looking at the isosceles triangle DAB (DA equals DB), "
                   . "then the angles \\{alpha} and \\{beta} are equal (I.5)" );
        $l{AEv} = VirtualLine->new( $c{AB}->tangent( $p{A}->coords ) );
        $l{BEv} = VirtualLine->new( $c{AB}->tangent( $p{B}->coords ) );
        $l{BEv}->prepend(50);
        $l{BEv2} = VirtualLine->new( $l{BEv}->start, $p{B}->coords );
        $a{DAE} = Angle->new( $pn, $l{AEv}, $l{DA} )->label( "\\{alpha}", 20 );
        $a{DBE} = Angle->new( $pn, $l{DB}, $l{BEv2} )->label( "\\{beta}", 20 );
        $t2->y( $t3->y );
        $t2->math("\\{alpha} = \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{DE}->normal;
        $l{DB}->grey;
        $a{DBE}->grey;
        $t1->explain(   "Angle \\{gamma} is exterior to the triangle DAE, "
                      . "so it is larger than the angle \\{alpha} (I.16)" );
        $l{EBv} = VirtualLine->new( $c{AB}->tangent( $p{E}->coords ) );
        $a{DEB} = Angle->new( $pn, $l{EBv}, $l{DE} )->label( "\\{gamma}", 20 );

        $t2->allgrey;
        $t2->math("\\{gamma} > \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{DE}->normal;
        $l{DB}->normal;
        $l{DA}->grey;
        $a{DBE}->normal;
        $a{DAE}->grey;
        $t1->explain(   "Since \\{alpha} equals \\{beta}, then \\{gamma} "
                      . "is also greater than \\{beta}" );
        $t2->allblack;
        $t2->math("\\{gamma} > \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The side opposite a larger angle is larger (I.19), "
                      . "therefore DB is larger than DE" );
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("DB > DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->down;
        $t1->explain(
                  "DB equals DF because they are the radii of the same circle");
        $t2->allgrey;
        $t2->math("DB = DF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore DF is also greater than DE");
        $t2->allgrey;
        $t2->black( [ -1, -2 ] );
        $t2->math("DF > DE");
    };

    push @$steps, sub {
        $l{DE}->normal;
        $l{DB}->grey;
        $l{DA}->grey;
        $c{AB}->grey;
        $t1->explain(   "But DE is larger than DF (by definition), "
                      . "so we have a logical inconsistency" );
        $t3->red(-1);
        $t2->allgrey;
        $t2->red(-1);
    };

    push @$steps, sub {
        $a{DBE}->normal;
        $a{DEB}->normal;
        $a{DAE}->normal;
        $l{DE}->normal;
        $l{DB}->normal;
        $l{DA}->normal;
        $c{AB}->normal;
        $c{C}->normal;
        $t1->explain(
                "Therefore E cannot lie outside of the circle, "
              . "or by similar logic, on the circumference of the circle"
        );
        $t2->allgrey;
        $t3->allgrey;
        $t3->red( [ 0, 1 ] );
    };

    push @$steps, sub {
        $t3->allgrey;
        $t2->down;
        $t3->y($t2->y);
        $t3->explain("AB is a straight line and inside the circle");
        $l{AB}->draw;
        $c{AB}->remove;
        $p{E}->remove;
        $l{DA}->remove;# = Line->join( $p{D}, $p{A} );
        $l{DE}->remove;# = Line->join( $p{D}, $p{E} );
        $l{DB}->remove;# = Line->join( $p{D}, $p{B} );
        $p{F}->remove;
        $p{D}->remove;
        $a{DEB}->remove;
        $a{DAE}->remove;# = Angle->new( $pn, $l{AEv}, $l{DA} )->label( "\\{alpha}", 20 );
        $a{DBE}->remove;# = Angle->new( $pn, $l{DB}, $l{BEv2} )->label( "\\{beta}", 20 );
    };

    return $steps;

}

