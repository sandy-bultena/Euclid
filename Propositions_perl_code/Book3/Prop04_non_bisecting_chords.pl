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
my $title = "If in a circle two straight lines cut one another "
  . "which are not through the center, they do not bisect one another.";

$pn->title( 4, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 4 );
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
        $t1->title("In other words ");
        $t1->explain(   "Let two straight lines AC and BD, not passing through "
                      . "the center of the circle, intersect at point E" );
        $t1->explain("\\{dot} AC and BD do not bisect each other");

        $c{C} = Circle->new( $pn, @c, $c[0] + $r, $c[1] );
        $p{D} = $c{C}->point(20)->label(qw(D topright));
        $p{B} = $c{C}->point(270)->label(qw(B bottom));
        $p{A} = $c{C}->point(190)->label( "A", "bottomleft" );
        $p{C} = $c{C}->point(-30)->label( "C", "bottomright" );

        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{BD} = Line->join( $p{B}, $p{D} );
        $p{E} =
          Point->new( $pn, $l{AC}->intersect( $l{BD} ) )->label(qw(E bottom));

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by contradiction");
        $t1->explain("Assume AE equals EC and BE equals ED");
        $t3->explain("Assume ...");
        $t3->math("AE = EC, BE = ED");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Find (III.1) the center of the circle (F) and join FE");
        $p{F} = Point->new( $pn, $c{C}->center )->label(qw(F topright));
        $l{FE} = Line->join( $p{F}, $p{E} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since FE is a line passing through the center of a "
                      . "circle, bisecting AC, a line not through the center, "
                      . "then the angle FEA (\\{alpha}) is right (III.3)" );
        $l{AE} = Line->join( $p{A}, $p{E}, -1 );
        $a{FEA} = Angle->new( $pn, $l{FE}, $l{AE} )->label( "\\{alpha}", 20 );
        $l{BD}->grey;
        $t2->y( $t3->y );
        $t2->math("\\{alpha} = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(  "Since FE is a line passing through the center of "
                     . "a circle, bisecting BD, a line not through the center, "
                     . "then the angle FEB (\\{beta}) is right (III.3)" );
        $l{BE} = Line->join( $p{B}, $p{E}, -1 );
        $a{FEB} = Angle->new( $pn, $l{FE}, $l{BE} )->label( "\\{beta}", 60 );
        $l{BD}->normal;
        $l{AC}->grey;

        $t2->allgrey;
        $t2->math("\\{beta} = \\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "If \\{alpha} and \\{beta} are both right angles, "
                      . "they are equal to each other" );
        $t2->allblack;
        $l{AC}->normal;
        $t2->math("\\{alpha} = \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "But \\{beta} is larger than \\{alpha}, "
                      . "which is inconsistent with the previous statement" );
        $t2->math("\\{alpha} < \\{beta}");
        $t1->down;
        $t2->allgrey;
        $t2->red( [ -1, -2 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
               "Hence lines AC and BD cannot both be bisected at point\\{nb}E");
        $t2->allgrey;
        $t3->allgrey;
        $t3->red(1);
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{FE}->remove;
        $a{FEA}->remove;
        $a{FEB}->remove;
        $p{F}->remove;
        $t3->allgrey;
        $t2->down;
        $t2->math("AE \\{notequal} EC, BE \\{notequal} ED");
    };

    return $steps;

}

