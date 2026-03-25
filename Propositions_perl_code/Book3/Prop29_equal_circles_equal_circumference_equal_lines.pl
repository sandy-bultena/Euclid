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
my $title = "In equal circles equal circumferences are "
  . "subtended by equal straight lines.";

$pn->title( 29, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 200, 480 );
my $t2 = $pn->text_box( 400, 500 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 29 );
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

    my @c1 = ( 180, 280 );
    my $r1 = 140;
    my @c2 = ( 500, 280 );
    my $r2 = 140;
    my $tC = $pn->text_box( $c1[0] - 10, $c1[1] - $r1 + 30 );
    my $tF = $pn->text_box( $c2[0] - 10, $c2[1] - $r2 + 30 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("In other words");
        $t4->explain("Given two equal circles (as shown)");
        $t4->explain(
            "If the circumference BGC equals EHF, then line BC equals line EF");

        $c{C2t} = Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] )->grey;
        $c{C1t} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $tC->math("A");
        $tF->math("D");
        $p{B} = $c{C1t}->point( 180 + 40 )->label( "B ", "bottom" );
        $p{C} = $c{C1t}->point(-40)->label( " C", "bottom" );
        $p{E} = $c{C2t}->point( 180 + 40 )->label( "E ", "bottom" );
        $p{F} = $c{C2t}->point(-40)->label( " F", "bottom" );
        $l{BC} = Line->join( $p{B}, $p{C} );
        $l{EF} = Line->join( $p{E}, $p{F} );
        $c{C2t}->remove;
        $c{C1t}->remove;
        $c{C1t} =
          Arc->new( $pn, $r1, $p{B}->coords, $p{C}->coords )
          ->label( "G", "bottom" );
        $c{C2t} =
          Arc->new( $pn, $r2, $p{E}->coords, $p{F}->coords )
          ->label( "H", "bottom" );
        $c{C1b} = Arc->newbig( $pn, $r1, $p{C}->coords, $p{B}->coords )->grey();
        $c{C2b} = Arc->newbig( $pn, $r2, $p{F}->coords, $p{E}->coords )->grey();
        $t3->math("\\{circle}A = \\{circle}D");
        $t3->math("\\{arc}BGC = \\{arc}EHF");
        $t3->allblue;
        $t3->math("\\{then} BC = EF");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof");
        $t3->erase;
        $t3->math("\\{circle}A = \\{circle}D");
        $t3->math("\\{arc}BGC = \\{arc}EHF");
        $t3->allblue;
    };

    push @$steps, sub {
        $t4->explain(   "Take the centre (K,L) of the circles A and D "
                      . "and and draw the radii KB, KC, LE and LF" );
        $p{K} = Point->new( $pn, @c1 )->label( "K", "top" );
        $p{L} = Point->new( $pn, @c2 )->label( "L", "top" );
        $l{KC} = Line->join( $p{K}, $p{C} );
        $l{KB} = Line->join( $p{K}, $p{B} );
        $l{LF} = Line->join( $p{L}, $p{F} );
        $l{LE} = Line->join( $p{L}, $p{E} );
    };

    push @$steps, sub {
        $t4->explain( "Since the circumferences BGC and EHF are equal, "
                  . "then the angles from the centre are also equal (III.27)" );
        $a{BKC} = Angle->new( $pn, $l{KB}, $l{KC} )->label("\\{alpha}");
        $a{ELF} = Angle->new( $pn, $l{LE}, $l{LF} )->label("\\{alpha}");
        $t3->allgrey;
        $t3->blue(1);
        $t3->math("\\{angle}BKC = \\{angle}ELF");
        $l{BC}->grey;
        $l{EF}->grey;
    };

    push @$steps, sub {
        $t4->explain(   "Since KB, KC, LE, LF are all radii of equal circles, "
                      . "they are all equal" );
        $t3->allgrey;
        $t3->blue(0);
        $t3->math("KB = KC = LE = LF");
    };

    push @$steps, sub {
        $t4->explain(
                "Since each triangle has two lines equal to "
              . "two lines respectively, "
              . "with an equal angle between (side-angle-side), "
              . "then the triangles are equal in all respects\\{nb}(I.4)"
        );
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $s{BKC} = Triangle->join( $p{B}, $p{K}, $p{C} )->fill($sky_blue);
        $s{LEF} = Triangle->join( $p{L}, $p{E}, $p{F} )->fill($sky_blue);
        $t3->math("\\{triangle}BCK \\{equivalent} \\{triangle}EFL");
    };

    push @$steps, sub {
        $t4->down;
        $t4->explain("Therefore the base BC equals EF");
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("BC = EF");
    };

    push @$steps, sub {
        $s{BKC}->grey;
        $s{LEF}->grey;
        $l{BC}->normal;
        $l{EF}->normal;
        $l{KB}->grey;
        $l{KC}->grey;
        $l{LE}->grey;
        $l{LF}->grey;
        $a{BKC}->grey;
        $a{ELF}->grey;
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->black(-1);
    };

    return $steps;

}

