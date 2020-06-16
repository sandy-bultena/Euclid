#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If two triangles have two sides equal to two sides "
  . "respectively, but have one of the angles contained by the equal "
  . "straight lines greater than the other, then they also have the "
  . "base greater than the base.";

my $pn = PropositionCanvas->new( -number => 24, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 475 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,24);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my ( %l, %p, %c, %a, %t );
    my @objs;
    my %o;

    my @A = ( 200, 150 );
    my @B = ( 75,  350 );
    my @C = ( 375, 350 );
    my @D = ( 220, 425 );
    my @E;
    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain( "Given two triangles ABC and DEF, where "
              . "lengths AB equals DE and AC equals DF, "
              . "and angle BAC is greater than DEF" );

        $t{ABC} = Triangle->new(
            $pn, @A, @B, @C,1,
            -points => [qw(A top B left C right)],
            -angles => ["\\{alpha}"],
            -labels => [ qw(c left), undef, undef, qw(b right) ],
        );

        $t{DEF} = Triangle->SAS(
            $pn, @D, $t{ABC}->l(1)->length, $t{ABC}->a(1)->arc - 30,
            $t{ABC}->l(3)->length,1,
            -points => [qw(D top E left F bottom)],
            -angles => ["\\{delta}"],
            -labels => [ qw(c left), undef, undef, qw(b right) ],
        );
        @E = $t{DEF}->p(2)->coords;

        $t2->math("\\{alpha} > \\{delta}");
        $t2->math("AB = DE = c");
        $t2->math("AC = DF = b");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then length BC is greater than length EF");
        $t{ABC}->set_labels( undef, undef, qw(a bottom) );
        $t{DEF}->set_labels( undef, undef, qw(d bottom) );
        $t2->math("BC > EF, a > d");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("\\{alpha} > \\{delta}");
        $t2->math("AB = DE = c");
        $t2->math("AC = DF = b");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Copy the angle BAC onto line ED at point D  (I.23)");

    $t{ABC}->l(2)->grey;
    $t{DEF}->l(2)->grey;
    $t{DEF}->l(3)->grey;
    $t{DEF}->a(1)->grey;
        ( $l{DG2}, $a{GDE} ) =
          $t{ABC}->a(1)->copy( $t{DEF}->p(1), $t{DEF}->l(1) );
        $l{DG2}->extend(100);
        $a{GDE}->label( "\\{alpha}", 80 );
        $t2->allgrey;
        $t2->math("\\{angle}EDG = \\{angle}BAC");
        $t2->blue([-1]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
            "Define point G on the copied angle such that DG equals DF");

        $c{D} = Circle->new( $pn, @D, $t{DEF}->p(3)->coords );
        $p{G} =
          Point->new( $pn, $c{D}->intersect( $l{DG2} ) )->label( "G", "right" );
        $l{DG} = Line->new( $pn, @D, $p{G}->coords, -1 )->label( "b", "right" );
        $c{D}->remove;
        $l{DG2}->grey;
        $t2->allgrey;
        $t2->math("DG = DF");
        $t2->blue([-1]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Construct line EG and FG");
        $l{EG} = Line->new( $pn, $t{DEF}->p(2)->coords, $p{G}->coords );
        $l{FG} = Line->new( $pn, $t{DEF}->p(3)->coords, $p{G}->coords );
        $l{DG2}->remove;

        $t{DEG} = Triangle->assemble(
            $pn,
            -lines  => [ $t{DEF}->l(1), $l{EG},        $l{DG} ],
            -angles => [ $a{GDE},       undef,         undef ],
            -points => [ $t{DEF}->p(1), $t{DEF}->p(2), $p{G} ]
        );

        $t{DFG} = Triangle->assemble(
            $pn,
            -lines  => [ $t{DEF}->l(3), $l{FG},        $l{DG} ],
            -points => [ $t{DEF}->p(1), $t{DEF}->p(3), $p{G} ]
        );

        $t{EFG} = Triangle->assemble(
            $pn,
            -lines  => [ $t{DEF}->l(2), $l{FG},        $l{EG} ],
            -points => [ $t{DEF}->p(2), $t{DEF}->p(3), $p{G} ]
        );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{DEF}->grey;
        $t{DFG}->grey;
        $t{DEG}->normal;
        $t{ABC}->l(2)->normal;
        $t{ABC}->fill($sky_blue);
        $t{DEG}->fill($sky_blue);

        $t1->explain( "Triangle ABC and DEG have two equal sides "
              . "with an equal angle between them, hence they are equal, "
              . "and the line BC equals EG (I.4)" );

        $l{EG}->label( "a", "topleft" );

        $t2->allgrey;
        $t2->blue([1,2,3,4]);
        $t2->math("EG = BC");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{DEF}->grey;
        $t{DEG}->grey;
        $t{DFG}->normal;

        $t1->explain("Consider triangle FDG");
        $t1->explain( "Angles DFG and DGF are equal since the "
              . "the triangle is an isosceles triangle (I.5)" );

        $t{DFG}->set_angles( undef, "\n    \\{epsilon}", "\\{epsilon}", 0, 40, 20 );
        $t{DFG}->fill($lime_green);
        $t{ABC}->fill();

        $t2->allgrey;
        $t2->blue([4]);
        $t2->math("\\{angle}DFG = \\{angle}DGF = \\{epsilon}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{DFG}->grey;
        $t{DEF}->remove_line_labels;
        $t{DEF}->p(1)->normal;
        $t{EFG}->normal;
        $t1->explain("Angle EFG is greater than DFG");
        $t{DEF}->l(3)->normal;
        $t{DEG}->l(2)->grey;
        $t{DFG}->a(2)->normal;
        $t{EFG}->set_angles( undef, "\n\\{beta}     ", undef, 0, 15, 0 );
        $t2->allgrey;
        $t2->math("\\{beta} > \\{epsilon}");
    };

    # -------------------------------------------------------------------------

    push @steps, sub {
        $t{ABC}->remove;
        $t{DFG}->a(2)->red;
        $t{DFG}->remove_line_labels;
        $t{EFG}->remove_line_labels;
        $t{DEF}->remove_line_labels;
        $t{DEG}->remove_line_labels;

        # get all unique items for the three triangles, and then scale them
        %o = map { ( $_, $_ ) } $t{DFG}->objects, $t{EFG}->objects,
          $t{DEF}->objects, $t{DEG}->objects;

        $t{DEF}->p(1)->normal;
        $t{EFG}->fill();
        $pn->scaleall( 1.5, $E[0]+100, $E[1] + 50, values %o );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Angle DGF is greater than EGF");
        $t{DFG}->a(2)->remove;
        $t{EFG}->a(2)->remove;
        $t{DEF}->l(2)->grey;
        $t{DEF}->l(3)->grey;
        $t{EFG}->l(3)->normal;
        $t{DFG}->l(3)->normal;
         $t{DFG}->set_angles( undef, undef, "\\{epsilon}", 0, 40, 20 );
         $t{DFG}->a(3)->scale(1.5,$E[0]+100,$E[1]+50);
        $t{EFG}->set_angles( undef, undef, "\\{theta}", 0, 0, 60 );
        $t{EFG}->a(3)->scale(1.5,$E[0]+100,$E[1]+50);

        $t2->allgrey;
        $t2->math("\\{epsilon} > \\{theta}");
     };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{DFG}->l(3)->grey;
        $t{DFG}->a(3)->grey;
        $t{EFG}->scale_inner(1.5,$E[0]+100,$E[1]+50);
        $t{EFG}->fill($pale_pink);
        $t{EFG}->l(1)->normal;
        $t{EFG}->set_angles( undef, "\n\\{beta}     ", undef, 0, 15, 0 );
        $t{EFG}->a(2)->scale(1.5,$E[0]+100,$E[1]+50);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "The angle EFG is greater than EGF, "
              . "hence line EG is greater than EF (I.19)" );
              $t2->black(-2);
        $t2->math("EG > EF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $pn->scaleall( 1/1.5, $E[0]+100, $E[1] + 50, values %o );
        $t{EFG}->a(2)->scale(1/1.5,$E[0]+100,$E[1]+50);
        $t{EFG}->scale_inner(1/1.5,$E[0]+100,$E[1]+50);
         $t{DFG}->a(3)->scale(1/1.5,$E[0]+100,$E[1]+50);
        $t{EFG}->a(3)->scale(1/1.5,$E[0]+100,$E[1]+50);

        $t{ABC}->draw(-1);
        $t1->explain("Since EG is equal to BC, BC is greater than EF");
        $t2->allgrey;
        $t2->black([5,-1]);
        $t2->down;
        $t2->math("BC > EF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{EFG}->remove;
        $t{DFG}->remove;
        $t{DEF}->draw(-1);
        $a{GDE}->remove;
        $p{G}->remove;

        $t2->allgrey;
        $t2->blue([0..2]);
        $t2->black(-1);
    };
    return \@steps;
}

