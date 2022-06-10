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
my $t5 = $pn->text_box( 140, 150, -width=>1100 );
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 400, 400 );
my $t4 = $pn->text_box( 800, 660, -width=>500 );

my $unit = 10;
my $ds   = 30;

our ( %p, %c, %s, %t, %l );

my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If two numbers be prime to one another, and numbers fall between them ".
    "in continued proportion, then, however many numbers fall between ".
    "them in continued proportion, so many also fall between each of ".
    "them and a unit in continued proportion.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 9
);


# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my $E = 1;
    my $F = 2;
    my $G = 3;
    my ($A,$C,$D,$B) = Numbers->new($F,$G)->find_continued_proportion(4);
    my ($H,$K,$L) = Numbers->new($F,$G)->find_continued_proportion(3);
    my ($M,$N,$O,$P) = Numbers->new($F,$G)->find_continued_proportion(4);
    
    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @H = $line_coords->( -after => $B, -length => $H );
    our @C = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $C );
    our @K = $line_coords->( -after => $B, -length => $K );
    our @D = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $D );
    our @L = $line_coords->( -after => $B,-length => $L );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );

    our @E = $line_coords->( -xorig  => $dxs, -after => $E,-yskip => 1, -length => $E );
    our @M = $line_coords->( -after => $B,-length => $M );
    our @F = $line_coords->( -xorig  => $dxs, -yskip => 1,-after => $E, -length => $F );
    our @N = $line_coords->( -after => $B,-length => $N );
    our @G = $line_coords->( -xorig  => $dxs, -yskip => 1, -after => $E, -length => $G );
    our @O = $line_coords->( -after => $B,-length => $O );
    our @P = $line_coords->( -after => $B,-yskip=>1,-length => $P );

    my $steps;


    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given two numbers A,B, prime to one another, and the unit E" );
        $make_lines->(qw(A  B E ));
        $t2->math("gcd(A,B) = 1");
        $t2->math("E = 1");
        $t2->allblue;
    };


    push @$steps, sub {
        $t1->explain("If there 'n' numbers between A,B such that they ".
        "form a continuously proportional series, then ...");
        $make_lines->(qw(C D));
        $t2->math("A:C = C:D = D:B   ".
                "A:S\\{_1} = S\\{_1}:S\\{_2} ... = S\\{_m}\\{_-}\\{_1}:S\\{_m} ".
                "= S\\{_m}:B");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... there will be the same number of numbers 'm' between ".
        "1,A and 1,B such that they form a continuously proportional series");
        $t2->math("1:F = F:G = G:A   ".
                "1:a\\{_1} = a\\{_1}:a\\{_2} ... = a\\{_m}\\{_-}\\{_1}:a\\{_m} ".
                "= a\\{_m}:A");
        $t2->math("1:G = G:L = L:B   ".
                "1:b\\{_1} = b\\{_1}:b\\{_2} ... = b\\{_m}\\{_-}\\{_1}:b\\{_m} ".
                "= b\\{_m}:B");
    };

    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t2->erase;
        $t1->title("Aside:");
        $t1->explain("Remember that for a least proportional series, the ".
        "first and last (A,B) are an 'n-1' powers, where 'n' ".
        "is the length of the series, as shown in (VIII.2.Por)"); 
        $t2->down;
        $t2->math("if   S\\{_1} ... S\\{_n} are least of a proportional series");
        $t2->math("then S\\{_1} = p\\{^n-1},  S\\{_n} = q\\{^n-1}    ");
    };

    push @$steps, sub {
        $t1->explain("And the least numbers in a proportional series of "
        ."size n is of the form... (VIII.2.Por)");
        $t2->down;
        $t2->math("p\\{^n}\\{^-}\\{^1}, p\\{^n}\\{^-}\\{^2}q, ".
        "p\\{^n}\\{^-}\\{^3}q\\{^2} ... pq\\{^n}\\{^-}\\{^2}, q\\{^n}\\{^-}\\{^1}");
    };

    push @$steps, sub {
        $t1->title("In other words:");
        $t1->explain("Prove that there are as many ".
        "proportional numbers between 1 and p^n as there proportional ".
        "numbers between p^(n-1) and q^(n-1)");
        $t2->down;
        $t2->math("1,   p,    p\\{^2}    ... p\\{^n}\\{^-}\\{^2},  p\\{^n}\\{^-}\\{^1}");
        $t2->math("1,   q,    q\\{^2}    ... q\\{^n}\\{^-}\\{^2},  q\\{^n}\\{^-}\\{^1}");
    };



    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        
        $t1->title("Proof");
        $t2->erase;
        $t2->math("gcd(A,B) = 1");
        $t2->math("E = 1");
        $t2->math("A:C = C:D  = D:B");

        $t2->allblue;        
    };

 #   push @$steps, sub {
 #       $t1->explain("Since A,B are relatively prime, A,C,D,B are the least ".
 #       "numbers in that ratio (VIII.1)");
 #   };

    push @$steps, sub {
        $t1->explain("Find the least two numbers F,G which are in the same ".
        "ratio as A,C,D,B (VIII.2)");
        $make_lines->(qw(F G));
        $t2->allgrey;
        $t2->math("F:G = A:C:D:B");
    };

    push @$steps, sub {
        $t1->explain("Find the least three numbers H,K,L which are in the same ".
        "ratio as A,C,D,B (VIII.2), continuously increasing the length of ".
        "the series by one, until the length of the series matches the length ".
        "of the series A..B (VIII.2)");
        $make_lines->(qw(H K L));
        $make_lines->(qw(M N O P));
        $t2->math("H:K:L = F:G");
        $t2->math("M:N:O:P = F:G");
    };

    push @$steps, sub {
        $t1->explain("From (VIII.2.Por) we know that H is F squared, and M is ".
        "F multiplied by H");
        $t2->black([-1,-2,-3]);
        $t2->math("H = F\\{dot}F,  L = G\\{dot}G");
        $t2->math("M = F\\{dot}H,  P = G\\{dot}L");
    };

    push @$steps, sub {
        $t1->explain("Since A,C,D,B are the least numbers in the ratio F:G\\{nb}".
        "(VIII.1) and M,N,O,P are the least numbers as well, ".
        "A,C,D,B are equal to M,N,O,P");
        $t2->blue(0);
        $t2->grey([-1,4,6]);
        $t2->math("A = M,    B = P");
    };

    push @$steps, sub {
        $t1->explain("Now H is F squared, so F measures H ' f ' times (f being the ".
        "number of units in F)");
        $t2->allgrey;
        $t2->black(-3);
        $t3->math("H = fF");
    };

    push @$steps, sub {
        $t1->explain("And F is measured by E (a unit) ' f ' times");
        $t2->allgrey;
        $t2->blue(1);
        $t3->math("F = fE");
    };

    push @$steps, sub {
        $t1->explain("And thus, E is to F as F is to H (VII.Def.20)");
        $t2->allgrey;
        $t3->math("E:F = F:H");
    };

    push @$steps, sub {
        $t1->explain("Now M is F multiplied by H, so H measures M ' f ' times");
        $t2->allgrey;
        $t2->black(7);
        $t3->allgrey;
        $t3->math("M = fH");
    };

    push @$steps, sub {
        $t1->explain("And thus, E is to F as H is to M (VII.Def.20)");
        $t2->allgrey;
        $t3->allgrey;
        $t3->black([1,-1]);
        $t3->math("E:F = H:M");
    };

    push @$steps, sub {
        $t1->explain("Thus, E is to F as F is to H as H is to M");
        $t3->allgrey;
        $t3->black([2,4]);
        $t3->math("E:F = F:H = H:M");
    };

    push @$steps, sub {
        $t1->explain("But E is equal to 1, and M is equal to A, so ".
        "1 is to F as F is to H as H is to A");
        $t3->allgrey;
        $t3->black(-1);
        $t2->black([8]);
        $t2->blue(1);
        $t3->math("1:F = F:H = H:A");
    };

    push @$steps, sub {
        $t1->explain("And the length of the series 1 to A is the same ".
        "length of the series A to B");
    };

    push @$steps, sub {
        $t1->explain("Similarly, we can show that 1 is to G as G is to L ".
        "as L is to B");
        $t3->allgrey;
        $t2->allgrey;
        $t3->math("1:G = G:L = L:B");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t3->allgrey;
        $t3->math("len(1,F,H,A) = len(A,C,D,B)");
        $t3->math("len(1,G,L,B) = len(A,C,D,B)");
        $t3->black([-1,-2,-3,-4]);
        $t2->blue([2]);
    };

    push @$steps, sub {
        $t2->allgrey;
        $t3->allgrey;
        $t3->blue([-1,-2]);
        $t2->blue([0,2]);
    };

    return $steps;

}

