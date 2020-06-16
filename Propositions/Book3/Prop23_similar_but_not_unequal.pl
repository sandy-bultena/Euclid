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
my $title = "On the same straight line there cannot be constructed two similar "
  . "and unequal segments of circles on the same side";

$pn->title( 23, $title, 'III' );
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
    my $f  = 0.6;
    my $ao = 40 * 3.14159 / 180;

    # -------------------------------------------------------------------------
    # definition
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("Definition - Similar segments of circles");
        $t4->explain( "'Similar segments of circles' are those which "
            . "admit equal angles, or in which the angles are equal to one another"
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
        $p{B1}->remove;
        $p{A1}->remove;
        $l{AB1}->remove;
        $c{AB1}->remove;
        $p{D}->remove;
        $l{DA}->remove;
        $l{DB}->remove;

        $t4->erase;
        $t1->erase;
        $t3->erase;
        $t4->title("In other words");
        $t4->explain("It is impossible to construct a figure (as shown) where");
        $t1->y( $t4->y );
        $t4->explain("\\{dot}");
        $t1->explain("the two segments of the circle are not equal, and");
        $t4->y( $t1->y );
        $t4->explain("\\{dot}");
        $t1->explain( "any angle C on the inner circle is equal to any angle D "
                      . "on the outer circle" );

        $c{D} = Arc->new( $pn, $r1 / 1.3, $p{B}->coords, $p{A}->coords );
        $p{A}->label( "A", "bottom" );
        $p{B}->label( "B", "bottom" );

        $p{D} = $c{D}->point(50)->label( "D", "top" );

        $l{DA} = Line->join( $p{D}, $p{A} );
        $l{DB} = Line->join( $p{D}, $p{B} );

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->y( $t1->y );
        $t4->down;
        $t4->title("Proof");
        $l{DA}->remove;
        $l{DB}->remove;
        $p{D}->remove;
    };

    push @$steps, sub {
        $t4->explain(   "Extend line AC such that it intersects the larger "
                      . "circle at point D, and draw a line from D to B" );

        $l{CAx} = $l{CA}->clone;
        $l{CAx}->prepend(300);
        $l{CAx}->remove;
        my @p = $c{D}->intersect( $l{CAx} );
        $p{D} = Point->new( $pn, @p[ 0, 1 ] )->label( "D", "top" );
        $l{DA} = Line->join( $p{D}, $p{A} );
        $l{DB} = Line->join( $p{D}, $p{B} );
    };

    push @$steps, sub {
        $t4->explain("Consider the angles ACB (\\{gamma}) and CDB (\\{delta})");
        $t4->explain(
                "The angle \\{gamma} is exterior to the triangle CDB, and thus "
                  . "is larger than any interior/opposite angle (I.16)" );
        $a{C} = Angle->new( $pn, $l{CA}, $l{CB} )->label( "\\{gamma}", 20 );
        $a{D} = Angle->new( $pn, $l{DA}, $l{DB} )->label( "\\{delta}", 20 );
        $s{CDB} = Triangle->join( $p{C}, $p{D}, $p{B} )->fill($sky_blue);
        $t3->math("\\{gamma} > \\{delta}");
    };

    push @$steps, sub {
        $t4->explain( "THUS, the two circle segments cannot be similar, "
            . "because \\{gamma} cannot be both equal and greater than \\{delta}"
        );
    };

    return $steps;

}

