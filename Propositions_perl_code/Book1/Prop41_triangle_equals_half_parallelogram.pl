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
    "If a parallelogram has the same base with a "
  . "triangle and is in the same parallels, then the "
  . "parallelogram is double the triangle.";

my $pn = PropositionCanvas->new( -number => 41, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 400, 500 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,41);
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

    my ( %l, %p, %c, %a, %t, %s );
    my @objs;
    my $top = 250;
    my $bot = 450;
    my @A   = ( 100, $top );
    my @B   = ( 125, $bot );
    my @E   = ( 375, $top );
    my @C   = ( $B[0] + 200, $bot );

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("If a parallelogram and a triangle have the same base and height, ".
        "the triangle will have half the area of the parallelogram");
    };
    push @steps, sub {
        $t1->erase;
        $t1->title("In other words");
        $t1->explain("Given two parallel lines");
        $l{AE} = Line->new( $pn, @A, @E )->dash;
        $l{BC} = Line->new( $pn, @B, @C )->dash;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Let the parallelogram ABCD and the triangle EBC ".
        "have the same bases, and be on the same parallels" );
        $l{AE}->grey;
        $l{BC}->grey;
        $s{ABCD} = Parallelogram->new( $pn, @A, @B, @C, 1, -points => [qw(A top B bottom C bottom D top)] );
        $t{EBC} = Triangle->new( $pn, @E, @B, @C, 1, -points => [qw(E top B bottom C bottom)] );
        $t3->math("AE \\{parallel} BC");
        $t3->allblue;
        $s{ABCD}->fill($sky_blue);
        $t{EBC}->fill($lime_green);
        my @x = $s{ABCD}->l(3)->intersect($t{EBC}->l(1));
        $t{BxC} = Triangle->new($pn,@B,@x,@C);
        $t{BxC}->fillover($s{ABCD},$teal);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Then the area of the triangle EBC is half the area of ".
        "the parallelogram ABCD" );
        $t3->math("EBC = \\{half} ABCD");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t3->erase;
        $t3->math("AE \\{parallel} BC");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw the line AC");
        $l{AC} = Line->new( $pn, @A, @C );
        $t{ABC} = Triangle->assemble( $pn, -lines => [ $s{ABCD}->l(1), $s{ABCD}->l(2), $l{AC} ] );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Triangle ABC is equal to one half of ABCD\\{nb}(I.34)");
        $t{ABC}->fillover( $s{ABCD}, $blue );
        $t{EBC}->grey;
        $t{BxC}->grey;
        $t3->allgrey;
        $t3->math("\\{triangle}ABC = \\{half} ABCD");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Triangles ABC and EBC are equal, since ".
        "they are on the same parallels\\{nb}(I.37)" );
        $s{ABCD}->grey;
        $t{EBC}->normal;
        $t{ABC}->normal;
        $t{ABC}->p(1)->label("A","top");
        my @y = $t{ABC}->l(3)->intersect($t{EBC}->l(1));
        $t{ByC} = Triangle->new($pn,@B,@y,@C);
        $t{ByC}->fillover($t{ABC},Colour->add($blue,$lime_green));
        $t3->allgrey;
        $t3->math("\\{triangle}ABC = \\{triangle}EBC");
        $t3->blue(0);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Thus triangle EBC is half the parallelogram ABCD");
        $t{ByC}->remove;
        $t{ABC}->fill;
        $l{AC}->remove;
        $s{ABCD}->normal;
        $s{ABCD}->fill($sky_blue);
        $t{EBC}->fillover( $s{ABCD}, $lime_green );
        $t{BxC}->fillover($t{EBC},$teal);
        $t3->allgrey;
        $t3->black([1,2,3]);
        $t3->math("\\{triangle}EBC = \\{half} ABCD");

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->blue(0);
        $t3->black(-1);
    };

    return \@steps;
}

