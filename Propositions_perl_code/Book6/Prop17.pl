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
my $title = "If three straight lines be proportional, the rectangle contained ".
"by the extremes is equal to the square on the mean; and, if the rectangle ".
"contained by the extremes be equal to the square on the mean, the three straight ".
"lines will be proportional";

$pn->title( 17, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 17 );
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
    my $off = 100;
    my $yoff = 60;
    my $y0 = 220;
    my $y1 = $y0+$yoff;
    my $y2 = $y1+$yoff;
    my $dx1 = 300;
    my $dx2 = 100;
    my $xs = 100;
    my $k = 1.4;
    
    my @A = ($xs,$y0,$xs+$dx1,$y0);
    my @B = ($xs,$y1,$xs+$dx1/$k,$y1);
    my @C = ($xs,$y2,$xs+$dx1/$k/$k,$y2);
    my @D = ($B[2]+$off,$y1,$B[2]+$off+$dx1/$k,$y1);
    
    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given three lines A,B,C that are proportional, ".
        "A is to B as B is to C");
        $t1->explain("Then the product of A,C is equal to the square of B");
        $t1->down;
        $t1->explain("And the inverse");
        $p{A} = Point->new($pn,@A[0,1])->label("A","left");
        $p{B} = Point->new($pn,@B[0,1])->label("B","left");
        $p{C} = Point->new($pn,@C[0,1])->label("C","left");
        $l{A} = Line->new($pn,@A);
        $l{B} = Line->new($pn,@B);
        $l{C} = Line->new($pn,@C);
        
        $t3->math("A:B = B:C")->blue;
        $t3->math("\\{then} A\\{times}C = B\\{squared}");
        $t3->down;
        $t3->math("A\\{times}C = B\\{squared}")->blue(2);
        $t3->math("\\{then} A:B = B:C");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof (Part 1)");
        $t1->explain("Assume A is to B as B is to C");
        $t3->erase;
        $t3->math("A:B = B:C")->blue;
    };
    
    push @$steps, sub {
        $t1->explain("Let line D be equal to B");
        $l{D} = Line->new($pn,@D);
        $p{D} = Point->new($pn,@D[0,1])->label("D","left");
        $t3->math("D = B");
    };
    
    push @$steps, sub {
        $t1->explain("And since A is to B as B is to C, then A is to B as D is to C");
        $t3->math("A:B = D:C");
    };
    
    push @$steps, sub {
        $t1->explain("If the four lines are proportional, then the rectangles contained ".
        "by A,C will be equal to the rectangle contained by B,D (VI.16)");
        $t3->math("A\\{times}C = B\\{times}D");
    };
    
    push @$steps, sub {
        $t1->explain("Since B equals D, the rectangle formed by B,D is equivalent to the ".
        "square of B");
        $t3->math("A\\{times}C = B\\{times}B = B\\{squared}");        
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof (Part 2)");
        $t1->explain("Assume the rectangle formed by A,C is equal to the square of\\{nb}B");
        $t3->erase;
        $t3->math("A\\{times}C = B\\{squared}")->blue;
        $t1->explain("Let line D be equal to B");
        $t3->math("D = B");
    };
    
    push @$steps, sub {
        $t1->explain("Since B equals D, square of B is equivalent to the ".
        "the rectangle formed by B,D");
        $t3->math("B\\{squared} = B\\{times}B = B\\{times}D");        
    };
    
    push @$steps, sub {
        $t1->explain("Therefore the rectangle contained by A,C is equal to the ".
        "rectangle contained by D,C");
        $t3->math("A\\{times}C = B\\{times}D"); 
    };
    
    push @$steps, sub {
        $t1->explain("If the rectangle contained by the extremes (A,C) ".
        "is equal to the rectangle contained by the means (B,D)...");
        $t1->explain("... then the four lines are proportional (A is to B as D is to C) (VI.16)");
        $t3->math("A:B = D:C");
    };
    
    push @$steps, sub {
        $t1->explain("But B equals D, therefore A is to B as B is to C");
        $t3->down;
        $t3->math("A:B = B:C");
    };
    

    return $steps;

}

