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
    "If a first magnitude have to a second the same ratio as a third to a ".
    "fourth, and the third have to the fourth a greater ratio than a fifth ".
    "has to a sixth, the first will also have to the second a greater ratio ".
    "than the fifth to the sixth";

$pn->title( 13, $title, 'V' );

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
push @$steps, Proposition::toc5( $pn, 13 );
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
    my $p      = 1.8/3;
    my $k      = 2;
    my $k2     = 3;
    my $a      = 80;
    my $c      = 100;
    my $e      = 120;
    my $b      = $a * $p;
    my $d      = $c * $p;
    my $f      = $e * ($p*1.3);
    my $offset = 20;
    my @start  = (50,50+$a+30,50+$a+$c+60,50+$a+$c+$k*$a+90);
    my @A      = ( $start[0], 200 );
    my @C      = ( $start[1], 200 );
    my @B      = ( $start[0], $A[1] + $down );
    my @E      = ( $start[0]+50, $B[1]+$down+$offset );
    my @D      = ( $start[1], $C[1]  + $down);
    my @F      = ( $start[0]+50, $E[1]  + $down );
    
    my @G = ($start[3],$A[1]);
    my @H = ($E[0]+50+$e,$B[1]+$down+$offset);
    my @K = ($start[3],$B[1]);

    my @L = ($H[0],$H[1]+$down);
    my @M = ($start[2],$A[1]);
    my @N = ($start[2],$B[1]);

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
        $tdot->explain("7.");
        $tindent->explain( "When, of the equimultiples, the multiple of the "
            . "first magnitude exceeds the multiple of the second, but the multiple "
            . "of the third does not exceed the multiple of the fourth, "
            . "then the first is said to have a greater ratio to the second than "
            . "the third has to the fourth." );

        my $b = $d + 15;

        #my $c = $c + 10;
        my $y = 200;
        my $x = 360;
        $l{A} =
          Line->new( $pn, 150, $y, 150 + $a, $y )->tick_marks($a)
          ->label( "A", "top" );
        $l{Am} = Line->new( $pn, $x, $y, $x + 2 * $a, $y )->tick_marks($a);

        $y = $y + $down;
        $l{B} =
          Line->new( $pn, 150, $y, 150 + $b, $y )->tick_marks($b)
          ->label( "B", "top" );
        $l{Bm} = Line->new( $pn, $x, $y, $x + 4 * $b, $y )->tick_marks($b);

        $y = $y + $down + $offset;
        $l{C} =
          Line->new( $pn, 150, $y, 150 + $c, $y )->tick_marks($c)
          ->label( "C", "top" );
        $l{Cm} = Line->new( $pn, $x, $y, $x + 2 * $c, $y )->tick_marks($c);

        $y = $y + $down;
        $l{D} =
          Line->new( $pn, 150, $y, 150 + $d, $y )->tick_marks($d)
          ->label( "D", "top" );
        $l{Dm} = Line->new( $pn, $x, $y, $x + 4 * $d, $y )->tick_marks($d);

        $t4->down;
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->math("If   n\\{dot}A >  m\\{dot}B");
        $t4->math("and  n\\{dot}C <= m\\{dot}D");
        $t4->math("then A:B > C:D");

        $t4->down;
        $t4->math("Example:");
        $t4->blue(3);
        $t4->math(   "compare "
                   . $l{A}->length . ":"
                   . $l{B}->length . " to "
                   . $l{C}->length . ":"
                   . $l{D}->length );
        $t4->math(
               "2\\{times}" . $l{A}->length . " > 4\\{times}" . $l{B}->length );
        $t4->math(
               "2\\{times}" . $l{C}->length . " < 4\\{times}" . $l{D}->length );
        $t4->math(   "\\{therefore} "
                   . $l{A}->length . ":"
                   . $l{B}->length . " > "
                   . $l{C}->length . ":"
                   . $l{D}->length );
    };

    push @$steps, sub {
        $tdot->erase;
        $tindent->erase;
        $t4->erase;
        $t1->erase;
        $l{A}->remove;
        $l{B}->remove;
        $l{C}->remove;
        $l{D}->remove;
        $l{Am}->remove;
        $l{Bm}->remove;
        $l{Cm}->remove;
        $l{Dm}->remove;
    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("If A is to B as C is to D, and C is to D greater than ".
        "E is to F ");
        $t1->explain("... then A is to B is also greater than E is to F");

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
        $t3->math("C:D > E:F");
        $t3->blue( [ 0,1 ] );
        $t3->math("\\{then} A:B > E:F");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("A:B = C:D");
        $t3->math("C:D > E:F");
        $t3->blue( [ 0,1 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since the ratio of C to D is greater than E to F, "
        ."there exists equimultiples of C,E and D,F such that the multiple ".
        "of C is in excess of the multiple of E, whereas the multiple of D ".
        "is less than the multiple of\\{nb}F\\{nb}(V.def.7)" );
        
        $t3->math("m\\{dot}C > n\\{dot}D");
        $t3->math("m\\{dot}E < n\\{dot}F");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Create equimultiples G,H of C,E and equimultiples "
        ."K,L of D,F such that G is greater than K, but H is less than L");
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
        $p{K} = Point->new( $pn, @K )->label( "K", "top" );
        $p{L} = Point->new( $pn, @L )->label( "L", "top" );

        $l{G} = Line->new( $pn, @G, $G[0] + $k*$c, $G[1] )->tick_marks($c);
        $l{K} = Line->new( $pn, @K, $K[0] + $k2*$d, $K[1] )->tick_marks($d);
        $l{H} = Line->new( $pn, @H, $H[0] + $k*$e, $H[1] )->tick_marks($e);
        $l{L} = Line->new( $pn, @L, $L[0] + $k2*$f, $L[1] )->tick_marks($f);
        
        $t3->math("G = m\\{dot}C");
        $t3->math("H = m\\{dot}E");
        $t3->math("K = n\\{dot}D");
        $t3->math("L = n\\{dot}F");
        $t3->blue([0..20]);
        
        $t2->math("G > K");
        $t2->math("H < L");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Let M be the same multiple of A as G is to C, ".
        "and let N be the same multiple of B as K is to D" );

        $p{M} = Point->new( $pn, @M )->label( "M", "top" );
        $p{N} = Point->new( $pn, @N )->label( "N", "top" );

        $l{M} = Line->new( $pn, @M, $M[0] + $k*$a, $M[1] )->tick_marks($a);
        $l{N} = Line->new( $pn, @N, $N[0] + $k2*$b, $N[1] )->tick_marks($b);
        
        $t3->math("M = m\\{dot}A");
        $t3->math("N = n\\{dot}B");
        $t3->blue([0..20]);
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the ratios A to B, C to D are equal and since ".
        "equimultiples G,H,K and L,M,N have been taken...");
        $t1->explain("... so if M is greater than N, then G is greater than K".
        " etc\\{nb}(V.def\\{nb}5)");
        
        $t3->grey([0..20]);
        $t3->blue([0,4,6,8,9]);
        $t2->grey([0,1]);
        
        $t2->math("m\\{dot}A >=< n\\{dot}B ".
        "\\{then} m\\{dot}C >=< n\\{dot}D");
        $t2->math("  M >=< N  \\{then}   G >=< K");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But G is greater than K, then so is M greater than N");
        $t2->grey([0..20]);
        $t2->black([0,3]);
        $t3->grey([0..20]);
        $t2->math("M > N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("M,H are equimultiples of A,E, and N,L are equimultiples ".
        "of B,F");
        $t1->explain("Since M is greater than N, and H is less than L...");
        $t2->grey([0..20]);
        $t2->black([1,4]);
        $t3->grey([0..20]);
        $t3->blue([8,9,5,7]);
        $t2->down;
        $t2->math("m\\{dot}A > n\\{dot}B");
        $t2->math("m\\{dot}E < n\\{dot}F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... the ratio A to B is greater than the ratio E to\\{nb}".
        "F\\{nb}(V.def.7)");
        $t2->down;
        $t2->grey([0..20]);
        $t3->grey([0..20]);
        $t3->blue([0,1]);
        $t2->black([5,6]);
        $t2->math("A:B > E:F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t3->grey([0..20]);
        $t2->black([7]);
        $t3->blue([0,1]);
    };


    return $steps;

}

