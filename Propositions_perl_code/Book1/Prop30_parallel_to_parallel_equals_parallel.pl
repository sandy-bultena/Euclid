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
my $title = "Straight lines parallel to the same straight line are also parallel to one another.";

my $pn = PropositionCanvas->new( -number => 30, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 400, 200, -width => 600 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,30);
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

    my @A = ( 100, 350 );
    my @B = ( 425, 350 );
    my @C = ( 100, 500 );
    my @D = ( 425, 500 );
    my @E = ( 100, 600 );
    my @F = ( 425, 600 );
    my @G = ( 150, 250 );
    my @K = ( 350, 650 );

    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given two lines AB and CD which are both parallel to\\{nb}EF");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $l{AB} = Line->new( $pn, @A, @B );

        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $l{CD} = Line->new( $pn, @C, @D );

        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );
        $l{EF} = Line->new( $pn, @E, @F );
        $t2->math("if  AB \\{parallel} EF");
        $t2->math("and CD \\{parallel} EF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then lines AB and CD are parallel to each other");
        $t2->math("then AB \\{parallel} CD");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Construct a fourth line GK such that it intersects lines AB, CD and EF");

        $t2->clear;
        $t2->math("if  AB \\{parallel} EF");
        $t2->math("and CD \\{parallel} EF");
        $t2->down;

        $l{GK} = Line->new( $pn, @G, @K );
        $p{G} = Point->new( $pn, $l{AB}->intersect( $l{GK} ) )->label( "G", "topleft" );
        $p{H} = Point->new( $pn, $l{CD}->intersect( $l{GK} ) )->label( "H", "topleft" );
        $p{K} = Point->new( $pn, $l{EF}->intersect( $l{GK} ) )->label( "K", "topleft" );

        ( $l{AG}, $l{GB} ) = $l{AB}->split( $p{G} );
        ( $l{CH}, $l{HD} ) = $l{CD}->split( $p{H} );
        ( $l{EK}, $l{KF} ) = $l{EF}->split( $p{K} );
        ( $l{XG}, $l{GH}, $l{HK}, $l{KY} ) = $l{GK}->split( $p{G}, $p{H}, $p{K} );

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Since lines AB and EF are parallel, angle AGH equals HKF (I.29)");
        $a{AGH} = Angle->new( $pn, $l{AG}, $l{GH}, -size => 30 )->label("\\{alpha}");
        $a{HKF} = Angle->new( $pn, $l{KF}, $l{HK}, -size => 30 )->label("\\{gamma}");
        $t2->math("AB \\{parallel} EF");
        $t2->math("\\{alpha} = \\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Since lines CD and EF are parallel, angle GHD equals HKF (I.29)");
        $a{AGH} = Angle->new( $pn, $l{HD}, $l{GH}, -size => 30 )->label("\\{beta}");
        $t2->down;
        $t2->math("CD \\{parallel} EF");
        $t2->math("\\{beta} = \\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore angles AGH and GHD are equal");
        $a{HKF} = Angle->new( $pn, $l{KF}, $l{HK}, -size => 30 )->label("\\{gamma}");

        $t2->down;
        $t2->math("\\{alpha} = \\{gamma} = \\{beta}");
        $t2->math("\\{alpha} = \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since angles AGH and GHD are equal and they are opposite, then lines AB and CD are parallel (I.28)" )
          ;
        $t2->down;
        $t2->math("\\{therefore} AB \\{parallel} CD");
    };

    return \@steps;
}

