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
    "If, as a whole is to a whole, so is a part subtracted to a part ".
    "subtracted, the remainder will also be to the remainder as whole to whole.";

$pn->title( 19, $title, 'V' );

my $down    = 60;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 80, 200 + 2 * $down + $offset );
my $t4      = $pn->text_box( 100, 200 + 0 * $down );
my $t2      = $pn->text_box( 420, 200 + 2 * $down + $offset);
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 19 );
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
    my $p      = 1/3;
    my ($a1,$a2) = (12,9);
    my $a      = $a1*40;
    my $c      = $a2*40;
    my $offset = 20;
    my @start  = (150,300,150+$a, 150+$a+100, 150+$a*$p, 150+$c*$p, 150+$c*$p+40);
    my @A      = ( $start[0], 200 );
    my @C      = ( $start[0], $A[1] + $down );
    my @B      = ( $start[2], $A[1] );
    my @D      = ( $start[0]+$c, $C[1] );
    my @E      = ( $start[4], $A[1]);
    my @F      = ( $start[5], $C[1] );
    my ($ab,$cd,$ae,$cf,$eb,$fd) = ($a1,$a2,$p*$a1,$p*$a2,(1-$p)*$a1,(1-$p)*$a2);
    $ab = "(u+v)";
    $cd = "(x+y)";
    $ae = "u";
    $cf = "x";
    $eb = "v";
    $fd = "y";

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
        $t1->explain("As the whole AB is to the whole CD, let the part AE be to CF, ");
        $t1->explain("... then the remainders (AB less AE, CD less CF) will also ".
        "be proportional");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{u} = Line->new( $pn, @A, @E) ->label("u","top");
        $l{v} = Line->new( $pn, @E, @B) -> label("v","top");
        $l{x} = Line->new( $pn, @C, @F)->label("x","top");
        $l{y} = Line->new( $pn, @F, @D)->label("y","top");

        $t3->math("AB:CD = AE:CF");
        $t3->down;
        $t3->math("AB:CD = (AB-AE):(CD-CF)");
        $t3->math("AB:CD = EB:FD");
        $t3->blue( [ 0 ] );

       # $l{A}->tickmarks(40);
       # $l{C}->tickmarks(40);
        $t2->math("$ab:$cd = $ae:$cf");
        $t2->blue( [ 0,1 ] );
        $t2->down;
        $t2->math("$ab:$cd = ($ab-$ae):($cd-$cf)");
        $t2->math("$ab:$cd = $eb:$fd");
        $t3->down;
        $t3->down;
        $t3->down;
        $t3->math("a:b = c:d \\{then} a:b = (a-c):(b-d)");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t2->erase();
        $t1->title("Proof");
        $t3->math("AB:CD = AE:CF");
        $t3->blue( [ 0,1 ] );
        $t3->down;
        $t2->math("$ab:$cd = $ae:$cf");
        $t2->blue( [ 0,1 ] );
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since AB is to CD as AE is to CF, the alternative ratios "
        ."are also equal, AB is to AE as CD is to CF (V.16)");

        $t3->math("AB:AE = CD:CF");
        $t2->math("$ab:$ae = $cd:$cf");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And since the magnitudes are proportional COMPONENDO, ".
        "they will also be proportional SEPARANDO (V.17)");
        
        $t3->math("(AB-AE):AE = (CD-CF):CF");
        $t3->math("EB:AE = FD:CF");
        $t2->math("($ab-$ae):$ae = ($cd-$cf):$cf");
        $t2->math("$eb:$ae = $fd:$cf");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The magnitudes EB,AE,FD,CF are proportional, and so are ".
        "the alternative ratios (V.16)");
        $t3->grey([1,2]);
        $t3->math("EB:FD = AE:CF");
        $t2->grey([1,2]);
        $t2->math("$eb:$fd = $ae:$cf");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But AE is to CF as AB is to CD, therefore ".
        "EB is to FD as AB is to CD (V.11)");
        $t3->grey(3);
        $t3->math("EB:FD = AB:CD");
        $t2->grey(3);
        $t2->math("$eb:$fd = $ab:$cd");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey(4);
        $t2->grey(4);
    };

   # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("PORISM: If magnitudes are proportional COMPONENDO ".
        "(V.def.14) they will also be proportional CONVERTENDO (V.def.16)");

        $t3->down;
        $t2->down;
        $t3->allgrey;
        $t2->allgrey;
        $t2->black(-1);
        $t3->black(-1);
        $t3->blue(0);
        $t2->blue(0);
        $t3->math("AB:CD = EB:FD");
        $t2->math("$ab:$cd = $eb:$fd");
        
    };


   # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey(-2);
        $t2->grey(-2);
    };

    return $steps;

}

