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
my $title = "In a given pentagon, which is equilateral and equiangular,"
  . " to inscribe a circle.";

$pn->title( 13, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 440, 200 );
my $t5 = $pn->text_box( 440, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 13 );
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
        $t1->explain( "Given a pentagon draw a circle on the inside, where the "
                      . "sides of the pentagon touch the circle" );

        $c{v} = VirtualCircle->new( @c, $c[0] + $r, $c[1] );

        foreach my $i ( 1 .. 5 ) {
            $p{$i} =
              Point->new( $pn, $c{v}->coords( 90 - ( $i - 1 ) * 360 / 5 ) );
        }
        $p{A} = $p{1}->label( "A", "top" );
        $p{E} = $p{2}->label( "E", "right" );
        $p{D} = $p{3}->label( "D", "bottom" );
        $p{C} = $p{4}->label( "C", "bottom" );
        $p{B} = $p{5}->label( "B", "left" );
        $s{a} = Polygon->join( 5, $p{1}, $p{2}, $p{3}, $p{4}, $p{5} );
        $c{a} =
          Circle->new( $pn, @c, $c[0] + $r * cos( 36 * 3.14159 / 180 ), $c[1] );

    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $c{a}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Bisect the angles BCD and CDE by the lines CF and DF");
        $a{BCD} = Angle->new( $pn, $s{a}->l(3), $s{a}->l(4) );
        $l{CFt} = $a{BCD}->clean_bisect()->grey;
        $a{CDE} = Angle->new( $pn, $s{a}->l(2), $s{a}->l(3) );
        $l{DFt} = $a{CDE}->clean_bisect()->grey;
        $a{BCD}->grey;
        $a{CDE}->grey;
        my @p = $l{CFt}->intersect( $l{DFt} );
        $p{F} = Point->new( $pn, @p )->label( "F", "topright" );
        $l{CF} = Line->join( $p{C}, $p{F} );
        $l{DF} = Line->join( $p{D}, $p{F} );
        $l{CFt}->remove;
        $l{DFt}->remove;

        $a{BCF} =
          Angle->new( $pn, $l{CF}, $s{a}->l(4) )->label( "\\{alpha}", 35 );
        $a{DCF} =
          Angle->new( $pn, $s{a}->l(3), $l{CF} )->label( "\\{alpha}", 30 );
        $a{CDF} =
          Angle->new( $pn, $l{DF}, $s{a}->l(3) )->label( "\\{theta}", 30 );
        $a{FDE} =
          Angle->new( $pn, $s{a}->l(2), $l{DF} )->label( "\\{theta}", 35 );

        $t5->math("2\\{alpha} = 2\\{theta}");
        $t5->math("\\{angle}BCF = \\{angle}FCD = \\{alpha}");
        $t5->math("\\{angle}CDF = \\{angle}FDE = \\{theta}");
        $t5->down;
        $t5->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a perpendicular from point F to side CD");

        $a{BCF}->grey;
        $a{DCF}->grey;
        $a{CDF}->grey;
        $a{FDE}->grey;

        $l{FKt} = $s{a}->l(3)->perpendicular( $p{F} );
        my @p = $l{FKt}->intersect( $s{a}->l(3) );
        $p{K} = Point->new( $pn, @p )->label( "K", "bottom" );
        $l{FK} = Line->join( $p{F}, $p{K} );
        $l{FKt}->remove;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "Draw a circle with F as the centre, and FK as the radius");
        $t1->explain("The circle inscribes the pentagon");
        $c{a} = Circle->new( $pn, $p{F}->coords, $p{K}->coords );
        $l{FK}->grey;
        $l{CF}->grey;
        $l{DF}->grey;
        $t3->y( $t5->y );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof");
        $c{a}->grey;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw line BF");
        $l{BF} = Line->join( $p{B}, $p{F} );
        $l{CF}->normal;
        $l{DF}->normal;
        $t5->allgrey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(  "Since BC is equal to CD, FC is common, and the angles "
                     . "BCF and FCD are equal the two triangles BFC and FCD are"
                     . " equivalent (SAS)\\{nb}(I.4)" );
        $s{FBC} = Triangle->join( $p{F}, $p{B}, $p{C} )->fill($sky_blue);
        $s{FCD} = Triangle->join( $p{F}, $p{C}, $p{D} )->fill($lime_green);
        $a{BCF}->normal;
        $a{DCF}->normal;
        $a{CDF}->normal;
        $t5->blue(1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the angles CBF and CDF are equal");
        $a{FBC} =
          Angle->new( $pn, $s{a}->l(4), $l{BF} )->label( "\\{theta}", 35 );
        $t3->math("\\{angle}CBF = \\{angle}CDF = \\{theta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The pentagon is equiangular, hence angles ABC and "
                      . "CDE are equal" );

        $s{FBC}->grey;
        $s{FCD}->grey;
        $a{BCF}->grey;
        $a{DCF}->grey;
        $l{CF}->grey;

        $a{FDE}->normal;
        $t3->allgrey;
        $t5->allgrey;

        $t3->math("\\{angle}CDE = \\{angle}ABC = 2\\{theta}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Angle CBF (\\{theta}) is equal to FDC (\\{theta}), "
            . "and FDC is half of CDE (2\\{theta}), therefore BF bisects the angle ABC"
        );

        $a{ABF} =
          Angle->new( $pn, $l{BF}, $s{a}->l(5) )->label( "\\{theta}", 30 );
        $t3->black(-2);
        $t3->math("\\{therefore} \\{angle}ABF = \\{angle}CBF = \\{theta}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Similarly, it can be shown that AF and EF bisect the "
                      . "angles BAE and AED respectively" );
        $l{AF} = Line->join( $p{A}, $p{F} );
        $l{EF} = Line->join( $p{E}, $p{F} );
        $l{CF}->normal;
        $t3->math("\\{angle}BAF = \\{angle}FAE");
        $t3->math("\\{angle}AEF = \\{angle}FED");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw perpendiculars from F to line CD and BC");
        $a{FDE}->grey;
        $a{ABF}->grey;
        $a{BCF}->grey;
        $a{DCF}->grey;
        $a{CDF}->grey;
        $a{FBC}->grey;
        $l{AF}->grey;
        $l{BF}->grey;
        $l{DF}->grey;
        $l{EF}->grey;
        $l{CF}->grey;
        $t3->allgrey;
        $t5->allgrey;

        $l{FK}->normal;

        $l{FHt} = $s{a}->l(4)->perpendicular( $p{F} )->grey;
        my @p = $l{FHt}->intersect( $s{a}->l(4) );
        $p{H} = Point->new( $pn, @p )->label( "H", "left" );
        $l{FH} = Line->join( $p{F}, $p{H} );
        $l{FHt}->remove;

        $l{HC} = Line->join( $p{H}, $p{C} );
        $l{CK} = Line->join( $p{C}, $p{K} );
        $a{FKC} = Angle->new( $pn, $l{FK}, $l{CK} );
        $a{FHC} = Angle->new( $pn, $l{HC}, $l{FH} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Triangles HFC and FKC are right angled triangles "
                      . "with angles FCH and FCK equal and a common side FC " );
        $t1->explain(
                    "Therefore, the two triangles are equivalent (ASA) (I.26), "
                      . "and FH equals FK" );
        $s{FHC} = Triangle->join( $p{F}, $p{H}, $p{C} )->fill($pale_pink);
        $s{FCK} = Triangle->join( $p{F}, $p{C}, $p{K} )->fill($pale_yellow);
        $a{BCF}->normal;
        $a{DCF}->normal;
        $t3->down;
        $t3->math("FH = FK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Similarly, it can be shown that "
                  . "perpendiculars drawn from\\{nb}"
                  . "F to the remaining sides of the pentagon are all equal " );
        $s{FHC}->grey;
        $s{FCK}->grey;
        $a{BCF}->grey;
        $a{DCF}->grey;
        $a{FKC}->grey;
        $a{FHC}->grey;

        $l{FGt} = $s{a}->l(5)->perpendicular( $p{F} )->grey;
        my @p = $l{FGt}->intersect( $s{a}->l(5) );
        $p{G} = Point->new( $pn, @p )->label( "G", "top" );
        $l{FG} = Line->join( $p{F}, $p{G} );
        $l{FGt}->remove;

        $l{FMt} = $s{a}->l(1)->perpendicular( $p{F} )->grey;
        @p      = $l{FMt}->intersect( $s{a}->l(1) );
        $p{M}   = Point->new( $pn, @p )->label( "M", "top" );
        $l{MG}  = Line->join( $p{F}, $p{M} );
        $l{FMt}->remove;

        $l{FLt} = $s{a}->l(2)->perpendicular( $p{F} )->grey;
        @p      = $l{FLt}->intersect( $s{a}->l(2) );
        $p{L}   = Point->new( $pn, @p )->label( "L", "right" );
        $l{FL}  = Line->join( $p{F}, $p{L} );
        $l{FLt}->remove;

        $t3->math("FH = FK = FL = FM = FG");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Thus, a circle drawn with a centre at F, and a radius "
                  . "of FH will pass through all the points H, K, L, M and G" );
        $c{a}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the sides of the pentagon are at right angles "
                   . "to the radii, the pentagon touches the circle (III.16)" );
        $l{FL}->grey;
        $l{MG}->grey;
        $l{FG}->grey;
        $l{FH}->grey;
        $l{FK}->grey;

        #$s{a}->fill($sky_blue);
        #$c{a}->fill($blue);
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

