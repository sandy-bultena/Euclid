#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
  "Any two sides of a triangle are together greater than the third side.";

my $pn = PropositionCanvas->new( -number => 20, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 430 );
my $t3 = $pn->text_box( 300, 250 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,20);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #20
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @D = ( 450, 350 );
    my @B = ( 100, 350 );
    my @A = ( 250, 150 );
    my @C = ( 350, 350 );
    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a triangle ABC");
        $t{ABC} = Triangle->new(
            $pn,
            @A, @B, @C,1,
            -points => [qw(A top B bottom C bottom)],
            -labels => [qw(c left a bottom b right)],
            -angles => [qw(\\{alpha} \\{beta} \\{gamma})],
        );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "The sum of any two sides of the triangle is greater "
              . "than the third" );
        $t2->math("AC + AB > BC  (b + c > a)");
        $t2->math("BC + AC > AB  (a + b > c)");
        $t2->math("AB + BC > AC  (c + a > b)");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Extend BC");

        my $x = $t{ABC}->p(3)->distance_to(@A) + 25;
        $t{ABC}->l(2)->extend($x);

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->erase;
        $t1->explain("Define point D, such that CD equals AC");
        $t2->math("CD = AC");

        $c{C} = Circle->new( $pn, @C, @A );
        my @p = $c{C}->intersect( $t{ABC}->l(2) );
        $p{D} = Point->new( $pn, @p[0,1] )->label( "D", "bottom" );
        $c{C}->remove;

        ( $l{BC}, $l{CD}, $l{Dp} ) =
          $t{ABC}->l(2)->split( $t{ABC}->p(3), $p{D} );
        $l{BC}->label( "a", "bottom" );
        $l{CD}->label( "b", "bottom" );

        $l{BC}->grey;
        $t{ABC}->l(1)->grey;
        $t{ABC}->a(1)->grey;
        $t{ABC}->a(2)->grey;
        $t{ABC}->a(3)->grey;

        $t2->math("BD =  BC + CD");
        $t2->math("BD =  BC + AC");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
                "Create line AD, making the triangle ACD an isosceles triangle, "
              . "thus the angles CAD and CDA are equal (I.5)" );

        $l{AD} = Line->new( $pn, @A, $p{D}->coords );
        $t{ACD}=Triangle->assemble(
            $pn,
            -lines  => [ $t{ABC}->l(3), $l{CD},        $l{AD} ],
        );
        $t{ACD}->set_angles( "\\{theta}", undef, "\\{theta}", 50, 0, 50 );
        $t{ACD}->fill($sky_blue);

        $t2->allgrey;
        $t2->math("\\{angle}CAD = \\{angle}CDA = \\{theta}");
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Consider triangle ABD");
        $t{ABC}->l(3)->grey;
        $t{ABC}->a(3)->grey;
        $t{ACD}->fill();
        $l{BC}->normal;
        $t{ABC}->l(1)->normal;
        $t{ABC}->a(1)->normal;
        $t{ABC}->a(2)->normal;
        #$t{ABC}->a(3)->grey;
        
        $t2->allgrey;
        $t1->explain( "Angle BAD is obviously larger than angle BDA, "
              . "thus length BD is larger than AB (I.18)" );
        $t2->math("\\{alpha} + \\{theta} > \\{theta}");
        $t2->math("\\{angle}BAD  > \\{angle}BDA");
        $t2->math("\\{therefore} BD > AB");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("But BD is the sum of BC and AC");
        $t2->allgrey;
        $t2->black([2,-1]);
        $t2->math("BC + AC > BD");
        $t{ABC}->l(3)->normal;
        $t{ABC}->a(3)->normal;
        $t{ACD}->l(3)->grey;
        $t{ACD}->a(1)->remove;
        $t{ACD}->a(3)->remove;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Thus BD, one side of a triangle, is less than the sum ".
        "of the other two sides");
        $l{CD}->grey;
        $l{Dp}->grey;
        $p{D}->grey;
        $t2->allgrey;
        $t2->black(-1);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "This procedure can be used on any side of the triangle, "
              . "hence the sum of two sides is always greater than the third" );
    };

    # -------------------------------------------------------------------------
    return \@steps;
}

