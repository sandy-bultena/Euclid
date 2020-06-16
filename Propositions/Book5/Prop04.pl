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
my $title = "If a first magnitude have to a second the same ratio as a third ".
"to a fourth, any equimultiples whatever of the first and third will also ".
"have the same ratio to any equimultiples whatever of the second and fourth ".
"respectively, taken in corresponding order.";

$pn->title( 4, $title, 'V' );

my $down = 30;
my $offset = 15;
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t3 = $pn->text_box( 160, 200+7*$down );
my $t4 = $pn->text_box( 160, 200+3*$down );
my $t2 = $pn->text_box( 450, 200+8*$down );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 4 );
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
    my $p = 1/1.2;
    my $k = 3;
    my $a = 45;
    my $c = 60;
    my $k2 = 2;
    my @A = (150, 200);
    my @B = (150, 200+$down);
    my @C = (400, 200);
    my @D = (400, 200+$down);
    my @E = (150, 200+2*$down+$offset);
    my @F = (400, 200+2*$down+$offset);
    my @G = (150, 200+3*$down+$offset);
    my @H = (400, 200+3*$down+$offset);
    my @K = (150, 200+4*$down+2*$offset);
    my @L = (400, 200+4*$down+2*$offset);
    my @M = (150, 200+5*$down+2*$offset);
    my @N = (400, 200+6*$down+2*$offset);

    # -------------------------------------------------------------------------
    # Definitions
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Definitions");
        $tdot->y($t1->y);
        $tindent->y($t1->y);
        $tdot->explain("3.");
        $tindent->explain("A RATIO is a sort of relation in respect of size ".
        "between two magnitudes of the same kind");
        $tdot->y($tindent->y);

        $tdot->explain("4.");
        $tindent->explain("Magnitudes are said to HAVE A RATIO to one another ".
        "which are capable, when multiplied, of exceeding one another");
        $tdot->y($tindent->y);
        
        $p{A} = Point->new($pn,@A)->label("A","left");
        $p{B} = Point->new($pn,@B)->label("B","left");
        
        $l{A} = Line->new($pn,@A,$A[0]+$a,$A[1]);
        $l{B} = Line->new($pn,@B,$B[0]+$p*$a,$B[1]);

        $t4->math("A and B have a ratio (A:B) if there ");
        $t4->math("exists a 'p' and 'q' such that");
        $t4->math("p\\{dot}A > B, and A < q\\{dot}B");
    };

    push @$steps, sub {
        $tdot->explain("5.");
        $tindent->explain("Magnitudes are said to BE IN THE SAME RATIO, the first ".
        "to the second and the third to the fourth, when, if any equimultiples ".
        "whatever be taken of the first and third, and any equimultiples whatever ".
        "of the second and fourth, the former equimultiples alike exceed, ".
        "are alike equal to, or alike fall short of, the latter equimultiples ".
        "respectively taken in corresponding order");
        $tdot->y($tindent->y);

        $p{C} = Point->new($pn,@C)->label("C","left");
        $p{D} = Point->new($pn,@D)->label("D","left");
        
        $l{C} = Line->new($pn,@C,$C[0]+$c,$C[1]);
        $l{D} = Line->new($pn,@D,$D[0]+$p*$c,$D[1]);

        $t4->down;
        $t4->math("The ratio A:B = C:D if, for any number 'p' and 'q'");
        $t4->math("  if p\\{dot}A > q\\{dot}B then p\\{dot}C > q\\{dot}D");
        $t4->math("  if p\\{dot}A < q\\{dot}B then p\\{dot}C < q\\{dot}D");
        $t4->math("  if p\\{dot}A = q\\{dot}B then p\\{dot}C = q\\{dot}D");
        $t4->down;
        $t4->math("  p\\{dot}A >=< q\\{dot}B \\{then} p\\{dot}C >=< q\\{dot}D");
        $t4->down;
        $t4->math("if   A:B = C:D");
        $t4->math("then p\\{dot}A >=< q\\{dot}B \\{then} p\\{dot}C >=< q\\{dot}D");
    };

    push @$steps, sub {
        $tdot->erase;
        $tindent->erase;
        $t4->erase;
        $t1->erase;
        $p{A}->remove;
        $p{B}->remove;
        $l{A}->remove;
        $l{B}->remove;
        $p{C}->remove;
        $p{D}->remove;
        $l{C}->remove;
        $l{D}->remove;
    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let the ratio of A to B be the same ratio C to D");

        $p{A}=Point->new($pn,@A)->label("A","left");
        $p{B}=Point->new($pn,@B)->label("B","left");
        $l{A}=Line->new($pn,@A,$A[0]+$a,$A[1]);
        $l{B}=Line->new($pn,@B,$B[0]+$a*$p,$B[1]);
        
        $p{C}=Point->new($pn,@C)->label("C","left");
        $p{D}=Point->new($pn,@D)->label("D","left");
        $l{C}=Line->new($pn,@C,$C[0]+$c,$C[1]);
        $l{D}=Line->new($pn,@D,$D[0]+$c*$p,$D[1]);

        $t3->math("A:B = C:D");
        $t3->math("pA >=< qB \\{then} pC >=< qD");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw lines E and F that are equimultiple to A and C");

        $p{E}=Point->new($pn,@E)->label("E","left");
        $p{F}=Point->new($pn,@F)->label("F","left");
        $l{E}=Line->new($pn,@E,$E[0]+$k2*$a,$E[1])->tick_marks($a);
        $l{F}=Line->new($pn,@F,$F[0]+$k2*$c,$F[1])->tick_marks($c);
        
        $t3->math("E = i\\{dot}A");
        $t3->math("F = i\\{dot}C");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw lines G and H that are equimultiple to B and D");

        $p{G}=Point->new($pn,@G)->label("G","left");
        $p{H}=Point->new($pn,@H)->label("H","left");
        $l{G}=Line->new($pn,@G,$G[0]+$k*$a*$p,$G[1])->tick_marks($a*$p);
        $l{H}=Line->new($pn,@H,$H[0]+$k*$c*$p,$H[1])->tick_marks($c*$p);
        
        $t3->math("G = j\\{dot}B");
        $t3->math("H = j\\{dot}D");
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The ratio E to G is equal to the ratio F to H");

        $t3->down;        
        $t3->math("E:G = F:H");
        $t3->math("... or if    A:B  =  C:D ");
        $t3->math("       then i\\{dot}A:j\\{dot}B = i\\{dot}C:j\\{dot}D");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->down();
        $t1->title("Proof");
        $t3->math("A:B = C:D");
        $t3->math("pA >=< qB \\{then} pC >=< qD");
        $t3->down;
        $t3->math("E = i\\{dot}A, F = i\\{dot}C");
        $t3->math("G = j\\{dot}B, H = j\\{dot}D");
        $t3->blue([0..4]);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw lines K and L that are equimultiple to E and F");

        $p{K}=Point->new($pn,@K)->label("K","left");
        $p{L}=Point->new($pn,@L)->label("L","left");
        $l{K}=Line->new($pn,@K,$K[0]+$k2*$l{E}->length,$K[1])->tick_marks($l{E}->length);
        $l{L}=Line->new($pn,@L,$L[0]+$k2*$l{F}->length,$L[1])->tick_marks($l{F}->length);
        
        $t3->grey(1);
        $t3->math("K = mE, L = mF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw lines M and N that are equimultiple to G and H");

        $p{M}=Point->new($pn,@M)->label("M","left");
        $p{N}=Point->new($pn,@N)->label("N","left");
        $l{M}=Line->new($pn,@M,$M[0]+$k*$l{G}->length,$M[1])->tick_marks($l{G}->length);
        $l{N}=Line->new($pn,@N,$N[0]+$k*$l{H}->length,$N[1])->tick_marks($l{H}->length);
        
        $t3->math("M = nG, N = nH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Since E and F are the same multiple of A and C, and "
        ."K and L are the same multiple of E and F, then K and L are also the "
        ."same multiple of A and C\\{nb}(V.3)");

        $t3->down;
        $t3->grey([0,3,5]);
        $t3->math("K = pA, L = pC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Likewise M and N are equimultiples of B and D\\{nb}(V.3)");
        $t3->blue(3);
        $t3->grey([2,4,6]);
        $t3->black(5);
        $t3->math("M = qB, N = qD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Because K and L are equimultiples of A,C, and M,N are ".
        "equimultiples of B,D, then if K exceeds M, L exceeds N, etc ".
        "(V\\{nb}def\\{nb}5)");
        $t3->blue([0,1]);
        $t3->grey([2..5]);
        $t3->black([6,7]);
        $t2->math(" K >=<  M \\{then}  L >=<  N");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("K,L are equimultiples of E,F and M,N are equimultiples of G,H");
        $t2->down;
        $t3->black([4,5]);
        $t3->grey([6,7]);
        $t3->grey([1]);
        $t2->math("mE >=< nG \\{then} mF >=< nH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, E is to G as F is to H (V\\{nb}def\\{nb}5)");
        $t2->down;
        $t3->blue([0,2,3]);
        $t3->grey([4..7]);
        $t2->grey([0]);
        $t2->math("E:G = F:H");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->math("(i\\{dot}A):(j\\{dot}B) = (i\\{dot}C):(j\\{dot}D)");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->allgrey;
        $t2->black(-1);
        $t3->allgrey;
        $t3->blue(0);
    };

    return $steps;

}

