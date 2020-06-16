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
my $title = "If, as whole is to whole, so is a number subtracted to a number ".
"subtracted, the remainder will also be to the remainder as whole to whole.";

$pn->title( 11, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 80, 300);
my $tp = $pn->text_box( 600, 180 );

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 11 );
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
    my $E = 40;
    my $A = 1.4*$E;
    my $B = 0;
    my $C = .85*$A;
    my $F = .85*$E;
    my $D = 0;
    my $yl = 180+$A*$dy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Definition 20");
        $t1->explain("Numbers are proportional when the first is the same ".
        "multiple, or the same part, or the same parts, of the second that ".
        "the third is of the fourth");
    };

    push @$steps, sub {
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Given AB and CD are in the same proportion as AE and CF");
        $t1->explain("Then EB and FD are in the same proportion as AB and CD");
        $t2->math("AB:CD = AE:CF");
       $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-$A*$dy);
       $l{C} = Line->new($pn,$dx2,$yl,$dx2,$yl-$C*$dy);
       $p{B} = Point->new($pn,$dx1,$yl-$B*$dy)->label("B","left");
       $p{A} = Point->new($pn,$dx1,$yl-$A*$dy)->label("A","left");
       $p{E} = Point->new($pn,$dx1,$yl-$E*$dy)->label("E","left");
       $p{D} = Point->new($pn,$dx2,$yl-$D*$dy)->label("D","left");
       $p{C} = Point->new($pn,$dx2,$yl-$C*$dy)->label("C","left");
       $p{F} = Point->new($pn,$dx2,$yl-$F*$dy)->label("F","left");
    };

    push @$steps, sub {
        $t2->math("(AB-AE):(CD-CF) = AB:CD");
    };
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t2->math("AB:CD = AE:CF");
        $t1->down;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("By definition of proportional, whatever part or parts AB is of CD, ".
        "the same part or the same parts is AE of CF (VII Def 20).");
        $t2->math("AB = (p/q)CD");
        $t2->math("AE = (p/q)CF");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the remainder EB is the same part or parts of ".
        "FD that AB  is of CD (VII.7,8)");
        $t2->grey([0..20]);
        $t2->black([-1,-2]);
        $t2->math("(AB-AE) = (p/q)(CD-CF)");
        $t2->math("EB = (p/q)FD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, as EB is to FD, so is AB to CD (VII Def 20)");
        $t2->grey([0..20]);
        $t2->black([-1,1]);
         $t2->math("EB:FD = AB:CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,-1]);
    };




    return $steps;

}

