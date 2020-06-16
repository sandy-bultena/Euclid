#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
    "To construct a rectilinear angle equal to a given rectilinear angle "
  . "on a given straight line and at a point on it.";

my $pn = PropositionCanvas->new( -number => 23, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 475 );
my $t3 = $pn->text_box( 820, 150, -width=>460 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,23);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #23
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my @objs;

    my @A = ( 75,  650 );
    my @B = ( 400, 700 );
    my @C = ( 75,  400 );
    my @D = ( 225, 200 );
    my @E = ( 350, 400 );
    my @steps;

    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Given an angle and a line AB");
        $l{CD} = Line->new($pn, @C, @D );
        $l{CD2} = $l{CD}->clone->extend( 50);
        $p{C} = Point->new($pn,@C)->label( "C", "left" );
        $l{CE} = Line->new($pn, @C, @E );
        $l{CE2} = $l{CE}->clone->extend( 50 );
        $a{alpha} = Angle->new($pn, $l{CE}, $l{CD} )->label("\\{alpha}");
        $p{A} = Point->new($pn,@A)->label( "A", "left" );
        $p{B} = Point->new($pn,@B)->label( "B", "right" );
        $l{AB} = Line->new($pn, @A, @B );
    };
    push @steps, sub {
        $t1->explain("Draw a new line on point A such that it forms ".
        "an angle equivalent to the original");
        @objs = $a{alpha}->copy($p{A},$l{AB});
        $objs[1]->label("\\{alpha}");
        
    };
    
    
    
    push @steps, sub {
        $t1->clear;
        foreach my $obj (@objs) {
            $obj->remove;
        }
        $t1->title("Construction");
    };

    push @steps, sub {
        $t1->explain( "Define points D and E at random on "
              . "the two lines defining the angle" );
        $p{D} = Point->new($pn,@D)->label( "D", "right" );
        $p{E} = Point->new($pn,@E)->label( "E", "bottom" );
        $l{CD}->label( "e", "left" );
        $l{CE}->label( "d", "bottom" );
    };
    push @steps, sub {
        $t1->explain("Construct triangle DCE by constructing the line DE");
        $l{DE} = Line->new($pn, @D, @E );
        $l{DE}->label( "c", "right" );
    };
    push @steps, sub {
        $t1->explain(
                "Copy this triangle onto line segment AB, using the methods "
              . "described in I.22" );
        $t3->y($t1->y);
        $t1->explain("-");
        $t3->explain("Copy length CE to AF (I.2)");
        $t2->math("AF = CE");
        ( $l{AF}, $p{F} ) = $l{CE}->copy_to_line( $p{A}, $l{AB} );
        $p{F}->label( "F", "bottom" );
        $l{AF}->label( "d", "bottom" );
    };
    push @steps, sub {
        $t1->y($t3->y);
        $t1->explain("-");
        $t3->explain(
                "Copy length CD, start at point A (I.2), and then construct "
              . "a circle with radius CD" );
        ( $l{AG}, $p{G} ) = $l{CD}->copy( $p{A} );
        $p{G}->remove;
        $c{A} = Circle->new($pn, @A, $p{G}->coords );
        $l{AG}->grey;
        $l{AG}->label( "e", "left" );
    };
    push @steps, sub {
        $t1->y($t3->y);
        $t1->explain("-");
        $t3->explain(
                "Copy length DE, start at point F (I.2), and then construct "
              . "a circle with radius DE" );
        ( $l{FH}, $p{H}) = $l{DE}->copy( $p{F} );
        $p{H}->remove;
        $c{F} = Circle->new($pn, $p{F}->coords, $p{H}->coords );
        $l{FH}->grey;
        $l{FH}->label( "c", "right" );
    };

    push @steps, sub {
        $t1->y($t3->y);
        $t1->explain("-");
        $t3->explain( "Construct triangle AFG, where G is the intersection "
              . "of the two circles" );
        $l{FH}->remove;
        $l{AG}->remove;
        $t2->math("AG = CD");
        $t2->math("FG = ED");
        my @p = $c{F}->intersect( $c{A} );
        $p{G} = Point->new($pn, @p[0,1] )->label( "G", "top" );
        $c{F}->grey;
        $c{A}->grey;
        $l{AG} = Line->new($pn, @A,            $p{G}->coords );
        $l{FG} = Line->join( $p{F}, $p{G});
        $l{FG}->label( "c", "right" );
        $l{AG}->label( "e", "left" );
    };
    push @steps, sub {
        $t1->y($t3->y);
        $t1->explain("Angle GAF is equal to DCE");
        $a{GAF} = Angle->new($pn, $l{AB}, $l{AG} )->label("\\{alpha}");
    };
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t1->explain(
                "Two triangles where all three sides are equivalent, have "
              . "equivalent angles (I.8)" );
        $c{F}->remove;
        $c{A}->remove;
    };
    push @steps, sub {
        $l{FG}->remove;
        $l{DE}->remove;
    };
    return \@steps;
}

