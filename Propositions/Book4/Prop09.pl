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
my $title = "About a given square, to circumscribe a circle.";

$pn->title( 9, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 440, 300 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 9 );
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
    my @b = ( 140, 400 );
    my @c = ( 200, 300 );
    my @a = ( 500, 140 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "Given a square ABCD, draw a circle outside the square, "
                      . "going through points A,B,C and D" );

        my @p = @c;
        $p[0] = $p[0] + $r;
        $p{A} = Point->new( $pn, $c[0], $c[1] - $r )->label( "A", "top" );
        $p{B} = Point->new( $pn, $c[0] - $r, $c[1] )->label( "B", "left" );
        $p{C} = Point->new( $pn, $c[0], $c[1] + $r )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, $c[0] + $r, $c[1] )->label( "D", "right" );
        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{BC} = Line->join( $p{B}, $p{C} );
        $l{CD} = Line->join( $p{C}, $p{D} );
        $l{DA} = Line->join( $p{D}, $p{A} );
        $c{a} = Circle->new( $pn, @c, @p, undef, 1 );

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
        $t1->explain(
               "Draw lines AC and BD, and label the intersection point\\{nb}E");
        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{BD} = Line->join( $p{B}, $p{D} );
        my @p = $l{AC}->intersect( $l{BD} );
        $p{E} = Point->new( $pn, @p )->label( "E", "topright" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a circle with centre E, and radius AE");
        $t1->explain("This circle circumscribes the square");
        $c{A} = Circle->new( $pn, $p{E}->coords, $p{A}->coords );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;

        # $t1->erase;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{A}->grey;
        $t1->explain("Consider the two triangles ABC and ADC");
        $l{BD}->grey;
        $s{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($sky_blue);
        $s{ACD} = Triangle->join( $p{A}, $p{C}, $p{D} )->fill($lime_green);

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("AB equals AD, and AC is common to both triangles ");
        $t1->explain(   "Given that ABCD is a square, the bases BC and CD "
                      . "are also equal, so the triangles are "
                      . "equal in all respects (SSS)\\{nb}(I.8)" );
        $t3->math("\\{triangle}ABC \\{equivalent} \\{triangle}ADC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "Thus, the angles BAC and DAC are equal, and angle A is bisected");
        $a{BAC} = Angle->new( $pn, $l{AB}, $l{AC} )->label("\\{alpha}");
        $a{DAC} = Angle->new( $pn, $l{AC}, $l{DA} )->label( "\\{alpha}", 30 );
        $t3->math("\\{alpha} = \\{half} \\{angle}A");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{A}->grey;
        $t1->explain("Similarly, the angles ABD and CBD are equal");
        $l{BD}->normal;
        $s{ABC}->remove;
        $s{ACD}->remove;
        $s{ABD} = Triangle->join( $p{A}, $p{B}, $p{D} )->fill($sky_blue);
        $s{BCD} = Triangle->join( $p{B}, $p{C}, $p{D} )->fill($lime_green);
        $a{ABD} = Angle->new( $pn, $l{BD}, $l{AB} )->label("\\{gamma}");
        $a{DBC} = Angle->new( $pn, $l{BC}, $l{BD} )->label( "\\{gamma}", 30 );
        $t3->math("\\{gamma} = \\{half} \\{angle}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since angle A is equal to angle B, and \\{alpha} and "
            . "\\{gamma} are half of A and B respectively, \\{alpha} is equal to \\{gamma}"
        );
        $s{ABD}->remove;
        $s{BCD}->remove;
        $t3->math(
                 "\\{angle}A = \\{angle}B \\{therefore} \\{alpha} = \\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                     "The triangle ABE is an isosceles triangle, and therefore "
                       . "AE equals BE (I.6)" );
        $a{DAC}->remove;
        $a{DBC}->remove;
        $s{ABE} = Triangle->join( $p{A}, $p{B}, $p{E} )->fill($sky_blue);
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("AE = BE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{ABE}->remove;
        $t1->explain( "Using the same methods, it can be shown that CE and DE "
                      . "are also equal to AE and BE" );
        $t3->math("AE = BE = CE = DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                     "Thus, a circle with the centre at E, with radius AE will "
                       . "pass through the points A,B,C and D" );
        $t3->allgrey;
        $t3->black(-1);
        $c{A}->normal;
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

