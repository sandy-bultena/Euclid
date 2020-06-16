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
"Given a segment of a circle, to describe the complete circle of which it is a segment.";

$pn->title( 25, $title, 'III' );
my $t1  = $pn->text_box( 820, 150, -width => 500 );
my $t4  = $pn->text_box( 800, 150, -width => 480 );
my $t3  = $pn->text_box( 560, 220 );
my $t31 = $pn->text_box( 250, 130, -width => 240 );
my $t32 = $pn->text_box( 360, 380 );
my $t33 = $pn->text_box( 670, 680 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 25 );
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

    my @c1 = ( 220, 180 );
    my $r1 = 150;
    my @c2 = ( 320, 400 );
    my $r2 = 150;
    my @c3 = ( 520, 600 );
    my $r3 = 150;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("In other words");
        $t4->explain(
            "From a given segment ABC, find the radius and centre of the circle"
        );

        $c{1} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $c{2} = Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] )->grey;
        $c{3} = Circle->new( $pn, @c3, $c3[0] + $r3, $c3[1] )->grey;

        $p{A1} = $c{1}->point( 90 + 40 )->label( "A", "top" );
        $p{C1} = $c{1}->point( -90 - 40 )->label( "C", "bottom" );

        $p{A2} = $c{2}->point(90)->label( "A", "top" );
        $p{C2} = $c{2}->point(-90)->label( "C", "bottom" );

        $p{A3} = $c{3}->point(50)->label( "A", "top" );
        $p{C3} = $c{3}->point(-50)->label( "C", "bottom" );

        $a{1} =
          Arc->new( $pn, $r1, $p{A1}->coords, $p{C1}->coords )
          ->label( "B", "left" );
        $l{1} = Line->join( $p{A1}, $p{C1} );
        $c{1}->remove;

        $a{2} =
          Arc->new( $pn, $r2, $p{A2}->coords, $p{C2}->coords )
          ->label( "B", "left" );
        $l{2} = Line->join( $p{A2}, $p{C2} );
        $c{2}->remove;

        $a{3} =
          Arc->newbig( $pn, $r3, $p{A3}->coords, $p{C3}->coords )
          ->label( "B", "left" );
        $l{3} = Line->join( $p{A3}, $p{C3} );
        $c{3}->remove;

    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->title("Construction");
    };

    push @$steps, sub {
        $t4->explain("Bisect line AC at point D");
        $p{D1} = $l{1}->bisect()->label( "D  ",  "bottom" );
        $p{D2} = $l{2}->bisect()->label( "   D", "bottom" );
        $p{D3} = $l{3}->bisect()->label( "   D", "bottom" );
        $t3->math("AD = DC");
        $t3->allblue;
    };

    push @$steps, sub {
        $t4->explain(   "Draw line perpendicular to AC from D, "
                      . "intersecting the circumference at point B" );

        $l{x}   = $l{1}->perpendicular( $p{D1} );
        $p{B1}  = $c{1}->point(180)->label( "B", "left" );
        $l{BD1} = Line->join( $p{B1}, $p{D1} );
        $l{x}->remove;

        $l{x}   = $l{2}->perpendicular( $p{D2} );
        $p{B2}  = $c{2}->point(180)->label( "B", "left" );
        $l{BD2} = Line->join( $p{B2}, $p{D2} );
        $l{x}->remove;

        $l{x}   = $l{3}->perpendicular( $p{D3} );
        $p{B3}  = $c{3}->point(180)->label( "B", "left" );
        $l{BD3} = Line->join( $p{B3}, $p{D3} );
        $l{x}->remove;

    };

    push @$steps, sub {
        $t4->explain("Join points A and B");
        $l{AB1} = Line->join( $p{A1}, $p{B1} );
        $l{AB2} = Line->join( $p{A2}, $p{B2} );
        $l{AB3} = Line->join( $p{A3}, $p{B3} );
    };

    push @$steps, sub {
        $t4->explain("Construct an angle BAE equal to the angle ABD");
        $a{1} = Angle->new( $pn, $l{BD1}, $l{AB1} )->label( "\\{alpha}", 20 );
        $l{1}->grey;
        ( $l{AE1t}, $a{a1} ) = $a{1}->copy( $p{A1}, $l{AB1} );
        $a{a1}->label( "\\{alpha}", 20 );

        $a{2} = Angle->new( $pn, $l{BD2}, $l{AB2} )->label( "\\{alpha}", 30 );
        $l{2}->grey;
        ( $l{AE2t}, $a{a2} ) = $a{2}->copy( $p{A2}, $l{AB2} );
        $a{a2}->label( "\\{alpha}", 30 );

        $a{3} = Angle->new( $pn, $l{BD3}, $l{AB3} )->label( "\\{alpha}", 40 );
        $l{3}->grey;
        ( $l{AE3t}, $a{a3} ) = $a{3}->copy( $p{A3}, $l{AB3} );
        $a{a3}->label( "\\{alpha}", 40 );

        $t3->math("\\{angle}BAE = \\{angle}ABD");
        $t3->allblue;
    };

    push @$steps, sub {
        $t4->explain(   "Extend the angled line and the line BD "
                      . "until they meet at the point E" );

        my @p = $l{AE1t}->intersect( $l{BD1} );
        $p{E1} = Point->new( $pn, @p )->label( "E", "bottom" );
        $l{AE1} = Line->join( $p{A1}, $p{E1} );
        $l{AE1t}->remove;
        $l{DE1} = Line->join( $p{D1}, $p{E1} );

        @p = $l{AE2t}->intersect( $l{BD2} );
        $p{E2} = Point->new( $pn, @p )->label( "E  ", "bottom" );
        $l{AE2} = Line->join( $p{A2}, $p{E2} );
        $l{AE2t}->remove;
        $l{DE2} = Line->join( $p{D2}, $p{E2} );

        @p = $l{AE3t}->intersect( $l{BD3} );
        $p{E3} = Point->new( $pn, @p )->label( "E  ", "bottom" );
        $l{AE3} = Line->join( $p{A3}, $p{E3} );
        $l{AE3t}->remove;
        $l{DE3} = Line->join( $p{D3}, $p{E3} );
    };

    push @$steps, sub {
        $t4->down;
        $t4->explain( "With E as the centre of a circle, and one "
            . "of the three lines (AE, BE, CE) as radius, the circle will be complete"
        );

        $a{a1}->grey;
        $a{1}->grey;
        $a{a2}->grey;
        $a{2}->grey;
        $a{a3}->grey;
        $a{3}->grey;

        $l{BD1}->grey;
        $l{DE1}->grey;
        $l{BD2}->grey;
        $l{DE2}->grey;
        $l{BD3}->grey;
        $l{DE3}->grey;

        $l{AB1}->grey;
        $l{AB2}->grey;
        $l{AB3}->grey;

        $l{AE1}->grey;
        $l{AE2}->grey;
        $l{AE3}->grey;

        $l{1}->normal;
        $l{2}->normal;
        $l{3}->normal;

        $c{1} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $c{2} = Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] )->grey;
        $c{3} = Circle->new( $pn, @c3, $c3[0] + $r3, $c3[1] )->grey;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->erase;
        $t4->title("Proof");

        $a{a1}->normal;
        $a{1}->normal;
        $a{a2}->normal;
        $a{2}->normal;
        $a{a3}->normal;
        $a{3}->normal;

        $l{BD1}->normal;
        $l{DE1}->normal;
        $l{BD2}->normal;
        $l{DE2}->normal;
        $l{BD3}->normal;
        $l{DE3}->normal;

        $l{AB1}->normal;
        $l{AB2}->normal;
        $l{AB3}->normal;

        $l{AE1}->normal;
        $l{AE2}->normal;
        $l{AE3}->normal;

        $l{1}->grey;
        $l{2}->grey;
        $l{3}->grey;

        $c{1}->remove;
        $c{2}->remove;
        $c{3}->remove;
    };

    push @$steps, sub {
        $t4->explain( "Since angles EBA and EAB are equal, the triangle is an "
                      . "isosceles, and the lines AE and BE are equal (I.6)" );
        $s{ABE1} = Triangle->join( $p{A1}, $p{B1}, $p{E1} )->fill($sky_blue);
        $s{ABE2} = Triangle->join( $p{A2}, $p{B2}, $p{E2} )->fill($sky_blue);
        $s{ABE3} = Triangle->join( $p{A3}, $p{B3}, $p{E3} )->fill($sky_blue);
        $t3->math("AE = BE");
    };

    push @$steps, sub {
        $t4->explain("Draw line CE");
        $l{CE1} = Line->join( $p{C1}, $p{E1} );
        $l{CE2} = Line->join( $p{C2}, $p{E2} );
        $l{CE3} = Line->join( $p{C3}, $p{E3} );
    };

    push @$steps, sub {
        $t4->explain("If D and E are not the same point,");
        $t1->y( $t4->y );
        $t1->explain("Consider triangles ADE and ACE");
        $t1->explain( "Two sides are equal, (D bisects AC, and DE is common), "
            . "and the angles ADE and EDC are equal (BD is perpendicular to AC)"
        );
        $t3->allgrey;
        $t3->math("AD = DC");

        $s{ABE1}->remove;
        $s{ADE1} = Triangle->join( $p{A1}, $p{D1}, $p{E1} )->fill($lime_green);
        $s{EDC1} = Triangle->join( $p{D1}, $p{C1}, $p{E1} )->fill($pale_pink);
        $l{AD1} = Line->join( $p{A1}, $p{D1}, -1 );
        $l{DC1} = Line->join( $p{D1}, $p{C1}, -1 );
        $a{a1}->remove;
        $a{1}->remove;
        $a{ADE1} = Angle->new( $pn, $l{DE1}, $l{AD1} )->label( " ", 30 );
        $a{EDC1} = Angle->new( $pn, $l{DC1}, $l{DE1} )->label( " ", 25 );

        $s{ABE3}->remove;
        $s{ADE3} = Triangle->join( $p{A3}, $p{D3}, $p{E3} )->fill($lime_green);
        $s{EDC3} = Triangle->join( $p{D3}, $p{C3}, $p{E3} )->fill($pale_pink);
        $l{AD3} = Line->join( $p{A3}, $p{D3}, -1 );
        $l{DC3} = Line->join( $p{D3}, $p{C3}, -1 );
        $a{a3}->remove;
        $a{3}->remove;
        $a{ADE3} = Angle->new( $pn, $l{AD3}, $l{DE3} )->label( " ", 30 );
        $a{EDC3} = Angle->new( $pn, $l{DE3}, $l{DC3} )->label( " ", 25 );

    };

    push @$steps, sub {
        $t1->explain(   "Therefore the triangles ADE and DEC are equal, "
                      . "and AE equals EC (I.4)" );
        $t3->allgrey;
        $t3->black( [-1] );
        $t3->math("\\{triangle}ADE \\{equivalent} \\{triangle}DEC");
        $t3->math("AE = EC");
    };

    push @$steps, sub {
        $t4->y( $t1->y );
        $t4->explain("If D and E are the same point,");
        $t1->y( $t4->y );
        $t1->explain("AE equals AD, and DC equals EC, so AE equals EC");
        $t4->y( $t1->y );
    };

    push @$steps, sub {
        $t4->explain("The three lines AE, BE, and CE are equal");
        $t3->allgrey;
        $t3->black( [ 2, 5 ] );
    };

    push @$steps, sub {
        $t4->down;
        $t4->explain(   "If more than two EQUAL lines fall from a "
                      . "point within a circle to the "
                      . "circumference of a circle, "
                      . "then that point is the centre\\{nb}(III.9)" );
        $t4->explain(
               "Therefore E is the centre of the circle, and the radius is AE");

        $a{ADE1}->remove;
        $a{EDC1}->remove;
        $s{ADE1}->remove;
        $s{EDC1}->remove;

        $s{ABE2}->remove;
        $a{a2}->remove;
        $a{2}->remove;

        $a{ADE3}->remove;
        $a{EDC3}->remove;
        $s{ADE3}->remove;
        $s{EDC3}->remove;
        $l{BD3}->grey;
        $l{DE3}->grey;
        $l{BE3} = Line->join( $p{B3}, $p{E3}, -1 );

        $l{AB1}->grey;
        $l{AB2}->grey;
        $l{AB3}->grey;

        $l{AD1}->remove;
        $l{AD3}->remove;
        $l{DC1}->remove;
        $l{DC3}->remove;

        $c{1} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $c{2} = Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] )->grey;
        $c{3} = Circle->new( $pn, @c3, $c3[0] + $r3, $c3[1] )->grey;
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );

        $t31->explain("If \\{alpha} > \\{delta}")
          ;
        $t31->explain("then the segment is less than a semicircle");
        $a{ABE} = Angle->new( $pn, $l{BD1}, $l{AB1} )->label( "\\{alpha}", 15 );
        $a{DAB} = Angle->new( $pn, $l{AB1}, $l{1} )->label( "\\{delta}", 30 );
        $c{1}->remove;
        $l{CE1}->grey;
        $l{BD1}->grey;
        $l{DE1}->grey;
        $l{AB1}->grey;
        $l{AE1}->grey;
        $l{1}->normal;
    };

    push @$steps, sub {
        $t32->explain("If \\{alpha} = \\{delta}");
        $t32->explain("then the segment is a semicircle");
        $a{ABE} = Angle->new( $pn, $l{BD2}, $l{AB2} )->label("\\{alpha}");
        $a{DAB} = Angle->new( $pn, $l{AB2}, $l{2} )->label("\\{delta}");
        $c{2}->remove;
        $l{CE2}->grey;
        $l{BD2}->grey;
        $l{DE2}->grey;
        $l{AB2}->grey;
        $l{AE2}->grey;
        $l{2}->normal;
    };

    push @$steps, sub {
        $t33->explain("If \\{alpha} < \\{delta}");
        $t33->explain("then the segment is larger than a semicircle");
        $a{ABE} = Angle->new( $pn, $l{BD3}, $l{AB3} )->label("\\{alpha}");
        $a{DAB} = Angle->new( $pn, $l{AB3}, $l{3} )->label("\\{delta}");
        $c{3}->remove;
        $l{BE3}->grey;
        $l{CE3}->grey;
        $l{BD3}->grey;
        $l{DE3}->grey;
        $l{AB3}->grey;
        $l{AE3}->grey;
        $l{3}->normal;
    };

    return $steps;

}

