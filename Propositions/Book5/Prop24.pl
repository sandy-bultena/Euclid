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
    "If a first magnitude have to a second the same ratio as a third has ".
    "to a fourth, and also a fifth have to the second the same ratio as a ".
    "sixth to the fourth, the first and fifth added together will have to ".
    "the second the same ratio as the third and sixth have to the fourth.";

$pn->title( 24, $title, 'V' );

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
push @$steps, Proposition::toc5( $pn, 24 );
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
    my $p2     = 1/2;
    my $a      = 300;
    my $c      = $a * $p1;
    my $b      = $c*$p2;
    my $d      = 250;
    my $f      = $d * $p1;
    my $e      = $f * $p2;
    my $offset = 20;
    my $s = 150;
    my @A      = ( $s, 200 );
    my @B      = ( $s+$a, $A[1]);
    my @C      = ( $s, $A[1]+$down  );
    my @D      = ( $s, $C[1]+$down );
    my @E      = ( $s+$d, $D[1] );
    my @F      = ( $s, $D[1] + $down);
    my @G      = ( $B[0]+$b,$A[1]);
    my @H      = ( $E[0]+$e, $D[1]);

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain(   "Let AB to C be as DE to F, and let BG to C be as EH to F" );
        $t1->explain( "Then AG (sum of AB,BG) will be to C as DH (sum of DE,EH) is to F" );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );

        $l{A} = Line->new( $pn, @A, @G );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{D} = Line->new( $pn, @D, @H );
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] );

        $t3->math("AB:C = DE:F");
        $t3->math("BG:C = EH:F");
        $t3->down;
        $t3->blue( [ 0, 1 ] );
        $t3->math("\\{then} (AB+BG):C = (DE+EH):F");
        $t3->math("  AG:C = DH:F");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("AB:C = DE:F");
        $t3->math("BG:C = EH:F");
        $t3->blue( [ 0, 1 ] );
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since BG is to C, so is EH to F, therefore inversely, ".
        "as C is to BG as F is to EH");
        $t3->grey(0);
        $t3->math("C:BG = F:EH");        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since AB is to C as DE is to F, and C is to BG as ".
        "F is to EH, Then AB is to BG so is DE to EH (V.22)");
        $t3->blue(0);
        $t3->grey(1);
        $t3->math("AB:BG = DE:EH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And, since magnitudes are proportional SEPARANDO, they ".
        "will also be proportional COMPONENDO; therefore, as AG ".
        "is to BG, so is DH to EH (V.18)");
        $t3->grey([0..2]);
        
        $t3->math("(AB+BG):BG = (DE+EH):EH");
        $t3->math("AG:BG = DH:EH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But also, as BG is to C so EH is to F; therefore ".
        "EX AEQUALI, as AG is to C, so DH is to F (V.22)");
        $t3->grey([0..4]);
        $t3->blue(1);
        
        $t3->math("AG:C = DH:F");
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..5]);
        $t3->blue([0,1]);
        
    };

    return $steps;

}

