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

my $pn = PropositionCanvas->new( -number => 37, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 400, 500 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,37);
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

    my @A = ( 230, 200 );
    my @B = ( 125, 400 );
    my @C = ( 325, 400 );
    my @D = ( 350, 200 );
    my @E = ( 350, 400 );
    my @F = ( 500, 400 );

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Triangles with equal base and height have the same area");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given two parallel lines ");

        $l{BC1} = Line->new( $pn, @B, @C )->dash;
        $l{AD}  = Line->new( $pn, @A, @D )->dash;
        $t3->math("AD \\{parallel} BC");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Let ABC and DBC be triangles on the same base BC, and on the same parallels BC and AD" );
        $s{ABC} = Triangle->new( $pn, @A, @B, @C, 1, -points => [qw(A top B bottom C bottom)] )->fill($sky_blue);;
        $s{DBC} = Triangle->new( $pn, @D, @B, @C, 1, -points => [qw(D top B bottom C bottom)] )->fill($lime_green);
        my @p = $s{ABC}->l(3)->intersect($s{DBC}->l(1));
        $s{BxC} = Triangle->new($pn,@B,@p,@C)->fillover($s{ABC},$teal);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The areas of ABC and DBC are equal");
        $l{AD}->grey;
        $t3->math("\\{triangle}ABC = \\{triangle}DBC");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t3->erase;
        $t3->math("AD \\{parallel} BC");
        $t3->allblue;
        
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Extend line AD");
        $l{AD}->prepend(250);
        $l{AD}->extend(250);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw BE parallel to CA (I.31)");
        $s{ABC}->grey;
        $s{DBC}->grey;
        $s{BxC}->remove;
        $s{ABC}->p(3)->normal;
        $s{ABC}->p(2)->normal;
        $s{ABC}->p(1)->normal;
        $l{BE1} = $s{ABC}->l(3)->parallel( $s{ABC}->p(2) );
        $s{ABC}->l(3)->normal;
        $l{BE1}->extend(150);
        $l{BC1}->grey;
        $p{E} = Point->new( $pn, $l{AD}->intersect( $l{BE1} ) )->label(qw(E top));
        $t3->allgrey;
        $t3->math("BE \\{parallel} CA");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw CF parallel to BD (I.31)");
        $l{BE1}->grey;
        $s{ABC}->l(3)->grey;
        $l{CF1} = $s{DBC}->l(1)->parallel( $s{DBC}->p(3) );
        $s{DBC}->l(1)->normal;
        $s{DBC}->p(1)->normal;
        $l{CF1}->prepend(100);
        $p{F} = Point->new( $pn, $l{AD}->intersect( $l{CF1} ) )->label(qw(F top));
        $t3->allgrey;
        $t3->math("CF \\{parallel} BD"); 
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        my @x = $s{ABC}->l(3)->intersect($s{DBC}->l(1));
        $s{EBxA} = Polygon->new( $pn, 4, $p{E}->coords, @B, @x, @A, -1, -fill => $blue );
        $s{DxCF} = Polygon->new( $pn, 4,@D, @x, @C, $p{F}->coords, -1, -fill => $green );
        $t{xBC}=Triangle->new($pn,@x,@B,@C,-1)->fillover($s{ABC},Colour->add($blue,$green));
        $l{BE1}->grey;
        $l{CF1}->grey;
        $t1->explain("The parallelograms EBCA and DBCF are equal\\{nb}(I.35)");
        $t3->allblack;
        $t3->blue(0);
        $t3->math("EBCA = DBCF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{xBC}->grey;
        $s{EBxA}->remove;
        $s{EBA} = Polygon->new( $pn, 3, $p{E}->coords, @B, @A, -1, -fill => $blue );
        $s{DxCF}->grey;
        $s{ABC}->normal;
        $s{ABC}->fillover($s{EBxA},$sky_blue);
        $s{DBC}->grey;
        $t3->allgrey;
        $t1->explain( "The triangle ABC is half the area of EBCA " . "since line AB bisects the parallelogram\\{nb}(I.34)" );
        $t3->math("\\{triangle}ABC = \\{half} EBCA");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $s{EBA}->grey;
        $s{DxCF}->remove;
        $s{DCF} = Polygon->new( $pn, 3,@D, @C, $p{F}->coords, -1, -fill => $green );
        $s{ABC}->grey;
        $s{DBC}->normal->fill($lime_green);
        $t3->allgrey;
        $t1->explain( "The triangle DBC is half the area of DBCF since line DC bisects the parallelogram\\{nb}(I.34)" );
        $t3->math("\\{triangle}DBC = \\{half} DBCF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $s{EBA}->remove;
        $s{DCF}->remove;
        $s{BxC}->draw;
        $s{ABC}->normal->fill($sky_blue);
        $s{DBC}->normal->fill($lime_green);
        $s{BxC}->fillover($s{ABC},$teal);
        $t3->allgrey;
        $t3->black([-1,-2,-3]);
        $t1->explain("Half of equals are equal, so ABC equals DBC");
        $t3->math("\\{triangle}ABC = \\{triangle}DBC");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->blue(0);
        $t3->black(-1);
    };

    return \@steps;
}

