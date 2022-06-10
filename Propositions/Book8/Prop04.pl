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
my $t2 = $pn->text_box( 140, 340 );
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 400, 160 );
my $t4 = $pn->text_box( 455, 540 );

my $ds   = 30;
my $unit = 7;

our ( %p, %c, %s, %t, %l );

use Geometry::Shortcuts;
my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);


# ============================================================================
# Definitions
# ============================================================================
my $title =
    "Given as many ratios as we please in least numbers, to find numbers in "
  . "continued proportion which are the least in the given ratios";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 4
);



# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my $A        = 2;
    my $B        = 3;
    my $C        = 5;
    my $D        = 7;
    my $E        = 3;                               # 11;
    my $F        = 4;                               # 13;
    my $G        = Numbers->new( $B, $C )->lcm();
    my $H        = $G / $B * $A;
    my $K        = $G / $C * $D;
    my $L        = $K / $E * $F;
    my $N        = 0.75 * $H;
    my $O        = 0.75 * $G;
    my $M        = 0.75 * $K;
    my $P        = 0.75 * $L;

    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -after=>$C, -length => $B );
    our @C = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $C );
    our @D = $line_coords->( -after=>$C, -length => $D );
    our @E = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $E );
    our @F = $line_coords->( -after =>$C, -length => $F );
    our @H = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $H );
    our @G = $line_coords->( -length => $G );
    our @K = $line_coords->( -length => $K );
    our @L = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $L );
    my @xy = $current_xy->();
    our @N = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $N );
    our @O = $line_coords->( -after=>$H, -length => $O );
    our @M = $line_coords->( -after=>[$G,$H], -length => $M );
    our @P = $line_coords->( -after=>[$G,$H,$K],-length => $P );

    my $M1 = Numbers->new( $E,$K )->lcm();
    my $N1 = int($M1/$K)*$H;
    my $O1 = int($M1/$K)*$G;
    our $P1 = int($M/$E)*$F;

    our @M1 = $line_coords->(-xorig=>$dxs, -yorig => $xy[1], -length=>$M1);
    our @N1 = $line_coords->(-length=>$N1);
    our @O1 = $line_coords->(-length=>$O1);
    our @P1 = $line_coords->(-xorig=>$dxs, -yskip=>1, -length=>$P1);
    
    my $steps;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain(   "Given a series of ratios in least numbers, A to B, "
                      . "C to D, and E to F" );

        $make_lines->(qw(A B C D E F));

        $t2->math("A,B is least of A:B");
        $t2->math("C,D is least of C:D");
        $t2->math("E,F is least of E:F");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain( "Find a series of least numbers in continued proportion, "
            . "where the first two have the ratio A to B, where the second and third "
            . "have the ratio to C to D, etc" );
        $t2->down;
        $t2->math("Find the least numbers H,G,K,L such that");
        $t2->math("A:B = H:G");
        $t2->math("C:D = G:K");
        $t2->math("E:F = K:L");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Contruction");
        $t2->erase;
        $t2->math("A,B, C,D, E,F are least of A:B, C:D, E:F");
        $t2->allblue();
    };

    push @$steps, sub {
        $t1->explain("Let G be the lowest common multiple of B,C");
        $t2->allgrey;
        $t2->math("G = lcm(B,C) = nB = mC");
        $make_lines->(qw(G));
    };

    push @$steps, sub {
        $t1->explain("Let H be the same multiple of A as G is of B");
        $t2->math("H = nA");
        $make_lines->(qw(H));
    };

    push @$steps, sub {
        $t1->explain("Let K be the same multiple of D as G is of C");
        $make_lines->(qw(K));
        $t2->allgrey;
        $t2->black(1);
        $t2->math("K = mD");
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain("* Assume that E measures K");
        $t1->down;
        $t2->allgrey;
        $t2->math("K = pE");
    };

    push @$steps, sub {
        $t1->explain("Let L be the same multiple of F as K is of E");
        $t2->math("L = pF");
        $make_lines->("L");
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain(   "Then A is to B as H is to G, and C is to "
                      . "D as G is to K and E is to F as K is to L " );
        $t2->math("A:B = H:G");
        $t2->math("C:D = G:K");
        $t2->math("E:F = K:L");
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain("And H,G,K,L are the least numbers with these ratios");
        $t2->math("H,G,K,L are the least with the above ratios");
    };

    # -------------------------------------------------------------------------
    # Proof 1A
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof of Ratios");
        $t1->sidenote("Assume that E measures K");
        $t1->down;
        $t2->erase;
        $t2->math("A,B, C,D, E,F are least of A:B, C:D, E:F");  # 0
        $t2->allblue();
        $t2->math("G = lcm(B,C) = nB = mC");                    # 1
        $t2->math("H = nA");                                    # 2
        $t2->math("K = mD");                                    # 3
        $t2->math("K = pE");                                    # 4
        $t2->math("L = pF");                                    # 5
        $t2->allblue;

    };

    push @$steps, sub {
        $t1->explain(
                     "A measures H the same number of times that B measures G, "
                       . "therefore A is to B as H is to G (VII.13)" );
        $t2->allgrey;
        $t2->blue( [ 1, 2 ] );
        $t2->math("A:B = H:G");                                 # 6
    };

    push @$steps, sub {
        $t1->explain(
                     "C measures G the same number of times that D measures K, "
                       . "therefore C is to D as G is to K (VII.13)" );
        $t2->allgrey;
        $t2->blue( [ 1, 3 ] );
        $t2->math("C:D = G:K");                                 # 7
    };

    push @$steps, sub {
        $t1->explain("Similarly, E is to F as K is to L (VII.13)");
        $t2->allgrey;
        $t2->blue( [ 4, 5 ] );
        $t2->math("E:F = K:L");                                 # 8
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue(0);
        $t2->blue( [ -1, -2, -3 ] );       
    };

    # -------------------------------------------------------------------------
    # Proof 1B
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof of Least Ratios");
        $t1->sidenote("Assume that E measures K");
        $t1->down;
        $t2->erase;
        $t2->math("A,B, C,D, E,F are least of A:B, C:D, E:F");  # 0
        $t2->math("G = lcm(B,C) = nB = mC");                    # 1
        $t2->math("H = nA");                                    # 2
        $t2->math("K = mD");                                    # 3
        $t2->math("K = pE");                                    # 4
        $t2->math("L = pF");                                    # 5
        my $y = $t2->y;
        $t2->math("H:G = A:B, ");                               # 6
        $t2->y($y);
        $t2->math("           G:K = C:D,");                     # 7
        $t2->y($y);
        $t2->math("                      K:L = E:F");           # 8
        $t2->allblue();
    };

    push @$steps, sub {
        $t1->explain(   "Assume H,G,K,L are not the least numbers, but instead "
                      . "N,O,M,P" );
        $t2->allgrey;
        my $y = $t2->y;
        $t2->math("H,G,K,L > N,O,M,P");                         # 9
        $t2->y($y);
        $t2->math("                   and ");                   # 10
        $t2->y($y);
        $t2->math("                       A:B=N:O");            # 11
        $t2->y($y);
        $t2->math("                                C:D=O:M");   # 12
        $t2->y($y);
        $t2->math("                                         E:F=M:P");  # 13
        $make_lines->(qw(N O M P));
    };

    push @$steps, sub {
        $t1->explain(
                    "Since A is to B as N is to O, and A:B is the least ratio, "
                      . "then N,O is measured by A,B\\{nb}(VII.20)" );
        $t2->allgrey;
        $t2->black(-3);
        $t2->math("O = iB");                                    # 14
    };

    push @$steps, sub {
        $t1->explain("For the same reason, O is measured by C");
        $t2->allgrey;
        $t2->black(-3);
        $t2->math("O = jC");                                    # 15
    };

    push @$steps, sub {
        $t1->explain(   "If B,C measure O, then the least common multiple will "
                      . "also measure O (VII.35)" );
        $t2->allgrey;
        $t2->black( [ -1, -2 ] );                               # 16
        $t2->math("O = k\\{dot}lcm(B,C)");                      # 17
    };

    push @$steps, sub {
        $t1->explain(   "G is the lowest common multiple of B,C, therefore "
                      . "G measures\\{nb}O" );
        $t2->allgrey;
        $t2->blue( [ 1 ] );
        $t2->black(-1);
        $t2->math("O = kG");                                    # 18
    };

    push @$steps, sub {
        $t1->explain(   "But G cannot simultaneously measure O and be greater "
                      . "than\\{nb}O, therefore we have a contradiction" );
        $t2->allgrey;
        $t2->red( [ -1, -9 ] );
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain("Thus, H,G,K,L are the least numbers for this ratio");
        $t2->allgrey;
        $t2->math("H,G,K,L are the least");
        $t2->blue([0,6,7,8,-1]);
    };

    # -------------------------------------------------------------------------
    # Construction 2
    # -------------------------------------------------------------------------
    push @$steps, sub {
        foreach my $c (qw(L M N O P)) {
            $l{$c}->remove;
        }
        $t1->erase();
        $t1->title("Contruction");
        $t2->erase;
        $t2->math("A,B, C,D, E,F are least of A:B, C:D, E:F");
        $t2->allblue();
        $t1->explain("Let G be the lowest common multiple of B,C");
        $t2->math("G = lcm(B,C) = nB = mC");
        $t1->explain("Let H be the same multiple of A as G is of B");
        $t2->math("H = nA");
        $t1->explain("Let K be the same multiple of D as G is of C");
        $t2->math("K = mD");
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain("* Assume that E does not measures K");
        $t1->down;
        $t2->allgrey;
    };

    push @$steps, sub {
        $t1->explain("Let M be the least common multiple of E,K");
        my $y = $t2->y;
        $t2->math("M ");  # 4
        $t2->y($y);
        $t2->math("  = lcm(E,K)");  # 5
        $t2->y($y);
        $t2->math("             = aE    "); #6
        $t2->y($y);
        $t2->math("                  = bK"); #7
        $make_lines->("M1");
    };

    push @$steps, sub {
        $t1->explain("Let N,O be the same multiple of H,G as M is of K");
        $t2->allgrey;
        $t2->black([4,7]);
        $t2->math("N = bH");
        $make_lines->("N1");
    };
    push @$steps, sub {
        $t2->allgrey;
        $t2->black([4,7]);
        $t2->math("O = bG");
        $make_lines->("O1");
    };

    push @$steps, sub {
        $t1->explain("Let P be the same multiple of F as M is of E");
        $t2->allgrey;
        $t2->black([4,6]);
        $t2->math("P = aF");
        $make_lines->("P1");
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain(   "Then A is to B as N is to O, and C is to "
                      . "D as O is to M and E is to F as M is to P " );
        $t2->math("A:B = N:O");
        $t2->math("C:D = O:M");
        $t2->math("E:F = M:P");
    };

    push @$steps, sub {
        $t1->down;
        $t2->allblack;
        $t2->blue(0);
        $t1->explain("And N,M,O,P are the least numbers with these ratios");
        $t2->math("N,M,O,P are the least with the above ratios");
    };
    
    # -------------------------------------------------------------------------
    # Proof 2A
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof of Ratios");
        $t1->sidenote("Assume that E does not measures K");
        $t1->down;
        $t2->erase;
        $t2->math("A,B, C,D, E,F are least of A:B, C:D, E:F");
        $t2->allblue();
        $t2->math("G = lcm(B,C) = nB = mC");
        $t2->math("H = nA");
        $t2->math("K = mD");
        my $y = $t2->y;
        $t2->math("M ");                        # 4
        $t2->y($y);
        $t2->math("  = lcm(E,K)");              # 5
        $t2->y($y);
        $t2->math("             = aE    ");     # 6
        $t2->y($y);
        $t2->math("                  = bK");    # 7
        $t2->math("N = bH");                    # 8
        $t2->math("O = bG");                    # 9
        $t2->math("P = aF");                    # 10
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("Since H measures N the same number of times that ".
        "G measures O, therefore, as H is to G, so is N to O (VII.13) ".
        "and (def.20)");
        $t2->allgrey;
        $t2->blue([-3,-2]);
        $t2->math("H:G = N:O");
    };

    push @$steps, sub {
        $t1->explain("But as H is to G, so is A to B, there A to B is as N to O");
        $t2->allgrey;
        $t2->blue([1,2]);
        $t2->black([-1]);
        $t2->math("A:B = N:O");
    };

    push @$steps, sub {
        $t1->explain("For the same reason also, as G is to K so is O to M");
        $t2->allgrey;
        $t2->blue([4,7,9]);
        $t2->math("G:K = O:M");
    };

    push @$steps, sub {
        $t1->explain("As O is to M so is C to D");
        $t2->allgrey;
        $t2->black([-1]);
        $t2->blue([1,3]);
        $t2->math("C:D = O:M");
    };
    
    push @$steps, sub {
        $t1->explain ("Since E measures M the same number ".
        "of times that F measures P, E is to F as M is to P (VII.13)");
        $t2->allgrey;
        $t2->blue([4,6,10]);
        $t2->math("E:F = M:P");
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t2->blue(0);
        $t2->blue([-1,-2,-4]);
    };

    # -------------------------------------------------------------------------
    # Proof 2B
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof of Least Ratios");
        $t1->sidenote("Assume that E does not measures K");
        $t1->down;
        $t2->erase;
        $t2->math("A,B, C,D, E,F are least of A:B, C:D, E:F");  # 0
        $t2->allblue();
        $t2->math("G = lcm(B,C) = nB = mC");                    # 1
        $t2->math("K = mD");                                    # 2
        $t2->math("M = lcm(E,K)");                              # 3
        my $y = $t2->y;
        $t2->math("N:O = A:B, ");                               # 4
        $t2->y($y);
        $t2->math("           O:M = C:D,");                     # 5
        $t2->y($y);
        $t2->math("                      M:P = E:F");           # 6
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain(   "Assume N,O,M,P are not the least numbers, but instead "
                      . "Q,R,S,T" );
        $t2->allgrey;
        my $y = $t2->y;
        $t2->math("N,O,M,P > Q,R,S,T");                         # 7
        $t2->y($y);
        $t2->math("                   and ");                   # 8
        $t2->y($y);
        $t2->math("                       A:B=Q:R");            # 9
        $t2->y($y);
        $t2->math("                                C:D=R:S");   # 10
        $t2->y($y);
        $t2->math("                                         E:F=S:T");  # 11
    };

    push @$steps, sub {
        $t1->explain("Since Q is to R as A is to B, and A,B are least of ".
        "the ratio A:B, A,B measure Q,R (VII.20)");
        $t2->allgrey;
        $t2->blue([-3]);
        $t2->math("R = iB");                                    # 12
    };

    push @$steps, sub {
        $t1->explain("For the same reason, R is measured by C");
        $t2->allgrey;
        $t2->blue([-3]);
        $t2->math("R = jC");                                    # 13
    };
    
    push @$steps, sub {
        $t1->explain(   "If B,C measure R, then the least common multiple will "
                      . "also measure R (VII.35)" );
        $t2->allgrey;
        $t2->black( [ -1, -2 ] );
        $t2->math("R = k\\{dot}lcm(B,C)");                      # 14
    };

    push @$steps, sub {
        $t1->explain(   "G is the lowest common multiple of B,C, therefore "
                      . "G measures\\{nb}R" );
        $t2->allgrey;
        $t2->blue( [ 1 ] );
        $t2->black( [  -1 ] );
        $t2->math("R = k\\{dot}G");                             # 14
    };

    push @$steps, sub {
        $t1->explain("As G is to K so is C to D");
        $t2->allgrey;
        $t2->blue([1,2]);
        $t2->math("G:K = C:D");                                 # 15
    };
    
    push @$steps, sub {
        $t1->explain("By alternate ratios, as G is to R, so is K to S (VII.13)");
        $t2->allgrey;
        $t2->black([-1,-7]);
        $t2->math("G:R = K:S");                                 # 16
    };
    
    push @$steps, sub {
        $t1->explain("Since G measures R, K measures S");
        $t2->allgrey;
        $t2->black([-1,-3]);
        $t2->math("S = k\\{dot}K");                             # 17
    };
    
    push @$steps, sub {
        $t1->explain("But E also measures S, therefore E and K both measure S");
        $t2->allgrey;
        $t2->black([-1,-8]);
        $t4->math("S = m\\{dot}E");   # 18        
    };
    
    push @$steps, sub {
        $t1->explain("Therefore the least common multiple of ".
        "E,K will also measure S (VII.35)");
        $t4->math("S = l\\{dot}lcm(E,K)");                      # 19
    };
    
    push @$steps, sub {
        $t1->explain(   "M is the lowest common multiple of E,K, therefore "
                      . "M measures\\{nb}S" );
        $t2->allgrey;
        $t2->blue(3);
        $t4->allgrey;
        $t4->black( [ 1, -1 ] );
        $t4->math("S = l\\{dot}M");                             # 20
    };

    push @$steps, sub {
        $t1->explain(   "But M cannot simultaneously measure S and be greater "
                      . "than\\{nb}S, therefore we have a contradiction" );
        $t4->allgrey;
        $t2->allgrey;
        $t2->red(7);
        $t4->red( [ -1, -10 ] );
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain("Thus, N,O,M,P are the least numbers for this ratio");
        $t4->allgrey;
        $t2->allgrey;
        $t2->blue( [ 0..6 ] );
        $t4->math("N,O,M,P are the least");
        $t4->blue(-1);
    };














    # -------------------------------------------------------------------------
    # Example
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t2->erase();
        $t4->erase();   
        
        foreach my $c (keys %l) {
            $l{$c}->remove;
       }

        $t2->math("A,B, C,D, E,F are least of A:B, C:D, E:F");
        $t2->allblue();
        $t2->math("G = lcm(B,C) = nB = mC");
        $t2->math("H = nA");
        $t2->math("K = mD");
        $t2->math("K = pE");
        $t2->math("L = pF");



        $t1->title("Example");
        $t1->explain("Assume\\{^1}");
        $t1->point("a perfect ratio of salt to pepper, 2:3");
        $t1->point("a perfect ratio of pepper to garlic 2:5");
        $t1->point("and a perfect ratio of garlic to oregano 3:7");
        $t1->down;
        $t1->math("A:B=2:3, C:D=2:5, E:F=3:7");
        $t1->math("G = lcm(3,2) = 6 = 2B = 3C");
        $t1->math("H = 2A = 4");
        $t1->math("K = 3D = 15");
        $t1->math("K = 5E");
        $t1->math("L = 5F = 35");
        $t1->down;
        $t1->math("4:6:15:35");
        $t1->down;
        $t1->explain(   "Gives a 4:6:15:35 ratio of salt, pepper, "
                      . "garlic, oregano for a perfect spice blend" );
        $t1->down;
        $t1->sidenote(
               "\\{^1}Disclaimer: I made these numbers up... I am not a cook!");
    };

    return $steps;

}

