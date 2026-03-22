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
my $t2 = $pn->text_box( 140, 300 );
#my $t2 = $pn->text_box( 140, 400 );
#my $t2 = $pn->text_box( 100, 400 );
my $t5 = $pn->text_box( 140, 150, -width=>1100 );
my $tp = $pn->text_box( 100, 550 );
my $t3 = $pn->text_box( 100, 150 );
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
    "Between two similar plane numbers there is one mean proportional number; ".
    "and the plane number has to the plane number the ratio duplicate of ".
    "that which the corresponding side has to the corresponding side.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 18
);


# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
 #   my $dys      = 160;
    my $dys      = 200;
    my $C = 2;
    my $D = 3;
    my $E = 2*$C;
    my $F = 2*$D;
    my $B = $E*$F; # = 2 * $C * 2 * $D
    my $A = $C*$D; # =     $C     * $D
    my $G = $D*$E; # = 2 * $C     * $D 

    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @C = $line_coords->(  -after=>$B, -length => $C );
    our @D = $line_coords->( -after=>[$B,$E], -length=>$D );

    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @E = $line_coords->( -after=>$B, -length => $E );
    our @F = $line_coords->( -after=>[$B,$E], -length=>$F );

    our @G = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $G );

    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # Definition
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t5->down;
        $t5->title("Definition: Plane numbers (VII.Def.16)");
        $t5->down;
        $t5->explain("When two numbers having multiplied one another make some ".
        "number, the number so produced is called 'plane' and its 'sides' ".
        "are the numbers which have multiplied one another");
        $t5->math("A\\{dot}B = C");
        my $y = $t5->y;
        $t5->math("A,B");
        $t5->y($y);
        $t5->explain("              are sides");
        $y = $t5->y;
        $t5->math("C");
        $t5->y($y);
        $t5->explain("              is a 'plane' number");
        $t5->down;
        $t5->title("Definition: Similar Plane Numbers (VII.Def.21)");
        $t5->down;
        $t5->explain("'Similar plane' and 'solid' numbers are those which have "
        ."their sides proportional");
        $t5->math("If   A = C\\{dot}D");
        $t5->math("and  B = E\\{dot}F");
        $y = $t5->y;
        $t5->math("and  C:D = E:F");       
        $t5->math("then A ~ B (A,B are similar)");
    };

    push @$steps, sub {
        $t5->erase;
        $t5->down;
        $t5->title("Definition: Duplicate Ratio (V.Def.9)");
        $t5->down;
        $t5->explain("If A is to B as B is to C, then the ratio of A to C is the ".
        "duplicate ratio of A to B");
        $t5->explain("(a special case of compound ratio)");

        $t5->down;
            #$t3->fancy("Duplicate ratio of A:B");
        $t5->math("A:C=C:B \\{then} A:B duplicate ratio of A:C");
        $t5->down;
        $t5->fancy("Example");
        $t5->math("A\\{^2}:AB = AB:B\\{^2}  (=A:B)");
            $t5->math("A\\{^2}:B\\{^2} is the duplicate ratio of A:B ");       
   };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t5->erase;
        $t1->title("In other words (a)");
        $t1->explain("If A,B be similar plane numbers, and C,D be the sides of A, "
        ."and E,F the sides of B, then...") ;
        $make_lines->(qw(A B C D E F));
        $t2->math("A = C\\{dot}D");
        $t2->math("B = E\\{dot}F");
        $t2->math("A ~ B, C:D = E:F");     # 2
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... there is one mean proportional between A and B, and ...");
        $t2->math("A:G = G:B");
    };

    push @$steps, sub {
        $t1->explain("... A to B is the duplicate ratio of C to E or D to F");
        $t2->math("A:B is duplicate of C:E and D:F");
        $t2->math("A:B = C\\{^2}:E\\{^2} =  D\\{^2}:F\\{^2}");
    };

    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("A = C\\{dot}D"); # 0
        $t2->math("B = E\\{dot}F"); # 1
        $t2->math("A ~ B, C:D = E:F");     # 2
        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Since C is to D as E is to F, alternately, as C is ".
        "to E, so is D to\\{nb}F\\{nb}(VII.13)");
        $t2->allgrey;
        $t2->blue(-1);
        $t2->math("C:E = D:F");     # 3
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Let G be E multiplied by D");
        $make_lines->("G");
        $t2->math("G = E\\{dot}D");   # 4
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since A is C multiplied by D, and G is E multipled by D, ".
        "then C is to E as A is to G (VII.17)");
        $t2->black(4);
        $t2->blue([0]);
        $t2->math("C:E = A:G");     # 5
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("But, as C to E also is as D to F, so D is to F as A is to G");
        $t2->black([5,3]);
        $t2->math("D:F = A:G");     # 6
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since G is E multiplied by D, and B is E multiplied by F ".
        "then D is to F as G is to B (VII.17)");
        $t2->blue(1);
        $t2->black(4);
        $t2->math("D:F = G:B");     # 7
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("But D is to F as A is to G, therefore A is to G as G ".
        "is to B");
        $t2->black([7,6]);
        $t2->math("A:G = G:B");     # 8
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0..2]);
        $t2->black(-1);
        $t1->explain("Thus there is one mean proportional between A and B");
        $t2->down;
        $t1->down;
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since A,G,B are in continued proportion, A to B is the ".
        "duplicate ratio of A to G and G to B (V.Def.9)");
        $t2->black(-1);
        $t2->math("A:B is duplicate of A:G");   #9
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("But A is to G as C is to E as D is to F, therefore ".
        "A to B is the duplicate ratio of C to E and D to F");
        $t2->black([5,6,9]);
        $t2->math("A:B is duplicate of C:E and D:F");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0..2]);
        $t2->blue([-1,8]);
    };

    return $steps;

}

