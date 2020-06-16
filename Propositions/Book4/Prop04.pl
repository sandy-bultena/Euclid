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
my $title = "In a given triangle, to inscribe a circle.";

$pn->title( 4, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 200, 500 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 4 );
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

    my $r = 80;
    my @b = ( 140, 400 );
    my @c = ( 700, 400 );
    my @a = ( 500, 140 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a triangle ABC");
        $t1->explain(   "Draw a circle so that it touches all "
                      . "three sides of the triangle" );

        $p{A} = Point->new( $pn, @a )->label("A");
        $p{B} = Point->new( $pn, @b )->label( "B", "left" );
        $p{C} = Point->new( $pn, @c )->label( "C", "right" );
        $s{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} );
        $s{ABC}->set_angles( undef, " ", " " );
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Bisect the angles at points B and C with lines "
                      . "BD and CD, intersecting at point D" );
        $l{l2} = $s{ABC}->a(2)->clean_bisect();
        $l{l3} = $s{ABC}->a(3)->clean_bisect();
        my @p = $l{l2}->intersect( $l{l3} );
        $p{D} = Point->new( $pn, @p )->label( "D", "top" );

        $l{BD} = Line->join( $p{B}, $p{D} );
        $l{CD} = Line->join( $p{C}, $p{D} );

        $l{l2}->remove();
        $l{l3}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Draw perpendicular lines from the point D to all three "
                      . "sides of the triangle" );
        my $label = "E";
        foreach my $i ( 1 .. 3 ) {
            $l{"D$label"} = $s{ABC}->l($i)->perpendicular( $p{D} );
            my @p = $l{"D$label"}->intersect( $s{ABC}->l($i) );
            $p{$label} = Point->new( $pn, @p )->label($label);
            $label++;
        }
        $p{E}->label( "E", "left" );
        $p{F}->label( "F", "bottom" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                 "With D as the centre, and DF as the radius, it is possible "
               . "to draw a circle that touches all three sides of the triangle"
        );
        $c{a} = Circle->new( $pn, $p{D}->coords, $p{F}->coords );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "The two triangles DEB and DBF are equal in "
              . "all respects, since they have "
              . "an angle (\\{half}\\{alpha}), side (BD) and angle "
              . "(DFB and DEB) equal\\{nb}(I.26)"
        );

        $c{a}->grey;
        $a{alpha1} =
          Angle->new( $pn, $s{ABC}->l(2), $l{BD} )->label( " \\{alpha}/2", 90 );
        $a{alpha2} =
          Angle->new( $pn, $l{BD}, $s{ABC}->l(1) )
          ->label( " \\{alpha}/2", 110 );
        $s{DBF} = Triangle->join( $p{D}, $p{B}, $p{F} )->fill($sky_blue);
        $s{DEB} = Triangle->join( $p{D}, $p{E}, $p{B} )->fill($lime_green);
        $s{DBF}->set_angles( undef, undef, " " );
        $s{DEB}->set_angles( undef, " ",   undef );

        $t3->math("\\{angle}EBD = \\{angle}DBF = \\{alpha}/2");
        $t3->math("\\{angle}DFE = \\{angle}DEB = \\{right}");
        $t3->math("BD is common");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Hence DF equals DE");
        $t3->math("\\{therefore} DF = DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, it can be shown that DF equals DG");
        $t3->math("  DF = DG");
        $s{DBF}->remove;
        $s{DEB}->remove;
        $a{alpha1}->remove;
        $a{alpha2}->remove;
        $s{GDC} = Triangle->join( $p{G}, $p{D}, $p{C} )->fill($pale_pink);
        $s{DFC} = Triangle->join( $p{D}, $p{F}, $p{C} )->fill($pale_yellow);
        $s{GDC}->set_angles(" ");
        $s{DFC}->set_angles( undef, " " );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{GDC}->remove;
        $s{DFC}->remove;
        $l{BD}->grey;
        $l{CD}->grey;
        $l{FC} = Line->join( $p{F}, $p{C}, -1 );
        $l{GA} = Line->join( $p{G}, $p{A}, -1 );
        $l{EB} = Line->join( $p{E}, $p{B}, -1 );

        $t1->explain( "Since the sides of the triangles are at right angles "
            . "to the radii of the circle, and are at the extremities of the radii, "
            . "then they touch the circle\\{nb}(III.16)" );

        $a{1} = Angle->new( $pn, $l{FC}, $l{DF} );
        $a{2} = Angle->new( $pn, $l{GA}, $l{DG} );
        $a{3} = Angle->new( $pn, $l{EB}, $l{DE} );
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
        $p{$o}->grey;
    }
}

