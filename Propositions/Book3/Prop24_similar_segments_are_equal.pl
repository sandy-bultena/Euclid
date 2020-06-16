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
my $title = "Similar segments of circles on equal straight lines are "
  . "equal to one another.";

$pn->title( 24, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 520, 180 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 23 );
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

    my @c1 = ( 320, 540 );
    my $r1 = 320;
    my @c2 = ( 320, 740 );
    my $r2 = 320;

    # -------------------------------------------------------------------------
    # definition
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("Definition - Similar segments of circles");
        $t4->explain( "'Similar segments of circles' are those which admit "
               . "equal angles, or in which the angles are equal to one another"
        );
        $c{A}  = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $p{B}  = $c{A}->point(45);
        $p{A}  = $c{A}->point(135);
        $l{AB} = Line->join( $p{A}, $p{B} )->green;
        $c{AB} = Arc->new( $pn, $r1, $p{B}->coords, $p{A}->coords )->green;
        $c{A}->remove;

        $c{A1} =
          Circle->new( $pn, $c1[0], $c1[1] + 200, $c1[0] + $r1, $c1[1] + 200 )
          ->grey;
        $p{B1}  = $c{A1}->point(45);
        $p{A1}  = $c{A1}->point(135);
        $l{AB1} = Line->join( $p{A1}, $p{B1} )->green;
        $c{AB1} = Arc->new( $pn, $r1, $p{B1}->coords, $p{A1}->coords )->green;
        $c{A1}->remove;

        $p{C} = $c{A}->point(85)->label( "C", "top" );
        $p{D} = $c{A1}->point(70)->label( "D", "top" );

        $l{CA} = Line->join( $p{C}, $p{A} );
        $l{CB} = Line->join( $p{C}, $p{B} );

        $l{DA} = Line->join( $p{D}, $p{A1} );
        $l{DB} = Line->join( $p{D}, $p{B1} );

        $t3->math("\\{angle}C = \\{angle}D");
    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->erase;
        $t3->erase;
        $p{B1}->remove;
        $p{A1}->remove;
        $l{AB1}->remove;
        $c{AB1}->remove;
        $p{D}->remove;
        $l{DA}->remove;
        $l{DB}->remove;
        $l{CA}->remove;
        $l{CB}->remove;
        $l{DA}->remove;
        $l{DB}->remove;
        $p{C}->remove;
        $p{D}->remove;
        $c{AB}->normal;
        $c{AB}->label( "E", "top" );
        $l{AB}->normal;
        $p{A}->label( "A", "bottom" );
        $p{B}->label( "B", "bottom" );

        $t4->title("In other words");
        $t4->explain(   "If two similar segments are placed on one another, "
                      . "they will coincide with one another" );

        $c{C} = Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] )->grey;
        $p{D} = $c{C}->point(45)->label( "D", "bottom" );
        $p{C} = $c{C}->point(135)->label( "C", "bottom" );
        $l{CD} = Line->join( $p{D}, $p{C} );
        $c{CD} =
          Arc->new( $pn, $r1, $p{D}->coords, $p{C}->coords )
          ->label( "F      ", "top" );
        $c{C}->remove;

        $t3->math("AB = CD");
        $t3->math("AEB = CFD");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof by Contradiction");
    };

    push @$steps, sub {
        $t4->explain( "Assume that when the segment AEB is is placed on CED, "
            . "the circumference AB will not coincide with the circumference CD"
        );
        $t4->explain("Then it will either ");
    };

    push @$steps, sub {
        $t1->y( $t4->y );
        $t4->explain("\\{dot}");
        $t1->explain("fall on the inside or the outside");
        $t1->explain("which is impossible (III.23)");
        $c{B1} =
          Arc->new( $pn, $r2 / 1.2, $p{D}->coords, $p{C}->coords )->green;
        $c{B2} =
          Arc->new( $pn, $r2 * 1.2, $p{D}->coords, $p{C}->coords )->green;
    };

    push @$steps, sub {
        $t4->y( $t1->y );
        $t4->explain("or");
        $t1->y( $t4->y );
        $t4->explain("\\{dot}");
        $t1->explain("fall awry, such as CGD ");
        $t1->explain( "which is impossible, because then the circles would cut "
                      . "each other in more than two places, "
                      . "which is impossible (III.10)" );
        $c{B2}->remove;
        $c{B1}->remove;
        $p{G} = $c{C}->point(90)->label( "G", "top" );
        $c{CG} = Arc->new( $pn, $r2 * 1.6, $p{G}->coords, $p{C}->coords );
        $c{GD} = Arc->new( $pn, $r2 / 1.6, $p{D}->coords, $p{G}->coords );
    };

    push @$steps, sub {
        $t4->y( $t1->y );
        $t4->down;
        $t4->explain(   "Therefore, segment AEB would coincide with CFD, "
                      . "and will be equal to it" );
        $c{CG}->grey;
        $c{GD}->grey;
    };

    return $steps;

}

