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
my $title =
    "If a straight line falling on two straight lines "
  . "makes the exterior angle equal to the interior and opposite "
  . "angle on the same side, or the sum of the interior angles "
  . "on the same side equal to two right angles, then the straight "
  . "lines are parallel to one another.";

my $pn = PropositionCanvas->new( -number => 28, -title => $title );
my $t1 = $pn->text_box( 800, 140, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 400, 200, -width => 600 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,28);
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
    my @E = ( 325, 300 );
    my @F = ( 200, 600 );
    my @G = ( 750, 425 );

    my @steps;

    # -------------------------------------------------------------------------
    # Definition
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->title("Definition - Parallel Lines");
        $t3->normal( "Parallel straight lines are straight lines which, "
              . "being in the same plane and being produced indefinitely "
              . "in both directions, do not meet one another in "
              . "either direction." );
        $l{1} = Line->new($pn, @A, @B );
        $l{2} = Line->new($pn, @C, @D );
        for my $i ( 1 .. 800 ) {
            $l{1}->extend(1);
            $l{2}->extend(1);
        }
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->erase;
        $t3->title( "Definition - Exterior to Interior and Opposite Angle"
              . " on the Same Side" );
        $t3->normal( "If a line EF intersect two straight lines AB and CD at "
              . "the points G and H, and the exterior angle is EGB, "
              . "then the interior and opposite angle on the same side is GHD"
        );

        $p{1} = Point->new($pn, $l{1}->start )->label( "A", "top" );
        $p{2} = Point->new($pn, $l{1}->end )->label( "B", "top" );
        $p{3} = Point->new($pn, $l{2}->start )->label( "C", "top" );
        $p{4} = Point->new($pn, $l{2}->end )->label( "D", "top" );
        $l{3} = Line->new($pn, @E, @F );
        $p{8} = Point->new($pn,@E)->label( "E", "top" );
        $p{9} = Point->new($pn,@F)->label( "F", "bottom" );

        $p{6} = Point->new($pn, $l{1}->intersect( $l{3} ) )->label( "G", "topleft" );
        $p{7} = Point->new($pn, $l{2}->intersect( $l{3} ) )->label( "H", "bottom" );

        ( $l{4}, $l{5} ) = $l{1}->split( $p{6} );
        ( $l{6}, $l{7} ) = $l{2}->split( $p{7} );
        ( $l{8}, $l{9}, $l{10} ) = $l{3}->split( $p{6}, $p{7} );

        $a{1} = Angle->new($pn, $l{5}, $l{8}, -size => 20 )->label("\\{alpha}");
        $a{4} = Angle->new($pn, $l{7}, $l{9}, -size => 20 )->label("\\{delta}");

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        foreach my $o ( values %a, values %l, values %p ) {
            $o->remove;
        }
        $t3->erase;
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given two straight lines AB and CD");

        $p{A} = Point->new($pn,@A)->label( "A", "top" );
        $p{B} = Point->new($pn,@B)->label( "B", "top" );
        $l{AB} = Line->new($pn, @A, @B );

        $p{C} = Point->new($pn,@C)->label( "C", "top" );
        $p{D} = Point->new($pn,@D)->label( "D", "top" );
        $l{CD} = Line->new($pn, @C, @D );

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "And a third line EF that intersects "
              . "lines AB and CD at points G and H" );

        $p{E} = Point->new($pn,@E)->label( "E", "top" );
        $p{F} = Point->new($pn,@F)->label( "F", "bottom" );
        $l{EF} = Line->new($pn, @E, @F );
        $p{G} =
          Point->new($pn, $l{AB}->intersect( $l{EF} ) )->label( "G", "topleft" );
        $p{H} = Point->new($pn, $l{CD}->intersect( $l{EF} ) )->label( "H", "bottom" );

        ( $l{AG}, $l{GB} ) = $l{AB}->split( $p{G} );
        ( $l{CH}, $l{HD} ) = $l{CD}->split( $p{H} );
        ( $l{EG}, $l{GH}, $l{HF} ) = $l{EF}->split( $p{G}, $p{H} );

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "1. If angles EGB and GHD are equal, then the lines "
              . "AB and CD are parallel" );
        $a{EGB} = Angle->new($pn, $l{GB}, $l{EG}, -size => 20 )->label("\\{alpha}");
        $a{GHD} = Angle->new($pn, $l{HD}, $l{GH}, -size => 20 )->label("\\{delta}");
        $t2->math("if \\{alpha} = \\{delta}");
        $t2->math("=> AB \\{parallel} CD");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "2. If angles BGH and GHD added together equal "
              . "two right angles, then the lines "
              . "AB and CD are parallel" );
        $a{DGH} = Angle->new($pn, $l{GH}, $l{GB}, -size => 30 )->label("\\{beta}");
        $a{EGB}->label;
        $t2->down;
        $t2->math("if \\{beta} + \\{delta} = \\{right}+\\{right}");
        $t2->math("=> AB \\{parallel} CD");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $a{EGB}->label("\\{alpha}");
        $a{DGH}->remove;
        $t1->down;
        $t2->erase;
        $t2->math("\\{alpha} = \\{delta}");
        $t2->down;
        $t2->allblue;
        
        $t1->title("Proof 1");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Angle AGH equals EGB (I.15), equals GHD");
        $a{AGH} = Angle->new($pn, $l{AG}, $l{GH}, -size => 20 )->label("\\{alpha}'");
        $t2->math("\\{alpha}' = \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since AGH and GHB are opposite interior angles, "
              . "and they are equal, lines AB and CD are parallel (I.27)" );
        $t2->math("AB \\{parallel} CD");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->blue(0);
        $t2->black(-1);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t2->erase;
        $t2->math("\\{delta} + \\{beta} = \\{right}+\\{right}");
        $t2->allblue;
        $t1->title("Proof 2");
        $t2->down;
        $a{AGH}->remove;
        $a{EGB}->remove;
        $a{DGH}->draw->label("\\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
            "The sum of the EGB and BGH are " . "two right angles (I.13)" );
        $t2->math("\\{alpha} + \\{beta} = \\{right}+\\{right}");
        $a{EGB}->draw->label("\\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since the sum of GHD and GHD are also two right angles, "
              . "the sum of EGB and DGH are equal" );
        $t2->math("\\{alpha} + \\{beta} = \\{delta} + \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Remove the common angle DGH and we have angle EGB "
              . "equal to GHD" );
              $t2->allgrey;
              $t2->black(-1);
        $t2->math("\\{alpha} = \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Angle AGH equals EGB (I.15), equals GHD");

        $a{AGH} = Angle->new($pn, $l{AG}, $l{GH}, -size => 20 )->label("\\{alpha}'");
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("\\{alpha}' = \\{alpha} = \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since AGH and GHB are opposite interior angles, "
              . "and they are equal, lines AB and CD are parallel (I.27)" );
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("AB \\{parallel} CD");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->blue(0);
        $t2->black(-1);
    };

    return \@steps;
}

