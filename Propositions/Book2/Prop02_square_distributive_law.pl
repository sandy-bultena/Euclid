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
    "If a straight line be cut at random, the rectangles "
  . "contained by the whole and both of the segments "
  . "are equal to the square on the whole";

$pn->title( 2, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 820, 430 );
my $t3 = $pn->text_box( 200, 530 );
my $t4 = $pn->text_box( 200, 490 );

my $steps;
push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 2 );
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
        $t4->math("AB = AC + CB");
        $t4->blue;
        $t3->y( $t4->y );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Then the area of the square formed by line AB "
                      . "is equal in area to the sum of the rectangles "
                      . "formed by line AB and AC, and line AB and BC" );
        $t4->math("AB\\{dot}AB = AB\\{dot}AC + AB\\{dot}BC");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->math("AB = AC + CB");
        $t4->blue;
        
        $t1->down;
        $t1->title("Proof:");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a square ABED on the line AB\\{nb}(I.46) and "
                   . "draw a line CF parallel to either AD or BE\\{nb}(I.31)" );

        $s{AB} = Square->new( $pn, $l{A}->coords );
        $s{AB}->p(1)->label(qw(E right));
        $s{AB}->p(4)->label(qw(D left));
        $p{D} = $s{AB}->p(4);
        $p{E} = $s{AB}->p(1);

        $l{Ct} = $s{AB}->l(3)->parallel( $p{C} );
        $l{Ct}->prepend(100);
        $p{F} =
          Point->new( $pn, $l{Ct}->intersect( $s{AB}->l(4) ) )
          ->label(qw(F bottom));
        $l{C} = Line->join( $p{C}, $p{F}, -1 );
        $l{Ct}->remove();

        $t3->math("AB = AD = CF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "The rectangle AE is the sum of the rectangles AF and\\{nb}CE");
        $s{AF} =
          Polygon->new( $pn, 4, $p{A}->coords, $p{D}->coords, $p{F}->coords,
                        $p{C}->coords, -1 );
        $s{AF}->fill($sky_blue);
        $s{CE} =
          Polygon->new( $pn, 4, $p{C}->coords, $p{F}->coords, $p{E}->coords,
                        $p{B}->coords, -1 );
        $s{CE}->fill($lime_green);

        $t3->allgrey;
        $t3->math("\\{square}AE = \\{square}AF + \\{square}CE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since AD is equal in length to AB, the rectangle "
                      . "AE is equal to the square contained by line AB" );

        $s{AB}->fill($pale_pink);
        $t3->allgrey;
        $t3->black(0);
        $t3->math(   "\\{square}AE = AB\\{dot}AD,   "
                   . "\\{therefore} \\{square}AE = AB\\{dot}AB" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{AB}->fill();
        $s{CE}->fill();
        $t3->allgrey;
        $t3->black(0);
        $t1->explain(   "Similarly, the rectangle AF is equal to "
                      . "the rectangle contained by lines AB and AC" );
        $t3->math(   "\\{square}AF = AD\\{dot}AC,   "
                   . "\\{therefore} \\{square}AF = AB\\{dot}AC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $s{CE}->fill($lime_green);
        $s{AF}->fill();
        $t3->black(0);
        $t1->explain(   "Since AB equals CF (I.34), CE is equal to "
                      . "the rectangle contained by lines AB and CB" );
        $t3->math(   "\\{square}CE = CF\\{dot}CB,   "
                   . "\\{therefore} \\{square}CE = AB\\{dot}CB" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $s{CE}->fill($lime_green);
        $s{AF}->fill($sky_blue);
        $t1->explain(
              "Thus the square of AB is equal to the rectangle formed by AB,AC "
                . "and the rectangle formed by AB,CB" );
        $t3->down;
        $t3->allgrey;
        $t3->black( [ 1 .. 4 ] );
        $t3->math("AB\\{dot}AB = AB\\{dot}AC + AB\\{dot}CB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
    };

    return $steps;

}

