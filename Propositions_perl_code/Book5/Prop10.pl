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
    "Of magnitudes which have a ratio to the same, that which "
  . "has a greater ratio is greater; and that to "
  . "which the same has a greater ratio is less.";

$pn->title( 10, $title, 'V' );

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
push @$steps, Proposition::toc5( $pn, 10 );
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
    my $b      = 150;
    my $c      = 250;
    my $offset = 20;
    my @A      = ( 150, 200 );
    my @B      = ( 150 + $a + 100, 200 );
    my @C      = ( 150 + 0.5 * $a, 200 + $down );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let the ratio of A to C be greater than the ratio B to C");
        $t1->explain("Then A is greater than B");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $t3->math("A:C > B:C \\{then} A > B");
        $t3->math("C:B > C:A \\{then} B < A");
        $t3->blue( [ 0, 1 ] );
        $t3->down;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("A:C > B:C");
        $t3->blue(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "If A is not greater than B, then A either equals ".
        "B or is less than\\{nb}B" );
        $t1->explain( "If A equals B then the ratios A to C and B to C ".
        "would be equal\\{nb}(V.7)"); 
        $t1->explain( "If A is less than B then the ratio A to C would ".
        "be less than B\\{nb}to\\{nb}C\\{nb}(V.8)"); 
        $t3->math("A = B \\{then} A:C = B:C");
        $t3->math("A < B \\{then} A:C < B:C");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But A to C IS greater than B to C, therefore A ".
        "is greater than B");
        $t3->math("But A:C > B:C \\{therefore} A > B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t3->grey([0..10]);
        $t3->math("C:B > C:A");
        $t3->blue(4);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "If B is not less than A, then B either equals ".
        "A or is greater than\\{nb}A" );
        $t1->explain( "If B equals A then the ratios C to B and C to A ".
        "would be equal\\{nb}(V.7)"); 
        $t1->explain( "If B is greater than A then the ratio C to B would ".
        "be less than C\\{nb}to\\{nb}A\\{nb}(V.8)"); 
        $t3->math("B = A \\{then} C:B = C:A");
        $t3->math("B > A \\{then} C:B < C:A");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But C to B IS greater than C to A, therefore B ".
        "is less than A");
        $t3->math("But C:B > C:A \\{therefore} B < A");
    };

    return $steps;

}

