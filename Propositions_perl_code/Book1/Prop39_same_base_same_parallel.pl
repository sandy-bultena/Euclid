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
my $title = "Equal triangles which are on the same base and on the same side ".
"are also in the same parallels.";

my $pn = PropositionCanvas->new( -number => 39, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 300 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,39);
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
    my @A   = ( 175, $top );
    my @B   = ( 125, $bot );
    my @D   = ( 350, $top );
    my @C   = ( $B[0] + 200, $bot );
    my @X   = ( $D[0] + 25, $top + 35 );

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain( "Let ABC and DBC be triangles with the same base, and equal area" );
        $t{ABC} = Triangle->new( $pn, @A, @B, @C, 1, -points => [qw(A top B bottom C bottom)] );
        $t{DBC} = Triangle->new( $pn, @D, @B, @C, 1, -points => [qw(D top B bottom C bottom)] );
        my @p = $t{ABC}->l(3)->intersect($t{DBC}->l(1));
        $t{ABC}->fill($sky_blue);
        $t{DBC}->fill($lime_green);
        $t{tBC}=Triangle->new($pn,@p,@B,@C,-1);
        $t{tBC}->fillover($t{ABC},$teal);

        $t3->math("\\{triangle}ABC = \\{triangle}DBC");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The lines AD and BC are parallel");
        $l{AD} = Line->new( $pn, @A, @D )->dash;
        $l{AD}->extend(100);
        $l{AD}->prepend(100);
        $t3->math("AD \\{parallel} BC");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t3->erase;
        $t3->math("\\{triangle}ABC = \\{triangle}DBC");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Assume AD is not parallel to BC");
        $t1->explain( "Draw line AE, parallel to BC and passing point A and line DB" );
        $l{AD}->grey;

        $l{AX} = Line->new( $pn, @A, @X )->dash;
        $p{E} = Point->new( $pn, $l{AX}->intersect( $t{DBC}->l(1) ) )->label( "E", "topleft" );
        $t3->allgrey;
        $t3->math("AE \\{parallel} BC");

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw line EC");
        $l{EC} = Line->new( $pn, $p{E}->coords, @C );
        $t{EBC} = Triangle->new( $pn, $p{E}->coords, @B, @C, -1 );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Triangle ABC equal EBC since AE and BC are parallel\\{nb}(I.37)" );
        $l{AX}->grey;

        $t{ABC}->fill($sky_blue);
        $t{EBC}->fillover($t{DBC},$green);
        $t{tBC}->fill(Colour->add($sky_blue,$green));
        $t3->math("\\{triangle}ABC = \\{triangle}EBC");

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Which is a contradiction to the initial definition ".
        "that triangles ABC and DBC are equal");
        $t3->allgrey;
        $t3->red([0,-1]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore the original assumption is incorrect");
        $t3->allgrey;
        $t3->red(1);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore, line AD must be parallel to BC");
        $t{ABC}->fill($sky_blue);
        $t{EBC}->grey;
        $t{DBC}->fill($lime_green);
        $t{tBC}->fill($teal);
        $t{EBC}->grey;
        $l{EC}->grey;
        $t3->down;
        $t3->math("AD \\{parallel} BC");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->blue(0);
        $t3->black(-1);
    };

    return \@steps;
}

