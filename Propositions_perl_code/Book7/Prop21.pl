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
my $title = "Numbers prime to one another are the least of those which ".
"have the same ratio with them.";

$pn->title( 21, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 21 );
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
    my $dx = 50;
    my $dy = 40;
    my $x1 = $ds;
    my $x2 = $dx + $x1;
    my $x3 = 1.5*$dx + $x2;
    my $x4 = $dx + $x3;
    my $x5 = $dx + $x4;
    my $x6 = $dx + $x5;
    my $A = 7*$dy;
    my $B = 6*$dy;
    my $C = 3.5*$dy;
    my $D = 3*$dy;
    my $E = 1*$dy;
    my $G = 0.5 * $C;
    my $H = 0.5 * $E;
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
        $t1->explain("Let A and B be relatively prime.");
        $t2->math("gcd(A,B) = 1");
        $l{A}= Line->new($pn,$x1,$yl,$x1,$yl+$A)->label("A","right");
        $l{B}= Line->new($pn,$x2,$yl,$x2,$yl+$B)->label("B","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then A and B are the smallest whole numbers that can be ".
        "used to create the same ratio equal to A to B");
        $t2->down;
        $t2->mathsmall("S = { (x,y) | x\\{elementof}\\{natural}, y\\{elementof}\\{natural}, ".
        "x:y=A:B }");
        $t2->mathsmall("(A,B)\\{elementof}S such that A\\{lessthanorequal}x, ".
        "B\\{lessthanorequal}y, \\{forall}(x,y)\\{elementof}S"); 
        $t2->down;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t2->erase;
        $t2->math("gcd(A,B) = 1");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let C and D be the lowest two numbers that have the same ratio as A to B, "
        ."and let C,D be smaller than A,B");
        $t2->math("A:B = C:D");
        $l{C}= Line->new($pn,$x3,$yl,$x3,$yl+$C)->label("C","right");
        $l{D}= Line->new($pn,$x4,$yl,$x4,$yl+$D)->label("D","right");
        $t2->math("C < A");
        $t2->math("D < B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore C measures A the same number of times that ".
        "D measures B (VII.20)"); 
        $t2->grey([0..20]);
        $t2->black([-1,-2,-3]); 
        $t2->math("A = C\\{_1} + C\\{_2} + ... + C\\{_i} + ... C\\{_n}");
        $t2->math("B = D\\{_1} + D\\{_2} + ... + D\\{_i} + ... D\\{_n}");
        $l{A}->show_parts(2,undef,"right",$pale_pink);
        $l{B}->show_parts(2,undef,"right",$turquoise);
        $l{C}->show_parts(1,undef,"right",$pale_pink);
        $l{D}->show_parts(1,undef,"right",$turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let E be equal to the number of times C measures A"); 
        $t2->grey([0..20]);
        $t2->black([-2]);        
        $t2->math("A = E\\{dot}C, E \\{notequal} 1");
        $l{E}= Line->new($pn,$x5,$yl,$x5,$yl+$E)->label("E","right");
        $l{E}->show_parts(1,undef,"right",$purple);
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore D also measures B according to the units in E"); 
        $t2->grey([0..20]);
        $t2->black([-2]);
        $t2->math("B = E\\{dot}D, E \\{notequal} 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since C measures A according to the units in E, therefore E also measures A according to the units in C (VII.16)"); 
        $t2->grey([0..50]);
        $t2->black([-2]);        
        $t2->math("A = C\\{dot}E");
        $l{A}->show_parts(7,undef,"left",$purple);
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since B measures D according to the units in E, therefore E also measures B according to the units in D (VII.16)"); 
        $t2->grey([0..50]);
        $t2->black([-2]);        
        $t2->math("B = D\\{dot}E");
        $l{B}->show_parts(6,undef,"left",$purple);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore A,B have a common divisor E, which is greater than one."); 
        $t2->grey([0..50]);
        $t2->black([-1,-2]);        
        $t2->math("gcd(A,B) = E, E \\{notequal} 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("This is not possible since A and B are prime to one another (VII Def.12)"); 
        $t2->grey([0..50]);
        $t2->black([0]);
        $t2->red([-1]);        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus A and B are the lowest numbers that have the ratio A to B"); 
        $t2->down;
        $t2->mathsmall("S = { (x,y) | x\\{elementof}\\{natural}, y\\{elementof}\\{natural}, ".
        "x:y=A:B }");
        $t2->mathsmall("(A,B)\\{elementof}S such that A\\{lessthanorequal}x, ".
        "B\\{lessthanorequal}y, \\{forall}(x,y)\\{elementof}S"); 
        $t2->grey([0..50]);
        $t2->black([-1,-2]);        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,-1,-2]);        
    };




    return $steps;

}

