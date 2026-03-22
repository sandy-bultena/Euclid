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
my $title = "To find the center of a given circle.";

$pn->title( 1, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 1 );
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

    my @c = ( 225, 400 );
    my $r = 180;
    $c{C} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Construction");
        $c{C} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );
        $t1->explain(   "Let a straight line (AB) be drawn through "
                      . "the circle at random, and be bisected at point D" );
        $l{ABv} = VirtualLine->new(
                                    $c[0] - 2 * $r,
                                    $c[1] + .75 * $r,
                                    $c[0] + 2 * $r,
                                    $c[1] + .75 * $r
        );
        my @p = $c{C}->intersect( $l{ABv} );
        $l{AB} = Line->new( $pn, @p );
        $p{B} = Point->new( $pn, $l{AB}->start )->label(qw(B right));
        $p{A} = Point->new( $pn, $l{AB}->end )->label(qw(A left));
        $p{D} = $l{AB}->bisect;
        $p{D}->label( "D", "bottomleft" );
        $l{ADv} = VirtualLine->new( $p{A}->coords, $p{D}->coords );
        $l{DBv} = VirtualLine->new( $p{D}->coords, $p{B}->coords );
        $t3->math("AD = DB");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw a line perpendicular to AB through the point D, "
                      . "intersecting the circle at CE" );
        $l{CEt} = $l{AB}->perpendicular( $p{D} )->grey;
        $l{CEt}->extend($r);
        $l{CEt}->prepend($r);
        my @p = $c{C}->intersect( $l{CEt} );
        $l{CE} = Line->new( $pn, @p );
        $l{CEt}->remove;
        $p{C} = Point->new( $pn, $l{CE}->start )->label(qw(C bottom));
        $p{E} = Point->new( $pn, $l{CE}->end )->label(qw(E top));
        $l{DE} = Line->join( $p{D}, $p{E} );
        $l{AD} = Line->join( $p{A}, $p{D} );
        $a{ADE} = Angle->new( $pn, $l{DE}, $l{AD} )->label( "\\{gamma}", 100 );
        $l{DB} = Line->join( $p{D}, $p{B} );
        $l{DE}->remove;
        $l{AD}->remove;
        $l{DB}->remove;
        $t3->math("\\{gamma} = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "Bisect CE at point F.  Point F is the center of the circle");
        $p{F} = $l{CE}->bisect;
        $p{F}->label( "F", "left" );
        $t3->math("CF = FE");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof by Contradiction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Assume that G is the center of the circle, and "
                      . "that G does not lie on the line CE" );

        my @g = $p{F}->coords;
        $p{G} =
          Point->new( $pn, $g[0] + 40, $g[1] + 20 )->label(qw(G topright));
        $t3->down;
        $t2->y( $t3->y );
        $t2->explain("If G is the centre of the circle");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Join GA, GD and\\{nb}GB");
        $l{GA} = Line->join( $p{G}, $p{A} );
        $l{GD} = Line->join( $p{G}, $p{D} );
        $l{GB} = Line->join( $p{G}, $p{B} );
        $t2->math("\\{alpha} > \\{gamma}");
        $a{ADG} = Angle->new( $pn, $l{GD}, $l{ADv} )->label( "\\{alpha}", 20 );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("AG and GB are radii, and thus are equal");
        $l{CE}->grey;
        $t3->allgrey;
        $t2->math("AG = GB");
        $a{ADE}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{CE}->grey;
        $s{ADG} =
          Triangle->new( $pn, $p{A}->coords, $p{D}->coords, $p{G}->coords, -1 )
          ->fill($sky_blue);
        $s{GDB} =
          Triangle->new( $pn, $p{G}->coords, $p{D}->coords, $p{B}->coords, -1 )
          ->fill($lime_green);

        $t1->explain(
                "Thus, since the side DG is shared between both triangles ADG "
              . "and GDB, the triangles have three equal sides, "
              . "therefore angle ADG (\\{alpha}) equals angle GDB (\\{beta})\\{nb}(I.8)"
        );
        $a{GDB} = Angle->new( $pn, $l{DBv}, $l{GD} )->label( "\\{beta}", 30 );
        $t3->blue(0);
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("\\{alpha} = \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "By definition (I.Def.10), two angles on a straight lines "
                . "are right angles if they are equal to each other, " . "thus "
                . "\\{alpha} and \\{beta} are right" );

        $t3->allgrey;
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("\\{alpha} = \\{beta} = \\{right}");

        $s{ADG}->remove;
        $s{GDB}->remove;
        $l{GA}->grey;
        $l{GB}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "But GDB (\\{alpha}) is greater than FDA (\\{gamma}), "
                      . "which is also a right angle (by construction)" );
        $t1->explain(
                 "The angle \\{alpha} cannot be both greater than and equal to "
                   . "\\{gamma}" );
        $l{CE}->normal;
        $a{GDB}->remove;
        $t2->allgrey;
        $t3->allgrey;
        $t3->red(1);
        $t2->red( [ 1, 4 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So G is not the center of the circle");
        $t2->allgrey;
        $t3->allgrey;
        $t2->red(0);
        $t2->down;
        $l{GA}->normal;
        $l{GB}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Thus, the centre of the circle must lie on the line CE");
        $a{ADG}->remove;
        $p{G}->remove;
        $l{GA}->remove;
        $l{GD}->remove;
        $l{AF} = Line->join( $p{A}, $p{F} );
        $l{GB}->remove;
        $l{BF} = Line->join( $p{B}, $p{F} );
        $t2->allgrey;
        $t2->explain("Centre of circle lies on EC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t3->blue(2);
        $t1->explain(   "Note that if G lies on the line CE, and it "
                      . "is the center of the circle, it must coincide "
                      . "with the point F, since the points E and C "
                      . "must be equidistant from the center." );
        $t2->explain("F is the centre");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->allgrey;
        $t2->black(-1);
        $t3->allblue;
        $a{ADE}->normal;
    };

    return $steps;
}

