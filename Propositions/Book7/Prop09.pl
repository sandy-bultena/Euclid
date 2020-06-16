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
my $title = "If a number be a part of a number, and another be the same part ".
"of another, alternately also, whatever part or parts the first of the third, ".
"the same part, or the same parts, will the second also be of the fourth";

$pn->title( 9, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 80, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);
$t4->wide_math(1);
$t5->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 9 );
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
    my $A = 20;
    my $D = 30;
    my $B = 2*$A;
    my $C = 0;
    my $E = 2*$D;
    my $F = 0;
    my $G = $B/2;
    my $H = $E/2;
    my $yl = 180+$E*$dy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("If b is the same fraction of a as d is of c, and b is another fraction of d, "
        ."then the fraction that b is of d, then a is the same fraction of c");
        $t2->math("b = (1/q)a");
        $t2->math("d = (1/q)c");
        $t2->math("if b = (r/s)\\{dot}d \\{then} a = (r/s)\\{dot}c");
        $t2->down;
        $t2->fraction_equation("!a/b! = !c/d! \\{then} !a/c! = !b/d!");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Let A be a part of the number BC, and let D be the same part of EF");
        
       $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-$A*$dy)->label("A","left");
       print "$dx1, $yl, $dx1, ",$yl-$A*$dy,"\n";
       $l{D} = Line->new($pn,$dx3,$yl,$dx3,$yl-$D*$dy)->label("D","right");
       $p{B} = Point->new($pn,$dx2,$yl-$B*$dy)->label("B","left");
       $p{C} = Point->new($pn,$dx2,$yl-$C*$dy)->label("C","left");
       $p{E} = Point->new($pn,$dx4,$yl-$E*$dy)->label("E","right");
       $p{F} = Point->new($pn,$dx4,$yl-$F*$dy)->label("F","right");
       $l{BC} = Line->join($p{B},$p{C});
       $l{EF} = Line->join($p{E},$p{F});

       $t2->math("A = (1/q)BC ");
       $t2->math("D = (1/q)EF ");
        $t2->math(" ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A and D are the same part of BC,EF respectively, then ".
        "there is an equal number of 'A' in BC as there is 'D' in EF");
        $t1->explain("Divide BC into equal sections of 'A', and CF into equal sections of 'D'");
        $p{G} = Point->new($pn,$dx2,$yl-$G*$dy)->label("G","left");
        $p{H} = Point->new($pn,$dx4,$yl-$H*$dy)->label("H","right");
        $t2->grey([0..20]);
        $t2->math("BG = GC = A");
        $t2->math("EH = HF = D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since BG,GC are equal, and EH,HF are equal, then BG is the same ".
        "part or parts of EH as GC part or parts of HF");
        $t2->math("BG = (r/s)EH");
        $t2->math("GC = (r/s)HF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, since the number of parts (BG,GC) are equal to the number ".
        "of parts (EH,HF), the sum of BG,GC is the same part or parts of the sum GC,HF ".
        "as BG is to EH (VI.5, VI.6)");
        $t2->grey([0..20]);
        $t2->black([-1,-2]);
        $t2->math("BC = (r/s)EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("BG is equal to A and EH is equal to D, therefore the part or parts ".
        "of BG to EH is the same as A to D");
        $t2->grey([0..20]);
        $t2->black([2,3,4,5]);
        $t2->math("A  = (r/s)D ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And since BC is the same part or parts of EF as BG is to EH, ".
        "BC is the part or parts of EF as A is of D");
        $t2->grey([0..20]);
        $t2->black([5,7,-1]);        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,1,-1,-2]);        


     #   $t2->down;
     #   $t2->fraction_equation("!A/BC! = !D/EF! \\{then} !A/D! = !BC/EF!");
    };



    return $steps;

}

