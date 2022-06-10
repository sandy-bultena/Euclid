#!/usr/bin/perl 
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;
use Geometry::Shortcuts ;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

my $t1 = $pn->text_box( 800, 150, -width => 500 );
#my $t2 = $pn->text_box( 140, 300 );
my $t2 = $pn->text_box( 140, 400 );
#my $t2 = $pn->text_box( 100, 400 );
my $t5 = $pn->text_box( 140, 150, -width=>1100 );
my $tp = $pn->text_box( 100, 550 );
my $t3 = $pn->text_box( 140, 150 );
my $t4 = $pn->text_box( 480, 400 );

my $unit = 10;
my $ds   = 30;

our ( %p, %c, %s, %t, %l );

my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "Between two similar solid numbers there fall two mean proportional numbers; ".
    "and the solid number has to the similar solid number the ratio triplicate of ".
    "that which the corresponding side has to the corresponding side.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 19
);


# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
 #   my $dys      = 200;
    my $fact = 1.0;
    my $C = 1/$fact;
    my $D = 2/$fact;
    my $E = 3/$fact;
    my $F = 2*$C;
    my $G = 2*$D;
    my $H = 2*$E;
    my $B = $F*$G*$H; # = 2 * $C * 2 * $D
    my $A = $C*$D*$E;
    my $K = $C*$D;
    my $L = $F*$G;
    my $M = $D*$F;
    
    my $N = $E*$M;
    my $O = $H*$M;

    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );

    our @C = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $C );
    our @F = $line_coords->( -after=>[$L], -length=>$F );
    our @N = $line_coords->( -after=>[$L,$H], -length=>$N );

    our @D = $line_coords->(  -xorig  => $dxs, -yskip => 1, -length => $D );
    our @G = $line_coords->( -after=>[$L], -length=>$G );
    our @O = $line_coords->( -after=>[$L,$H], -length=>$O );

    our @E = $line_coords->( -xorig  => $dxs, -yskip => 1,-length => $E );
    our @H = $line_coords->( -after=>[$L], -length=>$H );

    our @K = $line_coords->(  -xorig  => $dxs, -yskip => 1, -length => $K );
    our @L = $line_coords->(  -xorig  => $dxs, -yskip => 1, -length => $L );
    our @M = $line_coords->(  -xorig  => $dxs, -yskip => 1, -length => $M );

    my $steps;
    my $ypos;
    my $yA;
    my $yB;
    my $yK;
    my $yKM;

    # -------------------------------------------------------------------------
    # Definition
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t5->down;
        $t5->title("Definition: Solid numbers (VII.Def.16)");
        $t5->down;
        $t5->explain("When three numbers having multiplied one another make ".
        "some number, the number so produces is 'solid', and its sides are ".
        "the numbers which have multiplied one another");
        $t5->math("A\\{dot}B\\{dot}C = D");
        my $y = $t5->y;
        $t5->math("A,B,C");
        $t5->y($y);
        $t5->explain("                  are sides");
        $y = $t5->y;
        $t5->math("D");
        $t5->y($y);
        $t5->explain("                  is a 'solid' number");

        $t5->down;
        $t5->title("Definition: Similar Solid Numbers (VII.Def.21)");
        $t5->down;
        $t5->explain("'Similar plane' and 'solid' numbers are those which have "
        ."their sides proportional");
        $t5->math("If   A = C\\{dot}D\\{dot}E");
        $t5->math("and  B = F\\{dot}G\\{dot}H");
        $t5->math("and  C:D = F:G, D:E = G:H");       
        $t5->math("then A ~ B (A,B are similar)");
    };

    push @$steps, sub {
        $t3->erase;
        $t5->erase;
        $t3->down;
        $t3->title("Definition: Triplicate Ratio (V.Def.10)");
        $t3->down;
        $t3->explain("If A is to B as B is to C as C is to D, ".
        "\nthen the ratio of A to D is the ".
        "triplicate ratio of A to B");
        $t3->explain("(a special case of compound ratio)");
        $t3->down;
        $t3->math("A:B = B:C = C:D \\{then} A:D triplicate ratio of A:B");
        $t3->down;

        $t3->fancy("Example");
        $t3->math("A\\{^3}:A\\{^2}B = A\\{^2}B:AB\\{^2} = AB\\{^2}:B\\{^3}  (=A:B)");
        $t3->math("A\\{^3}:B\\{^3} is the triplicate ratio of A:B ");       
   };


    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t5->erase;
        $t3->erase;
        $t1->title("In other words");
        $t1->explain("If A,B be similar solid numbers, and C,D,E be the sides of A, "
        ."and F,G,H the sides of B, then...") ;
        $make_lines->(qw(A B C D E F G H));
        $t2->math("A = C\\{dot}D\\{dot}E");
        $t2->math("B = F\\{dot}G\\{dot}H");
        $t2->math("A ~ B, C:D = F:G, D:E = G:H");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... there is two mean proportionals between A and B, and ...");
        $t2->math("A:N = N:O = O:B");
    };

    push @$steps, sub {
        $t1->explain("... A to B is the triplicate ratio of C to E or D to F");
        $t2->math("A:B is triplicate of C:F, D,G and E:H");
        $t2->math("A:B = C\\{^3}:F\\{^3} = D\\{^3}:G\\{^3} = E\\{^3}:H\\{^3}");
    };

    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $yA = $t2->y;
        $t2->math("A = C\\{dot}D\\{dot}E");                         # 0
        $yB = $t2->y;
        $t2->math("B = F\\{dot}G\\{dot}H");                         # 1
        $ypos = $t2->y;
                       $t2->math("A ~ B");                          # 2
        $t2->y($ypos); $t2->math("     , ");                        # 3
        $t2->y($ypos); $t2->math("       C:D = F:G");               # 4
        $t2->y($ypos); $t2->math("                , ");             # 5
        $t2->y($ypos); $t2->math("                  D:E = G:H");    # 6       
        $t2->allblue;        
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Let K be C multiplied by D, and let L be F multiplied by G");
        $ypos = $t2->y;
        $t2->math("K = C\\{dot}D");                                 # 7
        $t2->y($ypos);
        $t2->math("           L = F\\{dot}G");                      # 8
        $make_lines->(qw(K L));
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since K,L are plane numbers where there sides are ".
        "proportional, they are similar plane numbers (VII.Def.21)");
        $t2->blue([4]);
        $t2->black([7,8]);
        $t2->y($ypos);
        $t2->math("                      K ~ L");                   # 9
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Therefore there is one mean proportional number".
        " 'M' between K,L\\{nb}(VIII.18), where M is F multiplied by D (VIII.18)");
        $make_lines->(qw(M));
        $ypos = $t2->y;
        $t2->blue([4]);
        $t2->black([7,8]);
        $t2->math("M = F\\{dot}D, K:M = M:L");                      # 10
        $t2->y($ypos);
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since M and K are both C,F multiplied by D,  K,M,L ".
        "are continuously proportional in the ratio of C to F (VII.17)");
        $t2->black([-1,7]);
        $t2->math("                    = C:F");                     # 11
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since C is to D as F is to G, alternately C ".
        "is to F as D is\\{nb}to\\{nb}G\\{nb}(VII.13)");
        $ypos = $t2->y;
        $t2->blue(4);
        $t2->math("C:F = D:G");                                     # 12
        $t2->y($ypos);
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue(6);
        $t1->explain("Similarly, D is to G as E is to H");
        $t2->math("         ,")->grey(-1);                          # 13
        $t2->y($ypos);
        $t2->math("           D:G = E:H");                          # 14
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("And since K,L,M is in continous proportion to C,F it ".
        "is also in continous proportion to D,G and E,H");
        $t2->black([10,11,12,13,14]);
        $yKM = $t2->y;
        $t2->math("K:M = M:L =");                                   # 15
        $t2->y($yKM);
        $t2->math("            C:F = D:G = E:H");                   # 16
    };

    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof (cont)");
        $t2->allgrey;
        $t1->explain("Let N,O be E,H multiplied by M");
        $ypos = $t2->y;
        $t2->math("N = E\\{dot}M");                                 # 17
        $t2->y($ypos);
        $t2->math("           O = H\\{dot}M");                      # 18
        $make_lines->(qw(N O));
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since A is the product of C,D,E, and K is ".
        "the product of C,D, A is also the product of E,K also ",
        "B is the product of H,L");
        $t2->blue([0,1]);
        $t2->black([7,8]);
        $t2->y($yA);
        $t2->math("           = E\\{dot}K");                        # 19
        $t2->y($yB);
        $t2->math("           = H\\{dot}L");                        # 20        
        $t2->y($ypos);
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since A,N is K,M multiplied by E, K is to M as A "
        ."is to\\{nb}N\\{nb}(VII.17)");
        $t2->blue(0);
        $t2->black([19,15,16]);
        $ypos = $t2->y;
        $t3->y($ypos);
        $t3->down;
        $t3->math("K:M = A:N");                                     # ...           
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->black([15,16]);
        $ypos = $t2->y;
        $t2->y($yKM);
        $t2->math("                            = A:N");             # 21
        $t2->y($ypos);
    };

    push @$steps, sub {
        $t3->erase;
        $t2->allgrey;
        $t1->explain("Again, since N,O are E,H multiplied by M, E is to ".
        "H as N is to\\{nb}O\\{nb}(VII.18)");
        $t2->black([15,16,18]);
        $t2->math("                    E:H = N:O");                 # 22        
    };

    push @$steps, sub {
        $t3->erase;
        $t2->allgrey;
        $t1->explain("But E is to H as C is to F, etc, so N is to O etc");
        $t2->black([15,16,22,21]);
        $ypos = $t2->y;
        $t2->y($yKM);
        $t2->math("                                  = N:O");       # 23
        $t2->y($ypos);
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue(1);
        $t2->black([20,18]);
        $t1->explain("B,O are L,M multiplied by H, so M is to L as O is to B (VII.17)");
        $t3->y($t2->y);
        $t3->math("M:L = O:B");                                     # ...
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("But M is to L as C is to F, etc, so O is to B as C is to F, etc");
        $t2->black([15,16,21,23]);
        $ypos = $t2->y;
        $t2->y($yKM);
        $t2->math("                                        = O:B");       # 24
    };

    push @$steps, sub {
        $t2->allgrey;
        $t3->erase;
        $t1->explain("Therefore A, N, O, and B are continuously proportional ".
        "in the ratios of their sides.");
        $t2->blue([0..6,16,21,23,24]);
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->down;
        $t2->down;
        $t1->down;
        $t1->explain("A to B is the triplicate ratio of A to N (V.Def.10)");
        $t2->math("A:B is triplicate of A:N");
        $t2->blue([21,23,24]);
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("But A is to N as C is to F, as D is to G, and as E is to H, "
        ."thus A to B is the triplicate of C to F, D to G, E to H");
        $t2->blue([16,21]);
        $t2->black(-1);
        $t2->math("A:B is triplicate of C:F, D:G, E:H");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0..6,16,21,23,24,-1]);

    };

    return $steps;

}

