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
my $title = "Given two numbers, to find the least number which they measure.";
$pn->title( 34, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 340, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t3->wide_math(1);
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 34 );
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
    my $yl = 180;
    my $y1 = $yl;
    my $y2 = $dy + $y1;
    my $y3 = $dy + $y2;
    my $y4 = $dy + $y3;
    my $y5 = $dy + $y4;

    my $A = 2*$dx;
    my $B = 3*$dx;
    my $C = 6*$dx;
    my $D = 5*$dx;
    my $E = 3*$dx;
    my $F = 2*$dx;
    my $G = 6*$dx;
    my $H = 1.5*$dx;
    my $K = 9/4*$dx;
    my $L = 4.5 * $dx;
    my $M = $A/$H*$dx;
    
    push @$steps, sub {
        $t2->down;
        $t2->title("Definition: lowest common multiple");
        $t2->math("lcm(A,B) = C");
        $t2->math("S={x}|x\\{elementof}\\{natural}, x=m\\{dot}A, x=n\\{dot}B");
        $t2->math("C\\{elementof}S such that C\\{lessthanorequal}x, ".
        "\\{forall}(x)\\{elementof}S"); 
    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Given two numbers A,B");
        $l{A}= Line->new($pn,$ds,$yl,$ds+$A,$yl);
        $p{A}= Point->new($pn,$ds,$yl)->label("A","left");
        $l{B}= Line->new($pn,$ds+$A+60,$yl,$ds+$A+60+$B,$yl);
        $p{B}= Point->new($pn,$ds+$A+60,$yl)->label("B","left");
    };

    push @$steps, sub {
        $t1->explain("Find the lowest common multiple");
        $t2->explain("Find:");
        $t2->math("lcm(A,B) = C");
    };

    # -------------------------------------------------------------------------
    # Method
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Method 1: A,B are co-prime");
        $t2->erase;
        $t2->math("gcd(A,B) = 1");
        $t2->down;
    };

if(1) {
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let C be equal to A times B, which is also equal to B time A");
        $l{C}= Line->new($pn,$ds,$y2,$ds+$C,$y2);
        $p{C}= Point->new($pn,$ds,$y2)->label("C","left");
        $t2->math("C = A\\{times}B");
        $t2->math("C = B\\{times}A");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus B measures C, and A measures C");
        $t2->math("C = A\\{dot}B");
        $t2->math("C = B\\{dot}A");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("C is the lowest common multiple of A and B");
        $t2->math("lcm(A,B) = C");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t2->erase;

        $t3->math("gcd(A,B) = 1");
        $t3->math("C = A\\{times}B = B\\{times}A");
        $t3->math("lcm(A,B) = C");
        $t3->down;
        $t3->allblue;
        $t2->y($t3->y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let A and B measure D, which is less than C");
        $t2->math("D = m\\{dot}A");
        $t2->math("D = n\\{dot}B");
        $t2->math("D < C");
        $l{D}= Line->new($pn,$ds,$y3,$ds+$D,$y3);
        $p{D}= Point->new($pn,$ds+$D,$y3)->label("D","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then, as many times as A measure D, let there be so ".
        "many units in E, and as may times and B measures D, let there be so many ".
        "units in F");
        $t2->allgrey;
        $t2->black([0,1]);
        $t2->math("E = m\\{dot}1");
        $t2->math("F = n\\{dot}1");
        $l{E}= Line->new($pn,$ds,$y4,$ds+$E,$y4);
        $p{E}= Point->new($pn,$ds,$y4)->label("E","left");
        $l{F}= Line->new($pn,$ds+$E+60,$y4,$ds+$E+60+$F,$y4);
        $p{F}= Point->new($pn,$ds+$E+60,$y4)->label("F","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus D is equal to A multiplied by E, and also equal to B ".
        "multiplied by F (VII.Def.15)");
        $t2->allgrey;
        $t2->black([0,1,3,4]);
        $t2->math("D = E\\{times}A = F\\{times}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, as A is to B, so is F to E (VII.19)");
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("A:B = F:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A,B are relatively prime, then they are the smallest ".
        "numbers that can express the ratio A to B (VII.21)");
        $t2->allgrey;
        $t3->black([0]);
        $t2->math("A < F, B < E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And if A,B are the smallest numbers that express the ratio of ".
        "F to E, then A measures F, and B measures E (VI.20)");
        $t3->allgrey;
        $t2->allgrey;
        $t2->black([-2,-1]);
        $t2->math("E = p\\{dot}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since B times A equals C, and E times A equals D, then ".
        "the ratio B to E is equal to C to D (VI.17)");
        $t3->black([1]);
        $t2->allgrey;
        $t2->black([5]);
        $t2->math("C:D = B:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But D is less than C, so E is less than B");
        $t2->allgrey;
        $t2->black([2,-2,-1]);
        $t3->allgrey;
        $t2->math("E < B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But B measures C, so E cannot be less than B");
        $t2->allgrey;
        $t2->red([-3,-1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore there is no number D less than C that is ".
        "measured by A and B, thus C is the lowest common multiple");
        $t2->allgrey;
        $t3->allblue;
        $t2->red([0,1,2]);
    };

}






    # -------------------------------------------------------------------------
    # Method
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{C}->remove;
        $l{D}->remove;
        $l{E}->remove;
        $l{F}->remove;
        $p{C}->remove;
        $p{D}->remove;
        $p{E}->remove;
        $p{F}->remove;
        $t1->erase;
        $t1->title("Method 2: A,B are not co-prime");
        $t3->erase;
        $t2->erase;
        $t3->math("gcd(A,B) \\{notequal} 1");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Find F,E such that F and E are the smallest numbers ".
        "that have the same ratio of A and B (VII.33)");
        $t3->math("S={(x,y) | x:y = A:B }" );
        $t3->math("(F,E)\\{elementof}S such that F\\{lessthanorequal}x,E\\{lessthanorequal}y,".
        "\\{forall}(x,y)\\{elementof}S");
        $t3->math("F:E = A:B");
        
        $l{E}= Line->new($pn,$ds+$A+60,$y2,$ds+$E+$A+60,$y2);
        $p{E}= Point->new($pn,$ds+$A+60+$E,$y2)->label("E","right");
        $l{F}= Line->new($pn,$ds,$y2,$ds+$F,$y2);
        $p{F}= Point->new($pn,$ds+$F,$y2)->label("F","right");
         
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus the product of A and E is equal to the product of B and F (VII.19)");
        $t3->math("E\\{times}A = F\\{times}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let C by equal to A times E and also equal to B times F");
        $t3->math("C = E\\{times}A");
        $t3->math("C = F\\{times}B");
        $l{C}= Line->new($pn,$ds,$y3,$ds+$C,$y3);
        $p{C}= Point->new($pn,$ds+$C,$y3)->label("C","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore A and B both measure C");
        $t3->math("C = E\\{dot}A");
        $t3->math("C = F\\{dot}B");        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("C is the lowest common multiple of A and B");
        $t3->math("lcm(A,B) = C");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Method 2: A,B are not co-prime");
        $t1->explain("Find F,E such that F and E are the smallest numbers ".
        "that have the same ratio of A and B (VII.33)");
        $t1->explain("Let C by equal to A times E and also equal to B times F");
         $t1->explain("C is the lowest common multiple of A and B");
        
        
        
        $t1->down;
    
        $t1->title("Proof by Contradiction");
        $t3->erase;

        $t3->math("gcd(A,B) \\{notequal} 1");
        $t3->math("S={(x,y) | x:y = A:B }" );
        $t3->math("(F,E)\\{elementof}S such that F\\{lessthanorequal}x,E\\{lessthanorequal}y,".
        "\\{forall}(x,y)\\{elementof}S");
        $t3->math("F:E = A:B");
        $t3->math("C = E\\{times}A ");
        $t3->math("C = F\\{times}B ");

        $t3->down;
        $t3->allblue;
        $t2->y($t3->y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t1->explain("Let A and B measure D, which is less than C");
        $t2->math("D = m\\{dot}A");
        $t2->math("D = n\\{dot}B");
        $t2->math("D < C");
        $l{D}= Line->new($pn,$ds,$y4,$ds+$D,$y4);
        $p{D}= Point->new($pn,$ds+$D,$y4)->label("D","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then, as many times as A measure D, let there be so ".
        "many units in G, and as may times and B measures D, let there be so many ".
        "units in H");
        $t2->allgrey;
        $t2->black([0,1]);
        $t2->math("G = m\\{dot}1");
        $t2->math("H = n\\{dot}1");
        $l{G}= Line->new($pn,$ds,$y5,$ds+$E-20,$y5);
        $p{G}= Point->new($pn,$ds,$y5)->label("G","left");
        $l{H}= Line->new($pn,$ds+$E+40,$y5,$ds+$E+40+$F-20,$y5);
        $p{H}= Point->new($pn,$ds+$E+40,$y5)->label("H","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus D is equal to A multiplied by G, and also equal to B ".
        "multiplied by H ");
        $t2->allgrey;
        $t2->black([0,1,3,4]);
        $t2->math("D = G\\{times}A = H\\{times}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, as A is to B, so is H to G (VII.19)");
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("A:B = H:G");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But as A is to B, so is F to E, therefore as ".
        "F is to E, so is H to\\{nb}G");
        $t2->allgrey;
        $t2->black([-1]);
        $t3->black([3]);
        $t2->math("F:E = H:G");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But F and E are the smallest numbers in the ratio A:B, ".
        "thus F measures H and E measures G (VII.20)");
        $t2->allgrey;
        $t3->allgrey;
        $t3->black([1,2]);
        $t2->black([-1]);
        $t2->math("G = p\\{dot}E");
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A times E equals C, and G times A equals D, then ".
        "the ratio E to G is equal to C to D (VI.17)");
        $t3->allgrey;
        $t3->black([4]);
        $t2->allgrey;
        $t2->black([5]);
        $t2->math("C:D = E:G");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But D is less than C, so G is less than E");
        $t3->allgrey;
        $t2->allgrey;
        $t2->black([2,-2,-1]);
        $t3->allgrey;
        $t2->math("G < E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But E measures G, so G cannot be less than E");
        $t2->allgrey;
        $t2->red([-3,-1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore there is no number D less than C that is ".
        "measured by A and B, thus C is the lowest common multiple");
        $t2->allgrey;
        $t3->allblue;
        $t2->red([0,1,2]);
    };






    
    return $steps;

}

