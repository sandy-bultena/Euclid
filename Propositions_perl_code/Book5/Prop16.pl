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
    "If our magnitudes be proportional, they will also be proportional alternately";

$pn->title( 16, $title, 'V' );

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
push @$steps, Proposition::toc5( $pn, 16 );
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
    my $a      = 100;
    my $b      = $a*$p;
    my $c      = 80;
    my $d      = $c*$p;
    my $offset = 20;
    my @start  = (150,150+3*$a+100);
    my @A      = ( $start[0], 200 );
    my @C      = ( $start[1], $A[1] );
    my @B      = ( $start[0], $A[1] + $down );
    my @D      = ( $start[1], $A[1]  + $down);
    my @E      = ( $start[0], $B[1]  + $down);
    my @F      = ( $start[0], $E[1]  + $down );
    my @G      = ( $start[1], $B[1]  + $down);
    my @H      = ( $start[1], $G[1]  + $down );

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

        $tdot->explain("6.");
        $tindent->explain( "Let magnitudes which have the same ratio be ".
        "called PROPORTIONAL");
        $tdot->y( $tindent->y );

        $t4->math("A:B = C:D \\{then} A,B,C,D are proportional");
        $t4->down;
        $t4->math("A,C \\{then} antecedents");
        $t4->math("B,D \\{then} consequents");

        $tdot->explain("12.");
        $tindent->explain( "ALTERNATE RATIO means taking the antecedent in relation to ".
        "the antecedent and the consequent in relation to the consequent" );
        
        $t4->down;
        $t4->math("given two ratios");
        $t4->math(" A:B and C:D ");
        $t4->math("then the alternate ratios are: ");
        $t4->math(" A:C and B:D")

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
        $t1->explain("If A,B,C,D are proportional,");
        $t1->explain("... then they will also be alternately proportional");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );

        $t3->math("A:B = C:D");
        $t3->blue( [ 0,1 ] );
        $t3->down;
        $t3->math("A:C = B:D");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("A:B = C:D");
        $t3->blue( [ 0,1 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let E,F be equimultiples of A and B, and G,H other chance "
        ."equimultiple of C,D");
        
        $p{E} = Point->new($pn,@E)->label("E","top");
        $p{F} = Point->new($pn,@F)->label("F","top");
        
        $l{E} = Line->new($pn,@E,$E[0]+3*$a,$E[1])->tick_marks($a);
        $l{F} = Line->new($pn,@F,$F[0]+3*$b,$F[1])->tick_marks($b);

        $p{G} = Point->new($pn,@G)->label("G","top");
        $p{H} = Point->new($pn,@H)->label("H","top");
       
        $l{G} = Line->new($pn,@G,$G[0]+2*$c,$G[1])->tick_marks($c);
        $l{H} = Line->new($pn,@H,$H[0]+2*$d,$H[1])->tick_marks($d);
        
        $t3->math("E = m\\{dot}A");
        $t3->math("F = m\\{dot}B");

        $t3->math("G = n\\{dot}C");
        $t3->math("H = n\\{dot}D");
        
        $t3->blue([0..4]);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since E,F are equimultiples of A,B, their ratios ".
        "are equal\\{nb}(V.15)");
        $t3->grey([0..20]);
        $t3->blue([1,2]);
        $t2->math("E:F = A:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But A is to B as C is to D, therefore E is to F as".
        " C is to\\{nb}D\\{nb}(V.11)");
        $t3->grey([0..20]);
        $t3->blue([0]);
        $t2->math("E:F = C:D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Again, since G, H are equimultiples of C,D, therefore ".
        " as C is to D, so is G to H (V.15)");
        $t3->grey([0..20]);
        $t3->blue([3,4]);
        $t2->grey([0..20]);
        $t2->math("G:H = C:D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But C is to D as E is to F, therefore G is to H as".
        " E is to\\{nb}F\\{nb}(V.11)");
        $t3->grey([0..20]);
        $t2->black(1);
        $t2->math("G:H = E:F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Because G,H,E,F are proportional, then if E is greater ".
        "than G, then F is greater than H, etc (V.14)");

        $t2->grey([0..20]);
        $t2->black(3);
        $t2->math("E >=< G \\{then} F >=< H");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Now E,F are equimultiples of A,B and G,H equimultiples".
        " of C,D so ...");

        $t2->grey([0..20]);
        $t2->black(4);
        $t3->blue([1..4]);
        $t2->math("m\\{dot}A >=< n\\{dot}C \\{then} m\\{dot}B >=< n\\{dot}D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... A is to C as B is to D (V.def.5)");

        $t2->grey([0..20]);
        $t2->black(5);
        $t3->grey([0..20]);
        $t3->blue([0]);
        $t2->math("A:C = B:D");
    };

    return $steps;

}

