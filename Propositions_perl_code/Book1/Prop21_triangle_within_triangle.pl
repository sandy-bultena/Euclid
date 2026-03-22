#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
    "If from the ends of one of the sides of a triangle two straight lines "
  . "are constructed meeting within the triangle, then the sum of the "
  . "straight lines so constructed is less than the sum of the remaining "
  . "two sides of the triangle, but the constructed straight lines contain "
  . "a greater angle than the angle contained by the remaining two sides.";

my $pn = PropositionCanvas->new( -number => 21, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 375, 200 );
my $t3 = $pn->text_box( 300, 250 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,21);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #21
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @D = ( 215, 400 );
    my @B = ( 25,  600 );
    my @A = ( 200, 200 );
    my @C = ( 400, 600 );
    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a triangle ABC");
        $t{ABC} = Triangle->new(
            $pn, @A, @B, @C, 1,
            -points => [qw(A top B bottom C bottom)],
            -labels => [qw(c1 left a bottom b1 right)]
        );
        $t{ABC}->fill($sky_blue);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("From a point within the triangle ABC...");
        $p{D} = Point->new( $pn, @D );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "... construct a second " . "triangle DBC" );
        $t{DBC} = Triangle->new(
            $pn, @D, @B, @C, 1,
            -points => [qw(D top B bottom C bottom)],
            -labels => [qw(c2 top a bottom b2 right)]
        );
        $t{DBC}->fillover( $t{ABC}, $teal);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "The sum of the lines BD and DC is less than the sum of "
              . "the lines BA and AC, and the angle BDC is greater than angle BAC"
        );
        $t{ABC}->set_angles("\\{alpha}");
        $t{DBC}->set_angles("\\{theta}");
        $t2->math("c1 + b1 > c2 + b2");
        $t2->math("\\{theta} > \\{alpha}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->erase;
        $t1->erase;
        $t1->down;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Extend BD such that it intersects AC at point E");

        $t{ABC}->l(3)->label;
        $t{ABC}->fill;
        $t{DBC}->fill;
        
        $t{ABC}->a(1)->grey;
        $t{ABC}->l(1)->grey;
        $t{ABC}->l(2)->grey;
        $t{DBC}->l(2)->grey;
        $t{DBC}->a(1)->grey;
        $t{DBC}->l(3)->grey;

        # extend line BD, find intersection, and split line
        $l{BX} = $t{DBC}->l(1)->clone->prepend(200);
        my @p = $l{BX}->intersect( $t{ABC}->l(3) );
        $p{E} = Point->new( $pn, @p )->label( "E", "right" );

        ( $l{EX}, $l{BE} ) = $l{BX}->split( $p{E} );
        ( $l{DE}, $l{BD} ) = $l{BE}->clone->split( $t{DBC}->p(1) );

        $l{EX}->grey;

        # split line AC at point E
        $l{AC} = $t{ABC}->l(3)->clone;
        ( $l{CE}, $l{AE} ) = $l{AC}->split( $p{E} );

        # define new triangles
        $t{EDC} =
          Triangle->assemble( $pn,
            -lines => [ $l{DE}, $t{DBC}->l(3), $l{CE} ] );
        $t{EDC}->set_labels( qw(c3 top), undef, undef, qw(b4 right) );

        $t{ABE} = Triangle->assemble(
            $pn,
            -lines  => [ $t{ABC}->l(1), $l{BE}, $l{AE} ],
            -angles => [ $t{ABC}->a(1), undef,  undef ],
        );
        $t{ABE}->set_labels( undef, undef, undef, undef, qw(b3 right) );

        $t2->math("b1 = b3+b4");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{EX}->remove;
        $t1->explain("Consider triangle ABE");
        $t1->explain("The sum of lines AB and AE is greater than BE (I.18)");
        $t{DBC}->grey;
        $t{ABC}->grey;
        $t{EDC}->grey;
        $t{ABE}->normal;
        $t{ABC}->p(1)->normal;
        $t{ABC}->p(2)->normal;
        $t{DBC}->l(1)->normal;
        $t{EDC}->l(1)->normal;
        $t{ABE}->fill($purple);
        $t2->allgrey;
        $t2->math("c1+b3    > c2+c3");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Add length EC to both each part of the inequality");
        $t{EDC}->l(3)->normal;
        $t{ABC}->p(3)->normal;
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("c1+b3+b4 > c2+c3+b4");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->black([0,-1]);
        $t2->math("c1+b1    > c2+c3+b4");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Consider triangle DEC");
        $t1->explain("The sum of lines DE and EC is greater than CD (I.18)");
        $t{ABE}->grey;
        $p{D2} = Point->new($pn, @D)->label("D","top");
        $t{DBC}->l(1)->grey;
        $l{BD}->grey;
        $t{EDC}->normal->fill($pale_pink);
        $t2->allgrey;
        $t2->math("              c3+b4 >    b2");
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Add BD to both sides of the inequality");
        $l{BD}->normal;
        $t{DBC}->l(1)->normal;
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("           c2+c3+b4 > c2+b2");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Thus, the sum of AB and AC is greater than the sum of "
              . "DB and DC" );
        $t{ABE}->grey;
        $t{EDC}->grey;
        $t{ABC}->normal;
        $t{DBC}->normal;
        $t2->allgrey;
        $t2->black([-1,-3]);
        $t{ABC}->l(3)->label( "b1", "right" );
        $t2->math("c1+b1    >            c2+b2 ");
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->black([-1]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t2->down;
        $t1->explain( "Angle BDC is an exterior angle to triangle DCE, hence "
              . "it is larger than the angle DEC (I.16)" );
        $t{ABE}->grey;
        $t{ABC}->grey;
        $t{DBC}->grey;
        $t{EDC}->normal->remove_labels;
        $t{EDC}->fill($pale_pink);
        $t{DBC}->a(1)->normal;
        $t{EDC}->set_angles( "\\{epsilon}", undef, undef, 20, 0, 0 );
        $t{ABC}->p(1)->normal;
        $t{ABC}->p(2)->normal;
        $t{ABC}->p(3)->normal;

        $t2->allgrey;
        $t2->math("    \\{theta} > \\{epsilon}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Angle DEC is an exterior angle to triangle EAB, hence "
              . "it is larger than the angle EAB (I.16)" );
        $t{ABC}->grey;
        $t{DBC}->grey;
        $t{EDC}->grey;
        $t{ABE}->normal->fill($purple);
        $t{EDC}->a(1)->normal;
        $t{ABC}->p(1)->normal;
        $t{ABC}->p(2)->normal;
        $t{ABC}->p(3)->normal;
        $t2->math("    \\{epsilon} > \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Thus, angle BDC is greater than angle ABC");
        $t2->math("    \\{theta} > \\{epsilon} > \\{alpha}");
        $t2->math("    \\{theta} > \\{alpha}");
        $t{DBC}->a(1)->normal;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{EDC}->remove;
        $p{E}->remove;

        #$t{EDC}->grey;
        $t{ABE}->remove;
        $t{ABC}->draw(-1)->fill($sky_blue);
        $t{DBC}->draw(-1)->fillover( $t{ABC}, $teal );
        $t{DBC}->l(3)->label( "b2", "right" );
        $t{ABC}->l(1)->label("c1","left");
        $t2->allgrey;
        $t2->black([6,-1]);

    };

    return \@steps;
}

