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
my $t2 = $pn->text_box( 140, 340 );
my $t5 = $pn->text_box( 140, 150, -width=>1100 );
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 140, 340 );
my $t4 = $pn->text_box( 140, 660 );

my $ds   = 30;
my $unit = 7;

our ( %p, %c, %s, %t, %l );

use Geometry::Shortcuts;
my ($make_lines, $line_coords, $current_xy ) = 
        Shortcuts::make_some_line_subs($pn,$ds,$unit,\%p,\%l);


# ============================================================================
# Definitions
# ============================================================================
my $title =
    "Plane numbers have to one another the ratio compounded ".
    "of the ratios of their sides  (c.f. VI.23)";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 5
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $dxs_orig = 100;
    my $dxs      = $dxs_orig;
    my $dys      = 160;
    my $C        = 3;
    my $D        = 4;
    my $E        = 5;                               
    my $F        = 6;                               
    my $A        = $C * $D;
    my $B        = $E * $F;
    
    my $H        = Numbers->new( $E, $D )->lcm();
    my $G        = $H / $E * $C;
    my $K        = $H / $D * $F;
    my $L        = $D*$E;

    our @A = $line_coords->( -xorig  => $dxs, -yorig => $dys, -length => $A );
    our @C = $line_coords->( -after=>$B, -length => $C );
    our @D = $line_coords->( -after=>[$B,$E], -length => $D );
    our @B = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $B );
    our @E = $line_coords->( -after=>$B, -length => $E );
    our @F = $line_coords->( -after=>[$B,$E], -length => $F );
    our @G = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $G );
    our @H = $line_coords->( -length => $H );
    our @K = $line_coords->( -length => $K );
    our @L = $line_coords->( -xorig  => $dxs, -yskip => 1, -length => $L );
    
    my $steps;

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
       
    };

    # -------------------------------------------------------------------------
    # Definition
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t5->clear;
        $t5->down;
        $t5->title("Definition: Compound Ratios");
        $t5->down;
        $t5->explain("Euclid simply uses 'compound ratios' in this proof without ".
        "previously defining them, so the definition of compound ratio has been retroactively defined as...\\{^1}");
        $t4->footnote("\\{^1} Euclid's Elements - all thirteen books complete in one volume, ".
        "The Thomas L Heath Translation,  Dana Densmore, Editor, ".
        "\n  Green Lion Press (c) 2013, pg xxix");
    };

    push @$steps, sub {
        $t5->explain(" ...If we have a series of magnitudes, A...D for example");
        $t5->math("A:D = compound ratio of A:B, B:C, C:D")->blue([-1]);
    };

    push @$steps, sub {
        $t5->explain("If A to B is equal to E to F, B to C equal to G to H, C to D equal J to K, ".
        "then the ratio of A to D is also equal to the compound ratio of G to H, C to D, and J to K \\{^1}");
        $t5->math("A:B = E:F")->blue(-1);
        $t5->math("B:C = G:H")->blue(-1);
        $t5->math("C:D = J:K")->blue(-1);
        $t5->math("A:D = compound ratio of E:F, G:H, J:K")->blue(-1);
    };

    push @$steps, sub {
        $t5->down;
        $t5->explain("For two or more ratios, if we take antecedent as product of ".
        "antecedents of the ratios and consequent as product of consequents of the ratios, ".
        "then the ratio thus formed is called mixed or compound ratio. \\{^2}");
        $t5->math("compound ratio of m:n, p:q = mp:nq")->blue(-1);
        $t4->footnote("\\{^2} http://www.math-only-math.com/types-of-ratios.html");
    };

    push @$steps, sub {
        $t5->math("\\{therefore}     A:D = ABC:BCD and A:D = EGJ:FHK")->red(-1);
    };

        















    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t5->erase;
        $t1->title("In other words");
        $t1->explain(   "If A,B are both plane numbers, and C,D are the ".
        "sides of A, and E,F are the sides of B ..." );

        $t2->math("A = C\\{dot}D");
        $t2->math("B = E\\{dot}F");
        $t2->allblue;
        $make_lines->(qw(A B C D E F));

        my $xoff = 400; my $yoff = 300; my $scale = 25;
        $s{A} = Polygon->new($pn, 4,$xoff,$yoff,$xoff+$C*$scale,$yoff,$xoff+$C*$scale,
            $yoff+$D*$scale, $xoff,$yoff+$D*$scale)->label("A")->fill($pale_yellow);
        $l{C} = Line->new($pn,$xoff,$yoff,$xoff+$C*$scale,$yoff)->label("C","top");
        $l{D} = Line->new($pn,$xoff,$yoff,$xoff,$yoff+$D*$scale)->label("D","left");

        $xoff = $xoff + 100 + $C*$scale;
        $yoff = $yoff + 0.5*($D-$F)*$scale;
        $s{B} = Polygon->new($pn, 4,$xoff,$yoff,$xoff+$E*$scale,
            $yoff,$xoff+$E*$scale,$yoff+$F*$scale, $xoff,$yoff+$F*$scale)->label("B")->fill($sky_blue);
        $l{E} = Line->new($pn,$xoff,$yoff,$xoff+$E*$scale,$yoff)->label("E","top");
        $l{F} = Line->new($pn,$xoff,$yoff,$xoff,$yoff+$F*$scale)->label("F","left");
     };

    push @$steps, sub {
        $t2->down;
        $t2->explain("The ratio of sides:");
        $t2->math("C:E, D:F");
    };

    push @$steps, sub {
        $t2->down;
        $t1->explain("... the ratio of A to B is equal to the compound ".
        "ratio of their sides");
        $t2->math("A:B = (C\\{dot}D):(E\\{dot}F)");
    };


    # -------------------------------------------------------------------------
    # Proof 
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->title("Proof");
        $t2->erase;
        $t2->math("A = C\\{dot}D");
        $t2->math("B = E\\{dot}F");
        $t2->allblue;        
    };

    push @$steps, sub {
        $t1->explain("Find the least ".
        "numbers G,H,K that are continuous in the ratios of C to E "
        ."and D to F (VIII.4)");
        $t3->y($t2->y);
        $t3->down;
        $t3->math("H = lcm(E,D) = nE = mD");
        $t3->math("G = nC");
        $t3->math("K = mF");
        $t3->down;
        
        $t3->math("G:H = C:E");
        $t3->math("H:K = D:F");
        
        $make_lines->(qw(G H K));
    };

    push @$steps, sub {
        $t3->erase;
        $t2->math("G:H = C:E");
        $t2->math("H:K = D:F");
    };

    push @$steps, sub {
        $t1->explain("Let L be D multiplied by E");
        $t2->allgrey;
        $make_lines->("L");
        $t2->math("L = D\\{dot}E");
    };

    push @$steps, sub {
        $t1->explain("Since A is D multiplied by C, and L is D multiplied by E, ".
        "C is to\\{nb}E as A is to L (VII.17)");
        $t2->blue(0);
        $t2->math("C:E = A:L");
    };

    push @$steps, sub {
        $t1->explain("But, as C is to E, so is G to H, ".
        "therefore G is to H as A is to L");
        $t2->allgrey;
        $t2->black([2,-1]);
        $t2->math("G:H = A:L");
    };

    push @$steps, sub {
        $t1->explain("Since B is E multiplied by F, and L is E multiplied by F, ".
        "D is to\\{nb}F as L is to B (VII.17)");
        $t2->allgrey;
        $t2->blue(1);
        $t2->black(4);
        $t2->math("D:F = L:B");
    };
    
    push @$steps, sub {
        $t1->explain("But, as D is to F, so is H to K, ".
        "therefore H is to K as L is to B");
        $t2->allgrey;
        $t2->black([3,-1]);
        $t2->math("H:K = L:B");
     };
    
    push @$steps, sub {
        $t1->explain("However G is to H as A is to L, therefore, ex aequali, ".
        "G is to K as A is to B (VII.14)");
        $t2->allgrey;
        $t2->black([6,8]);
        $t2->math("G:K = A:B");
     };
    
    push @$steps, sub {
        $t1->explain("But G to K is the compounded ratio of the sides ");
        $t2->allgrey;
        my $y = $t2->y;
        $t2->math("G:K is compound ratio of G:H, H:K");
        $t2->math("G:K = (G\\{dot}H):(H\\{dot}K) = (nC\\{dot}mD):(nE\\{dot}mF) =  (C\\{dot}D):(E\\{dot}F)");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->black([-1,-3]);
        $t1->explain("Therefore A to B is equal to the compound ratio of the sides");
        $t2->math("A:B = (C\\{dot}D):(E\\{dot}F)");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->blue([0,1,-1]);
    };

    return $steps;

}

