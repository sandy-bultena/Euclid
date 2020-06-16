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
    "If magnitudes be proportional SEPARANDO, they will also be proportional COMPONENDO";

$pn->title( 18, $title, 'V' );

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
push @$steps, Proposition::toc5( $pn, 18 );
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
    my $c      = 350;
    my $d      = $c*$p;
    my $offset = 20;
    my @start  = (150,300,150+$a, 150+$a+100, 150+$a*$p, 150+$c*$p, 150+$c*$p+40);
    my @A      = ( $start[0], 200 );
    my @C      = ( $start[0], $A[1] + $down );
    my @B      = ( $start[2], $A[1] );
    my @D      = ( $start[0]+$c, $C[1] );
    my @E      = ( $start[4], $A[1]);
    my @F      = ( $start[5], $C[1] );
    my @G      = ( $start[6], $C[1]);

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
        $t1->explain("If AE, BE, CF, DF are proportional");
        $t1->explain("... then COMPENDO (joint) ratios will also be equal");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $t3->math("AE:EB = CF:FD");
        $t3->down;
        $t3->math("(AE+EB):EB = (CF+FD):FD");
        $t3->math("AB:EB = CD:FD");
        $t3->blue( [ 0 ] );
        $t3->down;
        $t3->math("a:b = c:d \\{then} (a+b):b = (c+d):d");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof by Contradiction");
        $t3->math("AE:EB = CF:FD");
        $t3->blue( [ 0,1 ] );
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume CD is not to DF as AB is to BE");
        $l{y} = $t3->y;
        $t3->math("CD:DF \\{notequal} AB:BE");
        $t1->explain("Then the ratio of AB to BE will be equal to CD to some "
        ."magnitude not equal to DF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that CD to GD is the correct ratio, ".
        "where GD is less than FD ");
        $p{G} = Point->new($pn,@G)->label("G","top");
        $t3->grey(1);
        $t3->math("GD < FD");
        $t3->math("AB:EB = CD:DG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since ratios that are proportional COMPRENDO will be ".
        "proportional SEPARANDO, AE is to EB as CG is to GD (V.17)");
        $t3->grey(2);
        $t3->math("AE:EB = CG:GD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But AE is to EB is the same as CF to FD by definition ".
        "so CF to FD is also the same as CG to GD (V.11)");
        $t3->grey(3);
        $t3->math("CG:GD = CF:FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("When two ratios are equal, if the first magnitude is larger than ".
        "the third, then the second is larger than the fourth, which means...");
        $t1->explain("... Since CG is greater than CF, GD is greater than".
        " FD (V.14)");
        $t3->grey(4);
        $t3->math("CG > CF \\{then} GD > FD");
       
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But that is impossible, so AB to EB cannot be the same as "
        ."CG is to GD, where GD is less than FD");
        $t1->explain("Similar arguments can show that the relationship cannot ".
        "hold true even if GD is greater than FD");
        $t3->red(2);
        $t3->grey(5);        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t3->math("CD:DF = AB:BE");
        $t3->y($l{y});
        $t3->math("               \\{wrong}");
        $t3->red([1,8]);
        $t3->grey([2,6]);
    };
    
    return $steps;

}

