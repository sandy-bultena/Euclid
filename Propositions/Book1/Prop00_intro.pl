#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
Proposition::set_animation(0);
my ( $xc, $yc ) = $pn->center_coords;

# ============================================================================
# Definitions
# ============================================================================
my $t = $pn->text_box( 700, 50, -anchor => "c", -width => 1000 );

my $t1 = $pn->text_box( 400, 150, -width => 800 );
my $t2 = $pn->text_box( $xc, $yc,-anchor=>"c",-width=>1000 );
my $t3 = $pn->text_box( $xc, $yc-200,-anchor=>"c",-width=>1000 );

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, explanation( $pn );
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->go;

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my ( %l, %p, %c );

    my @A = ( 200, 500 );
    my @B = ( 450, 500 );
    my $vert = 150;
    my $x    = 250;

    # -------------------------------------------------------------------------
    # Why
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $pn->clear;
        my $cn = $pn->Tk_canvas;
        $cn->createText( $xc, $yc-300, -text => "Why Study Euclid?", -font => "intro" );
    };

    push @$steps, sub {
        my ( $x, $y ) = $pn->center_coords;
        my $cn = $pn->Tk_canvas;
        $cn->createText( $xc, $yc-200, -text => "Because it's fun!", -font => "intro" );
    };

    push @$steps, sub {
        $t2->title("... and because it teaches one how ".
        "to think logically.");
    };
    
    push @$steps, sub {
        $t2->down;
        $t2->explain("If Euclid did not kindle your youthful enthusiasm, ".
        "you were not born to be a scientific thinker.");
        $t2->explain("       Albert Einstein");
    };
    
    
    # -------------------------------------------------------------------------
    # What
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $pn->clear;
        my $cn = $pn->Tk_canvas;
        $cn->createText( $xc, $yc-300, -text => "What will we do?", -font => "intro" );
    };

    push @$steps, sub {
        $t2->erase;
        $t3->title("From a simple set of five initial rules (postulates),");
        $t3->down;
        $t3->title("we will derive all of the facts (propositions) of ".
        "Euclidean Geometry!");
    };
    
    push @$steps, sub {
        $t3->down;
        $t3->explain("such as:                                    ".
        "                             ");
        $t3->explain("... the area of a triangle is one half ".
        "of the base times the height");
        $t3->down;
        $t3->down;
        $t3->down;
        $t3->math("A = \\{half} b\\{dot}h");
        my $t = Triangle->new($pn,500,400,450,600,650,600);
        $t->l(2)->label("b","bottom");
        my $l = Line->new($pn,500,400,500,600)->grey->label("h","right");
    };
    
    


    # -------------------------------------------------------------------------
    # Euclid's Tools
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $pn->clear;
        my ( $x, $y ) = $pn->center_coords;
        my $cn = $pn->Tk_canvas;
        $cn->createText( $x+50, $y-300, -text => "Tools", -font => "intro" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("1. A straight edge");
    };
    push @$steps, sub {
        Line->new( $pn, $x, $vert, $x + 100, $vert );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("2. A compass");
    };

    push @$steps, sub {
        Point->new($pn,$x,$vert+150);
        Circle->new( $pn, $x, $vert + 150, $x + 100, $vert + 150 );
    };

    # ========================================================================
    # Postulates (Axioms)
    # ========================================================================
    push @$steps, sub {
        $pn->clear;
        my $cn = $pn->Tk_canvas;
        $cn->createText( $xc, $yc-300, -text => "Postulates (Axioms)", -font => "intro" );  
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("1. To draw a straight line from any point to any point");
        $vert = 150 + 27;
        Point->new( $pn, $x - 100, $vert );
        Point->new( $pn, $x + 100, $vert );
    };

    push @$steps, sub {
        Line->new( $pn, $x - 100, $vert, $x + 100, $vert );
        $vert += 27;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "2. To produce a finite straight line continuously "
              . "in a straight line" );
        $l{a} = Line->new( $pn, $x - 175, $vert, $x - 100, $vert );
    };

    push @$steps, sub {
        $l{a}->prepend(50);
    };

    push @$steps, sub {
        $l{a}->extend(200);
        $vert += 27;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("3. To describe a circle with any centre and distance");
        $p{c1} = Point->new( $pn, $x, $vert + 100 );
        $l{r1} =
          Line->new( $pn, $x, $vert + 100, $x + 100, $vert + 100 )
          ->label(qw(r1 bottom));
        $p{c2} = Point->new( $pn, $x - 150, $vert + 150 );
        $l{r2} =
          Line->new( $pn, $x - 150, $vert + 150, $x - 100, $vert + 150 )
          ->label(qw(r2 bottom));
    };

    push @$steps, sub {
        Circle->new( $pn, $l{r1}->endpoints );
    };

    push @$steps, sub {
        Circle->new( $pn, $l{r2}->endpoints );
        $vert += 27;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("4. That all right angles are equal to one another");
        my @p = CalculatePoints->right_triangle( $x - 150, $vert + 350,
            $x, $vert + 300, 75 );
        $l{r1} = Line->new( $pn, @p[ 0 .. 3 ] );
        $l{r2} = Line->new( $pn, @p[ 2 .. 5 ] );
        Angle->new( $pn, $l{r2}, $l{r1} );

        @p = CalculatePoints->right_triangle( $x + 100, $vert + 150,
            $x, $vert + 250, 75 );
        $l{r3} = Line->new( $pn, @p[ 0 .. 3 ] );
        $l{r4} = Line->new( $pn, @p[ 2 .. 5 ] );
        Angle->new( $pn, $l{r4}, $l{r3} );
        $vert += 27;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "5. That, if a straight line falling on two straight lines "
              . "make the interior angles on the same side less "
              . "than two right angles, the two straight lines, "
              . "if produced indefinitely, meet on that "
              . "side on which are the angles less than "
              . "the two right angles" );
        my $x1     = $x + 200;
        my $y1     = $vert + 200;
        my $y2     = $vert + 350;
        my $x2     = $x1 + 100;
        my $x3     = $x1 + 300;
        my $deltay = 65;
        my $deltax = 25;

        $l{p1} = VirtualLine->new( $x1, $y1, $x3, $y1 );
        $l{p2} = VirtualLine->new( $x1, $y2, $x3, $y2 - $deltay );
        $l{s1} = VirtualLine->new( $x2, $y1 - 50, $x2 - $deltax, $y2 + 50 );

        my @p1 = $l{p1}->intersect( $l{s1} );
        my @p2 = $l{p2}->intersect( $l{s1} );

        $l{p11} = Line->new( $pn, $x1,    $y1,      $p1[0], $p1[1] );
        $l{p12} = Line->new( $pn, $p1[0], $p1[1],   $x3,    $y1 );
        $l{p21} = Line->new( $pn, $x1,    $y2,      $p2[0], $p2[1] );
        $l{p22} = Line->new( $pn, $p2[0], $p2[1],   $x3,    $y2 - $deltay );
        $l{s11} = Line->new( $pn, $x2,    $y1 - 50, $p1[0], $p1[1] );
        $l{s12} = Line->new( $pn, $p1[0], $p1[1],   $p2[0], $p2[1] );
        $l{s13} = Line->new( $pn, $p2[0], $p2[1], $x2 - $deltax, $y2 + 50 );
        Angle->new( $pn, $l{p22}, $l{s12}, -size => 20 )->label("\\{beta}");
        Angle->new( $pn, $l{s12}, $l{p12}, -size => 20 )->label("\\{alpha}");
        my $t3 = $pn->text_box( $p1[0]+75, $p1[1]+50, -width => 300 );
        $t3->math("\\{alpha}+\\{beta} < 180\\{degrees}");
    };

    push @$steps, sub {
        $l{p12}->extend(600);
        $l{p22}->extend(600);
    };

    # ========================================================================
    # Common Notions
    # ========================================================================
    push @$steps, sub {
        $pn->clear;
        my $cn = $pn->Tk_canvas;
        $cn->createText( $xc, $yc-300, -text => "Common Notions", -font => "intro" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->down;
        $t1->explain( "1. Things that are equal to the same thing "
              . "are also equal to one another" );
    };

    push @$steps, sub {
        $t1->math("A = B    C = B   \\{therefore} A = C");
        $t1->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("2. If equals be added to equals, the wholes are equal");
    };

    push @$steps, sub {
        $t1->math("A = B  then   A + C = B + C");
        $t1->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "3. If equals be subtracted from equals, the "
              . "remainders are equal" );
    };

    push @$steps, sub {
        $t1->math("A = B  then   A - C = B - C");
        $t1->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "4. Things which coincide with one another, "
              . "equal one another" );
    };

    push @$steps, sub {
        Line->new( $pn, $t1->x + 25, $t1->y, $t1->x + 350, $t1->y );
    };

    push @$steps, sub {
        Line->new( $pn, $t1->x + 25, $t1->y, $t1->x + 350, $t1->y );
        $t1->down;
        $t1->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("5. The whole is greater than the part");
    };

    push @$steps, sub {
        $t1->math("A > A - C");
        $t1->down;
    };

    return $steps;

}

