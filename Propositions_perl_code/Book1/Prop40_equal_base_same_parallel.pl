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
my $title = "Equal triangles which are on equal bases and on the same side ".
"are also in the same parallels.";

my $pn = PropositionCanvas->new( -number => 40, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 250 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,40);
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

    my ( %l, %p, %c, %a, %t, %s );
    my @objs;
    my $top = 250;
    my $bot = 450;
    my @A   = ( 150, $top );
    my @B   = ( 125, $bot );
    my @D   = ( 310, $top );
    my @C   = ( $B[0] + 200, $bot );
    my @E   = ( $C[0] + 200, $bot );
    my @X   = ( $D[0] + 25, $top + 35 );

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain( "Let ABC and DCE be triangles, lying on the same line, with equal bases and equal areas" );
        $t{ABC} = Triangle->new( $pn, @A, @B, @C, 1, -points => [qw(A top B bottom C bottom)] );
        $t{DCE} = Triangle->new( $pn, @D, @C, @E, 1, -points => [qw(D top C bottom E bottom)] );
        $t{ABC}->fill($sky_blue);
        $t{DCE}->fill($lime_green);
        $t{ABC}->l(2)->label(qw(x bottom));
        $t{DCE}->l(2)->label(qw(x bottom));
        $t3->math("BC = CE");
        $t3->math("\\{triangle}ABC = \\{triangle}DCE");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The lines AD and BE are parallel");
        $l{AD} = Line->new( $pn, @A, @D )->dash;
        $l{AD}->extend(100);
        $l{AD}->prepend(100);
        $t3->math("AD \\{parallel} BE");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t3->erase;
        $t3->math("BC = CE");
        $t3->math("\\{triangle}ABC = \\{triangle}DCE");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Assume AD is not parallel to BE");
        $t1->explain( "Draw line AF, parallel to BE and passing point A and line DC" );
        $l{AD}->grey;

        $l{AX} = Line->new( $pn, @A, @X )->dash;
        $p{F} = Point->new( $pn, $l{AX}->intersect( $t{DCE}->l(1) ) )->label( "F", "topleft" );
        $t3->math("AF \\{parallel} BE");

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw line FE");
        $l{FE} = Line->new( $pn, $p{F}->coords, @E );
        $t{FCE} = Triangle->new( $pn, $p{F}->coords, @C, @E, -1 );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Triangle ABC equals FCE since AF and BE are parallel\\{nb}I.38" );
        $l{AX}->grey;

        $t{FCE}->fillover($t{DCE},$green);
        $t3->allgrey;
        $t3->math("   \\{triangle}ABC = \\{triangle}FCE");

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Which is a contradiction to the initial definition ".
        "that triangles ABC and DCE are equal" );
        $t3->allgrey;
        $t3->red([1,-1])
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Therefore the original assumption is incorrect" );
        $t3->allgrey;
        $t3->red([2]);
    };


    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Thus, line AD is parallel to BC" );
        $t{ABC}->fill($sky_blue);
        $t{FCE}->grey;
        $l{FE}->grey;
        $t3->down;
        $t3->math("   AD \\{parallel} BE");

    };


    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->blue([0,1]);
        $t3->black(-1);
    };

    return \@steps;
}

