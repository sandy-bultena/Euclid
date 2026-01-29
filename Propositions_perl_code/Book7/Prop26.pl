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
my $title = "If two numbers be prime to two numbers, both to each, their ".
"products also will be prime to one another";

$pn->title( 26, $title, 'VII' );

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
push @$steps, Proposition::toc7( $pn, 26 );
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
    my $dx = 40;
    my $dy = 20;
    my $x1 = $ds;
    my $x2 = $dx + $x1;
    my $x3 = $dx + $x2;
    my $x4 = $dx + $x3;
    my $x5 = $dx + $x4;
    my $x6 = $dx + $x5;
    my $A = 8*$dy;
    my $B = 3*$dy;
    my $C = 7*$dy;
    my $D = 3*$dy;
    my $E = 8*3*$dy;
    my $F = 7*3*$dy;
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
        $t1->explain("If A is relatively prime to C and to D, and B is also ".
        "relatively prime to C and to D");
        $t4->down;
        $t4->math("gcd(A,C) = 1");
        $t4->math("gcd(A,D) = 1");
        $t4->math("gcd(B,C) = 1");
        $t4->math("gcd(B,D) = 1");
        $l{A}= Line->new($pn,$x1,$yl,$x1+$A,$yl);
        $p{A}= Point->new($pn,$x1,$yl)->label("A","left");
        $l{B}= Line->new($pn,$x1,$yl+$dx,$x1+$B,$yl+$dx);
        $p{B}= Point->new($pn,$x1,$yl+$dx)->label("B","left");
        $l{C}= Line->new($pn,$xc2,$yl,$xc2+$C,$yl);
        $p{C}= Point->new($pn,$xc2,$yl)->label("C","left");
        $l{D}= Line->new($pn,$xc2,$yl+$dx,$xc2+$D,$yl+$dx);
        $p{D}= Point->new($pn,$xc2,$yl+$dx)->label("D","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->math("gcd(A\\{times}B,C\\{times}D) = 1");
        $t1->explain("Then the product of A and B will be relatively prime ".
        "to the product C and D");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
#        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t4->erase;
        $t4->down;
        $t4->math("gcd(A,C) = 1");
        $t4->math("gcd(A,D) = 1");
        $t4->math("gcd(B,C) = 1");
        $t4->math("gcd(B,D) = 1");
        $t4->down;
        $y = $t4->y;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let E be the product of A and B");
        $t4->math("E = A \\{times} B");
        $l{E}= Line->new($pn,$x1,$yl+2*$dx,$x1+$E,$yl+2*$dx);
        $p{E}= Point->new($pn,$x1,$yl+2*$dx)->label("E","left");
        $l{E}->show_parts($E/$B,6,"top",$turquoise);
        $l{E}->show_parts($E/$A,12,"top",$pale_pink);
        $l{A}->show_parts(1,6,"top",$pale_pink);
        $l{B}->show_parts(1,6,"top",$turquoise);
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let F be the product of C and D");
        $t4->math("F = C \\{times} D");
        $l{F}= Line->new($pn,$x1,$yl+3*$dx,$x1+$F,$yl+3*$dx);
        $p{F}= Point->new($pn,$x1,$yl+3*$dx)->label("F","left");
        $l{F}->show_parts($F/$C,6,"top",$purple);
        $l{F}->show_parts($F/$D,12,"top",$sky_blue);
        $l{C}->show_parts(1,6,"top",$purple);
        $l{D}->show_parts(1,6,"top",$sky_blue);
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A and B are prime to C, then the product A and B ".
        "will also be prime to C (VII.24)");
        $t4->grey([0..20]);
        $t4->black([0,2]);
        $t4->math("gcd(A\\{times}B,C) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But E is equal to the product of A and B, so E is relatively ".
        "prime to C");
        $t4->grey([0..20]);
        $t4->black([4,-1]);
        $t4->math("gcd(E,C) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A and B are prime to D, then the product A and B ".
        "will also be prime to D (VII.24)");
        $t4->grey([0..20]);
        $t4->black([1,3,4]);
        $t4->math("gcd(E,D) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore C and D are prime to E");
        $t2->y($y);
        $t4->grey([0..20]);
        $t4->black([-1,-2]);        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the product of C and D are prime to E  (VI.24)");
         $t4->grey([0..20]);
        $t4->black([-1,-2]);        
        $t2->math("gcd(E,C\\{times}D) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But F is equal to the product of C and D, so F is relatively ".
        "prime to E");
         $t4->grey([0..20]);
        $t4->black([5]);        
         $t2->grey([0..20]);
        $t2->black([-1]);        
        $t2->math("gcd(E,F) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([-1]);        
        $t4->grey([0..20]);
        $t4->blue([0..5]);        
    };
    
    return $steps;

}

