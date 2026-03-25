#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Geometry::Canvas::PropositionCanvas;

# ============================================================================
# Definition
# ============================================================================
my $title = "To cut off from the greater of two "
  . "given unequal straight lines a straight line equal to the less.";

my $pn = PropositionCanvas->new( -number => 3, -title => $title );
Proposition::init($pn);
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 600, 430 );

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,3);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;


# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my @objs;

    my @A = ( 150, 450 );
    my @B = ( 250, 450 );
    my @C = ( 350, 350 );
    my @D = ( 600, 350 );
    my $rAB = sqrt(($A[0]-$B[0])**2 + ($A[1]-$B[1])**2);
    my $rCD = sqrt(($C[0]-$D[0])**2 + ($C[1]-$D[1])**2);
    my @F = ($D[0],$D[1]+$rAB-$rCD);
    my @steps;

    # ------------------------------------------------------------------------
    # In other words
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Start with line AB and line CD, where CD is larger than AB");

        $p{A} = Point->new($pn,@A)->label( 'A', 'left' );
        $p{B} = Point->new($pn,@B)->label( 'B', 'right' );
        $l{AB} = Line->new($pn, @A, @B );

        $p{C} = Point->new($pn,@C)->label( 'C', 'bottom' );
        $p{D} = Point->new($pn,@D)->label( 'D', 'bottom' );
        $l{CD} = Line->new($pn, @C, @D );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Construct a line that is equal to CD minus AB");
        $p{F} = Point->new($pn,@F)->label("F","right");
        $l{DF} = Line->new($pn,@D,@F)->blue;
    };

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("Construction:");
        $l{DF}->remove;
        $p{F}->remove;
        $t1->explain("Start with line AB and line CD");

        $p{A} = Point->new($pn,@A)->label( 'A', 'left' );
        $p{B} = Point->new($pn,@B)->label( 'B', 'right' );
        $l{AB} = Line->new($pn, @A, @B );

        $p{C} = Point->new($pn,@C)->label( 'C', 'bottom' );
        $p{D} = Point->new($pn,@D)->label( 'D', 'bottom' );
        $l{CD} = Line->new($pn, @C, @D );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Construct line segment CE equal to AB\\{nb}(I.2)");

        ( $l{CE}, $p{E}) = $l{AB}->copy( $p{C} );
        $p{E}->label( "E", 'top' );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {

        $t1->explain("Draw a circle with C as the center and CE as the radius");
        $c{E} = Circle->new($pn, $p{C}->coords, $p{E}->coords );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Define the intersection of the circle and CD as F");

        my @ps = $c{E}->intersect( $l{CD} );
        $p{F} = Point->new($pn,@ps)->label( "F", "topright" );
        $l{CF} = Line->new($pn, @C, $p{F}->coords );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $c{E}->grey;
        $l{CE}->grey;

        $t1->explain("Line DF is the difference between line CD and line AB");
        $l{DF} = Line->new($pn, @D, $p{F}->coords );
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{CE}->normal;
        $l{CD}->green;
        $l{DF}->grey;
        $l{CF}->grey;

        $t1->down;
        $t1->title("Proof:");
        $t1->explain("AB is equal to CE (I.2)");

        $l{AB}->label( "x", "top" );
        $l{CE}->label( "x", "top" );
        $l{CD}->label( "y", "bottom" );
        
        $t2->math("CD = y");
        $t2->math("AB = CE = x");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{CF}->normal;

        $t1->explain("Line CF and line CE are radii of the same circle");
        $l{CF}->label( "x", "top" );
        $t2->math("CE = CF = x");
        $t2->down;
        $t2->math("AB = CF = x");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Line DF is the difference between CD and CF");
        $l{DF}->label( "y-x", "top" );
        $t2->math("DF = CD - CF");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{CE}->grey;
        $l{CD}->label;
        $l{DF}->raise;
        $l{DF}->red;

        $t1->explain("Line DF is the difference between CD and AB");
        $t2->math("DF = CD - AB");
    };

    # ------------------------------------------------------------------------
    return \@steps;
}
