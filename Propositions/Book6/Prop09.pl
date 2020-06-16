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
my $title = "From a given straight line to cut off a prescribed part.";

$pn->title( 9, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 9 );
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
    my (%p,%c,%s,%t,%l,%a);
    my $off = 250;
    my $yh = 200;
    my $yb = 400;
    my $dx1 = 250;
    my $m = ($yh-$yb)/$dx1;
    my $dx2 = 0.9*$dx1;
    
    my @A = (100,$yb);
    my @B = ($A[0]+$dx1,$yb);
    my @F = ($A[0]+1.1*$dx2,$yb+($yh-$yb)*1.1);
    my @D = ($A[0]+$dx2/3.,$yb+($yh-$yb)/3.);
    my @E = ($A[0]+2*$dx2/3.,$yb+($yh-$yb)/3*2);
    my @C = ($A[0]+$dx2,$yb+($yh-$yb));
    

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("The instructions required to cut off a certain fraction ".
        "from a given line");
        
        $p{A} = Point->new($pn,@A)->label("A","bottom");
        $p{B} = Point->new($pn,@B)->label("B","bottom");
        $l{AB} = Line->join($p{A},$p{B});
            
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Construction");
        $t3->erase();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let AB be the given line, and the fraction to be "
        ."removed is one third");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a line of any length, making an arbitrary angle with AB");
        $l{A}=Line->new($pn,@A,@F);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let point D be defined anywhere on the new line, and find points ".
        "E and C such that DE and EC are equal to AD (I.3)");
        $p{D}=Point->new($pn,@D)->label("D","top");
        $p{E}=Point->new($pn,@E)->label("E","top");
        $p{C}=Point->new($pn,@C)->label("C","top");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw BC, and draw line DF parallel to BC (I.31)");
        $l{BC} = Line->join($p{B},$p{C});
        $l{DFx} = $l{BC}->parallel($p{D},-1);
        my @p = $l{DFx}->intersect($l{AB});
        $p{F} = Point->new($pn,@p)->label("F","bottom");
        $l{DF} = Line->join($p{D},$p{F}); 
        $l{DFx}->remove;       
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("AF is one third of AB");
        $t3->math("AF = (1/3)\\{dot}AB");
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t3->erase();
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since FD is parallel to BC, one of the sides of the triangle ABC, "
        ."therefore CD is to DA as BF is to FA (VI.2)");
        $t3->math("CD:DA = BF:FA");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But CD is double that of AD, therefore BF is double of AF, "
        ."therefore AB is triple of AF");
        $t3->math("CD = 2\\{dot}AD \\{therefore} BF = 2\\{dot}AF");
        $t3->math("\\{therefore} AB = 3\\{dot}AF");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Therefore AF is one third AB");
    };


    return $steps;

}

