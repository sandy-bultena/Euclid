#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
    "If two triangles have the two sides equal to two "
  . "sides respectively, and also have the base equal to the base, then they "
  . "also have the angles equal which are contained by the equal straight lines.";

my $pn = PropositionCanvas->new( -number => 8, -title => $title );
Proposition::init($pn);
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 500, 330 );

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,8);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #8
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @A = ( 100, 450 );
    my @B = ( 300, 450 );
    my @C = ( 250, 200 );

    my @D = ( 550, 700 );
    my @E = ( 350, 700 );
    my @F = ( 400, 450 );

    my @steps;

    push @steps, sub {
        $t1->title("In other words...");
        $t1->explain(
            "Given two triangles with three sides of one ".
            "triangle equal to the three sides of the other " . "triangle (SSS)" );

        $t{ABC} = Triangle->new(
                                 $pn, @A, @B, @C, 1,
                                 -points => [qw(A left B right C top)],
                               );

        $t{EDF} = Triangle->new(
                                 $pn, @E, @D, @F, 1,
                                 -points => [qw(E left D right F top)],
                               );
        $t2->math("CB = EF");
        $t2->math("AC = DF");
        $t2->math("AB = ED");
        $t2->allblue;
    };
    push @steps, sub {
        $t1->explain("Then the two triangles are equivalent in all respects");
        $t2->math("\\{triangle}ABC \\{equivalent} \\{triangle}DEF");
        $t{ABC}->set_angles(qw(\\{alpha} \\{beta} \\{theta}));
        $t{EDF}->set_angles(qw(\\{beta} \\{alpha} \\{theta}));
    };

    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t{ABC}->remove_angles;
        $t{EDF}->remove_angles;
        $p{A} = $t{ABC}->p(1);
        $p{B} = $t{ABC}->p(2);
        $t2->clear;
                $t2->math("CB = EF");
        $t2->math("AC = DF");
        $t2->math("AB = ED");
        $t2->allblue;
        
    };

    push @steps, sub {
        $t1->explain( "Construct line segment BX equal to DE at point B\\{nb}(I.2)" );
        ( $l{BX}, $p{X}, @objs ) = $t{EDF}->l(1)->copy( $p{B} );
        $p{X}->label( "X", 'right' );

        #foreach my $obj (@objs) {
        #    $obj->remove;
        #}
        $t{EDF}->l(1)->grey;
        $t2->math("BX = DE");
    };

    push @steps, sub {
        $t1->explain( "Align BX to AB.  Since they are the same lengths, "."the endpoints are congruent" );
        $p{X}->remove;
        $l{BX}->red;
        $l{BX}->rotateTo( 180 + $t{ABC}->l(1)->angle );
        $t{ABC}->p(1)->raise;
        $p{X} = Point->new($pn,@A)->label("X","bottom");
    };

    push @steps, sub {
        $t1->explain("Construct line segment BZ equal to EF at point B\\{nb}(I.2)");
        ( $l{BZ}, $p{Z}, @objs ) = $t{EDF}->l(3)->copy( $p{B} );
        $p{Z}->label( "Z", 'right' );
        $t{EDF}->l(3)->grey;
        $t2->math("BZ = EF");

       # foreach my $obj (@objs) {
       #     $obj->remove if $obj;
       # }
    };

    push @steps, sub {
        $t1->explain("Construct line segment AY equal to DF at point A\\{nb}(I.2)");
        ( $l{AY}, $p{Y}, @objs ) = $t{EDF}->l(2)->copy( $p{A} );
        $p{Y}->label( "Y", 'right' );
        $t{EDF}->l(2)->grey;
        foreach my $obj (@objs) {
            $obj->remove;
        }
        $t2->math("AY = DF");
    };

    push @steps, sub {
        $t1->explain("Where do ends of the lines BZ and AY meet?");
        $p{Z}->remove;
        $p{Y}->remove;
        $l{BZ}->label;
        $l{AY}->label;
        $l{BZ}->red;
        $l{BZ}->rotateTo( $t{ABC}->l(2)->angle - 10 );
        $l{AY}->red;
        $l{AY}->rotateTo( $t{ABC}->l(3)->angle - 10 + 180 );
        $p{Z} = Point->new($pn,$l{BZ}->end)->label("Z","top");
        $p{Y} = Point->new($pn,$l{AY}->end)->label("Y","top");
    };

    push @steps, sub {
        $t1->explain("They can only meet at one point, 'C'\\{nb}(I.7)");
        $p{Z}->remove;
        $p{Y}->remove;
        $l{BZ}->rotateTo( $t{ABC}->l(2)->angle );
        $l{AY}->rotateTo( $t{ABC}->l(3)->angle + 180 );
    };

    push @steps, sub {
        $t1->explain( "Since all the endpoints of the lines are congruent, "."then the angles must also be congruent" );
        $t{EDF}->lines_normal;
        $t{ABC}->angles_draw;
        $t{EDF}->angles_draw;
    };

    push @steps, sub {
        $t1->explain("Thus the two triangles are equivalent");
        $t2->allgrey;
        $t2->blue([0..2]);
        $t2->math("\\{triangle}ABC \\{equivalent} \\{triangle}DEF");
    };

    return \@steps;
}

