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
  "If two circles cut one another, they will not have the same center.";

$pn->title( 5, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 5 );
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
    my @c2 = ( 200, 320 );
    my $r2 = 140;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words ");
        $t1->explain(   "If two circles ABC, and BCD cut each other, "
                      . "then the center of the "
                      . "ABC is not the same as the center of BCD" );
        $c{D} =
          Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->label( "D", "top" );
        $c{A} =
          Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] )->label( "A", "left" );
        my @p = $c{D}->intersect( $c{A} );
        $p{B} = Point->new( $pn, @p[ 2, 3 ] )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @p[ 0, 1 ] )->label( "C", "top" );
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
        $t1->explain("Assume that E is the center of both circles");
        $t4->y( $t1->y );
        my @e = ( 0.5 * ( $c1[0] + $c2[0] ), 0.5 * ( $c1[1] + $c2[1] ) );
        $p{E} = Point->new( $pn, @e )->label(qw(E left));

        $t3->explain("E is centre of both circles");
        $t3->allblue;
        $t3->down;
        $t2->y( $t3->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Join EC and draw a line EFG at random");
        $l{EC} = Line->join( $p{E}, $p{C} );
        $p{G}  = $c{D}->point(-35)->label(qw(G right));
        $l{EG} = Line->join( $p{E}, $p{G} );
        $p{F} = Point->new( $pn, $c{A}->intersect( $l{EG} ) )->label(qw(F top));
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                 "Since CE and EF are radii of the circle ABC, they are equal");
        $c{A}->fill($sky_blue);
        $t2->math("CE = EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                 "Since CE and EG are radii of the circle BCD, they are equal");
        $c{D}->fill($lime_green);
        $c{A}->fill();
        $t2->math("CE = EG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
            "Since EF and EG are both equal to CE, they are equal to each other"
        );
        $c{D}->fill();
        $c{A}->fill();
        $t2->math("EF = EG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "But EF is less than EG, which is inconsistent "
                      . "with the above statement" );
        $t2->allgrey;
        $t2->math("EF < EG");
        $t2->red( [ -1, -2 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->y( $t4->y );
        $t1->down;
        $t1->explain("Therefore E cannot be the center of both circles");
        $t2->allgrey;
        $t3->allred;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->y($t2->y);
        $t3->down;
        $t3->explain("     E is not the centre of both circles");
    };

    return $steps;

}

