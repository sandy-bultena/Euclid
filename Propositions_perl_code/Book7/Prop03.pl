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
my $title = "Given three numbers not prime to one another, to find their ".
"greatest common measure.";

$pn->title( 3, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 300, 200 );
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 3 );
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
    my $ds = 60;
    my $dx = 50;
    my $dy = 10;
    my $dx1 = $ds;
    my $dx2 = $ds + $dx;
    my $dx3 = $ds + 2*$dx;
    my $dx4 = $ds + 3*$dx;
    my $dx5 = $ds + 4*$dx;
    my $dx6 = $ds + 5*$dx;
    my $A = 54;
    my $B = 42;
    my $C = 24;
    my $C2 = 21;
    my $D = 6;
    my $E = 7;
    my $E2 = 3;
    my $F = 5;
    my $yl = 120+$A*$dy;
    
    my ($AE,$EB,$AB,$CD,$CF,$FD);
    my ($q,$p,$m);
    $q = 1;
    $p = 3;
    $m = 2;
    $CF = 6;
    $AE = $m*$CF;
    $FD = $p*$AE;
    $CD = $CF + $FD;
    $EB = $q*$CD;    
    $AB = $AE + $EB;
     
  #   print "$AE, $EB, ($AB, $CD), $CF, $FD\n";
  #   die;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Find the largest common divisor for three numbers");
        
        $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-$A*$dy)->label("A","left");
        $l{B} = Line->new($pn,$dx2,$yl,$dx2,$yl-$B*$dy)->label("B","left");
        $l{C} = Line->new($pn,$dx3,$yl,$dx3,$yl-$C*$dy)->label("C","left");
        
    };

    # -------------------------------------------------------------------------
    # Method
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Method");
        $t2->erase();
        $t1->explain("Find D, the greatest measure of A and B (VII.2)");
        $t2->math("gcd(A,B) = D");
        $l{D} = Line->new($pn,$dx4,$yl,$dx4,$yl-$D*$dy)->label("D","left");
        foreach my $i (0..20) {
            $l{A}->tick($i*$D*$dy);
            $l{B}->tick($i*$D*$dy);
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If D measure C, then D is a common divisor for A,B,C");
        $t2->down;
        $t2->math("let C = \\{sum(i=1,q)} D");
        foreach my $i (0..20) {
            $l{C}->tick($i*$D*$dy);
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("D is the greatest common divisor");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
         $t1->down;
        $t1->title("Proof by contradiction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
         $t1->explain("If D is not the greatest common divisor, ".
        "let E be the greatest common divisor");
        $l{E} = Line->new($pn,$dx5,$yl,$dx5,$yl-$E*$dy)->label("E","left");
        $t2->down;
        $t2->math("let E = gcd(A,B,C)");
        $t2->math("D < E");
        $t2->math("A = \\{sum(i=1,p)} E");        
        $t2->math("B = \\{sum(i=1,q)} E");        
        $t2->math("C = \\{sum(i=1,r)} E");        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since E measures A,B,C, it will also measure the ".
        "greatest common divisor of A,B, which is D (VII.2 Por)");

        $t2->grey([0..20]);
        $t2->black([0,4,5]);
        $t2->down;
        $t2->math("D = \\{sum(i=1,s)} E");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->black([0,3]);
        $t1->explain("But D is less than E, so it cannot be measured by E, ");
        $t2->red([2,3,7]);
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->red([2,3,7]);
        $t1->explain("therefore D is the greatest common divisor");
        $t2->math("\\{therefore} gcd(A,B,C) = D");
        $t2->blue([0,1,-1]);
    };

    # -------------------------------------------------------------------------
    # Method
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Method");
        $t2->erase();
        $t1->explain("Find D, the greatest measure of A and B (VII.2)");
        $t2->math("gcd(A,B) = D");
        $l{D} = Line->new($pn,$dx4,$yl,$dx4,$yl-$D*$dy)->label("D","left");
        foreach my $i (0..20) {
            $l{A}->tick($i*$D*$dy);
            $l{B}->tick($i*$D*$dy);
        }
         $t2->down;
        $t2->math("let C \\{notequal} \\{sum(i=1,q)} D");
        $l{C}->remove;
        $l{C} = Line->new($pn,$dx3,$yl,$dx3,$yl-$C2*$dy)->label("C","left");
        $l{E}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("C and D are not prime to one another");
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
         $t1->down;
        $t1->title("Proof");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A,B,C are not prime to one another, there is a number ".
        "x that measures A,B,C");
        $t2->math("A = \\{sum(i=1,p)} x");
        $t2->math("B = \\{sum(i=1,q)} x");
        $t2->math("C = \\{sum(i=1,r)} x");
        foreach my $i (0..50) {
            $l{A}->tick($i*$E2/2*$dy);
            $l{B}->tick($i*$E2/2*$dy);
            $l{C}->tick($i*$E2/2*$dy);
        }
     };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->black([0,2,3]);
        $t1->explain("This number x will also measure D, the greatest ".
        "common divisor of A,B (VII.2 Por)");
        $t2->math("D = \\{sum(i=1,s)} x");
        foreach my $i (0..10) {
            $l{D}->tick($i*$E2/2*$dy);
        }
     };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since x measures D and C, D and C are not prime to each other");
        $t2->grey([0..20]);
        $t2->blue([0,1,-1,-2]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{A}->remove;
        $l{B}->remove;
        $l{C}->remove;
        $l{D}->remove;        
        $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-$A*$dy)->label("A","left");
        $l{B} = Line->new($pn,$dx2,$yl,$dx2,$yl-$B*$dy)->label("B","left");
        $l{C} = Line->new($pn,$dx3,$yl,$dx3,$yl-$C*$dy)->label("C","left");
        $t1->erase();
        $t1->title("Method");
        $t2->erase();
        $t1->explain("Find D, the greatest measure of A and B (VII.2)");
        $t2->math("gcd(A,B) = D");
        $l{D} = Line->new($pn,$dx4,$yl,$dx4,$yl-$D*$dy)->label("D","left");
        foreach my $i (0..20) {
            $l{A}->tick($i*$D*$dy);
            $l{B}->tick($i*$D*$dy);
        }
        $t2->math("let C \\{notequal} \\{sum(i=1,q)} D");
        $l{C}->remove;
        $l{C} = Line->new($pn,$dx3,$yl,$dx3,$yl-$C2*$dy)->label("C","left");
        $l{E}->grey;

        $t1->explain("Find the greatest common divisor E for C and D (VII.2)");
        $t2->math("gcd(C,D) = E");

        $l{E}->remove;
        $l{E} = Line->new($pn,$dx5,$yl,$dx5,$yl-$E2*$dy)->label("E","left");
        foreach my $i (0..10) {
            $l{C}->tick($i*$E2*$dy);
            $l{D}->tick($i*$E2*$dy);
        }
        #$t2->math("D = \\{sum(i=1,p)} E");
        $t2->allblue;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since E is a measure of D, and since D is a measure of A,B, ".
        "E is also a measure of A,B");
        $t2->down;
        $t2->allgrey;
        $t2->black([0,2]);
        $t2->math("A = \\{sum(i=1,a)} E");
        $t2->math("B = \\{sum(i=1,b)} E");
        foreach my $i (0..20) {
            my $t;
            $t = $l{A}->tick($i*$E2*$dy);
            $t->grey if $t;
            $t = $l{B}->tick($i*$E2*$dy);
            $t->grey if $t;
        }
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And since E also measures C, E is a common measure of A,B,C");
        $t2->grey([0..20]);
        $t2->blue([2,3,4]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Method");
        $t2->erase();
        $t1->explain("Find D, the greatest measure of A and B (VII.2)");
        $t2->math("gcd(A,B) = D");
        $t2->math("gcd(C,D) = E");
        $t2->allblue;
        $t1->explain("Find the greatest common divisor E for C and D (VII.2)");
        $t1->explain("E is the Greatest Common Divisor of A,B,C");    
    };
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that F, which is greater than E, is the largest common ".
        "divisor");
        $t2->down;
        $t2->math("let F = gcd(A,B,C)");
        $t2->math("F > E");
        $t2->math("A = \\{sum(i=1,p)} F");
        $t2->math("B = \\{sum(i=1,q)} F");
        $t2->math("C = \\{sum(i=1,r)} F");
        $l{F} = Line->new($pn,$dx6,$yl,$dx6,$yl-$F*$dy)->label("F","left");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("F measures A,B so it also measures D, the greatest common divisor ".
        "of A,B (VII.2 Por)");
        $t2->down;
        $t2->grey([0..20]);
        $t2->black([0,5,4]);
        $t2->math("D = \\{sum(i=1,s)} F");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("F measures D,C so it also measures E, the greatest common divisor ".
        "of D,C (VII.2 Por)");
        $t2->grey([0..20]);
        $t2->black([7,6,1]);
        $t2->math("E = \\{sum(i=1,n)} F");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But F, being larger than E, cannot measure E, hence F cannot be ".
        "larger than E");
        $t2->grey([0..20]);
        $t2->black([3]);
        $t2->red([3,-1]);
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t2->grey([0..20]);
        $t2->black([0..1]);
        $t2->red([2,3,-1]);
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t2->allgrey;
        $t2->blue([0..1]);
        $t1->explain("Therefore E is the greatest common divisor");
        $t2->math("gcd(A,B,C) = E");
    };

    return $steps;

}

