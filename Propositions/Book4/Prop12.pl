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
my $title = "About a given circle to circumscribe an equilateral "
  . "and equiangular pentagon.";

$pn->title( 12, $title, 'IV' );

my $t1 = $pn->text_box( 800, 140, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 440, 200 );
my $t5 = $pn->text_box( 440, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 12 );
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

    my $r = 140;
    my @c = ( 200, 300 );
    my @a = ( $c[0] + $r + 60, $c[1] + $r );
    my @b = (
              $c[0] + $r + 60 + 2 * $r * cos( 72 / 180 * 3.14 ),
              $c[1] + $r - 2 * $r * sin( 72 / 180 * 3.14 )
    );
    my @info;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain(   "Construct a pentagon on the outside of "
                      . "a circle, where all lines and "
                      . "angles are equal" );

        $c{a} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );

        foreach my $i ( 1 .. 5 ) {
            $p{$i} = $c{a}->point( 90 - ( $i - 1 ) * 360 / 5 + 180 / 5 );
            $l{$i} = Line->new( $pn, $c{a}->tangent( $p{$i}->coords ) );
            $p{$i}->remove;
            if ( $i > 1 ) {
                $p{ $i - 1 } =
                  Point->new( $pn, $l{$i}->intersect( $l{ $i - 1 } ) );
            }
            $l{$i}->remove;
        }
        $p{5} = Point->new( $pn, $l{1}->intersect( $l{5} ) );
        $s{a} = Polygon->join( 5, $p{1}, $p{2}, $p{3}, $p{4}, $p{5} );

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
        $s{a}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Construct a pentagon in the circle, so that the "
                 . "AB, BC, CD, DE, EA circumferences are equal\\{nb}(IV.11)" );
        foreach my $i ( 1 .. 5 ) {
            $p{$i} = $c{a}->point( 90 - ( $i - 1 ) * 360 / 5 + 180 / 5 );
        }
        $p{E} = $p{2}->label( "E", "topright" );
        $p{D} = $p{3}->label( "D", "right" );
        $p{C} = $p{4}->label( "C", "bottom" );
        $p{B} = $p{5}->label( "B", "left" );
        $p{A} = $p{1}->label( "A", "topleft" );
        $s{inner} = Polygon->join( 5, $p{1}, $p{2}, $p{3}, $p{4}, $p{5} )->grey;
        $t5->math("\\{arc}AB = \\{arc}BC = \\{arc}CD = \\{arc}EA");
        $t5->allblue;
        $t3->y( $t5->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Draw lines from each point A, B, C, D, E, just touching "
                      . "the circle\\{nb}(III.16)" );
        foreach my $i ( 1 .. 5 ) {
            $l{$i} = $c{a}->draw_tangent( $p{$i} );
            $l{$i}->prepend( $c{a}->radius );
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Label the intersection points G, H, K, L and M");
        $t1->explain("The pentagon GHKLM is equilateral and equiangular");

        foreach my $i ( 2 .. 6 ) {
            my $j = $i > 5 ? 1 : $i;
            $p{ $i - 1 + 5 } =
              Point->new( $pn, $l{$j}->intersect( $l{ $i - 1 } ) );
        }
        $p{G} = $p{6}->label( "G", "top" );
        $p{M} = $p{7}->label( "M", "right" );
        $p{L} = $p{8}->label( "L", "bottom" );
        $p{K} = $p{9}->label( "K", "bottom" );
        $p{H} = $p{10}->label( "H", "left" );
        $s{a} = Polygon->join( 5, $p{6}, $p{7}, $p{8}, $p{9}, $p{10} );

        foreach my $i ( 1 .. 5 ) {
            $l{$i}->remove;
        }
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
        $t1->explain("Find and label the centre of the circle F\\{nb}(III.1)");
        $t1->explain("Draw lines FB FK FC FL FD");

        $p{F} = Point->new( $pn, $c{a}->centre )->label( "F", "top" );
        $l{FB} = Line->join( $p{F}, $p{B} );
        $l{FK} = Line->join( $p{F}, $p{K} );
        $l{FC} = Line->join( $p{F}, $p{C} );
        $l{FL} = Line->join( $p{F}, $p{L} );
        $l{FD} = Line->join( $p{F}, $p{D} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since HK, KL and LM touch the circle at points B, C, D, "
            . "and since the lines FB, FC, FD are drawn from the centre of the circle, "
            . "the angles at B, C and D are right angles\\{nb}(III.18)" );
        $l{HB} = Line->join( $p{H}, $p{B} )->grey;
        $a{FBH} = Angle->new( $pn, $l{FB}, $l{HB} );
        $l{CK} = Line->join( $p{C}, $p{K} )->grey;
        $a{FCK} = Angle->new( $pn, $l{FC}, $l{CK} );
        $l{DL} = Line->join( $p{D}, $p{L} )->grey;
        $a{FDL} = Angle->new( $pn, $l{FD}, $l{DL} );
        $t5->allgrey;
        $t3->math("FB = FC = FD");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Using pythagoras' theorem (I.47), the square of FK is equal "
              . "to the sum of the squares FC,CK and it is also equal to the sum of the "
              . "the squares FB,BK" );
        $c{a}->grey;
        $s{FBK} = Triangle->join( $p{F}, $p{B}, $p{K} )->fill($sky_blue);
        $s{FKC} = Triangle->join( $p{F}, $p{K}, $p{C} )->fill($lime_green);
        $t3->math("FK\\{squared} = FC\\{squared} + KC\\{squared}");
        $t3->math("FK\\{squared} = FB\\{squared} + BK\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since FC equals FB, then the square of "
                      . "KC equals the square of "
                      . "BK, or KC equals BK" );
        $t3->math("BK = KC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("BF equals BC, BK equals KC, and FK is common, "
                   . "therefore the triangles FBK and FBC are equivalent(\\{nb}"
                   . "(SSS)\\{nb}(I.8) " );
        $t1->explain("Thus angles BFK and KFC are equal");
        $a{BFK} = Angle->new( $pn, $l{FB}, $l{FK} )->label( "\\{alpha}", 35 );
        $a{KFC} = Angle->new( $pn, $l{FK}, $l{FC} )->label( "\\{alpha}", 25 );
        $l{KB} = Line->join( $p{K}, $p{B} )->grey;
        $l{KC} = Line->join( $p{K}, $p{C} )->grey;
        $a{FKB} = Angle->new( $pn, $l{FK}, $l{KB} )->label( "\\{delta}", 35 );
        $a{FKC} = Angle->new( $pn, $l{KC}, $l{FK} )->label( "\\{delta}", 25 );
        $t3->allgrey;
        $t3->black( [ 0, -1 ] );
        $t3->math("\\{angle}BFK = \\{angle}CFK");
        $t3->math("\\{angle}FKB = \\{angle}FKC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, angles CFL and LFD are equal");
        $s{FBK}->grey;
        $s{FKC}->grey;
        $a{FKB}->grey;
        $a{FKC}->grey;
        $s{FCL} = Triangle->join( $p{F}, $p{C}, $p{L} )->fill($pale_pink);
        $s{FLD} = Triangle->join( $p{F}, $p{L}, $p{D} )->fill($pale_yellow);

        $a{CFL} = Angle->new( $pn, $l{FC}, $l{FL} )->label( "\\{epsilon}", 35 );
        $a{FLD} = Angle->new( $pn, $l{FL}, $l{FD} )->label( "\\{epsilon}", 25 );

        $l{CL} = Line->join( $p{C}, $p{L} )->grey;
        $l{DL} = Line->join( $p{D}, $p{L} )->grey;
        $a{FLC} = Angle->new( $pn, $l{FL}, $l{CL} )->label( "\\{theta}", 35 );
        $a{DLF} = Angle->new( $pn, $l{DL}, $l{FL} )->label( "\\{theta}", 25 );
        $t3->allgrey;
        $t3->math("\\{angle}CFL = \\{angle}LFD");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the circumference BC, CD are equal, so are the "
                   . "angles subtending them, angles BFC equals CFD (III.27)" );
        $t5->allblue;

        $a{FLC}->grey;
        $a{DLF}->grey;
        $l{FK}->grey;
        $s{FCL}->grey;
        $s{FLD}->grey;
        $l{FD}->normal;
        $s{a}->grey;
        $c{BC} = Arc->join( $r, $p{B}, $p{C} )->fillpie($teal);
        $c{CD} = Arc->join( $r, $p{C}, $p{D} )->fillpie($orange);
        $l{FL}->grey;
        $a{FBH}->grey;
        $a{FCK}->grey;
        $a{FDL}->grey;
        $t3->down;
        $t3->allgrey;
        $t3->math("\\{angle}BFC = \\{angle}CFD");
        $t3->math("\\{alpha} = \\{epsilon}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "Triangles FKC and FCL have one side and two angles equal, "
                      . "therefore they are equivalent (I.26), "
                      . "and KC equals CL, or KL equals twice KC "
                      . "and the angles FKC and FLC are equal" );
        $l{FB}->grey;
        $l{FD}->grey;
        $c{BC}->grey;
        $c{CD}->grey;
        $c{BC}->fill;
        $c{CD}->fill;
        $s{FKC} = Triangle->join( $p{F}, $p{K}, $p{C} )->fill($lime_green);
        $s{FCL} = Triangle->join( $p{F}, $p{C}, $p{L} )->fill($pale_pink);
        $a{FLC}->normal;
        $a{FCK}->normal;
        $a{FKC}->normal;
        $t3->allgrey;
        $t3->math("KC = CL");
        $t3->math("KL = 2\\{dot}KC");
        $t3->math("\\{delta} = \\{theta}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "Similarly, it can be shown that HK is twice BK, and since "
                      . "BK equals KC, HK equals KL" );
        $t3->allgrey;
        $t3->black(3);
        $t3->math("HK = 2\\{dot}BK = 2\\{dot}KC");
        $t3->math("\\{therefore} HK = KL");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                   "Applying the same logic to the other sides of the pentagon "
                     . "proves that the pentagon is equilateral" );
        $s{FKC}->grey;
        $s{FCL}->grey;
        $l{FC}->grey;
        $a{CFL}->grey;
        $a{FLD}->grey;
        $a{BFK}->grey;
        $a{KFC}->grey;
        $a{FCK}->grey;
        $s{a}->normal;
        $a{FLC}->grey;
        $a{FKC}->grey;
        $t3->allgrey;
        $t3->math("HK = KL = LM = MG = GH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->explain("The pentagon has been proven to be equilateral");
        $t1->explain("It is also equiangular");
        $t1->down;
        $t1->title("Proof (cont.)");
        $t3->erase;
        $t3->y( $t5->y );
        $t3->math("HK = KL = LM = MG = GH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Triangles BFK and FKC have been proven "
              . "to be equivalent, therefore "
              . "the angles FKB and FKC are equal"
        );

        $s{FBK}->normal;
        $s{FKC}->normal;

        $a{FKB}->normal;
        $a{FKC}->normal;

        $t3->math("\\{angle}HKL = 2\\{delta}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Triangles FCL and FDL have been proven to be equal, therefore "
                  . "the angles FLC and FLD are equal" );

        $s{FBK}->grey;
        $s{FKC}->grey;

        $a{FKB}->grey;
        $a{FKC}->grey;

        $s{FCL}->normal;
        $s{FLD}->normal;

        $a{FLC}->normal;
        $a{DLF}->normal;

        $t3->math("\\{angle}KLM = 2\\{theta}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Triangles FKC and FCL have been proven to be equal, therefore "
                  . "the angles FKC and FLC are equal" );

        $s{FBK}->grey;
        $s{FKC}->normal;

        $a{FKB}->grey;
        $a{FKC}->normal;

        $s{FCL}->normal;
        $s{FLD}->grey;

        $a{FLC}->normal;
        $a{DLF}->grey;

        $t3->math("\\{delta} = \\{theta}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, angles HKL and FLC are equal");
        $t3->math("\\{angle}HKL = \\{angle}FLC");
        $s{FCL}->grey;
        $s{FLD}->grey;
        $s{FKC}->grey;
        $a{FKB}->normal;
        $a{DLF}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                     "Using the same logic, it can be shown that all the angle "
                       . "are equal, hence the pentagon is equiangular" );
        $s{FCL}->grey;
        $a{FKC}->grey;
        $a{FLC}->grey;
        $s{FKC}->grey;
        $a{FKB}->grey;
        $a{DLF}->grey;
        $t3->allgrey;
        $t3->math("\\{angle}GHK = \\{angle}HKL = \\{angle}KLM");
        $t3->math("     = \\{angle}LMG = \\{angle}MGH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->black(0);
        $t1->down;
        $t1->explain("Thus GHKLM is a regular pentagon");
        $t5->allgrey;
        $s{a}->fill($blue);
        $c{a}->normal;
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

