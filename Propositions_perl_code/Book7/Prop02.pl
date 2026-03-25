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
my $title = "Given two numbers not prime to one another, to find their ".
"greatest common measure.";

$pn->title( 2, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 400, 160 );
my $t4 = $pn->text_box( 300, 200 );
my $t5 = $pn->text_box( 800, 160 );
    my $sep = 5;

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 2 );
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
    #push @$steps, Proposition::title_page7($pn);
    my (%p,%c,%s,%t,%l);
    my $ds = 80;
    my $dx = 60;
    my $dy = 3;
    my $dx1 = $ds;
    my $dx2 = $ds + $dx;
    my $dx3 = $ds + 2*$dx;
    my $A = 140;
    my $B = 0;
    my $C = 63;
    my $D = 0;
    my $E = $A-$A%$C;
    my $F = $C-$C%($A-$E);
    my $G = 9;
    my $yl = 180+$A*$dy;
    my $H = 1;
    
    my ($AE,$EB,$AB,$CD,$CF,$FD);
    my ($q,$p,$m);
    $q = 1;
    $p = 3;
    $m = 2;
    $CF = 2;
    $AE = $m*$CF;
    $FD = $p*$AE;
    $CD = $CF + $FD;
    $EB = $q*$CD;    
    $AB = $AE + $EB;
     
 #    print "$AE, $EB, $AB, $CD, $CF, $FD\n";
 #    die;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Find the greatest common divisor for two numbers");
        
        $p{A} = Point->new($pn,$dx1,$yl-$A*$dy)->label("A","right");
        $p{B} = Point->new($pn,$dx1,$yl-$B*$dy)->label("B","right");
        $p{C} = Point->new($pn,$dx2,$yl-$C*$dy)->label("C","right");
        $p{D} = Point->new($pn,$dx2,$yl-$D*$dy)->label("D","right");
        $l{AB} = Line->join($p{B},$p{A});
        $l{CD} = Line->join($p{D},$p{C});
        
    };

    # -------------------------------------------------------------------------
    # Method
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Finding gcd()");
        $t2->erase();
        $t1->explain("Continuously subtract the smaller number from the larger, "
        ."until one number measures the other");
        $t1->explain("This number will not be 1, as AB,CD are not relatively prime ".
        "(VII.1)");
        $t1->explain("This number is the largest common divisor");
    };

    # -------------------------------------------------------------------------
    # Example
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Example");
        $t2->erase;
        $t2->math("AB = 140, CD = 63");
        $t3->y($t2->y);
        $t3->down($sep);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let CD measure BE with the remainder AE less than CD, ");
        $t3->math("140- 63 = 77");
        $l{AB}->grey;
        $p{t1} = Point->new($pn,$dx1,$yl-$C*$dy);
        $l{t1} = Line->join($p{t1},$p{A});
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->math(" 77- 63 = 14");
        $t3->down($sep);
        $t2->y($t3->y);
        $l{t1}->remove;
        $p{t1}->grey;
        $p{t2} = Point->new($pn,$dx1,$yl-2*$C*$dy);
        $l{t2} = Line->join($p{t2},$p{A});

    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t2}->remove;
        $p{t2}->grey;
        $t2->math("AE=14");
        $p{E} = Point->new($pn,$dx1,$yl-$E*$dy)->label("E","right");
        $t3->y($t2->y);
        $t3->down($sep);
        $l{AE} = Line->join($p{A},$p{E});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And AE measure DF, with CF less than AE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t2}->remove;
        $p{t2}->grey;
        $l{CD}->grey;
        $p{t3} = Point->new($pn,$dx2,$yl-($A-$E)*$dy);
        $l{t3} = Line->join($p{t3},$p{C});
        $t3->math(" 63- 14 = 49");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t3}->remove;
        $p{t3}->grey;
        $p{t4} = Point->new($pn,$dx2,$yl-2*($A-$E)*$dy);
        $l{t4} = Line->join($p{t4},$p{C});
        $t3->math(" 49- 14 = 35");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t4}->remove;
        $p{t4}->grey;
        $p{t5} = Point->new($pn,$dx2,$yl-3*($A-$E)*$dy);
        $l{t5} = Line->join($p{t5},$p{C});
        $t3->math(" 35- 14 = 21");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t5}->remove;
        $p{t5}->grey;
        $p{t6} = Point->new($pn,$dx2,$yl-4*($A-$E)*$dy);
        $l{t6} = Line->join($p{t6},$p{C});
        $t3->math(" 21- 14 =  7");
        $t3->down($sep);
        $t2->y($t3->y);

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->math("CF=7");
        $t2->down($sep);
        $p{F} = Point->new($pn,$dx2,$yl-$F*$dy)->label("F","right");
        $l{CD}->grey;
        $l{CF} = Line->join($p{C},$p{F});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And let CF measure AE...");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->y($t2->y);
        $t3->down($sep);
        $l{AE}->grey;
        $p{t7} = Point->new($pn,$dx1,$yl-($E-($F-$C))*$dy);
        $l{t7} = Line->join($p{t7},$p{A});
        $t3->math(" 14-  7 =  7");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{t7}->grey;
        $l{t7}->remove;
        $t3->math("  7-  7 =  0");
    };

    push @$steps, sub {
        $t1->explain("... leaving NO remainder");
        $t3->down($sep);
        $t2->y($t3->y);
        $t2->math("AE = 2\\{times}CF");
        $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the smaller number (7) measures the larger number (14) ".
        "it is the greatest common divisor");
        $t2->math("\\{then} gcd(AB,CD) = CF = 7");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
         $t1->erase();
         $l{AB}->normal;
        $l{CD}->normal;  
        $t1->title("Proof");
        $t2->erase();
        $t3->erase;
        $t4->erase;

        $t1->explain("If CD measures AB, then CD is the largest common divisor ".
        "since it measures AB and itself, and no larger number can measure CD");
        $t2->math("if AB = \\{sum(i=1,n)}  CD");
        $t2->down($sep);
        $t2->math("gcd(AB,CD) = CD");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
         $t1->erase();
        $t1->title("Proof");
        $t2->erase();      

        $t1->explain("Let CD measure BE, leaving AE less than CD, let AE measure DF, ".
        "leaving FC less than DF, and let CF measure AE");
        $t2->math("BE = \\{sum(i=1,a)}  CD, AE < CD");
        $t2->down($sep);
        $t2->math("DF = \\{sum(i=1,b)}  AE, FC < AE");
        $t2->down($sep);
        $t2->math("AE = \\{sum(i=1,c)}  CF");
        $t2->down();
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->bold("Proof that CF is a common measure");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since CF measures AE, and AE measures DF, then CF will also measure DF");
        $l{AB}->tick(($E+$C-$F)*$dy);
        $t2->grey([0..20]);
        $t2->black([2]);
        
        $l{4} = Line->new($pn,$dx1+10,$yl-$E*$dy-2,$dx1+10,$yl-$E*$dy - ($C-$F)*$dy+2)->grey;
        $l{5} = Line->new($pn,$dx1+10,$yl-$E*$dy - ($C-$F)*$dy-2,$dx1+10,$yl-$E*$dy - 2*($C-$F)*$dy+2)->grey;

        $t2->down($sep);
        
    };
    
    push @$steps, sub {
        my $y = $t2->y;
        $t4->y($y);
        $t4->math("DF = \\{sum(i=1,c)}  CF + ... ");
        $t2->grey([0..20]);
        $t2->black([1,2]);
        $l{1} = Line->new($pn,$dx2+10,$yl-2,$dx2+10,$yl-($A-$E)*$dy+2)->grey;
        $l{1}->tick(0.5*($A-$E)*$dy)->grey;
    };
    
    push @$steps, sub {
        $t4->erase;
        my $y = $t2->y;
        $t4->y($y);
        $t4->math("DF = \\{sum(i=1,c)}  CF + \\{sum(i=1,c)}  CF + ... ");
        $l{CD}->tick(($D+2*($A-$E))*$dy);
        $l{2} = Line->new($pn,$dx2+10,$yl-($A-$E)*$dy-2,$dx2+10,$yl-2*($A-$E)*$dy+2)->grey;
        $l{2}->tick(0.5*($A-$E)*$dy)->grey;
    };
    
    push @$steps, sub {
        $t4->erase;
        my $y = $t2->y;
        $t4->y($y);
        $t4->math("DF = \\{sum(i=1,c)}  CF + \\{sum(i=1,c)}  CF + \\{sum(i=1,c)}  CF + ... ");
        $l{CD}->tick(($D+$A-$E)*$dy);
        $l{3} = Line->new($pn,$dx2+10,$yl-2*($A-$E)*$dy-2,$dx2+10,$yl-3*($A-$E)*$dy+2)->grey;
        $l{3}->tick(0.5*($A-$E)*$dy)->grey;
    };
    
    push @$steps, sub {
        $t4->erase;
        $t2->math("DF = \\{sum(i=1,c)}  CF + \\{sum(i=1,c)}  CF + ... = \\{sum(i=1,p)}  CF");
        $l{CD}->tick(($D+3*($A-$E))*$dy);
        $l{31} = Line->new($pn,$dx2+10,$yl-3*($A-$E)*$dy-2,$dx2+10,$yl-4*($A-$E)*$dy+2)->grey;
        $l{31}->tick(0.5*($A-$E)*$dy)->grey;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->black([-1]);
        $t1->explain("CF also measures itself, therefore it measures all of CD");
        $t2->math("CD = CF+DF = CF + \\{sum(i=1,p)}  CF = \\{sum(i=1,n)}  CF");
        $t2->down($sep);
        $l{6} = Line->new($pn,$dx2+10,$yl-($F)*$dy-2,$dx2+10,$yl-$C*$dy+2)->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->black([0,-1]);
        $t1->explain("But CD measures BE, therefore CF will also measure BE");
        $t2->math("BE = \\{sum(i=1,n)}  CF + \\{sum(i=1,n)}  CF + ... = \\{sum(i=1,q)}  CF");
        $t2->down($sep);
        $l{6} = Line->new($pn,$dx1+10,$yl-2,$dx1+10,$yl-$C*$dy+2)->grey;
        $l{6}->tick(($C-$F)*$dy)->grey;
        $l{6}->tick(2*($C-$F)*$dy)->grey;
        $l{6}->tick(3*($C-$F)*$dy)->grey;
        $l{6}->tick(4*($C-$F)*$dy)->grey;
        $l{6}->tick(5*($C-$F)*$dy)->grey;
        $l{6}->tick(6*($C-$F)*$dy)->grey;
        $l{6}->tick(7*($C-$F)*$dy)->grey;
        $l{6}->tick(8*($C-$F)*$dy)->grey;
    };

    push @$steps, sub {
        $l{7} = Line->new($pn,$dx1+10,$yl-$C*$dy-2,$dx1+10,$yl-2*$C*$dy+2)->grey;
        $l{7}->tick(($C-$F)*$dy)->grey;
        $l{7}->tick(2*($C-$F)*$dy)->grey;
        $l{7}->tick(3*($C-$F)*$dy)->grey;
        $l{7}->tick(4*($C-$F)*$dy)->grey;
        $l{7}->tick(5*($C-$F)*$dy)->grey;
        $l{7}->tick(6*($C-$F)*$dy)->grey;
        $l{7}->tick(7*($C-$F)*$dy)->grey;
        $l{7}->tick(8*($C-$F)*$dy)->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->black([2,-1]);
        $t1->explain("CF measures AE, therefore it measures all of AB");
        $t2->math("AB = AE+BE = \\{sum(i=1,c)}  CF + \\{sum(i=1,q)}  CF = \\{sum(i=1,m)}  CF");       
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("CF measures both AB and CD");
        $t2->grey([0..20]);
        $t2->black([-1,-3]);
        $t2->blue([0,1,2]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
         $t1->erase();
        $t1->title("Proof");
        $t2->erase();      

        $t1->explain("Let CD measure BE, leaving AE less than CD, let AE measure DF, ".
        "leaving FC less than DF, and let CF measure AE");
        $t2->math("BE = \\{sum(i=1,a)}  CD, AE < CD");
        $t2->down($sep);
        $t2->math("DF = \\{sum(i=1,b)}  AE, FC < AE");
        $t2->down($sep);
        $t2->math("AE = \\{sum(i=1,c)}  CF");
        $t2->down();
 
        $t1->down;
        $t1->bold("Proof that CD is the greatest common divisor");
         $t2->math("CD = \\{sum(i=1,n)}  CF");
        $t2->math("AB = \\{sum(i=1,m)}  CF");  
        $t2->allblue;     
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that G, larger than CF, is also a common divisor");
       $l{G} = Line->new($pn,$dx3,$yl,$dx3,$yl-$G*$dy)->label("G","right");
       $t2->down;
       $t2->explain("Assume");
       $t2->math("G > CF");
       $t2->math("AB = \\{sum(i=1,p)}  G");
       $t2->down($sep);
       $t2->math("CD = \\{sum(i=1,q)}  G");
       $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since G measures CD, and CD measures BE, G also measures BE");
        $t2->grey([1..7]);
        $t2->math("BE = \\{sum(i=1,q)}  G + \\{sum(i=1,q)}  G + ... = \\{sum(i=1,r)}  G");
       $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since G also measures AB, it must measure AE");
        $t2->grey([0..20]);
        $t2->black([-3,-1]);
        $t2->math("AE = AB-BE = \\{sum(i=1,p)}  G - \\{sum(i=1,r)}  G = \\{sum(i=1,s)}  G");
       $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But AE measures DF, therefore G will also measure DF");
        $t2->grey([0..20]);
        $t2->black([-1,1]);
        $t2->math("DF = \\{sum(i=1,s)} G + \\{sum(i=1,s)} G + ... = \\{sum(i=1,t)} G");
       $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since G also measures DC, it must measure CF");
        $t2->grey([0..20]);
        $t2->black([-1,8]);
        $t2->math("CF = CD-DF = \\{sum(i=1,q)}  G - \\{sum(i=1,t)}  G = \\{sum(i=1,u)}  G");
       $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But G cannot measure CF, because CF is less than G");
        $t2->grey([0..20]);
        $t2->math("CF \\{notequal} \\{sum(i=1,u)}  G");
        $t2->red([6,-1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore there is a contradiction, and there is no ".
        "number G, larger than CF, that measures AB and CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Therefore, there is no number G, greater than CF, that will ".
        "measure AB and CD");
        $t2->grey([0..20]);
        $t2->blue([0,1,2]);
        $t2->down;
        $t2->explain("CF is the greatest common divisor");
        $t2->blue(-1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Porism");
        $t1->explain("If a number measures two numbers, it must also measure the ".
        "greatest common divisor");
        $t2->blue(-3);
    };

    return $steps;

}

