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
"of another, the sum will also be the same part of the sum that the one is ".
"of the one.";

$pn->title( 5, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $tp = $pn->text_box( 600, 180 );
    $t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 5 );
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
    my $A = 25;
    my $B = 50;
    my $E = 40;
    my $D = 20;
    my $G = $A;
    my $H = $D;
    my $yl = 180+$B*$dy;
    
    # -------------------------------------------------------------------------
    # Definitions
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->down(-20);
        $t2->title("Definitions");
        $t2->explain("3. A number is a 'part' of a number, the less of the greater, ".
        "when it measures the greater");
        $t2->math("A = 10, B = 2,");
        $t2->explain("B is part of A");
        $t2->math("A = B + B + B + B + B");

        $t2->down;
        $t2->explain("4. but 'parts' when it does not measure it");
        $t2->math("A=10, B=6 ");
        $t2->explain("Let the part of A be 2");
        $t2->math("p = 2, A = p + p + p + p + p");
        $t2->explain("B is a multiple of the part of A (B is parts of A)");
        $t2->math("B = p + p + p");   
        
        $t2->down;
        $t2->explain("A part of one number is the same as the part of another ".
        "number if it is the same fraction");
        $t2->math("A = 10, B = 4");
        $t2->math("p\\{_A} = (1/2)A = 5");
        $t2->math("p\\{_B} = (1/2)B = 2");
        $t2->math("p\\{_A}  same as p\\{_B} ");
    };
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("If b is the same fraction of a as d is to c, then the sum b,d "
        ."will also be the same fraction of the sum a,c");
        $t2->math("b = (1/q)a");
        $t2->math("d = (1/q)c");
        $t2->math("\\{then} (b+d) = (1/q)(a+c)");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Let the number A be part (fraction) of BC, and D be the same part (fraction) of EF");
       $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-$A*$dy)->label("A","left");
       $l{B} = Line->new($pn,$dx2,$yl,$dx2,$yl-($B)*$dy);
       $p{B} = Point->new($pn,$dx2,$yl-($B)*$dy)->label("B","left");
       $p{C} = Point->new($pn,$dx2,$yl)->label("C","left");
       $l{D} = Line->new($pn,$dx3,$yl,$dx3,$yl-$D*$dy)->label("D","left");
       $l{E} = Line->new($pn,$dx4,$yl,$dx4,$yl-($E)*$dy);
       $p{E} = Point->new($pn,$dx4,$yl-($E)*$dy)->label("E","left");
       $p{F} = Point->new($pn,$dx4,$yl)->label("F","left");
       
       $t2->math("BC = \\{sum(i=1,q)} A, A = BC/q");
       $t2->math("EF = \\{sum(i=1,q)} D, D = EF/q");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let BC be divided into the numbers equal to A, namely BG, GC");        
        $t1->explain("Let EF be divided into the numbers equal to D, namely EH, HF");        
       $p{G} = Point->new($pn,$dx2,$yl-$G*$dy)->label("G","left");
       $p{H} = Point->new($pn,$dx4,$yl-$H*$dy)->label("H","left");
       $t2->down;
       $t2->math("A = BG = GC");
       $t2->math("D = EH = HF");
       $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The sum of BG,EH equals the sum of A,D, since A equals BG, ".
        "and D equals EH");
        $t2->math("A + D = BG + EH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Likewise, the sum of GC,HF equals the sum of A,D, since A equals GC, ".
        "and D equals HF");
        $t2->math("A + D = GC + HF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Given that BC and EF have the same number of parts, the previous ".
        "process can be repeated for every part in BC and EF, repeatedly adding A,D ");
        $t2->math("BC    = A   + A   + ... + A"); 
        $t2->math("EF    = D   + D   + ... + D");
        $t2->math("BC+EF = A+D + A+D + ... + A+D"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
         $t1->explain("Thus the sum of BC and EF will be the the sum of A and D, ".
         "repeated as many times as there are parts D in EF");
        $t2->down;
        $t2->math("BC + EF = \\{sum(i=1,q)} (A+D),");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
         $t1->explain("Thus the sum of A,D will be the same part (fraction) of BC,EF as A is to BC ".
         "D is to EF");
        $t2->down;
        $t2->math("A + D = (BC + EF)/q"); 
        $t2->blue([0..20]);
        $t2->grey([2..8]);
    };


    

    
    return $steps;

}

