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
my $title = "Given as many numbers as we please, to find the least of those ".
"which have the same ratio with them.";
$pn->title( 33, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);
$t4->wide_math(1);
my %parts;

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 33 );
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
    my $dy = 8;
    my $yl = 130;
    my $x1 = $ds;
    my $x2 = $dx + $x1;
    my $x3 = $dx + $x2;
    my $x4 = $dx + $x3;
    my $x5 = $dx + $x4;
    my $x6 = $dx + $x5;
    my $x7 = $dx + $x6;
    my $x8 = $dx + $x7;

    my $A = 24*$dy;  # 2*2*2*3
    my $B = 36*$dy;  # 2*2*3*3
    my $C = 72*$dy;  # 2*2*3*3*2
    my $D = 6*$dy;   # gcd = 12, not 6
    my $E = $A/$D*$dy;  
    my $F = $B/$D*$dy;  
    my $G = $C/$D*$dy;  
    my $M = 12*$dy;      # 
    my $H = $A/$M*$dy;
    my $K = $B/$M*$dy;
    my $L = $C/$M * $dy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Given as many numbers as we please, say A,B,C");
        $l{A}= Line->new($pn,$x3,$yl,$x3,$yl+$A);
        $p{A}= Point->new($pn,$x3,$yl+$A)->label("A","bottom");
        $l{B}= Line->new($pn,$x4,$yl,$x4,$yl+$B);
        $p{B}= Point->new($pn,$x4,$yl+$B)->label("B","bottom");
        $l{C}= Line->new($pn,$x5,$yl,$x5,$yl+$C);
        $p{C}= Point->new($pn,$x5,$yl+$C)->label("C","bottom");
        $t2->mathsmall("S={(x,y,z)|x,y,z\\{elementof}\\{natural}, x:y:z=A:B:C}");
    };

    push @$steps, sub {
        $t1->explain("Find the least numbers X,Y,Z which are in the same ratio as A,B,C");
        $t2->down;
        $t2->explain("Find");
        $t2->mathsmall("(X,Y,Z)\\{elementof}S \nsuch that X\\{lessthanorequal}x, ".
        "Y\\{lessthanorequal}y, Z\\{lessthanorequal}z,".
        "\\{forall}(x,y,z)\\{elementof}S"); 
    };

    # -------------------------------------------------------------------------
    # Method
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Method");
        $t2->erase;
        $t2->mathsmall("S={(x,y,z)|x,y,z\\{elementof}\\{natural}, x:y:z=A:B:C}");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let A,B,C be prime to one another");
        $t2->math("gcd(A,B,C) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then A,B,C are the least numbers with this ratio (VII.21)");
        $t2->math("A\\{lessthanorequal}x, ".
        "B\\{lessthanorequal}y, C\\{lessthanorequal}z, \\{forall}(x,y,z)\\{elementof}S");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Method");
        $t2->erase;
        $t2->mathsmall("S={(x,y,z)|x,y,z\\{elementof}\\{natural}, x:y:z=A:B:C}");
        $t2->down;
        $t1->explain("Let A,B,C NOT be prime to one another");
        $t1->explain("Let D be the greatest common divisor of A,B and C (VII.3)");
        $t2->math("gcd(A,B,C) = D");
        $l{D}= Line->new($pn,$x6,$yl,$x6,$yl+$D);
        $p{D} = Point->new($pn,$x6,$yl+$D)->label("D","bottom");
        push @{$parts{D}}, $l{A}->parts($A/$D,6,"right",$sky_blue);
        push @{$parts{D}}, $l{B}->parts($B/$D,6,"right",$sky_blue);
        push @{$parts{D}}, $l{C}->parts($C/$D,6,"right",$sky_blue);
        push @{$parts{D}}, $l{D}->parts($D/$D,6,"right",$sky_blue);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("and, as many times a D measure the number A,B,C, let there ".
        "be the same number of units in E,F,G respectively");
        $t2->math("A = E\\{dot}D");
        $t2->math("B = F\\{dot}D");
        $t2->math("C = G\\{dot}D");
        $t2->down;
        $l{E}= Line->new($pn,$x6,$yl+$D+80,$x6,$yl+$E+$D+80);
        $p{E} = Point->new($pn,$x6,$yl+$E+$D+80)->label("E","bottom");
        $l{F}= Line->new($pn,$x7,$yl+$D+80,$x7,$yl+$F+$D+80);
        $p{F} = Point->new($pn,$x7,$yl+$F+$D+80)->label("F","bottom");
        $l{G}= Line->new($pn,$x8,$yl+$D+80,$x8,$yl+$G+$D+80);
        $p{G} = Point->new($pn,$x8,$yl+$G+$D+80)->label("G","bottom");
        push @{$parts{E}}, $l{E}->parts($A/$D,6,"right",$tan);
        push @{$parts{E}}, $l{F}->parts($B/$D,6,"right",$tan);
        push @{$parts{E}}, $l{G}->parts($C/$D,6,"right",$tan);
        push @{$parts{E}}, $l{D}->parts($D/($dy),12,"right",$tan);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore E,F,G measure A,B,C according to the units in D (VII.16)");
        $t2->math("A = D\\{dot}E");
        $t2->math("B = D\\{dot}F");
        $t2->math("C = D\\{dot}G");
        foreach my $lines ( @{$parts{D}}) {
            foreach my $line (@$lines) {
            $line->remove;
            }
        }
        push @{$parts{measure}}, $l{E}->parts(1,6,"left",$pale_pink);
        push @{$parts{measure}}, $l{F}->parts(1,6,"left",$turquoise);
        push @{$parts{measure}}, $l{G}->parts(1,6,"left",$purple);
        push @{$parts{measure}}, $l{A}->parts($A/$E,6,"left",$pale_pink);
        push @{$parts{measure}}, $l{B}->parts($B/$F,6,"left",$turquoise);
        push @{$parts{measure}}, $l{C}->parts($C/$G,6,"left",$purple);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore E,F,G are in the same ratio as A,B,C (VII.Def.20)");
        $t2->math("E:F:G = A:B:C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("E,F,G are the smallest numbers that have the ratio of A,B,C");
        $t2->math("E\\{lessthanorequal}x, ".
        "F\\{lessthanorequal}y, G\\{lessthanorequal}z, \\{forall}(x,y,z)\\{elementof}S");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof by Contradiction");
        $t2->erase;
        $t2->mathsmall("S={(x,y,z)|x,y,z\\{elementof}\\{natural}, x:y:z=A:B:C}"); #0
        $t2->math("gcd(A,B,C) = D"); #1
        my $y = $t2->y;
        $t2->math("A = D\\{dot}E");#2
        $t2->y($y);
        $t2->math("       , B = D\\{dot}F, C = D\\{dot}G");#3
        $t2->math("E:F:G = A:B:C");#4
        $t2->math("E\\{lessthanorequal}x, ".#5
        "F\\{lessthanorequal}y, G\\{lessthanorequal}z, \\{forall}(x,y,z)\\{elementof}S");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the number H,K,L be in the same ratio of A,B,C, and smaller ".
        "than the numbers E,F,G, respectively");
        $t2->grey([0..20]);
        $t2->math("H:K:L = E:F:G = A:B:C");#6
        my $y = $t2->y;
        $t2->math("H < E");#7
        $t2->y($y);
        $t2->math("     , K < F, L < G");#8
        
        $l{H}= Line->new($pn,$x1,$yl+$B,$x1,$yl+$B+$H);
        $p{H} = Point->new($pn,$x1,$yl+$B+$H)->label("H","bottom");
        $l{K}= Line->new($pn,$x2,$yl+$B,$x2,$yl+$B+$K);
        $p{K} = Point->new($pn,$x2,$yl+$B+$K)->label("K","bottom");
        $l{L}= Line->new($pn,$x3,$yl+$B,$x3,$yl+$B+$L);
        $p{L} = Point->new($pn,$x3,$yl+$B+$L)->label("L","bottom");

        foreach my $lines ( @{$parts{E}}) {
            foreach my $line (@$lines) {
            $line->remove;
            }
        }
        foreach my $lines ( @{$parts{measure}}) {
            foreach my $line (@$lines) {
            $line->remove;
            }
        }
        $p{D}->grey;
        $l{D}->grey;


    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, H,K,L measure A,B,C the same number of times");
        $l{E}->grey;
        $l{F}->grey;
        $l{G}->grey;
        $p{E}->grey;
        $p{F}->grey;
        $p{G}->grey;
 
        push @{$parts{H}}, $l{A}->parts($A/$H,6,"left",$pale_pink);
        push @{$parts{H}}, $l{B}->parts($B/$K,6,"left",$turquoise);
        push @{$parts{H}}, $l{C}->parts($C/$L,6,"left",$purple);
        push @{$parts{H}}, $l{H}->parts(1,6,"left",$pale_pink);
        push @{$parts{H}}, $l{K}->parts(1,6,"left",$turquoise);
        push @{$parts{H}}, $l{L}->parts(1,6,"left",$purple);


        $t2->grey([0..20]);
        $t2->black([-3]);
        my $y = $t2->y;
        $t2->math("A = M\\{dot}H");#9
        $t2->y($y);
        $t2->math("       , B = M\\{dot}K, C = M\\{dot}L");#10
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("As many times as H measures A, let M have the same number of units");
        $l{M}= Line->new($pn,$x4,$yl+$B+60,$x4,$yl+$B+$M+60);
        $p{M} = Point->new($pn,$x4,$yl+$B+$M+60)->label("M","bottom");
        push @{$parts{M}}, $l{M}->parts($A/$H,6,"left",$tan);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the numbers H,K,L measure the numbers A,B,C ".
        "according to the units in M");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore M measures A according to the units in H, B ".
        "according to the units in K, and C according to the units in L (VII.16)");
        $t2->grey([0..20]);
        $t2->black([-1,-2]);
        my $y = $t2->y;
        $t2->math("A = H\\{dot}M");#11
        $t2->y($y);
        $t2->math("       , B = K\\{dot}M, C = L\\{dot}M");#12
        push @{$parts{last}}, $l{M}->parts(1,6,"right",$tan);
        push @{$parts{last}}, $l{A}->parts($A/$M,6,"right",$tan);
        push @{$parts{last}}, $l{B}->parts($B/$M,6,"right",$tan);
        push @{$parts{last}}, $l{C}->parts($C/$M,6,"right",$tan);
        
        foreach my $lines ( @{$parts{H}}) {
            foreach my $line (@$lines) {
            $line->remove;
            }
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->black([-1,-2]);
        $t1->explain("Therefore M measures A,B,C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since H measures A according to the units in M, M multiplied".
        " by H is equal to A (VII.Def.15)");
        $t2->math("A = M \\{times} H");#13
        push @{$parts{last}}, $l{H}->parts($H/$dy,6,"right",$tan);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the product of E,D is equal to the product H,M ");
        $t2->down;
        $t2->grey([0..30]);
        $t2->black([2,9]);
        $t2->math("A = M\\{times}H = E\\{times}D");#14
        foreach my $lines ( @{$parts{last}}) {
            foreach my $line (@$lines) {
            $line->remove;
            }
        }
        foreach my $lines ( @{$parts{M  }}) {
            foreach my $line (@$lines) {
            $line->remove;
            }
        }
        $l{B}->grey;
        $l{C}->grey;
        $p{B}->grey;
        $p{C}->grey;
        $l{E}->normal;
        $p{E}->normal;
        $l{D}->normal;
        $p{D}->normal;
        $p{K}->grey;
        $l{K}->grey;
        $p{L}->grey;
        $l{L}->grey;
        push @{$parts{last}}, $l{D}->parts(1,6,"right",$sky_blue);
        push @{$parts{last}}, $l{A}->parts($A/$D,6,"right",$sky_blue);
        push @{$parts{last}}, $l{M}->parts(1,6,"left",$tan);
        push @{$parts{last}}, $l{A}->parts($A/$M,6,"left",$tan);
        
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore E is to H as M is to D (VII.19)");
        $t2->grey([0..30]);
        $t2->black([-1]);
        $t2->math("E:H = M:D");#15
       push @{$parts{last2}}, $l{E}->parts($E/$H,6,"left",$pale_pink);
       push @{$parts{last2}}, $l{H}->parts(1,6,"left",$pale_pink);
        push @{$parts{last}}, $l{D}->parts($D/$D,6,"right",$sky_blue);
        push @{$parts{last}}, $l{M}->parts($M/$D,6,"right",$sky_blue);

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But E is greater H, therefore M is also greater than D");
        $t2->grey([0..30]);
        $t2->black([-1,7]);
        $t2->math("M > D");#16
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And it measures A,B,C");
        $t2->grey([0..30]);
        $t2->black([-1,11,12]);    
        $l{B}->normal;
        $l{C}->normal;
      push @{$parts{last}}, $l{B}->parts($B/$M,6,"left",$tan);
      push @{$parts{last}}, $l{C}->parts($C/$M,6,"left",$tan);
      $p{B}->normal;
      $p{C}->normal;
       foreach my $lines ( @{$parts{last2}}) {
            foreach my $line (@$lines) {
            $line->remove;
            }
        }
        $l{E}->grey;
        $l{H}->grey;
        $p{E}->grey;
        $p{H}->grey;
             
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Which is impossible, because D is the greatest common divisor ".
        "of A,B,C");
        $t2->grey([0..30]);
        $t2->red([-1,11,12,1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, there cannot be any numbers less than E,F,G ".
        "with the same ratio as A,B,C, which was the original assumption");
        $t2->allgrey; 
        $t2->blue([0..4]);
        $t2->red([6,7,8]); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, E,F,G are the smallest numbers with the ratio A,B,C");
        $t2->grey([0..30]);
        $t2->blue([0..5]);        
    };








    
    return $steps;

}

