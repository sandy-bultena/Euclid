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
    "Ratios which are the same with the same ratio are also ".
    "the same with one another.";

$pn->title( 11, $title, 'V' );

my $down    = 40;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 160, 200 + 4 * $down + $offset );
my $t4      = $pn->text_box( 160, 200 + 0 * $down );
my $t2      = $pn->text_box( 400, 200 + 4 * $down + $offset);
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 11 );
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
    my @A      = ( 50, 200 );
    my @C      = ( 50 + 3*$b + 20, 200 );
    my @E      = ( 50 + 3*$b + 3*$d + 40, 200 );
    my @B      = ( 50, $A[1] + $down );
    my @D      = ( 50 + 3*$b + 20, $C[1]  + $down);
    my @F      = ( 50 + 3*$b + 3*$d + 40, $E[1]  + $down );
    
    my @G = ($B[0],$B[1]+$down+$offset);
    my @H = ($D[0],$D[1]+$down+$offset);
    my @K = ($F[0],$F[1]+$down+$offset);

    my @L = ($G[0],$G[1]+$down);
    my @M = ($H[0],$H[1]+$down);
    my @N = ($K[0],$K[1]+$down);

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("If A is to B as C is to D, and C is to D as ".
        "E is to F then ...");
        $t1->explain("... A is to B as E is to F");

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

        $t3->math("A:B = C:D");
        $t3->math("C:D = E:F ");
        $t3->blue( [ 0, 1 ] );
        $t3->math("\\{then} A:B = E:F");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("A:B = C:D");
        $t3->math("C:D = E:F ");
        $t3->blue([0,1]);
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
        $t1->explain("Since the ratios A to B and C to D are equal, and since ".
        "equimultiples G,H and L,M have been taken...");
        $t1->explain("If G is less than L, then H is less than M, ".
        "etc\\{nb}(V.def\\{nb}5)");
        
        $t3->grey([0..20]);
        $t3->blue([0,2,3,5,6]);
        
        $t2->math("G >=< L \\{then} H >=< M");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the ratios C to D and E to F are equal, and since ".
        "equimultiples H,K and M,N have been taken...");
        $t1->explain("If H is less than M, then K is less than N, ".
        "etc\\{nb}(V.def\\{nb}5)");
        
        $t3->grey([0..20]);
        $t3->blue([1,3,4,6,7]);
        $t2->grey(0);
        
        $t2->math("H >=< M \\{then} K >=< N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, if G is greater than L than that H is ".
        "greater than M, and K is greater than N, ".
        "then...");
        $t1->explain("... If G is greater than L, then K is greater than N, etc.");
        
        $t3->grey([0..20]);
        $t2->black([0,1]);
        $t2->down;
        
        $t2->math("G >=< L \\{then} K >=< N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If G is greater/equal/less than than L, means that ".
        "K is greater/equal/less than N, ...");
        $t1->explain ("... and G,K are equimultiples of A,E and L,N are ".
        "equimultiples of B,F");
        
        $t3->grey([0..20]);
        $t3->blue([2,5,4,7]);
        $t2->grey([0..20]);
        $t2->black(2);
        
        $t2->math("p\\{dot}A >=< q\\{dot}B \\{then} p\\{dot}E >=< q\\{dot}F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("A is to B as E is to F (V.def\\{nb}5)");
        
        $t3->grey([0..20]);
        $t3->blue([0,1]);
        $t2->grey([0..20]);
        $t2->black(3);
        
        $t2->math("A:B = E:F");
    };
    return $steps;

}

