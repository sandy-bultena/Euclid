#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title = "A greater side of a triangle is opposite a greater angle.";

my $pn = PropositionCanvas->new( -number => 18, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 430 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,18);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #18
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @D = ( 450, 450 );
    my @B = ( 100, 400 );
    my @A = ( 75,  150 );
    my @C = ( 350, 400 );
    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a triangle ABC");
        $t{ABC} = Triangle->new(
            $pn, @A, @B, @C,1,
            -points     => [qw(A top B bottom C bottom)],
            -angles     => [qw(\\{alpha} \\{beta} \\{gamma})],
            -anglesizes => [ undef, 60, undef ],
            -labels     => [ undef, undef, qw(x bottom y right) ],
        );
        $l{AB} = $t{ABC}->l(1);
        $l{BC} = $t{ABC}->l(2);
        $l{AC} = $t{ABC}->l(3);
        $a{alpha} = $t{ABC}->a(1);
        $a{beta} = $t{ABC}->a(2);
        $a{gamma} = $t{ABC}->a(3);
        $p{A} = $t{ABC}->p(1);
        $p{B} = $t{ABC}->p(2);
        $p{C} = $t{ABC}->p(3);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "If line AC is greater than BC, "
              . "then angle ABC is greater than BAC" );
        $t2->math("y > x  =>  \\{beta} > \\{alpha}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->erase;
        $t2->math("AC > BC");
        $t1->down;
        $t1->title("Proof");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create point D on line AC, such that CD equals BC");
        $c{C} = Circle->new( $pn, @C, @B );
        my @p = $c{C}->intersect( $t{ABC}->l(3) );
        $p{D} = Point->new( $pn, @p )->label( "D", "right" );
        $c{C}->remove;
        ( $l{CD}, $l{AD} ) = $t{ABC}->l(3)->split( $p{D} );
        $l{CD}->label("x");
        $t{ABC}->l(3)->label;
        $t2->math("DC = BC");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create line BD");
        $t1->explain( "The angle CDB is an exterior angle to triangle ADB, "
              . "thus angle CDB is greater than angle DAB (I.16)" );

        $a{beta}->grey;
        $a{gamma}->grey;
        $l{BD} = Line->new( $pn, @B, $p{D}->coords );
        $t{ABD} = Triangle->assemble(
            $pn,
            -lines  => [ $t{ABC}->l(1), $l{BD}, $l{AD} ],
            -angles => [ $t{ABC}->a(1), undef,  undef ]
        );

        $t{DBC} = Triangle->assemble(
            $pn,
            -lines  => [ $l{BD}, $t{ABC}->l(2), $l{CD} ],
            -angles => [ undef,  undef,         $t{ABC}->a(3) ]
        );
        $t{DBC}->set_angles( "\\{theta}", undef, undef );
        $a{theta} = $t{DBC}->a(1);

        $t{DBC}->grey;
        $t{ABC}->grey;
        $t{ABD}->normal;
        $a{theta}->normal;
        $p{A}->normal;
        $p{B}->normal;
        $t{ABD}->fill($sky_blue);
        $l{CD}->normal;
        $p{C}->normal;
        $t2->math("\\{theta} > \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "The triangle BCD is an isosceles triangle, "
              . "thus angles CDB and DBC are equal (I.5)" );
        $t{DBC}->set_angles( undef, "\\{theta}", undef, 0, 20, 0 );
        $t{ABD}->set_angles( undef, undef, "\\{epsilon}", 0, 0, 20 );
        $a{epsilon} = $t{ABD}->a(3);
        $t{ABD}->grey;
        $t{DBC}->normal;
        $t{DBC}->fill($lime_green);
        $t{ABD}->a(1)->normal;
        $a{alpha}->grey;
        $p{A}->grey;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Angle ABC is greater than angle DBC, "
              . "so angle ABC is greater than angle BAC" );
        $t{DBC}->fill();
        $t{ABC}->a(2)->normal;
        $p{A}->normal;
        $a{alpha}->normal;
        $l{AB}->normal;
        $l{AD}->normal;
        $a{gamma}->grey;
        $t2->math("\\{beta} > \\{theta} > \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{ABD}->remove;
        $t{DBC}->remove;
        $p{D}->remove;
        $t{ABC}->draw(-1);
        $t2->allgrey;
        $t2->blue(0);
        $t2->down;
        $a{gamma}->remove;
        $l{AC}->label;
        $t2->math("\\{angle}ABC > \\{angle}BAC");
    };

    # -------------------------------------------------------------------------
    return \@steps;
}

