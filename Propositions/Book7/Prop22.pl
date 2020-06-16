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
my $title = "The least numbers of those which have the same ratio with them ".
"are prime to one another.";

$pn->title( 22, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 22 );
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
    my $A = 20*$dy/2.2;
    my $B = 15*$dy/2.2;
    my $C = 5*$dy/2.2;
    my $D = 4*$dy/2.2;
    my $E = 3*$dy/2.2;
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
        $t1->explain("If A and B are the smallest whole numbers that are equal to ".
        "the ratio of A to B, then they are prime to one another");
        $t2->mathsmall("S = { (x,y) | x\\{elementof}\\{natural}, y\\{elementof}\\{natural}, ".
        "x:y=A:B }");
        $t2->mathsmall("(A,B)\\{elementof}S such that A\\{lessthanorequal}x,".
        "B\\{lessthanorequal}y, \\{forall}(x,y)\\{elementof}S"); 
        $t2->down;
        $t2->math("gcd(A,B) = 1");
        $l{A}= Line->new($pn,$x1,$yl,$x1+$A,$yl);
        $p{A}=Point->new($pn,$x1,$yl)->label("A","left");
        $l{B}= Line->new($pn,$x1,$yl+$dy,$x1+$B,$yl+$dy);
        $p{B}=Point->new($pn,$x1,$yl+$dy)->label("B","left");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t2->erase;
        $t2->mathsmall("S = { (x,y) | x\\{elementof}\\{natural}, y\\{elementof}\\{natural}, ".
        "x:y=A:B }");
        $t2->mathsmall("(A,B)\\{elementof}S such that A\\{lessthanorequal}x,".
        "B\\{lessthanorequal}y, \\{forall}(x,y)\\{elementof}S"); 
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that A and B are not prime to one another");
        $t2->math("gcd(A,B) = C");
        $l{C}= Line->new($pn,$x1,$yl+2*$dy,$x1+$C,$yl+2*$dy);
        $p{C}=Point->new($pn,$x1,$yl+2*$dy)->label("C","left");
        $l{C}->show_parts(1,undef,"top",$pale_pink);
        $l{A}->show_parts($A/$C,undef,"top",$pale_pink);
        $l{B}->show_parts($B/$C,undef,"top",$pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("For as many times that C measures A, let there be so many ".
        "units in D");
        $t2->grey([0..20]);
        $t2->black([-1]);
        $t2->math("A = \\{sum(i=1,d)} C");
        $t2->math("D = \\{sum(i=1,d)} 1");
        $l{D}= Line->new($pn,$x1,$yl+3*$dy,$x1+$D,$yl+3*$dy);
        $p{D}=Point->new($pn,$x1,$yl+3*$dy)->label("D","left");
        $l{D}->show_parts($A/$C,undef,"top",$turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("C measures A according to the units in D, therefore A ".
        "is equal to C times D (VII.Def.15)");
        $t2->grey([0..20]);
        $t2->black([-1,-2,-3]);
        $t2->math("A = C\\{times}D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("By the same argument, B is equal to C times E");
        $t2->grey([0..20]);
        $t2->math("B = C\\{times}E");
        $l{E}= Line->new($pn,$x1,$yl+4*$dy,$x1+$E,$yl+4*$dy);
        $p{E}=Point->new($pn,$x1,$yl+4*$dy)->label("E","left");
        $l{E}->show_parts($B/$C,undef,"top",$turquoise);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus A,B are equal to C multiplied by D and E, respectively, ".
        "therefore D is to E as A is to B (VII.17)");
        $t2->grey([0..20]);
        $t2->black([-1,-2]);
        $t2->math("D:E = A:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But D and E are less than A and B, which violates the ".
        "original hypothesis");
        $t2->grey([0..20]);
        $t2->red([-1,-2,-3]);
        $t2->black([0,1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, A and B are relatively prime");
        $t2->math("gcd(A,B) = 1");
        $t2->grey([0..20]);
        $t2->blue([0,1,-1]);
    };





    return $steps;

}

