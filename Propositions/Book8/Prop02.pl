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
my $t4 = $pn->text_box( 480, 160 );

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "To find numbers in continued proportion, as many as may be prescribed, ".
    "and the least that are in a given ratio";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 2
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my ( %p, %c, %s, %t, %l );
    my $ds  = 30;
    my $dxs  = 100;
    my $dys = 200;
    my $unit = 7;
    
    my $A = 2;
    my $B = 3;
    my $C = $A*$A;
    my $D = $A*$B;
    my $E = $B*$B;
    my $F = $A*$A*$A;
    my $G = $B*$A*$A;
    my $H = $A*$B*$B;
    my $K = $B*$B*$B;
    
    my @A   = ($dxs,$dys,$dxs+$A*$unit,$dys);
    $dys = $dys + $ds;
    my @B   = ($dxs,$dys,$dxs+$B*$unit,$dys);
    $dys = $dys + 2*$ds;
    my @C   = ($dxs,$dys,$dxs+$C*$unit,$dys);
    $dys = $dys + $ds;
    my @D   = ($dxs,$dys,$dxs+$D*$unit,$dys);
    $dys = $dys + $ds;
    my @E   = ($dxs,$dys,$dxs+$E*$unit,$dys);
    $dys = $dys + 2*$ds;
    my @F   = ($dxs,$dys,$dxs+$F*$unit,$dys);
    $dys = $dys + $ds;
    my @G   = ($dxs,$dys,$dxs+$G*$unit,$dys);
    $dys = $dys + $ds;
    my @H   = ($dxs,$dys,$dxs+$H*$unit,$dys);
    $dys = $dys + $ds;
    my @K   = ($dxs,$dys,$dxs+$K*$unit,$dys);
    $dys = $dys + $ds;

    my $steps;
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "Given a ratio of A:B, where A,B are the least numbers "
        ."of that ratio" );
       
        $p{A} = Point->new( $pn, @A[0,1])->label( "A", "left" );
        $p{B} = Point->new( $pn, @B[0,1] )->label( "B", "left" );
        $l{A} = Line->new($pn,@A);
        $l{B} = Line->new($pn,@B);
        
        $t2->mathsmall("T={(x,y)|x,y\\{elementof}\\{natural}, x:y=A:B}");
        $t2->mathsmall("(A,B)\\{elementof}T such that A\\{lessthanorequal}x, ".
        "B\\{lessthanorequal}y \\{forall}(x,y)\\{elementof}T");
    };

    push @$steps, sub {
        $t1->explain( "Find a set of numbers (four in this example) "
        ."where F is to G is as G is to H as H is to K, where ".
        "F,G,H are the least numbers of the ratio A to B" );
       
        $p{F} = Point->new( $pn, @F[0,1])->label( "F", "left" );
        $p{G} = Point->new( $pn, @G[0,1] )->label( "G", "left" );
        $l{F} = Line->new($pn,@F);
        $l{G} = Line->new($pn,@G);
        $p{H} = Point->new( $pn, @H[0,1])->label( "H", "left" );
        $p{K} = Point->new( $pn, @K[0,1] )->label( "K", "left" );
        $l{H} = Line->new($pn,@H);
        $l{K} = Line->new($pn,@K);

        $t2->down();
        $t2->mathsmall("S={(i,j,k,l)|i,j,k,l\\{elementof}\\{natural}, i:j=j:k=k:l=A:B}");
        $t2->mathsmall("(F,G,H,K)\\{elementof}S \nsuch that F\\{lessthanorequal}i, ".
        "G\\{lessthanorequal}j, H\\{lessthanorequal}k, K\\{lessthanorequal}l ".
        "\\{forall}(i,j,k,l)\\{elementof}S"); 
        
    };

    push @$steps, sub {
        $t2->down;
        $t2->explain("Example:");
        $t2->math("A:B = 2:3");
        $t2->math("F:G = 8:12, G:H = 12:18, H:K = 18:27");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Construction");

        foreach my $c (qw(F G H K)) {
            $p{$c}->remove;
            $l{$c}->remove;
        }
        $t2->erase;
        $t2->mathsmall("T={(x,y)|x,y\\{elementof}\\{natural}, x:y=A:B}");
        $t2->mathsmall("(A,B)\\{elementof}T such that A\\{lessthanorequal}x, ".
        "B\\{lessthanorequal}y \\{forall}(x,y)\\{elementof}T");
        $t2->allblue();
    };

    push @$steps, sub {
        $t2->down;
        $t1->explain("Create three new numbers C,D,E, where C is A times ".
        "A, D is B times A, and E is B times B");

        $p{C} = Point->new( $pn, @C[0,1])->label( "C", "left" );
        $p{D} = Point->new( $pn, @D[0,1] )->label( "D", "left" );
        $l{C} = Line->new($pn,@C);
        $l{D} = Line->new($pn,@D);
        $p{E} = Point->new( $pn, @E[0,1])->label( "E", "left" );
        $l{E} = Line->new($pn,@E);

        $t4->y($t2->y);
        $t2->math("C = AA = A\\{^2}");
        $t2->math("D = AB");
        $t2->math("E = BB = B\\{^2}");
    };

    push @$steps, sub {
        $t1->explain("Create four new numbers where F is C times A, G is D ".
        "times A, H is D times A, and K is B times E");

        foreach my $c (qw(F G H K)) {
            $p{$c}->draw;
            $l{$c}->draw;
        }

        $t2->down;
        $t2->math("F = AC = A\\{^3}");
        $t2->math("G = AD = A\\{^2}B");
        $t2->math("H = AE = AB\\{^2}");
        $t2->math("K = BE = B\\{^3}");
        
    };
    
    push @$steps, sub {
        $t1->explain("And thus F,G,H,K are the least numbers in continuous ".
        "proportion to the ratio A to B");
        $t2->down;
        $tp->y($t2->y);
        $tp->mathsmall("S={(i,j,k,l)|i,j,k,l\\{elementof}\\{natural}, i:j=j:k=k:l=A:B}");
        $tp->mathsmall("(F,G,H,K)\\{elementof}S \nsuch that F\\{lessthanorequal}i, ".
        "G\\{lessthanorequal}j, H\\{lessthanorequal}k, K\\{lessthanorequal}l ".
        "\\{forall}(i,j,k,l)\\{elementof}S"); 
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof");

        $tp->erase;
        $t2->allblue();
     };
    
    push @$steps, sub {
        $t1->explain("Since C and D are A multiplied by A and B respectively, ".
        "C is to D as A is to B (VII.17)");
        $t2->allgrey;
        $t2->blue([2,3]);
        $t4->math("C:D = AA:AB = A:B");
    };
    push @$steps, sub {
        $t1->explain("Since D and E are A and B multiplied by B, ".
        "D is to E as A is to\\{nb}B\\{nb}(VII.18)");
        $t2->allgrey;
        $t2->blue([3,4]);
        $t4->allgrey;
        $t4->math("D:E = AB:BB = A:B");
    };
    push @$steps, sub {
        $t2->allgrey;
        $t4->allblack();
        $t4->math("C:D = D:E");
    };
    push @$steps, sub {
        $t1->explain("Since F and G are A multiplied by C and D respectively, ".
        "F is to G as C is to D (VII.17)");
        $t4->down;
        my $y = $t4->y;
        $t4->allgrey;
        $t2->blue([5,6]);
        $t4->math("F:G = AC:AD = C:D");
        $t4->y($y);
    };
    push @$steps, sub {
        $t1->explain("And C to D is equal to A to B, so F to G is equal to A to B");
        $t4->math("                  = A:B");
    };
    push @$steps, sub {
        $t1->explain("Since G and H are A multiplied by D and E respectively, ".
        "F is to G as C is to D (VII.17)");
        my $y = $t4->y;
        $t4->allgrey;
        $t2->allgrey;
        $t2->blue([6,7]);
        $t4->math("G:H = AD:AE = D:E");
        $t4->y($y);
    };
    push @$steps, sub {
        $t1->explain("And D to E is equal to A to B, so G to H is equal to A to B");
        $t4->math("                  = A:B");
    };
     push @$steps, sub {
        $t1->explain("Since H and K are A and B multiplied by E, ".
        "H is to K as A is to\\{nb}B\\{nb}(VII.18)");
        my $y = $t4->y;
        $t2->allgrey;
        $t2->blue([7,8]);
        $t4->allgrey;
        $t4->math("H:K = EB:EB = A:B");
     };
     push @$steps, sub {
         $t1->explain("Therefore, as F is to G, G is to H, and H is to K, where ".
         "all are as A is to B");
         $t2->allgrey;
         $t4->allgrey;
         $t4->black([-1,-2,-3,-4,-5]);
         $t4->math("F:G = G:H = H:K = A:B");
     };
     push @$steps, sub {
        $t1->down;
        $t1->explain("Since A,B are the least numbers with that ratio, A,B ".
        "are relatively prime (VII.22)");
        $t2->blue([0,1]);
        $t4->allgrey;
        $t2->math("gcd(A,B) = 1");
     };
     push @$steps, sub {
         $t1->explain("C and E are the squares of A and B respectively, ".
         "and are thus also relatively prime (VII.27)");
        $t2->allgrey;
        $t2->blue([2,4,]);
        $t2->black([9]);
        $t2->math("gcd(C,E) = 1");
    };
     push @$steps, sub {
         $t1->explain("F and K are the cubes of A and B respectively, ".
         "and are thus also relatively prime (VII.27)");
        $t2->allgrey;
        $t2->blue([5,8,]);
        $t2->black([9]);
        $t2->math("gcd(F,K) = 1");
    };
     push @$steps, sub {
        $t1->explain("If there be as many numbers as we please in continued ".
        "proportion, and the extrems are relatively prime, then they are the ".
        "least numbers in that ratio (VIII.1)");
        $t2->allgrey;
        $t2->black([-1]);
        $t4->black(-1);
        $t2->mathsmall("S={(i,j,k,l)|i,j,k,l\\{elementof}\\{natural}, i:j=j:k=k:l=A:B}");
        $t2->mathsmall("(F,G,H,K)\\{elementof}S \nsuch that F\\{lessthanorequal}i, ".
        "G\\{lessthanorequal}j, H\\{lessthanorequal}k, K\\{lessthanorequal}l ".
        "\\{forall}(i,j,k,l)\\{elementof}S"); 
    };
     push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0,1,-1,-2]);
        $t4->blue([-1]);
    };

    # -------------------------------------------------------------------------
    # Porism
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Porism");
        $t1->explain("If three numbers in continued proportion be the least ".
        "of those which have the same ratio with them, the extremes of them ".
        "are squares, and, if four numbers, cubes.");
        $t2->blue([2,4,5,8]);
        $t4->blue([2]); 
     };

    


    return $steps;

}

