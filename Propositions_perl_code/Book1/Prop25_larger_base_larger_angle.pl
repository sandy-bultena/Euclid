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
    "If two triangles have two sides equal to "
  . "two sides respectively, but have the base greater "
  . "than the base, then they also have the one of the angles "
  . "contained by the equal straight lines greater than the other.";

my $pn = PropositionCanvas->new( -number => 25, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 475 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,25);
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

    my @A = ( 200, 150 );
    my @B = ( 75,  350 );
    my @C = ( 375, 350 );
    my @D = ( 100, 660 );
    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain( "Given two triangles ABC and DEF, where "
              . "lengths AB equals DE and AC equals DF, "
              . "but the base BC is greater than the base EF" );

        $t{ABC} = Triangle->new(
            $pn, @A, @B, @C,1,
            -points => [qw(A top B left C right)],
            -angles => ["\\{alpha}"],
            -labels => [qw(c left a bottom b right)],
        );

        $t{DEF} = Triangle->SSS(
            $pn, @D, $t{ABC}->l(1)->length,
            $t{ABC}->l(2)->length - 100, $t{ABC}->l(3)->length,1,
            -points => [qw(D top E left F right)],
            -angles => ["\\{delta}"],
            -labels => [qw(c left d bottom b right)],
        );

        $t2->math("AB = DE = c");
        $t2->math("AC = DF = b");
        $t2->math("BC > EF, a > d");
        $t2->allblue;

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Angle CAB is greater than angle FDE");
        $t2->down;
        $t2->math("\\{alpha} > \\{delta}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof by contradiction");
        $t2->erase;
        $t2->math("AB = DE = c");
        $t2->math("AC = DF = b");
        $t2->math("BC > EF, a > d");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Assume angle CAB is equal to angle FDE");
        $t2->down;
        $t2->allgrey;
        $t2->math("\\{alpha} = \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Then length BC would equal EF because the ".
        "side-angle-side of both triangles are equal (I.4)" );
        $t2->blue([0,1]);
        $t2->black(-1);
        $t2->math("=> BC = EF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "which leads to a contradiction" );
        $t2->allgrey;
        $t2->red([-1,2]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Therefore the original assumption that the angles ".
        "CAB and FDE are equal is also wrong" );
        $t2->allgrey;
        $t2->red(-2);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Assume angle CAB is less than angle FDE");
        $t2->allgrey;
        $t2->down;
        $t2->math("\\{alpha} < \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Then length BC would less than EF, since it is ".
        "the triangle with the lesser angle (I.24), " );
        $t2->allgrey;
        $t2->blue([0,1]);
        $t2->black(-1);
        $t2->math("=> BC < EF ");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "which leads to a contradiction" );
        $t2->allgrey;
        $t2->red([-1,2]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Therefore the original assumption that the angles ".
        "CAB is less than FDE is also wrong" );
        $t2->allgrey;
        $t2->red(-2);
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore angle CAB is greater than FDE");
        $t2->down;
        $t2->red(3);
        $t2->math("\\{therefore} \\{alpha} > \\{delta}");
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->black(-1);
        $t2->blue([0..2]);
    };
    return \@steps;
}

