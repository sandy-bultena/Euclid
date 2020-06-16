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
    "If there be any number of magnitudes whatever, and others equal to ".
    "them in multitude, which taken two and two together are in the same ratio, ".
    "they will also be in the same ratio EX AEQUALI";

$pn->title( 22, $title, 'V' );

my $down    = 40;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 160, 200 + 4 * $down + $offset );
my $t4      = $pn->text_box( 160, 200 + 0 * $down );
my $t2      = $pn->text_box( 400, 200 + 4 * $down + $offset );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 22 );
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
    my $a      = 120;
    my $b      = $a * $p1;
    my $c      = $b * $p2;
    my $d      = 100;
    my $e      = $d * $p1;
    my $f      = $e * $p2;
    my $offset = 20;
    my $s = 50;
    my @starts = ($s, $s+2*$a + 30,$s+2*$a+3*$b+60); 
    my @A      = ( $starts[0], 200 );
    my @B      = ( $starts[1], $A[1]);
    my @C      = ( $starts[2], $B[1]  );
    my @D      = ( $starts[0], $A[1]+$down );
    my @E      = ( $starts[1], $D[1] );
    my @F      = ( $starts[2], $D[1] );
    my @G      = ( $starts[0], $D[1]+$offset+$down);
    my @H      = ( $starts[0], $G[1]+$down);
    my @K      = ( $starts[1], $D[1]+$offset+$down);
    my @L      = ( $starts[1], $G[1]+$down);
    my @M      = ( $starts[2], $D[1]+$offset+$down);
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
        $t1->explain(   "Given two sets of numbers A,B,C and D,E,F where ".
                        "A is to B as D is to E, and "
                      . "where B is to C as E is to F " );
        $t1->explain( "Then they will also be in the same ratio EX AEQUALI ".
        "(A is to C as D is to F)" );

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

        $t3->math("A:B = D:E");
        $t3->math("B:C = E:F");
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
        $t3->math("A:B = D:E");
        $t3->math("B:C = E:F");
        $t3->blue( [ 0, 1 ] );
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let G,H be equimultiples of A and D");
        
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
        $l{G} = Line->new($pn,@G,$G[0] + 2*$a,$G[1])->tick_marks($a);
        $l{H} = Line->new($pn,@H,$H[0] + 2*$d,$H[1])->tick_marks($d);

        $t3->math("G = m\\{dot}A");
        $t3->math("H = m\\{dot}D");
        $t3->blue([2,3]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let K,L be equimultiples of B and E");
        
        $p{K} = Point->new( $pn, @K )->label( "K", "top" );
        $p{L} = Point->new( $pn, @L )->label( "L", "top" );
        $l{K} = Line->new($pn,@K,$K[0] + 3*$b,$K[1])->tick_marks($b);
        $l{L} = Line->new($pn,@L,$L[0] + 3*$e,$L[1])->tick_marks($e);

        $t3->math("K = n\\{dot}B");
        $t3->math("L = n\\{dot}E");
        $t3->blue([4,5]);
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let M,N be equimultiples of C and F");
        
        $p{M} = Point->new( $pn, @M )->label( "M", "top" );
        $p{N} = Point->new( $pn, @N )->label( "N", "top" );
        $l{M} = Line->new($pn,@M,$M[0] + 2*$c,$M[1])->tick_marks($c);
        $l{N} = Line->new($pn,@N,$N[0] + 2*$f,$N[1])->tick_marks($f);

        $t3->math("M = p\\{dot}C");
        $t3->math("N = p\\{dot}F");
        $t3->blue([6,7]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since G,H are equimultiples of A,D and K,L are ".
        "equimultiples of B,E and A is to D as B is to E, then ".
        "G is to K as H is to\\{nb}L\\{nb}(V.4)");
        $t3->grey([0..20]);
        $t3->blue([0,2,3,4,5]);
        $t2->math("m\\{dot}A:n\\{dot}B = m\\{dot}D:n\\{dot}E");
        $t2->math("G:K = H:L");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey(0);
        $t1->explain("Similarly it can be shown that K is to M, so is L to N");
        $t3->grey([0..20]);
        $t3->blue([1,4,5,6,7]);
        $t2->math("K:M = L:N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("With three magnitudes G,K,M and another three ".
        "magnitudes H,L,N are two by two equal in ratios, then if G is in ".
        "excess of M, H is in excess of N, etc. (V.20)");
        $t3->grey([0..20]);
        $t2->math("G >=< M \\{then} H >=< N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("G,H are equimultiples of A,D and M,N are chance ".
        "equimultiples of C,F, therefore A is to C so is D to F (V.def.5)");
        $t2->grey([0..20]);
        $t2->black(3);
        $t2->math("m\\{dot}A >=< p\\{dot}C \\{then} m\\{dot}D >=< p\\{dot}F");
        $t2->math("A:C = D:F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->black(5);
        $t3->blue([0,1]);
    };

    return $steps;

}

