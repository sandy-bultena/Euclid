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
my $title = "Any number is either a part or parts of any number, the less of the greater";

$pn->title( 4, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $tp = $pn->text_box( 600, 180 );
$t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 4 );
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
    my $dy = 10;
    my $dx1 = $ds;
    my $dx2 = $ds + $dx;
    my $dx3 = $ds + 2*$dx;
    my $dx4 = $ds + 3*$dx;
    my $dx5 = $ds + 4*$dx;
    my $dx6 = $ds + 5*$dx;
    my $A = 45;
    my $B = 27;
    my $B1 = 15;
    my $D = 9;
    my $yl = 120+$A*$dy;
    
    my $common = "Given two natural numbers, A and B, either B is part of A, or there exists a natural ".
        "number (a part) that can measure both A and B";
    
    # -------------------------------------------------------------------------
    # Definitions
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->title("Definitions");
        $t2->explain("3. A number is a 'part' of a number, the less of the greater, ".
        "when it measures the greater");
        $t2->math("A = 10, B = 2,");
        $t2->explain("B is part of A");
        $t2->math("A = B + B + B + B + B");

        $t2->down;
        $t2->explain("4. but 'parts' when it does not measure it");
        $t2->math("A=10, B=6 ");
        $t2->explain("Let the part of A be 2");
        $t2->math("p = 2, A = p + p + p + p + p");
        $t2->explain("B is a multiple of the part of A (B is parts of A)");
        $t2->math("B = p + p + p");            
    };
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->title("In other words");
        $t1->explain($common);
        $t2->math("(A,B) \\{elementof} \\{natural}");
        $t2->math("\\{thereexists}(p,m,n) \\{elementof} \\{natural} such that ");
        $t2->math("A = \\{sum(i=1,m)} p");
        $t2->math("B = \\{sum(i=1,n)} p");
        
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("In other words");
        $t1->explain($common);
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Either A, BC are co-prime, or not");
        $t2->erase;
       $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-$A*$dy)->label("A","left");
       $l{B} = Line->new($pn,$dx2,$yl,$dx2,$yl-($B+3)*$dy);
       $p{B} = Point->new($pn,$dx2,$yl-($B+3)*$dy)->label("B","left");
       $p{C} = Point->new($pn,$dx2,$yl)->label("C","left");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("In other words");
        $t1->explain($common);
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Either A, BC are co-prime, or not");
        $t1->explain("Assume A, BC are co-prime");
       $t2->math("gcd(A,BC) = 1");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Divide BC into individual units (the number 1)");
        
        foreach my $i (0..60) {
            $l{A}->tick($i*3*$dy);
            $l{B}->tick($i*3*$dy);
        }
        $t2->down;
        $t2->math("u  = 1");
        $t2->math("A  = \\{sum(i=1,q)} u");
        $t2->math("BC = \\{sum(i=1,p)} u");
     };
    

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Each unit in B will be some part of A, since '1' measures A, ".
        "so BC will be some parts of A");
       $t2->grey([0..20]);
        $t2->blue([-1,-2]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("In other words");
        $t1->explain($common);
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Either A, BC are co-prime, or not");
        $t1->explain("Assume A, BC are not co-prime and BC measures A");
        $t2->erase;
        
        $t2->math("gcd(A,BC) = BC");
         foreach my $i (0..60) {
            $l{A}->tick($i*$B1*$dy);
            $l{B}->tick($i*$B1*$dy);
        }
        $t2->down;
        $t2->math("A  = \\{sum(i=1,q)} BC");
         $l{B}->remove;
        $p{B}->remove;
        $l{A}->remove;
       $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-($A)*$dy)->label("A","left");
       $l{B} = Line->new($pn,$dx2,$yl,$dx2,$yl-($B1)*$dy);
       $p{B} = Point->new($pn,$dx2,$yl-($B1)*$dy)->label("B","left");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If BC measures A, BC is a part of A");
        $t2->math("BC = BC");
       $t2->grey([0..20]);
        $t2->blue([-1,-2]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("In other words");
        $t1->explain($common);
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Either A, BC are co-prime, or not");
        $t1->explain("Assume A, BC are not co-prime and BC does not measure A");
        $t2->erase;
        
         $l{B}->remove;
        $p{B}->remove;
        $l{A}->remove;
       $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-($A)*$dy)->label("A","left");
       $l{B} = Line->new($pn,$dx2,$yl,$dx2,$yl-($B)*$dy);
       $p{B} = Point->new($pn,$dx2,$yl-($B)*$dy)->label("B","left");
       
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Find the largest common divisor D (VII.2), and divide ".
        "BC into the numbers equal to D, namely BE, EF, FC");
        $t2->math("gcd(A,BC) = D");
        $l{D} = Line->new($pn,$dx3,$yl,$dx3,$yl-$D*$dy)->label("D","left");
        $l{B}->tick($D*$dy)->label("F","left");
        $l{B}->tick($D*$dy*2)->label("E","left");
        $t2->down;
        $t2->math("BE = EF = FC = D");
        $t2->math("BC = BE + EF + FC");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since D measures A, D is a part of A");
        foreach my $i (0..20) {
            $l{A}->tick($D*$dy*$i);
        }
        $t2->grey([0..20]);
        $t2->black([0]);
        $t2->math("A  = \\{sum(i=1,q)} D");
        $t2->down;
     };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But BE,EF,FC also equal D");
        $t2->grey([0..20]);
        $t2->black([1,2]);
        $t2->math("BC = \\{sum(i=1,3)} D");        
        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("D is a part of A, so BC is a sum ".
        "of the parts of A");
        $t2->grey([0..20]);
        $t2->blue([0,-1,-2]);
        
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("In other words");
        $t1->explain($common);
        $t1->down;
        $l{A}->remove;
        $l{B}->remove;
       $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-$A*$dy)->label("A","left");
       $l{B} = Line->new($pn,$dx2,$yl,$dx2,$yl-($B)*$dy);
       $p{B} = Point->new($pn,$dx2,$yl-($B)*$dy)->label("B","left");
       $p{C} = Point->new($pn,$dx2,$yl)->label("C","left");
        $t2->erase;
       $t2->math("gcd(A,BC) = 1");
        $t2->math("u = 1");
        $t2->math("A   = \\{sum(i=1,q)} u");
        $t2->math("BC  = \\{sum(i=1,p)} u");
        $t2->down;
        $t2->math("gcd(A,BC) = BC");
        $t2->math("A  = \\{sum(i=1,q)} BC");
        $t2->math("BC = BC");
        $t2->down;
        $t2->math("gcd(A,BC) = D");
        $t2->math("A  = \\{sum(i=1,q)} D");
        $t2->math("BC = \\{sum(i=1,p)} D");
        
    };
    

    
    return $steps;

}

