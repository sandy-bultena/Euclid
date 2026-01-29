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
    "In any triangle, if one of the sides is produced, "
  . "then the exterior angle equals the sum of the two "
  . "interior and opposite angles, and the sum of the three "
  . "interior angles of the triangle equals two right angles.";

my $pn = PropositionCanvas->new( -number => 32, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 500 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,32);
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

    my @B = ( 75,  400 );
    my @A = ( 250, 200 );
    my @C = ( 350, 400 );

    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a triangle ABC, and line BC extended to point\\{nb}D");
        $t{ABC} = Triangle->new(
                                 $pn, @A, @B, @C, 1,
                                 -points => [qw(A top B bottom C bottom)],
                                 -angles => [qw(\\{gamma} \\{alpha} \\{beta})],
                               );
        $l{BC} = $t{ABC}->l(2)->clone->extend(200);
        $p{D} = Point->new( $pn, $l{BC}->end )->label( "D", "bottom" );
        ( $l{BC}, $l{CD} ) = $l{BC}->split( $t{ABC}->p(3) );
        $l{BC}->remove;

        $a{DCA} = Angle->new( $pn, $l{CD}, $t{ABC}->l(3), -size => 60 )->label("\\{delta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Angle DCA is equal to the sum of ABC and CAB");
        $t2->math("\\{delta} = \\{gamma} + \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The sum of the angles BCA, ABC and CAB is two right angles");
        $t2->math("\\{beta} + \\{gamma} + \\{alpha} = \\{right}+\\{right}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create a line parallel to AB, at point C\\{nb}(I.31)");
        $a{DCA}->grey;
        $l{CE} = $t{ABC}->l(1)->parallel($t{ABC}->p(3) );
        $t{ABC}->grey;
        $t{ABC}->l(1)->normal;
        $t{ABC}->p(1)->normal;
        $t{ABC}->p(2)->normal;
        $t{ABC}->p(3)->normal;
        $l{CD}->grey;

        $p{E} = Point->new( $pn, $l{CE}->start )->label( "E", "top" );
        ( $l{CE}, $l{XC} ) = $l{CE}->split( $t{ABC}->p(3) );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{AB} = $t{ABC}->l(1)->clone->prepend(40);
        $l{AB}->extend(40);
        $l{CD}->grey;
        $t{ABC}->a(1)->normal;
        $t{ABC}->l(3)->normal;

        $t1->explain("Since lines AB and CE are parallel, and line AC crosses them, then angles BAC and ACE are equal (I.29)");

        $a{ECA} = Angle->new( $pn, $l{CE}, $t{ABC}->l(3), -size => 20 )->label("\\{gamma}");
        $t3->math("\\{angle}BAC = \\{angle}ACE = \\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{ABC}->normal;
        $l{CD}->normal;
        $t{ABC}->l(3)->grey;
        $t{ABC}->a(1)->grey;
        $t{ABC}->a(3)->grey;
        $a{ECA}->grey;

        $t1->explain("Since lines AB and CE are parallel, and line BC crosses them, then angles ABC and ECD are equal (I.29)")
          ;

        $a{ECD} = Angle->new( $pn, $l{CD}, $l{CE}, -size => 25 )->label("\\{alpha}");
        $t3->math("\\{angle}ABC = \\{angle}ECD = \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{ABC}->normal;
        $a{ECA}->normal;
        $a{DCA}->normal;

        $t1->explain("Angle ACD equals the sum of angles ACE and ECD");
        $t3->math("\\{delta} = \\{gamma} + \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The sum of angles ACD and ACB is two right angles\\{nb}(I.13)");
        $t3->math("\\{beta} + \\{delta} = \\{right}+\\{right}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore sum of angles ACE, ECD, and ACB is two right angles");
        $t3->math("\\{beta} + \\{gamma} + \\{alpha} = \\{right}+\\{right}");
    };

    return \@steps;
}

