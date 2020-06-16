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
my $title = "The opposite angles of quadrilaterals in circles "
  . "are equal to two right angles.";

$pn->title( 22, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 520, 180 );
my $t5 = $pn->text_box( 520, 180 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 22 );
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

    my @c1 = ( 250, 380 );
    my $r1 = 180;
    my $f  = 0.6;
    my $ao = 40 * 3.14159 / 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->erase;
        $t4->title("In other words");
        $t4->explain(
                "If a quadilateral ABCD is drawn within a circle, then the "
              . "sum of the angles at A and C (\\{alpha} and \\{gamma}) equals two right angles, "
              . "similarly, the angles at B and D (\\{beta} and \\{delta}) sum to two right angles"
        );
        $c{A}  = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $p{A}  = $c{A}->point( 90 + 45 )->label(qw(A top));
        $p{B}  = $c{A}->point(40)->label( "  B", "top" );
        $p{C}  = $c{A}->point(-50)->label( "C", "bottom" );
        $p{D}  = $c{A}->point(-100)->label( "D", "bottom" );
        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{BC} = Line->join( $p{B}, $p{C} );
        $l{CD} = Line->join( $p{C}, $p{D} );
        $l{DA} = Line->join( $p{D}, $p{A} );

        $a{A} = Angle->new( $pn, $l{DA}, $l{AB} )->label("\\{alpha}");
        $a{B} = Angle->new( $pn, $l{AB}, $l{BC} )->label("\\{beta}");
        $a{C} = Angle->new( $pn, $l{BC}, $l{CD} )->label("\\{gamma}");
        $a{D} = Angle->new( $pn, $l{CD}, $l{DA} )->label( "   \\{delta}", 20 );

        $t3->math("\\{alpha} + \\{gamma} = 2\\{right}");
        $t3->math("\\{delta} + \\{beta} = 2\\{right}");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof");
        $t3->erase;
        $t5->math("\\{angle}A = \\{alpha}, \\{angle}B = \\{beta},");
        $t5->math("\\{angle}C = \\{gamma}, \\{angle}D = \\{delta}");
        $t5->down;
        $t5->allblue;
        $t3->y( $t5->y );
        $t1->y( $t4->y );
    };

    push @$steps, sub {
        $t4->explain("Draw the lines AC and BD");
        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{BD} = Line->join( $p{B}, $p{D} );
    };

    push @$steps, sub {
        $t4->explain(   "The sum of the angles inside the triangle "
                      . "ABC equals two right angles (I.32)" );
        $l{BD}->grey;
        $l{DA}->grey;
        $l{CD}->grey;
        $a{A}->grey;
        $a{D}->grey;
        $a{C}->grey;
        $s{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($sky_blue);
        $a{CAB} = Angle->new( $pn, $l{AC}, $l{AB} )->label( "\\{epsilon}", 50 );
        $a{ACB} = Angle->new( $pn, $l{BC}, $l{AC} )->label( "\\{lambda}",  50 );
        $t3->math("\\{epsilon} + \\{lambda} + \\{beta} = 2\\{right}");
    };

    push @$steps, sub {
        $t4->explain( "Angle CAB is equal to angle BDC because they are in the "
                      . "same circular segment (III.21)" );
        $s{ABC}->remove;
        $l{BD}->normal;
        $l{CD}->normal;
        $a{ACB}->grey;
        $a{B}->grey;
        $l{BC}->red;
        $a{CDB} = Angle->new( $pn, $l{CD}, $l{BD} )->label( "\\{epsilon}", 65 );
        $a{A2} = Arc->newbig( $pn, $r1, $p{B}->coords, $p{C}->coords )->red;
        $t3->grey;
        $t3->math("\\{angle}CAB = \\{angle}BDC = \\{epsilon}");
    };

    push @$steps, sub {
        $t4->explain(   "Angle ACB is equal to angle ADB because they are "
                      . "in the same circular segment (III.21)" );
        $l{BD}->normal;
        $l{CD}->grey;
        $l{DA}->normal;
        $a{ACB}->normal;
        $a{CDB}->grey;
        $a{CAB}->grey;
        $a{B}->grey;
        $l{AB}->red;
        $l{BC}->normal;
        $a{ADB} = Angle->new( $pn, $l{BD}, $l{DA} )->label( "\\{lambda}", 45 );
        $a{A3} = Arc->newbig( $pn, $r1, $p{A}->coords, $p{B}->coords )->red;
        $a{A2}->remove;
        $t3->math("\\{angle}ACB = \\{angle}ADB = \\{lambda}");
    };

    push @$steps, sub {
        $t4->explain(
                "The angle at D is equal to the sum of the angles ADC and BCD");
        $l{AC}->grey;
        $l{BC}->grey;
        $l{AB}->grey;
        $a{A3}->remove;
        $l{CD}->normal;
        $a{D}->normal;
        $a{ACB}->grey;
        $a{CDB}->normal;
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("\\{delta} = \\{epsilon} + \\{lambda}");
    };

    push @$steps, sub {
        $t4->explain( "So the sum of the angles as B and D is equal to the sum "
            . "of the angles at B (\\{beta}), ADB (\\{lambda}), and BDC (\\{epsilon})"
        );
        $l{BD}->grey;
        $l{AB}->normal;
        $l{BC}->normal;
        $a{B}->normal;
        $t3->allgrey;
        $t3->black( [-1] );
        $t3->down;
        $t3->math("\\{angle}B + \\{angle}D ");
        $t3->math("= \\{beta} + \\{delta}");
        $t3->math("= \\{beta} + \\{epsilon} + \\{lambda}");
    };

    push @$steps, sub {
        $t4->explain("Which is equal to two right angles");
        $t3->allgrey;
        $t3->black( [ 0, -1 ] );
        $t3->math("= 2\\{right}");
    };

    push @$steps, sub {
        $t4->explain("Similarly ... ");
        $a{B}->grey;
        $a{CDB}->grey;
        $a{ACB}->normal;
        $a{A}->normal;
        $l{BD}->normal;
        $l{BC}->grey;
        $l{CD}->grey;
        $s{ABD} = Triangle->join( $p{A}, $p{B}, $p{D} )->fill($sky_blue);
        $a{ABD} = Angle->new( $pn, $l{AB}, $l{BD} )->label( "\\{theta}", 50 );
        $t3->down;
        $t3->allgrey;
        $t3->math("\\{alpha} + \\{theta} + \\{lambda} = 2\\{right}");
    };

    push @$steps, sub {
        $l{CD}->normal;
        $l{AC}->normal;
        $l{BC}->grey;
        $l{DA}->green;
        $s{ABD}->remove;
        $c{AD} = Arc->newbig( $pn, $r1, $p{D}->coords, $p{A}->coords )->green;

        $a{ACD} = Angle->new( $pn, $l{AC}, $l{CD} )->label( "\\{theta}", 35 );
        $t3->math("\\{angle}DBA = \\{angle}ACD = \\{theta}");
    };

    push @$steps, sub {
        $l{BC}->normal;
        $l{AC}->grey;
        $l{BD}->grey;
        $l{DA}->normal;
        $c{AD}->remove;

        $t3->allgrey;
        $t3->black( [-2] );
        $t3->math("\\{angle}A + \\{angle}C");
        $t3->math("= \\{alpha} + \\{theta} + \\{lambda}");
        $t3->math("= 2\\{right}");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ 4, 7, 10, 12 ] );
    };

    return $steps;

}

