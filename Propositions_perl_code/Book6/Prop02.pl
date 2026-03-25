#!/usr/bin/perl 
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If a straight line be drawn parallel to one of the sides of a triangle, "
  . "it will cut the sides of the triangle proportionally; and, if the sides of the triangle "
  . "be cut proportionally, the line joining the points of section will be parallel to "
  . "the remaining side of the triangle.";

$pn->title( 2, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 480 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 2 );
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
    my ( %p, %c, %s, %t, %l );
    my $yh      = 200;
    my $yb      = 400;
    my $dx1     = 100;
    my $dx2     = 200;
    my $sl      = $dx1;
    my @B       = ( 150, $yb );
    my @A       = ( $B[0] + $sl, $yh );
    my @C       = ( $A[0] + $dx2, $yb );
    my @D       = ( $B[0] + 0.4 * $dx1, $yb + 0.4 * ( $yh - $yb ) );
    my @E       = ( $C[0] - 0.4 * $dx2, $yb + 0.4 * ( $yh - $yb ) );
    my $colour1 = $sky_blue;
    my $colour2 = $lime_green;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "If DE is parallel to BC, then the ratio of BD to DA is "
                      . "equal to the ratio of CE to EA" );
        $t1->explain(
                    "Conversly, if the ratio of BD to DA is equal to the ratio "
                      . "of CE to EA, then DE is parallel to BC" );

        $t3->math("if DE\\{parallel}BC \\{then} BD:DA=CE:EA");
        $t3->math("if BD:DA=CE:EA \\{then} DE\\{parallel}BC");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "left" );

        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} );

        $l{DE} = Line->join( $p{D}, $p{E} );

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {

        # $t1->erase();
        $t1->title("Proof (part 1)");
        $t3->erase();
        $t3->math("BC \\{parallel} DE")->blue;
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw the lines BE and CD");
        $l{BE} = Line->join( $p{B}, $p{E} );
        $l{CD} = Line->join( $p{C}, $p{D} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "The triangles BDE and CDE are equal, because they have "
                      . "the same base DE, and the same parallels DE and BC "
                      . "(i.e. are the same height) (I.38)" );
        $p{X} = Point->new( $pn, $l{CD}->intersect( $l{BE} ) );
        $t{BXD} = Triangle->join( $p{D}, $p{X}, $p{B} )->fill($sky_blue);
        $t{EXC} = Triangle->join( $p{E}, $p{X}, $p{C} );
        $t{DEX} = Triangle->join( $p{D}, $p{X}, $p{E} )->fill($sky_blue);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{BXD}->fill();
        $t{EXC}->fill($lime_green);
        $t{DEX}->fill($lime_green);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{BXD}->fill($sky_blue);
        $t{EXC}->fill($lime_green);
        $t{DEX}->fill($teal);
        $t3->math("\\{triangle}BDE = \\{triangle}CDE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since BDE and CDE are equal, they have the "
                      . "same ratio to the triangle ADE (V.7)" );
        $t{ADE} = Triangle->join( $p{A}, $p{D}, $p{E} )->fill($pale_pink);
        $t3->math(
             "\\{triangle}BDE:\\{triangle}ADE = \\{triangle}CDE:\\{triangle}ADE"
        );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "The ratio of the triangles BDE to ADE is equal to the ratio "
                    . "of the bases BD and DA (VI.1)" );
        $t{BXD}->fill($sky_blue);
        $t{EXC}->fill();
        $t{DEX}->fill($sky_blue);
        $t3->allgrey;
        $t3->math("BD:DA = \\{triangle}BDE:\\{triangle}ADE");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Similarly, the ratio of the triangles CDE to ADE "
                      . "is equal to the ratio "
                      . "of the bases CE and EA (VI.1)" );
        $t{BXD}->fill();
        $t{EXC}->fill($lime_green);
        $t{DEX}->fill($lime_green);
        $t3->allgrey;
        $t3->math("CE:EA = \\{triangle}CDE:\\{triangle}ADE");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since equality of ratios are transitive, BD to DA "
                      . "is equal to CE to EA" );
        $t3->black( [ -1, -2, -3 ] );
        $t3->math(   "BD:DA = \\{triangle}BDE:\\{triangle}ADE "
                   . "= \\{triangle}CDE:\\{triangle}ADE = CE:EA" );
        $t3->down;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
        $t3->blue(0);
        $t3->math("BD:DA = CE:EA");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain( "If DE is parallel to BC, then the ratio of BD to DA is "
                      . "equal to the ratio of CE to EA" );
        $t1->explain(
                    "Conversly, if the ratio of BD to DA is equal to the ratio "
                      . "of CE to EA, then DE is parallel to BC" );
        $t1->title("Proof (part 2)");
        $t3->erase();
        $t{BXD}->fill();
        $t{EXC}->fill();
        $t{DEX}->fill();
        $t3->math("BD:DA = CE:EA")->blue;
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The ratio "
                      . "of the bases BD and DA is equal to the ratio of the "
                      . "triangles BDE to ADE (VI.1)" );
        $t{BXD}->fill($sky_blue);
        $t{EXC}->fill();
        $t{DEX}->fill($sky_blue);
        $t3->math("BD:DA = \\{triangle}BDE:\\{triangle}ADE");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Similarly, the ratio  "
                      . "of the bases CE and EA is equal to the ratio of the "
                      . "triangles CDE to ADE (VI.1)" );
        $t{BXD}->fill();
        $t{EXC}->fill($lime_green);
        $t{DEX}->fill($lime_green);
        $t3->math("CE:EA = \\{triangle}CDE:\\{triangle}ADE");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Since each of the triangles BDE and CDE have the "
              . "same ratio to ADE, they are equal (V.9)"
        );
        $t{BXD}->fill($sky_blue);
        $t{EXC}->fill($lime_green);
        $t{DEX}->fill($teal);
        $t3->math("\\{triangle}BDE = \\{triangle}CDE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "BDE and CDE are equal, and they are on the same base, "
                      . "therefore they are on the same parallels (I.39)" );
        $t3->down;
        $t3->math("DE \\{parallel} BC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->blue(0);
        $t3->black(1);
    };

    return $steps;

}

