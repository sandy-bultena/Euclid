#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;


# ============================================================================
# Definitions
# ============================================================================
my $title = "If a magnitude be the same multiple of a magnitude that a part ".
"subtracted is of a part subtracted, the remainder will also be ".
"the same multiple of the remainder that the whole is of the whole";

$pn->title( 5, $title, 'V' );

my $down = 60;
my $offset = 15;
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 550, 375, -width => 480 );
my $t3 = $pn->text_box( 160, 200+2*$down );
my $t2 = $pn->text_box( 450, 200+8*$down );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 5 );
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
    my ( %l, %p, %c, %s, %a );
    my $p = 1/1.2;
    my $k = 3;
    my $a = 45;
    my $cd = 160;
    my $cf = 100;
    my $k2 = 2;
    my @A = (150, 200);
    my @C = (300, 200+$down);
    my @D = (300+$cd, 200+$down);
    my @B = (150+$k*$cd, 200);
    my @E = (150+$k*$cf, 200);
    my @F = (300+$cf,200+$down);
    my @G = ($C[0]-($cd-$cf),200+$down);
    

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let AB be the same multiple of CD as AE is of CF");

        $p{A}=Point->new($pn,@A)->label("A","top");
        $p{B}=Point->new($pn,@B)->label("B","top");
        $p{E}=Point->new($pn,@E)->label("E","top");
        $p{C}=Point->new($pn,@C)->label("C","top");
        $p{F}=Point->new($pn,@F)->label("F","top");
        $p{D}=Point->new($pn,@D)->label("D","top");
        
        $l{AE}=Line->join($p{A},$p{E});
        $l{EB}=Line->join($p{E},$p{B});
        $l{CF}=Line->join($p{C},$p{F});
        $l{FD}=Line->join($p{F},$p{D});

        $t3->math("AB = n\\{dot}CD");
        $t3->math("AE = n\\{dot}CF");
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then the remainder of AB minus the part AE is the same "
        ."multiple of the remainder of CD minus CF");
        $t3->math("EB = n\\{dot}FD");
        $t3->down;
        $t3->math("AB - AE = n\\{dot}CD - n\\{dot}CF = n\\{dot}(CD - CF)");

        
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->down();
        $t1->title("Proof");
        $t3->math("AB = n\\{dot}CD");
        $t3->math("AE = n\\{dot}CF");
        $t3->blue([0,1]);
        $t3->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Create a line GC such that EB is the same multiple of GC "
        ."as AE is to CF");
        $l{CF}->grey;
        $l{FD}->grey;
        $t3->grey(0);
        $l{EB}->tick_marks($cd-$cf);
        $l{AE}->tick_marks($cf);
        $p{G}=Point->new($pn,@G)->label("G","top");
        $l{GC}=Line->join($p{G},$p{C});
        $t3->math("EB = n\\{dot}GC");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since AE and EB are equimultiples of CF and GC, then the "
        ."sum of the lines are also of the same multiple\\{nb}(V.1)");
        $l{AE}->normal;
        $l{CF}->normal;
        $l{GC}->normal;
        $t3->math("AE + EB = n\\{dot}CF + n\\{dot}GC = n\\{dot}(CF + GC)");
        $t3->math("AB = n\\{dot}GF");        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But AB is by definition the same multiple of CD, so CD equals GF");
        $t3->blue(0);
        $t3->grey(1);
        $t3->grey(2);
        $t3->grey(3);
        
        $l{FD}->normal;
        $t3->math("GF = CD");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Subtract CF from both, which gives GC equals FD");
        $l{CF}->grey;
        $t3->grey(0);
        $t3->grey(4);
        
        $t3->math("GF - CF = CD - CF");
        $t3->math("GC = FD");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since GC equals FD, and since EB is the same multiple of GC as ".
        "as AE is to CF, then EB is the same multiple of FD");
        $l{CF}->normal;
        $t3->grey(5);
        $t3->grey(6);
        $t3->black(2);
        $t3->blue(1);
        
        $t3->math("EB = n\\{dot}FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But. by definition, AE is the same multiple of CF that AB is of CD "
        ."therefore EB is the same multiple of FD that AB is of CD");
        $t3->blue(0);
        $t3->grey(2);
        $t3->grey(7);
        $l{GC}->grey;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t3->math("AB - AE = n\\{dot}CD - n\\{dot}CF = n\\{dot}(CD - CF) = n\\{dot}FD");
    };


    return $steps;

}

