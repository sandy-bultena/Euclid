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
    "If two numbers have to one another the ratio which a a square number ".
    "has to a square number, and the first be square, the second will ".
    "also be square";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 24
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my $c = 2;
    my $C = $c*$c;
    my $d = 3;
    my $D = $d*$d;
    my $a = 4;
    my $A = $a*$a;
    my $B = $D/$C * $A; # A:B = C:D   

    our @A =
      $line_coords->( -xorig => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $B );
    our @C = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $C );
    our @D = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $D );

    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("If A and B are in the same proportion as two square ".
        "numbers, C and D, ... ");
        $make_lines->(qw(A B C D));
        $t2->math("C = p\\{^2}");
        $t2->math("D = q\\{^2}");
        $t2->math("A:B = C:D");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... and A is a square");
        $t2->math("A = x\\{^2}");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then B is also a square");
        $t2->math("B = y\\{^2}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("C = p\\{^2}");  # 0
        $t2->math("D = q\\{^2}");  # 1
        $t2->math("A:B = C:D");    # 2
        $t2->math("A = x\\{^2}");  # 3
        $t2->allblue;
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since C and D are square numbers, they are similar plane ".
        "numbers");
        $t2->blue([0,1]);
        $t2->math("C ~ D");      # 4
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->black([4]);
        $t1->explain("Therefore there is one mean proportional number that ".
        "falls between C and D (VIII.18)");
        $t2->math("C:G = G:D");     # 5
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([2]);
        $t2->black(5);
        $t1->explain("Since A and B are in the same proportion as C and D, ".
        "then one mean proportional number also falls between A and B (VIII.8)");
        $t2->math("A:E = E:B");     # 6
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->black([6]);
        $t2->blue([3]);
        $t1->explain("Since A is a square, therefore B is also a square (VIII.22)");
        $t2->math("B = y\\{^2}");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0..3,7]);
    };

    return $steps;

}

