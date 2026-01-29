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
    "If three numbers be in continued proportion, and the first be square, ".
    "the third will also be square";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 22
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;

    my ( $A, $B, $C ) = Numbers->new( 2, 3 )->find_continued_proportion(3);
    our @A =
      $line_coords->( -xorig => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $B );
    our @C = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $C );

    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("If A,B,C are in continuous proportion ...");
        $make_lines->(qw(A B C ));
        $t2->math("A:B = B:C");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... and A is a square");
        $t2->math("A = x\\{squared}");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then C is also a square");
        $t2->math("C = y\\{squared}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
         $t2->math("A:B = B:C");            # 0
        $t2->math("A = x\\{squared}");      # 1
       $t2->allblue;
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain(   "Since between A,C, there exists one mean number, ".
        "A and C are similar plane numbers (VIII.20)");
        $t2->blue([0,1]);
        $t2->math("A ~ C");      # 2
        $t2->math("C = y\\{dot}z");     # 3
        $t2->math("x:x = y:z");         # 4
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->black([4,3]);
        $t1->explain("Thus C is a square");
        $t2->math("y:z = 1, \\{therefore} y = z");  # 5
        $t2->math("C = y\\{dot}y = y\\{squared}");         # 6
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0,1,6]);
    };

    return $steps;

}

