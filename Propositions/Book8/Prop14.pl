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

my $unit = 10;
my $ds   = 30;

our ( %p, %c, %s, %t, %l );

my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If a square measure a square, the side will also measure the side; and, ".
    "if the side measure the side, the square will also measure the square.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 14
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
    my $D = 6;
    my $B = $D*$D;
    my $A = $C*$C;

    my $E = $D*$C;
    
    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @C = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $C );
    our @D = $line_coords->(  -length => $D );
    our @E = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $E );

    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words (a)");
        $t1->explain("Let A,B be square numbers, and C,D their respective sides.") ;
        $make_lines->(qw(A B C D));
        $t2->math("A = C\\{dot}C");
        $t2->math("B = D\\{dot}D");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("If A measures B, then ...");
        $t2->math("B = iA");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then C measures D");
        $t2->math("D = jC");
    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->erase;
        $t1->down;
        $t1->title("In other words (b)");
        $t1->explain("Let A,B be square numbers, and C,D their respective sides.") ;
        $make_lines->(qw(A B C D));
        $t2->math("A = C\\{dot}C");
        $t2->math("B = D\\{dot}D");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("If C measures D, then ...");
        $t2->math("D = jC");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then A measures B");
        $t2->math("B = iA");
    };

    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof (a)");
        $t2->erase;
        $t2->math("A = C\\{dot}C");
        $t2->math("B = D\\{dot}D");
        $t2->math("B = iA");
        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Let E be C multiplied by D");
        $make_lines->(qw(E));
        $t2->allgrey;
        $t2->math("E = C\\{dot}D"); #3
    };

    push @$steps, sub {
        $t1->explain("Then A,E,B are continuously proportional (VIII.11)");
        $t2->blue([0,1]);
        $t2->math("A:E = E:B = C:D"); #4
    };
    
     push @$steps, sub {
        $t1->explain("And, since A,E,B are continuously proportional, ".
        "and A measures B, then A also measures E (VIII.7)");
        $t2->allgrey;
        $t2->blue([2]);
        $t2->black([-1]);
        $t2->math("E = jA"); #5
    };
    
     push @$steps, sub {
        $t1->explain("And since A is to E as C is to D, C measures D ".
        "(VII.Def.20)");
        $t2->allgrey;
        $t2->black([4,5]);
        $t2->math("D = jC"); #6
    };
    
     push @$steps, sub {
         $t2->allgrey;
         $t2->blue([0,1,2]);
         $t2->blue(-1);
    };
    
    
    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof (b)");
        $t2->erase;
        $t2->math("A = C\\{dot}C");
        $t2->math("B = D\\{dot}D");
        $t2->math("D = jC");
        $t2->allblue;        
    };

     push @$steps, sub {
        $t1->explain("Let E be C multiplied by D");
        $t2->math("E = C\\{dot}D"); #3
        $t1->explain("Then A,E,B are continuously proportional (VIII.11)");
        $t2->blue([0,1]);
        $t2->math("A:E = E:B = C:D"); #4
    };

     push @$steps, sub {
        $t1->explain("And since A is to E as C is to D,".
        "and C measures D, then A also measures E (VII.Def.20)");
        $t2->allgrey;
        $t2->black([4]);
        $t2->blue(2);
        $t2->math("E = jA"); #5
    };

     push @$steps, sub {
        $t1->explain("And, since A,E,B are continuously proportional, ".
        "and A measures E, it also measures B ");
        $t2->allgrey;
        $t2->black([4,5]);
        $t2->math("B = iA"); #6
    };
    
     push @$steps, sub {
         $t2->allgrey;
         $t2->blue([0,1,2]);
         $t2->blue(-1);
    };

    return $steps;

}

