#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 21;

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If there be three magnitudes, and others equal to them in multitude, ".
    "which taken two and two together are in the same ratio, and the ".
    "proportion of them be perturbed, they will also be in the same ".
    "ratio EX AEQUALI";

$pn->title( 23, $title, 'V' );

my $down    = 40;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 580 );
my $t3      = $pn->text_box( 160, 200 + 4 * $down + $offset );
my $t4      = $pn->text_box( 160, 200 + 0 * $down );
my $t2      = $pn->text_box( 400, 200 + 4 * $down + $offset );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 23 );
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
    my $p1     = 2 / 3;
    my $p2     = 3/2.5;
    my $a      = 100;
    my $b      = $a * $p1;
    my $c      = $b * $p2;
    my $e      = 90;
    my $f      = $e * $p1;
    my $d      = $e / $p2;
    my $offset = 20;
    my $s = 50;
    my @starts = ($s, $s+3*$a + 30,$s+3*$a+3*$b+60); 
    my @A      = ( $starts[0], 200 );
    my @B      = ( $starts[1], $A[1]);
    my @C      = ( $starts[2], $B[1]  );
    my @D      = ( $starts[0], $A[1]+$down );
    my @E      = ( $starts[1], $D[1] );
    my @F      = ( $starts[2], $D[1] );
    my @G      = ( $starts[0], $D[1]+$offset+$down);
    my @H      = ( $starts[1], $G[1]);
    my @K      = ( $starts[0], $G[1]+$down);
    my @L      = ( $starts[2], $G[1]);
    my @M      = ( $starts[1], $G[1]+$down);
    my @N      = ( $starts[2], $G[1]+$down);

    # -------------------------------------------------------------------------
    # Definitions
    # -------------------------------------------------------------------------

    push @$steps, sub {

        $tdot->erase;
        $tindent->erase;
        $t4->erase;
        $t1->erase;
        $t1->title("Definitions");
        $tdot->y( $t1->y );
        $tindent->y( $t1->y );

        $tdot->explain("17.");
        $tindent->explain(
                "A ratio EX AEQUALI arises when, there being several "
              . "magnitudes and another set equal to them in multitude which taken "
              . "two and two are in the same proportion, as the first is to the last "
              . "among the the first magnitudes, so is the first is to the last among "
              . "the second magnitudes" );

        $t4->math("ratio EX AEQUALI");
        $t4->math("  a:b = d:e");
        $t4->math("  b:c = e:f");
        $t4->math("\\{then} a:c = d:f");

        $tdot->y( $tindent->y );
        $tindent->y( $tindent->y );

        $tdot->explain("18.");
        $tindent->explain(
                "A PERTURBED PROPORTION arises when, there being three magnitudes ".
                "and another set equal to them in multitude, as antecedent is to ".
                "consequent among the first magnitudes, so is antecedent to ".
                "consequent among the second magnitudes, while, as the ".
                "consequent is to a third among the first magnitudes, so is a ".
                "third to the antecedent among the second magnitudes" );

        $t4->math("ratio PERTURBED PROPORTION");
        $t4->math("  a:b = e:f");
        $t4->math("  b:c = d:e");
        $t4->math("\\{then} a:c = d:f");

        $tdot->y( $tindent->y );
        $tindent->y( $tindent->y );

    };

    push @$steps, sub {
        $tdot->erase;
        $tindent->erase;
        $t1->erase;
        $t4->erase;

    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain(   "Given two sets of numbers A,B,C and D,E,F in ".
                        "perturbed proportion, where ".
                        "A is to B as E is to F, and "
                      . "where B is to C as D is to E " );
        $t1->explain( "Then A is to C as D is to F" );

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

        $t3->math("A:B = E:F");
        $t3->math("B:C = D:E");
        $t3->down;
        $t3->blue( [ 0, 1 ] );
        $t3->math("\\{then} A:C = D:F");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("A:B = E:F");
        $t3->math("B:C = D:E");
        $t3->blue( [ 0, 1 ] );
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let G,H,K be equimultiples of A, B and D");
        
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
        $p{K} = Point->new( $pn, @K )->label( "K", "top" );
        $l{G} = Line->new($pn,@G,$G[0] + 3*$a,$G[1])->tick_marks($a);
        $l{H} = Line->new($pn,@H,$H[0] + 3*$b,$H[1])->tick_marks($b);
        $l{K} = Line->new($pn,@K,$K[0] + 3*$d,$K[1])->tick_marks($d);

        $t3->math("G = m\\{dot}A");
        $t3->math("H = m\\{dot}B");
        $t3->math("K = m\\{dot}D");
        $t3->blue([2,3,4]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let L,M,N be equimultiples of C, E and F");
        
        $p{L} = Point->new( $pn, @L )->label( "L", "top" );
        $p{M} = Point->new( $pn, @M )->label( "M", "top" );
        $p{N} = Point->new( $pn, @N )->label( "N", "top" );
        $l{L} = Line->new($pn,@L,$L[0] + 2*$c,$L[1])->tick_marks($c);
        $l{M} = Line->new($pn,@M,$M[0] + 2*$e,$M[1])->tick_marks($e);
        $l{N} = Line->new($pn,@N,$N[0] + 2*$f,$N[1])->tick_marks($f);

        $t3->math("L = n\\{dot}C");
        $t3->math("M = n\\{dot}E");
        $t3->math("N = n\\{dot}F");
        $t3->blue([5,6,7]);
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since G,H are equimultiples of A,B then ".
        "A is to B as G is to H (V.15)");
        $t3->grey([0..20]);
        $t3->blue([2,3]);
        $t2->math("A:B = G:H");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey(0);
        $t1->explain("Similarly E is to F as M is to N");
        $t3->grey([0..20]);
        $t3->blue([6,7]);
        $t2->math("E:F = M:N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And, as A is to B, so is E to F; hence ".
        "as G is to H, so is M to N (V.11)");
        $t3->grey([0..20]);
        $t3->blue([0]);
        $t2->black([0..20]);
        $t2->math("G:H = M:N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since B is to C as D is to E, alternately B is to ".
        "D as C is to E (V.16)");
        $t3->grey([0..20]);
        $t3->blue([1]);
        $t2->grey([0..20]);
        $t2->math("B:D = C:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since H,K are equimultiples of B,D, B is to D as H is to K (V.15)");
        $t3->grey([0..20]);
        $t3->blue([3,4]);
        $t2->grey([0..20]);
        $t2->math("B:D = H:K");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("As B is to D, so is C to E; hence as H is to ".
        "K, so is C to E (V.11)");
        $t3->grey([0..20]);
        $t2->grey([0..20]);
        $t2->black([3,4,5]);
        $t2->math("H:K = C:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("L,M are equimultiples of C,E, so C is to E as L is to M (V.15)");
        $t3->grey([0..20]);
        $t2->grey([0..20]);
        $t3->blue([5,6]);
        $t2->math("C:E = L:M");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since C is to E as H is to K, H is to K as L is to M (V.11)");
        $t2->black(5);
        $t2->math("H:K = L:M");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And alternately, as H is to L, so is K to M (V.16)");
        $t2->grey([5,6]);
        $t2->math("H:L = K:M");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore G,H,L and K,M,N are in a perturbed ratio");
        $t3->grey([0..20]);
        $t2->grey([0..20]);
        $t2->black([2,8]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus if G is greater than L, K is also ".
        "greater than N, etc (V.21)");
        $t3->grey([0..20]);
        $t2->grey([0..20]);
        $t2->black([2,8]);
        $t2->math("G >=< L \\{then} K >=<N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("G,K are equimultiples of A,D and L,N of C,F ");
        $t2->grey([0..20]);
        $t2->black([9]);
        $t2->math("m\\{dot}A >=< n\\{dot}C \\{then} m\\{dot}D >=<n\\{dot}F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore A is to C as D is to F (V.def.5)");
        $t3->grey([0..20]);
        $t3->blue([0,1]);
        $t2->grey([0..20]);
        $t2->down;
        $t2->black([10]);
        $t2->math("A:C = D:F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey(-2);
    };

    return $steps;

}

