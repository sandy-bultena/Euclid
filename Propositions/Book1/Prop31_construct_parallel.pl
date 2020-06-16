#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

# ============================================================================
# Definitions
# ============================================================================
my $title = "To draw a straight line through a given point parallel to a given straight line.";

my $pn = PropositionCanvas->new( -number => 31, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 400, 200, -width => 600 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,31);
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

    my ( %l, %p, %c, %a, %t );
    my @objs;

    my @A = ( 225, 350 );
    my @C = ( 425, 500 );
    my @B = ( 100, 500 );
    my @D = ( 175, 500 );

    my @steps;

    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain($title);  # no need to paraphrase
    };
    
    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Construction");
        $t1->explain("Start with line BC and point A not on line BC");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $l{BC} = Line->new( $pn, @B, @C );

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Define a point D on the line BC, and create line AD");
        $p{D} = Point->new( $pn, @D )->label( "D", "bottom" );
        ( $l{BD}, $l{DC} ) = $l{BC}->split( $p{D} );

        $l{AD} = Line->new( $pn, @A, @D );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Copy angle ADC on line AD at point A\\{nb}(I.23)");
        $a{ADC} = Angle->new( $pn, $l{DC}, $l{AD} )->label("\\{delta}");
        ( $l{EA}, $a{EAD} ) = $a{ADC}->copy( $p{A}, $l{AD}, "negative" );
        $l{EA}->normal;
        $p{E} = Point->new( $pn, $l{EA}->end )->label( "E", "top" );
        $a{EAD}->label("\\{delta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Extend line EA to AF");
        $l{EA}->prepend(200);
        $p{F} = Point->new( $pn, $l{EA}->start )->label( "F", "top" );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Line EF is parallel to BC");
        $t2->math("EF \\{parallel} BC");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t2->math("\\{angle}EAD = \\{angle}ADC");
        $t1->explain( "Angles EAD and ADC are equal and opposite angles, " . "therefore lines EF and BC are parallel (I.27)" );
    };

    return \@steps;
}

