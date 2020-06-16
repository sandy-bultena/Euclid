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
my $title = "If a number by multiplying two numbers make certain numbers, ".
"the numbers so produced will have the same ratio as the numbers multiplied";

$pn->title( 17, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
        $t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 17 );
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
    my $ds = 180;
    my $dx = 40;
    my $dy = 40;
    my $dy1 = $ds;
    my $dy2 = $ds + $dy;
    my $dy3 = $ds + 2*$dy+20;
    my $dy4 = $dy3 + $dy;
    my $dy5 = $dy4 + $dy;
    my $dy6 = $dy5 + $dy;
    my $A = 2*$dx;
    my $B = 3*$dx;
    my $C = 4*$dx;
    my $D = 6*$dx;
    my $E = 8*$dx;
    my $F = $dx;
    my $xl = 60;
    my $y;
    my $yy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->title("In other words");
        $t1->explain("The ratio B to C is equal to the ratio A times B to A times C");
        $t4->down;
        $t4->down;
        $t4->down;
        $t4->math("D = A\\{times}B");
        $t4->math("E = A\\{times}C");
        $t4->math("\\{then} B:C = D:E");
        $p{A}= Point->new($pn,$xl+$A,$dy1)->label("A","right");
        $p{B}= Point->new($pn,$xl,$dy2)->label("B","left");
        $p{C}= Point->new($pn,$xl+$D+$xl,$dy2)->label("C","left");
       $l{A} = Line->new($pn,$xl,$dy1,$xl+$A,$dy1);
       $l{B} = Line->new($pn,$xl,$dy2,$xl+$B,$dy2);
       $l{C} = Line->new($pn,$xl+$D+$xl,$dy2,$xl+$D+$xl+$C,$dy2);
       $l{E} = Line->new($pn,$xl+$D+$xl,$dy3,$xl+$D+$xl+$E,$dy3)->label("E","top");
       $l{D} = Line->new($pn,$xl,$dy3,$xl+$D,$dy3)->label("D","top");
       
    };

    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->down;
        $t4->down;
        $t4->down;
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Let D be the result of A times B, and let D be the result ".
        "of A times C");
        $t4->math("D = A\\{times}B");
        $t4->math("E = A\\{times}C");
        $p{F}= Point->new($pn,$xl+$F,$dy4)->label("F","right");
       $l{F} = Line->new($pn,$xl,$dy4,$xl+$F,$dy4);
       $t4->math("F = 1");
        $t4->down;
        $yy = $t4->y;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since D is equal to B multiplied by A, therefore B measures ".
        "D the same number of times the unit F measures A");
        $t4->grey([1,3..20]);
        $t4->math("D = \\{sum(i=1,a)} B");
        $t4->math("A = \\{sum(i=1,a)} F");
        $l{pFt} = $l{F}->show_parts(1,undef,'top',$turquoise);
        $l{pAt} = $l{A}->show_parts($A/$F,undef,'top',$turquoise);
        $l{pBt} = $l{B}->show_parts(1,undef,"top",$pale_pink);
        $l{pDt} = $l{D}->show_parts($D/$B,undef,"top",$pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, the ratio of F to A is the same as B to D (VII.Def.20)");
        $t4->math("F:A = B:D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, the ratio of F to A is the same as C to E");
        $t4->grey([0..20]);
        $t4->black([1,2]);
        $t4->math("F:A = C:E");
        $l{pCt} = $l{C}->show_parts(1,undef,"top",$pale_pink);
        $l{pEt} = $l{E}->show_parts($E/$C,undef,"top",$pale_pink);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, B is to D as C is to E");
        $t4->grey([0..20]);
        $t4->black([-1,-2]);
        $t4->math("B:D = C:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Alternately, as B is to C, so is D to E (VII.13)");
        $t4->grey([0..20]);
        $t4->black([-1]);
        $t4->math("B:C = D:E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->grey([0..20]);
        $t4->blue([0,1]);        
        $t4->blue([-1]);        
    };





    return $steps;

}

