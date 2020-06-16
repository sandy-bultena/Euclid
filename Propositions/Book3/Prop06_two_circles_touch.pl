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
  "If two circles touch one another, they will not have the same center.";

$pn->title( 6, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 6 );
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

    my @c1 = ( 280, 340 );
    my $r1 = 180;
    my @c2;
    my $r2 = 140;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words ");
        $t1->explain(   "If two circles AC, and CD touch each other, "
                      . "then the center of the circle "
                      . "AC is not the same as the center of CD" );
        $c{A} =
          Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->label( "A", "bottom" );
        $p{C} = $c{A}->point(125)->label( "C", "left" );
        $l{c1v} = VirtualLine->new( $p{C}->coords, @c1 );
        $l{c1v}->extend( $r2 - $l{c1v}->length );
        $c{D} =
          Circle->new( $pn, $l{c1v}->end, $p{C}->coords )
          ->label( "D", "bottom" );
        @c2 = $c{D}->center;
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
        $t1->explain("Assume that F is the center of both circles");
        $t4->y( $t1->y );
        my @e = ( 0.5 * ( $c1[0] + $c2[0] ), 0.5 * ( $c1[1] + $c2[1] ) );
        $p{F} = Point->new( $pn, @e )->label(qw(F left));

        $t3->explain("Assume F is centre of both circles");
        $t3->allblue;
        $t3->down;
        $t2->y( $t3->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Join FC and draw a line FEB at random");
        $l{FC} = Line->join( $p{F}, $p{C} );
        $p{B}  = $c{A}->point(-20)->label(qw(B right));
        $l{FB} = Line->join( $p{F}, $p{B} );
        $p{E} =
          Point->new( $pn, $c{D}->intersect( $l{FB} ) )->label(qw(E topright));
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                  "Since FC and FB are radii of the circle AC, they are equal");
        $c{A}->fill($sky_blue);
        $t2->math("FC = FB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                  "Since FC and FE are radii of the circle CD, they are equal");
        $c{D}->fill($lime_green);
        $c{A}->fill();
        $t2->allgrey;
        $t2->math("FC = FE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "Since FB and FE are both equal to FC, they "
                      . "are equal to each other" );
        $c{D}->fill();
        $c{A}->fill();
        $t2->allblack;
        $t2->math("FB = FE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "But FE is less than FB, which is inconsistent "
                      . "with the above statement" );
        $t2->math("FB > FE");
        $t2->allgrey;
        $t2->red( [ -1, -2 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->y( $t4->y );
        $t1->down;
        $t1->explain("Therefore F cannot be the center of both circles");
        $t2->allgrey;
        $t3->allred;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->y($t2->y);
        $t3->down;
        $t3->down;
        $t3->down;
        $t3->explain("     F is not the centre of both circles");
    };
    return $steps;

}

