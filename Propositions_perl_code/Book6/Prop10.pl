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
my $title = "To cut a given uncut straight line similarly to a given cut straight line.";

$pn->title( 10, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 10 );
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
    my $yb = 400;
    my $dx1 = 300;
    my $m = ($yh-$yb)/$dx1;
    my $dx2 = 0.9*$dx1;
    
    my @A = (100,$yb);
    my @B = ($A[0]+$dx1,$yb);
    my @F = ($A[0]+1.1*$dx2,$yb+($yh-$yb)*1.1);
    my @D = ($A[0]+$dx2/3.5,$yb+($yh-$yb)/3.5);
    my @E = ($A[0]+2.1*$dx2/3.,$yb+($yh-$yb)/3*2.1);
    my @C = ($A[0]+$dx2,$yb+($yh-$yb));
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("The instructions to cut a line (AB) in the same proportions as line (AC)");
        
        $p{A} = Point->new($pn,@A)->label("A","bottom");
        $p{B} = Point->new($pn,@B)->label("B","bottom");
        $l{AB} = Line->join($p{A},$p{B});
        $l{AC}=Line->new($pn,@A,@C);
        $p{D}=Point->new($pn,@D)->label("D","top");
        $p{E}=Point->new($pn,@E)->label("E","top");
        $p{C}=Point->new($pn,@C)->label("C","top");
            
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Construction");
        $t3->erase();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Copy the line segments to join at point A, with any angle between them");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw BC, and draw line DF and EG parallel to BC (I.31)");
        $l{BC} = Line->join($p{B},$p{C});
        $l{DFx} = $l{BC}->parallel($p{D},-1);
        my @p = $l{DFx}->intersect($l{AB});
        $p{F} = Point->new($pn,@p)->label("F","bottom");
        $l{DF} = Line->join($p{D},$p{F}); 
        $l{DFx}->remove;       
        $l{EGx} = $l{BC}->parallel($p{E},-1);
        @p = $l{EGx}->intersect($l{AB});
        $p{G} = Point->new($pn,@p)->label("G","bottom");
        $l{EG} = Line->join($p{E},$p{G}); 
        $l{EGx}->remove; 
        $t3->down;
        $t3->math("DF \\{parallel} EG \\{parallel} BC");      
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("AB has been cut similarly to AC");
        $t3->math("AD:DE = AF:FG");
        $t3->math("DE:EC = FG:GB");
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t3->erase();
        $t3->down;
        $t3->math("DF \\{parallel} EG \\{parallel} BC");      
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a line DHK parallel to AB (I.31)");
        $l{DKx} = $l{AB}->parallel($p{D},-1);
        my @p = $l{DKx}->intersect($l{BC});
        $p{K} = Point->new($pn,@p)->label("K","right");
        $l{DK} = Line->join($p{D},$p{K}); 
        $l{DKx}->remove;
        @p = $l{DK}->intersect($l{EG});
        $p{H} = Point->new($pn,@p)->label("H","topright");       
        $t3->math("DHK \\{parallel} AB");
        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("FH and GK are parallelograms, and hence DH is equal to FG, ".
        "and HK is equal to BG (I.34)");
        $t{p1} = Polygon->join(4,$p{D},$p{H},$p{G},$p{F})->fill($sky_blue);
        $t{p2} = Polygon->join(4,$p{H},$p{K},$p{B},$p{G})->fill($lime_green);
        $t3->math("DH = FG");
        $t3->math("HK = BG");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{p1}->grey;
        $t{p2}->grey;
        $t{t1} = Triangle->join($p{C},$p{D},$p{K})->fill($pale_pink);
        $l{AB}->grey;
        $l{AC}->grey;
        $l{DF}->grey;
        $l{EG}->grey;
        $l{BC}->grey;
        $l{EH} = Line->join($p{E},$p{H});
        $t1->explain("Since EH is parallel to the base of the triangle DCK, the ".
        "ratio of the line segments ".
        "DE to EC is equal to the ratio of the line segments DH to HK (VI.2)");
        $t3->grey([0..10]);
        $t3->math("DE:CE = DH:HK");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But DH equals FG, and HK equals BG, therefore the ratios ".
        "of DE to CE is equal to FG to BG");
        $t3->black([2..3]);
        $t3->math("DE:CE = FG:BG");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{t1}->grey;
        $t{t2}=Triangle->join($p{A},$p{E},$p{G})->fill($pale_yellow);
        $l{EH}->grey;
        $l{DK}->grey;
        $l{DF}->normal;
        $t1->explain("Since DF is parallel to the base of the triangle AEG, the ".
        "ratio of the line segments ".
        "AD to DE is equal to the ratio of the line segments AF to FG (VI.2)");
        $t3->grey([0..10]);
        $t3->math("AD:DE = AF:FG");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{t2}->grey;
        $l{DF}->grey;
        $l{AC}->normal;
        $l{AB}->normal;
        $t1->down;
        $t1->explain("Thus it has been shown that the line AB has been cut ".
        "similarly to the line AC");
        $t3->grey([0..20]);
        $t3->black([5,6]);
    };

    

    return $steps;

}

