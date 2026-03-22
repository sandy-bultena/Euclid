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
    "Between two cube numbers there are two mean proportional numbers, and ".
    "the cube has to the cube the ratio triplicate of that which the side ".
    "has to the side.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 12
);


# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my $C = 2;
    my $D = 3;
    my $A = $C*$C*$C;
    my $B = $D*$D*$D;
    my $E = $C*$C;
    my $F = $C*$D;
    my $G = $D*$D;
    my $K = $D*$F;
    my $H = $C*$F;
    
    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @E = $line_coords->( -after=>$B, -length => $E );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @F = $line_coords->( -after=>$B, -length => $F );
    our @C = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $C );
    our @H = $line_coords->( -after=>$D, -length => $H );
    our @G = $line_coords->( -after=>$B, -length => $G );
    our @D = $line_coords->( -xorig  => $dxs, -yskip=>1,-length => $D );
    our @K = $line_coords->( -after=>$D, -length => $K );

    my $steps;

    # -------------------------------------------------------------------------
    # Definition
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t3->title("Definition: Cube numbers (VII.Def.19)");
        $t3->down;
        $t3->explain("A 'cube' is equal multiplied by equal and again ".
        "by equal, or a ".
        "number which is contained by three equal numbers");
        $t3->down;
        $t3->math("B \\{times} B \\{times} B = C");
        my $y = $t3->y;
        $t3->math("B");
        $t3->y($y);
        $t3->explain("              is the side");
        $y = $t3->y;
        $t3->math("C");
        $t3->y($y);
        $t3->explain("              is a 'cube' number");
       
    };

    push @$steps, sub {
        $t3->erase;
        $t3->down;
        $t3->title("Definition: Triplicate Ratio (V.Def.9)");
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
        $t3->erase;
        $t5->erase;
        $t1->erase;
        $t1->down;
        $t1->title("In other words");
        $t1->explain("If A and B are cubes, where C and D are the ".
        "sides, respectively, then ...") ;
        $make_lines->(qw(A B C D));
        
        $t2->math("A = C\\{dot}C\\{dot}C");
        $t2->math("B = D\\{dot}D\\{dot}D");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... there are two mean proportional numbers, and ...");
        $make_lines->(qw(H K));
        $t2->math("A:H = H:K = K:B   ");
    };

    push @$steps, sub {
        $t1->explain("... A is to B is the triplicate ratio of H to K");
        $t2->math("A:H = H:K = K:B = C:D");
    };


    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $l{H}->remove;
        $l{K}->remove;
        $t2->math("A = C\\{dot}C\\{dot}C");
        $t2->math("B = D\\{dot}D\\{dot}D");

        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Let E be C multiplied by C, and let F be C multiplied by D " .
        "and let G be D multiplied by D");
        $t2->math("E = C\\{dot}C");
        $t2->math("F = C\\{dot}D");
        $t2->math("G = D\\{dot}D");
        $make_lines->(qw(E F G));
    };

    push @$steps, sub {
        $t1->explain("Let H,K be C,D multiplied by F");
        $make_lines->(qw(H K));
        $t2->math("H = C\\{dot}F");
        $t2->math("K = D\\{dot}F");
    };

    push @$steps, sub {
        $t1->explain("Since A is C cubed, and E is C squared, A is E multiplied ".
        "by C");
        $t2->allgrey;
        $t2->blue(0);
        $t2->black(2);
        $t2->math("A = C\\{dot}E");
    };

    push @$steps, sub {
        $t1->explain("Likewise, B is equal to D multiplied by G");
        $t2->allgrey;
        $t2->blue(1);
        $t2->black(4);
        $t2->math("B = D\\{dot}G");
    };

    push @$steps, sub {
        $t1->explain("Since E,F are C multiplied by C,D respectively, C is to ".
        "D as E is to F (VII.17)");
        $t2->allgrey;
        $t2->black([2,3]);
        $t4->math("C:D = E:F");
    };

    push @$steps, sub {
        $t1->explain("For the same reason C is to D as F is to G (VII.18)");
        $t2->allgrey;
        $t2->black([3,4]);
        $t4->allgrey;
        $t4->math("C:D = F:G");
    };

    push @$steps, sub {
        $t1->explain("A and H are E,F multiplied by C, therefore E is ".
        "to F is as A is to H (VII.17)");
        $t4->allgrey;
        $t2->allgrey;
        $t2->black([5,7]);
        $t4->math("E:F = A:H");
    };

    push @$steps, sub {
        $t1->explain("But E is to F as C is to D, therefore as C is ".
        "to D, so is A to H");
        $t4->allgrey;
        $t2->allgrey;
        $t4->black([0,-1]);
        $t4->math("C:D = A:H");
    };

    push @$steps, sub {
        $t1->explain("C is to D as H is to K (VII.18)");
        $t2->allgrey;
        $t2->black([5,6]);
        $t4->allgrey;
        $t4->math("C:D = H:K");
    };
    
    push @$steps, sub {
        $t1->explain("F is to G as K is to B (VII.17)");
        $t2->allgrey;
        $t2->black([6,8]);
        $t4->allgrey;
        $t4->math("F:G = K:B");
    };
    
    push @$steps, sub {
        $t1->explain("But F is to G as C is to D, therefore C is to as K is to B");
        $t4->allgrey;
        $t2->allgrey;
        $t4->black([1,-1]);
        $t4->math("C:D = K:B"); 
    };

    push @$steps, sub {
        $t1->explain("But C is to D as A is to H, H is to K, and K is to B");
        $t4->allgrey;
        $t2->allgrey;
        $t4->black([3,4,-1]);
        $t4->math("A:H = H:K = K:B");
    };

    push @$steps, sub {
        $t1->explain("Therefore H,K are TWO mean proportional numbers ".
        "between A and B");
        $t4->allgrey;
        $t2->allgrey;
        $t4->black([-1]);
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain("A to B is the triplicate ".
        "ratio of A to H (V.Def.10)");
        $t4->allgrey;
        $t4->down;
        $t4->black([-1]);
        $t4->math("A:B is triplicate A:H");
    };

    push @$steps, sub {
        $t1->explain("But A is to H as C is to D, therefore A to B is the ".
        "triplicate of C to D");
        $t4->allgrey;
        $t4->black([-1,3]);
        $t4->math("A:B is triplicate C:D");        
    };

    push @$steps, sub {
        $t2->blue([0,1]);
        $t4->allgrey;
        $t4->blue([-1,-3]);
    };
    
    
    
    

    return $steps;

}

