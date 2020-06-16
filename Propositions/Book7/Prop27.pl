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
my $title = "If two numbers be prime to one another, and each by multiplying ".
"itself make a certain number, the products will be prime to one another; ".
"and, if the original numbers by multiplying the products make certain numbers, ".
"the latter will also be prime to one another (and this is always the case ".
"with the extremes).";

$pn->title( 27, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
#$t2->wide_math(1);
#$t4->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 27 );
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
    my $ds = 60;
    my $dx = 30;
    my $dy = 20;
    my $x1 = $ds;
    my $x2 = $dx + $x1;
    my $x3 = $dx + $x2;
    my $x4 = $dx + $x3;
    my $x5 = $dx + $x4;
    my $x6 = $dx + $x5;
    my $A = 5*$dy;
    my $B = 4*$dy;
    my $C = $A*$A/2/$dy;
    my $D = $C*$A/4/$dy;
    my $E = $B * $B /$dy/2;
    my $F = $E * $B /$dy/2;
    my $yl = 180;
    my $y;
    my $xc2 = $ds + $dx + $A ;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Let A and B be relatively prime");
        $l{A}= Line->new($pn,$x1,$yl,$x1,$yl+$A)->label("A","left");
        $l{B}= Line->new($pn,$x1,$yl+$dy+$A,$x1,$yl+$dy+$A+$B)->label("B","left");
        $l{C}= Line->new($pn,$x2,$yl,$x2,$yl+$C);
        $p{C}= Point->new($pn,$x2,$yl+$C)->label("C","bottom");
        $l{D}= Line->new($pn,$x3,$yl,$x3,$yl+$D);
        $p{D}= Point->new($pn,$x3,$yl+$D)->label("D","bottom");
        $l{E}= Line->new($pn,$x4,$yl,$x4,$yl+$E);
        $p{E}= Point->new($pn,$x4,$yl+$E)->label("E","bottom");
        $l{F}= Line->new($pn,$x5,$yl,$x5,$yl+$F);
        $p{F}= Point->new($pn,$x5,$yl+$F)->label("F","bottom");
        
        $t2->math("gcd(A,B) = 1");
        $t2->math("C = A \\{times} A = A\\{^2}");
        $t2->math("D = A \\{times} C = A\\{^3}");
        $t2->math("E = B \\{times} B = B\\{^2}");
        $t2->math("F = B \\{times} E = B\\{^3}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->down;
        $t2->math("gcd(C,E) = 1,  gcd(A\\{^2}, B\\{^2}) = 1");
        $t2->math("gcd(D,F) = 1,  gcd(A\\{^3}, B\\{^3}) = 1");
        $t1->explain("Then A\\{squared} and B\\{squared} are relatively prime, ".
        "and A\\{cubed}, B\\{cubed} are also relatively prime");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
#        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("gcd(A,B) = 1");
        $t2->math("C = A \\{times} A = A\\{^2}");
        $t2->math("D = A \\{times} C = A\\{^3}");
        $t2->math("E = B \\{times} B = B\\{^2}");
        $t2->math("F = B \\{times} E = B\\{^3}");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A and B are prime to one another, then A\\{squared}, ".
        " and B are prime to one another (VII.25), thus C and B are prime to one another");
        $t2->grey([0..20]);
        $t2->black([0,1]);
        $t2->math("gcd(A\\{^2},B) = 1");
        $t2->math("gcd(C,B) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since C,B are prime to one another, and E is B times ".
        "B, C and E are prime to one another (VII.25)");
        $t2->grey([0..20]);
        $t2->black([3,-1,1]);
        $t2->math("gcd(C,B\\{^2})= 1");
        $t2->math("gcd(C,E) = 1 \\{then} gcd(A\\{^2},B\\{^2})=1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A,B are prime to one another, and E is B times ".
        "B, A and E are prime to one another (VII.25)");
        $t2->grey([0..20]);
        $t2->black([0,3]);
        $t2->math("gcd(A,B\\{^2})= 1");
        $t2->math("gcd(A,E) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A and C are prime to the two numbers B and E, therefore ".
        "the product of A and C will be prime to the product B and E (VII.26)");
        $t2->grey([0..20]);
        $t2->black([0,-1,-3,-5]);
        $t2->math("gcd(A\\{times}C,B\\{times}E) = 1");
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore D and F are prime to one another");
        $t2->grey([0..20]);
        $t2->black([2,4,-1]);
        $t2->math("gcd(D,F) = 1");
        $t2->math("gcd(A\\{^3},B\\{^3})= 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0..4,8,-1]);        
    };
    
    return $steps;

}

