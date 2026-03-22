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
my $title = "About a given circle to circumscribe a triangle "
  . "equiangular with a given triangle.";

$pn->title( 3, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 540, 400 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 3 );
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

    my @c = ( 220, 500 );
    my $r = 80;
    my @e = ( 440, 300 );                           #e
    my @d = ( 500, 215 );                           #d
    my @f = ( 300, 215 );                           #f
    my @g = ( $c[0] - $r + 20, $c[1] + $r - 20 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $c{A} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );
        $p{D} = Point->new( $pn, @d )->label( "D", "right" );
        $p{E} = Point->new( $pn, @e )->label( "E", "bottomleft" );
        $p{F} = Point->new( $pn, @f )->label( "F", "bottom" );
        $s{DEF} = Triangle->join( $p{D}, $p{F}, $p{E} );
        $s{DEF}
          ->set_angles( "\\{delta}", "\\{lambda}", "\\{epsilon}", undef, undef,
                        20 );

        $t1->explain("Given a circle and a triangle DEF:");
        $t1->explain(   "Draw a triangle circumscribing the circle, "
                      . "where the angles in the new triangle equal the angles "
                      . "in triangle DEF" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{1} = $c{A}->point(15);
        $p{2} = $c{A}->point(-100);
        $p{3} = $c{A}->point(150);
        $p{4} = Point->new( $pn, $c{A}->center );
        $l{1} = Line->join( $p{4}, $p{1}, -1, 1 );
        $l{2} = Line->join( $p{4}, $p{2}, -1, 1 );
        $l{3} = Line->join( $p{4}, $p{3}, -1, 1 );
        $l{5} = $l{1}->perpendicular( $p{1}, -1, undef, 1 )->prepend(300);
        $l{6} = $l{2}->perpendicular( $p{2}, -1, undef, 1 )->prepend(300);
        $l{7} = $l{3}->perpendicular( $p{3}, -1, undef, 1 )->prepend(300);
        $l{5}->extend(100);
        $l{6}->extend(100);
        $l{7}->extend(100);
        $l{1}->remove;
        $l{2}->remove;
        $l{3}->remove;
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $l{5}->remove;
        $l{6}->remove;
        $l{7}->remove;
        $p{1}->remove;
        $p{2}->remove;
        $p{3}->remove;
        $p{4}->remove;
        $t1->title("Construction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Extend the base of the triangle to points H and G");
        $l{GH} = Line->join( $p{E}, $p{F}, -1 );
        $l{GH}->extend(100);
        $l{GH}->prepend(100);
        $p{H} = Point->new( $pn, $l{GH}->end )->label( "H", "bottom" );
        $p{G} = Point->new( $pn, $l{GH}->start )->label( "G", "bottom" );
        $l{HF} = Line->join( $p{H}, $p{F}, -1 );
        $l{GE} = Line->join( $p{G}, $p{E}, -1 );
        $a{DFH} =
          Angle->new( $pn, $s{DEF}->l(1), $l{HF} )->label( "\\{alpha}", 20 );
        $a{DEG} =
          Angle->new( $pn, $l{GE}, $s{DEF}->l(3) )->label( "\\{gamma}", 30 );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Find the centre of the circle K (III.1)");
        $p{K} = Point->new( $pn, @c )->label( "K", "left" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the line KB be drawn at random");
        $p{B} = $c{A}->point(45)->label( "B", "right" );
        $l{KB} = Line->join( $p{K}, $p{B} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "Copy angle \\{gamma} to line KB at the point K\\{nb}(I.23)");
        $c{A}->grey;
        ( $l{a1}, $a{BKA} ) = $a{DEG}->copy( $p{K}, $l{KB} );
        $l{a1}->grey;
        $l{a1}->extend( $l{a1}->length() * 2 );
        my @p = $c{A}->intersect( $l{a1} );
        $p{A} = Point->new( $pn, @p[ 0, 1 ] )->label( "A", "left" );
        $l{KA} = Line->join( $p{K}, $p{A} );
        $l{a1}->remove;
        $a{BKA}->label( "\\{gamma}", 20 );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "Copy angle \\{alpha} to line KB at the point K\\{nb}(I.23)");
        $c{A}->grey;
        ( $l{a1}, $a{BKC} ) = $a{DFH}->copy( $p{K}, $l{KB}, "negative" );
        $l{a1}->grey;
        $l{a1}->extend( $l{a1}->length() * 2 );
        my @p = $c{A}->intersect( $l{a1} );
        $p{C} = Point->new( $pn, @p[ 0, 1 ] )->label( "C", "bottom" );
        $l{KC} = Line->join( $p{K}, $p{C} );
        $l{a1}->remove;
        $a{BKC}->label("\\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Draw lines LM, MN, NL such that the touch the circle at "
                      . "points A, B and C respectively (III.16)" );
        $l{a1} = $l{KB}->perpendicular( $p{B} )->grey();
        $l{a2} = $l{KA}->perpendicular( $p{A} )->grey();
        $l{a3} = $l{KC}->perpendicular( $p{C} )->grey();
        $p{M}  = Point->new( $pn, $l{a1}->intersect( $l{a2} ) )->label("M");
        $p{L} =
          Point->new( $pn, $l{a2}->intersect( $l{a3} ) )->label( "L", "left" );
        $p{N} = Point->new( $pn, $l{a3}->intersect( $l{a1} ) )->label("N");
        $l{LM} = Line->join( $p{L}, $p{M} );
        $l{MN} = Line->join( $p{M}, $p{N} );
        $l{NL} = Line->join( $p{N}, $p{L} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Triangle LMN is equi-angular to DEF");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->explain("Triangle LMN is equi-angular to DEF");
        $t1->down;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "The sides of the triangle touch the circle, "
             . "and the lines KA, KB and KC all pass through the centre of the "
             . "circle, therefore the angles "
             . "KCL, KAM and KBN are all right\\{nb}(III.18)" );
        $a{KBN} = Angle->new( $pn, $l{KB}, $l{a1} );
        $a{KCL} = Angle->new( $pn, $l{KC}, $l{a3} );
        $a{KAM} = Angle->new( $pn, $l{KA}, $l{a2} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Consider the quadilateral CKBN.");
        greyall();
        $s{CKBN} = Polygon->join( 4, $p{C}, $p{K}, $p{B}, $p{N} )->fill($sky_blue);
        $a{n} = Angle->new( $pn, $l{MN}, $l{NL} )->label("n");
        $a{KBN}->normal;
        $a{KCL}->normal;
        $p{C}->normal;
        $p{N}->normal;
        $p{B}->normal;
        $p{K}->normal;
        $a{BKC}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "The sum of all the angles "
            . "is equal to four right angles, where KCN and KBN are right, thus "
            . "the angles BKC (\\{alpha}) and BNC (n) are equal to two right angles"
        );
        $t3->math("\\{alpha} + n = 2\\{dot}\\{right}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "The angles \\{alpha} and \\{lambda} are also equal to two "
                      . "right angles\\{nb}(I.13)" );
        $l{HF}->normal;
        $s{DEF}->l(2)->normal;
        $a{DFH}->normal;
        $s{DEF}->a(2)->normal;
        $p{H}->normal;
        $p{F}->normal;
        $p{E}->normal;
        $s{DEF}->l(1)->normal;
        $p{D}->normal;
        $t3->math("\\{alpha} + \\{lambda} = 2\\{dot}\\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, angle n equals \\{lambda}");
        $t3->math("\\{therefore} n = \\{lambda}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
              "Similarly, it can be shown that the angle m equals \\{epsilon}");
        $s{CKBN}->remove;
        greyall();
        $t3->allgrey;
        $s{MAKB} = Polygon->join( 4, $p{K}, $p{B}, $p{M}, $p{A} )->fill($lime_green);
        $a{m} = Angle->new( $pn, $l{LM}, $l{MN} )->label( "m", 20 );
        $l{GE}->normal;
        $s{DEF}->l(2)->normal;
        $a{DEG}->normal;
        $s{DEF}->a(3)->normal;
        $p{G}->normal;
        $p{F}->normal;
        $p{E}->normal;
        $s{DEF}->l(3)->normal;
        $p{D}->normal;

        $a{KBN}->normal;
        $a{KAM}->normal;
        $p{A}->normal;
        $p{M}->normal;
        $p{B}->normal;
        $p{K}->normal;
        $a{BKA}->normal;

        $t3->math("\\{gamma} + \\{epsilon} = 2\\{dot}\\{right}");
        $t3->math("\\{gamma} + m = 2\\{dot}\\{right}");
        $t3->math("\\{therefore} m = \\{epsilon}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since the sum of all angles in a triangle is equal to "
                . "two right angles, and the sum of m,n is equal to the sum of "
                . "\\{epsilon},\\{lambda} (I.32)" );
        $t1->explain("... the angle l is equal to \\{delta}");

        greyall();
        $t3->allgrey;
        $s{MAKB}->remove;
        $s{DEF}->normal;
        $l{MN}->normal;
        $l{NL}->normal;
        $l{LM}->normal;
        $a{m}->normal;
        $a{n}->normal;
        $a{l} = Angle->new( $pn, $l{NL}, $l{LM} )->label("l");
        $p{D}->normal;
        $p{E}->normal;
        $p{F}->normal;
        $p{L}->normal;
        $p{M}->normal;
        $p{N}->normal;

        $t3->math("\\{epsilon} + \\{lambda} + \\{delta} = 2\\{dot}\\{right}");
        $t3->math("m + n + l = 2\\{dot}\\{right}");
        $t3->math("\\{therefore} l = \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ -1, -4, -7 ] );
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
        $p{$o}->grey;
    }
}

