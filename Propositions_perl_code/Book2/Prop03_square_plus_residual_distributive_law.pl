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
    "If a straight line be cut at random, the rectangle "
  . "contained by the whole and one of the segments "
  . "is equal to the rectangle contained by the segments and the "
  . "square on the aforesaid segment.";

$pn->title( 3, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 820, 430 );
my $t3 = $pn->text_box( 200, 490 );
my $t5 = $pn->text_box( 200, 490 );

my $steps;
push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 3 );
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
    my ( %l, %p, %c, %s );

    my @A = ( 200, 200 );
    my @B = ( 450, 200 );
    my @C = ( 300, 200 );

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Let AB be a straight line, arbitrarily cut at point C");
        $p{A} = Point->new( $pn, @A )->label(qw(A left));
        $p{B} = Point->new( $pn, @B )->label(qw(B right));
        $l{A} = Line->new( $pn, @B, @A );
        $p{C} = Point->new( $pn, @C )->label(qw(C top));
        $t5->math("AB = AC + CB");
        $t5->allblue;
        $t3->y( $t5->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Then the area of the rectangle formed by "
               . "line AB and CB is equal in area to the sum of the rectangles "
               . "formed by line CB and AC, and line CB and CB" );
        $t5->math("CB\\{dot}AB = CB\\{dot}AC + CB\\{dot}CB");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t5->erase;
        $t5->math("AB = AC + CB");
        $t5->allblue;
        $t1->down;
        $t1->title("Proof:");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw a square CDEB on the line CB\\{nb}(I.46) "
                      . "and draw a line AF parallel to either "
                      . "CD or BE\\{nb}(I.31).  Extend DE to the point F" );

        $s{CB} = Square->new( $pn, $p{B}->coords, $p{C}->coords );
        $s{CB}->p(1)->label(qw(E right));
        $s{CB}->p(4)->label(qw(D bottom));
        $p{D} = $s{CB}->p(4);
        $p{E} = $s{CB}->p(1);
        $l{D} = $s{CB}->l(4)->clone;

        $l{Ft} = $s{CB}->l(3)->parallel( $p{A} );
        $l{Ft}->prepend(100);
        $p{F} =
          Point->new( $pn, $l{Ft}->intersect( $s{CB}->l(4) ) )
          ->label(qw(F bottom));
        $l{F} = Line->join( $p{A}, $p{F}, -1 );
        $l{Ft}->remove();
        $l{D}->prepend( $l{A}->length - $l{D}->length );
        $t3->math("CB = BE = CD = AF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "The rectangle AE is the sum of the rectangles AF and\\{nb}CE");
        $s{AE} =
          Polygon->new( $pn, 4, $p{A}->coords, $p{F}->coords, $p{E}->coords,
                        $p{B}->coords, -1 );
        $s{AD} =
          Polygon->new( $pn, 4, $p{A}->coords, $p{F}->coords, $p{D}->coords,
                        $p{C}->coords, -1 );
        $s{AD}->fill($sky_blue);
        $s{CE} =
          Polygon->new( $pn, 4, $p{C}->coords, $p{D}->coords, $p{E}->coords,
                        $p{B}->coords, -1 );
        $s{CE}->fill($lime_green);

        $t3->allgrey;
        $t3->math("\\{square}AE = \\{square}AD + \\{square}CE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since AF is equal in length to CB (I.34), "
                    . "the rectangle AE is equal to the rectangle contained by "
                    . "lines AB and CB" );
        $s{AE}->fill($pale_pink);
        $t3->allgrey;
        $t3->black(0);
        $t3->math(   "\\{square}AE = AF\\{dot}AB,   "
                   . "\\{therefore} \\{square}AE = CB\\{dot}AB" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{AE}->fill();
        $s{CE}->fill();
        $t1->explain(   "Similarly, the rectangle AD is equal to the "
                      . "rectangle contained by lines CB and AC" );
        $t3->allgrey;
        $t3->black(0);
        $t3->math(   "\\{square}AD = AF\\{dot}AC,   "
                   . "\\{therefore} \\{square}AD = CB\\{dot}AC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{CE}->fill($lime_green);
        $s{AD}->fill;
        $t3->allgrey;
        $t3->black(0);
        $t1->explain(   "Since CD equals AF (I.34), CE is equal to the "
                      . "rectangle contained by lines CB and CB" );
        $t3->math(   "\\{square}CE = CD\\{dot}CB,   "
                   . "\\{therefore} \\{square}CE = CB\\{dot}CB" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Thus, the rectangle formed by CB,AB is equal to the sum "
                      . "of the rectangles formed by CB,AC and CB,CB" );
        $s{AD}->fill($sky_blue);
        $t3->allgrey;
        $t3->black( [ 1 .. 4 ] );
        $t3->down;
        $t3->math("CB\\{dot}AB = CB\\{dot}AC + CB\\{dot}CB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
    };

    return $steps;

}

