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
my $title = "If two numbers measure any number, the least number measured ".
"by them will also measure the same.";
$pn->title( 35, $title, 'VII' );

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
push @$steps, Proposition::toc7( $pn, 35 );
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
    my $dy = 50;
    my $yl = 160;
    my $y1 = $yl;
    my $y2 = $dy + $y1;
    my $y3 = $dy + $y2;
    my $y4 = $dy + $y3;
    my $y5 = $dy + $y4;

    my $A = 2*$dx;
    my $B = 3*$dx;
    my $D = 12*$dx;
    my $E = 6*$dx;
    my $F = $dx;
    my %parts;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Let the number CD be measured by two numbers A,B");
        $l{A}= Line->new($pn,$ds,$yl,$ds+$A,$yl);
        $p{A}= Point->new($pn,$ds,$yl)->label("A","left");
        $l{B}= Line->new($pn,$ds+$A+60,$yl,$ds+$A+60+$B,$yl);
        $p{B}= Point->new($pn,$ds+$A+60,$yl)->label("B","left");
        $l{CD}= Line->new($pn,$ds,$y2,$ds+$D,$y2);
        $p{C}= Point->new($pn,$ds,$y2)->label("C","left");
        $p{D}= Point->new($pn,$ds+$D,$y2)->label("D","right");
        
        $parts{C1} = $l{CD}->parts($D/$A,6,'top',$pale_pink);
        $parts{A} = $l{A}->parts($A/$A,6,'top',$pale_pink);
        $parts{B} = $l{B}->parts($B/$B,6,'top',$purple);
        $parts{C2} = $l{CD}->parts($D/$B,12,'top',$purple);
        
        $t3->down;
        $t3->down;
        $t3->math("CD = n\\{dot}A");
        $t3->math("CD = m\\{dot}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And let the lowest common multiple be E");
        $t3->math("lcm(A,B) = E");
        $l{E}= Line->new($pn,$ds,$y3,$ds+$E,$y3);
        $p{E}= Point->new($pn,$ds,$y3)->label("E","left");
        $parts{E1} = $l{E}->parts($E/$A,6,'top',$pale_pink);
        $parts{E2} = $l{E}->parts($E/$B,12,'top',$purple);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then E also measures CD");
        $t3->math("CD = p\\{dot}E");
        $parts{E3} = $l{E}->parts($E/$E,6,'bottom',$turquoise);
        $parts{C3} = $l{CD}->parts($D/$E,6,'bottom',$turquoise);
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof by Contradiction");
        foreach my $key (keys %parts) {
            next if $key =~ /[AB]/;
            foreach my $line (@{$parts{$key}}) {
                $line->remove;
            }
        }
        $t3->erase;
        $t3->down;
        $t3->down;
        $t3->math("CD = n\\{dot}A");
        $t3->math("CD = m\\{dot}B");
        $t3->math("lcm(A,B) = E");
        $t2->y($t3->y);
        $t3->allblue;
        $t2->down;        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t1->explain("Assume that E does not measure CD");
        $t2->math("CD \\{notequal} p\\{dot}E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then let E measure DF, with the remainder CF less than E");
        $t2->math("DF = p\\{dot}E");
        $t2->math("CF < E");
        $p{F}= Point->new($pn,$ds+$F,$y2)->label("F","top");
        $l{FD} = Line->new($pn,$ds+$F,$y2,$ds+$D,$y2);;
        $parts{E3} = $l{E}->parts($E/$E,6,'bottom',$turquoise);
        $parts{F} =  $l{FD}->parts(2,6,'bottom',$turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Now, since A and B both measure E, and E measures DF...");
        $t2->allgrey;
        $t2->black([-2]);
        $t3->black([-1]);
        $t2->math("E = r\\{dot}A = s\\{dot}B");
        $parts{E1} = $l{E}->parts($E/$A,6,'top',$pale_pink);
        $parts{E2} = $l{E}->parts($E/$B,12,'top',$purple);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... A and B will also measure DF");
        $t2->math("DF = p\\{dot}(r\\{dot}A) = p\\{dot}(s\\{dot}B)");
        $parts{F1} = $l{FD}->parts(6,6,'top',$pale_pink);
        $parts{F2} = $l{FD}->parts(4,12,'top',$purple);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But A and B also measure the CD, therefore they will ".
        "also measure the remainder CF ");
        $t3->allgrey;
        $t3->black([0,1]);
        $t2->allgrey;
        $t2->black([-1]);
        $t2->math("CF = CD - DF");
        $t2->math("CF = n\\{dot}A - pr\\{dot}A = (n-pr)\\{dot}A");
        $t2->math("CF = m\\{dot}B - ps\\{dot}B = (m-ps)\\{dot}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("A and B measure CF, which is less than E, which is impossible, ".
        "because E is the lowest common multiple of A and\\{nb}B");
        $t3->allgrey;
        $t3->red([-1]);
        $t2->allgrey;
        $t2->red([-1,-2]);
        $t2->red([2]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the original statement that E does not measure CD is false");
        $t2->allgrey;
        $t3->allblue;
        $t2->red([0]);
        foreach my $key (qw(F1 F2)) {
            foreach my $line (@{$parts{$key}}) {
                $line->remove;
            }
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore E does measure CD");
        $t2->allgrey;
        $t2->down;
        $t2->math("CD = p\\{dot}E");
        $parts{F}[0]->remove;
         $parts{C3} = $l{CD}->parts($D/$E,6,'bottom',$turquoise);
         $p{F}->grey;
    };






    
    return $steps;

}

