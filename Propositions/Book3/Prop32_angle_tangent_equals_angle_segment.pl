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
    "If a straight line touch a circle, and from the point of contact "
  . "there be drawn across, in the circle, a straight line cutting the circle, "
  . "the angles which it makes with the tangent will be equal to the angles in "
  . "the alternate segments of the circle.";

$pn->title( 32, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 520, 200 );
my $t2 = $pn->text_box( 400, 500 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 32 );
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

    my @c1 = ( 280, 380 );
    my $r1 = 190;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("In other words");
        $t4->explain("Let EF be a line that touches a circle at point B");

        $c{1} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{E} =
          Point->new( $pn, $c1[0] - $r1, $c1[1] + $r1 )->label( "E", "bottom" );
        $p{F} =
          Point->new( $pn, $c1[0] + $r1, $c1[1] + $r1 )->label( "F", "bottom" );
        $p{B} = Point->new( $pn, $c1[0], $c1[1] + $r1 )->label( "B", "bottom" );
        $l{EB} = Line->join( $p{E}, $p{B} );
        $l{BF} = Line->join( $p{B}, $p{F} );

    };

    push @$steps, sub {
        $t4->explain("Let an arbitrary line cut the circle from B to D");
        $p{D} = $c{1}->point(60)->label( "D", "top" );
        $l{BD} = Line->join( $p{B}, $p{D} );
    };

    push @$steps, sub {
        $t4->explain(   "Then, the angle EBD will be equal to the angle in "
                      . "the alternate segment DCB" );
        $a{EBD} = Angle->new( $pn, $l{BD}, $l{EB} )->label( "\\{theta}", 50 );
        $p{C} = $c{1}->point(15)->label( "C", "right" );
        $l{DC} = Line->join( $p{D}, $p{C} )->green;
        $l{CB} = Line->join( $p{C}, $p{B} )->green;
        $a{BCD} = Angle->new( $pn, $l{DC}, $l{CB}, )->label("\\{lambda}");
        $t3->math("\\{theta} = \\{lambda}");
    };

    push @$steps, sub {
        $t4->explain(
                "Conversely, angle DBF will be equal to the segment angle DAB");
        $a{BCD}->grey;
        $a{EBD}->grey;
        $l{DC}->grey;
        $l{CB}->grey;
        $p{A} = $c{1}->point(125)->label( "A", "left" );
        $l{DA} = Line->join( $p{D}, $p{A} )->green;
        $l{AB} = Line->join( $p{A}, $p{B} )->green;
        $a{DBF} = Angle->new( $pn, $l{BF}, $l{BD} )->label(" \\{beta}");

        $a{BAD} = Angle->new( $pn, $l{AB}, $l{DA}, )->label("\\{alpha}");
        $t3->math("\\{alpha} = \\{beta}");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->erase;
        $t3->erase;
        $t4->title("Proof");
        $l{DA}->grey;
        $l{AB}->grey;
        $a{DBF}->grey;
        $a{BAD}->grey;
    };

    push @$steps, sub {
        $t4->explain("Draw the line BA such that it is perpendicular to EF");
        $l{AB}->remove;
        $l{DA}->remove;
        $l{AB}->remove;
        $p{A}->remove;
        $p{A} = Point->new( $pn, $c1[0], $c1[1] - $r1 )->label( "A", "top" );
        $l{AB} = Line->join( $p{A}, $p{B} );
        $a{ABE} = Angle->new( $pn, $l{AB}, $l{EB} );
        $a{BAD}->remove;
        $t3->math("\\{angle}EBA = \\{angle}ABF = \\{right}");
    };

    push @$steps, sub {
        $t4->explain( "Since EF touches the circle at B, and BA is "
            . "perpendicular to EF, BA is a diameter of the circle\\{nb}(III.19)"
        );
        $p{c} = Point->new( $pn, @c1 );
        $t3->math("AB = diameter");
    };

    push @$steps, sub {
        $t4->explain(
            "Thus ADB is a semicircle, and the angle ADB is right\\{nb}(III.31)"
        );
        $l{AD} = Line->join( $p{A}, $p{D} );
        $a{ADB} = Angle->new( $pn, $l{AD}, $l{BD} );
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{angle}ADB = \\{right}");
    };

    push @$steps, sub {
        $t4->explain(   "The remaining angles of the triangle ABC "
                      . "(\\{gamma},\\{alpha}) sum to one right angle (I.32)" );
        $s{ABD} = Triangle->join( $p{A}, $p{B}, $p{D} )->fill($pale_yellow);
        $a{BAD} = Angle->new( $pn, $l{AB}, $l{AD} )->label("\\{alpha}");
        $a{ABD} = Angle->new( $pn, $l{BD}, $l{AB} )->label( "\\{gamma}", 60 );
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{alpha} + \\{gamma} = \\{right}");
    };

    push @$steps, sub {
        $t4->explain( "Angle ABF is right, which is equal to "
            . "\\{gamma} plus \\{beta}, therefore \\{alpha} is equal to \\{beta}"
        );
        $s{ABD}->remove;
        $a{DBF}->normal;
        $a{DBF}->label("\\{beta}");
        $t3->allgrey;
        $t3->black( [ 0, -1 ] );
        $t3->math("\\{beta} + \\{gamma} = \\{right}");
        $t3->math("\\{alpha} = \\{beta}");
    };

    push @$steps, sub {
        $t4->explain(   "In the quadilateral ABCD, the angles at A and C sum "
                      . "to two right angles (III.22)" );
        $s{ABD}->remove;
        $s{ABCD} = Polygon->join( 4, $p{A}, $p{B}, $p{C}, $p{D} )->fill($sky_blue);
        $a{BCD}->normal;
        $l{BD}->grey;
        $t3->down;
        $t3->allgrey;
        $t3->math("\\{alpha} + \\{lambda} = 2\\{right}");
        $a{ABD}->grey;
        $a{DBF}->grey;
        $a{ADB}->grey;
    };

    push @$steps, sub {
        $t4->explain("If \\{alpha},\\{lambda} equals two right angles,");
        $t3->math("  \\{lambda} = 2\\{right} - \\{alpha}");
        $l{c} = Line->join( $p{c}, $p{B} );
        $a{BAD}->grey;
        $l{AB}->grey;
        $l{AD}->grey;
        $l{BD}->normal;
        $l{DC}->normal;
        $l{CB}->normal;
        $a{EBD}->normal;
        $s{ABCD}->remove;

        $a{ABD}->normal;
        $a{DBF}->grey;
        $a{ADB}->grey;
    };

    push @$steps, sub {
        $t4->explain("and \\{alpha},\\{gamma} equals one right angle, ");
        $t3->allgrey;
        $t3->black(-5);
        $t3->math("  \\{alpha} = \\{right} - \\{gamma}");
    };

    push @$steps, sub {
        $t4->explain(
                   "then \\{lambda} " . "equals a right angle plus \\{gamma}" );
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("  \\{lambda} = 2\\{right} - \\{right} + \\{gamma}");
        $t3->math("\\{lambda} = \\{right} + \\{gamma}");
    };

    push @$steps, sub {
        $t4->explain(   "But angle EBD (\\{theta}) equals one right angle "
                      . "plus \\{gamma}, thus \\{theta} equals \\{gamma}" );
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{theta} = \\{right} + \\{gamma}");
        $t3->math("\\{therefore} \\{theta} = \\{lambda}");
    };

    push @$steps, sub {
        $a{ABD}->grey;
        $a{DBF}->normal;
        $l{AB}->normal;
        $a{BAD}->normal;
        $l{AD}->normal;
        $a{ABE}->grey;
        Triangle->join( $p{A}, $p{B}, $p{D} )->fill($pale_yellow);
        Triangle->join( $p{B}, $p{D}, $p{C} )->fill($sky_blue);
        $t3->allgrey;

        $t3->black( [ -1, 5 ] );
    };

    return $steps;

}

