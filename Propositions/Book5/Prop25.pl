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
    "If four magnitudes be proportional, the greatest and the least ".
    "are greater than the remaining two";

$pn->title( 25, $title, 'V' );

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
push @$steps, Proposition::toc5( $pn, 25 );
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
    my $p1     = 2.3 / 3;
    my $p2     = 1/2;
    my $a      = 300;
    my $e      = 200;
    my $c      = $a * $p1;
    my $f      = $c * $p1;
    my $offset = 20;
    my $s = 150;
    my @A      = ( $s, 200 );
    my @B      = ( $s+$a, $A[1]);
    my @C      = ( $s, $A[1]+2*$down  );
    my @D      = ( $s+$c, $C[1] );
    my @E      = ( $s, $A[1]+$down );
    my @F      = ( $s, $C[1] + $down);
    my @G      = ( $s+$e,$A[1]);
    my @H      = ( $s+$f,$C[1]);

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain(   "Let AB, CD, E, F be proportional so that AB is to CD ".
        "as is E to F, and let AB be the greatest of them, and F the least" );
        $t1->explain( "Then the sum of AB,F is greater than the sum of CD,E" );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->new( $pn, @A, @B );
        $l{C} = Line->new( $pn, @C, @D );
        $l{E} = Line->new( $pn, @E, $E[0]+$e,$E[1] );
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] );

        $t3->math("AB:CD = E:F");
        $t3->math("AB > CD,E,F    F < CD,E,AB");
        $t3->down;
        $t3->blue( [ 0, 1 ] );
        $t3->math("\\{then} AB + F > CD + E");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("AB:CD = E:F");
        $t3->math("AB > CD,E,F    F < CD,E,AB");
        $t3->blue( [ 0..20 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let AG equal E, and CH equal F");
        $t3->math("AG = E");
        $t3->math("CH = F");
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
                
        $t3->blue( [ 0..20 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, AB is to CD as AG is to CH");
        $t3->grey([1]);
        $t3->down;
        $t3->math("AB:CD = AG:CH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("GB,HD are the remainder of AB,CD less AG,CH, therefore ".
        "the remainder GB will be to the remainder HD as the whole AB".
        " is the whole CD (V.19)");
        $t3->grey([0..20]);
        $t3->black(4);
        $t3->math("AB:CD = GB:HD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But AB is greater than CD; therefore GB is greater ".
        "than HD (V.def.5)");
        $t3->grey([0..20]);
        $t3->black(5);
        $t3->blue(1);
        $t3->math("GB > HD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since AG is equal to E, and CH to F, The sum AG,F".
        " is equal to the sum CH,E");
        $t3->grey([0..20]);
        $t3->blue([2,3]);
        $t3->math("AG + F = CH + E");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("GB is greater than HD, add AG,F to GB, and add CH,E to HD ".
        "... ");
        $t3->grey([0..20]);
        $t3->black([6..10]);
        $t3->math("GB + (AG+F) > HD + (CH+E)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([6,7]);
        $t3->math("(GB+AG) + F > (HD+CH) + E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... ".
        "if follows that the sum AB,F is greater than the sum CD,E");
        $t3->grey([8]);
        $t3->math("AB + F > CD + E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..20]);
        $t3->blue([0,1]);
        $t3->black(10);        
    };
    

    return $steps;

}

