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
    "In obtuse-angled triangles the square on the side subtending the "
  . "obtuse angle is greater than the squares on the sides containing the "
  . "obtuse angle by twice the rectangle contained by one of the sides about "
  . "the obtuse angle, namely that on which the perpendicular falls, and the "
  . "straight line cut off outside by the perpendicular towards the obtuse angle.";

$pn->title( 12, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t6 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 480, 240 );
my $t3 = $pn->text_box( 160, 500 );
my $text_pos;

my $steps;
push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 12 );
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

    my @A = ( 260, 400 );
    my @B = ( 140, 200 );
    my @D;
    my @C = ( 460, 400 );
    my @E;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->down;
        $t1->title("In other words");
        $t1->explain( "Given an obtuse triangle ABC, where the obtuse angle is "
            . "opposite of BC. Extend the base AC to point D, where D is the intersection "
            . "of the perpendicular from point B to the line AC. " );
        $t1->explain(
                "The square of BC equals the square of AB and "
              . "AC plus twice the rectangle formed by AC,AD"
        );

        $s{ACB} = Triangle->new( $pn, @A, @C, @B );
        $s{ACB}->set_points(qw(A bottom C bottom B top));
        $s{ACB}->fill($sky_blue);
        @p{ "A",  "C",  "B" }  = $s{ACB}->points;
        @l{ "AC", "CB", "BA" } = $s{ACB}->lines;

        $l{ADt} = $l{AC}->clone;
        $l{ADt}->prepend(200)->grey;
        $l{BD} = $l{ADt}->perpendicular( $p{B} );
        @D     = $l{ADt}->intersect( $l{BD} );
        $p{D}  = Point->new( $pn, @D )->label( "D", "bottom" );
        $l{DA} = Line->new( $pn, @D, @A );
        $l{ADt}->remove;

        $t5->y( $t1->y );
        $t5->math(
"BC\\{squared} = AB\\{squared} + AC\\{squared} + 2\\{dot}AD\\{dot}AC" );
        $t1->y( $t5->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->y( $t1->y );
        $t4->down;
        $t4->explain("Or... the cosine law");
        $t6->y( $t4->y );
        $t6->math("BC=a, AB=c, AC=b, AD=c\\{dot}cos(\\{alpha})");
        $t6->math(   "cos(\\{alpha})=-cos(\\{theta}) \\{therefore} "
                   . "AD=-c\\{dot}cos(\\{theta})" );

        $t6->down;
        $t6->math(   "BC\\{squared} = AB\\{squared} + "
                   . "AC\\{squared} + 2\\{dot}AC\\{dot}AD" );

        $t6->math(   " a\\{squared} =  c\\{squared} +  b\\{squared} "
                   . "- 2\\{dot} b\\{dot}c\\{dot}cos(\\{theta})" );

        $s{ACB}->set_angles( "\\{theta}", undef, undef, 20 );
        $s{ACB}->set_labels(qw(b bottom a top c left));
        $a{alpha} = Angle->new( $pn, $l{BA}, $l{DA} )->label("\\{alpha}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t6->erase;
        $t2->erase;
        $t4->y( $t1->y );
        $t4->down;
        $s{ACB}->remove_labels;
        $s{ACB}->remove_angles;
        $a{alpha}->remove;
        $t4->title("Proof");

        $t4->explain( "The line DC is cut at a point A, and thus the square of "
            . "DC is equal to the squares of DA and AC plus twice the rectangle "
            . "formed by DA and AC (II.4)" );

        $t3->math(   "DC\\{squared} = DA\\{squared} + AC\\{squared} "
                   . "+ 2\\{dot}DA\\{dot}AC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Add the square of DB to both sides of the equality");

        $t3->math(   "(DC\\{squared} + DB\\{squared}) = (DA\\{squared} "
                   . "+ DB\\{squared}) + AC\\{squared} + 2\\{dot}DA\\{dot}AC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                "The squares of DC and DB equals the square of BC\\{nb}(I.47)");
        $s{ACB}->fill();
        $s{BDC} = Triangle->new( $pn, @B, @D, @C, -1 )->fill($pale_pink);
        $t3->allgrey;
        $t3->math("DC\\{squared} + DB\\{squared} = BC\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math(   "BC\\{squared} = (DA\\{squared} + "
                   . "DB\\{squared}) + AC\\{squared} + 2\\{dot}DA\\{dot}AC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                "The squares of DA and DB equals the square of AB\\{nb}(I.47)");
        $s{BDC}->fill();
        $s{BAD} = Triangle->new( $pn, @B, @A, @D, -1 )->fill($lime_green);
        $t3->allgrey;
        $t3->math("DA\\{squared} + DB\\{squared} = AB\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math(   "BC\\{squared} = AB\\{squared} "
                   . "+ AC\\{squared} + 2\\{dot}DA\\{dot}AC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain( "Thus the square of BC is equal to the sum of the "
                 . "squares of AB and AC, plus the rectangle formed by DA,AC" );
        $s{BAD}->fill();
        $s{ACB}->fill($sky_blue);
        $t3->allgrey;
        $t3->black(-1);
    };

    return $steps;

}

