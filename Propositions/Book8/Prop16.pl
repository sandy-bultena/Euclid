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
    "If a square number do not measure a square number, neither will the side ".
    "measure the side; and, if the side do not measure the side, neither ".
    "will the square measure the square.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 16
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

    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @C = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $C );
    our @D = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $D );


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
        $t1->explain("If A does not measures B, then ...");
        $t2->math("B \\{notequal} iA");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then C does not measures D");
        $t2->math("D \\{notequal} jC");
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
        $t2->math("A = C\\{dot}C");
        $t2->math("B = D\\{dot}D");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("If C does not measures D, then ...");
        $t2->math("D \\{notequal} jC");
        $t2->allblue;
    };

    push @$steps, sub {
        $t1->explain("... then A does not measures B");
        $t2->math("B \\{notequal} iA");
    };

    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof by Contradiction (a)");
        $t2->erase;
        $t2->math("A = C\\{dot}C");
        $t2->math("B = D\\{dot}D");
        $t2->math("B \\{notequal} iA");
        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("If C measures D, A measures B (VIII.14)");
        $t2->math("D = jC \\{then} B = iA \\{wrong}")->red(-1); 
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->math("D \\{notequal} jC");
        $t2->blue([0..2,-1]);
    };
    
    
    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof by Contradiction (b)");
        $t2->erase;
        $t4->erase;
        $t2->math("A = C\\{dot}C");
        $t2->math("B = D\\{dot}D");
        $t2->math("D \\{notequal} jC");
        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("If A measures B, C measures D (VIII.14)");
        $t2->math("B = iA \\{then} D = jC \\{wrong}")->red(-1); 
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->math("B \\{notequal} iA");
        $t2->blue([0..2,-1]);
    };
    return $steps;

}

