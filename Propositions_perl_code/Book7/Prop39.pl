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
my $title = "To find the number which is the least that will have given parts";
$pn->title( 39, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 40, 300 );
my $t3 = $pn->text_box( 40, 300 );
my $t4 = $pn->text_box( 40, 300);
my $t5 = $pn->text_box( 340, 300);
my $tp = $pn->text_box( 600, 180 );
$t3->wide_math(1);
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 39 );
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
    my $dy = 40;
    my $yl = 160;
    my $y1 = $yl;
    my $y2 = $dy + $y1;
    my $y3 = $dy + $y2;
    my $y4 = $dy + $y3;
    my $y5 = $dy + $y4;

    my $A = 2*$dx;
    my $B = 3*$dx;
    my $C = 4*$dx;
    my $D = 6*$dx;
    my $E = 4*$dx;
    my $F = 3*$dx;
    my $G = 12*$dx;
    my $H = 11*$dx;

my $acolour = $sky_blue;
my $bcolour = $lime_green;
my $ccolour = $pale_pink;
my $dcolour = $blue;
my $ecolour = $turquoise;
my $fcolour = $pink;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Find the smallest number G that has the fractions ".
        "1/A, 1/B and\\{nb}1/C");
        $t2->math("G/A, G/B, G/C \\{elementof} \\{natural}");
     };

    # -------------------------------------------------------------------------
    # Method
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->title("Method");
        $t1->explain("Let A, B and C be the given parts (fractions)");
        $l{A}= Line->new($pn,$ds,$yl,$ds+$A,$yl);
        $p{A}= Point->new($pn,$ds,$yl)->label("A","left");
        $l{B}= Line->new($pn,$ds+$A+60,$yl,$ds+$B+$A+60,$yl);
        $p{B}= Point->new($pn,$ds+$A+60,$yl)->label("B","left");
        $l{C}= Line->new($pn,$ds+$A+60+$B+60,$yl,$ds+$C+$B+60+$A+60,$yl);
        $p{C}= Point->new($pn,$ds+$A+60+$B+60,$yl)->label("C","left");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let D,E,F be numbers called by the same name as the fractions A,B,C. ");
        $t1->explain("   For example, \\{half} has the same name as 2");
        $l{D}= Line->new($pn,$ds,$yl+$dy,$ds+$D,$yl+$dy);
        $p{D}= Point->new($pn,$ds,$yl+$dy)->label("D","left");
        $l{E}= Line->new($pn,$ds+$D+60,$yl+$dy,$ds+$E+$D+60,$yl+$dy);
        $p{E}= Point->new($pn,$ds+$D+60,$yl+$dy)->label("E","left");
        $l{F}= Line->new($pn,$ds+$D+60+$C+60,$yl+$dy,$ds+$D+$C+60+$F+60,$yl+$dy);
        $p{F}= Point->new($pn,$ds+$D+60+$C+60,$yl+$dy)->label("F","left");
        
        $t4->math("D has the same name as the fraction 1/A (ie. A=D)");
        $t4->math("E has the same name as the fraction 1/B (ie. B=E)");
        $t4->math("F has the same name as the fraction 1/C (ie. C=F)");
        $t4->blue([0..2]);
        $t3->y($t4->y);
        $t3->down;

     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Find the lowest common multiple of D,E,F and let it be called\\{nb}G "
        ."(VII.36)");
        $t3->math("G = lcm(D,E,F)");        
        $l{G}= Line->new($pn,$ds,$yl+2*$dy,$ds+$G,$yl+2*$dy);
        $p{G}= Point->new($pn,$ds,$yl+2*$dy)->label("G","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("G is measured by D,E,F");
        $t3->math("G = a\\{dot}D");        
        $t3->math("G = b\\{dot}E");        
        $t3->math("G = c\\{dot}F"); 
        
        $l{D}->parts($D/$D,6,"top",$dcolour);      
        $l{E}->parts($E/$E,6,"top",$ecolour);      
        $l{F}->parts($F/$F,6,"top",$fcolour);      
        $l{G}->parts($G/$D,6,"top",$dcolour);      
        $l{G}->parts($G/$E,12,"top",$ecolour);      
        $l{G}->parts($G/$F,18,"top",$fcolour);      
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore G has parts called by the same name as D,E,F (VII.37)");
        
        $t3->math("G/a \\{elementof} \\{natural}, where 1/a has the same name as D");        
        $t3->math("G/b \\{elementof} \\{natural}, where 1/b has the same name as E");        
        $t3->math("G/c \\{elementof} \\{natural}, where 1/c has the same name as F");        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But the fraction A has the same name as D, etc, so G has ".
        "the fractions A,B and C");
        $t3->down;
        $t3->math("G/A, G/B, G/C \\{elementof} \\{natural}");
    };

     # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey();
        $t3->black([0,-1]);
    };

     # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("G is the lowest number that has the fraction 1/A, 1/B, and\\{nb}1/C");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof by Contradiction");
        $t3->erase;
        $t3->y($t4->y);
        $t3->down;
        $t3->math("G = lcm(D,E,F)");        
        $t3->down;
        $t3->math("G/A, G/B, G/C \\{elementof} \\{natural}");        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the number H, smaller than G, have the fractions 1/A, 1/B, and 1/C");
        $t3->math("H < G");
         $l{H}= Line->new($pn,$ds,$yl+3*$dy,$ds+$H,$yl+3*$dy);
        $p{H}= Point->new($pn,$ds,$yl+3*$dy)->label("H","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since H has the fractions 1/A, etc, it will also be measured by "
        ."fractions of the same name: D,E,F (VII.38)" );

        $t3->math("H = a\\{dot}D");
        $t3->math("H = b\\{dot}E");
        $t3->math("H = c\\{dot}F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Which is a contradiction because G is the lowest common multiple ".
        "of D,E,F not H");
        $t3->allgrey;
        $t3->red([0,-1,-2,-3,-4]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Hence, G is the lowest number that has the parts 1/A, ".
        "1/B and\\{nb}1/C");
        $t3->allgrey;
        $t3->black([0,1]);
    };


    
    return $steps;

}

