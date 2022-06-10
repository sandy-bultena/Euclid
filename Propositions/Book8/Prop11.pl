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
my $t4 = $pn->text_box( 140, 660 );

my $unit = 10;
my $ds   = 30;

our ( %p, %c, %s, %t, %l );

my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "Between two square numbers there is one mean proportional number, and the ".
    "square has to the square the ratio duplicate of that which the side ".
    "has to the side.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 11
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
    my $A = $C*$C;
    my $B = $D*$D;
    my $E = $C*$D;
    
    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @C = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $C );
    our @D = $line_coords->( -after => $A,-length => $D );
    our @E = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $E );

    my $steps;

    # -------------------------------------------------------------------------
    # Definition
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t3->title("Definition: Square numbers (VII.Def.18)");
        $t3->down;
        $t3->explain("A 'square number' is equal multiplied by equal, or a ".
        "number which is contained by two equal numbers");
        $t3->down;
        $t3->math("B \\{times} B = C");
        my $y = $t3->y;
        $t3->math("B,B");
        $t3->y($y);
        $t3->explain("              is the side");
        $y = $t3->y;
        $t3->math("C");
        $t3->y($y);
        $t3->explain("              is a 'square' number");
       
    };

    push @$steps, sub {
        $t3->erase;
        $t3->down;
        $t5->title("Definition: Duplicate Ratio (V.Def.9)");
        $t5->down;
        $t5->explain("If A is to B as B is to C, then the ratio of A to C is the ".
        "duplicate ratio of A to B");
        $t5->explain("(a special case of compound ratio)");

        $t5->down;
            #$t3->fancy("Duplicate ratio of A:B");
        $t5->math("A:C = C:B \\{then} A:B duplicate ratio of A:C");
        $t5->down;
        $t5->fancy("Example");
        $t5->math("A\\{^2}:AB = AB:B\\{^2}  (=A:B)");
            $t5->math("A\\{^2}:B\\{^2} is the duplicate ratio of A:B ");       
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
        $t1->explain("If A and B are square numbers, where C and D are the ".
        "sides, respectively, then ...") ;
        $make_lines->(qw(A B C D));
        
        $t2->math("A = C\\{dot}C");
        $t2->math("B = D\\{dot}D");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... there is one mean proportional number, and ...");
        $make_lines->(qw(E));
        $t2->math("A:E = E:B   ");
    };

    push @$steps, sub {
        $t1->explain("... A is to B is the duplicate ratio of C to D");
        $t2->math("A:E = E:B = C:D");
    };


    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $l{E}->remove;
        $t2->math("A = C\\{dot}C");
        $t2->math("B = D\\{dot}D");

        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Let E be C multiplied by D");
        $t2->math("E = C\\{dot}D");
        $make_lines->("E");
    };

    push @$steps, sub {
        $t1->explain("Since A,E are C multiplied by C,D respectively, therefore ".
        "as C is to D, so is A to E (VII.17)");
        $t2->allgrey;
        $t2->blue(0);
        $t2->black(-1);
        $t2->math("C:D = A:E");
    };

    push @$steps, sub {
        $t1->explain("Since B,E are D,C multiplied by D respectively, therefore ".
        "as C is to D, so is E to B (VII.18)");
        $t2->allgrey;
        $t2->blue(1);
        $t2->black(2);
        $t2->math("C:D = E:B");
    };

    push @$steps, sub {
        $t1->explain("Therefore, A is to E as E is to B, and there is ONE ".
        "mean number");
        $t2->allgrey;
        $t2->black([-1,-2]);
        $t2->math("A:E = E:B");
    };

    push @$steps, sub {
        $t1->explain("By definition (V.Def.9) A to B is the duplicate ratio of A:E");
        $t2->allgrey;
        $t2->black([-1]);
        $t2->math("A:B is duplicate of A:E");
    };

    push @$steps, sub {
        $t1->explain("But as A is to E, so is C to D");
        $t2->allgrey;
        $t2->black([3,-1]);
        $t2->math("A:B is duplicate of C:D");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([-1]);
        $t2->blue([0,1]);
    };
    
    
    
    

    return $steps;

}

