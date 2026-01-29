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


# ============================================================================
# Definitions
# ============================================================================
my $title = "Equiangular parallelograms have to one another the ratio ".
"compounded of the ratios of their sides";

$pn->title( 23, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 140, 660 );
my $t5 = $pn->text_box( 140, 150, -width=>1100 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 23 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my (%p,%c,%s,%t,%l,%a);
    my $off = 40;
    my $yoff = 30;
    my $yh = 150;
    my $ym = 210;
    my $yb = 300;
    my $dx1 = 200;
    my $dx2 = 20;
    my $dx3 = 140;
    my $dx4 = 20;
    my $xs = 150;
    my $k = 1.1;
    my $y;
    my $k2 = 1/1.3;
    
    my @B = ($xs,$ym);
    my @C = ($xs + $dx1, $ym);
    my @A = ($B[0]+$dx2,$yh);
    my @D = ($A[0]+$dx1,$yh);
    my @E = ($C[0]-$dx2*($yb-$ym)/($ym-$yh),$yb);
    my @F = ($E[0]+$k*$dx1,$yb);
    my @G = ($C[0]+$k*$dx1,$ym);
    my @H = ($D[0]+$k*$dx1,$yh);
    
    my @K = ($B[0],$E[1]+2*$yoff);
    my @L = ($B[0],$K[1]+$yoff);
    my @M = ($B[0],$L[1]+$yoff);
    

    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;

    
    # -------------------------------------------------------------------------
    # Definition
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t5->title("Definition: Compound Ratios");
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
        $t5->down;
        $t5->math("\\{therefore}     A:D = ABC:BCD")->red(-1);;
        $t5->math("  and A:D = EGJ:FHK")->red(-1);
    };

        
    push @$steps, sub {
        $t5->erase;
        $t4->erase;
        $t5->title("Definition: Compound Ratios");
        $t5->math("A:D = compound ratio of A:B, B:C, C:D")->blue(-1);
        $t5->math("A:B = E:F")->blue(-1);
        $t5->math("B:C = G:H")->blue(-1);
        $t5->math("C:D = J:K")->blue(-1);
        $t5->math("A:D = compound ratio of E:F, G:H, J:K")->blue(-1);
        $t5->math("compound ratio of m:n, p:q = mp:nq")->blue(-1);
        $t5->down;
        $t5->math("\\{therefore}     A:D = ABC:BCD")->red(-1);;
        $t5->math("  and A:D = EGJ:FHK")->red(-1);
        
    };

        
    push @$steps, sub {
        $t5->down;
        $y = $t5->y;
        $t5->fraction_equation("!A/D! = !A/D! \\{times} !B\\{dot}C/B\\{dot}C! = !A/B! ".
        "\\{times} !B/C! \\{times} !C/D!");
    };
       
    push @$steps, sub {
        $t5->y($y);
        $y = $t5->y;
        $t5->fraction_equation("                        = !E/F! \\{times} !G/H! \\{times} !J/K!");
    };

    push @$steps, sub {
        $t5->y($y);
        $t5->fraction_equation("                                    = !E\\{dot}G\\{dot}J/F\\{dot}H\\{dot}K!");
    };


    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t5->erase;
        $t1->title("In other words");
        $t1->explain("The areas of equiangular parallelograms have ratios that equal ".
        "the multiplication of the ratios of their sides (compounded ratio)");
        
        $p{A} = Point->new($pn,@A)->label("A","top");
        $p{B} = Point->new($pn,@B)->label("B","bottom");
        $p{C} = Point->new($pn,@C)->label("C","bottomleft");
        $p{D} = Point->new($pn,@D)->label("D","top");
        $p{E} = Point->new($pn,@E)->label("E","bottom");
        $p{F} = Point->new($pn,@F)->label("F","bottom");
        $p{G} = Point->new($pn,@G)->label("G","right");
        
        $t{A} = Polygon->join(4,$p{A},$p{B},$p{C},$p{D})->fill($colour1);
        $t{C} = Polygon->join(4,$p{C},$p{E},$p{F},$p{G})->fill($colour2);
        
        ($l{AB},$l{BC},$l{CD},$l{AD}) = $t{A}->lines;
        ($l{CE},$l{EF},$l{FG},$l{CG}) = $t{C}->lines;
        
        $a{C1} = Angle->new($pn,$l{CD},$l{BC})->label("\\{alpha}",20);
        $a{C2} = Angle->new($pn,$l{CE},$l{CG})->label("\\{alpha}",20);
        
        $t3->math("\\{square}AC:\\{square}CF =  (BC\\{dot}CD):(CG\\{dot}CE)");
    
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof");
        $t3->erase;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the parallelograms be placed so that BC is in a straight line with CG ".
        "therefore DC is also in a straight line with CE");
        $l{BC}->red;
        $l{CG}->red;
        $l{CD}->red;
        $l{CE}->red;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw the parallelogram DG");
        $l{BC}->normal;
        $l{CG}->normal;
        $l{CD}->normal;
        $l{CE}->normal;
        $p{H} = Point->new($pn,@H)->label("H","top");
        $t{D} = Polygon->join(4,$p{D},$p{C},$p{G},$p{H})->fill($colour3);
        $Shape::NoAnimation = 0;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Define an arbitrary line K, and draw another line L such ".
        "that the ratio as BC is to CG so is K to L (VI.12)");
        $p{K} = Point->new($pn,@K)->label("K","left");
        $l{K} = Line->new($pn,@K,$K[0]+200,$K[1]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{L} = Point->new($pn,@L)->label("L","left");
        $l{L} = Line->fourth_proportional($l{BC},$l{CG},$l{K},$p{L},0);
        $t3->math("K:L = BC:CG");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw another line M such that the ratio as DC is to CE so is L to M (VI.12)");
        $p{M} = Point->new($pn,@M)->label("M","left");
        $l{M} = Line->fourth_proportional($l{CD},$l{CE},$l{L},$p{M},0);
        $t3->math("L:M = CD:CE");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("K to M is the compounded ratio of K to L and L to M, therefore it is ".
        "also equal to the compound ratio of the sides, BC to CG and CD to CE");
        $t3->math("K:M = (BC\\{dot}CD):(CG\\{dot}CE)");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..20]);
        $t1->explain("The ratio of the sides BC to CG is equal to the ratio of the ".
        "parallelograms AC,CH (VI.1)");
        $t{C}->grey;
        $t3->math("BC:CG = \\{square}AC:\\{square}CH");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..20]);
        $t1->explain("But K to L is also equal to BC to CG, so K to L is equal to the ".
        "ratio of the parallelograms AC,CH (V.11)");
        $t3->black([0,-1]);
        $t3->math("K:L   = \\{square}AC:\\{square}CH");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..20]);
        $t1->explain("The ratio of the sides DC to CE is equal to the ratio of the ".
        "parallelograms CH,CF (VI.1)");
        $t{C}->normal;
        $t{A}->grey;
        $t3->math("CD:CE = \\{square}CH:\\{square}CF");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..20]);
        $t1->explain("Therefore L to M is equal to the ratio of the ".
        "parallelograms CH,CF (V.11)");
        $t3->black([1,5]);
        $t3->math("L:M   = \\{square}CH:\\{square}CF");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{A}->normal;
        $t{D}->grey;
        $t1->explain("Comparing the ratios of K to L and L to M it can be seen that the ratio ".
        "K to M is equal (ex aequali) to the ratio of the parallelograms AC to CF (V.22)");
        $t3->grey([0..20]);
        $t3->black([4,6]);
        $t3->math("K:M   = \\{square}AC:\\{square}CF");        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But K to M is equal to the compound ratio of the sides, therefore ".
        "the compound ratio of the sides is also equal to the ratio of the parallelograms");
        $t3->grey([0..20]);
        $t3->black([2,-1]);
        $t2->math("\\{square}AC:\\{square}CF = (BC\\{dot}CD):(CG\\{dot}CE)")
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey([0..20]);
    };
    
    return $steps;

}

