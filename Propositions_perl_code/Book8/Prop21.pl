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
    "If two mean proportional numbers fall between two numbers, the numbers "
  . "are similar solid numbers";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 21
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;

    my ( $A, $C, $D, $B ) = Numbers->new( 2, 3 )->find_continued_proportion(4);
    my ( $E, $F, $G ) = Numbers->new( $A, $C, $D )->least_ratio;    # 1 2 4
    my ( $H, $K ) = Numbers->new( $E, $F, $G )->find_plane_from_proportional(1);
    my ( $L, $M ) = Numbers->new( $E, $F, $G )->find_plane_from_proportional(3);
    my $N = $A/$E;
    my $O = $C/$E;

    

    our @A =
      $line_coords->( -xorig => $dxs, -yorig => $dys, -length => $A );
    our @E = $line_coords->( -after => $B, -length => $E );
    our @B = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $B );
    our @F = $line_coords->( -after => $B, -length => $F );
    our @C = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $C );
    our @G = $line_coords->( -after => $B, -length => $G );
    our @D = $line_coords->( -xorig => $dxs, -yskip => 1, -length => $D );

    our @H = $line_coords->( -after => [ $B, $G ], -yorig => $dys-12, -length => $H );
    our @K = $line_coords->( -after => [ $B, $G ], -yorig => $dys+12, -length => $K );
    our @L = $line_coords->( -after => [ $B, $G ], -yorig => $dys-12+2*$ds, -length => $L );
    our @M = $line_coords->( -after => [ $B, $G ], -yorig => $dys+12+2*$ds, -length => $M );

    our @N = $line_coords->( -after => [ $B, $G, $M ], -yorig => $dys, -length => $N );
    our @O = $line_coords->( -after => [ $B, $G, $M ], -yskip => 1, -length => $O );

    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("If A,C,D,B are in continuous proportion ...");
        $make_lines->(qw(A B C D));
        $t2->math("A:C = C:D = D:B");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then A and B are similar solid numbers");
        $t2->math("A ~ B, A = pqr, B = ijk, p:q:r=i:j:k");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("A:C = C:D = D:B");    # 0
        $t2->allblue;
    };

    push @$steps, sub {
        $t2->allgrey;
        $make_lines->(qw(E F G));
        $t1->explain(   "Let E,F,G be the least numbers in the same ratio "
                      . "as A,C,D (VII.33 or VIII.2)" );
        $t2->math("E:F:G = A:C:D = C:D:B");      # 1
    };

    push @$steps, sub {
        $t1->explain("Thus E,G are prime to one another (VIII.3)");
        $t2->math("gcd(E,G) = 1");       # 2
    };

    push @$steps, sub {
        $t2->allgrey();
        $t1->explain( "Since one mean number falls between E,G, then E,G "
               . "are similar plane numbers, (VIII.20), and let their sides be "
               . "H,K and L,M respectively" );
        $t2->black(-2);
        $make_lines->(qw(H K L M));
        $t2->math("E = H\\{dot}K, H \\{greaterthanorequal} K");      # 3
        $t2->math("G = L\\{dot}M, L \\{greaterthanorequal} M");      # 4
    };

    push @$steps, sub {
        $t2->allgrey();
        $t1->explain("From the steps used in the previous proposition, it is "
        ."known that E,F,G is continuously porportional to H to L and K to M");
        $t2->black([1]);
        $t2->math("E:F = F:G = H:L = K:M");     # 5
    };

    push @$steps, sub {
        $t2->allgrey();
        $t1->explain("Since E,F,G are the least numbers of the proportion ".
        "A,C,D, and they are equal in number, then E is to A as G is to D (VII.14)");
        $t2->black([1]);
        $t2->math("E:G = A:D");                 # 6
    };

    push @$steps, sub {
        $t2->allgrey();
        $t1->explain("Since E,G are prime, they are also the least numbers ".
        "in the ratio A to D (VII.21), thus E measures A the same number of ".
        "times that E measures D (VII.20)");
        $make_lines->(qw(N));
        $t2->black([2,-1]);
        $t2->math("A = N\\{dot}E, D = N\\{dot}G ");            # 7
    };

    push @$steps, sub {
        $t2->allgrey();
        $t1->explain("But E is the product of H,K, therefore A is the product ".
        "of N,H,K, and hence a solid");
        $t2->black([-1,3]);
        $t2->math("A = N\\{dot}H\\{dot}K");                     # 8
    };

    push @$steps, sub {
        $t2->allgrey();
        $t1->explain("Again, since E,F,G are the least numbers of ration C,D,B, ".
        "E\\{nb}measures C the same number of times that G measures B");
        $make_lines->("O");
        $t2->math("C = O\\{dot}E, B = O\\{dot}G");              # 9
        $t2->black([1]);
    };

    push @$steps, sub {
        $t2->allgrey();
        $t1->explain("But G is the product of L,M, therefore B is the product ".
        "of O,L,M, and hence a solid");
        $t2->black([-1,4]);
        $t2->math("B = O\\{dot}L\\{dot}M");                     # 10
    };

    push @$steps, sub {
        $t2->allgrey();
        $t1->explain("Therefore A,B are both solids\n");
        $t2->blue([0,8,10]);
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof (cont)");
    };

    push @$steps, sub {
        $t2->allgrey();
        $t1->explain("A,C are N,O multipled by E, therefore N is to O as ".
        "A is to C, as E is to F (VII.18)");
        $t2->black([1,7,9]);
        $t4->math("N:O = A:C = E:F");
    };

    push @$steps, sub {
        $t2->allgrey();
        $t4->allgrey();
        $t1->explain("But as E is to F, so is H to L and K to M, ".
        "therefore, as H is to L so is K to M and N to O");
        $t2->black(5);
        $t4->black(-1);
        $t4->math("H:L = K:M = N:O");
    };

    push @$steps, sub {
        $t2->allgrey();
        $t4->allgrey();
        $t1->explain("And H,K,N are the sides of A, and O,L,M ".
        "the sides of B, therefore A,B are similar solid numbers");
        $t4->black(-1);
        $t2->black([8,10]);
        $t4->math("A ~ B");
    };


    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0,8,10]);
        $t4->allgrey();
        $t4->blue(-1);
    };

    return $steps;

}

