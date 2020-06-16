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
my $t4 = $pn->text_box( 480, 160 );

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
    my $dys      = 200;
    my $unit     = 7;

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

    our @A = ( $dxs, $dys, $dxs + $A * $unit, $dys );
    $dxs = $dxs + $A * $unit + 2 * $ds;
    our @B = ( $dxs, $dys, $dxs + $B * $unit, $dys );
    $dxs = $dxs + $B * $unit + 2 * $ds;
    our @C = ( $dxs, $dys, $dxs + $C * $unit, $dys );
    $dxs = $dxs + $C * $unit + 2 * $ds;
    our @D = ( $dxs, $dys, $dxs + $D * $unit, $dys );

    $dxs = $dxs_orig;
    $dys = $dys + $ds;
    our @E = ( $dxs, $dys, $dxs + $E * $unit, $dys );
    $dxs = $dxs + $A * $unit + 2 * $ds;
    our @F = ( $dxs, $dys, $dxs + $F * $unit, $dys );

    $dxs = $dxs_orig;
    $dys = $dys + $ds;
    our @G = ( $dxs, $dys, $dxs + $G * $unit, $dys );
    $dxs = $dxs + $A * $unit + 2 * $ds;
    our @H = ( $dxs, $dys, $dxs + $H * $unit, $dys );
    $dxs = $dxs + $B * $unit + 2 * $ds;
    our @K = ( $dxs, $dys, $dxs + $K * $unit, $dys );

    $dxs = $dxs_orig;
    $dys = $dys + $ds;
    our @L = ( $dxs, $dys, $dxs + $L * $unit, $dys );
    $dxs = $dxs + $A * $unit + 2 * $ds;
    our @M = ( $dxs, $dys, $dxs + $M * $unit, $dys );
    $dxs = $dxs + $B * $unit + 2 * $ds;
    our @N = ( $dxs, $dys, $dxs + $N * $unit, $dys );
    $dxs = $dxs + $C * $unit + 2 * $ds;
    our @O = ( $dxs, $dys, $dxs + $O * $unit, $dys );

    my $steps;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "Given a set of numbers, A,B,C,D in continued proportion "
                      . "and let them be the least numbers in that ratio" );

        make_lines(qw(A B C D));

        $t2->mathsmall(
              "S={(i,j,k,l)|i,j,k,l\\{elementof}\\{natural}, i:j=j:k=k:l=A:B}");
        $t2->mathsmall(
                "(A,B,C,D)\\{elementof}S such that A\\{lessthanorequal}i, "
              . "B\\{lessthanorequal}j, C\\{lessthanorequal}k, D\\{lessthanorequal}l "
              . "\\{forall}(i,j,k,l)\\{elementof}S" );
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
        $t2->mathsmall(
              "S={(i,j,k,l)|i,j,k,l\\{elementof}\\{natural}, i:j=j:k=k:l=A:B}");
        $t2->mathsmall(
                "(A,B,C,D)\\{elementof}S such that A\\{lessthanorequal}i, "
              . "B\\{lessthanorequal}j, C\\{lessthanorequal}k, D\\{lessthanorequal}l "
              . "\\{forall}(i,j,k,l)\\{elementof}S" );

        $t2->allblue();
    };

    push @$steps, sub {
        $t1->explain(   "Let E,F be the least two numbers in the ratio of "
                      . "A,B,C,D\\{nb}(VII.33)" );
        make_lines(qw(E F));
        $t2->allgrey;
        $t2->mathsmall("T={(x,y)|x,y\\{elementof}\\{natural}, x:y=A:B}");
        $t2->mathsmall( "(E,F)\\{elementof}T such that E\\{lessthanorequal}x, "
                      . "F\\{lessthanorequal}y \\{forall}(x,y)\\{elementof}T" );
    };
    push @$steps, sub {
        $t1->explain(   "Then three others (G,H,K) with the same property"
                      . "\\{nb}(VIII.2)" );
        make_lines(qw(G H K));
        $t2->allgrey;
        $t2->black(3);
        $t2->math("G=E\\{^2}, H=E\\{dot}F, K=F\\{^2}");

     #$t2->mathsmall("S'={(i,j,k)|i,j,k\\{elementof}\\{natural}, i:j=j:k=A:B}");
     #$t2->mathsmall("(G,H,K)\\{elementof}S' such that G\\{lessthanorequal}i, ".
     #"H\\{lessthanorequal}j, K\\{lessthanorequal}k ".
     #"\\{forall}(i,j,k)\\{elementof}S'");
    };
    push @$steps, sub {
        $t1->explain(
                 "Continuing one at a time until we have the same multitude as "
                   . "A,B,C,D\\{nb}(VIII.2). Let them be called L,M,N,O" );
        make_lines(qw(L M N O));
        $t2->math("L=E\\{^3}, M=E\\{^2}\\{dot}F, N=E\\{dot}F\\{^2}, O=F\\{^3}");

        #$t2->allgrey;
        #$t2->blue(0);
    };

    push @$steps, sub {
        $t2->mathsmall(
                "(L,M,N,O)\\{elementof}S such that L\\{lessthanorequal}i, "
              . "N\\{lessthanorequal}j, M\\{lessthanorequal}k, O\\{lessthanorequal}l "
              . "\\{forall}(i,j,k,l)\\{elementof}S" );
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
        $t2->black(6);
        $t2->math("A:B:C:D = L:M:N:O");
        $t2->math("A = L, D = O");
    };

    push @$steps, sub {
        $t1->explain("Thus, since L,O are relatively prime, so are A,D");
        $t2->allgrey;
        $t2->black( [ -1, -3 ] );
        $t2->math("gcm(A,D) = 1");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue( [ 0, 1, -1 ] );
    };

    return $steps;

}

