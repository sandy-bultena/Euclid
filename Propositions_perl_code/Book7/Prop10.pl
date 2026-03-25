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
my $title = "If a number be a parts of a number, and another be the same parts ".
"of another, alternately also, whatever part or parts the first of the third, ".
"the same part, or the same parts, will the second also be of the fourth";

$pn->title( 10, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 80, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 10 );
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
    my $ds = 80;
    my $dx = 60;
    my $dy = 5;
    my $dx1 = $ds;
    my $dx2 = $ds + $dx;
    my $dx3 = $ds + 2*$dx;
    my $dx4 = $ds + 3*$dx;
    my $dx5 = $ds + 4*$dx;
    my $dx6 = $ds + 5*$dx;
    my $A = 40;
    my $D = 1.2*$A;
    my $B = 0;
    my $C = 3*$A/2;
    my $E = 0;
    my $F = 3*$D/2;
    my $G = $A/2;
    my $H = $D/2;
    my $yl = 180+$F*$dy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("If b is the same fraction of a as d is to c, and b another fraction of d, "
        ."then the fraction of b to d is the same fraction of a to c");
        $t2->math("b = (p/q)\\{dot}a");
        $t2->math("d = (p/q)\\{dot}c");
        $t2->math("if b = (m/n)\\{dot}d \\{then} a = (m/n)\\{dot}c");
        $t2->down;
        $t2->fraction_equation("!b/a! = !d/c! \\{then} !b/d! = !a/c!");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Let AB be parts of the number C, and let DE be the same parts of F");
        
       $l{C} = Line->new($pn,$dx2,$yl,$dx2,$yl-$C*$dy)->label("C","left");
       $l{F} = Line->new($pn,$dx4,$yl,$dx4,$yl-$F*$dy)->label("F","right");
       $p{B} = Point->new($pn,$dx1,$yl-$B*$dy)->label("B","left");
       $p{A} = Point->new($pn,$dx1,$yl-$A*$dy)->label("A","left");
       $p{E} = Point->new($pn,$dx3,$yl-$E*$dy)->label("E","right");
       $p{D} = Point->new($pn,$dx3,$yl-$D*$dy)->label("D","right");
       $l{AB} = Line->join($p{A},$p{B});
       $l{ED} = Line->join($p{E},$p{D});

       $t2->math("AB = (p/q)C");
       $t2->math("DE = (p/q)F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->math(" ");
        $t1->explain("Since AB and DE are the same part of C,F respectively, then ".
        "there is an equal number of parts of AB in C as there is of DE in F");
        $t1->explain("Divide AB into the number of parts it has of C, ".
        "and DE into the number of parts it has of F");
        $t2->math("AG = GB = (1/q)C");
        $t2->math("DH = HE = (1/q)F");
        $p{G} = Point->new($pn,$dx1,$yl-$G*$dy)->label("G","left");
        $p{H} = Point->new($pn,$dx3,$yl-$H*$dy)->label("H","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("AG has the same part of C as DH has of F");
        $t2->grey([0..20]);
        $t2->black([-1,-2]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Whatever parts AG is of DH, So is C of F (VII.9)");
        $t2->allgrey;
        $t2->black([4,3]);
        $t2->math("AG = (r/s)DH");
        $t2->math("C  = (r/s)F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Likewise for GB and HE");
        $t2->math("GB = (r/s)HE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, the sum of AG,GB will have the same parts of the ".
        "sum EH,HD as GB has of HE (VII.5), (VII.6)");
        $t2->allgrey;
        $t2->black([5,7]);
        $t2->math("AG+GB = (r/s)(DH+HE)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->math("AB    = (r/s)DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,1,-1,-4]);
    };



    return $steps;

}

