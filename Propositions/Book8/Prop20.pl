#!/usr/bin/perl 
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;
use Geometry::Shortcuts ;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 140, 300 );
#my $t2 = $pn->text_box( 140, 400 );
#my $t2 = $pn->text_box( 100, 400 );
my $t5 = $pn->text_box( 140, 150, -width=>1100 );
my $tp = $pn->text_box( 300, 750, -width=>1100 );
my $t3 = $pn->text_box( 140, 150 );
my $t4 = $pn->text_box( 480, 400 );

my $unit = 10;
my $ds   = 30;

our ( %p, %c, %s, %t, %l );

my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If one mean proportional number fall between two numbers, the numbers ".
    "will be similar plane numbers";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 20
);


# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
 #   my $dys      = 200;
    my $fact = 1.0;
    my ($A, $C, $B) = Numbers->new(4,6)->find_continued_proportion(3);
    my ($D, $E) = Numbers->new($A,$C)->least_ratio();
    my $F = $A/$D;
    my $G = $B/$E;

    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @D = $line_coords->( -after=>$B, -length => $D );

    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @E = $line_coords->( -after=>$B, -length => $E );

    our @C = $line_coords->(  -xorig  => $dxs, -yskip => 1, -length => $C );
    our @F = $line_coords->(  -xorig  => $dxs, -yskip => 1, -length => $F );
    our @G = $line_coords->(  -xorig  => $dxs, -yskip => 1, -length => $G );

    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("If A,C,B are in continuous proportion ...") ;
        $make_lines->(qw(A B C));
        $t2->math("A:C = C:B");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then A and B are similar plane numbers");
        $t2->math("A ~ B, A = pq, B = ij, p:q=i:j");
    };

    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("A:C = C:B");                             # 0
        $t2->allblue;
    };

    push @$steps, sub {
        $t2->allgrey;
        $make_lines->(qw(D E));
        $t1->explain("Let D,E be the least numbers in the same ratio as A,C (VII.33)");
        $t2->math("D,E least where D:E = A:C = C:B");             # 1
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Therefore D measures A the same number of times that E ".
        "measures C (VII.20)");
        $t2->black(1);
        $t2->math("A = fD");                                # 2
        $t2->math("C = fE");                                # 3
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("As many times as D measure A, let F be that many units");
        $t2->black([2]);
        $t2->math("F = f\\{dot}1");                         # 4
        $make_lines->("F");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("And thus A is F multiplied by D, so A is a plane number");
        $t2->black([2,4]);
        $t2->math("A = F\\{dot}D");                         # 5
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Again, since D,E are the least in the same ratio as C,B, ".
        "D measures C the same number of times that E measures\\{nb}B\\{nb}(VII.20)");
        $t2->black(1);
        $t2->math("C = gD");                                # 6
        $t2->math("B = gE");                                # 7
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("As many times as E measure B, let G be that many units");
        $t2->black([7]);
        $t2->math("G = g\\{dot}1");                         # 8
        $make_lines->("G");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("And thus B is G multiplied by E, so B is a plane number");
        $t2->black([7,8]);
        $t2->math("B = G\\{dot}E");                         # 9
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since A,C is F multiplied by D,E, A is to C as D is ".
        "to E (V11.17) \\{^1}");
        $tp->footnote("\\{^1} Circular reasoning (we defined D,E to be ".
        "the same ratio as A,C)");
        $t2->black([1,2,3]);
        $t3->y($t2->y);
        $t3->math("A:C = D:E");                             # NO
    };

    push @$steps, sub {
        $t2->allgrey;
        $t3->erase;
        $t2->black([3,4,9]);
        $t1->explain("Since C,B is F,G multiplied by E, F is to G as C is to B (VII.17)");
        $t2->math("F:G = C:B");                             # 10     
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("But C to B is also equal to D to E, therefore D is to E ".
        "as F is to\\{nb}G");
        $t2->black([1,10]);
        $t2->math("D:E = F:G");                             # 11
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("And alternately D is to F as E is to G (VII.13)");
        $t2->black(11);
        $t2->math("D:F = E:G");                             # 12
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Thus A,B are both plane numbers, and are similar because ".
        "their sides are proportional");
        $t2->black([5,9,12]);
        $t2->math("A ~ B");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0,5,9,13]);
    };

    return $steps;

}

