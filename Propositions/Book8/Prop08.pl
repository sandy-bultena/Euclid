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

my $unit = 3;
my $ds   = 30;

our ( %p, %c, %s, %t, %l );

my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If between two numbers there fall numbers in continued proportion with ".
    "them, then, however many numbers fall between them in continued ".
    "proportion, so many will also fall in continued proportion between ".
    "the numbers which have the same ratio with the original numbers.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 8
);


# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my ($G,$H,$K,$L) = Numbers->new(2,3)->find_continued_proportion(4);
    
    my $A = 2*$G;
    my $B = 2*$L;
    my $C = 2*$H;
    my $D = 2*$K;
    my $E = 3*$G;
    my $F = 3*$L;
    my $M = 3*$H;
    my $N = 3*$K;
    
    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @E = $line_coords->( -after => $B, -length => $E );
    our @C = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $C );
    our @M = $line_coords->( -after => $B,, -length => $M );
    our @D = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $D );
    our @N = $line_coords->( -after => $B,-length => $N );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @F = $line_coords->( -after => $B,-length => $F );
    
    our @G = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $G );
    our @H = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $H );
    our @K = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $K );
    our @L = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $L );

    my $steps;


    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given two numbers A,B, and two numbers E,F in the same ".
        "ratio as A,B" );
        $make_lines->(qw(A B E F ));
        
        $t2->math("A:B = E:F");
        $t2->blue;
    };


    push @$steps, sub {
        $t1->explain("Then if there 'n' numbers between A,B such that they ".
        "form a continuously proportional series, then ...");
        $make_lines->(qw(C D));
        $l{C}->colour($blue);
        $l{D}->colour($blue);
        $t2->math("A:C = C:D = D:B     ".
                "A:S\\{_1} = S\\{_1}:S\\{_2} ... S\\{_n}\\{_-}\\{_1}:S\\{_n} ".
                "= S\\{_n}:B");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... there will be the same number of numbers 'n' between ".
        "E and F such that they form a continuously proportional series");
        $make_lines->(qw(M N));
        $l{M}->colour($blue);
        $l{N}->colour($blue);
        $t2->math("E:M = M:N = N:F     ".
                "E:T\\{_1} = T\\{_1}:T\\{_2} ... T\\{_n}\\{_-}\\{_1}:T\\{_n} ".
                "= T\\{_n}:F");
    };


    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof");
        $t2->erase;
        $t2->math("A:B = E:F");
        $t2->math("A:C = C:D = D:B");
        $l{M}->remove;
        $l{N}->remove;

        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Find a series G,H,K,L, equal in length to A,B,C,D where ".
        "G,H,K,L are the least that have the same ratio as A,C,D,B (VII.33)");
        $make_lines->(qw(G H K L));
        $t2->math("G:H:K:L = A:C:D:B");
        $t2->math("G:H = H:K = K:L");
        $t2->math("G:H:K:L are least");        
    };

    push @$steps, sub {
        $t1->explain("Since G,H,K,L are least, and in continuous proportion, ".
        "G,L are relatively prime\\{nb}(VIII.3)");
        $t2->allgrey;
        $t2->black([-1,-2]);
        $t2->math("gcd(G,L) = 1");
    };

    push @$steps, sub {
        $t1->explain("A,C,D,B has the same sequence length, and same ratio as ".
        "G,H,K,L, thus ex aequali, A is to B as G is to L (VII.14)");
        $t2->allgrey;
        $t2->black(2);
        $t2->math("A:B = G:L");
    };

    push @$steps, sub {
        $t1->explain("But A to B is equal to E to F, so E to F is equal to G to L");
        $t2->allgrey;
        $t2->blue(0);
        $t2->black(-1);
        $t2->math("E:F = G:L");
    };

    push @$steps, sub {
        $t1->explain("G and L are relatively prime, which means that G,L are the ".
        "least numbers in that ratio (VII.21)");
        $t2->allgrey;
        $t2->black([-3]);
    };

    push @$steps, sub {
        $t1->explain("Least numbers measure any numbers in the same ratio, by the ".
        "same proportion (VII.20), thus G measures E the same number of times ".
        "that L measures F");
        $t2->allgrey;
        $l{parts} = [];
        push $l{parts}, $l{E}->parts($E/$G,undef,undef,$pink);
        push $l{parts}, $l{F}->parts($F/$L,undef,undef,$pink);
        $t2->black([-1,-3]);
        $t2->math("E = pG, F = pL");
    };

    push @$steps, sub {
        $l{N}->draw;
        $l{M}->draw;
        push $l{parts}, $l{N}->parts($N/$K,undef,undef,$pink);
        push $l{parts}, $l{M}->parts($M/$H,undef,undef,$pink);
        $t1->explain("Let H measure M and K measure N the same number of times ".
        "as G measures E");
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("M = pH, N = pK");
    };

    push @$steps, sub {
        $t1->explain("G,H,K,L is in the same proportion as ".
        "E,M,N,K (VII.Def.20)");
        $t3->math("G:H:K:L = E:M:N:F"); 
    };

    push @$steps, sub {
        $t1->explain("But G,H,K,L are in the same proportion as A,C,D,B, "
        ."therefore A,C,D,B is in the same proportion as E,M,N,F");
        $t2->allgrey;
        $t2->black(2);
        $t3->math("A:C:D:B = E:M:N:F");
    };

    push @$steps, sub {
        foreach my $ref (@{$l{parts}}) {
            foreach my $l (@$ref) {
                $l->remove;
            }
        }
        $t1->explain("Thus the length of the sequence of proportional ".
        "numbers between A and B is equal to the length of the sequence ".
        "of numbers between E and F");
        $t2->allgrey;
        $t3->allgrey;
        $t2->blue([0,1]);
        $t3->blue(-1);
        $l{M}->colour($blue);
        $l{N}->colour($blue);
        
    };

    return $steps;

}

