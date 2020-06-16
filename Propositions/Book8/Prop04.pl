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
my $t2 = $pn->text_box( 100, 340 );
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 400, 160 );
my $t4 = $pn->text_box( 455, 340 );

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "Given as many ratios as we please in least numbers, to find numbers in ".
    "continued proprotion which are the least in the given ratios";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 4
);

our ( %p, %c, %s, %t, %l );

sub make_lines {
    my @letters = @_;
    foreach my $e (@letters) {
        no strict;
        $p{$e} = Point->new( $pn, @$e[ 0, 1 ] )->label( $e, "left" );
        $l{$e} = Line->new( $pn, @$e );
    }
}

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $ds       = 30;
    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my $unit     = 7;

    my $A = 2;
    my $B = 3;
    my $C = 5;
    my $D = 7;
    my $E = 3; # 11;
    my $F = 4; # 13;
    my $G = Numbers->new($B,$C)->lcm();
    my $H = $G/$A * $A;
    my $K = $G/$C * $D;
    my $L = $K/$E * $F;
    my $M = $B;
    my $N = $C;
    my $O = $D;
    print "$G, $H, $K, $L\n";

    our @A = ( $dxs, $dys, $dxs + $A * $unit, $dys );
    $dxs = $dxs + $A * $unit + 2 * $ds;
    our @B = ( $dxs, $dys, $dxs + $B * $unit, $dys );

    $dxs = $dxs_orig;
    $dys = $dys + $ds;
    our @C = ( $dxs, $dys, $dxs + $C * $unit, $dys );
    $dxs = $dxs + $C * $unit + 2 * $ds;
    our @D = ( $dxs, $dys, $dxs + $D * $unit, $dys );

    $dxs = $dxs_orig;
    $dys = $dys + $ds;
    our @E = ( $dxs, $dys, $dxs + $E * $unit, $dys );
    $dxs = $dxs + $E * $unit + 2 * $ds;
    our @F = ( $dxs, $dys, $dxs + $F * $unit, $dys );

    $dxs = $dxs_orig;
    $dys = $dys + $ds;
    our @G = ( $dxs, $dys, $dxs + $G * $unit, $dys );
    $dxs = $dxs + $G * $unit + 2 * $ds;
    our @H = ( $dxs, $dys, $dxs + $H * $unit, $dys );
    $dxs = $dxs + $H * $unit + 2 * $ds;
    our @K = ( $dxs, $dys, $dxs + $K * $unit, $dys );

    $dxs = $dxs_orig;
    $dys = $dys + $ds;
    our @L = ( $dxs, $dys, $dxs + $L * $unit, $dys );

    my $steps;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "Given a series of ratios in least numbers, A to B, ".
        "C to D, and E to F" );

        make_lines(qw(A B C D E F));

        $t2->math("A,B is least of A:B");
        $t2->math("C,D is least of C:D");
        $t2->math("E,F is least of E:F");
    };

    push @$steps, sub {
        $t1->explain("Find a series of least numbers in continued proportion, ".
        "where the first two have the ratio A to B, where the second and third ".
        "have the ratio to C to D, etc");
        $t2->down;
        $t2->math("Find the least numbers H,G,K,L such that");
        $t2->math("A:B = H:G");
        $t2->math("C:D = G:K");
        $t2->math("E:F = K:L");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Contruction");
        $t2->erase;
        $t2->math("A,B, C,D, E,F are least of A:B, C:D, E:F");
        $t2->allblue();
    };

    push @$steps, sub {
        $t1->explain("Let G be the lowest common multiple of B,C");
        $t2->math("G = lcm(B,C) = nB = mC");
        make_lines(qw(G));
    };

    push @$steps, sub {
        $t1->explain("Let H be the same multiple of A as B is to G");
        $t2->math("H = nA");
        make_lines(qw(H));
    };

    push @$steps, sub {
        $t1->explain("Let K be the same multiple of D as C is to G");
        make_lines(qw(K));
        $t2->math("K = mD");
    };

    push @$steps, sub {
        $t1->title("Assume that E measures K");
        $t2->math("K = pE");
    };

    push @$steps, sub {
        $t1->explain("Let L be the same multiple of F as E is to K");
        $t2->math("L = pF");
        make_lines("L");
    };

    push @$steps, sub {
        $t1->explain("Then A is to B as H is to G, and C is to ".
        "D as G is to K and E is to F as K is to L and H,G,K,L are the least "
        ."numbers which are in these proportions");
        $t2->math("A:B = H:G");
        $t2->math("C:D = G:K");
        $t2->math("E:F = K:L");
    };

    push @$steps, sub {
        $t1->explain("And H,G,K,L are the least numbers with these ratios");
        $t2->math("H,G,K,L are the least with the above ratios");
    };
    

    # -------------------------------------------------------------------------
    # Example
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Example");
        $t1->explain("Assume\\{^1}");
        $t1->point("a perfect ratio of salt to pepper, 2:3");
        $t1->point("a perfect ratio of pepper to garlic 2:5");
        $t1->point("and a perfect ratio of garlic to oregano 3:7");
        $t1->down;
        $t1->math("A:B=2:3, C:D=2:5, E:F=3:7");
        $t1->math("G = lcm(3,2) = 6 = 2B = 3C");
        $t1->math("H = 2A = 4");
        $t1->math("K = 3D = 15");
        $t1->math("K = 5E");
        $t1->math("L = 5F = 35");
        $t1->down;
        $t1->math("4:6:15:35");
        $t1->down;
        $t1->explain("Gives a 4:6:15:35 ratio of salt, pepper, ".
        "garlic, oregano for a perfect spice blend");
        $t1->down;
        $t1->sidenote("\\{^1}Disclaimer: I made these numbers up... I am not a cook!");
    };
    
    # -------------------------------------------------------------------------
    # Proof 1
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof (E measures K) - Ratios");
        $t2->erase;
        $t2->math("A,B, C,D, E,F are least of A:B, C:D, E:F");
        $t2->allblue();
        $t2->math("G = lcm(B,C) = nB = mC");
        $t2->math("H = nA");
        $t2->math("K = mD");
        $t2->math("K = pE");
        $t2->math("L = pF");
        
    };

    push @$steps, sub {
        $t1->explain("A measures H the same number of times that B measures G, ".
        "therefore A is to B as H is to G (VII.13)");
        $t2->allgrey;
        $t2->black([1,2]);
        $t2->math("A:B = H:G");
    };

    push @$steps, sub {
        $t1->explain("C measures G the same number of times that D measures K, ".
        "therefore C is to D as G is to K (VII.13)");
        $t2->allgrey;
        $t2->black([1,3]);
        $t2->math("C:D = G:K");
    };
    push @$steps, sub {
        $t1->explain("Similarly, E is to F as K is to L (VII.13)");
        $t2->allgrey;
        $t2->black([4,5]);
        $t2->math("E:F = K:L");
    };


    return $steps;

}

