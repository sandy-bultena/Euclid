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
my $title = "If two magnitudes be equimultiples of two magnitudes, and ".
"any magnitudes subtracted from them be equimultiples of the same, the ".
"remainders are also are either equal to the same or equimultiples of them";

$pn->title( 6, $title, 'V' );

my $down = 40;
my $offset = 15;
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 550, 375, -width => 480 );
my $t3 = $pn->text_box( 160, 200+4*$down );
my $t2 = $pn->text_box( 450, 200+4*$down );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page5($pn);
push @$steps, Proposition::toc5( $pn, 6 );
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
    my $k = 4;
    my $a = 45;
    my $e = 110;
    my $f = 75;
    my $k2 = 3;
    my @A = (150, 200);
    my @C = (150, 200+2*$down);
    my @D = (150+4*$f, 200+2*$down);
    my @B = (150+$k*$e, 200);
    my @E = (150, 200+$down);
    my @F = (150,200+3*$down);
    my @G = (150+$k2*$e,200);
    my @K = (150-$f, 200+2*$down);
    my @H = (150+3*$f,200+2*$down);
    

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let AB be the same multiple of E as CD is of F");

        $p{A}=Point->new($pn,@A)->label("A","top");
        $p{B}=Point->new($pn,@B)->label("B","top");
        $l{AB} = Line->join($p{A},$p{B})->tick_marks($e);
        $p{E}=Point->new($pn,@E)->label("E","top");
        $l{E} = Line->new($pn,@E,$E[0]+$e,$E[1]);
        $p{C}=Point->new($pn,@C)->label("C","top");
        $p{D}=Point->new($pn,@D)->label("D","top");
        $l{CD} = Line->join($p{C},$p{D})->tick_marks($f);
        $p{F} = Point->new($pn,@F)->label("F","top");
        $l{F} = Line->new($pn,@F,$F[0]+$f,$F[1]);
        
        $t3->math("AB = nE");
        $t3->math("CD = nF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Subtract AG and CH be from AB and CD, where ".
        "AG,CH are equimultiples of E and F respectively");
        
        $p{H} = Point->new($pn,@H)->label("H","top");
        $p{G} = Point->new($pn,@G)->label("G","top");
        
        $t3->math("AG = mE");
        $t3->math("CH = mF");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then, either GB,HD are both equal to E,F, ".
        "or they are equimultiples of them");
        
        $t3->down;
        $t3->math("GB = AB - AG = nE - mE = kE");
        $t3->math("HD = CD - CH = nF - mF = kF");
        
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->down();
        $t1->title("Proof");
        $t3->math("AB = nE");
        $t3->math("CD = nF");
        $t3->math("AG = mE");
        $t3->math("CH = mF");
        $t3->down;
        $t3->blue([0..3]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->math("Let GB = E");
        $t1->explain("Let GB equal E, and create a line KC equal to F");
        $p{K}=Point->new($pn,@K)->label("K","top");
        $l{KC}=Line->join($p{K},$p{C});
        
        $t3->grey([0..3]);
        $t3->math("Let KC = F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("AG,CH are the same multiples of E,F, while GB equals\\{nb}E ".
        "and KC equals F ... ");
         
        $t3->blue(2);
        $t3->blue(3);
        $t3->math("AG + GB = AB = nE");
        $t3->math("KC + CH = KH = nF");
        
        $t1->explain("... therefore, AB,KH are equimultiple to E,F\\{nb}(V.2)");
         
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since CD,KC are equimultiples of F, then KC must equal "
        ."CD");
         
        $t3->blue(1);
        $t3->grey([0,2,3,4,5,6]);
        $t3->math("KH = CD");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Subtract CH from CH and CD, therefore the .".
        "remainders KC,HD are equal");
        
        $t3->grey([1,6,7,8]);
        
        $t2->math("KH = CD");
        $t2->math("KH - CH = CD - CH");
        $t2->math("KC = HD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But KC is equal to F, so HD must also be equal to F");
        $t3->black(5);
        $t2->grey([0..1]);
        $t2->math("HD = F");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Hence, if GB is equal to E, HD must be equal to F");
        $t3->black(4);
        $t3->grey(5);
        $t3->blue([0..3]);
        $t2->grey([0..2]);
    };

    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Using the same method, we can prove that if GB is ".
        "a multiple of E, then HD will be the same multiple of F");
         
        $t3->grey([4,5]);
        $t3->blue([0..3]);
        $t2->grey(3);
        
        $t3->down;
        $t3->math("AB - AG = nE - mE = (n-m)E = kE = GB");
        $t3->math("CD - CH = nF - mF = (n-m)F = kF = HD");
        
    };
    

    return $steps;

}

