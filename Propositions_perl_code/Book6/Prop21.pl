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
my $title = "Figures which are are similar to the same rectilineal ".
"figure are also similar to one another.";

$pn->title( 21, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 450 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 21 );
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
    my $yoff = 200;
    my $yh = 150;
    my $ym = 200;
    my $yb = 380;
    my $dx1 = 180;
    my $dx2 = -10;
    my $dx3 = -50;
    my $dx4 = 20;
    my $xs = 150;
    my $k = 1/1.5;
    
    my @A = ($xs,$yb);
    my @B = ($A[0]+$dx1,$yb);
    my @C = ($B[0]+$dx2,$ym);
    my @D = ($A[0]+$dx3,$yh);
    
    my @E = ($B[0]+$off,$yb);
    my @F = ($E[0]+$k*$dx1,$yb);
    my @G = ($F[0]+$k*$dx2,$yb+$k*($ym-$yb));
    my @H = ($E[0]+$k*$dx3,$yb+$k*($yh-$yb));
    
    my @I = ($F[0]+$off,$yb);
    my @J = ($I[0]+$k*$k*$dx1,$yb);
    my @K = ($J[0]+$k*$k*$dx2,$yb+$k*$k*($ym-$yb));
    my @L = ($I[0]+$k*$k*$dx3,$yb+$k*$k*($yh-$yb));

    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;

    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
   #     $t1->down;
        $t1->title("In other words");
        $t1->explain("If polygon A is similar to polygon C, and polygon B is similar to polygon C ".
        "then polygon A is similar to polygon B");

    $t{A} = Polygon->new($pn,4,@A,@B,@C,@D)->label("A");       
    $t{B} = Polygon->new($pn,4,@E,@F,@G,@H)->label("B");       
    $t{C} = Polygon->new($pn,4,@I,@J,@K,@L)->label("C");    
    
    $t3->math("A ~ C");
    $t3->math("B ~ C");
    $t3->down;
    $t3->math("\\{then} A ~ B")->blue([0,1]);   
        
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Proof");
        $t3->erase;
        $t3->math("A ~ C");
        $t3->math("B ~ C")->blue([0,1]);
        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since A is similar to C, it is equiangular with it and the sides about ".
        "equal angles is proportional (VI.1)");
        $t3->math("A\\{_1} :A\\{_2}  = C\\{_1} :C\\{_2} , ...");
        $t3->math("\\{angle}A\\{_1}  = \\{angle}C\\{_1} , ...");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since B is similar to C, it is equiangular with it and the sides about ".
        "equal angles is proportional (VI.1)");
        $t3->math("B\\{_1} :B\\{_2}  = C\\{_1} :C\\{_2} , ...");
        $t3->math("\\{angle}B\\{_1}  = \\{angle}C\\{_1} , ...");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the angles in A and B are equal to C they are equal to each other");
        $t3->grey([2,4]);
        $t3->math("\\{angle}A\\{_1}  = \\{angle}B\\{_1} , ...");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And the sides about equal angles in polygons A and B are also proportional");
        $t3->black([2,4]);
        $t3->grey([3,5,6]);
        $t3->math("A\\{_1} :A\\{_2}  = B\\{_1} :B\\{_2} , ...");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore A is similar to B");
        $t3->grey([2,3,4,5]);
        $t3->black([6]);
        $t3->down;
        $t2->math("A ~ B");
    };
    
    return $steps;

}

