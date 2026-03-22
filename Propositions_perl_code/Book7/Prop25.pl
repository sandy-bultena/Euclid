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
my $title = "If two numbers be prime to any number, their product of one of ".
"them into itself will be prime to the remaining one";

$pn->title( 25, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 25 );
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
    my $dx = 50;
    my $dy = 20;
    my $x1 = $ds;
    my $x2 = $dx + $x1;
    my $x3 = $dx + $x2;
    my $x4 = $dx + $x3;
    my $x5 = $dx + $x4;
    my $x6 = $dx + $x5;
    my $A = 7*$dy;
    my $B = 5*$dy;
    my $C = 49/2*$dy;
    my $D = 7*$dy;
    my $yl = 180;
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
        $t1->explain("If A and B are relatively prime, then A\\{^2} will ".
        "also be prime to B");
        $t2->down;
        $t2->math("gcd(A,B) = 1");
        $t2->math("C = A \\{times} A");
        $t2->explain("then");
        $t2->math("gcd(C,B) = 1");
        $l{A}= Line->new($pn,$x1,$yl,$x1,$yl+$A)->label("A","left");
        $l{B}= Line->new($pn,$x2,$yl,$x2,$yl+$B)->label("B","left");
        $l{C}= Line->new($pn,$x3,$yl,$x3,$yl+$C)->label("C","left");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
#        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->down;
        $t2->math("gcd(A,B) = 1");
        $t2->math("C = A \\{times} A");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let D be equal to A");
        $t2->math("D = A");
        $l{D}= Line->new($pn,$x1,$yl+$A+$dy,$x1,$yl+$A+$dy+$D)->label("D","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A and B are relatively prime, and A equals D, ".
        "then D and B are relatively prime");
        $t2->grey([0..20]);
        $t2->black([0,-1]);
        $t2->math("gcd(D,B) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("A and D are both prime to B, thus the product of D and A ".
        "will also be prime to B (VII.24)");
        $t2->grey([0..20]);
        $t2->black([0,-1]);
        $t2->math("gcd(A\\{times}D,B) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But A times D equals C");
        $t2->grey([0..20]);
        $t2->black([1,2]);
        $t2->math("C = A \\{times} D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore C is prime to B");
        $t2->grey([0..20]);
        $t2->black([-1,-2]);
        $t2->math("gcd(C,B) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,1,-1]);        
    };
    
    return $steps;

}

