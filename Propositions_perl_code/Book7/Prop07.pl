#!/usr/bin/perl 
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;


# ============================================================================
# Definitions
# ============================================================================
my $title = "If a number be that part of a number, which a number subtracted is ".
"of a number subracted, the remainder will also be the same part of the ".
"remainder that the whole is of the whole";

$pn->title( 7, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $tp = $pn->text_box( 600, 180 );
    $t2->wide_math(1);
    $t4->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 7 );
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
    my (%p,%c,%s,%t,%l);
    my $ds = 200;
    my $dx = 20;
    my $dy = 60;
    my $dy1 = $ds;
    my $dy2 = $ds + $dy;
    my $dy3 = $ds + 2*$dy;
    my $dy4 = $ds + 3*$dy;
    my $dy5 = $ds + 4*$dy;
    my $dy6 = $ds + 5*$dy;
    my $A = my $C = 0;
    my $B = 6;
    my $E = 2;
    my $F = 2 * $E;
    my $D = 2*$B;
    my $G = $A-2*($B-$E);
    my $xl = 80-$G*$dx;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("If b is the same fraction of a as d is to c, then the result of d subtracted from b "
        ."will also be the same fraction of the result of c subtracted from a");
        $t2->math("b = a/q");
        $t2->math("d = c/q");
        $t2->math("\\{then} (b-d) = (a-c)/q");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Let the number AB be a part of CD, and let AE be the same part of CF");
        $t1->explain("And let AE be subtracted from AB, and CF be subtracted from CF");
       $p{A} = Point->new($pn,$xl+($A)*$dx,$dy1)->label("A","top");
       $p{B} = Point->new($pn,$xl+($B)*$dx,$dy1)->label("B","top");
       $p{C} = Point->new($pn,$xl+($C)*$dx,$dy2)->label("C","top");
       $p{D} = Point->new($pn,$xl+($D)*$dx,$dy2)->label("D","top");
       $p{E} = Point->new($pn,$xl+($E)*$dx,$dy1)->label("E","top");
       $p{F} = Point->new($pn,$xl+($F)*$dx,$dy2)->label("F","top");
       $l{AB} = Line->join($p{A},$p{B});
       $l{CD} = Line->join($p{C},$p{D});
       
       $t4->math("AB = (1/q)CD");
       $t4->math("AE = (1/q)CF");
       #$t4->math("CD = \\{sum(i=1,q)} AB");
       #$t4->math("CF = \\{sum(i=1,q)} AE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let EB be the same part of GC that AE is to CF");
        $t4->grey([0..20]);
        $t4->math("EB = (1/q)GC ");
        $p{G} = Point->new($pn,$xl+$G*$dx,$dy2)->label("G","top");
        $l{CG} = Line->join($p{C},$p{G});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since EB is the same part as CG as AE is of CF, the sum AB will be ".
        "the same part of the sum GF (VII.5)");
        $t4->black([1..20]);
        $t4->down;
        $t4->math("AE + EB = (1/q)(GC + CF) = (1/q)GF ");
        $t4->math("AB = (1/q)GF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Whatever fraction AB is of GF, it is the same fraction of CD; ");
        $t4->grey([0..20]);
        $t4->black([0,4]);
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore GF is equal to CD ");
        $t4->math("GF = CD");
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Subtract CF from GF and FD, and the remainders are equal");
        $t4->grey([0..20]);
        $t4->black(-1);
        $t4->math("GC = FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Now, EB is the same part of GC that AE is of CF, and GC equals FD");
        $t4->grey([0..20]);
        $t4->black([2,6]);
        $t4->math("EB = (1/q)FD");        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore EB is the same part of FD that AE is of CF");
        $t4->grey([0..20]);
        $t4->black([1,-1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("FD is ".
        "the remainder of CF subtracted from CD");
        $t4->grey([0..20]);
        $t4->black([-1,0,1]);
        $t4->math("EB = (1/q)(CD - CF)  ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Finally, EB is the remainder of AE subtracted from AB");
        $t4->grey([0..20]);
        $t4->black([-1,0,1]);
        $t4->math("AB - AE = (1/q)(CD - CF)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->grey([0..20]);
        $t4->blue([0,1,-1]);
    };


    

    
    return $steps;

}

