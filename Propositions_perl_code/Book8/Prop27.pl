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

my $unit = 5;
my $ds   = 30;

our ( %p, %c, %s, %t, %l );

my ( $make_lines, $line_coords, $current_xy ) =
  Shortcuts::make_some_line_subs( $pn, $ds, $unit, \%p, \%l );

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "Similar solid numbers have to one another the ratio which a cube ".
    "number has to a cube number";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 27
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my ($E,$F,$G, $H) = Numbers->new(2,3)->find_continued_proportion(4);
    my $A = 2*$E;
    my $B = 2*$H;
    my $C = 2*$F;
    my $D = 2*$G;

    our @A =
      $line_coords->( -xorig => $dxs, -yorig => $dys, -length => $A );
    our @C = $line_coords->( -xorig => $dxs, -after=>$B, -length => $C );
    our @B = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $B );
    our @D = $line_coords->( -xorig => $dxs, -after=>$B, -length => $D );
    our @E = $line_coords->( -xorig => $dxs, -yskip=>1, -length => $E );
    our @F = $line_coords->( -xorig => $dxs, -after=>[$E], -length => $F );
    our @G = $line_coords->( -xorig => $dxs, -after=>[$E,$F], -length => $G );
    our @H = $line_coords->( -xorig => $dxs, -after=>[$E,$F,$G], -length => $H );

    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("If A and B are similar cube numbers ... ");
        $make_lines->(qw(A B ));
        $t2->math("A ~ B  (similar cube)");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then the ratio of A to B can also be expressed "
        ."as a ratio of two cubes");
        $t2->math("A:B = x\\{^3}:y\\{^3}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("A ~ B  (similar cube)");         # 0
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("Since A and B are similar cube numbers, two mean proportionals ".
        "fall between them (VIII.19)");
        $make_lines->(qw(C D));
        $t2->math("A:C = C:D = D:B");     # 1
    };

    push @$steps, sub {
        $t1->explain("Let E, F, G, H be the least numbers that have the same ratio ".
        "as A, C, D, B (VII.33) or (VIII.2)");
        $make_lines->(qw(E F G H));
        $t2->allgrey;
        $t2->black(1);
        $t2->math("E:F = F:G = G:H");     # 2
        $t2->math("E:H = A:B   E,H are least numbers");     #3
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->black([2,3]);
        $t1->explain("Therefore the extremes E and H are cube (VII.2.Por)");
        $t2->math("E = x\\{^3}");       # 4
        $t2->math("H = y\\{^3}");       # 5
    };

    push @$steps, sub {
        $t1->explain("And A is to B as E is to H, so the ratio of A and B ".
        "can be expressed as a ratio of two cubes");
        $t2->allgrey;
        $t2->black([3,4,5]);    
        $t2->math("A:B = x\\{^3}:y\\{^3}"); # 6
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0,6]);
    };

    return $steps;

}

