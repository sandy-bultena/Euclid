#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
    "Given two straight lines constructed from the ends of a straight "
  . "line and meeting in a point, there cannot be constructed from the "
  . "ends of the same straight line, and on the same side of it, two "
  . "other straight lines meeting in another point and equal to the former "
  . "two respectively, namely each equal to that from the same end.";

my $pn = PropositionCanvas->new( -number => 7, -title => $title );
Proposition::init($pn);
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 500, 330 );

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,7);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #7
# ============================================================================
sub explanation {

    my ( %l, %p, %c, %a, %t );
    my @objs;

    my @B = ( 450, 650 );
    my @A = ( 200, 650 );
    my @C = ( 280, 270 );
    my @D = ( 400, 270 );
    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a triangle ABC");
        $t1->explain(   "There is a unique point C where the sides of "
                      . "the triangle, AC and BC, meet" );

        $p{A} = Point->new( $pn, @A )->label( "A", "bottom" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $t{ABC} = Triangle->new( $pn, @A, @B, @C, 1,
                            -labels => [ undef, undef, qw(r2 right r1 left) ] );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t1->explain(   "Assume there is a point D where AD is equal in "
                      . "length to AC and BD is equal in length to BC" );
        $t1->explain("Create triangle ABD");

        $t{ABD} = Triangle->new( $pn, @A, @B, @D, 1,
                           -labels => [ undef, undef, qw(r2 right r1 left) ], );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $t2->math("AC = AD = r1");
        $t2->math("BC = BD = r2");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Construct line CD, thus creating triangles ACD and BCD");

        $l{CD} = Line->new( $pn, @C, @D );
        $t{ABC}->grey;
        $t{ABD}->grey;
        $t{CAD} = Triangle->assemble( $pn,
                          -lines => [ $t{ABC}->l(3), $t{ABD}->l(3), $l{CD}, ] );
        $t{CBD} = Triangle->assemble( $pn,
                          -lines => [ $t{ABC}->l(2), $t{ABD}->l(2), $l{CD}, ] );
        $t{CAD}->normal;
        $t{CBD}->normal;
        my @pn = $t{ABD}->l(3)->intersect( $t{ABC}->l(2) );
        $t{inner} =
          Triangle->new( $pn, @pn, $p{C}->coords, $p{D}->coords )->fill($teal);
        $t{outer1} =
          Triangle->new( $pn, @pn, $p{D}->coords, $p{B}->coords )->fill($lime_green);
        $t{outer2} =
          Triangle->new( $pn, @pn, $p{C}->coords, $p{A}->coords )->fill($sky_blue);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{CBD}->grey;
        $t{CAD}->normal;
        $t{inner}->grey;
        $t{outer1}->grey;
        $t{outer2}->grey;
        $t{CAD}->fill($sky_blue);
        $t1->explain(   "Triangle ACD is an isosceles triangle by "
                      . "definition, so the base angles must be equal (I.6)" );
        $t{CAD}->set_angles( "\\{alpha}", undef, "\\{alpha}", 55, 0, 20 );
        $t2->allgrey;
        $t2->black(0);
        $t2->math("\\{angle}ACD = \\{angle}CDA = \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{CAD}->grey;
        $t{CBD}->normal;
        $t{CAD}->fill;
        $t{CBD}->fill($lime_green);
        $t1->explain(   "Triangle BCD is an isosceles triangle by definition, "
                      . "so the base angles must be equal (I.6)" );
        $t{CBD}->set_angles( "\\{beta}", undef, "\\{beta}", 20, 0, 55 );
        $t2->allgrey;
        $t2->black(1);
        $t2->math("\\{angle}BCD = \\{angle}CDB = \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{CAD}->normal;
        $t{CBD}->normal;
        $t{CAD}->l(2)->grey;
        $t{CAD}->a(3)->grey;
        $t{CBD}->l(2)->grey;
        $t{CBD}->a(3)->grey;
        $t{CBD}->fill;

        $t1->explain(   "Looking at the figure, we can see that angle DCA "
                      . "(\\{alpha}) is larger that angle DCB (\\{beta})" );

        $t2->allgrey;
        $t2->black( [ 2, 3 ] );
        $t2->math("\\{angle}ACD > \\{angle}BCD");
        $t2->math("  \\{alpha}  >  \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{CAD}->normal;
        $t{CBD}->normal;
        $t{CAD}->l(1)->grey;
        $t{CAD}->a(1)->grey;
        $t{CBD}->l(1)->grey;
        $t{CBD}->a(1)->grey;

        $t1->explain(
            "Similarly, angle CDA (\\{alpha}) is less than angle CDB (\\{beta})"
        );
        $t2->allgrey;
        $t2->black( [ 2, 3 ] );
        $t2->math("\\{angle}CDA < \\{angle}CDB");
        $t2->math("  \\{alpha}  <  \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{CAD}->normal;
        $t{CBD}->normal;

        $t1->explain(   "But, since angle CDA is equal to DCA, "
                      . "and angle DCB is equal to angle CDB "
                      . "we have CDA simultaneously bigger and less than DBC" );
        $t1->explain("This is impossible");
        $t2->allgrey;
        $t2->red( [ 5, 7 ] );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{ABC} = Triangle->new(
                               $pn, @A, @B, @C, -1,
                               -points => [qw(A bottom B bottom C top)],
                               -labels => [ undef, undef, qw(r2 right r1 left) ]
        );
        $t{CAD}->grey;
        $t{CBD}->grey;

        $t1->explain(   "Thus, we have demonstrated that point D "
                      . "cannot exist, and the point C is unique." );
        $t2->allgrey;
    };

    # -------------------------------------------------------------------------

    return \@steps;
}

