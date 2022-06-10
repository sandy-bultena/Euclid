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
my $t2 = $pn->text_box( 140, 400 );
#my $t2 = $pn->text_box( 100, 400 );
my $t5 = $pn->text_box( 140, 150, -width=>1100 );
my $tp = $pn->text_box( 100, 550 );
my $t3 = $pn->text_box( 100, 150 );
my $t4 = $pn->text_box( 480, 400 );

my $unit = 5;
my $ds   = 30;

our ( %p, %c, %s, %t, %l );

my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If there be as many numbers as we please in continued proportion, ".
    "and each by multiplying itself make some number, the products will ".
    "be proportional, and, if the original numbers by multiplying the ".
    "products make certain numbers, the latter will also be proportional.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 13
);


# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my ($A,$B,$C) = Numbers->new(2,3)->find_continued_proportion(3);
    $A = $A/2;
    $B = $B/2;
    $C = $C/2;
    my $D = $A*$A;
    my $E = $B*$B;
    my $F = $C*$C;
    my $L = $A*$B;
    my $O = $B*$C;
    my $G = $A*$D;
    my $H = $B*$E;
    my $K = $C*$F;
    my $M = $A*$L;
    my $N = $B*$L;
    my $P = $B*$O;
    my $Q = $C*$O;
    #print "$A, $B, $C ... $D, $E, $F ... $G, $H, $K \n";
    
    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @G = $line_coords->( -after=>$F, -length => $G );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @H = $line_coords->( -after=>$F, -length => $H );
    our @C = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $C );
    our @K = $line_coords->( -after=>$F, -length => $K );

    our @D = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $D );
    our @E = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $E );
    our @M = $line_coords->( -after=>$F, -length => $M );
    our @F = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $F );
    our @N = $line_coords->( -after=>$F, -length => $N );
    our @L = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $L );
    our @P = $line_coords->( -after=>$F, -length => $P );
    our @O = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $O );
    our @Q = $line_coords->( -after=>$F, -length => $Q );


    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("If A,B,C are proportional, then ...") ;
        $make_lines->(qw(A B C ));
        $t2->math("A:B = B:C");
        $t4->math("S\\{_1}:S\\{_2} = S\\{_2}:S\\{_3} ... = ".
        "S\\{_n}\\{_-}\\{_1}:S\\{_n}");
        $t2->allblue;
        $t4->allblue;
    };

    push @$steps, sub {
        $t1->explain("... and if D,E,F are the squares of A,B,C ...");
        $make_lines->(qw(D E F ));
        $t2->math("D = A\\{^2}, E = B\\{^2}, F = C\\{^2}");
        $t4->math(" ");
        $t2->allblue;
        $t4->allblue;
    };

    push @$steps, sub {
        $t1->explain("... and if G,H,K are the cubes of A,B,C ...");
        $make_lines->(qw(G H K ));
        $t2->math("G = A\\{^3}, H = B\\{^3}, K = C\\{^3}");
        $t4->math(" ");
        $t2->allblue;
        $t4->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then D,E,F and G,H,K are proportional");
        $t2->math("D:E = E:F");
        $t2->math("G:H = H:K");
        $t4->math("S\\{_1}\\{^2}:S\\{_2}\\{^2} = S\\{_2}\\{^2}:S\\{_3}\\{^2} ... = ".
        "S\\{_n}\\{_-}\\{_1}\\{^2}:S\\{_n}\\{^2}");
        $t4->math("S\\{_1}\\{^3}:S\\{_2}\\{^3} = S\\{_2}\\{^3}:S\\{_3}\\{^3} ... = ".
        "S\\{_n}\\{_-}\\{_1}\\{^3}:S\\{_n}\\{^3}");
    };


    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t4->erase;
        $t2->math("A:B = B:C");
        #$t2->math("D = A\\{^2}, E = B\\{^2}, F = C\\{^2}");
        #$t2->math("G = A\\{^3}, H = B\\{^3}, K = C\\{^3}");
        $ypos = $t2->y;
        $t2->math("D = A\\{dot}A");
        $t2->math("E = B\\{dot}B");
        $t2->math("F = C\\{dot}C");
        $t2->y($ypos);
        $t2->math("          G = A\\{dot}A\\{dot}A");
        $t2->math("          H = B\\{dot}B\\{dot}B");
        $t2->math("          K = C\\{dot}C\\{dot}C");
        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Let L be A multiplied by B");
        $make_lines->(qw(L));
        $t2->allgrey;
        $ypos = $t2->y;
        $t2->math("L = A\\{dot}B");
    };

    push @$steps, sub {
        $t1->explain("Let M,N be L multiplied by A,B");
        $make_lines->(qw(M N));
        $t2->allgrey;
        $t2->y($ypos);
        $t2->math("          M = A\\{dot}A\\{dot}B");
        $t2->math("          N = B\\{dot}A\\{dot}B");        
    };
    
     push @$steps, sub {
        $t1->explain("Let O be B multiplied by C");
        $make_lines->(qw(O));
        $t2->allgrey;
        $ypos = $t2->y;
        $t2->math("O = B\\{dot}C");
    };
    
    push @$steps, sub {
        $t1->explain("Let P,Q be O multiplied by B,C");
        $make_lines->(qw(P Q));
        $t2->allgrey;
        $t2->y($ypos);
        $t2->math("          P = B\\{dot}B\\{dot}C");
        $t2->math("          Q = C\\{dot}B\\{dot}C");        
    };
    
    push @$steps, sub {
        $t1->explain("By using the same methods in previous propositions, ".
        "it can be seen that D,L,E is continuously proportional to A:B");
        $t2->allgrey;
        $t4->math("D:L = L:E = A:B");
        $t2->blue([1,2]);
        $t2->black(7);
    };
    
    push @$steps, sub {
        $t1->explain("Likewise, ".
        "it can be seen that G,M,N,H is continuously proportional to A:B");
        $t2->allgrey;
        $t4->allgrey;
        $t4->math("G:M = M:N = N:H = A:B");
        $t2->blue([4,5]);
        $t2->black([8,9]);
    };
    
    push @$steps, sub {
        $t1->explain("It can be seen that E,O,F is continuously proportional to B:C");
        $t2->allgrey;
        $t4->math("E:O = O:F = B:C");
        $t2->blue([2,3]);
        $t2->black(10);
    };
    
    push @$steps, sub {
        $t1->explain("It can be seen that H,P,Q,K is continuously proportional to B:C");
        $t2->allgrey;
        $t4->allgrey;
        $t4->math("H:P = P:Q = Q:K = B:C");
        $t2->blue([5,6]);
        $t2->black([11,12]);
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t1->explain("But A is to B as B is to C, therefore D,L,E are in ".
        "the same ratio as E,O,F");
        $t4->black([0,2]);
        $t2->blue(0);
        $t4->math("D:L:E = E:O:F");
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t1->explain("and G,M,N,H are the same ratio as H,P,Q,K");
        $t4->black([1,3]);
        $t2->blue(0);
        $t4->math("G:M:N:H = H:P:Q:K");
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t1->explain("And thus, ex aequali, D is to E as E is to F (VII.14)");
        $t4->black(4);
        $t4->math("D:E = E:F");        
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t1->explain("And G is to H as H is to K (VII.14)");        
        $t4->black(5);
        $t4->math("G:H = H:K");        
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t2->blue([0..6]);
        $t4->blue([-1,-2]);
    };
    
    

    return $steps;

}

