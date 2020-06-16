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
my $title = "Given three numbers, to find the least number which they measure.";
$pn->title( 36, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 340, 240 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t3->wide_math(1);
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 36 );
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
    my $dy = 30;
    my $yl = 160;
    my $y1 = $yl;
    my $y2 = $dy + $y1;
    my $y3 = $dy + $y2;
    my $y4 = $dy + $y3;
    my $y5 = $dy + $y4;

    my $A = 2*$dx;
    my $B = 3*$dx;
    my $C = 4*$dx;
    my $D = 6*$dx;
    my $E = 5*$dx;
    my $Ep = 12*$dx;
    my $F = 8*$dx;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Let A,B,C be any three numbers");
        $l{A}= Line->new($pn,$ds,$yl,$ds+$A,$yl);
        $p{A}= Point->new($pn,$ds,$yl)->label("A","left");
        $l{B}= Line->new($pn,$ds+$A+60,$yl,$ds+$A+60+$B,$yl);
        $p{B}= Point->new($pn,$ds+$A+60,$yl)->label("B","left");
        $l{C}= Line->new($pn,$ds,$y2,$ds+$C,$y2);
        $p{C}= Point->new($pn,$ds,$y2)->label("C","left");
        
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Find the least common multiple");
        $t3->down;
        $t3->math("lcm(A,B,C) = ?");
    };

    # -------------------------------------------------------------------------
    # Method
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->clear;
        $t3->clear;
        $t3->down;        
        $t1->title("Method");
        $t1->explain("Let D be the least common multiple of A and B (VII.34)");
        $t3->math("lcm(A,B) = D");
        $l{D}= Line->new($pn,$ds,$y3,$ds+$D,$y3);
        $p{D}= Point->new($pn,$ds,$y3)->label("D","left");
    };

    push @$steps, sub {
        $t1->explain("If C either measures D, or it does not.  If it does...");
        $t3->math("D = p\\{dot}C");
    };

    push @$steps, sub {
        $t1->explain("... then D is the least common multiple of A,B and C");
        $t3->math("lcm(A,B,C) = D");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof by Contradiction");
        $t3->erase;
        $t3->down;
        $t3->math("lcm(A,B) = D");
        $t3->math("D = p\\{dot}C");
        $t2->y($t3->y);
        $t3->allblue;
        $t2->down;        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t1->explain("Assume that E, a number less than D, is measured by A, B and C");
        $t2->math("E < D");
        $t2->math("E = m\\{dot}A");
        $t2->math("E = n\\{dot}B");
        $t2->math("E = r\\{dot}C");
        $l{E}= Line->new($pn,$ds,$y4,$ds+$E,$y4);
        $p{E}= Point->new($pn,$ds,$y4)->label("E","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If E is measured by A,B and C, it is also measured by A and B");
        $t2->allgrey;
        $t2->black([-2,-3]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But if A and B both measure E, then the least common ".
        "multiple (D) will also measure E (VII.35)");
        $t3->black([0]);
        $t2->math("E = q\\{dot}D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But D cannot measure E, and also be less than E");
        $t2->allgrey;
        $t3->allgrey;
        $t2->red([-1,0]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, there is no number E, less than D, which is a ".
        "multiple of A, B and C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So D is the least common multiple of A, B and C");
        $t2->down;
        $t2->allgrey;
        $t3->allblue;
        $t2->math("lcm(A,B,C) = D");
    };
    
    # -------------------------------------------------------------------------
    # Method
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->clear;
        $t3->clear;
        $t3->down;    
        $t2->clear;    
        $t1->title("Method");
        $t1->explain("Let D be the least common multiple of A and B (VII.34)");
        $t3->math("lcm(A,B) = D");
        $l{D}= Line->new($pn,$ds,$y3,$ds+$D,$y3);
        $p{D}= Point->new($pn,$ds,$y3)->label("D","left");
        $l{E}->remove;
        $p{E}->remove;
        $t1->explain("If C either measures D, or it does not.  If it does not...");
        $t3->math("D \\{notequal} p\\{dot}C");
        $t2->y($t3->y);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let E be the least common measure of C and D (VII.34)");
        $t3->math("lcm(C,D) = E");        
        $l{E}= Line->new($pn,$ds,$y4,$ds+$Ep,$y4);
        $p{E}= Point->new($pn,$ds,$y4)->label("E","left");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A and B measure D, and D measures E, then A and B ".
        "measure E ");
        $t3->allgrey;
        $t3->math("D = m\\{dot}A = n\\{dot}B");
        $t3->math("E = p\\{dot}C = q\\{dot}D");
        $t3->math("\\{therefore} E = q\\{dot}(m\\{dot}A) = q\\{dot}(n\\{dot}B)");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus A, B and C measures E, and E is the least common multiple");
        $t3->math("lcm(A,B,C) = E");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof by Contradiction");
        $t3->erase;
        $t3->down;
        $t3->math("lcm(A,B) = D");
        $t3->math("D \\{notequal} p\\{dot}C");
        $t3->math("lcm(C,D) = E");        
        $t2->y($t3->y);
        $t3->allblue;
        $t2->down;        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t1->explain("Let A, B and C measure F, which is smaller than E");
        $l{F}= Line->new($pn,$ds,$y5,$ds+$F,$y5);
        $p{F}= Point->new($pn,$ds,$y5)->label("F","left");
        $t2->math("F = r\\{dot}A = s\\{dot}B = t\\{dot}C");
        $t2->math("F < E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If A and B measure F, then the least common multiple ".
        "of A and B will also measure F (VII.35)");
        $t2->allgrey;
        $t2->black([-2]);
        $t3->black([0]);
        $t2->math("F = i\\{dot}D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But C and D also measures F, so the lowest common multiple of ".
        "C and D, which is E, will also measure F (VII.35).");
        $t2->allgrey;
        $t3->allgrey;
        $t2->black([0,-1]);
        $t3->black([2]);
        $t2->math("F = j\\{dot}E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But F cannot be measured by E while also be less than E");
        $t2->allgrey;
        $t3->allgrey;
        $t2->red([1,-1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Hence, no number less than E can measure A, B and C".
        ", and thus E is the lowest common multiple");
        $t2->allgrey;
        $t3->allblue;
        $t2->down;
        $t2->math("lcm(A,B,C) = E");
        
    };




    
    return $steps;

}

