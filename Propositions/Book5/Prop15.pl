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
    "Parts have the same ratio as the same multiples of them taken ".
    "in corresponding order";

$pn->title( 15, $title, 'V' );

my $down    = 60;
my $offset  = 15;
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 160, 200 + 2 * $down + $offset );
my $t4      = $pn->text_box( 160, 200 + 0 * $down );
my $t2      = $pn->text_box( 400, 200 + 2 * $down + $offset);
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 15 );
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
    my $c      = 80;
    my $f      = 60;
    my $offset = 20;
    my @start  = (150,150+3*$c+100);
    my @A      = ( $start[0], 200 );
    my @C      = ( $start[1], $A[1] );
    my @B      = ( $start[0]+3*$c, $A[1] );
    my @D      = ( $start[0], $A[1]  + $down);
    my @E      = ( $start[0]+3*$f, $A[1]  + $down);
    my @F      = ( $start[1], $A[1]  + $down );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("If AB is the same multiple of C as DE is of F ...");
        $t1->explain("... then the ratio of AB to DE is the same as D is to F");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->join($p{A},$p{B})->tick_marks($c);
        $l{D} = Line->join($p{D},$p{E} )->tick_marks($f);
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] )->tick_marks($c);
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] )->tick_marks($f);

        $t3->math("AB = m\\{dot}C");
        $t3->math("DE = m\\{dot}F");
        $t3->blue( [ 0,1 ] );
        $t3->down;
        $t3->math("AB:DE = C:F");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->title("Proof");
        $t3->math("AB = m\\{dot}C");
        $t3->math("DE = m\\{dot}F");
        $t3->blue( [ 0,1 ] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let AB be divided into the magnitudes AG, GH, HB, where ".
        "each is equal to C, and let DE be divided into magnitudes DK, KL, LE ".
        "where each is equal to F");
        
        $p{G} = Point->new($pn,$l{A}->point($c))->label("G","top");
        $p{H} = Point->new($pn,$l{A}->point(2*$c))->label("H","top");
        $p{K} = Point->new($pn,$l{D}->point($f))->label("K","top");
        $p{L} = Point->new($pn,$l{D}->point(2*$f))->label("L","top");
        
        $t3->down;
        $t3->math("AG = GH = HB = C");
        $t3->math("DK = KL = LE = F");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since AG, GH, HB are equal and DK, KL, LE are equal ".
        "therefore AG is to DK as GH is to KL, as HB is to LE (V.7)");
        $t3->grey([0,1]);
        $t3->math("AG:DK = GH:KL = HB:LE");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since all the ratios are equal, then the sum of the "
        ."antecedents to the sum of the consequents will have the same ratio (V.12)");
        
        $t3->grey([2,3]);
        $t3->math("AG:DK = AB:DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But AG is equal to C, and DK is equal to F, so the ".
        "ratio of C to F is the same as the ratio of AB to DE");
        $t3->grey(4);
        $t3->black([2,3]);
        $t3->math("C:F = AB:DE"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([2..5]);
        $t3->blue([0,1]);
    };


    return $steps;

}

