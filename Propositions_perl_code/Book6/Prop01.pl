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
my $title = "Triangles and parallelograms which are under the same height "
  . "are to one another as their bases";

$pn->title( 1, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 480 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 1 );
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
    my $yh      = 150;
    my $yb      = 350;
    my $dx1     = 50;
    my $dx2     = 100;
    my $sl      = $dx1 / 2;
    my @B       = ( 200, $yb );
    my @C       = ( $B[0] + $dx1, $yb );
    my @D       = ( $C[0] + $dx2, $yb );
    my @E       = ( $B[0] + $sl, $yh );
    my @A       = ( $C[0] + $sl, $yh );
    my @F       = ( $D[0] + $sl, $yh );
    my $colour1 = Colour->new($sky_blue);
    my $colour2 = Colour->new($lime_green);

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "If we have two triangles ABC and ACD, or two "
            . "parallelograms EC and CF, with the same height, "
            . "then the ratio of BC to CD is the same as the ratios of the triangles, "
            . "and parallelograms respectively" );
        $t3->math(   "BC:CD = \\{triangle}ABC:\\{triangle}ACD "
                   . "= \\{square}EC:\\{square}CF" );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "bottom" );

        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($sky_blue);
        $t{ACD} = Triangle->join( $p{A}, $p{C}, $p{D} )->fill($lime_green);

        $l{EF} = Line->join( $p{E}, $p{F} );
        $l{BE} = Line->join( $p{B}, $p{E} );
        $l{FD} = Line->join( $p{F}, $p{D} );

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof - Triangles");
        $t3->erase();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "Extend the line BD to HL, such that HB is composed of any "
                      . "number of lines equal to BC, and that DL is composed "
                      . "of any number of lines equal to CD" );
        $t3->math("HG = GB = BC");
        $t3->math("CD = DK = KL");
        $p{H} =
          Point->new( $pn, $B[0] - 2 * $dx1, $yb )->label( "H", "bottom" );
        $p{G} = Point->new( $pn, $B[0] - $dx1, $yb )->label( "G", "bottom" );
        $p{K} = Point->new( $pn, $D[0] + $dx2, $yb )->label( "K", "bottom" );
        $p{L} =
          Point->new( $pn, $D[0] + 2 * $dx2, $yb )->label( "L", "bottom" );
        $l{HL} = Line->join( $p{H}, $p{L} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw the triangles AHG, AGB, and ADK and AKL");
        $t{AGB} = Triangle->join( $p{A}, $p{G}, $p{B} )->fill($blue);
        $t{AHG} =
          Triangle->join( $p{A}, $p{H}, $p{G} )
          ->fill( Colour->add( $blue, $sky_blue ) );
        $t{ADK} = Triangle->join( $p{A}, $p{D}, $p{K} )->fill($green);
        $t{AKL} =
          Triangle->join( $p{A}, $p{K}, $p{L} )
          ->fill( Colour->add( $green, $lime_green ) );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "Since the bases are equal, triangles ABC, AGB and AHG are equal, "
               . "and the triangles ACD, ADK and AKL are equal (I.38)" );
        $t3->math("\\{triangle}ABC = \\{triangle}AGB = \\{triangle}AHG");
        $t3->math("\\{triangle}ACD = \\{triangle}ADK = \\{triangle}AKL");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Therefore, the triangle AHC is the same "
                      . "multiple of ABC as the line HC is to BC" );
        $t3->grey( [ 1, 3 ] );
        $t3->math(   "\\{triangle}AHC = \\{triangle}ABC + \\{triangle}AGB "
                   . "+ \\{triangle}AHG = n\\{dot}\\{triangle}ABC" );
        $t3->math("  HC =   BC +   GB +   HG = n\\{dot}  BC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Similarly, the triangle ACL is the same multiple "
                      . "of ACD as the line CD is to CL" );
        $t3->black( [ 1 .. 20 ] );
        $t3->grey( [ 0, 2, 4, 5 ] );
        $t3->math(   "\\{triangle}ACL = \\{triangle}ACD + \\{triangle}ADK "
                   . "+ \\{triangle}AKL = m\\{dot}\\{triangle}ACD" );
        $t3->math("  CL =   CD +   DK +   KL = m\\{dot}  CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t3->math("HG = GB = BC, CD = DK = KL");
        $t3->math(
                 "\\{triangle}AHC = n\\{dot}\\{triangle}ABC,  HC = n\\{dot}BC");
        $t3->math(
                 "\\{triangle}ACL = m\\{dot}\\{triangle}ACD,  CL = m\\{dot}CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "If HC is equal to CL, then the triangles AHC and "
                      . "ACL are equal (I.38)" );
        my $y = $t3->y;
        $t3->explain("if");
        $t3->y($y);
        $t3->math("   HC=CL \\{then} \\{triangle}AHC = \\{triangle}ACL");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "IF HC is greater (or less) than CL, the the "
                      . "triangle AHC will be greater (or less) "
                      . "than ACL (I.38)" );
        $t3->math("   HC <=> CL \\{then} \\{triangle}AHC <=> \\{triangle}ACL");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "By definition (V.Def.5), the ratio of BC to CD is "
                      . "equal to the ratio of "
                      . "the triangles ABC and ACD" );
        $t3->down;
        my $y = $t3->y;
        $t3->explain("or");
        $t3->y($y);
        $t3->math(
                 "   n\\{dot}BC <=> m\\{dot}CD \\{then} n\\{dot}\\{triangle}ABC"
                   . " <=> m\\{dot}\\{triangle}ACD" );
        $t3->math("\\{therefore} BC:CD = \\{triangle}ABC:\\{triangle}ACD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
    };

    # -------------------------------------------------------------------------
    # parallelograms
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof - Parallelograms");
        $t3->erase();
        $t{AGB}->remove;
        $t{AHG}->remove;
        $t{ADK}->remove;
        $t{AKL}->remove;
        $t{EBA} = Triangle->join( $p{E}, $p{B}, $p{A} )->fill($blue);
        $t{ADF} = Triangle->join( $p{A}, $p{D}, $p{F} )->fill($green);
        $t3->math("BC:CD = \\{triangle}ABC:\\{triangle}ACD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The parallelograms EC and CF are twice the "
                      . "triangles ABC and ACD respectively (I.41)" );
        $t3->math("\\{square}EC = 2\\{triangle}ABC");
        $t3->math("\\{square}CF = 2\\{triangle}ACD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "If two magnitudes are multiplied by the same "
                      . "number, then the ratio will not be affected (V.15)" );
        $t1->explain(  "Therefore the ratio of the triangles to each "
                     . "other is the same as the ratio of the parallelograms" );
        $t3->math(
                 "\\{triangle}ABC:\\{triangle}ACD = \\{square}EC:\\{square}CF");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "And since ratios are transitive (a=b b=c "
                 . "\\{then} a=c) (V.11), then the ratio "
                 . "of the parallelograms is equal to the ratio of the bases" );
        $t3->down;
        $t3->math(   "BC:CD = \\{triangle}ABC:\\{triangle}ACD = "
                   . "\\{square}EC:\\{square}CF" );
    };

    return $steps;

}
