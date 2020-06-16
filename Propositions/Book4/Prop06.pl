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
my $title = "In a given circle to inscribe a square.";

$pn->title( 6, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 400, 500 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 6 );
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

    my $r = 180;
    my @b = ( 140, 400 );
    my @c = ( 220, 300 );
    my @a = ( 500, 140 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a circle, draw a square ABCD within the circle");

        my @p = @c;
        $p[0] = $p[0] + $r;
        $c{a} = Circle->new( $pn, @c, @p );
        $p{A} = $c{a}->point(90)->label( "A", "top" );
        $p{B} = $c{a}->point(180)->label( "B", "left" );
        $p{C} = $c{a}->point(-90)->label( "C", "bottom" );
        $p{D} = $c{a}->point(0)->label( "D", "right" );
        $l{AB} = Line->join( $p{A}, $p{B}, undef, 1 );
        $l{BC} = Line->join( $p{B}, $p{C}, undef, 1 );
        $l{CD} = Line->join( $p{C}, $p{D}, undef, 1 );
        $l{DA} = Line->join( $p{D}, $p{A}, undef, 1 );

    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $l{AB}->remove;
        $l{BC}->remove;
        $l{CD}->remove;
        $l{DA}->remove;
        $p{A}->remove;
        $p{B}->remove;
        $p{C}->remove;
        $p{D}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a diameter AC through the centre of the circle E");
        $p{E} = Point->new( $pn, $c{a}->centre() )->label( "E", "topright" );
        $p{A} = $c{a}->point(90)->label( "A", "top" );
        $p{C} = $c{a}->point(-90)->label( "C", "bottom" );
        $l{AC} = Line->join( $p{A}, $p{C} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw a diameter BD, perpendicular to AC, "
                      . "through the centre of the circle E" );
        $l{BDt} = $l{AC}->perpendicular( $p{E} )->grey;
        $l{BDt}->prepend( $r * 1.1 );
        $l{BDt}->extend( $r * 1.1 );
        my @p = $c{a}->intersect( $l{BDt} );
        $p{B} = Point->new( $pn, @p[ 2, 3 ] )->label( "B", "left" );
        $p{D} = Point->new( $pn, @p[ 0, 1 ] )->label( "D", "right" );
        $l{BD} = Line->join( $p{B}, $p{D} );
        $l{BDt}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw lines AB, BC, BC, DA");
        $t1->explain("ABCD is a square");

        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{BC} = Line->join( $p{B}, $p{C} );
        $l{CD} = Line->join( $p{C}, $p{D} );
        $l{DA} = Line->join( $p{D}, $p{A} );
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
                "The two triangles ABE and AED are equal, since they have "
              . "a side (BE,ED), angle (AEB = AED = \\{right}), side (AE) equal\\{nb}(I.4)"
        );
        greyall();
        $s{ABE} = Triangle->join( $p{A}, $p{B}, $p{E} )->fill($sky_blue);
        $s{AED} = Triangle->join( $p{A}, $p{E}, $p{D} )->fill($lime_green);
        $t3->math("BE = ED");
        $t3->math("\\{angle}AEB = \\{angle}AED = \\{right}");
        $t3->math("AE is common");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Hence AB equals AD");
        $t3->math("\\{therefore} AB = AD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Similarly, it can be shown that AD is equal to CD, "
                      . "and CD equals CB, hence ABCD is an equilateral" );
        $s{DEC} = Triangle->join( $p{D}, $p{E}, $p{C} )->fill($pale_pink);
        $s{BEC} = Triangle->join( $p{B}, $p{E}, $p{C} )->fill($pale_yellow);
        $t3->math("  AB = AD = CD = CB");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "BD is the diameter of the circle, and the angle "
            . "of a semi-circle is a right angle (III.31), therefore the angle "
            . "BAD is right" );
        $s{DEC}->remove;
        $s{BEC}->remove;
        $s{AED}->remove;
        $s{ABE}->remove;
        $s{BAD} =
          Triangle->join( $p{B}, $p{D}, $p{A} )
          ->set_angles( undef, undef, " " );
        $t3->math("\\{angle}BAD = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Similarly, it can be shown that all the angles touching "
                      . "the circles are right" );
        $s{BAD}->remove;
        $a{BAD} = Angle->new( $pn, $l{AB}, $l{DA} );
        $a{ADC} = Angle->new( $pn, $l{DA}, $l{CD} );
        $a{DCB} = Angle->new( $pn, $l{CD}, $l{BC} );
        $a{CBA} = Angle->new( $pn, $l{BC}, $l{AB} );
        $l{AB}->normal;
        $l{DA}->normal;
        $l{CD}->normal;
        $l{BC}->normal;
        $t3->math("\\{angle}ADC = \\{angle}DCB = \\{angle}CBA = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "A quadilateral with all angles "
              . "right angles is, by definition, "
              . "a square"
        );

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

