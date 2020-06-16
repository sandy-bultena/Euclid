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
    "If a number be that parts of a number that a number subracted "
  . "is of a number subtracted, the remainder will also be the same parts of the "
  . "remainder that the whole is of the whole.";

$pn->title( 8, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80,  260 );
my $t5 = $pn->text_box( 80,  300 );
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);
$t4->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 8 );
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
    my $ds  = 160;
    my $dx  = 20;
    my $dy  = 50;
    my $dy1 = $ds;
    my $y2  = $ds + $dy;
    my $dy3 = $ds + 2 * $dy;
    my $dy4 = $ds + 3 * $dy;
    my $dy5 = $ds + 4 * $dy;
    my $dy6 = $ds + 5 * $dy;
    my $A   = my $C = my $G = 0;
    my $B   = my $H = 12;
    my $K   = $H / 2;
    my $M   = my $L = $B / 3;
    my $N   = $K + $B / 3;
    my $E   = 2 * $B / 3;
    my $D   = 3 * $B / 2;
    my $F   = 2 * $D / 3;
    my $xl  = 80 - $G * $dx;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->title("In other words");
        $t1->explain(
"If b is the same fraction of a as d is to c, then the result of d subtracted from b "
              . "will also be the same fraction of the result of c subtracted from a"
        );
        $t2->math("b = (p/q)\\{dot}a");
        $t2->math("d = (p/q)\\{dot}c");
        $t2->math("\\{then} (b-d) = (p/q)\\{dot}(a-c)");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $t1->explain(
"Let the number AB be parts (fractions) of CD, and let AE be the same parts (fractions) of CF"
        );
        $p{A} = Point->new( $pn, $xl + ($A) * $dx, $dy3 )->label( "A", "top" );
        $p{B} = Point->new( $pn, $xl + ($B) * $dx, $dy3 )->label( "B", "top" );
        $p{C} = Point->new( $pn, $xl + ($C) * $dx, $dy1 )->label( "C", "top" );
        $p{D} = Point->new( $pn, $xl + ($D) * $dx, $dy1 )->label( "D", "top" );
        $p{E} = Point->new( $pn, $xl + ($E) * $dx, $dy3 )->label( "E", "top" );
        $p{F} = Point->new( $pn, $xl + ($F) * $dx, $dy1 )->label( "F", "top" );
        $l{AE} = Line->join( $p{A}, $p{E} );
        $l{EB} = Line->join( $p{E}, $p{B} );
        $l{CD} = Line->join( $p{C}, $p{D} );
        $l{CF} = Line->join( $p{C}, $p{F} );
        $l{AE} = Line->join( $p{A}, $p{E} );
        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{FD} = Line->join( $p{F}, $p{D} );
        $l{FD}->remove;
        $l{AB}->remove;

        $t4->down;
        $t4->down;
        $t4->math("AB = (p/q)CD");
        $t4->math("AE = (p/q)CF");

        $l{CD_3} = $l{CD}->parts( 3, undef, "bottom", $pale_pink );
        $l{CF_3} = $l{CF}->parts( 3, undef, "top",    $turquoise );
        $l{AB_2} = $l{AB}->parts( 2, undef, "bottom", $pale_pink );
        $l{AE_2} = $l{AE}->parts( 2, undef, "top",    $turquoise );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Make GH equal to AB");
        $l{GM} = Line->new( $pn, $xl,            $y2, $xl + $M * $dx, $y2 );
        $l{MK} = Line->new( $pn, $xl + $M * $dx, $y2, $xl + $K * $dx, $y2 );
        $l{KN} = Line->new( $pn, $xl + $K * $dx, $y2, $xl + $N * $dx, $y2 );
        $l{NH} = Line->new( $pn, $xl + $N * $dx, $y2, $xl + $H * $dx, $y2 );
        $p{G} = Point->new( $pn, $xl,            $y2 )->label( "G", "top" );
        $p{H} = Point->new( $pn, $xl + $H * $dx, $y2 )->label( "H", "top" );
        $l{GH} = Line->join( $p{G}, $p{H} );
        $l{GH}->remove;
        $t4->grey( [ 0 .. 20 ] );
        $t4->math("GH = AB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("AE is the same parts of CF that GH is of CD");
        $t4->grey( [ 0 .. 20 ] );
        $t4->black( [ -1, 1, 0 ] );
        $t4->math("GH = (p/q)CD");
        $l{GH}->parts( 2, undef, "bottom", $pale_pink );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "Divide GH and AE into the number of parts of CD, or ... ");
        $t1->explain(
                "... divide GH into sections where each section is equal to "
              . "one part of CD, and divide AE into sections where each section is equal to one part of CF"
        );

        #$t1->explain("Assuming p equals 2, divide GH by 2 equal parts, GK,KH ".
        #"and AE into 2 equal parts, AL,LE");
        $p{K} = Point->new( $pn, $xl + $K * $dx, $y2 )->label( "K", "top" );
        $p{L} = Point->new( $pn, $xl + $L * $dx, $dy3 )->label( "L", "top" );

        $t4->grey( [ 0 .. 20 ] );
        $t4->black( [ 1, -1 ] );
        $t4->math("GK = KH = (1/q)CD");
        $t4->math("AL = LE = (1/q)CF");
        foreach my $d ( @{ $l{AB_2} } ) { $d->remove; }
        $l{EB}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since AL is the same part of CF that GK is of CD, and "
                      . "CD is greater than CF, then GK is greater than AL" );
        $t4->grey( [ 0 .. 3 ] );
        $l{KN}->grey;
        $l{NH}->grey;
        $t4->math("GK > AL");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let GM equal to AL");
        $p{M} = Point->new( $pn, $xl + $M * $dx, $y2 )->label( "M", "top" );
        $t4->grey( [ 0 .. 20 ] );
        $t4->math("GM = AL = (1/q)CF");
        $l{gm} = Line->new( $pn, $xl + ($G) * $dx + 5,
                            $y2 - 7, $xl + ($M) * $dx - 5,
                            $y2 - 7 )->colour($turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Now GK is the same part of CD that GM is of CF, "
                      . "therefore MK is also the same part of FD (VII.7)" );
        $l{FD}->parts( 3, undef, "top", $purple );

        $l{MK}->parts( 1, undef, "top", $purple );

        $t4->grey( [ 0 .. 20 ] );
        $t4->black( [ 4, 7 ] );
        $t4->math("MK = GK - GM = (1/q)(CD - CF) = (1/q)FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since LE is the same part of CF that KH is of CD, and "
                      . "CD is greater than CF, then KH is greater than LE" );
        $t4->grey( [ 0 .. 3, 6 .. 8 ] );
        $t4->black(5);
        $l{KN}->normal;
        $l{NH}->normal;
        $l{GM}->grey;
        $l{MK}->grey;
        $t4->math("KH > LE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let KN equal to LE");
        $p{N} =
          Point->new( $pn, $xl + ( $K + $M ) * $dx, $y2 )->label( "N", "top" );
        $t4->grey( [ 0 .. 20 ] );
        $t4->math("KN = LE = (1/q)CF");
        $l{NH}->parts( 1, undef, "top", $purple );
        $l{kn} = Line->new( $pn, $xl + ($K) * $dx + 5,
                            $y2 - 7, $xl + ($N) * $dx - 5,
                            $y2 - 7 )->colour($turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Now KH is the same part of CD that KN is of CF, "
                      . "therefore NH is also the same part of FD (VII.7)" );
        $t4->grey( [ 0 .. 20 ] );
        $t4->black( [ 4, 5, 10 ] );
        $t4->math("NH = KH - KN = (1/q)(CD - CF) = (1/q)FD");
    };

    # -------------------------------------------------------------------------
    # continued
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->erase;
        $t1->title("In other words");
        $t1->explain(
                "If b is the same fraction of a as d is to c, "
              . "then the result of d subtracted from b "
              . "will also be the same fraction of the result of c subtracted from a"
        );
        $t1->down;
        $t1->title("Proof (cont.)");
        $t4->down;
        $t4->down;
        $t4->math("AB = (p/q)CD");
        $t4->math("AE = (p/q)CF");
        $t4->math("GH = AB = (p/q)CD");
        $t4->math("GK = KH = (1/q)CD");
        $t4->math("GM = KN = AL = LE = (1/q)CF");
        $t4->math("MK = NH = (1/q)FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
              "MK and NH are each equal to one part of FD, so the sum of them "
                . "is equal to the same number of parts of FD as GH is of CD" );
        $t4->grey( [ 0 .. 20 ] );
        $t4->black( [ -1, -3 ] );
        $t4->math("MK + NH + ... = (p/q)FD");
        $t4->math("GK + KH + ... = (p/q)CD");
        $l{KN}->grey;
        $l{MK}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                     "EB is the remainder of AB minus AL and LE, MK plus NH is "
                       . "the remainder of GH minus GM and KN" );
        $t4->grey( [ 0 .. 20 ] );
        $l{AE}->grey;
        $l{EB}->normal;
        $t4->math("AB - AL - LE = EB");
        $t4->math("GH - GM - KN = MK + NH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "But GM and KN equal AL and LE respectively, and GH is equal to AB,"
              . " so "
              . "the remainder MK,NH is equal to the remainder EB" );
        $t4->grey( [ 0 .. 20 ] );
        $t4->black( [ -1, -2, 2, 4 ] );
        $l{EB}->parts(2,undef,"top",$purple);

        $t4->math("MK + NH = EB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                     "Therefore, EB also equals the same number of parts of FD "
                       . "as AB is of CD and AE is of CF" );
        $t4->grey( [ 0 .. 20 ] );
        $t4->black( [ -1, 6 ] );
        $t4->math("EB = (p/q)FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->math("AB - AE = (p/q)(CD - CF)");
        $t4->grey( [ 0 .. 20 ] );
        $t4->blue( [ 0, 1, -1 ] );
        $l{GM}->grey;
        $l{MK}->grey;
        $l{KN}->grey;
        $l{NH}->grey;
        $p{G}->grey;
        $p{M}->grey;
        $p{K}->grey;
        $p{N}->grey;
        $p{H}->grey;
        $l{AE}->normal;

    };

    return $steps;

}
