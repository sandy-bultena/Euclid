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
my $title = "If four numbers be proportional, the number produced from ".
"the first and fourth will be equal to the number produced from the second and third; ".
"and, if the number produced from the first and fourth be equal to that produced ".
"from the second and third, the four numbers are proportional.";

$pn->title( 19, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 19 );
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
    my $ds = 40;
    my $dx = 40;
    my $dy = 40;
    my $x1 = $ds;
    my $x2 = $dx + $x1;
    my $x3 = $dx + $x2;
    my $x4 = $dx + $x3;
    my $x5 = $dx + $x4;
    my $x6 = $dx + $x5;
    my $A = 4*$dy;
    my $B = 3*$dy;
    my $C = 3.5*$dy;
    my $D = $B/$A*$C;
    my $E = $A*$D/$dy;
    my $F = $B*$C/$dy;
    my $G = $A*$C/$dy;
    my $yl = 140;
    my $yl2 = $yl + $B + $dy;
    my $y;
    my $yy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given four numbers in proportion, where A is to B ".
        "as C is to D");
        $t1->explain("Then A times D equals B times C");
        $t1->down;
        $t1->explain("If A times D equals B times C");
        $t1->explain("Then A is to B as C is to D");
        $l{A}= Line->new($pn,$x1,$yl,$x1,$yl+$A)->label("A","right");
        $l{B}= Line->new($pn,$x2,$yl,$x2,$yl+$B)->label("B","right");
        $l{C}= Line->new($pn,$x3,$yl,$x3,$yl+$C)->label("C","right");
        $l{D}= Line->new($pn,$x4,$yl,$x4,$yl+$D)->label("D","right");
        
        $t2->down;
        $t2->math("A:B = C:D \\{then} A\\{times}D = B\\{times}C");
        $t2->math("A\\{times}D = B\\{times}C \\{then} A:B = C:D ");
        
    };

    
    push @$steps, sub {
        $t1->down;
        $t1->explain("... or as fractions: ");
        $t2->down;
        $t2->fraction_equation("!a/b! = !c/d! \\{then} ad = bc");
        $t2->fraction_equation("ad = bc \\{then} !a/b! = !c/d!");
    };

    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given four numbers in proportion, where A is to B ".
        "as C is to D");
        $t1->explain("Then A times D equals B times C");
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $t2->math("A:B = C:D");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let E equal A times D, and F equal B times C");
        $t2->math("E = A\\{times}D");
        $t2->math("F = B\\{times}C");
        $l{E}= Line->new($pn,$x2,$yl2,$x2,$yl2+$E)->label("E","right");
        $l{F}= Line->new($pn,$x3,$yl2,$x3,$yl2+$F)->label("F","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let G equal A times C");
        $t2->math("G = A\\{times}C");
        $l{G}= Line->new($pn,$x5,$yl,$x5,$yl+$G)->label("G","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since G and E are equal to A times C and A times D ".
        "respectively, then the ratio of G to E is equal to the ratio C to D ".
        "(VII.17)");
        $t2->grey([0..20]);
        $t2->black([1,-1]);
        $t2->math("G:E = C:D");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But the ratio C to D is equal to the ratio A to B, ".
        "therefore A to B is also equal to G to E (V.11)");
        $t2->grey([0..20]);
        $t2->black([0,-1]);
        $t2->math("G:E = A:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since G and F are equal to A times C and B times C ".
        "respectively, then the ratio of G to F is equal to the ratio A to B ".
        "(VII.18)");
        $t2->grey([0..20]);
        $t2->black([2,3]);
        $t2->math("G:F = A:B");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the ratios G to E and G to F both equal the ".
        "ratio A to B, then they also equal each other (V.11)");
        $t2->grey([0..20]);
        $t2->black([-2,-1]);
        $t2->math("G:E = G:F");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And thus E and F must be equal (V.9)");
         $t2->grey([0..20]);
        $t2->black([-1]);
        $t2->math("E = F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,1,2,-1]);        
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("In other words");
        $t1->explain("If A times D equals B times C");
        $t1->explain("Then A is to B as C is to D");
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $t2->math("A\\{times}D = B\\{times}C");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let E equal A times D, and F equal B times C therefore ".
        "E equals F");
        $t2->math("E = A\\{times}D");
        $t2->math("F = B\\{times}C");
        $t2->math("E = F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let G equal A times C");
        $t2->math("G = A\\{times}C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since E equals F, then the ratio of G to E is equal ".
        "to the ratio of G to F (V.7)");
        $t2->grey([0..20]);
        $t2->black([-2]);
        $t2->math("G:E = G:F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But G is to E as C is to D (VII.17)");
         $t2->grey([0..20]);
        $t2->black([1,4]);
        $t2->math("G:E = C:D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And G is to F as A is to B (VII.18)");
         $t2->grey([0..20]);
        $t2->black([2,4]);
        $t2->math("G:F = A:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since E and F are equal, the ratio G to E is equal ".
        "to the ratio G to F, therefore A to B equals C to D (V.11)");
        $t2->grey([0..20]);
        $t2->black([3,-1,-2]);
        $t2->math("A:B = C:D");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,-1]);        
    };




    return $steps;

}

