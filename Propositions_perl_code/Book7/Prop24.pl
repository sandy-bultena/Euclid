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
my $title = "If two numbers be prime to any number, their product also will ".
"be prime to the same";

$pn->title( 24, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 24 );
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
    my $ds = 20;
    my $dx = 50;
    my $dy = 40;
    my $x1 = 40;
    my $x2 = $dx + $x1;
    my $x3 = $dx + $x2;
    my $x4 = $dx + $x3;
    my $x5 = $dx + $x4;
    my $x6 = $dx + $x5;
    my $A = 6*$ds;
    my $B = 4*$ds;
    my $C = 10*$ds;
    my $D = 24*$ds;
    my $E = 2*$ds;
    my $F = $D/$E*$ds;
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
        $t1->explain("If A and B are both prime to C, and D is the product of A,B");
        $t2->down;
        $t2->math("gcd(A,C) = 1");
        $t2->math("gcd(B,C) = 1");
        $t2->math("D = A\\{times}B");
        $l{A}= Line->new($pn,$x1,$yl,$x1,$yl+$A);
        $p{A}=Point->new($pn,$x1,$yl+$A)->label("A","bottom");
        $l{B}= Line->new($pn,$x2,$yl,$x2,$yl+$B);
        $p{B}=Point->new($pn,$x2,$yl+$B)->label("B","bottom");
        $l{C}= Line->new($pn,$x3,$yl,$x3,$yl+$C);
        $p{C}=Point->new($pn,$x3,$yl+$C)->label("C","bottom");
        $l{D}= Line->new($pn,$x4,$yl,$x4,$yl+$D);
        $p{D}=Point->new($pn,$x4,$yl+$D)->label("D","bottom");
        #$l{D}->show_parts($D/$A,6,"top",$pale_pink);
        #$l{D}->show_parts($D/$B,6,"bottom",$turquoise);
        #$l{A}->show_parts(1,6,"top",$pale_pink);
        #$l{B}->show_parts(1,6,"top",$turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->down;
        $t1->explain("Then C and D are prime to one another");
        $t2->math("gcd(C,D) = 1");
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
        $t2->math("gcd(A,C) = 1");
        $t2->math("gcd(B,C) = 1");
        $t2->math("D = A\\{times}B");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that C and D are not prime to one another, and ".
        "E measures both of them");
        $t2->math("C = \\{sum(i=1,k)} E");
        $t2->math("D = \\{sum(i=1,f)} E");
        $l{E}= Line->new($pn,$x5,$yl,$x5,$yl+$E);
        $p{E}=Point->new($pn,$x5,$yl+$E)->label("E","bottom");
        $l{C}->show_parts($C/$E,6,"top",$pale_pink);
        $l{D}->show_parts($D/$E,6,"top",$pale_pink);
        $l{E}->show_parts(1,6,"top",$pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A and C are relatively prime, and E measures C, ".
        "then A and E are also relatively prime (VII.23)");
        $t2->grey([0..20]);
        $t2->black([0,-2]);
        $t2->math("gcd(A,E) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let F be equal to the number of times that E measures D");
        $t2->grey([0..20]);
        $t2->black([-2]);
        $t2->math("F = \\{sum(i=1,f)} 1");
        $l{F}= Line->new($pn,$x6,$yl,$x6,$yl+$F);
        $p{F}=Point->new($pn,$x6,$yl+$F)->label("F","bottom");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore F also measures D according to the units in E (VII.16)");
        $t2->grey([0..20]);
        $t2->black([-3,-1]);
        $t2->math("E = \\{sum(i=1,e)} 1");
        $t2->math("D = \\{sum(i=1,e)} F");
        $l{D}->show_parts($D/$F,12,"top",$turquoise);
        $l{F}->show_parts(1,6,"top",$turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore D equals F times E (VII.Def.15)");
        $t2->grey([0..20]);
        $t2->black([-5,-3,-2,-1]);
        $t2->math("D = F\\{times}E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t2->down;
        $t2->math("gcd(A,C) = 1");
        $t2->math("gcd(B,C) = 1");
        $t2->math("D = A\\{times}B");
        $t2->down;
        $t2->math("C = \\{sum(i=1,k)} E");
        $t2->math("D = \\{sum(i=1,f)} E");
        $t2->math("gcd(A,E) = 1");
        $t2->math("D = F\\{times}E");
       $t2->grey([0..20]);
        $t2->black([-1]);
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But D is also equal to A times B, therefore F times E ".
        "equals A times B");
        $t2->grey([0..20]);
        $t2->black([2,-1]);
        $t2->math("F\\{times}E = A\\{times}B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If the product of the extremes are equal to that of the ".
        "means, the four numbers are proportional, in other words E is to A as B ".
        "is to F (VII.19)");
        $t2->grey([0..20]);
        $t2->black([-1]);
        $t2->math("E:A = B:F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("A and E are relatively prime, so therefore they are the smallest ".
        "numbers which can represent the ratio E to A (VII.21)");
        $t2->grey([0..20]);
        $t2->black([-4]);
        $t2->mathsmall("S = { (x,y) | x\\{elementof}\\{natural}, y\\{elementof}\\{natural}, ".
        "x:y=E:A }");
        $t2->mathsmall("(E:A)\\{elementof}S such that E\\{lessthanorequal}x, ".
        "A\\{lessthanorequal}y, \\{forall}(x,y)\\{elementof}S"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A and E are the smallest numbers in the ratio of B and F, ".
        "E will measure B (and A will measure F) (VII.20)");
        $t2->grey([0..20]);
        $t2->black([-1,-2,-3]);
        $t2->math("B = \\{sum(i=1,r)} E");
        $l{B}->show_parts($B/$E,6,"top",$pale_pink);
        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But E also measures C, which is impossible since B,C are ".
        "relatively prime (VII.Def.12)");
        $t2->grey([0..20]);
        $t2->red([-1,-9]);
        $t2->black([1]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore no number E measures C and D, which means that ".
        "C and D are relatively prime");
         $t2->grey([0..20]);
        $t2->red([3,4]);
        $t2->math("gcd(C,D) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,1,2,-1]);        
    };
    
    return $steps;

}

