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
    "If a cube number measure a cube number, the side will also measure ".
    "the side; and, if the side measure the side, the cube will also ".
    "measure the cube.";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 15
);


# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $y;

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my $C = 3/1.5;
    my $D = 6/1.5;
    my $B = $D*$D*$D;
    my $A = $C*$C*$C;

    my $E = $C*$C;
    my $F = $C*$D;
    my $G = $D*$D;
    my $H = $C*$F;
    my $K = $D*$F;
    
    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @C = $line_coords->( -xorig  => $dxs, -yskip=>1, -length => $C );
    our @E = $line_coords->( -after=>$D, -length => $E );
    our @H = $line_coords->( -after=>[$D,$G], -length => $H );
    our @D = $line_coords->(  -xorig  => $dxs, -yskip=>1, -length=>$D );
    our @G = $line_coords->( -after=>$D, -length => $G );
    our @K = $line_coords->( -after=>[$D,$G], -length => $K );
    our @F = $line_coords->( -yskip=>1,-after=>$D, -length => $F );

    my $steps;
    my $ypos;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words (a)");
        $t1->explain("Let A,B be cube numbers, and C,D their respective sides.") ;
        $make_lines->(qw(A B C D));
        $t2->math("A = C\\{dot}C\\{dot}C");
        $t2->math("B = D\\{dot}D\\{dot}D");
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
        $t1->explain("Let A,B be cube numbers, and C,D their respective sides.") ;
        $t2->math("A = C\\{dot}C\\{dot}C");
        $t2->math("B = D\\{dot}D\\{dot}D");
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
        $t2->math("A = C\\{dot}C\\{dot}C");
        $t2->math("B = D\\{dot}D\\{dot}D");
        $t2->math("B = iA");
        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Let E be C multiplied by C, let G by D multiplied by D, ".
        "and let F be C multiplied by D");
        $make_lines->(qw(E F G));
        $t2->allgrey;
        $t2->math("E = C\\{dot}C"); #3
        $t2->math("G = D\\{dot}D"); #4
        $t2->math("F = C\\{dot}D"); #5
    };

    push @$steps, sub {
        $t1->explain("And let H,K be C,D multiplied by F");
        $make_lines->(qw(H K));
        $t2->allgrey;
        $t2->math("H = C\\{dot}C\\{dot}D"); #6
        $t2->math("K = D\\{dot}C\\{dot}D"); #7
    };

    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Hence E,F,G are continuously proportion to C:D (VIII.11)");
        $t2->black([3,4,5]);
        $t2->math("E:F = F:G = C:D"); #8
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("And A,H,K,B are also continuously proportion to C:D (VIII.12)");
        $t2->blue([0,1]);
        $t2->black([6,7]);
        $t2->math("A:H = H:K = K:B = C:D"); #9
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t1->explain("Since A,H,K,B are continuously proportional, and A measures B, ".
        "then A also measures H (VIII.7)");
        $t2->black([9]);
        $t2->blue(2);
        $t4->math("H = jA");  #1
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t1->explain("And as A is to H, so is C to D, therefore C measures D (VII.Def.20)");
        $t2->black([9]);
        $t4->math("D = jC");
    };
    
    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t2->blue([0..2]);
        $t4->blue(-1);
    };
    
    
    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof (b)");
        $t2->erase;
        $t4->erase;
        $t2->math("A = C\\{dot}C\\{dot}C");
        $t2->math("B = D\\{dot}D\\{dot}D");
        $t2->math("D = jC");
        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Let E be C multiplied by C, let G by D multiplied by D, ".
        "and let F be C multiplied by D");
        $make_lines->(qw(E F G));
        $t2->allgrey;
        $t2->math("E = C\\{dot}C"); #3
        $t2->math("G = D\\{dot}D"); #4
        $t2->math("F = C\\{dot}D"); #5
        $t1->explain("And let H,K be C,D multiplied by F");
        $make_lines->(qw(H K));
        $t2->math("H = C\\{dot}C\\{dot}D"); #6
        $t2->math("K = D\\{dot}C\\{dot}D"); #7
        $t1->explain("Hence E,F,G are continuously proportion to C:D (VIII.11)");
        $t2->black([3,4,5]);
        $t2->math("E:F = F:G = C:D"); #8
        $t1->explain("And A,H,K,B are also continuously proportion to C:D (VIII.12)");
        $t2->blue([0,1]);
        $t2->black([6,7]);
        $t2->math("A:H = H:K = K:B = C:D"); #9
    };

    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t1->explain("Since C measures D and C is to D as A is to H, therefore ".
        "A measures H, (VII.Def.20)");
        $t2->blue(2);
        $t2->black(-1);
        $t4->math("H = jA");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t4->black([-1]);
        $t2->black(-1);
        $t1->explain("and thus A measures B");
        $t4->math("B = iA");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t4->allgrey;
        $t2->blue([0..2]);
        $t4->blue(-1);
    };
    return $steps;

}

