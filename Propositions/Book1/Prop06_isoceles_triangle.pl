#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
"If two angles of a triangle are equal, then the sides opposite them will be equal.";

my $pn = PropositionCanvas->new( -number => 6, -title => $title );
Proposition::init($pn);
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 450, 330 );
my $t3 = $pn->text_box( 800, 150, -width => 480 );
my $t4 = $pn->text_box( 450, 330 );

my $steps;

push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,6);
push @$steps, Proposition::reset();
push @$steps, @{ explanation($pn) };
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #6
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @A = ( 225, 250 );
    my @B = ( 425, 450 );
    my @C = ( 75,  450 );
    my $mid = int( ( $B[0] + $C[0] ) / 2 );
    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Start with a triangle with equal base angles");
        $t{ACB} = Triangle->new(
                           $pn,
                           @A, @C, @B, 1,
                           -points => [ "A", "top", "C", "left", "B", "right" ],
                           -angles => [ undef, "\\{alpha}", "\\{alpha}" ]
        );
        $t2->math("\\{angle}ACB = \\{angle}ABC");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then the sides opposite the equal angles are equal");
        $t{ACB}->set_labels( qw(r left), undef, undef, qw(r right) );
        $t2->math("AC = AB");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->erase;
        $t1->down;
        $t1->title("Proof by contradiction");
        $t1->explain("Assume that the sides are not equal, and "
                   . "demonstrate that this leads to a logical inconsistency" );

        $t{ACB}->set_labels( qw(r1 left), undef, undef, qw(r2 right) );
        $t{ACB}->fill($sky_blue);
        $t2->math("\\{angle}ACB = \\{angle}ABC");
        $t2->allblue;
        $t4->y( $t2->y );
        $t2->math("AB > AC, (r2 > r1)");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Use the method from Propositions 2 and 3 to find a "
                      . "point D such that BD equals AC" );
        ( $l{BD}, $p{D} ) =
          $t{ACB}->l(1)->copy_to_line( $t{ACB}->p(3), $t{ACB}->l(3) );
        $p{D}->label( "D", "right" );
        $l{BD}->label( "r1", "left" );
        $t2->math("  BD = AC = r1");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create a triangle DCB");
        $t{DCB} = Triangle->new( $pn, $p{D}->coords, @C, @B, 1,
                                 -points => [qw(D right C left B right)], );
        $t{DCB}->fill($teal);
        $t{ACB}->lower;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
               "Let's move DCB to a different spot so we can see more clearly");
        $p{D}->remove;
        $l{BD}->remove;
        $t{ACB}->set_labels( undef, undef, qw(r3 bottom) );
        $t{DCB}->set_labels( undef, qw(left r3 bottom r1 right) );

        $t{DCB}->move( 150, 250, 10 );
        $t{DCB}->set_angles( undef, undef, "\\{alpha}" );
        $t{DCB}->fill($lime_green);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Since two sides and the angle between are "
                      . "the same for both triangles, then "
                      . "all the sides and angles are equal\\{nb}(I.4)" );

        $t{ACB}->l(3)->grey;
        $t{DCB}->l(1)->grey;
        $t2->down;
        $t2->allgrey;
        $t2->black( [ 2, 3, 4 ] );
        $t2->math("  BD=r1 \\{angle}DBC=\\{alpha} BC=r3");
        $t2->math("  AC=r1 \\{angle}ACB=\\{alpha} BC=r3");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{ACB}->l(3)->normal;
        $t{DCB}->l(1)->normal;
        $t{DCB}->set_angles( undef, "\\{alpha}", undef, 0, 70, 0 );
        $t2->math("  \\{therefore} \\{angle}DCB = \\{angle}ABC = \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{DCB}->move( -150, -250, 10 );
        $t{DCB}->fill($teal);
        $t{DCB}->remove_labels;
        $t{ACB}->remove_labels;
        $t{ACB}->p(2)->remove;
        $t{ACB}->p(3)->remove;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $a{ACD} =
          Angle->new( $pn, $t{DCB}->l(1), $t{ACB}->l(1), -size => 120 )
          ->label("\\{beta}");
        $t2->allgrey;
        $t2->math("  let \\{angle}ACD = \\{beta}");
        $t4->y( $t2->y );
        $t2->math("=> \\{beta} + \\{alpha} = \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->explain(
                   "We now have an angle \\{alpha} which is equal to \\{alpha} "
                     . "plus \\{beta}" );
        $t1->explain(
             "This leaves us with a violation of the common notion\\{nb}5 that "
               . "the whole is greater than the part" );
        $t1->explain("... unless \\{beta} is zero!");
        $t4->math("              \\{wrong}");
        $t4->allred;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "This implies that D is concurrent with A, and that "
                      . "the two sides of the triangle are equal" );
        $t{ACB}->remove;
        $t{DCB}->set_labels( qw(r left), undef, undef, qw( r right) );
        $a{ACD}->remove;
        Point->new( $pn, $t{DCB}->p(1)->coords )->label( "A", "top" );

        $t2->down;
        $t4->allgrey;
        $t2->allgrey;
        $t2->blue(0);
        $t2->math("A = D");
        $t2->math("AC = DB = r");
    };

    return \@steps;
}

