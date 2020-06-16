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
    "Magnitudes which have the same ratio to the same are equal to "
    ."one another; and magnitudes to which the same has the same ratio ".
    "are equal";

$pn->title( 9, $title, 'V' );

my $down    = 40;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 160, 200 + 3 * $down + $offset );
my $t4      = $pn->text_box( 160, 200 + 0 * $down );
my $t2      = $pn->text_box( 500, 200 + 4 * $down );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 9 );
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
    my $c      = 250;
    my $offset = 20;
    my @A      = ( 150, 200 );
    my @B      = ( 150 + $a + 100, 200 );
    my @C      = ( 150+0.5*$a, 200 + $down );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let the ratios of A to C and B to C be equal");
        $t1->explain("Then A and B are equal");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        
        $l{A} = Line->new($pn,@A,$A[0]+$a,$A[1]);
        $l{B} = Line->new($pn,@B,$B[0]+$a,$B[1]);
        $l{C} = Line->new($pn,@C,$C[0]+$c,$C[1]);
        
        $t3->math("A:C = B:C \\{then} A = B");
        $t3->math("C:A = C:B \\{then} A = B");
        $t3->blue([0,1]);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
       $t1->title("Proof");
        $t3->math("A:C = B:C");
        $t3->blue(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If A and B are not equal, then their ratios will not be ".
        "equal, thus they are equal\\{nb}(V.8)");
        $t3->math("A \\{notequal} B \\{then} A:C \\{notequal} B:C");
        $t3->math("but A:C = B:C \\{therefore} A = B"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t3->math("C:A = B:C");
        $t3->blue(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If A and B are not equal, then their ratios will not be ".
        "equal, thus they are equal\\{nb}(V.8)");
        $t3->math("A \\{notequal} B \\{then} C:A \\{notequal} C:B");
        $t3->math("but C:A = C:B \\{therefore} A = B"); 
    };

    return $steps;

}

