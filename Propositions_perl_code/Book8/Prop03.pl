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
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 400, 160 );
my $t4 = $pn->text_box( 480, 160 );

my ( %p, %c, %s, %t, %l );

my $ds  = 30;
my $unit = 7;
use Geometry::Shortcuts;
my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If as many numbers as we please in continued proportion be the least of "
  . "those which have the same ratio with them, the extremes of them are "
  . "prime to one another";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 3
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 200;

    my $a = 2;
    my $b = 3;
    my $A = $a * $a * $a;
    my $B = $a * $a * $b;
    my $C = $a * $b * $b;
    my $D = $b * $b * $b;
    my $E = $a;
    my $F = $b;
    my $G = $a * $a;
    my $H = $a * $b;
    my $K = $b * $b;
    my $L = $A;
    my $M = $B;
    my $N = $C;
    my $O = $D;

    our @A = $line_coords->( -xorig  => $dxs_orig, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -after  => $A, -length => $B );
    our @C = $line_coords->( -after  => [$A,$B], -length => $C );
    our @D = $line_coords->( -after  => [$A,$B,$C], -length => $D );

    our @E = $line_coords->( -xorig  => $dxs_orig, -yskip => 1, -length => $E );
    our @F = $line_coords->( -after  => $A, -length => $F );

    our @G = $line_coords->( -xorig  => $dxs_orig, -yskip => 1, -length => $G );
    our @H = $line_coords->( -after  => $A, -length => $H );
    our @K = $line_coords->( -after  => [$A,$B], -length => $K );

    our @L = $line_coords->( -xorig  => $dxs_orig, -yskip => 1, -length => $L );
    our @M = $line_coords->( -after  => $A, -length => $M );
    our @N = $line_coords->( -after  => [$A,$B], -length => $N );
    our @O = $line_coords->( -after  => [$A,$B,$C], -length => $O );

    my $steps;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "Given a set of numbers, A,B,C,D in continued proportion "
                      . "and let them be the least numbers in that ratio" );

        $make_lines->(qw(A B C D));

        $t2->math("A,B,C,D are least, where ");
        $t2->math( "A:B = B:C = C:D");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("Then A,D are relatively prime");
        $t2->math("gcd(A,D) = 1");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof");
        $t2->erase;
        $t2->math("A,B,C,D are least, where ");
        $t2->math( "A:B = B:C = C:D");

        $t2->allblue();
    };

    push @$steps, sub {
        $t1->explain(   "Let E,F be the least two numbers in the ratio of "
                      . "A,B,C,D\\{nb}(VII.33)" );
        $make_lines->(qw(E F));
        $t2->allgrey;
        $t2->math("E,F is least, where");
        $t2->math( "E:F = A:B" );
    };
    push @$steps, sub {
        $t1->explain(   "Then three others (G,H,K) with the same property"
                      . "\\{nb}(VIII.2)" );
        $make_lines->(qw(G H K));
        $t2->allgrey;
        $t2->black(3);
        $t2->math("G=E\\{^2}, H=E\\{dot}F, K=F\\{^2},           G:H = A:B");

    };
    push @$steps, sub {
        $t1->explain(
                 "Continuing one at a time until we have the same multitude as "
                   . "A,B,C,D\\{nb}(VIII.2). Let them be called L,M,N,O" );
        $make_lines->(qw(L M N O));
        $t2->math("L=E\\{^3}, M=E\\{^2}\\{dot}F, N=E\\{dot}F\\{^2}, O=F\\{^3},  ".
        "L:M = A:B");

        #$t2->allgrey;
        #$t2->blue(0);
    };

    push @$steps, sub {
        $t2->math(
                "L,M,N,O is least, where " );
        $t2->math("A:B:C:D = L:M:N:O");
    };

    push @$steps, sub {
        $t1->explain( "Since E,F are the least of those which have the same "
            . "ratio with them, they are relatively prime to one another (VII.22)"
        );
        $t2->allgrey();
        $t2->black( [ 2, 3 ] );
        $t2->math("gcd(E,F) = 1");
    };

    push @$steps, sub {
        $t1->explain(   "And since G,K are E,F squared, and L,O are E,F cubed "
                      . "G,K and L,O are relatively prime (VII.27)" );
        $t2->allgrey();
        $t2->black( [ 4, 5, -1 ] );
        $t2->math("gcd(G,K) = 1");
        $t2->math("gcd(L,O) = 1");
    };

    push @$steps, sub {
        $t1->explain( "Since A,B,C,D are the least of those with the ratio A:B "
             . "and L,N,N,O are also the least of those with the ratio A:B ... "
        );
        $t1->explain(   "... and the multitude of numbers A,B,C,D is equal to "
                      . "the multitude of numbers L,M,N,O" );
        $t1->explain(
                 "A,B,C,D equals L,M,N,O, therefore A equals L and D equals O");
        $t2->allgrey;
        $t2->blue( [ 0, 1 ] );
        $t2->black([6,7]);
        $t2->math("A = L, D = O");
    };

    push @$steps, sub {
        $t1->explain("Thus, since L,O are relatively prime, so are A,D");
        $t2->allgrey;
        $t2->black( [ -1, -2 ] );
        $t2->math("gcd(A,D) = 1");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue( [ 0, 1,-1] );
    };

    return $steps;

}

