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
my $title = "To two given straight lines to find a third proportional.";

$pn->title( 11, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 11 );
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
    my $yh = 180;
    my $yb = 280;
    my $dx1 = 50;
    my $m = ($yh-$yb)/$dx1;
    my $dx2 = 0.9*$dx1;
    my $dx3 = $dx1*$dx1/$dx2;
    
    my @B = (160,$yb);
    my @A = ($B[0]+$dx1,$yh);
    my @C = ($A[0]+$dx2,$yb+20);
    my $dy3 = ($C[1]-$A[1])**2/($yb-$yh);
    my @E = ($C[0]+$dx3,$C[1]+$dy3);
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given two line segments AB, AC, find a third CE such that ".
        "the ratio AB to AC is equal to the ratio AC to CE");
        
        $p{A} = Point->new($pn,@A)->label("A","top");
        $p{B} = Point->new($pn,@B)->label("B","left");
        $l{AB} = Line->join($p{A},$p{B});
        $l{AC}=Line->new($pn,@A,@C);
        $p{C}=Point->new($pn,@C)->label("C","right");
        $t3->math("AB:AC = AC:CE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{E} = Point->new($pn,@E)->label("E","right");
        $l{CE} = Line->join($p{C},$p{E});
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Construction");
        $t3->erase();
        $l{CE}->remove;
        $p{E}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Place both lines on a common vertex");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Extend AB to D, where BD is equal to AC (I.3)");
        $l{AD} = Line->join($p{A},$p{B},-1,1)->extend(200);
        ($l{x},$p{x}) = $l{AC}->copy($p{B});
        $c{x} = Circle->new($pn,@B,$p{x}->coords);
        my @p = $c{x}->intersect($l{AD});
        $p{D} = Point->new($pn,@p)->label("D","left");
        $l{BD} = Line->join($p{B},$p{D});
        $l{x}->remove;
        $p{x}->remove;
        $l{AD}->remove;
        $c{x}->remove;
        $t3->math("BD = AC")->blue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw the line BC, and draw a line parallel to BC from point\\{nb}D (I.31)");
        $l{BC} = Line->join($p{B},$p{C});
        $l{DEx} = $l{BC}->parallel($p{D})->dash;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Extend line AC");
        my @p = $l{AC}->intersect($l{DEx});
        $p{E} = Point->new($pn,@p);
        $l{CE} = Line->join($p{C},$p{E})->dash;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Define the intercept of AC and the ".
        "previous parallel line as point\\{nb}E");
        $p{E}->label("E","right");
        $l{CE}->undash;
        $l{DE} = Line->join($p{D},$p{E});
        $l{DEx}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("AB is to AC as AC is to CE");
        $t3->math("AB:AC = AC:CE");
        $l{BD}->grey;
        $l{DE}->grey;
        $l{BC}->grey;
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
    #    $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t3->erase();
        $l{BD}->normal;
        $l{DE}->normal;
        $l{BC}->normal;
        $t3->math("BD = AC")->blue;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since BC is parallel to the base DE of the triangle ADE, ".
        "then AB is to BD as AC is to CE (VI.2)");
        $t{ADE} = Triangle->join($p{A},$p{D},$p{E})->fill($sky_blue);
        $t3->math("AB:BD = AC:CE");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t1->down;
        $t1->explain("But BD is equal to AC, so AB is to AC as AC is to CE");
        $t3->math("AB:AC = AC:CE");
    };

    

    return $steps;

}

