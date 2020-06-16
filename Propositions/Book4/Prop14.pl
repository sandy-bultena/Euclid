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
my $title = "About a given pentagon, which is equilateral and equiangular, to "
  . "circumscribe a circle.";

$pn->title( 14, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 440, 200 );
my $t5 = $pn->text_box( 440, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 14 );
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
        $t1->explain(
                     "Given a pentagon draw a circle on the outside, where the "
                       . "circle passes through the vertices of the pentagon" );

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
        $c{a} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );

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
        $t1->explain("Start with a equilateral, equiangular pentagon");
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
        $t1->explain(
                    "Draw a circle with F as the centre, and FC as the radius");
        $t1->explain("The circle circumscribes the pentagon");
        $c{a} = Circle->new( $pn, $p{F}->coords, $p{C}->coords );
        $l{CF}->grey;
        $l{DF}->grey;
        $a{BCF}->grey;
        $a{DCF}->grey;
        $a{CDF}->grey;
        $a{FDE}->grey;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof");
        $c{a}->grey;
        $t3->y( $t5->y );

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
        $t1->explain(
                "Angle CBF (\\{theta}) is equal to FDC (\\{theta}), "
              . "and FDC is half of CDE (2\\{theta}), "
              . "therefore BF bisects the angle ABC"
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
        $t1->explain(   "The pentagon is equiangular, hence angles BCD and "
                      . "CDE are equal" );
        $a{ABF}->grey;
        $a{FBC}->grey;
        $l{AF}->grey;
        $l{BF}->grey;
        $l{EF}->grey;
        $a{BCF}->normal;
        $a{DCF}->normal;
        $t3->allgrey;
        $t3->math("2\\{alpha} = 2\\{theta}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Therefore angles FCD and FDC are also equal, and the triangle "
                  . "FCD is an isosceles triangle" );
        $t1->explain("Thus, FC and FD are equal (I.6)");
        $a{BCF}->grey;
        $a{FDE}->grey;
        $s{FCD}->normal;
        $t3->math("\\{alpha} = \\{theta}");
        $t3->math("FC = FD");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Similarly, it can be shown that the "
                      . "lines FA, FB, FC, FD, and FE "
                      . "are all equal" );
        $s{FCD}->grey;
        $l{AF}->normal;
        $l{BF}->normal;
        $l{CF}->normal;
        $l{DF}->normal;
        $l{EF}->normal;
        $a{DCF}->grey;
        $a{CDF}->grey;
        $t3->math("FA = FB = FC = FD = FE");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "A circle drawn with a centre at F, and a radius "
                  . "of FA will pass through all the points A, B, C, D and E" );
        $c{a}->normal;
        $t3->allgrey;
        $t3->black(-1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus we have circumscribed the pentagon with a circle");
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

