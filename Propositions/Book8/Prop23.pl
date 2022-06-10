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
    "If four numbers be in continued proportion, and the first be ".
    "cube, the fourth will also be cube";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 23
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;

    my ( $A, $B, $C, $D ) = Numbers->new( 2, 3 )->find_continued_proportion(4);
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
        $t1->explain("If A,B,C,D are in continuous proportion ...");
        $make_lines->(qw(A B C D));
        $t2->math("A:B = B:C = C:D");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... and A is a cube");
        $t2->math("A = x\\{^3}");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then D is also a cube");
        $t2->math("D = y\\{^3}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
         $t2->math("A:B = B:C = C:D");            # 0
        $t2->math("A = x\\{^3}");      # 1
       $t2->allblue;
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain(   "Since there exists two mean numbers between A and D, ".
        "A\\{nb}and D are similar solid numbers (VIII.22)");
        $t2->blue([0,1]);
        $t2->math("A ~ D");      # 2
        $t2->math("D = y\\{dot}z\\{dot}a");     # 3
        $t2->math("x:x:x = y:z:a");         # 4
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->black([4,3]);
        $t1->explain("Thus D is a cube");
        $t2->math("y:z:a = 1, \\{therefore} y = z = a");  # 5
        $t2->math("D = y\\{dot}y\\{dot}y = y\\{^3}");         # 6
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0,1,6]);
    };

    return $steps;

}

