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
    "If numbers fall between each of two numbers and an unit in continued ".
    "proportion, however many numbers fall between each of them and an ".
    "unit in continued proportion, so many also will fall between the ".
    "numbers themselves in continued proportion.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 10
);


# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my $C = 1;
    my $D = 2;
    my $F = 3;
    my (undef,undef,$E,$A) = Numbers->new($C,$D)->find_continued_proportion(4);
    my (undef,undef,$G,$B) = Numbers->new($C,$F)->find_continued_proportion(4);
    my (undef,$K,$L,undef) = Numbers->new($D,$F)->find_continued_proportion(4);
    my $H = $D*$F;
    
    our @C = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $C );
    our @D = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $D );
    our @F = $line_coords->( -after => $A,-length => $F );
    our @E = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $E );
    our @G = $line_coords->( -after => $A,-length => $G );
    our @A = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $A );
    our @B = $line_coords->( -after => $A,-length => $B );
    
    our @H = $line_coords->( -xorig  => $dxs, -yskip=> 1, -length => $H );
    our @K = $line_coords->( -after=>$A, -length => $K );
    our @L = $line_coords->( -length => $L );


    my $steps;


    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("If there are 'n' numbers in continuous proportion ".
        "between 1 and A, and another between 1 and B, then ..." );
        $make_lines->(qw(A B C D E F G));
        
        $t2->math("C = 1");
        $t2->math("C:D = D:E = E:A");
        $t2->math("C:F = F:G = G:B");
        $tp->explain("Continuously proportional series...");
        $tp->math("1,   p,    p\\{^2}    ... p\\{^n}\\{^-}\\{^2},  p\\{^n}\\{^-}\\{^1}");
        $tp->math("1,   q,    q\\{^2}    ... q\\{^n}\\{^-}\\{^2},  q\\{^n}\\{^-}\\{^1}");
        $tp->allblue;
        $t2->allblue;
    };


    push @$steps, sub {
        $t1->explain("... there are 'n' numbers between A,B such that they, too, ".
        "form a continuously proportional series");
        $make_lines->(qw(K L));
        $t2->math("A:K = K:L = L:B   ");
        $tp->math("p\\{^n}\\{^-}\\{^1}, p\\{^n}\\{^-}\\{^2}q, ".
        "p\\{^n}\\{^-}\\{^3}q\\{^2} ... pq\\{^n}\\{^-}\\{^2}, q\\{^n}\\{^-}\\{^1}");
    };


    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $l{K}->remove;
        $l{L}->remove;
        $t1->title("Proof");
        $tp->erase;
        $t2->erase;
        $t2->math("C = 1");
        $t2->math("C:D = D:E = E:A");
        $t2->math("C:F = F:G = G:B");

        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Let H be F and D multiplied, let K be D and H multiplied, ".
        "and let L be F and H multiplied");
        $t2->math("H = D\\{dot}F = d\\{dot}F");
        $t2->math("K = D\\{dot}H = d\\{^2}\\{dot}F");
        $t2->math("L = H\\{dot}F = d\\{dot}F\\{^2}");        
        $make_lines->(qw(H K L));
    };

    push @$steps, sub {
        $t1->explain("C (the unit) measures D by 'd'");
        $t2->allgrey;
        $t2->blue([0]);;
        $t2->math("D = dC");
    };

    push @$steps, sub {
        $t1->explain("Since C is to D as D is to E, D measures E by 'd' ".
        "(VII.Def.20), or more succinctly E is D multiplied by D");
        $t2->blue([0,1]);;
        $t2->math("E = dD = D\\{dot}D");
    };

    push @$steps, sub {
        $t1->explain("Likewise, since C is to D as E is to A, A is D ".
        "multiplied by E");
        $t2->allgrey;
        $t2->black([6]);
        $t2->blue([0,1]);
        $t2->math("A = dE = D\\{dot}E");
    };

    push @$steps, sub {
        $t1->explain("Similarly, C is to F as F is to G and G is to B ".
        "so G is F multiplied by F, and B is G multiplied by F");
        $t2->allgrey;
        $t2->blue([0,2]);
        $t2->math("F = fC");
        $t2->math("G = fF = F\\{dot}F");
        $t2->math("B = fG = F\\{dot}G");
    };

    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof (cont)");
    };

    push @$steps, sub {
        $t1->explain("Since E is D multiplied by itself ".
        "and H is D multiplied by F, therefore D is to F as E is to H (VII.17)");
        $t2->allgrey;
        $t2->black([7,3]);
        $t3->math("D:F = E:H");
    };

    push @$steps, sub {
        $t1->explain("For the same reasons, D is to F as H is to G (VII.18)");
        $t2->allgrey;
        $t3->allgrey;
        $t2->black([3,10]);
        $t3->math("D:F = H:G");
    };

    push @$steps, sub {
        $t1->explain("Since A is D multiplied by E, and K is D ".
        "multiplied by H, therefore E is to H as A is to K (VII.17)");
        $t2->allgrey;
        $t3->allgrey;
        $t2->black([8,4]);
        $t3->math("E:H = A:K");
    };

    push @$steps, sub {
        $t1->explain("Since E is to H as D is to F and A is to K, ".
        "D to F is as A is to K");
        $t3->allgrey;
        $t2->allgrey;
        $t3->black([-1,-3]);
        $t3->math("D:F = A:K");
    };

    push @$steps, sub {
        $t1->explain("Since K is D multiplied by H and  ".
        " and L is F multiplied by H, D is to F as K is to L (VII.18)");
        $t3->allgrey;
        $t2->allgrey;
        $t2->black([4,5]);
        $t3->math("D:F = K:L");
    };

    push @$steps, sub {
        $t1->explain("But D is to F as A is to K, therefore A is to K as K is to L");
        $t3->allgrey;
        $t2->allgrey;
        $t3->black([-1,-2]);
        $t3->math("A:K = K:L");
    };

    push @$steps, sub {
        $t1->explain("Since L and B are H and G multiplied by F respectively, ".
        "H is to G as L is to B (VII.17)");
        $t2->black([5,11]);
        $t3->allgrey;
        $t3->math("H:G = L:B");
    };

    push @$steps, sub {
        $t1->explain("But H to G is also equal to D to F, therefore D to F ".
        "is as L to B");
        $t3->allgrey;
        $t2->allgrey;
        $t3->black([-1,1]);
        $t3->math("D:F = L:B");
    };

    push @$steps, sub {
        $t1->explain("But D is to F as A is to K and K is to L, therefore, ".
        "A is to K as K is to L and L is to B");
        $t3->allgrey;
        $t3->black([3,4,7]);
        $t3->math("A:K = K:L = L:B");
    };

    push @$steps, sub {
        $t1->explain("Thus A,K,L,B are in continuous proportion, and the ".
        "length of the series is equal to the length of the series from ".
        "1 to A and the series 1 to B");
        $t3->allgrey;
        $t2->allgrey;
        $t2->blue([0..2]);
        $t3->blue(-1);
    };
    
    
    

    return $steps;

}

