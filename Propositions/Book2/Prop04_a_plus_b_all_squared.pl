#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If a straight line be cut at random, the square on the whole is equal to "
  . "the squares on the "
  . "segments and twice the rectangle contained by the segments.";

$pn->title( 4, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 500, 200 );
my $t2 = $pn->text_box( 200, 490 );
my $t3 = $pn->text_box( 200, 490 );

my $steps;
push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 4 );
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
    my ( %l, %p, %c, %s, %a );

    my @A = ( 200, 200 );
    my @B = ( 450, 200 );
    my @C = ( 350, 200 );

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Let AB be a straight line, arbitrarily cut at point C");
        $p{A} = Point->new( $pn, @A )->label(qw(A left));
        $p{B} = Point->new( $pn, @B )->label(qw(B right));
        $l{A} = Line->new( $pn, @B, @A );
        $l{a} = Line->new( $pn, @A, @C, -1 )->label(qw(x top));
        $l{b} = Line->new( $pn, @C, @B, -1 )->label(qw(y top));
        $p{C} = Point->new( $pn, @C )->label(qw(C top));
        $t3->math("AB = AC + CB");
        $t3->allblue;
        $t2->y( $t3->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Then the square formed by line AB is equal in "
                      . "area to the sum of the squares "
                      . "formed by line CB and AC, plus twice the area of "
                      . "the rectangles formed by "
                      . "lines AC and CB" );
        $t3->math(
               "AB\\{dot}AB = AC\\{dot}AC + CB\\{dot}CB + 2\\{dot}AC\\{dot}CB");
        $t3->math("(x+y)\\{squared} =  x\\{squared} + y\\{squared} + 2xy");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase;
        $t3->math("AB = AC + CB");
        $t3->allblue;
        $t1->erase;
        $t5->erase;
        $t1->title("Proof:");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw a square ADEB on the line AB\\{nb}(I.46), "
                      . "and draw the diagonal  BD" );
        $l{a}->remove;
        $l{b}->remove;
        $s{AB} = Square->new( $pn, $p{B}->coords, $p{A}->coords );
        $s{AB}->p(1)->label(qw(E right));
        $s{AB}->p(4)->label(qw(D bottom));
        $p{D}  = $s{AB}->p(4);
        $p{E}  = $s{AB}->p(1);
        $l{BD} = Line->join( $p{B}, $p{D} );
        $t5->math("AB = BD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw a line CF parallel to either "
                      . "AD or BE\\{nb}(I.31), labelling the intersection "
                      . "with the diagonal as G." );

        $l{Ct} = $s{AB}->l(3)->parallel( $p{C} );
        $l{Ct}->prepend(100);
        $p{F} =
          Point->new( $pn, $l{Ct}->intersect( $s{AB}->l(4) ) )
          ->label(qw(F bottom));
        $l{C} = Line->join( $p{C}, $p{F}, -1 );
        $l{Ct}->remove();
        $p{G} =
          Point->new( $pn, $l{C}->intersect( $l{BD} ) )->label(qw(G topleft));

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                 "Draw a line parallel to AB through the point G\\{nb}(I.31).");

        $l{Gt} = $l{A}->parallel( $p{G} );
        $l{Gt}->prepend(100);
        $l{Gt}->extend(100);
        $p{H} =
          Point->new( $pn, $l{Gt}->intersect( $s{AB}->l(3) ) )
          ->label(qw(H left));
        $p{K} =
          Point->new( $pn, $l{Gt}->intersect( $s{AB}->l(1) ) )
          ->label(qw(K right));
        $l{G} = Line->join( $p{H}, $p{K}, -1 );
        $l{Gt}->remove();

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->y( $t1->y );
        $t4->explain( "Since BD crosses two parallel lines, (AD and CF), "
            . "then the exterior angle is equal to "
            . "the interior and opposite angle\\{nb}(I.29)"
        );
        
        $t5->math("\\{angle}CGB = \\{angle}ADB");

        $l{A}->remove();
        $s{AB}->l(2)->grey;
        $s{AB}->l(4)->grey;
        $s{AB}->l(1)->grey;
        $l{G}->grey;

        $l{vCG} = VirtualLine->new( $p{G}->coords, $p{C}->coords );
        $l{vGB} = VirtualLine->new( $p{G}->coords, $p{B}->coords );
        $l{vDB} = VirtualLine->new( $p{D}->coords, $p{B}->coords );
        $l{vAD} = VirtualLine->new( $p{A}->coords, $p{D}->coords );

        $a{CGB} =
          Angle->new( $pn, $l{vGB}, $l{vCG} )->label( qw(\\{alpha}), 20 );
        $a{ADB} = Angle->new( $pn, $l{vDB}, $l{vAD} )->label(qw(\\{alpha}));
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "Since triangle ABD is an isosceles triangle, "
                      . "then the angles at the base are also equal\\{nb}(I.5)");

        $l{C}->grey;
        $s{ABD} =
          Polygon->new( $pn, 3, $p{B}->coords, $p{A}->coords, $p{D}->coords,
                        -1 )->fill($sky_blue);
        $a{ABD} =
          Angle->new( $pn, $s{AB}->l(2), $l{BD} )->label( qw(\\{alpha}), 20 );
        $t5->math("\\{angle}ADB\\{nb}=\\{nb}\\{angle}ABD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "Since triangle BCG has two equal angles, it is an "
                      . "isosceles triangle\\{nb}(I.6), therefore the sides "
                      . "of the triangle are equal" );
        $t3->math("CG = CB");

        $l{BD}->grey;
        $s{AB}->l(3)->grey;
        $s{ABD}->remove();
        $s{BCG} =
          Polygon->new( $pn, 3, $p{B}->coords, $p{C}->coords, $p{G}->coords,
                        -1 )->fill($sky_blue);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "CB and GK are parallel,CG and BK are parallel, "
                      . "so the opposite sides equal on another\\{nb}(I.34), "
                      . "and since CB equals CG, all sides are equal, "
                      . "therefore CK is an equilateral" );

        $a{CGB}->remove;
        $a{ADB}->remove;
        $a{ABD}->remove;

        $s{BCG}->remove();
        $s{CGKB} =
          Polygon->new( $pn, 4, $p{C}->coords, $p{G}->coords, $p{K}->coords,
                        $p{B}->coords, -1 )->fill($sky_blue);

        $t2->y( $t3->y );
        $t2->math(
             "CB\\{parallel}GK, CG\\{parallel}BK   \\{therefore} CB=GK, CG=BK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                     "Since CG is parallel to BK, then the sum of the interior "
                       . "angles is two right angles\\{nb}(I.29)" );
        $t4->explain(   "We know that angle CBK is right, so then "
                      . "angle BCG is also right." );

        $t5->math("CBK = BCG = \\{right}");
        $s{CGKB}->l(2)->grey;
        $s{CGKB}->fill;
        $a{B} =
          Angle->new( $pn, $s{CGKB}->l(4), $s{CGKB}->l(3) )
          ->label(qw(\\{theta}));
        $a{C} =
          Angle->new( $pn, $s{CGKB}->l(1), $s{CGKB}->l(4) )
          ->label(qw(\\{beta}));

        $t2->math(   "\\{beta} + \\{theta} = \\{right}+\\{right},  "
                   . "\\{theta}=\\{right}  \\{therefore} \\{beta}=\\{right}" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
                "The angles opposite one another are equal in a parallelogram, "
                  . "so the other two angles are right "
                  . "angles as well\\{nb}(I.34)." );
        $t4->explain("So CK is a square, equal to the square of CB");

        $s{CGKB}->l(2)->normal;
        $s{CGKB}->fill($sky_blue);
        $a{G} = Angle->new( $pn, $s{CGKB}->l(2), $s{CGKB}->l(1) );
        $a{K} = Angle->new( $pn, $s{CGKB}->l(3), $s{CGKB}->l(2) );
        $a{B}->label;
        $a{C}->label;
        $t2->erase;
        $t3->math("\\{square}CK = CB\\{dot}CB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t5->erase;
        $t4->y( $t1->y );
        $t4->explain("Similarly, HDFG is a square, equal to the square of AC");

        $a{B}->remove();
        $a{C}->remove();
        $a{K}->remove();
        $a{G}->remove();
        $s{CGKB}->grey();
        $s{HDFG} =
          Polygon->new( $pn, 4, $p{H}->coords, $p{D}->coords, $p{F}->coords,
                        $p{G}->coords, -1 )->fill($pale_pink);

        $t3->allgrey;
        $t3->math("\\{square}HF = AC\\{dot}AC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain( "Rectangles AG and GE are equal (complements "
               . "of a parallelogram)\\{nb}(I.43), "
               . "and are equal to the rectangle formed from lines AC and CB" );

        $s{AHGC} =
          Polygon->new( $pn, 4, $p{A}->coords, $p{H}->coords, $p{G}->coords,
                        $p{C}->coords, -1 )->fill($lime_green);
        $s{GFEK} =
          Polygon->new( $pn, 4, $p{G}->coords, $p{F}->coords, $p{E}->coords,
                        $p{K}->coords, -1 )->fill($lime_green);
        $s{HDFG}->grey;
        $t3->allgrey;
        $t3->black(1);
        $t3->math("\\{square}AG = \\{square}GE");
        $t3->math("\\{square}AG = AC\\{dot}CG = AC\\{dot}CB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("The sum of all the rectangles equals the square on AB");

        $s{HDFG}->normal;
        $s{HDFG}->fill($pale_pink);
        $s{CGKB}->normal;
        $s{CGKB}->fill($sky_blue);
        $t3->allgrey;
        $t3->black( [ 2 .. 5 ] );
        $t3->math(   "\\{square}AE = \\{square}CK + \\{square}HF "
                   . "+ \\{square}AG + \\{square}GE" );
        $t3->math(
               "AB\\{dot}AB = CB\\{dot}CB + AC\\{dot}AC + 2\\{dot}AC\\{dot}CB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
        $t3->blue(0);
    };

    return $steps;

}

