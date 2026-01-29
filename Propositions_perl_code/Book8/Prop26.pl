#!/usr/bin/perl 
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;
use Geometry::Shortcuts;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 140, 300 );

#my $t2 = $pn->text_box( 140, 400 );
#my $t2 = $pn->text_box( 100, 400 );
my $t5 = $pn->text_box( 140, 150, -width => 1100 );
my $tp = $pn->text_box( 300, 750, -width => 1100 );
my $t3 = $pn->text_box( 140, 150 );
my $t4 = $pn->text_box( 480, 300 );

my $unit = 10;
my $ds   = 30;

our ( %p, %c, %s, %t, %l );

my ( $make_lines, $line_coords, $current_xy ) =
  Shortcuts::make_some_line_subs( $pn, $ds, $unit, \%p, \%l );

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "Similar plane numbers have to one another the ratio which a square ".
    "number has to a square number";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 26
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my ($D,$E,$F) = Numbers->new(2,3)->find_continued_proportion(3);
    my $A = 2*$D;
    my $B = 2*$F;
    my $C = 2*$E;

    our @A =
      $line_coords->( -xorig => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig => $dxs, -after=>$A, -length => $B );
    our @C = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $C );
    our @D = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $D );
    our @E = $line_coords->( -xorig => $dxs, -after=>$D, -length => $E );
    our @F = $line_coords->( -xorig => $dxs, -after=>[$D,$E], -length => $F );

    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("If A and B are similar square numbers ... ");
        $make_lines->(qw(A B));
        $t2->math("A ~ B  (similar plane)");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then the ratio of A to B can also be expressed "
        ."as a ratio of two squares");
        $t2->math("A:B = x\\{^2}:y\\{^2}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("A ~ B  (similar plane)");         # 0
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("Since A and B are similar solid numbers, one mean proportional ".
        "falls between them (VIII.18)");
        $make_lines->(qw(C));
        $t2->math("A:C = C:B");     # 1
    };

    push @$steps, sub {
        $t1->explain("Let D, E, F be the least numbers that have the same ratio ".
        "as A, C, B (VII.33) or (VIII.2)");
        $make_lines->(qw(D E F));
        $t2->allgrey;
        $t2->black(1);
        $t2->math("D:E = E:F");     # 2
        $t2->math("D:F = A:B   D,F are least numbers");     #3
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->black([2,3]);
        $t1->explain("Therefore the extremes D and F are square (VII.2.Por)");
        $t2->math("D = x\\{^2}");       # 4
        $t2->math("F = y\\{^2}");       # 5
    };

    push @$steps, sub {
        $t1->explain("And A is to B as D is to F, so the ratio of A and B ".
        "can be expressed as a ratio of two squares");
        $t2->allgrey;
        $t2->black([3,4,5]);    
        $t2->math("A:B = x\\{^2}:y\\{^2}"); # 6
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0,6]);
    };

    return $steps;

}

