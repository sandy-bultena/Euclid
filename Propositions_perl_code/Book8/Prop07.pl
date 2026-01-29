#!/usr/bin/perl 
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 140, 340 );
my $t5 = $pn->text_box( 140, 150, -width=>1100 );
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 260, 340 );
my $t4 = $pn->text_box( 800, 660, -width=>500 );

my $ds   = 30;
my $unit = 7;

our ( %p, %c, %s, %t, %l );

use Geometry::Shortcuts;
my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If there be as many numbers as we please in continued proportion, ".
    "and the first measure the last, it will measure the second\\{nb}also.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 7
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my ($A,$B,$C,$D) = Numbers->new(2,3)->find_continued_proportion(4);

    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @C = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $C );
    our @D = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $D );
    
    my $steps;


    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("A set of numbers (A through D) are continuously ".
        "proportional and the first measures the last" );
        $make_lines->(qw(A B C D));
        $t2->math("A:B = B:C = C:D");
        $t3->y($t2->y);
        $t3->math(   "S\\{_1}:S\\{_2} = S\\{_2}:S\\{_3} = S\\{_3}:S\\{_4} "
                   . "... = S\\{_n}\\{_-}\\{_1}:S\\{_n}" );
        $t2->y($t3->y);
        $t2->math("D = pA");
        $t3->math("S\\{_n} = p\\{dot}S\\{_1}");
        $t2->allblue;
        $t3->allblue;
    };


    push @$steps, sub {
        $t1->explain("Then the first will measure the second");
        $t2->math("B = qA");
        $t3->math("S\\{_2} = q\\{dot}S\\{_1}");
    };


    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof by Contradiction");
        $t2->erase;
        $t3->erase;
        $t2->math("A:B = B:C = C:D");
        $t3->y($t2->y);
        $t3->math(   "S\\{_1}:S\\{_2} = S\\{_2}:S\\{_3} = S\\{_3}:S\\{_4} "
                   . "... = S\\{_n}\\{_-}\\{_1}:S\\{_n}" );
        $t2->y($t3->y);
        $t2->math("D = pA");
        $t3->math("S\\{_n} = p\\{dot}S\\{_1}");
        $t2->allblue;
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain("Assume A does not measures B");
        $t2->down;
        $t2->allgrey;
        $t3->allgrey;
        $t3->y($t2->y);
        $t2->math("B \\{notequal} qA");
        $t3->math("S\\{_2} \\{notequal} p\\{dot}S\\{_1}");
    };

    push @$steps, sub {
        $t1->explain("Then neither will any other of the numbers "
        ."measure any other\\{nb}(VIII.6)");
        $t3->math("S\\{_n} \\{notequal} p\\{dot}S\\{_1}");
        $y = $t2->y;
        $t2->math("D \\{notequal} pA");        
    };

    push @$steps, sub {
        $t1->explain("Which is a contradiction, since A does measure D");
        $t2->allgrey;
        $t3->allgrey;
        $t3->red([-1]);
        $t2->red([-1]);
        $t3->blue([1]);
        $t2->blue([1]);
#        $t2->y($y);
        $t3->y($y);
        #$t2->math("       \\{wrong}");
        $t3->math("           \\{wrong}");
        $t2->red([-1]);
        $t3->red([-1]);
    };

    push @$steps, sub {
        $t1->explain("Thus A measures B");
        $t2->allgrey;
        $t3->allgrey;
        $t2->red(2);
        $t3->red(2);
        $t3->y($t2->y);
        $t2->math("B = qA");
        $t3->math("S\\{_2} = p\\{dot}S\\{_1}");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t3->allgrey;
        $t2->blue([0,1,-1]);
        $t3->blue([0,1,-1]);
    };

    return $steps;

}

