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
    "Of unequal magnitudes, the greater has to the same a greater "
  . "ratio than the less has; and the same has to the less a "
  . "greater ratio than it has to the greater";

$pn->title( 8, $title, 'V' );

my $down    = 40;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 160, 200 + 7 * $down + $offset );
my $t4      = $pn->text_box( 160, 200 + 0 * $down );
my $t2      = $pn->text_box( 500, 200 + 4 * $down );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 8 );
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
    my $p      = 1 / 1.2;
    my $k      = 4;
    my $k2     = 3;
    my $a      = 180;
    my $c      = 125;
    my $d      = 70;
    my $offset = 20;
    my @A      = ( 150, 200 );
    my @B      = ( 150 + $a, 200 );
    my @C      = ( 150, 200 + $down );
    my @D      = ( 150, 200 + 4 * $down + $offset );
    my @E      = ( $B[0] - $c, $B[1] );
    my @F      = ( 150, 200 + 2 * $down );
    my @G      = ( $F[0] + 2 * ( $a - $c ), $F[1] );
    my @H      = ( $G[0] + 2 * $c, $G[1] );
    my @K      = ( 150, 200 + 3 * $down );
    my @M      = ( 150, $D[1] + $down );
    my @N      = ( 150, $M[1] + $down );

    # -------------------------------------------------------------------------
    # Definitions
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Definitions");
        $tdot->y( $t1->y );
        $tindent->y( $t1->y );

        $tdot->explain("4.");
        $tindent->explain( "Magnitudes are said to HAVE A RATIO to one another "
                . "which are capable, when multiplied, of exceeding one another"
        );
        $tdot->y( $tindent->y );

        $t4->math("A and B have a ratio (A:B) if there ");
        $t4->math("exists a 'p' and 'q' such that");
        $t4->math("pA > B, and A < qB");

    };

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
        $t1->explain(
                "Let AB be greater than C and let D be an arbitrary magnitude");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $l{AB} = Line->join( $p{A}, $p{B} );

        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );

        $t3->math("AB > C \\{notequal} D");
        $t3->blue(0);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
              "Then the ratio of AB to D is greater than the ratio of C to D ");
        $t1->explain(
                 "Then the ratio of D to AB is less than the ratio of D to C ");
        $t3->math("AB:D > C:D");
        $t3->math("D:AB < D:C");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof");
        $t3->erase();
        $t3->math("AB > C \\{notequal} D");
        $t3->blue(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                   "First, let EB be equal to C.  Then the lesser of AE,EB can "
                     . "be multiplied by a number such that it is larger than D"
                     . "\\{nb}(V def.4)" );

        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $t3->math("EB = C");
        $t3->blue(1);

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
#        $t1->erase;
        $t1->explain("CASE 1: AE < EB");
        $t3->math("AE < EB");
        $t3->blue(2);
        $t3->grey( [ 0, 1 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                 "Define a line FG such that is is a multiple of AE, AND it is "
                   . "larger than D" );
        $t3->grey(2);

        $p{F} = Point->new( $pn, @F )->label( "F", "top" );
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $l{FG} = Line->join( $p{F}, $p{G} )->tick_marks( $a - $c );

        $t3->math("FG = n\\{dot}AE > D");
        $t3->blue(3);

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Using the same multiple, define line GH to be "
              . "the same multiple of EB, and K to be the same multiple of C" );

        $p{H} = Point->new( $pn, @H )->label( "H", "top" );

        $l{GH} = Line->join( $p{G}, $p{H} )->tick_marks($c);

        $p{K} = Point->new( $pn, @K )->label( "K", "top" );
        $l{K} = Line->new( $pn, @K, $K[0] + 2 * $c, $K[1] )->tick_marks($c);

        $t3->math("GH = n\\{dot}EB");
        $t3->math("K  = n\\{dot}C");
        $t3->blue( [ 4, 5 ] );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Define lines M and N such that ");
        $tdot->y( $t1->y );
        $tindent->y( $t1->y );

        $tdot->explain("*");
        $tindent->explain("M is one less multiple than N, ");

        $tdot->explain("*");
        $tindent->explain("M is less than or equal to K ");
        $tdot->y( $tindent->y );

        $tdot->explain("*");
        $tindent->explain("and N is greater than K");
        $tdot->y( $tindent->y );

        $p{M} = Point->new( $pn, @M )->label( "M", "top" );
        $p{N} = Point->new( $pn, @N )->label( "N", "top" );

        $l{M} = Line->new( $pn, @M, $M[0] + 3 * $d, $M[1] )->tick_marks($d);
        $l{N} = Line->new( $pn, @N, $N[0] + 4 * $d, $N[1] )->tick_marks($d);

        $t3->grey( [ 3 .. 5 ] );
        $t3->math("M = (j-1)\\{dot}D \\{lessthanorequal} K");
        $t3->math("N =     j\\{dot}D > K");
        $t3->blue( [ 6, 7 ] );

        $t1->y( $tindent->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $tindent->erase;
        $tdot->erase;
        $t1->title("Proof");
        $t1->explain("Case 1: AE < EB");
        $t1->explain(
            "Since FG is the same multiple of AE as GH is to EB, then sum of "
              . "FG,GH (FH) is the same multiple of the sum AE,EB (AB)\\{nb}(V.1)"
        );
        $t3->blue( [ 3, 4 ] );
        $t3->grey( [ 6, 7 ] );
        $t2->math("FH = n\\{dot}AB");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "But FG is the same multiple of AE that K is of C, "
                 . "therefore FH is the same multiple of AB that K is of C. " );
        $t1->explain("Therefore FH and K are equimultiples of AB and C.");
        $t3->blue(1);
        $t3->grey(4);
        $t3->blue( [ 3, 5 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since GH and K are equimultiples of EB and C, and "
                      . "EB and C are equal, GH equals K" );
        $t3->grey( [ 3, 8 ] );
        $t3->blue( [ 4 .. 5 ] );
        $t2->grey(0);
        $t2->math("GH = K");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "Since GH equals K, and K is greater than M, GH is greater than M");
        $t3->grey( [ 0 .. 10 ] );
        $t2->grey( [ 0 .. 10 ] );
        $t2->math("GH \\{greaterthanorequal} M");
        $t3->blue(6);
        $t2->black(1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "FG is greater than D, GH is greater than or equal to M, so the sum "
                      . "of FG,GH is greater than the sum D,M" );
        $t3->grey( [ 0 .. 10 ] );
        $t2->grey( [ 0 .. 10 ] );
        $t2->black(2);
        $t3->blue(3);

        $t2->math("FH = FG+GH > D + M");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "But M is defined as one less multiple of D than N, so the "
                      . "sum of D,M is equal to N" );
        $t1->explain("Thus FH is greater than N");
        $t3->grey( [ 0 .. 10 ] );
        $t2->grey( [ 0 .. 10 ] );
        $t3->blue( [ 6, 7 ] );
        $t2->black(3);

        $t2->math("D+M = N");
        $t2->math("FH > N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey( [ 0 .. 10 ] );
        $t2->grey( [ 0 .. 10 ] );

        $t2->black(5);
        $t3->blue( [7] );
        $t1->explain("But N is defined to be greater than K");
        $t2->math("K  < N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Rewriting the resulting inequalities as the appropriate "
            . "multiples of AB,C and D, we have the definition used to describe "
            . "inequalities of ratios (V def.7)" );
        $t3->grey(  [ 0 .. 10 ] );
        $t2->grey(  [ 0 .. 10 ] );
        $t2->black( [ 0, 5, 6 ] );
        $t3->blue(5);
        $t3->blue(7);
        $t2->math("n\\{dot}AB > j\\{dot}D, n\\{dot}C < j\\{dot}D");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus the ratio AB to D is larger than the ratio C to D");
        $t3->grey( [ 0 .. 10 ] );
        $t2->grey( [ 0 .. 10 ] );
        $t2->black(7);
        $t2->math("AB:D > C:D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey( [ 0 .. 10 ] );
        $t2->grey( [ 0 .. 10 ] );
        $t3->blue(0);
        $t2->black(8);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                     "Similarly, reversing the comparison operators, it can be "
                       . "seen that the ratio D to C is greater than D to AB" );
        $t2->down;
        $t2->math("j\\{dot}D > n\\{dot}C, j\\{dot}D < n\\{dot}AB");
        $t2->math("D:C > D:AB");
    };

    ###########################################################################
    ###########################################################################
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c = $d - 10;
        $d = $d + 5;
        @A = ( 150, 200 );
        @B = ( 150 + $a, 200 );
        @C = ( 150, 200 + $down );
        @D = ( 150, 200 + 4 * $down + $offset );
        @E = ( $B[0] - $c, $B[1] );
        @F = ( 150, 200 + 2 * $down );
        @G = ( $F[0] + 2 * ( $a - $c ), $F[1] );
        @H = ( $G[0] + 2 * $c, $G[1] );
        @K = ( 150, 200 + 3 * $down );
        @M = ( 150, $D[1] + $down );
        @N = ( 150, $M[1] + $down );
        $t3->erase();
        $t1->erase();
        $t2->erase();

        foreach my $o ( values %l, values %p ) {
            $o->remove;
        }
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $l{AB} = Line->join( $p{A}, $p{B} );

        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );

        $t1->title("Proof");
        $t1->explain(
                   "First, let EB be equal to C.  Then the lesser of AE,EB can "
                     . "be multiplied by a number such that it is larger than D"
                     . "\\{nb}(V def.4)" );

        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $t3->math("AB > C");
        $t3->math("EB = C");
        $t3->blue([0,1]);

#        $t1->erase;
        $t1->explain("CASE 2: AE > EB");
        $t3->math("AE > EB");

        $t1->explain(
                 "Define a line GH such that is is a multiple of EB, AND it is "
                   . "larger than D" );

        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
        $l{GH} = Line->join( $p{G}, $p{H} )->tick_marks($c);

        $t3->math("GH = n\\{dot}EB > D");

        $t1->explain( "Using the same multiple, define line KG to be "
              . "the same multiple of AE, and K to be the same multiple of C" );

        $p{K} = Point->new( $pn, @K )->label( "K", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{FG} = Line->join( $p{F}, $p{G} )->tick_marks( $a - $c );

        $p{K} = Point->new( $pn, @K )->label( "K", "top" );
        $l{K} = Line->new( $pn, @K, $K[0] + 2 * $c, $K[1] )->tick_marks($c);

        $t3->math("FG = n\\{dot}AE");
        $t3->math("K  = n\\{dot}C");
        $t3->down;

        $t1->explain("Define lines M and N such that ");
        $tdot->y( $t1->y );
        $tindent->y( $t1->y );

        $tdot->explain("*");
        $tindent->explain("M is one less multiple than N, ");

        $tdot->explain("*");
        $tindent->explain("M is less than or equal to FG ");
        $tdot->y( $tindent->y );

        $tdot->explain("*");
        $tindent->explain("and N is greater than FG");
        $tdot->y( $tindent->y );

        $p{M} = Point->new( $pn, @M )->label( "M", "top" );
        $p{N} = Point->new( $pn, @N )->label( "N", "top" );

        $l{M} = Line->new( $pn, @M, $M[0] + 3 * $d, $M[1] )->tick_marks($d);
        $l{N} = Line->new( $pn, @N, $N[0] + 4 * $d, $N[1] )->tick_marks($d);

        $t3->math("M = (j-1)\\{dot}D \\{lessthanorequal} FG");
        $t3->math("N =     j\\{dot}D > FG");

        $t1->y( $tindent->y );
        $t3->blue( [ 0 .. 10 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $tdot->erase;
        $tindent->erase;
        $t1->title("Proof");
        $t1->explain("Case 2: AE > EB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("FH,K are equimultiples of AB and C");
        $t3->grey([0..10]);
        $t3->blue([3,4,5]);
        $t2->math("FH = n\\{dot}AB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The whole of FH is greater than the sum of D and M, "
        ."which is equal to N");
        $t3->grey([0..10]);
        $t3->blue([3,6]);
        $t2->grey([0..10]);
        $t2->math("FH > D+M \\{then} FH > N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain ("K is equal to GH");
        $t3->grey([0..10]);
        $t2->grey([0..10]);
        $t2->math("K = GH");
        
        $t3->blue([1,3,5]);        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain ("But K is equal to GH, and GH is less than FG which is less than N ".
        "thus K is less than N");
        $t3->grey([0..10]);
        $t2->grey([0..10]);
        $t2->math("K = GH");
        $t2->math("GH < FG \\{lessthanorequal} N");
        $t2->math("K < N");
        
        $t3->blue([2,3,6,5]);        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore we have the inequalities that prove the relationships ".
        "between the ratios");
        $t3->grey([0..10]);
        $t2->grey([0..10]);
        $t3->blue([5,7]);
        $t2->down;
        $t2->black([0,1,5]);
        $t2->math("n\\{dot}AB > j\\{dot}D");
        $t2->math("n\\{dot}C  < j\\{dot}D");
        $t2->down;
        $t2->math("AB:D > C:D");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..10]);
        $t2->grey([0..10]);
        $t3->blue([0]);
        $t2->blue([8]);
    };

    return $steps;

}

