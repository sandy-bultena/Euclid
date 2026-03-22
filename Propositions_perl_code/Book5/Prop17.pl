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
    "If magnitudes be proportional COMPONENDO, they will also be proportional SEPARANDO";

$pn->title( 17, $title, 'V' );

my $down    = 40;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 160, 200 + 4 * $down + $offset );
my $t4      = $pn->text_box( 100, 200 + 0 * $down );
my $t2      = $pn->text_box( 400, 200 + 4 * $down + $offset);
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 17 );
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
    my $a      = 180;
    my $b      = $a*$p;
    my $c      = 130;
    my $d      = $c*$p;
    my $offset = 20;
    my @start  = (150,300,300+$a, 300+$a+100, 300+$a*$p, 300+$a+100+$c*$p);
    my @s2     = (150,150+$k*($a*$p),150+$k*$a,150+$k*$c*$p,150+$k*$c);
    my @s3     = ($s2[2]+$k2*($a-$a*$p), $s2[4]+$k2*($c-$c*$p));
    my @A      = ( $start[1], 200 );
    my @C      = ( $start[3], $A[1] );
    my @B      = ( $start[2], $A[1] );
    my @D      = ( $start[3]+$c, $A[1] );
    my @E      = ( $start[4], $A[1]);
    my @F      = ( $start[5], $A[1] );
    my @G      = ( $start[0], $B[1]  + $down + $offset);
    my @H      = ( $s2[1], $G[1] );
    my @K      = ( $s2[2], $G[1] );
    my @O      = ( $s3[0], $G[1] );
    my @L      = ( $start[0], $G[1]+$down);
    my @M      = ( $s2[3], $L[1]);
    my @N      = ( $s2[4], $L[1]);
    my @P      = ( $s3[1], $L[1]);

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

        $tdot->explain("14.");
        $tindent->explain( "COMPOSITION OF A RATIO means taking the antecedent".
        " together with the consequent as one in relation to the consequent by itself");
        $tdot->y( $tindent->y );

        $t4->explain("the componendo (composition) ratio of A:B is (A+B):B");

        $tdot->explain("15.");
        $tindent->explain( "SEPARATION OF A RATIO means taking the excess by ".
        "which the antecedent exceeds the consequent in relation ".
        "to the consequent by itself ");
        
        $tdot->y( $tindent->y );
        $tdot->explain("16.");
        $tindent->explain( "CONVERSION OF A RATIO means taking the antecedent in ".
        "relation to the excess by which the antecedent exceeds the consequent.");

        $t4->down;
        $t4->explain("the separando (separated) ratio of (A+B):B is A:B");

        $t4->down;
        $t4->explain("the convertendo (in conversion) ratio of (A+B):B is (A+B):A");
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
        $t1->explain("If AB, BE, CD, DF be magnitudes proportional COMPONENDO".
        " (V.def.14)");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $t3->math("AB:EB = CD:FD");
        $t3->math("(AE+EB):EB = (CF+FD):FD");
        $t3->down;
        $t3->allblue;
    };


    push @$steps, sub {
        $t1->explain("... then they will also be proportional SEPARANDO (V.def.15)");

        $t3->math("AE:EB = CF:FD");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("(AE+EB):EB = (CF+FD):FD");
        $t3->blue( [ 0,1 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let GH, HK, LM, MN be equimultiples of AE, EB, CF, FD");
        
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
        $p{K} = Point->new( $pn, @K )->label( "K", "top" );
        $p{L} = Point->new( $pn, @L )->label( "L", "top" );
        $p{M} = Point->new( $pn, @M )->label( "M", "top" );
        $p{N} = Point->new( $pn, @N )->label( "N", "top" );
        
        $l{G} = Line->new($pn,@G,@H)->tick_marks($p*$a);
        $l{H} = Line->new($pn,@H,@K)->tick_marks((1-$p)*$a);
        $l{L} = Line->new($pn,@L,@M)->tick_marks($p*$c);
        $l{M} = Line->new($pn,@M,@N)->tick_marks((1-$p)*$c);
        
        $t3->down;
        $t3->math("GH = m\\{dot}AE");
        $t3->math("HK = m\\{dot}EB");

        $t3->math("LM = m\\{dot}CF");
        $t3->math("MN = m\\{dot}FD");
        
        $t3->blue([0..4]);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let KO, NP be chance equimultiples of EB, FD");
        
        $p{O} = Point->new( $pn, @O )->label( "O", "top" );
        $p{P} = Point->new( $pn, @P )->label( "P", "top" );
        
        $l{K} = Line->new($pn,@K,@O)->tick_marks((1-$p)*$a);
        $l{N} = Line->new($pn,@N,@P)->tick_marks((1-$p)*$c);
        
        $t3->math("KO = n\\{dot}EB");
        $t3->math("NP = n\\{dot}FD");

        $t3->blue([0..20]);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since GH and HK are equimultiples of AE and EB, then the "
        ."sum of GH,HK is the same equimultiple of the sum of AE,EB\\{nb}(V.1)");
        
        foreach my $l (qw(C F K L M N D O P)) {eval{$l{$l}->grey};eval{$p{$l}->grey};}
        $p{K}->normal;
        
        $t3->grey([0..20]);
        $t3->blue([1,2]);
        $t2->down;
        $t2->down;
        $t2->math("GK = m\\{dot}AB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Also, since LM,MN are equimultiples of CF,FD, then the "
        ."sum of LM,MN is the same equimultiple of the sum of CF,FD (V.1)");
        
        foreach my $l (qw(A E B G H K N D O P)) {eval{$l{$l}->grey};eval{$p{$l}->grey};}
        foreach my $l (qw(L M C F)) {eval{$l{$l}->normal};eval{$p{$l}->normal};}
        $p{D}->normal;
        $p{N}->normal;
        
        $t3->grey([0..20]);
        $t3->blue([3,4]);
        $t2->grey([0..20]);
        $t2->math("LN = m\\{dot}CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Because everything is equimultiple to everything else, ".
        "GK and LN are equimultiples of AB and CD");
        
        foreach my $l (qw(A E C B G H)) {eval{$l{$l}->normal};eval{$p{$l}->normal};}
        $p{K}->normal;
        
        $t3->grey([0..20]);
        $t2->grey([0..20]);
        $t2->black([0,1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("HK,MN are equimultiples of EB,FD and KO,NP are also "
        ."equimultiples of EB,FD, then HO,MP are also equimultiples of EB,FD (V.2)");
        
        foreach my $l (qw(G L)) {eval{$l{$l}->grey};eval{$p{$l}->grey};}
        foreach my $l (qw(K O N P E F)) {eval{$l{$l}->normal};eval{$p{$l}->normal};}
        
        $t3->grey([0..20]);
        $t3->blue([2,4,5,6]);
        $t2->grey([0..20]);
        
        $t2->math("HO = (m+n)\\{dot}EB = k\\{dot}EB");
        $t2->math("MP = (m+n)\\{dot}FD = k\\{dot}FD");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since AB is to EB as CD to FD, and chance equimultiples "
        ."have been taken of AB,CD and EB,FD, then if GK is greater than HO, ".
        "so is LN greater than MP, etc. (V.def.5)");
        
        foreach my $l (qw(G L)) {eval{$l{$l}->normal};eval{$p{$l}->normal};}
        
        $t3->grey([0..20]);
        $t3->blue([0]);
        $t2->grey([0..20]);
        $t2->black([0..4]);
        
        $t2->down;
        $t2->math("m\\{dot}AB >=< k\\{dot}EB \\{then} ".
        "m\\{dot}CD >=< k\\{dot}FD");
        $t2->math("GK >=< HO \\{then} LN >=< MP");
        
        
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->allgrey;
        $t2->black(-1);
    };
    

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("In other words");
        $t1->explain("If AB, BE, CD, DF be magnitudes proportional COMPONENDO".
        " (V.def.14)");
        $t1->explain("... then they will also be proportional SEPARANDO (V.def.15)");
        $t1->title("Proof (cont)");

        $t2->erase;
        $t2->down;
        $t2->down;
        $t2->math("GK >=< HO \\{then} LN >=< MP");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Take the case where GK is greater than HO");
        $t2->grey(0);
        $t2->math("GK > HO \\{then} LN > MP");
        $t2->blue(1);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Subtract HK from both, then GH is also in excess of KO");
        $t2->math("GK - HK > HO - HK");
        $t2->math("GH > KO");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If GK is greater than HO, then LN is also greater than MP, "
        ."subtract MN from both, giving LM is greater than NP");
        $t2->grey([2,3]);
        $t2->math("LN - MN > MP - MN");
        $t2->math("LM > NP");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, we can show that if GH is equal to HO, then LM ".
        "is equal to NP, if equal, equal");
        $t2->grey([1,4,5]);
        $t2->black(0,3);
        $t2->down;
        $t2->math("GH >=< KO \\{then} LM >=< NP");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But GH,LM are equimultiples of AE,CF and KO,NP are ".
        "equimultiples of EB,FD, therefore AE is to EB as CF is to FD (V.def.5)");
        $t3->blue([1,3,5,6]);
        $t3->grey(0);
        $t2->grey([0..5]);
        $t2->math("m\\{dot}AE >=< n\\{dot}EB \\{then} m\\{dot}CF >=< n\\{dot}FD");
        $t2->math("AE:EB = CF:FD");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([1..6]);
        $t3->blue(0);
        $t2->grey([0..7]);
    };
    
    return $steps;

}

