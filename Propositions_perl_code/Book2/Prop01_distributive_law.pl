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
"If there be two straight lines, and of of them be cut into any number of segments whatever, "
  . "the rectangle contained by the two straight lines is equal to the rectangles contained by "
  . "the uncut straight line and each of the segments.";

$pn->title( 1, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 820, 430 );
my $t3 = $pn->text_box( 200, 480 );
my $t5 = $pn->text_box( 200, 480 );

my $ppurple        = Colour->add( $purple,    $purple );
my $really_purple = Colour->add( $ppurple, $purple );

my $steps;
push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 1 );
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

    my @A  = ( 200, 200 );
    my @Ap = ( 350, 200 );
    my @B  = ( 200, 250 );
    my @C  = ( 550, 250 );
    my @D  = ( 375, 250 );
    my @E  = ( 500, 250 );

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Let A and BC be two straight lines");
        $t1->explain("Let BC be arbitrarily cut at points D and E ");
        $p{A} = Point->new( $pn, @A )->label(qw(A left));
        $l{A} = Line->new( $pn, @A, @Ap );
        $p{B} = Point->new( $pn, @B )->label(qw(B left));
        $p{C} = Point->new( $pn, @C )->label(qw(C right));
        $l{BC} = Line->new( $pn, @B, @C );
        $p{D} = Point->new( $pn, @D )->label(qw(D top ));
        $p{E} = Point->new( $pn, @E )->label(qw(E top));
        $t5->math("BC = BD + DE + CE");
        $t3->y( $t5->y );
        $t5->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Then the area of the rectangle formed by line A "
                      . "and BC is equal in area to the sum of the rectangles "
                      . "formed by line A and BD, line A and DE, "
                      . "and line A and EC" );
        $t5->math("A\\{dot}BC = A\\{dot}BD + A\\{dot}DE + A\\{dot}EC");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t5->erase;
        $t5->math("BC = BD + DE + CE");
        $t5->allblue;
        $t1->down;
        $t1->title("Proof:");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub{
        $t1->explain("Draw a line BF perpendicular to BC\\{nb}(I.11)");
        $l{BF} = $l{BC}->perpendicular( $p{B}, undef, 'negative' );
        my $len = $l{BF}->length();
        $l{BF}->extend( 200 - $len );
        $p{F} = Point->new( $pn, $l{BF}->end )->label(qw(F left));
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Define point G such that BG equals A\\{nb}(I.3)");
        ( $l{BG}, $p{G} ) = $l{A}->copy_to_line( $p{B}, $l{BF} );
        $p{G}->label(qw(G left));
        my $y = $t3->y;
        $t3->math("A = BG");
        $t3->y($y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw GH parallel to BC, and DK, EL, and CH "
                      . "parallel to BG\\{nb}(I.31)" );
        $l{GHt} = $l{BC}->parallel( $p{G} );
        $l{GHt}->prepend(400);
        $l{DKt} = $l{BG}->parallel( $p{D} );
        $l{ELt} = $l{BG}->parallel( $p{E} );
        $l{CHt} = $l{BG}->parallel( $p{C} );
        $p{K} =
          Point->new( $pn, $l{DKt}->intersect( $l{GHt} ) )->label(qw(K bottom));
        $p{L} =
          Point->new( $pn, $l{ELt}->intersect( $l{GHt} ) )->label(qw(L bottom));
        $p{H} =
          Point->new( $pn, $l{CHt}->intersect( $l{GHt} ) )->label(qw(H bottom));

        $l{GH} = Line->join( $p{G}, $p{H} );
        $l{GHt}->remove();
        $l{DK} = Line->join( $p{D}, $p{K} );
        $l{DKt}->remove();
        $l{EL} = Line->join( $p{E}, $p{L} );
        $l{ELt}->remove();
        $l{CH} = Line->join( $p{C}, $p{H} );
        $l{CHt}->remove();
        $t3->math("       = DK = EL = CH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The rectangle BH is the sum of the "
                      . "rectangles BK DL and\\{nb}EH" );
        $s{BK} =
          Polygon->new( $pn, 4, $p{B}->coords, $p{G}->coords, $p{K}->coords,
                        $p{D}->coords, -1 );
        $s{BK}->fill($sky_blue);
        $s{DL} =
          Polygon->new( $pn, 4, $p{D}->coords, $p{K}->coords, $p{L}->coords,
                        $p{E}->coords, -1 );
        $s{DL}->fill($blue);
        $s{EH} =
          Polygon->new( $pn, 4, $p{E}->coords, $p{L}->coords, $p{H}->coords,
                        $p{C}->coords, -1 );
        $s{EH}->fill(Colour->add($blue,$sky_blue));
        $s{BH} =
          Polygon->new( $pn, 4, $p{B}->coords, $p{G}->coords, $p{H}->coords,
                        $p{C}->coords, -1 );

        $t3->allgrey;
        $t3->math("\\{square}BH = \\{square}BK + \\{square}DL + \\{square}EH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since BG is equal in length to A, the rectangle "
                 . "BH is equal to the rectangle contained by lines A and BC" );
        $s{BH}->fillover( $s{BK}, $lime_green );
        $t3->allgrey;
        $t3->black(0);
        $t3->math(   "\\{square}BH = BG\\{dot}BC,     \\{therefore} "
                   . "\\{square}BH = A\\{dot}BC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Similarly, the rectangle BK is equal to the "
                      . "rectangle contained by lines A and BD" );
        $s{BH}->fill();
        $s{BK}->fill($sky_blue);
        $s{DL}->fill;
        $s{EH}->fill;
        $t3->allgrey;
        $t3->black( [ 0, 1 ] );
        $t3->math(   "\\{square}BK = BG\\{dot}BD,     "
                   . "\\{therefore} \\{square}BK = A\\{dot}BD" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since BG equals DK (I.34), DL is equal to the rectangle "
                      . "contained by lines A and DE" );
        $s{BK}->fill;
        $s{DL}->fill($blue);
        $s{EH}->fill;
        $t3->allgrey;
        $t3->black( [ 0, 1 ] );
        $t3->math(   "\\{square}DL = DK\\{dot}DE,     "
                   . "\\{therefore} \\{square}DL = A\\{dot}DE" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "And finally, EH is equal to the rectangle "
                      . "contained by lines A and EC" );
        $s{BK}->fill();
        $s{DL}->fill;
        $s{EH}->fill(Colour->add($sky_blue,$blue));
        $t3->allgrey;
        $t3->black( [ 0, 1 ] );
        $t3->math(   "\\{square}EH = EL\\{dot}EC,     "
                   . "\\{therefore} \\{square}EH = A\\{dot}EC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus the rectangle formed by A,BC is equal to the sum ".
        "of the rectangles formed by A,BD, A,DE and A,EC");
        $s{BK}->fill($sky_blue);
        $s{DL}->fill($blue);
        $t3->down;
        $t3->allgrey;
        $t3->black( [ 2 .. 6 ] );
        $t3->math("A\\{dot}BC = A\\{dot}BD + A\\{dot}DE + A\\{dot}EC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
    };

    return $steps;

}

