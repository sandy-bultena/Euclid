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

my ( %p, %c, %s, %t, %l );
my $ds  = 30;
my $unit = 7;
use Geometry::Shortcuts;
my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);


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
    my $dxs  = 100;
    my $dys = 200;
    
    my $A = 2;
    my $B = 3;
    my $C = $A*$A;
    my $D = $A*$B;
    my $E = $B*$B;
    my $F = $A*$A*$A;
    my $G = $B*$A*$A;
    my $H = $A*$B*$B;
    my $K = $B*$B*$B;
    
    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @C = $line_coords->( -xorig  => $dxs, -yskip => 2, -length => $C );
    our @D = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $D );
    our @E = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $E );
    our @F = $line_coords->( -xorig  => $dxs, -yskip => 2, -length => $F );
    our @G = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $G );
    our @H = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $H );
    our @K = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $K );

    my $steps;
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "Given a ratio of A:B, where A,B are the least numbers "
        ."of that ratio" );
       
        $make_lines->(qw(A B ));
        
        $t2->math("A,B are least of A:B");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain( "Find a set of numbers (four in this example) "
        ."where F is to G is as G is to H as H is to K, where ".
        "F,G,H,K are the least numbers of the ratio A to B" );
       
        $make_lines->(qw(F G H K ));

        $t2->down();
        $t2->math("F,G,H,K are least where...");
        $t2->math("F:G = G:H = H:K = A:B"); 
        
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
            $l{$c}->remove;
        }
        $t2->erase;
        $t2->math("A,B are least of A:B");
        $t2->allblue();
    };

    push @$steps, sub {
        $t2->down;
        $t1->explain("Create three new numbers C,D,E, where C is A times ".
        "A, D is B times A, and E is B times B");

        $make_lines->(qw(C D E ));

        $t4->y($t2->y);
        $l{parts} = [];
        $t2->math("C = AA = A\\{^2}");
        $t2->math("D = AB");
        $t2->math("E = BB = B\\{^2}");
    };

    push @$steps, sub {
        $t1->explain("Create four new numbers where F is C times A, G is D ".
        "times A, H is D times A, and K is B times E");

        $make_lines->(qw(F G H K ));
        
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
        $t2->math("F,G,H,K are least where...");
        $t2->math("F:G = G:H = H:K = A:B"); 
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof");
        $t2->erase;        
        $t2->math("A,B are least of A:B");
        $t2->down;
        $t2->math("C = AA = A\\{^2}");      # 0
        $t2->math("D = AB");                # 1
        $t2->math("E = BB = B\\{^2}");      # 2
        $t2->down;
        $t2->math("F = AC = A\\{^3}");      # 3
        $t2->math("G = AD = A\\{^2}B");     # 4
        $t2->math("H = AE = AB\\{^2}");     # 5
        $t2->math("K = BE = B\\{^3}");      # 6
        $tp->erase;
        $t2->allblue();
     };
    
    push @$steps, sub {
        $t1->explain("Since C and D are A multiplied by A and B respectively, ".
        "C is to D as A is to B (VII.17)");
        $t2->allgrey;
        $t2->blue([1,2]);
        $t4->math("C:D = A:B");             # 0
    };
    push @$steps, sub {
        $t1->explain("Since D and E are A and B multiplied by B, ".
        "D is to E as A is to\\{nb}B\\{nb}(VII.18)");
        $t2->allgrey;
        $t2->blue([2,3]);
        $t4->allgrey;
        $t4->math("D:E = A:B");             # 1
    };
    push @$steps, sub {
        $t2->allgrey;
        $t4->allblack();
        $t1->explain("Thus C ".
        "is to D as D is to E");
        $t4->math("C:D = D:E");             # 2
    };
    push @$steps, sub {
        $t1->explain("Since F and G are A multiplied by C and D respectively, ".
        "F is to G as C is to D (VII.17)");
        $t4->down;
        my $y = $t4->y;
        $t4->allgrey;
        $t2->blue([4,5]);
        $t4->math("F:G = C:D");             # 3
        $t4->y($y);
    };
    push @$steps, sub {
        $t1->explain("And C to D is equal to A to B, so F to G is equal to A to B");
        $t4->black(0);
        $t2->allgrey;
        $t4->math("          = A:B");
    };
    push @$steps, sub {
        $t1->explain("Since G and H are A multiplied by D and E respectively, ".
        "G is to H as D is to E (VII.17)");
        my $y = $t4->y;
        $t4->allgrey;
        $t2->allgrey;
        $t2->blue([5,6]);                   
        $t4->math("G:H = D:E");             # 4
        $t4->y($y);
    };
    push @$steps, sub {
        $t1->explain("And D to E is equal to A to B, so G to H is equal to A to B");
        $t2->allgrey;
        $t4->black(1);
        $t4->math("          = A:B");       # 5
    };
     push @$steps, sub {
        $t1->explain("Since H and K are A and B multiplied by E, ".
        "H is to K as A is to\\{nb}B\\{nb}(VII.18)");
        my $y = $t4->y;
        $t2->allgrey;
        $t2->blue([6,7]);
        $t4->allgrey;
        $t4->math("H:K = A:B");             # 6
     };
     push @$steps, sub {
         $t1->explain("Therefore, as F is to G, G is to H, and H is to K, where ".
         "all are as A is to B");
         $t2->allgrey;
         $t4->allgrey;
         $t4->black([-1,-2,-3,-4,-5]);
         $t4->math("F:G = G:H = H:K = A:B");    # 7
     };
     push @$steps, sub {
        $t1->explain("Since A,B are the least numbers with that ratio, A,B ".
        "are relatively prime (VII.22)");
        $t2->blue([0]);
        $t4->allgrey;
        $t2->down;
        $t2->math("gcd(A,B) = 1");              # 7
     };
     push @$steps, sub {
         $t1->explain("C and E are the squares of A and B respectively, ".
         "and are thus also relatively prime (VII.27)");
        $t2->allgrey;
        $t2->blue([1,3,]);
        $t2->black(-1);
        $t2->math("gcd(C,E) = 1");              # 8
    };
     push @$steps, sub {
         $t1->explain("F and K are the cubes of A and B respectively, ".
         "and are thus also relatively prime (VII.27)");
        $t2->allgrey;
        $t2->blue([4,7,]);
        $t2->black(-2);
        $t2->math("gcd(F,K) = 1");              # 9
    };
     push @$steps, sub {
        $t1->explain("If there be as many numbers as we please in continued ".
        "proportion, and the extremes are relatively prime, then they are the ".
        "least numbers in that ratio (VIII.1)");
        $t2->allgrey;
        $t2->black([-1]);
        $t4->black(-1);
        $t2->math("F,G,H,K are least where...");    # 10
        $t2->math("F:G = G:H = H:K = A:B");         # 11
    };
     push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t2->blue([0,-1,-2]);
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
        $t4->allgrey;
        $t2->blue([1,3,4,7]);
        $t4->blue([2,8]); 
     };

    


    return $steps;

}

