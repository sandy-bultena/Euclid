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
my $title = "If four straight lines be proportional, the rectangle contained ".
"by the extremes is equal to the rectangle contained by the means; and, if the ".
"rectangle contained by the extremes be equal to the rectangle contained by ".
"the means, the four straight lines will be proportional.";

$pn->title( 16, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 16 );
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
    my $yh = 300;
    my $yb = 380;
    my $dx1 = 200;
    my $dx2 = 100;
    my $xs = 100;
    my $k = 1.2;
    
    my @A = ($xs,$yh);
    my @B = ($xs+$dx1,$yh);
    my @C = ($B[0]+$off,$yh);
    my @D = ($C[0]+$dx1/$k,$yh);
    my @E = ($xs,$yb,$xs + $dx2,$yb);
    my @F = ($C[0],$yb,$C[0]+$dx2/$k,$yb);
    my @G = ($A[0],$A[1]-($F[2]-$F[0]),$B[0],$B[1]-($F[2]-$F[0]));
    my @H = ($C[0],$C[1]-($E[2]-$E[0]),$D[0],$D[1]-($E[2]-$E[0]));
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given four lines AB, CD, E and F that are proportional, ".
        "AB is to CD as E is to F");
        $t1->explain("Then the product of AB, F is equal to the product CD, E");
        $t1->down;
        $t1->explain("And the inverse");
        $p{A} = Point->new($pn,@A[0,1])->label("A","bottom");
        $p{B} = Point->new($pn,@B[0,1])->label("B","bottom");
        $p{C} = Point->new($pn,@C[0,1])->label("C","bottom");
        $p{D} = Point->new($pn,@D[0,1])->label("D","bottom");
        $p{E} = Point->new($pn,@E[0,1])->label("E","bottom");
        $p{F} = Point->new($pn,@F[0,1])->label("F","bottom");
        $l{AB} = Line->new($pn,@A,@B);
        $l{CD} = Line->new($pn,@C,@D);
        $l{E} = Line->new($pn,@E);
        $l{F} = Line->new($pn,@F);
        $t{ABG} = Polygon->new($pn,4,@A,@G,@B)->fill($sky_blue);
        $t{CDH} = Polygon->new($pn,4,@C,@H,@D)->fill($lime_green);
        $t{ABG}->remove();
        $t{CDH}->remove();        
        
        
        $t3->math("AB:CD = E:F")->blue;
        $t3->math("\\{then} AB\\{dot}F = CD\\{dot}E");
        $t3->down;
        $t3->math("AB\\{dot}F = E\\{dot}CD")->blue(2);
        $t3->math("\\{then} AB:CD = E:F");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof (Part 1)");
        $t3->erase;
        $t3->math("AB:CD = E:F")->blue;
    };
    
    push @$steps, sub {
        $t1->explain("Copy the line F to line AB, perpendicular to line AB");
        ($l{AG},$p{G}) = $l{F}->copy($p{A},-1);
        $t3->math("AG = F, AG \\{perp} AB");
        $l{AG}->rotateTo(90);
        $p{G}->remove;
        $p{G} = Point->new($pn,$l{AG}->end)->label("G","top");
    };

    push @$steps, sub {
        $t1->explain("Copy the line E to line CD, perpendicular to line CD");
        ($l{CH},$p{H}) = $l{E}->copy($p{C},-1);
        $t3->math("CH = E, CH \\{perp} CD");
        $l{CH}->rotateTo(90);
        $p{H}->remove;
        $p{H} = Point->new($pn,$l{CH}->end)->label("H","top");
    };

    push @$steps, sub {
        $t1->explain("Finish the rectangles");
        $t{ABG}->draw->fill($sky_blue);
        $t{CDH}->draw->fill($lime_green);
    };

    push @$steps, sub {
        $t1->explain("Thus the sides of the rectangles (parallelograms) are ".
        "inversely proportional");
        $t3->math("AB:CD = CH:AG");
    };

    push @$steps, sub {
        $t1->explain("Rectangles BG and DH are equiangular parallelograms "
        ."where the sides are reciprocally ".
        "proportional around the equal angle");
        $t1->explain("Therefore, the rectangles BG and DH are equal (VI.14)");
        $t3->math("\\{square}BG = \\{square}DH");
    };

    push @$steps, sub {
        $t1->explain("And since AG equals F, and CH equals E, then the rectangles ".
        "BG and DH are equal to the rectangles formed from AB,F and CD,E");
        $t3->math("\\{square}BG = AB\\{times}F");
        $t3->math("\\{square}DH = CD\\{times}E");
        $t3->down;
    };

    push @$steps, sub {
        $t1->explain("Thus, the rectangle formed by AB.F is equal the rectangle formed by CD,E");
        $t3->math("AB\\{times}F = CD\\{times}E");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof (Part 2)");
        $t3->erase;
        $t3->math("AB\\{times}F = CD\\{times}E")->blue;
        $t1->explain("Copy the line F to line AB, perpendicular to line AB");
        $t1->explain("Copy the line E to line CD, perpendicular to line CD");
        $t1->explain("Finish the rectangles");
        $t3->math("AG = F, AG \\{perp} AB");
        $t3->math("CH = E, CH \\{perp} CD");
    };

    push @$steps, sub {
        $t1->explain("Since AG,F are equal, and CH,E are equal, the rectangles ".
        "BG and DH are equiangular, the areas are also equal");
       $t3->math("\\{square}BG = AB\\{times}F");
        $t3->math("\\{square}DH = CD\\{times}E");
        $t3->math("\\{square}BG = \\{square}DH");
    };

    push @$steps, sub {
        $t1->explain("Equal and equiangular parallelograms the sides about the equal are ".
        "reciprocally proportional (VI.14)");
        $t1->explain("Therefore AB is to CD as CH is to AG");
        
        $t3->math("AB:CD = CH:AG");
    };

    push @$steps, sub {
        $t1->explain("But CH,E are equal, and AG,F are equal, therefore AB is to CD as E is to F");
        $t3->down;
        $t3->math("AB:CD = E:F");
    };

    return $steps;

}

