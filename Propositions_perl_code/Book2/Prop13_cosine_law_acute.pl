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
    "In acute-angled triangles the square on the side subtending the "
  . "acute angle is less than the squares on the sides containing the "
  . "acute angle by twice the rectangle contained by one of the sides about "
  . "the acute angle, namely that on which the perpendicular falls, and the "
  . "straight line cut off within by the perpendicular towards the acute\\{nb}angle.";

$pn->title( 13, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t6 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 480, 240 );
my $t3 = $pn->text_box( 160, 500 );
my $text_pos;

my $steps;
push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 13 );
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

    my @B = ( 140, 400 );
    my @A = ( 260, 200 );
    my @D;
    my @C = ( 460, 400 );
    my @E;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain(   "Given an acute triangle ABC, where the acute angle is "
                      . "opposite of AC. Define point D as the intersection "
                      . "of the perpendicular from point A to the line BC. " );
        $t1->explain(   "The square of AC equals the square of AB and "
                      . "BC plus twice the rectangle formed by BC,BD" );
        $t5->y( $t1->y );
        $t5->math(   "AC\\{squared} = AB\\{squared} + "
                   . "BC\\{squared} - 2\\{dot}BD\\{dot}BC" );
        $t1->y( $t5->y );

        $s{ACB} = Triangle->new( $pn, @A, @B, @C );
        $s{ACB}->set_points(qw(A top B bottom C bottom));
        $s{ACB}->fill($sky_blue);
        @p{ "A",  "B",  "C" }  = $s{ACB}->points;
        @l{ "AB", "BC", "CA" } = $s{ACB}->lines;

        $l{AD} = $l{BC}->perpendicular( $p{A} );
        @D     = $l{AD}->intersect( $l{BC} );
        $p{D}  = Point->new( $pn, @D )->label( "D", "bottom" );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->y( $t1->y );
        $t4->down;
        $t4->explain("Or... the cosine law");
        $t6->y( $t4->y );
        $t6->math("AC=a, AB=c, BC=b, BD = c\\{dot}cos(\\{theta})");
        $t6->down;
        $t6->math(   "AC\\{squared} = AB\\{squared} "
                   . "+ BC\\{squared} - 2\\{dot}BC\\{dot}BD" );
        $t6->math( " a\\{squared} =  c\\{squared} "
               . "+  b\\{squared} - 2\\{dot} b \\{dot}c\\{dot}cos(\\{theta})" );
        $p{D}->label;
        $s{ACB}->set_angles( undef, "\\{theta}", undef, undef, 20 );
        $s{ACB}->set_labels(qw(c left b bottom a right));
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t6->erase;
        $t4->y( $t1->y );
        $t4->down;
        $s{ACB}->remove_labels;
        $s{ACB}->remove_angles;
        $p{D}->label( "D", "bottom" );

        $t4->title("Proof");

        $t4->explain(   "The line BC is cut at a point D, and thus "
                      . "the sum of the squares of BC and BD is "
                      . "equal to the square of DC plus twice the rectangle "
                      . "formed by BC and BD (II.7)" );

        $t3->math(   "BC\\{squared} + BD\\{squared} "
                   . "= DC\\{squared} + 2\\{dot}BC\\{dot}BD" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Add the square of AD to both sides of the equality");

        $t3->math(  "BC\\{squared} + (BD\\{squared} + AD\\{squared}) "
                  . "= (DC\\{squared} + AD\\{squared}) + 2\\{dot}BC\\{dot}BD" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                "The squares of BD and AD equals the square of AB\\{nb}(I.47)");
        $s{ACB}->fill();
        $s{ABD} = Triangle->new( $pn, @A, @B, @D, -1 )->fill($sky_blue);
        $t3->allgrey;
        $t3->math("BD\\{squared} + AD\\{squared} = AB\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->black( [ -1, -2 ] );
        $t3->math(  "BC\\{squared} + AB\\{squared} "
                  . "= (DC\\{squared} + AD\\{squared}) + 2\\{dot}BC\\{dot}BD" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                "The squares of AD and DC equals the square of AC\\{nb}(I.47)");
        $s{ABD}->fill();
        $s{ADC} = Triangle->new( $pn, @A, @D, @C, -1 )->fill($lime_green);
        $t3->allgrey;
        $t3->math("AD\\{squared} + DC\\{squared} = AC\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->black( [ -1, -2 ] );
        $t3->math(   "BC\\{squared} + AB\\{squared} "
                   . "= AC\\{squared} + 2\\{dot}BC\\{dot}BD" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain( "Thus the square of AC is equal to the sum of the "
                 . "squares of BC and AB, less the rectangle formed by BC,BD" );
        $s{ADC}->fill();
        $s{ACB}->fill($pale_pink);
        $t3->down;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math(
            "AC\\{squared} = BC\\{squared} "
              . "+ AB\\{squared} - 2\\{dot}BC\\{dot}BD"
        );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
    };

    return $steps;

}

