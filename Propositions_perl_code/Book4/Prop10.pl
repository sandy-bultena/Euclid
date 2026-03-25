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
my $title = "To construct an isosceles triangle having each of the angles at "
  . "the base double of the remaining one.";

$pn->title( 10, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 440, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 10 );
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
    my @c = ( 360, 400 );
    my @b = ( 100, 400 );
    my @a = ( 0.5 * ( $b[0] + $c[0] ), 140 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "Construct an isosceles triangle ABC such that the angle "
                 . "at A is half the angle at B and also half the angle at C" );

        my @p = @c;
        $p{A} = Point->new( $pn, @a )->label( "A", "top" );
        $p{B} = Point->new( $pn, @b )->label( "B", "left" );
        $p{C} = Point->new( $pn, @c )->label( "C", "right" );
        $s{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} );
        $s{ABC}->set_angles( "\\{alpha}", "\\{beta}", "\\{gamma}" );
        $t3->math("\\{beta} = \\{gamma} = 2\\{dot}\\{alpha}");

    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $p{A}->remove;
        $p{B}->remove;
        $p{C}->remove;
        $s{ABC}->remove;
        $t3->erase;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Start with any line AB");
        $p{A} = Point->new( $pn, @b )->label( "A", "left" );
        $p{B} =
          Point->new( $pn, $b[0] + 200, $b[1] - 200 )->label( "B", "right" );
        $l{AB} = Line->join( $p{A}, $p{B} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Let it be cut at point C such that the rectangle "
                      . "AB,BC equals the square on\\{nb}CA\\{nb}(II.11)" );
        $p{C} = $l{AB}->golden_ratio()->label( "C", "top" );
        $t3->math("AB\\{dot}BC = AC\\{squared}");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                   "Draw a circle, with A as the center, and AB as the radius");
        $c{A} = Circle->new( $pn, $p{A}->coords, $p{B}->coords );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw a line BD within the circle, equal to length"
                      . "\\{nb}AC\\{nb}(IV.1)" );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{BD} = $l{AC}->copy_to_circle( $c{A}, $p{B}, undef, "negative" );
        $p{D} = Point->new( $pn, $l{BD}->start )->label( "D", "right" );
        $t3->math("AC = BD");
        $t3->allblue;
        $l{AC}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let AD be joined");
        $t1->explain( "The triangle ABC is an isosceles triangle, and the "
                  . "angle at B and D are equal, and are half the angle at A" );
        $c{A}->grey;
        $l{AD} = Line->join( $p{A}, $p{D} );
        $t3->math("\\{angle}B = \\{angle}D = 2\\{dot}\\{angle}A");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof");
        $t3->erase;
        $t3->math("AB\\{dot}BC = AC\\{squared}");
        $t3->math("AC = BD");
        $t3->allblue;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since AC equals BD (by construction), and the rectangle "
            . "AB,BC equals the square on AC (again by construction), then the "
            . "rectangle AB,BC equals the square on BD" );
        $t3->down;
        $t3->math("AB\\{dot}BC = BD\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                   "Draw the line CD, and let a circle be drawn circumscribing "
                     . "the triangle ACD\\{nb}(IV.5)" );
        $s{ACD} = Triangle->join( $p{A}, $p{D}, $p{C} )->fill($sky_blue);
        $c{B} = $s{ACD}->circumscribe;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "We have point B on the outside of the circle, "
            . "and from\\{nb}B, two straight "
            . "lines fall on the circle, AB cutting the circle, and AB falling on the "
            . "circle" );
        $t1->explain(
                    "And since the rectangle AB,BC equals the square of BD, BD "
                      . "touches the circle (III.37)" );
        $s{ACD}->grey;
        $l{AD}->grey;
        $t3->allgrey;
        $t3->black(-1);
        $t3->explain("BD touches the circle");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "Now, since BD touches the circle, and DC cuts the circle, "
                      . "the angle BDC (\\{gamma}) is equal to the angle "
                      . "in the alternating section of the "
                      . "circle DAC (\\{alpha})  (III.32)" );
        $l{AB}->grey;
        $l{CD} = Line->join( $p{C}, $p{D} );
        $a{gamma} = Angle->new( $pn, $l{BD}, $l{CD} )->label("\\{gamma}");
        $a{alpha} = Angle->new( $pn, $l{AD}, $l{AB} )->label("\\{alpha}");
        $l{AD}->normal->green;
        $l{AC} = Line->join( $p{A}, $p{C} )->green;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{alpha} = \\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AC}->remove;
        $l{AB}->normal;
        $l{AD}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Add the angle CDA (\\{theta}) to both sides of the equality ");
        $t1->explain(   "Thus BDA (\\{lambda}) is equal to the "
                      . "two angles CDA,DAC (\\{theta},\\{alpha})" );
        $a{theta} = Angle->new( $pn, $l{CD}, $l{AD} )->label( "\\{theta}", 30 );
        $a{lambda} =
          Angle->new( $pn, $l{BD}, $l{AD} )->label( "   \\{lambda}\n", 80 );
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{alpha}+\\{theta} = \\{gamma}+\\{theta} = \\{lambda}");
        $t3->down;
        $t3->math("\\{lambda} = \\{alpha} + \\{theta}");
        $c{B}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "The exterior angle BCD (\\{phi}) is also equal to the "
               . "sum of the interior "
               . "and opposite angles, CDA,DAC (\\{theta},\\{alpha}) (I.32) " );
        $a{lambda}->grey;
        $a{gamma}->grey;
        $s{ACD} = Triangle->join( $p{A}, $p{C}, $p{D} )->fill($lime_green);
        $l{BD}->grey;
        $l{CB} = Line->join( $p{C}, $p{B} );
        $a{phi} = Angle->new( $pn, $l{CD}, $l{CB} )->label("\\{phi}");
        $t3->allgrey;
        $t3->math("\\{phi} = \\{alpha} + \\{theta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus BDA (\\{lambda}) equals BCD (\\{phi})");
        $s{ACD}->remove;
        $a{lambda}->normal;
        $l{BD}->normal;
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("\\{therefore} \\{lambda} = \\{phi}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "ABD is an isosceles triangle since AB equals AD, and "
              . "therefore angles BDA (\\{lambda}) and DBA (\\{beta}) are equal"
        );
        $a{phi}->grey;
        $a{lambda}->normal;
        $a{gamma}->grey;
        $a{alpha}->grey;
        $a{theta}->grey;
        $l{CD}->grey;
        $l{BD}->normal;
        $s{ABD} = Triangle->join( $p{A}, $p{B}, $p{D} )->fill($pale_yellow);
        $a{beta} = Angle->new( $pn, $l{AB}, $l{BD} )->label("\\{beta}");
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{beta} = \\{lambda} = \\{phi}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof (cont)");
        $t1->explain(   "Since the angles DBA (\\{beta}) and BCD "
                      . "(\\{phi}) are equal, BD is equal "
                      . "to\\{nb}CD\\{nb}(I.6)" );
        $a{lambda}->grey;
        $a{phi}->normal;
        $s{ABD}->remove;
        $s{BCD} = Triangle->join( $p{B}, $p{C}, $p{D} )->fill($pale_pink);
        $t3->math("CD = BD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "But BD is equal to AC (by construction) so triangle ACD "
                      . "is an isosceles triangle" );
        $t1->explain("Thus angle CAD is equal to CDA (I.6)");
        $s{BCD}->grey;
        $a{gamma}->grey;
        $a{beta}->grey;
        $a{theta}->normal;
        $a{alpha}->normal;
        $a{phi}->grey;
        $s{ACD} = Triangle->join( $p{A}, $p{C}, $p{D} )->fill($lime_green);
        $t3->allgrey;
        $t3->black( [-1] );
        $t3->blue(1);
        $t3->math("\\{therefore} AC = CD");
        $t3->math("\\{therefore} \\{theta} = \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Angle ABD (\\{beta}) equals BDA (\\{lambda}), which in "
            . "turn equals the sum of the equal angles "
            . "BAD (\\{alpha}) and CDA (\\{theta}), thus ABD "
            . "(\\{beta}) and BDA\\{nb}(\\{lambda}) equal twice BAD (\\{alpha})"
        );
        $s{ACD}->grey;
        $l{CD}->grey;
        $a{lambda}->normal;
        $a{beta}->normal;
        $a{theta}->grey;
        $t3->allgrey;
        $t3->black( [ -4, -7, -1 ] );
        $t3->math("\\{lambda} = \\{beta} = \\{alpha} + \\{theta} = 2\\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
        $t3->blue( [ 1, 0 ] );
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

