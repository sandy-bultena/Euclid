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
my $title = "In any parallelogram the complements of the parallelograms "
  . "about the diameter equal one another.";

my $pn = PropositionCanvas->new( -number => 43, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 500, 175 );
my $t3 = $pn->text_box( 150, 500 );
$pn->copyright;

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc( $pn, 43 );
push @$steps, Proposition::reset();
push @$steps, @{ explanation($pn) };
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my ( %l, %p, %c, %a, %t, %s );
    my @objs;
    my $top = 200;
    my $bot = 400;
    my @A   = ( 150, $top );
    my @B   = ( 125, $bot );
    my @C   = ( $B[0] + 300, $bot );
    my @G   = ( 100, $bot + 250 );

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a parallelogram ABCD");
        $s{ABCD} = Parallelogram->new( $pn, @A, @B, @C, 1,
                               -points => [qw(A top B bottom C bottom D top)] );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("With a diameter AC");
        $l{AC} = Line->new( $pn, @A, @C );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
               "And, from an arbitrary point E on line AB, draw a line parallel"
                 . " to AD intersecting the diagonal at point K" );
        $p{E} = Point->new( $pn, $s{ABCD}->l(1)->point(75) )->label(qw(E left));
        $l{EF} = $s{ABCD}->l(4)->parallel( $p{E} );

        $p{F} =
          Point->new( $pn, $l{EF}->intersect( $s{ABCD}->l(3) ) )
          ->label( "F", "right" );
        $p{K} =
          Point->new( $pn, $l{EF}->intersect( $l{AC} ) )
          ->label( "K", "topright" );

        $l{EF}->prepend(150);
        $t2->down;
        $t2->down;
        $t2->math("EF \\{parallel} BC");
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
                     "And finally, draw a line parallel to AB through point K, "
                       . "intersecting the parallelogram at points G and H" );
        $l{GH} = $s{ABCD}->l(1)->parallel( $p{K} );

        $p{G} =
          Point->new( $pn, $l{GH}->intersect( $s{ABCD}->l(2) ) )
          ->label( "G", "bottom" );
        $p{H} =
          Point->new( $pn, $l{GH}->intersect( $s{ABCD}->l(4) ) )
          ->label( "H", "top" );

        $l{GH}->extend(150);
        $t2->math("GH \\{parallel} CD");
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{EF}->grey;
        $l{GH}->grey;
        $t1->explain(   "Then the parallelograms EBGK and HKFD "
                      . "(complements of ABCD) and are equal" );
        $s{EBGK} = Polygon->new( $pn, 4, $p{E}->coords, $s{ABCD}->p(2)->coords,
                                 $p{G}->coords, $p{K}->coords );
        $s{EBGK}->fill($blue);
        $s{HKFD} =
          Polygon->new( $pn, 4, $p{H}->coords, $p{K}->coords, $p{F}->coords,
                        $s{ABCD}->p(4)->coords );
        $s{HKFD}->fill( Colour->add( $lime_green, $lime_green ) );
        $t2->math("EBGK = HKFD");
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof:");
        $t2->erase;
        $t2->down;
        $t2->down;
        $t2->math("EF \\{parallel} BC");
        $t2->math("GH \\{parallel} CD");
        $t2->allblue;

    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Since AC is the diameter of the parallelogram ABCD, "
                      . "triangles ABC and ACD are equal\\{nb}(I.34)" );
        $s{EBGK}->grey;
        $s{HKFD}->grey;
        $s{EBGK}->fill;
        $s{HKFD}->fill;
        $t{ABC} = Triangle->new( $pn, @A, @B, @C );
        $t{ABC}->fill($sky_blue);
        $t{ACD} = Triangle->new( $pn, @A, @C, $s{ABCD}->p(4)->coords );
        $t{ACD}->fill($lime_green);
        $t3->math("\\{triangle}ABC = \\{triangle}ACD");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "By the same reasoning, triangles AEK and AHK are equal, "
                      . "as well as KGC and KCF\\{nb}(I.34)" );
        $t{ABC}->fill;
        $t{ACD}->fill;

        $t{AEK} = Triangle->new( $pn, @A, $p{E}->coords, $p{K}->coords );
        $t{AEK}->fill( $sky_blue );
        $t{AKH} = Triangle->new( $pn, @A, $p{K}->coords, $p{H}->coords );
        $t{AKH}->fill( $lime_green );

        $t{KGC} = Triangle->new( $pn, $p{K}->coords, $p{G}->coords, @C );
        $t{KGC}->fill( Colour->add( $blue, $sky_blue ) );
        $t{KCF} = Triangle->new( $pn, $p{K}->coords, @C, $p{F}->coords );
        $t{KCF}->fill( Colour->add( $green, $lime_green ) );

        $t3->allgrey;
        $t3->math(   "\\{triangle}AEK = \\{triangle}AKH,  "
                   . "\\{triangle}KGC = \\{triangle}KCF" );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Triangle ABC is the sum of AED, EBGK and KGC");
        $t{AKH}->fill;
        $t{KCF}->fill;
        $s{EBGK}->fill($blue);
        $t3->allgrey;
        $t3->math("\\{triangle}ABC = \\{triangle}AEK + EBGK + \\{triangle}KGC");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Triangle ADC is the sum of AKH, HKFD and KCF");
        $t{AEK}->fill;
        $t{KGC}->fill;
        $s{EBGK}->fill;
        $t3->allgrey;
        $t3->math("\\{triangle}ADC = \\{triangle}AKH + HKFD + \\{triangle}KCF");

        $t{AKH}->fill( $lime_green );
        $s{HKFD}->fill( $green );
        $t{KCF}->fill( Colour->add( $green, $lime_green ) );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Again, since ABC is equal to ABD, when the equal "
             . "triangles are subtracted, we are left with the two complements "
             . "EBGK and HKFD equal to each other" );
        $t{AKH}->fill;
        $s{HKFD}->fill;
        $t{KCF}->fill;
        $t{ABC}->fill($sky_blue);
        $t{ACD}->fill($lime_green);
        $t3->down;
        $t3->allblack;
        $t3->grey(1);
        $t3->math(   "\\{triangle}AKH + HKFD + \\{triangle}KCF = "
                   . "\\{triangle}AEK + EBGK + \\{triangle}KGC" );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t{AKH}->fillover( $t{ACD}, "white" );
        $t{AEK}->fillover( $t{ABC}, "white" );
        $t3->allgrey;
        $t3->black( [ -1, 1 ] );
        $t3->math(
               "       HKFD + \\{triangle}KCF =        EBGK + \\{triangle}KGC");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t{KGC}->fillover( $t{ABC}, "white" );
        $t{KCF}->fillover( $t{ACD}, "white" );
        $t3->allgrey;
        $t3->black( [ -1, 1 ] );
        $t3->math("       HKFD        =        EBGK ");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->black( [-1] );
    };

    return \@steps;
}

