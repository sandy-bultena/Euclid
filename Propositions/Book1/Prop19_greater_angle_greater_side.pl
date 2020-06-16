#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title = "A greater angle of a triangle is opposite a greater side.";

my $pn = PropositionCanvas->new( -number => 19, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 430 );
my $t3 = $pn->text_box( 300, 250 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,19);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #19
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @D = ( 450, 450 );
    my @B = ( 100, 400 );
    my @A = ( 75,  150 );
    my @C = ( 350, 400 );
    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a triangle ABC");
        $t{ABC} = Triangle->new($pn,
            @A, @B, @C,1,
            -points => [ qw(A top B bottom C bottom) ],
            -labels => [ qw(c left a bottom b right) ],
            -angles => [ qw(\\{alpha} \\{beta} \\{gamma}) ],
        );
        $t2->math("\\{beta} > \\{alpha}    \\{beta} > \\{gamma}");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "If angle ABC is greater than angle BCA and CAB, "
              . "then the side AC is greater than the other two sides of the triangle"
        );
        $t2->math("b > a    b > c");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->erase;
        $t2->math("\\{beta} > \\{alpha}    \\{beta} > \\{gamma}");
        $t2->allblue;
        $t2->down;

        $t1->down;
        $t1->title("Proof by contradiction");
        $t1->explain( "If AC is not greater than AB, "
              . "then it must be less than or equal to AB" );
              $t2->math("AC \\{lessthanorequal} AB");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "If line AC equals AB, then the triangle would be "
              . "an isosceles triangle, where angle ABC equals angle ACB (I.5)"
        );
        $t2->down;
        $t2->math("AC = AB");
        $t2->math("\\{beta} = \\{gamma}");
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "But we have already stated that angle ABC "
              . "is greater than angle BCA, so we have a contradiction" );
        $t2->allgrey;
        $t2->red(0);
        $t2->black(-2);
        $t2->red(-1);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Because we have a contradiction, ".
        "the original assumption that AC equals AB cannot be true");
        $t2->allgrey;
        $t2->blue(0);
        $t2->red(2);
    };


    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->down;
        $t1->explain( "If line AC is less than AB, then by the previous "
              . "proposition, angle BCA would be larger than angle ABC (I.18)"
        );
        $t2->allgrey;
        $t2->blue(0);
        $t2->black(1);
        $t2->math("AC < AB");
        $t2->math("\\{beta} < \\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "But we have already stated that angle ABC "
              . "is greater than angle BCA, so we have a contradiction" );
              $t2->allgrey;
              $t2->red([0,5]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Because we have a contradiction, ".
        "the original assumption that AC is less than AB cannot be true");
        $t2->allgrey;
        $t2->blue(0);
        $t2->red(4);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore, AC is greater than AB");
        $t2->down;
        $t2->red([1,2,4]);
        $t2->math("\\{therefore} AC > AB");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->blue(0);
        $t2->black(-1);
    };


    # -------------------------------------------------------------------------
    return \@steps;
}

