#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 5;

# ============================================================================
# Definitions
# ============================================================================
my $title =
  "In a given circle to inscribe an equilateral and equiangular pentagon.";

$pn->title( 11, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 100, 540 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 11 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();
my ( %l, %p, %c, %s, %a );

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $r = 160;
    my @c = ( 200, 300 );
    my @a = ( $c[0] + $r + 60, $c[1] + $r );
    my @b = (
              $c[0] + $r + 60 + 2 * $r * cos( 72 / 180 * 3.14 ),
              $c[1] + $r - 2 * $r * sin( 72 / 180 * 3.14 )
    );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain(   "Construct a pentagon in a circle, where all lines and "
                      . "angles are equal" );

        $c{a} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );

        foreach my $i ( 1 .. 5 ) {
            $p{$i} = $c{a}->point( 90 - ( $i - 1 ) * 360 / 5 );
        }
        $l{1} = Line->join( $p{1}, $p{2}, undef, 1 );
        $l{2} = Line->join( $p{2}, $p{3}, undef, 1 );
        $l{3} = Line->join( $p{3}, $p{4}, undef, 1 );
        $l{4} = Line->join( $p{4}, $p{5}, undef, 1 );
        $l{5} = Line->join( $p{5}, $p{1}, undef, 1 );
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        foreach my $i ( 1 .. 5 ) {
            $p{$i}->remove;
            $l{$i}->remove;
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Draw an isosceles triangle FGH such that the angles "
                    . "at G and H are twice the angle at\\{nb}F\\{nb}(IV.10)" );
        $p{G} = Point->new( $pn, @a )->label( "G", "left" );
        $p{F} = Point->new( $pn, @b )->label( "F", "top" );
        $l{GF}  = Line->join( $p{F}, $p{G} );
        $s{FGH} = Triangle->golden( $l{GF} );
        $p{H}   = $s{FGH}->p(3)->label( "H", "right" );
        $s{FGH}->set_angles( "\\{alpha}", "2\\{alpha}", "2\\{alpha}" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Copy this triangle into the circle\\{nb}(IV.2)");
        $s{ACD} = $s{FGH}->copy_to_circle( $c{a} );
        $p{A}   = $s{ACD}->p(1)->label( "A", "top" );
        $p{C}   = $s{ACD}->p(2)->label( "C", "bottom" );
        $p{D}   = $s{ACD}->p(3)->label( "D", "bottom" );
        $t3->math("\\{angle}A = 2\\{angle}C = 2\\{angle}D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Bisect the angles at C and D with lines CE and DB\\{nb}(I.9)");
        $a{C} = Angle->new( $pn, $s{ACD}->l(2), $s{ACD}->l(1) );
        $a{D} = Angle->new( $pn, $s{ACD}->l(3), $s{ACD}->l(2) );
        $l{x} = $a{C}->clean_bisect()->prepend( 2.3 * $r );
        $l{y} = $a{D}->clean_bisect()->prepend( 2.3 * $r );
        my @p = $c{a}->intersect( $l{x} );
        $p{E} = Point->new( $pn, @p[ 0, 1 ] )->label( "E", "right" );
        @p    = $c{a}->intersect( $l{y} );
        $p{B} = Point->new( $pn, @p[ 2, 3 ] )->label( "B", "left" );
        $l{BD} = Line->join( $p{B}, $p{D} );
        $l{CE} = Line->join( $p{C}, $p{E} );
        $l{x}->remove;
        $l{y}->remove;
        $a{C}->remove;
        $a{D}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The pentagon ABCDE is equilateral and equiangular");
        $s{ABCDE} =
          Polygon->join( 5, $p{A}, $p{B}, $p{C}, $p{D}, $p{E} )->fill($sky_blue);
        $s{ACD}->grey;
        $l{BD}->grey;
        $l{CE}->grey;
        $p{A}->normal;
        $p{C}->normal;
        $p{D}->normal;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Because C and D are half of A, and they have been bisected, "
              . "the angles CAD, ADB, BDC, ECD, ACE are all equal\\{nb}(III.26)"
        );
        $l{BD}->normal;
        $l{CE}->normal;
        $s{ACD}->normal;
        $s{ABCDE}->grey;
        $a{CAD} =
          Angle->new( $pn, $s{ACD}->l(1), $s{ACD}->l(3) )
          ->label( "\\{alpha}", 20 );
        $a{ADB} =
          Angle->new( $pn, $s{ACD}->l(3), $l{BD} )->label( "\\{alpha}", 20 );
        $a{BDC} =
          Angle->new( $pn, $l{BD}, $s{ACD}->l(2) )->label( "\\{alpha}", 30 );
        $a{ECD} =
          Angle->new( $pn, $s{ACD}->l(2), $l{CE} )->label( "\\{alpha}", 30 );
        $a{ACE} =
          Angle->new( $pn, $l{CE}, $s{ACD}->l(1) )->label( "\\{alpha}", 20 );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Equal angles subtend equal circumferences so the arcs "
                      . "AB, BC, CD, DE, and EA are all equal" );
        $s{ACD}->l(1)->grey;
        $s{ACD}->l(2)->grey;
        $c{a}->grey;
        $l{CE}->grey;
        $a{CAD}->grey;
        $a{ACE}->grey;
        $a{ECD}->grey;
        $a{BDC}->grey;

        $a{AB} = Arc->join( $c{a}->radius, $p{A}, $p{B} );
        $a{AB}->fill($blue);
        $s{tmp} = Triangle->join( $p{A}, $p{B}, $p{D} )->fill($sky_blue);
        my $y = $t3->y;
        $t3->math("\\{arc}AB = ");
        $t3->y($y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{ACD}->l(3)->grey;
        $a{AB}->grey;
        $a{ADB}->grey;
        $a{AB}->fill;
        $s{tmp}->remove;

        $a{BC} = Arc->join( $c{a}->radius, $p{B}, $p{C} );
        $a{BC}->fill($blue);
        $s{tmp} = Triangle->join( $p{B}, $p{C}, $p{D} )->fill($sky_blue);
        $s{ACD}->l(2)->normal;
        $a{BDC}->normal;
        my $y = $t3->y;
        $t3->math("      \\{arc}BC = ");
        $t3->y($y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{ACD}->l(2)->grey;
        $l{BD}->grey;
        $a{BC}->grey;
        $a{BDC}->grey;
        $a{BC}->fill;
        $a{CD} = Arc->join( $c{a}->radius, $p{C}, $p{D} );
        $a{CD}->fill($blue);
        $s{tmp}->remove;
        $s{tmp} = Triangle->join( $p{A}, $p{C}, $p{D} )->fill($sky_blue);
        $s{ACD}->l(1)->normal;
        $s{ACD}->l(3)->normal;
        $a{CAD}->normal;

        my $y = $t3->y;
        $t3->math("            \\{arc}CD = ");
        $t3->y($y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{ACD}->l(1)->grey;
        $s{ACD}->l(3)->grey;
        $a{CD}->grey;
        $a{CD}->fill;
        $a{CAD}->grey;

        $a{DE} = Arc->join( $c{a}->radius, $p{D}, $p{E} );
        $a{DE}->fill($blue);
        $s{tmp}->remove;
        $s{tmp} = Triangle->join( $p{E}, $p{C}, $p{D} )->fill($sky_blue);
        $l{CE}->normal;
        $s{ACD}->l(2)->normal;
        $a{ECD}->normal;

        my $y = $t3->y;
        $t3->math("                  \\{arc}DE =");
        $t3->y($y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{ACD}->l(2)->grey;
        $a{DE}->grey;
        $a{DE}->fill;
        $a{ECD}->grey;

        $a{EA} = Arc->join( $c{a}->radius, $p{E}, $p{A} );
        $a{EA}->fill($blue);
        $s{tmp}->remove;
        $s{tmp} = Triangle->join( $p{E}, $p{C}, $p{A} )->fill($sky_blue);
        $s{ACD}->l(1)->normal;
        $a{ACE}->normal;

        my $y = $t3->y;
        $t3->math("                        \\{arc}EA");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "If the circumferences are equal, so are the lines "
                      . "subtending the circumferences\\{nb}(III.29)" );
        $t1->explain("Therefore the pentagon is equilateral");
        $t1->down;
        $a{EA}->fill;
        $s{tmp}->remove;
        $a{ACE}->grey;
        $l{CE}->grey;
        $s{ACD}->l(1)->grey;

        $s{ABCDE}->l(1)->normal;
        $a{AB}->normal;
        $s{ABCDE}->l(2)->green;
        $a{BC}->normal->green;
        $s{ABCDE}->l(3)->red;
        $a{CD}->normal->red;
        $s{ABCDE}->l(4)->normal;
        $a{DE}->normal;
        $s{ABCDE}->l(5)->green;
        $a{EA}->green;
        $t3->allgrey;
        $t3->black( [ -1, -2, -3, -4, -5 ] );
        $t3->math("AB = BC = CD = DE = EA");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{AB}->remove;
        $a{BC}->remove;
        $a{CD}->remove;
        $a{DE}->remove;
        $a{EA}->remove;
        $s{ABCDE}->normal->fill();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Because each circumference is equal, if the "
            . "arcs BC,CD are added to AB and DE respectively, it follows that "
            . "the circumference ABCD is equal to the circumference BCDE" );
        $t3->allgrey;
        $t3->black( [ 1 .. 5 ] );
        $l{a} = VirtualLine->new( $c{a}->centre, $p{A}->coords );
        $l{a}->extend(10);
        $l{d} = VirtualLine->new( $c{a}->centre, $p{D}->coords );
        $l{d}->extend(10);

        $c{b} =
          Arc->newbig( $pn, $c{a}->radius + 10, $l{a}->end, $l{d}->end )->red;

        $l{b} = VirtualLine->new( $c{a}->centre, $p{B}->coords );
        $l{b}->extend(20);
        $l{e} = VirtualLine->new( $c{a}->centre, $p{E}->coords );
        $l{e}->extend(20);
        $c{c} =
          Arc->newbig( $pn, $c{a}->radius + 20, $l{b}->end, $l{e}->end )->green;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Thus, since equal angles stand on equal circumferences "
                      . "the angles AED and BAE are equal\\{nb}(III.27)" );
        $s{ABCDE}->grey;
        $c{a}->normal;
        $l{EA} = Line->join( $p{E}, $p{A} )->normal;
        $l{DE} = Line->join( $p{D}, $p{E} )->normal;
        $l{AD} = Line->join( $p{A}, $p{D} )->red;
        $c{c}->grey;
        $c{bn} =
          Arc->newbig( $pn, $c{a}->radius, $p{A}->coords, $p{D}->coords );
        $c{bn}->fill($pink);
        $s{tmp} = Triangle->join( $p{A}, $p{E}, $p{D} )->fill($pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AD}->remove;
        $l{DE}->grey;
        $c{c}->green;
        $c{b}->grey;
        $c{bn}->fill;
        $c{bn}->remove;
        $s{tmp}->remove;
        $c{bn} =
          Arc->newbig( $pn, $c{a}->radius, $p{B}->coords, $p{E}->coords );
        $c{bn}->fill($green);
        $s{tmp} = Triangle->join( $p{A}, $p{E}, $p{B} )->fill($lime_green);
        $l{EA} = Line->join( $p{E}, $p{A} )->normal;
        $l{BE} = Line->join( $p{B}, $p{E} )->green;
        $l{AB} = Line->join( $p{A}, $p{B} )->normal;
        $t3->math("\\{angle}BAE = \\{angle}AED");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{bn}->fill;
        $c{bn}->remove;
        $s{tmp}->remove;
        $s{ABCDE}->normal;
        $c{a}->grey;
        $l{BE}->remove;
        $l{AD}->remove;
        $t1->explain( "Similarly, all the angles of the pentagon can be shown "
                      . "to be equal" );
        $t1->explain("Therefore, the pentagon is equiangular");
        $c{b}->remove;
        $c{c}->remove;
        $t3->math(   "\\{angle}BAE = \\{angle}AED = \\{angle}EDC = "
                   . "\\{angle}DCB = \\{angle}CBA" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus a regular pentagon has been drawn");
        $t3->allgrey;
        $t3->black( [ -1, -3 ] );

    };

    return $steps;

}

sub greyall {
    foreach my $o ( keys %l ) {
        $l{$o}->grey;
    }
    foreach my $o ( keys %a ) {
        $a{$o}->grey;
    }
    foreach my $o ( keys %s ) {
        $s{$o}->grey;
    }
    foreach my $o ( keys %p ) {

        #        $p{$o}->grey;
    }
}

