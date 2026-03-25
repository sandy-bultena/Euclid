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
my $title =
"If in a circle a straight line through the center bisect a straight line not through "
  . "the center, it also cuts it a right angles; and if it cut it at right angles "
  . "it also bisects it.";

$pn->title( 3, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 3 );
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

    my @c = ( 225, 350 );
    my $r = 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{C} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );
        $t1->title("In other words ");
        $t1->explain(
                 "Let a line CD pass through the center of the circle (E), and "
               . "cut line (AB) not through the center intersecting at point F."
        );
        $t1->explain(
                    "\\{dot} If F bisects AB, then CD cuts AB at right angles");
        $t1->explain(
                    "\\{dot} If CD cuts AB at right angles, then F bisects AB");

        $p{E} = Point->new( $pn, $c{C}->center )->label(qw(E topright));
        $p{C} = $c{C}->point(90)->label(qw(C top));
        $p{D} = $c{C}->point(270)->label(qw(D bottom));
        $p{A} = $c{C}->point(210)->label( "A", "bottomleft" );
        $p{B} = $c{C}->point(-30)->label( "B", "bottomright" );

        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{CD} = Line->join( $p{C}, $p{D} );
        $p{F} =
          Point->new( $pn, $l{AB}->intersect( $l{CD} ) )
          ->label(qw(F bottomright));

        $t3->math("AF = B \\{then} \\{angle}AFE = \\{right}");
        $t3->math("\\{angle}AFE = \\{right} \\{then} AF = FB");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof");
        $t3->erase;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Join the points EA and EB.  Because EA and EB are radii "
                      . "of the same circle they are equal." );
        $l{EA} = Line->join( $p{E}, $p{A} );
        $l{EB} = Line->join( $p{E}, $p{B} );
        $t2->math("EA = EB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t2->down;
        $t3->y( $t2->y );
        $t3->explain("If F bisects AB");
        $t2->y( $t3->y );
        $t2->math("AF = FB");
        $t2->blue(1);
        $t1->explain("If F bisects AB, AF and FB are equal");
        $t4->y( $t1->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                "Since AF,FB are equal, EA,EB are equal, and EF is common, "
              . "we have a two triangles with three equal sides, "
              . "thus the two triangles are equal (I.8)"
        );
        $s{EAF} =
          Triangle->new( $pn, $p{E}->coords, $p{A}->coords, $p{F}->coords, -1 )
          ->fill($sky_blue);
        $s{EFB} =
          Triangle->new( $pn, $p{E}->coords, $p{F}->coords, $p{B}->coords, -1 )
          ->fill($lime_green);
        $t2->math("\\{triangle}EAF \\{equivalent} \\{triangle}EFB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("EFA (\\{alpha}) equals angle EFB (\\{beta})");
        $s{EAF}->set_angles( undef, undef, "\\{alpha}" );
        $s{EFB}->set_angles( undef, "\\{beta}", undef, 0, 30, 0 );
        $t2->allgrey;
        $t2->math("\\{alpha} = \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "If \\{alpha} and \\{beta} are equal, then they are "
                      . "right angles by definition (I.Def.10)" );
        $t2->math("\\{alpha} = \\{beta} = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->allgrey;
        $t2->black(-1);
        $t2->blue(1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->down;
        $t3->y( $t2->y );
        $t3->allgrey;
        $t3->explain("If CD cuts AB at right angles");
        $t2->y( $t3->y );
        $t2->math("\\{alpha} = \\{beta} = \\{right}");
        $t2->allgrey;
        $t2->blue(5);
        $t1->y( $t4->y );
        $t1->down;
        $t1->explain("If CD cuts AB at right angles");
        $t4->y( $t1->y );
        $s{EFB}->fill();
        $s{EAF}->fill();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain( "Triangle EAB is an isosceles triangle, "
            . "thus angles EAF\\{nb}(\\{gamma}) and ABF (\\{delta}) are equal\\{nb}(I.5)"
        );

        $s{EAB} =
          Triangle->new( $pn, $p{E}->coords, $p{A}->coords, $p{B}->coords, -1 )
          ->fill($pale_pink);
        $s{EAB}->set_angles( undef, "\\{gamma}", "\\{delta}" );
        $l{CD}->grey;
        $t2->math("\\{gamma} = \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain( "Since EF is common, \\{gamma} = \\{delta}, "
            . "and \\{alpha} = \\{beta}"
            . " we have a two triangles with one side and two angles equal (SAA), "
            . "thus the two triangles are equal (I.26)" );

        $s{EFB}->normal();
        $s{EAF}->normal();
        $s{EAB}->fill;
        $s{EFB}->fill($lime_green);
        $s{EAF}->fill($sky_blue);
        $l{CD}->normal;
        $t2->math("\\{triangle}EAF \\{equivalent} \\{triangle}EFB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("AF equal FB, and F bisects AB");

        $t2->allgrey;
        $t2->black(-1);
        $t2->math("AF = FB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->allgrey;
        $t2->black( [ -1, 4 ] );
        $t2->blue( [ 1, 5 ] );
        $t3->allblack;
    };

    return $steps;

}

