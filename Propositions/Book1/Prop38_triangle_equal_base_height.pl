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
my $title = "Triangles which are on equal bases and in the same parallels equal one another.";

my $pn = PropositionCanvas->new( -number => 38, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 400, 500 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,38);
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
    my $top = 200;
    my $bot = 400;
    my @A   = ( 230, $top );
    my @B   = ( 125, $bot );
    my @D   = ( 275, $top );
    my @F   = ( 500, $bot );
    my @C   = ( $B[0] + 125, $bot );
    my @E   = ( $F[0] - 125, $bot );
    my @G   = ( $A[0] - 150, $top );
    my @H   = ( $D[0] + 150, $top );

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Triangles with equal base and height have the same area");
    };
    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given two parallel lines ");

        $l{GH} = Line->new( $pn, @G, @H )->dash;
        $l{BF} = Line->new( $pn, @B, @F )->dash;
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Let ABC and DEF be triangles with equal bases, and on the same parallels" );
        $t{ABC} = Triangle->new( $pn, @A, @B, @C, 1, -points => [qw(A top B bottom C bottom)] );
        $t{DEF} = Triangle->new( $pn, @D, @E, @F, 1, -points => [qw(D top E bottom F bottom)] );
        $t{ABC}->fill($sky_blue);
        $t{DEF}->fill($lime_green);
        $t3->math("AD \\{parallel} BF");
        $t3->math("BC = EF");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The area ABC is equal to DEF");
        $l{GH}->grey;
        $l{BF}->grey;
        $t3->math("\\{triangle}ABC = \\{triangle}DEF");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t3->erase;
        $t3->math("AD \\{parallel} BF");
         $t3->math("BC = EF");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw BG parallel to AC (I.31)");
        $t{ABC}->grey;
        $t{DEF}->grey;
        $l{BG} = $t{ABC}->l(3)->parallel( $t{ABC}->p(2) );
        $t{ABC}->l(3)->normal;
        $t{ABC}->p(1)->normal;
        $t{ABC}->p(2)->normal;
        $t{ABC}->p(3)->normal;
        $l{BG}->extend(150);
        $p{G} = Point->new( $pn, $l{GH}->intersect( $l{BG} ) )->label( "G", "top" );
        $t3->allgrey;
        $t3->math("BG \\{parallel} AC");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw FH parallel to DE (I.31)");
        $t{ABC}->grey;
        $l{BG}->grey;
        $l{FH} = $t{DEF}->l(1)->parallel($t{DEF}->p(3) );
        $l{FH}->extend(150);
        $p{H} = Point->new( $pn, $l{GH}->intersect( $l{FH} ) )->label( "H", "top" );
        $t{DEF}->l(1)->normal;
        $t{DEF}->p(1)->normal;
        $t{DEF}->p(2)->normal;
        $t{DEF}->p(3)->normal;
        $t3->allgrey;
        $t3->math("FH \\{parallel} DE");
     };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "The parallelograms GBCA and DEFH are equal "
                      . "since they have equal bases and are on two parallel "
                      . "lines.\\{nb}(I.36)" );
        $t{ABC}->p(1)->normal;
        $t{ABC}->p(2)->normal;
        $t{ABC}->p(3)->normal;
        $l{BG}->grey;
        $l{FH}->grey;
        $s{GBCA} = Polygon->new( $pn, 4, $p{G}->coords, @B, @C, @A, -1, -fill => $blue );
        $s{DEFH} = Polygon->new( $pn, 4, @D, @E, @F, $p{H}->coords, -1, -fill => $green );
        $t3->allblack;
        $t3->blue([0,1]);
        $t3->math("GBCA = DEFH");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "The triangle ABC is half the area of GBCA " . "since line AB bisects the parallelogram\\{nb}(I.34)" );
        $t{ABC}->normal;
        $t{DEF}->grey;
        $t{ABC}->fillover($s{GBCA},$sky_blue);
        $s{DEFH}->grey;
        $t3->allgrey;
        $t3->math("\\{triangle}ABC = \\{half} GBCA");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "The triangle DEF is half the area of DEFH " . "since line DE bisects the parallelogram\\{nb}(I.34)" );
        $t{ABC}->grey;
        $t{DEF}->normal;
        $s{GBCA}->normal;
        $s{GBCA}->grey;
        $s{DEFH}->normal;
        $s{DEFH}->fill($green);
        $t{DEF}->fillover($s{DEFH},$lime_green);
        $t3->allgrey;
        $t3->math("\\{triangle}DEF = \\{half} DEFH");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Half of equals are equal, so ABC equals DEF");
        $t{ABC}->normal;
        $s{GBCA}->grey;
        $s{DEFH}->grey;
        $t3->grey;
        $t3->black([-1,-2,-3]);
        $t3->math("\\{triangle}ABC = \\{triangle}DEF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->blue([0,1]);
        $t3->black(-1);
        $s{GBCA}->remove;
        $s{DEFH}->remove;
        $l{BG}->remove;
        $l{FH}->remove;
        $p{G}->remove;
        $p{H}->remove;
    };

    return \@steps;
}

