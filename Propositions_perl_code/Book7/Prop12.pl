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
my $title = "If there be as many numbers as we please in proportion, then, ".
"as one of the antecedents is to one of the consequents, so are all the ".
"antecedents to all the consequents.";

$pn->title( 12, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $t4 = $pn->text_box( 80, 300);
my $t5 = $pn->text_box( 80, 300);
my $tp = $pn->text_box( 600, 180 );

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 12 );
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
    my (%p,%c,%s,%t,%l);
    my $ds = 80;
    my $dx = 60;
    my $dy = 5;
    my $dx1 = $ds;
    my $dx2 = $ds + $dx;
    my $dx3 = $ds + 2*$dx;
    my $dx4 = $ds + 3*$dx;
    my $dx5 = $ds + 4*$dx;
    my $dx6 = $ds + 5*$dx;
    my $A = 30;
    my $B = 1.4*$A;
    my $C = 1.1*$B;
    my $D = 1.4*$C;
    my $yl = 180+$D*$dy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Definition 20");
        $t1->explain("Numbers are proportional when the first is the same ".
        "multiple, or the same part, or the same parts, of the second that ".
        "the third is of the fourth");
    };

    push @$steps, sub {
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("Given A,B,C,D in proportion (A is to B as C is to D)");
        $t1->explain("The sum of A,C is to the sum of C,D as A is to B");
        $t2->math("A:B = C:D");
        $t2->math("(A+C):(B+D) = A:B");
       $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-$A*$dy)->label("A");
       $l{B} = Line->new($pn,$dx2,$yl,$dx2,$yl-$B*$dy)->label("B");
       $l{D} = Line->new($pn,$dx4,$yl,$dx4,$yl-$D*$dy)->label("D");
       $l{C} = Line->new($pn,$dx3,$yl,$dx3,$yl-$C*$dy)->label("C");
    };
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t2->math("A:B = C:D");
        $t1->down;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("By definition of proportional, whatever part or parts A ".
        "is of B, C is the same part or parts of D (VII Def 20).");
        $t2->math("A = (p/q)\\{dot}B");
        $t2->math("C = (p/q)\\{dot}D");       
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the sum A,C is the same parts or part of the ".
        "the sum B,D (VII.5,6)");
        $t2->grey([0..20]);
        $t2->black([-1,-2]);
        $t2->math("A + C = (p/q)\\{dot}(B + D)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, the sum A,C is to B,D as A is to B (VII Def 20)");
        $t2->grey([0..20]);
        $t2->black([-1,1]);
         $t2->math("(A+C):(B+D) = A:B");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey([0..20]);
        $t2->blue([0,-1]);
    };




    return $steps;

}

