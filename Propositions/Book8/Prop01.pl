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
my $t2 = $pn->text_box( 300, 200 );
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 400, 160 );
my $t4 = $pn->text_box( 700, 160 );

our ( %p, %c, %s, %t, %l );

my $ds  = 30;
my $unit = 10;
use Geometry::Shortcuts;
    my ($make_lines, $line_coords, $current_xy ) = 
            Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If there be as many numbers as we please in continued proportion, and ".
    "the extremes of them be prime to one another, the numbers are the least ".
    "of those which have the same ratio with them";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 1
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $dxs  = 100;
    my $dys = 200;
    
    my $p = 1.5;
    my $A = 4;
    my $B = $A*$p;
    my $C = $B*$p;
    my $D = $C*$p;
    my $E = 3;
    my $F = $A*$p;
    my $G = $B*$p;
    my $H = $C*$p;
    
    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @C = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $C );
    our @D = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $D );
    our @E = $line_coords->( -xorig  => $dxs, -yskip => 2, -length => $E );
    our @F = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $F );
    our @G = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $G );
    our @H = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $H );

    my $steps;
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "If we have a series of numbers in continued proportion, "
        ."and the first and last are prime to one another," );
       
        $make_lines->(qw(A B C D ));
        $t2->math("A:B = B:C = C:D");
        $t2->math("gcd(A,D) = 1");
        $t2->allblue;

    };

    push @$steps, sub {
        $t1->explain( "Then the series of numbers are the lowest possible numbers "
        ."that have the ratio of the first to the second" );
       
        $t2->down();
        $t2->mathsmall("S={(i,j,k,l)|i,j,k,l\\{elementof}\\{natural}, i:j=j:k=k:l=A:B}");
        $t2->mathsmall("(A,B,C,D)\\{elementof}S \nsuch that A\\{lessthanorequal}i, ".
        "B\\{lessthanorequal}j, C\\{lessthanorequal}k, D\\{lessthanorequal}l ".
        "\\{forall}(i,j,k,l)\\{elementof}S");
    };

    push @$steps, sub {
        $t2->down;
        $t2->math("A,B,C,D are least numbers in the ratio of A:B"); 
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof by Contradiction");

        $t2->erase;
        $t2->math("A:B = B:C = C:D");
        $t2->math("gcd(A,D) = 1");
        $t2->allblue();
    };

    push @$steps, sub {
        $t1->explain("Let E,F,G,H be numbers smaller than A,B,C,D, but with ".
        "the same ratio");
        $make_lines->(qw(E F G H ));
        
        $t2->down;
        $t2->math("E:F = F:G = G:H");
        $t2->math("E:F = A:B");
        $t2->math("E < A");
    };

    push @$steps, sub {
        $t1->explain("Since A,B,C,D are in the same ratio with E,F,G,H, ".
        "and the number of numbers in the ratios (4) is equal...");
        $t1->explain("... A is to D as E is to H (VII.14)");
        $t2->allgrey();
        $t2->black([-2,-3]);
        $t2->blue(0);
        $t2->math("A:D = E:H");
    };

    push @$steps, sub {
        $t1->explain("But A and D are relatively prime, thus they are ".
        "the least numbers to represent the ratio A:D\\{nb}(VII.21)");
        $t2->down;
        $t2->allgrey();
        $t2->blue(1);
        $t2->math("A,D are least numbers");
        $t2->down; 
    };

    push @$steps, sub {
        $t1->explain("Thus, since A,D are the smallest numbers to represent ".
        "the ratio A:D and E:H, A measures\\{nb}E, and ".
        "D measures\\{nb}H\\{nb}(VII.20)");
        $t2->allgrey();
        $t2->black([-1,-2]);
        $t2->math("E = n\\{dot}A");
        $t2->math("H = m\\{dot}D");
    };

    push @$steps, sub {
        $t1->explain("Which is impossible if E is less than A");
        $t2->allgrey();
        $t2->red([4,-2]);
    };

    push @$steps, sub {
        $t1->explain("Thus there are no numbers smaller than A,B,C,D ".
        "which are of the same ratio");
        $t2->allgrey();
        $t2->blue([0,1]);
        $t2->down;
        $t2->math("A,B,C,D are least numbers in the ratio of A:B"); 
    };

    push @$steps, sub {
        $t2->blue([-1]);
    };
    


    return $steps;

}

