#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "In right-angled triangles the square on the side opposite "
  . "the right angle equals the sum of the squares on the sides "
  . "containing the right angle.";

my $pn = PropositionCanvas->new( -number => 47, -title => $title );
$pn->copyright;

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 470, 200 );
my $t3 = $pn->text_box( 470, 200 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,47);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;


# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my ( %l, %p, %c, %a, %t, %s );
    my @objs;
    my $top = 325;
    my $bot = 425;
    my @A   = ( 220, $top );
    my @B   = ( 145, $bot );

    my $s = -1. * ( $B[0] - $A[0] ) / ( $bot - $top );
    my $b = $A[1] - $s * $A[0];
    my @C = ( ( 1.0 / $s ) * ( $bot - $b ), $bot );
    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words...");
        $t1->explain("Given a right angle triangle ABC");
        $t{ABC} = Triangle->new( $pn, @A, @B, @C, 1, -points => [qw(A top B bottomleft C bottomright)] );
        $t{ABC}->set_angles( " ", undef, undef );
    };

    push @steps, sub {
        $t1->explain("where squares have been construct squares on all sides\\{nb}(I.46)");
        local $Shape::DefaultSpeed = 10;
        $s{B} = Square->new( $pn, @B, @A );
        $s{B}->normal;
        $s{A} = Square->new( $pn, @A, @C );
        $s{A}->normal;
        $s{C} = Square->new( $pn, @C, @B );
        $s{C}->normal;
        $s{B}->set_points( "F", "left",   undef, undef, undef, undef, "G", "top" );
        $s{C}->set_points( "E", "bottom", undef, undef, undef, undef, "D", "bottom" );
        $s{A}->set_points( "H", "top",    undef, undef, undef, undef, "K", "right" );
        $t3->math("ABFG is a square");
        $t3->math("ACKH is a square");
        $t3->math("BCED is a square");
        $t2->y($t3->y);
        $t2->down;
        $t3->allblue;
    };

    push @steps, sub {
        $t1->explain( "Then the sum of the squares of lines AB and AC equals " . "the square of BC" );
        $t2->math("\\{square}AB + \\{square}AC = \\{square}BC");
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof:");
        $t2->erase;
        $t3->erase;
        $t3->math("ABFG is a square");
        $t3->math("ACKH is a square");
        $t3->math("BCED is a square");
        $t2->y($t3->y);
        $t3->allblue;
        $t2->down;
        $s{A}->grey;
        $s{B}->grey;
        $s{C}->grey;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "By construction, angle GAB is a right angle, as is BAC, "
                      . "therefore lines GA and AC form a single line GC\\{nb}(I.14)" );
        $t3->allgrey;
        $t3->blue(0);
        $s{B}->p(4)->normal;
        $s{B}->set_angles(undef,undef," ",undef,0,0,30);
        $l{GC} = Line->new( $pn, $s{B}->p(4)->coords, @C, -1 );
        $l{GC}->notice;
        $t2->allgrey;
        $t2->math("GA,AC = GC");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Similarly for line BH\\{nb}(I.14)");
        $l{GC}->grey;
        $s{B}->a(3)->remove;
        $s{B}->p(4)->grey;
        $s{A}->p(1)->normal;
        $s{A}->set_angles(undef," ",undef,undef,0,30);
        $l{BH} = Line->new( $pn, $s{A}->p(1)->coords, @B, -1 );
        $l{BH}->notice;
        $t3->allgrey;
        $t3->blue(1);
        $t2->allgrey;
        $t2->math("BA,AH = BH");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{BH}->grey;
        $s{A}->p(3)->remove;
        $s{A}->a(2)->remove;
        $s{A}->p(1)->grey;
        $t1->explain( "Angles FBA and CBD are both right angles" );
        $t1->explain( "Adding angle ABC to both demonstrates that angles " . "FBC and ABD are also equal" );

        $s{B}->p(1)->normal;
        $s{B}->l(1)->normal;
        $s{C}->p(4)->normal;
        $s{C}->l(3)->normal;

        $a{FBC} = Angle->new( $pn, $t{ABC}->l(2), $s{B}->l(1) )->label( "\\{gamma}", 15 );
        $a{ABD} = Angle->new( $pn, $s{C}->l(3), $t{ABC}->l(1) )->label( "\\{gamma}", 25 );

        $t3->allgrey;
        $t3->blue([0,2]);
        $t2->math("\\{angle}FBC = \\{right} + \\{angle}ABC = \\{angle}ABD");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw a line from A, parallel to BD");
        $l{ALx} = $s{C}->l(3)->parallel( $t{ABC}->p(1) );
        $p{L} = Point->new( $pn, $l{ALx}->intersect( $s{C}->l(4) ) )->label( "L", "bottom" );
        $l{AL} = Line->new( $pn, @A, $p{L}->coords)->dash;
        $l{ALx}->remove;
        $t2->allgrey;
        $t3->allgrey;
        $t2->math("AL \\{parallel} BD");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Draw lines AD and FC, and consider triangles FBC and ABD" );
        $l{FC} = Line->new( $pn, $s{B}->p(1)->coords, @C );
        $l{AD} = Line->new( $pn, @A, $s{C}->p(4)->coords );
        $s{ABD} = Triangle->assemble( $pn, -lines => [ $t{ABC}->l(1), $s{C}->l(3),   $l{AD} ] );
        $s{FBC} = Triangle->assemble( $pn, -lines => [ $s{B}->l(1),   $t{ABC}->l(2), $l{FC} ] );
        $t{ABC}->l(1)->grey;
        $t{ABC}->l(2)->grey;
        $t{ABC}->l(3)->grey;
        $t{ABC}->a(1)->grey;
        $s{ABD}->normal;
        $s{FBC}->normal;
        $l{AL}->grey;
        $t2->allgrey;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "The two triangles are equal, FB equals AB, BC equals " . "BD, with a common angle \\{gamma}\\{nb}(I.4)" );
        $s{ABD}->fill($sky_blue);
        $s{FBC}->fill($sky_blue);
        $t3->blue([0,2]);
        $t2->black(-2);
        $t2->math("\\{triangle}FBC = \\{triangle}ABD");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $s{ABD}->grey;
        $a{ABD}->remove;
        $a{FBC}->remove;
        $t1->explain(   "The square AB and the triangle FBC share the same base, and are "
                      . "enclosed by the same parallel lines GC,FB "
                      . "thus FBC "
                      . "is one half ABFG\\{nb}(I.41)" );
        $l{FBX} = $s{B}->l(1)->clone->extend(50);
        $l{FBX}->prepend(350);
        $l{FBX}->dash;
        $l{CAX} = $t{ABC}->l(3)->clone->prepend(50);
        $l{CAX}->extend(200);
        $l{CAX}->dash;
        $s{B}->normal;
        $s{B}->fill($blue);
        $s{FBC}->fillover( $s{B}, $sky_blue );
        $t3->allgrey;
        $t3->blue(0);
        $t2->allgrey;
        $t2->math("\\{triangle}FBC = \\{half} \\{square}AB");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $s{B}->grey;
        $s{FBC}->grey;
        $l{FBX}->remove;
        $l{CAX}->remove;
        $t1->explain( "The triangle ABD equals half the parallelogram " . "BDL\\{nb}(I.41)" );
        
        $s{ABD}->normal;
        $s{BDL} = Polygon->new( $pn, 4, @B, $s{C}->p(4)->coords, $p{L}->coords, $l{AL}->intersect( $s{C}->l(2) ) );
        $s{BDL}->fill($blue);
        $s{ABD}->fillover( $s{ABD}, $sky_blue );

        $l{ALx} = $l{AL}->clone->extend(150)->dash;
        $l{ALx}->prepend(150);
        $l{BCx} = $s{BDL}->l(1)->clone->extend(150)->dash;
        $l{BCx}->prepend(150);

        $t3->allgrey;
        $t2->allgrey;
        $t2->black(3);
        $t2->math("\\{triangle}ABD = \\{half} \\{parallelogram}BDL");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore, the square of AB equals the polygon BDL");
        $l{ALx}->remove;
        $l{BCx}->remove;
        $s{ABD}->grey;
        $s{B}->fill($blue);
        $s{BDL}->fill($blue);
        $s{B}->normal;
        $l{FC}->remove;
        $l{AD}->remove;
        $t2->allgrey;
        $t3->allgrey;
        $t2->black([-1,-2,-3]);
        $t2->math("\\{square}AB = \\{parallelogram}BDL");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Applying the same logic as before, triangles " . "BCK and AEC are equal\\{nb}(I.4)" );
        $l{AE} = Line->new( $pn, @A, $s{C}->p(1)->coords );
        $l{BK} = Line->new( $pn, @B, $s{A}->p(4)->coords );
        $s{BCK} = Triangle->assemble( $pn, -lines => [ $t{ABC}->l(2), $s{A}->l(3), $l{BK} ] );
        $s{BCK}->normal;
        $s{ECA} = Triangle->assemble( $pn, -lines => [ $s{C}->l(1), $t{ABC}->l(3), $l{AE} ] );
        $s{ECA}->normal;
        $s{BCK}->set_angles( undef, "\\{sigma}", undef, 0, 15, 0 );
        $s{ECA}->set_angles( undef, "\\{sigma}", undef, 0, 25, 0 );
        $s{BCK}->fill($lime_green);
        $s{ECA}->fill($lime_green);
        $s{A}->p(1)->normal;
        $s{A}->p(2)->normal;
        $s{A}->p(3)->normal;
        $s{A}->p(4)->normal;
        $s{C}->p(1)->normal;
        $s{C}->p(2)->normal;
        $s{C}->p(3)->normal;
        $s{C}->p(4)->normal;



        $t2->allgrey;
        $t3->blue([1,2]);
        $t2->math("\\{angle}BCK = \\{angle}ACE");
        $t2->math("\\{triangle}ECA = \\{triangle}BCK");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Triangle BCK is half the square AC");
        $s{ECA}->grey;
        $s{A}->normal;
        $s{A}->fill($green);
        $s{BCK}->fillover( $s{A}, $lime_green);
        $s{1} = $t{ABC}->l(1)->clone->prepend(300)->extend(100)->dash;
        $s{2} = $s{A}->l(3)->clone->prepend(300)->extend(100)->dash;
        $t2->allgrey;
        $t3->allgrey;
        $t3->blue(1);
        $t2->math("\\{triangle}BCK = \\{half} \\{square}AC");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $s{1}->remove;
        $s{2}->remove;
        $t1->explain( "Triangle ECA is half the parallelogram " . "CEL\\{nb}(I.41)" );
        $s{BCK}->grey;
        $s{ECA}->normal;
        $s{A}->grey;
        $s{ECA}->normal;

        $s{1} = $s{C}->l(1)->clone->prepend(300)->extend(100)->dash;
        $s{2} = $l{AL}->clone->prepend(100)->extend(100)->dash;

        $s{CEL} =
          Polygon->new( $pn, 4, $p{L}->coords, $s{C}->p(1)->coords, $s{C}->p(2)->coords, $l{AL}->intersect( $s{C}->l(2) ) );
        $s{CEL}->fill($green);
        $s{ECA}->fillover( $s{CEL}, $lime_green );


        $t2->allgrey;
        $t3->allgrey;
        $t3->blue(2);
        $t2->black(3);
        $t2->math("\\{triangle}ECA = \\{half} \\{parallelogram}CEL");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Therefore the square of AC equals the " . "parallelogram\\{nb}CEL" );
        $s{1}->remove;
        $s{2}->remove;
        $l{AE}->remove;
        $l{BK}->remove;
        $s{ECA}->fill;
        $s{ECA}->remove_angles;
        $s{BCK}->remove_angles;
        $s{A}->normal;
        $s{A}->fill($green);
        $s{CEL}->fill($green);
        $t2->allgrey;
        $t3->allgrey;
        $t2->black([-1,-2,-3]);
        $t2->math("\\{square}AC = \\{parallelogram}CEL");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The square of line BC equals the sum of BDL and CEL");
        $t2->allgrey;
        $t3->allgrey;
        $t2->math("\\{square}BC = \\{parallelogram}BDL + \\{parallelogram}CEL");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "The sum of the squares of lines AB and AC equals " . "the square of BC" );
        $t2->allgrey;
        $t2->black([7,12,-1]);
        $t2->math("\\{square}BC = \\{square}AB + \\{square}AC");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t3->allblue;
        $t2->allgrey;
        $t2->black(-1);
    };

    return \@steps;
}
