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

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 300, 200 );
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 400, 160 );
my $t4 = $pn->text_box( 700, 160 );

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If there be as many numbers as we please in continued proportion, and ".
    "the extremes of them be prime to one another, the numbers are the least ".
    "of those which have the same ratio with them";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 1
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my ( %p, %c, %s, %t, %l );
    my $ds  = 30;
    my $dxs  = 100;
    my $dys = 200;
    my $unit = 10;
    
    my $p = 1.5;
    my $A = 4;
    my $B = $A*$p;
    my $C = $B*$p;
    my $D = $C*$p;
    my $E = 3;
    my $F = $A*$p;
    my $G = $B*$p;
    my $H = $C*$p;
    
    my @A   = ($dxs,$dys,$dxs+$A*$unit,$dys);
    $dys = $dys + $ds;
    my @B   = ($dxs,$dys,$dxs+$B*$unit,$dys);
    $dys = $dys + $ds;
    my @C   = ($dxs,$dys,$dxs+$C*$unit,$dys);
    $dys = $dys + $ds;
    my @D   = ($dxs,$dys,$dxs+$D*$unit,$dys);
    $dys = $dys + $ds;
    
    $dys = $dys + $ds;
    my @E   = ($dxs,$dys,$dxs+$E*$unit,$dys);
    $dys = $dys + $ds;
    my @F   = ($dxs,$dys,$dxs+$F*$unit,$dys);
    $dys = $dys + $ds;
    my @G   = ($dxs,$dys,$dxs+$G*$unit,$dys);
    $dys = $dys + $ds;
    my @H   = ($dxs,$dys,$dxs+$H*$unit,$dys);
    $dys = $dys + $ds;

    my $steps;
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "If we have a group of numbers in continued proportion, "
        ."and the first and last are prime to one another," );
       
        $p{A} = Point->new( $pn, @A[0,1])->label( "A", "left" );
        $p{B} = Point->new( $pn, @B[0,1] )->label( "B", "left" );
        $p{C} = Point->new( $pn, @C[0,1] )->label( "C", "left" );
        $p{D} = Point->new( $pn, @D[0,1] )->label( "D", "left" );
        $l{A} = Line->new($pn,@A);
        $l{B} = Line->new($pn,@B);
        $l{C} = Line->new($pn,@C);
        $l{D} = Line->new($pn,@D);
        
        $t2->math("A:B = B:C = C:D");
        $t2->math("gcd(A,D) = 1");

    };

    push @$steps, sub {
        $t1->explain( "Then the numbers are the lowest possible numbers "
        ."that have the ratio of the first to the second" );
       
        $t2->down();
        $t2->mathsmall("S={(i,j,k,l)|i,j,k,l\\{elementof}\\{natural}, i:j=j:k=k:l=A:B}");
        $t2->mathsmall("(A,B,C,D)\\{elementof}S \nsuch that A\\{lessthanorequal}i, ".
        "B\\{lessthanorequal}j, C\\{lessthanorequal}k, D\\{lessthanorequal}l ".
        "\\{forall}(i,j,k,l)\\{elementof}S"); 
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof by Contradiction");

        $t2->erase;
        $t2->math("A:B = B:C = C:D");
        $t2->math("gcd(A,D) = 1");
        $t2->allblue();
    };

    push @$steps, sub {
        $t1->explain("Let E,F,G,H be numbers smaller than A,B,C,D, but with ".
        "the same ratio");
        $p{E} = Point->new( $pn, @E[0,1])->label( "E", "left" );
        $p{F} = Point->new( $pn, @F[0,1] )->label( "F", "left" );
        $p{G} = Point->new( $pn, @G[0,1] )->label( "G", "left" );
        $p{H} = Point->new( $pn, @H[0,1] )->label( "H", "left" );
        $l{E} = Line->new($pn,@E);
        $l{F} = Line->new($pn,@F);
        $l{G} = Line->new($pn,@G);
        $l{H} = Line->new($pn,@H);
        
        $t2->down;
        $t2->math("E:F = F:G = G:H");
        $t2->math("E:F = A:B");
        $t2->math("E < A");
    };

    push @$steps, sub {
        $t1->explain("Since A,B,C,D are in the same ratio with E,F,G,H, ".
        "and the number of numbers in the ratios (4) is equal...");
        $t1->explain("... A is to D as E is to H (VII.14)");
        $t2->allgrey();
        $t2->black([-2,-3]);
        $t2->blue(0);
        $t2->math("A:D = E:H");
    };

    push @$steps, sub {
        $t1->explain("But A and D are relatively prime, thus they are ".
        "the least numbers to represent the ratio A:D\\{nb}(VII.21)");
        $t2->down;
        $t2->allgrey();
        $t2->blue(1);
        $t2->mathsmall("T={(x,y)|x,y\\{elementof}\\{natural}, x:y=A:D}");
        $t2->mathsmall("(A,D)\\{elementof}T such that A\\{lessthanorequal}x, ".
        "B\\{lessthanorequal}y \\{forall}(x,y)\\{elementof}T");
        $t2->down; 
    };

    push @$steps, sub {
        $t1->explain("Thus, since A,D are the smallest numbers to represent ".
        "the ratio A:D and E:H, A measures\\{nb}E, and ".
        "D measures\\{nb}H\\{nb}(VII.20)");
        $t2->allgrey();
        $t2->black([-1,-2,-3]);
        $t2->math("E = n\\{dot}A");
        $t2->math("H = m\\{dot}D");
    };

    push @$steps, sub {
        $t1->explain("Which is impossible if E is less than A");
        $t2->allgrey();
        $t2->red([4,-2]);
    };

    push @$steps, sub {
        $t1->explain("Thus there are no numbers smaller than A,B,C,D ".
        "which are of the same ratio");
        $t2->allgrey();
        $t2->blue([0,1]);
        $t2->down;
        $t2->mathsmall("S={(i,j,k,l)|i,j,k,l\\{elementof}\\{natural}, i:j=j:k=k:l=A:B}");
        $t2->mathsmall("(A,B,C,D)\\{elementof}S \nsuch that A\\{lessthanorequal}i, ".
        "B\\{lessthanorequal}j, C\\{lessthanorequal}k, D\\{lessthanorequal}l ".
        "\\{forall}(i,j,k,l)\\{elementof}S"); 
    };

    push @$steps, sub {
        $t2->blue([-1,-2]);
    };
    


    return $steps;

}

