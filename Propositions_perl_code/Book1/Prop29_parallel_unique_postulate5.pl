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
    "A straight line falling on parallel straight lines "
  . "makes the alternate angles equal to one another, the exterior "
  . "angle equal to the interior and opposite angle, and the sum "
  . "of the interior angles on the same side equal to two right angles.";

my $pn = PropositionCanvas->new( -number => 29, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 175 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,29);
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
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given with two parallel lines AB and CD");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $l{AB} = Line->new( $pn, @A, @B );

        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $l{CD} = Line->new( $pn, @C, @D );

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "And a third line EF such that it intersects lines AB and CD at points G and H" );

        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "bottom" );
        $l{EF} = Line->new( $pn, @E, @F );
        $p{G} = Point->new( $pn, $l{AB}->intersect( $l{EF} ) )->label( "G", "topleft" );
        $p{H} = Point->new( $pn, $l{CD}->intersect( $l{EF} ) )->label( "H", "bottom" );

        ( $l{AG}, $l{GB} ) = $l{AB}->split( $p{G} );
        ( $l{CH}, $l{HD} ) = $l{CD}->split( $p{H} );
        ( $l{EG}, $l{GH}, $l{HF} ) = $l{EF}->split( $p{G}, $p{H} );

        $a{alpha} = Angle->new( $pn, $l{GB}, $l{EG}, -size => 20 )->label("\\{alpha}");
        $a{delta} = Angle->new( $pn, $l{HD}, $l{GH}, -size => 20 )->label("\\{delta}");
        $a{gamma} = Angle->new( $pn, $l{AG}, $l{GH}, -size => 20 )->label("\\{gamma}");
        $a{beta} = Angle->new( $pn, $l{GH}, $l{GB}, -size => 30 )->label("\\{beta}");

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
             "Then angles AGH and GHD are equal, angles EGB and GHD are equal, " 
             . "angles BGH and GHD added together equal two right angles" );
        $t2->math("if AB \\{parallel} CD");
        $t2->math("=> \\{gamma} = \\{delta}");
        $t2->math("=> \\{alpha} = \\{delta}");
        $t2->math("=> \\{beta} + \\{delta} = \\{right}+\\{right}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t2->math("AB \\{parallel} CD");
        $t2->down;
        $t2->allblue;
        $t1->title("Proof by Contradiction");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Assume that AGH is greater than GHD");
        $t3->y( $t2->y );
        $a{alpha}->grey;
        $a{beta}->grey;
        $t2->allgrey;
        $t2->math("\\{gamma} > \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Add the angle BGH to both");
        $a{beta}->normal;
        $t2->math("\\{gamma}+\\{beta} > \\{delta}+\\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "The sum of angles BGH and AGH is equal to "
                      . "two right angles (I.13), thus angles GHD and BGH "
                      . "are less than two right angles" );
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("\\{gamma}+\\{beta} = \\{right}+\\{right} ");
        $t2->math("      \\{right}+\\{right} > \\{delta}+\\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "If the sum of the angles BGH and GHD is "
                      . "less than two right angles, the lines (if extended) will "
                      . "eventually meet (postulate 5), and hence "
                      . "are not parallel" );
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("AB \\{notpara} CD");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->red([0,-1]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("This is a contradiction, and hence our original assumption was wrong");
        $t2->allgrey;
        $t2->red(1);
        $t3->math("          \\{wrong}");
        $t3->red;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->down;
        $t1->down;
        $t1->explain("Therefore AGH equals GHD");
        $t2->math("\\{gamma} = \\{delta}");
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->blue(0);
        $t3->allgrey;
        $t2->black(-1);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Angle EGB equals AGH (I.15) and AGH equals GHD");
        $t2->down;
        $a{alpha}->normal;
        $a{beta}->grey;
        $t2->allgrey;
        $t2->black(-1);
        $t2->down;
        $t2->math("\\{alpha} = \\{gamma} = \\{delta}");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Add angle BGH to EGB and GHD");
        $t2->math("\\{beta}+\\{alpha} = \\{beta}+\\{delta}");
        $a{gamma}->grey;
        $a{beta}->normal;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
                     "The sum of EGB and BGH is two right angles, " );
                     $t2->allgrey;
                     $t2->black(-1);
        $t2->math("\\{beta}+\\{alpha} = \\{right}+\\{right}");
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->explain(
                     "therefore the sum of BGH and GHD is also two right angles" );
        $t2->math("\\{beta}+\\{delta} = \\{right}+\\{right} ");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->blue(0);
        $t2->black([-1,-4]);
        $a{gamma}->normal;
    };

    return \@steps;
}

