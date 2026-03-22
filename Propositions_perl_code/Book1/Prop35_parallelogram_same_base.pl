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
my $title = "Parallelograms which are on the same base and in " . "the same parallels equal one another.";

my $pn = PropositionCanvas->new( -number => 35, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 300 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,35);
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

    my @A = ( 75,  200 );
    my @B = ( 100, 400 );
    my @C = ( 250, 400 );
    my @F = ( 450, 200 );

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given two parallel lines ");

        $l{AF1} = Line->new( $pn, @A, @F )->dash;
        $l{BC1} = Line->new( $pn, @B, @C );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Let ABCD and EBCF be parallelograms with the same ".
        "base BC and the same height, (congruent with AF, a line parallel to the base)" );
        $s{ABCD} = Parallelogram->new( $pn, @A, @B, @C, 1, -points => [qw(A top B bottom C bottom D top)] );
        $s{BCFE} = Parallelogram->new( $pn, @B, @C, @F, 1, -points => [qw(B bottom C bottom F top E top)] );
        $t2->math("AD \\{parallel} BC \\{parallel} EF");
        $t2->math("AB \\{parallel} DC");
        $t2->math("EB \\{parallel} FC");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The area ABCD is equal to EBCF");
        $t2->math("\\{parallelogram}ABCD = \\{parallelogram}EBCF");
        $l{AF1}->grey;
        $l{BC1}->grey;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("AD \\{parallel} BC \\{parallel} EF");
        $t2->math("AB \\{parallel} DC");
        $t2->math("EB \\{parallel} FC");
        $t2->allblue;
        
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since ABCD is a parallelogram, AD is equal to BC\\{nb}(I.34)" );
        $s{ABCD}->l(4)->label( "x", "top" );
        $s{ABCD}->l(2)->label( "x", "bottom" );
        $s{ABCD}->fill($sky_blue);
        $t3->math("AD = BC = x");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since EBCF is a parallelogram, EF is equal to BC\\{nb}(I.34)" );
        $s{BCFE}->l(3)->label( "x", "top" );
        $s{ABCD}->fill;
        $s{BCFE}->fill($lime_green);
        $t3->allgrey;
        $t3->math("EF = BC = x");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Hence AD is equal to EF" );
        $t3->allblack;
        $t3->math("AD = EF = x");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Add DE to both AD and EF, then AE is equal to DF");
        $l{DE} = Line->new( $pn, $s{ABCD}->p(4)->coords, $s{BCFE}->p(4)->coords, -1 );
        $l{DE}->label( "\\{delta}", "top" );
        $s{BCFE}->fill();
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("AE = DF = x + \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since ABCD is a parallelograms, AB is equal to DC\\{nb}(I.34)" );
        $s{ABCD}->l(1)->label( "y", "left" );
        $s{ABCD}->l(3)->label( "y", "right" );
        $s{ABCD}->fill($sky_blue);
        $t3->allgrey;
        $t3->math("AB = DC = y");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Angle DAB and FDC are equal (interior and "
                      . "exterior angles), since AF "
                      . "intersects two parallel lines AB and DC\\{nb}(I.29)" );
        $s{BCFE}->l(1)->grey;
        $s{BCFE}->l(2)->grey;
        $s{BCFE}->l(4)->grey;
        $s{ABCD}->l(2)->grey;
        $s{ABCD}->set_angles(qw(\\{alpha}));
        $s{ABCD}->fill;
        $a{CDE} = Angle->new( $pn, $s{ABCD}->l(3), $l{DE}, -size => 20 )->label("\\{alpha}");
        $t3->allgrey;
        $t3->math("\\{angle}EAB = \\{angle}FDC");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $s{ABCD}->l(2)->grey;
        $s{BCFE}->l(1)->grey;
        $l{BC1}->remove;
        $t1->explain("Triangles ABE and DFC are equivalent\\{nb}(I.4), thus equal in area");
        $p{G} = Point->new( $pn, $s{BCFE}->l(4)->intersect( $s{ABCD}->l(3) ) );
        $s{ABGD} = Polygon->new( $pn, 4, @A, @B, $p{G}->coords, $s{ABCD}->p(4)->coords, -1, -fill => $sky_blue );
        $s{EFCG} = Polygon->new( $pn, 4, @F, @C, $p{G}->coords, $s{BCFE}->p(4)->coords, -1, -fill => $lime_green );
        $s{DEG} = Polygon->new( $pn, 3, $s{ABCD}->p(4)->coords, $p{G}->coords, $s{BCFE}->p(4)->coords, -1, -fill => $teal );
        $t3->black([3,4]);
        $t3->math("\\{triangle}ABE = \\{triangle}DCF");

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $s{ABCD}->remove_labels;
        $l{DE}->remove;
        $s{ABCD}->remove_angles;
        $a{CDE}->remove;
        $p{G}->label("G","right");
        $t1->explain( "Remove EDG from ABE and DFC, the resulting trapezoids ADGB and EGCF are equal" );
        $l{AF1}->grey;
        $s{DEG}->fill(undef);
        $s{DEG}->remove;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{triangle}ABE-\\{triangle}DGE = \\{triangle}DCF-\\{triangle}DGE");
        $t3->math("\\{rectangle}ADGB = \\{polygon}EGCF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Add BGC to both trapezoids, and the result is that the parallelograms ABCD and EBCF are equal" );
        $s{BCG} = Polygon->new( $pn, 3, @B, @C, $p{G}->coords, -1 );
        $s{BCG}->fill($teal);
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{polygon}ADGB+\\{triangle}BGC = \\{polygon}EGCF+\\{triangle}BGC");
        $t3->down;
        $t3->math("\\{parallelogram}ABCD = \\{parallelogram}EBCF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->black(-1);
    };

    return \@steps;
}
