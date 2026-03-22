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
my $title = "If two numbers be prime to one another, the number which measures ".
"the one of them will be prime to the remaining number";

$pn->title( 23, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 23 );
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
    my $dx = 50;
    my $dy = 40;
    my $ds = 20;
    my $x1 = $ds*2;
    my $x2 = $dx + $x1;
    my $x3 = $dx + $x2;
    my $x4 = $dx + $x3;
    my $x5 = $dx + $x4;
    my $x6 = $dx + $x5;
    my $A = 16*$ds;
    my $B = 12*$ds;
    my $C = 4*$ds;
    my $D = 2*$ds;
    my $E = 2*$ds;
    my $G = 0.5 * $C;
    my $H = 0.5 * $E;
    my $yl = 180 + $A;
    my $y;
    my $yy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("If A and B are prime to one another, and C measures A, then");
        $t2->down;
        $t2->math("gcd(A,B) = 1");
        $t2->math("A = \\{sum(i=1,n)} C");
        $l{A}= Line->new($pn,$x1,$yl,$x1,$yl-$A);
        $p{A}=Point->new($pn,$x1,$yl)->label("A","bottom");
        $l{B}= Line->new($pn,$x2,$yl,$x2,$yl-$B);
        $p{B}=Point->new($pn,$x2,$yl)->label("B","bottom");
        $l{C}= Line->new($pn,$x3,$yl,$x3,$yl-$C);
        $p{C}=Point->new($pn,$x3,$yl)->label("C","bottom");
        $l{C}->show_parts(1,undef,"top",$turquoise);
        $l{A}->show_parts($A/$C,undef,"top",$turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->down;
        $t1->explain("Then C and B are prime to one another");
        $t2->math("gcd(B,C) = 1");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t2->erase;
        $t2->down;
        $t2->math("gcd(A,B) = 1");
        $t2->math("A = \\{sum(i=1,n)} C");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that B and C are not prime to one another, and ".
        "D measures both of them");
        $t2->math("B = \\{sum(i=1,j)} D");
        $t2->math("C = \\{sum(i=1,k)} D");
        $l{D}= Line->new($pn,$x4,$yl,$x4,$yl-$D);
        $p{D}=Point->new($pn,$x4,$yl)->label("D","bottom");
        $l{D}->show_parts(1,undef,"top",$pale_pink);
        $l{B}->show_parts($B/$D,undef,"top",$pale_pink);
        $l{C}->show_parts($C/$D,12,"top",$pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since D measures C, and C measures A...");
        $t2->grey([0..20]);
        $t2->black([1,-1,-5]);
        $t2->math("A = \\{sum(i=1,n)} (\\{sum(i=1,k)} D)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... D also measures A");
        $t2->math("A = \\{sum(i=1,p)} D");
        $l{A}->show_parts($A/$D,12,"top",$pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But D also measures B, which means that A and B are not ".
        "prime to one another (VII.Def.12)");
        $t2->grey([0..20]);
        $t2->red([-1,-4]);
        $t2->black([0]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore C and B are prime to one another");
         $t2->grey([0..20]);
        $t2->red([2,3]);
        $t2->black([0]);
        $t2->math("gcd(B,C) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,1,-1]);        
    };




    return $steps;

}

