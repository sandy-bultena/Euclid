#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If any number of magnitudes be proportional, as one of the antecedents ".
    "is to one of the consequents, so will all the antecedents be to all ".
    "the consequents.";

$pn->title( 12, $title, 'V' );

my $down    = 40;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 160, 200 + 5 * $down + $offset );
my $t4      = $pn->text_box( 160, 200 + 0 * $down );
my $t2      = $pn->text_box( 400, 200 + 5 * $down + $offset);
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 12 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my ( %l, %p, %c, %s, %a );
    my $p      = 2.2/3;
    my $k      = 2;
    my $k2     = 3;
    my $a      = 120;
    my $c      = 100;
    my $e      = 80;
    my $b      = $a * $p;
    my $d      = $c * $p;
    my $f      = $e * $p;
    my $offset = 20;
    my @A      = ( 150, 200 );
    my @C      = ( 150 + $a + 50, 200 );
    my @E      = ( 150 + $a + $c + 100, 200 );
    my @B      = ( 150, $A[1] + $down );
    my @D      = ( 150 + $a + 50, $C[1]  + $down);
    my @F      = ( 150 + $a + $c + 100, $E[1]  + $down );
    
    my @G = ($B[0],$B[1]+$down+$offset);
    my @H = ($B[0],$G[1]+$down);
    my @K = ($B[0],$H[1]+$down);

    my @L = ($F[0],$G[1]);
    my @M = ($F[0],$H[1]);
    my @N = ($F[0],$K[1]);

    # -------------------------------------------------------------------------
    # Definitions
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Definitions");
        $tdot->y( $t1->y );
        $tindent->y( $t1->y );

        $tdot->explain("6.");
        $tindent->explain( "Let magnitudes which have the same ratio be ".
        "called PROPORTIONAL");
        $tdot->y( $tindent->y );

        $t4->math("A:B = C:D \\{then} A,B,C,D are proportional");
        $t4->down;
        $t4->math("A,C \\{then} antecedents");
        $t4->math("B,D \\{then} consequents");

    };

    push @$steps, sub {
        $t1->erase;
        $tdot->erase;
        $tindent->erase;
        $t4->erase;
     };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("If A is to B as C is to D, and C is to D as ".
        "E is to F then ...");
        $t1->explain("... the ratio of the sum of A,C,E to the sum of ".
        "B,D,F is also the ratio of A to B");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );
        $l{E} = Line->new( $pn, @E, $E[0] + $e, $E[1] );
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] );

        $t3->math("A:B = C:D = E:F ");
        $t3->blue( [ 0 ] );
        $t3->math("\\{then} (A+C+E):(B+D+F) = A:B");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("A:B = C:D = E:F ");
        $t3->blue( [ 0 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Let G,H,K be equimultiples of A,C and E" );

        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
        $p{K} = Point->new( $pn, @K )->label( "K", "top" );

        $l{G} = Line->new( $pn, @G, $G[0] + $k*$a, $G[1] )->tick_marks($a);
        $l{H} = Line->new( $pn, @H, $H[0] + $k*$c, $H[1] )->tick_marks($c);
        $l{K} = Line->new( $pn, @K, $K[0] + $k*$e, $K[1] )->tick_marks($e);
        
        $t3->math("G = p\\{dot}A");
        $t3->math("H = p\\{dot}C");
        $t3->math("K = p\\{dot}E");
        $t3->blue([0..20]);
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Let L,M,N be equimultiples of B,D and F" );

        $p{L} = Point->new( $pn, @L )->label( "L", "top" );
        $p{M} = Point->new( $pn, @M )->label( "M", "top" );
        $p{N} = Point->new( $pn, @N )->label( "N", "top" );

        $l{L} = Line->new( $pn, @L, $L[0] + $k2*$b, $L[1] )->tick_marks($b);
        $l{M} = Line->new( $pn, @M, $M[0] + $k2*$d, $M[1] )->tick_marks($d);
        $l{N} = Line->new( $pn, @N, $N[0] + $k2*$f, $N[1] )->tick_marks($f);
        
        $t3->math("L = q\\{dot}B");
        $t3->math("M = q\\{dot}D");
        $t3->math("N = q\\{dot}F");
        $t3->blue([0..20]);
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the ratios A to B, C to D, E to F are equal, and since ".
        "equimultiples G,H,K and L,M,N have been taken...");
        $t1->explain("... so if G is less than L, then H is less than M and ".
        "K is less than N, ".
        "etc\\{nb}(V.def\\{nb}5)");
        
        $t2->math("  p\\{dot}A >=< q\\{dot}B\n".
        "\\{then} p\\{dot}C >=< q\\{dot}D\n".
        "\\{then} p\\{dot}E >=< q\\{dot}F");
        $t2->math("  G >=< L \n\\{then} H >=< M \n\\{then} K >=< N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If G is less than L, and H is less than M and K is less than N ".
        "then the sum of G,H,K will be less than L,M,N");
        
        $t2->math("\\{then} G + H + K >=< L + M + N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But G,H,K are equimultiples of A,C,E, so the sum ".
        "G,H,K is the same multiple of the sum A,C,E\\{nb}(V.1)");
        $t3->grey([0..10]);
        $t3->blue([1,2,3]);
        $t2->grey([0..20]);
        
        $t2->math("G + H + K = p\\{dot}(A + C + E)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, the sum of L,M,N is the same multiple ".
        "of B,D,F as L is to B");
        $t3->grey([0..10]);
        $t3->blue([4,5,6]);
        $t2->grey([0..20]);
        
        $t2->math("L + M + N = q\\{dot}(B + D + F)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..10]);
        $t2->grey([0..20]);
        $t2->black([3,4]);
        $t2->math("p\\{dot}(A+C+E) >=< q\\{dot}(B+D+F)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Thus, the sum of A,C,E is to the sum of B,D,F ".
        "is equal in ratio to A\\{nb}to\\{nb}B\\{nb}(V def.5)");
        $t3->grey([0..10]);
        $t2->grey([0..20]);
        $t3->blue(0);
        $t2->black([0,5]);
        $t2->down;
        $t2->math("(A+C+E):(B+D+F) = A:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->allgrey;
        $t2->black(-1);
    };

    return $steps;

}

