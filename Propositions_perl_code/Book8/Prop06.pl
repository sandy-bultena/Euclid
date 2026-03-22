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
my $t5 = $pn->text_box( 140, 150, -width => 1100 );
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 260, 340 );
my $t4 = $pn->text_box( 800, 660, -width => 500 );

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
    "If there be as many numbers as we please in continued proportion, "
  . "and the first do not measure the second, neither will any other "
  . "measure any other\\{^1}.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 6
);



# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my ( $A, $B, $C, $D, $E ) =
      Numbers->new( 2, 3 )->find_continued_proportion(5);
    my ( $F, $G, $H ) = Numbers->new( 2, 3 )->find_continued_proportion(3);

    our @A = $line_coords->( -xorig => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig => $dxs, -yskip => 1,    -length => $B );
    our @C = $line_coords->( -xorig => $dxs, -yskip => 1,    -length => $C );
    our @D = $line_coords->( -xorig => $dxs, -yskip => 1,    -length => $D );
    our @E = $line_coords->( -xorig => $dxs, -yskip => 1,    -length => $E );
    our @F = $line_coords->( -xorig => $dxs, -yskip => 1,    -length => $F );
    our @G = $line_coords->( -length => $G );
    our @H = $line_coords->( -length => $H );

    my $steps;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->footnote(
                "\\{^1} This proposition assumes the numbers are in "
              . "increasing order. "
              . "If they are not, then the theorem should state that if the "
              . "last number does not "
              . "measure the second to last number... etc"
        );
        $t4->allgreen;
        $t1->title("In other words");
        $t1->explain("Five numbers A through E are continuously "
                   . "proportional and the first does not measure the second" );
        $make_lines->(qw(A B C D E));
        $t2->math("A:B = B:C = C:D = D:E");
        $t3->y($t2->y);
        $t3->math(   "S\\{_1}:S\\{_2} = S\\{_2}:S\\{_3} = S\\{_3}:S\\{_4} "
                   . "... = S\\{_n}\\{_-}\\{_1}:S\\{_n}" );
        $t3->math("S\\{_i} < S\\{_j}, i < j");
        $t2->y($t3->y);
        $t2->math("B \\{notequal} pA");
        $t3->math("S\\{_2} \\{notequal} p\\{dot}S\\{_1}");
        $t2->allblue;
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain(   "None of the numbers will measure any other later "
                      . "number in the series " );
        $t3->math("S\\{_j} \\{notequal} q\\{dot}S\\{_i}, i < j");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof");
        $t2->erase;
        $t3->erase;
        $t2->math("A:B = B:C = C:D = D:E");
        $t3->y($t2->y);
        $t3->math(   "S\\{_1}:S\\{_2} = S\\{_2}:S\\{_3} = S\\{_3}:S\\{_4} "
                   . "... = S\\{_n}\\{_-}\\{_1}:S\\{_n}" );
        $t3->math("S\\{_i} < S\\{_j}, i < j");
        $t2->y($t3->y);
        $t2->math("B \\{notequal} pA");
        $t3->math("S\\{_2} \\{notequal} p\\{dot}S\\{_1}");
        $t2->allblue;
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain( "Since A does not measure B, then none of the numbers "
            . "measure the next one in series, because they are all proportional "
        );
        $t3->allgrey;
        $t3->blue(2);
        $t2->allgrey;
        $t2->blue(1);
        $t3->math("S\\{_i}\\{_+}\\{_1} \\{notequal} p\\{dot}S\\{_i}");
        $t2->y($t3->y);
    };

    push @$steps, sub {
        $t1->explain("Does A measures C?");
        $t2->allgrey;
        $t3->allgrey;
        $t2->down;
        $t2->math("C = qA?");
    };

    push @$steps, sub {
        $t1->explain( "For as many numbers in the sequence A through C, make a "
            . "new sequence with the same length (F,G,H) that are comprised of the least "
            . "numbers in the same proportion to A,B,C (VII.33)" );
        $t2->allgrey;
        $make_lines->(qw(F G H));
        $t2->math("A:B:C = F:G:H   F,G,H are least numbers");
    };

    push @$steps, sub {
        $t1->explain(
                "Since the length of the sequence A,B,C is the same length "
              . "as F,G,H, and they are equal, then A is to C as F is to H (VII.14)"
        );
        $t2->math("A:C = F:H");
    };

    push @$steps, sub {
        $t1->explain(
                "And since A is to B as F is to G, and A does not measure B, "
              . "then F does not measure G. Therefore F is not a unit (number one), "
              . "for the unit measures any number (VII Def.20)" );
        $t2->allgrey;
        $t2->black( [-2] );
        $t2->blue(  [1] );
        $t2->math("G \\{notequal} qF \\{therefore} F \\{notequal} 1");
    };

    push @$steps, sub {
        $t1->explain( "Since F,G,H are the least numbers in that ratio, F and "
                      . "H are relatively prime (VIII.3)" );
        $t2->allgrey;
        $t2->black( [-3] );
        $t2->math("gcd(F,H) = 1,  H \\{notequal} pF");
    };

    push @$steps, sub {
        $t1->explain( "Since A is to C as F is to H, and F does not measure H, "
                      . "A does not measure C" );
        $t2->allgrey;
        $t2->black( [ -3, -1 ] );
        $t2->math("C \\{notequal} qA");
    };

    push @$steps, sub {
        $t1->explain(   "Similarly we can demonstrate that any number in the "
                      . "sequence does not measure another" );
        $t2->allgrey;
        $t2->black(-1);
        $t3->y($t2->y);
        $t3->math("S\\{_j} \\{notequal} q\\{dot}S\\{_i}, i < j");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t3->blue([0,1,2,-1]);
    };

    return $steps;

}

