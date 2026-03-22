#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
    "To construct a triangle out of three straight lines which equal three "
  . "given straight lines - thus it is necessary that the sum of any two of "
  . "the straight lines should be greater than the remaining one.";

my $pn = PropositionCanvas->new( -number => 22, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 200 );
my $t3 = $pn->text_box( 475, 475 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,22);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;


# ============================================================================
# Proposition #22
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my @objs;

    my @B = ( 75, 220, 250, 220 );
    my @A = ( 75, 200, 240, 200 );
    my @C = ( 75, 240, 175, 240 );
    my @D = ( 75, 400 );
    my @E = ( 600, 400 );
    my @steps;

    push @steps, sub {
        $t1->down;
        $t1->title("Construction");
        $t1->explain( "Start with three lines a,b,c where the sum of any two "
              . "is greater than the third" );
        $p{A} = Point->new($pn, @A[ 0, 1 ] )->label( "a", "left" );
        $l{A} = Line->new($pn,@A);
        $p{B} = Point->new($pn, @B[ 0, 1 ] )->label( "b", "left" );
        $l{B} = Line->new($pn,@B);
        $p{C} = Point->new($pn, @C[ 0, 1 ] )->label( "c", "left" );
        $l{C} = Line->new($pn,@C);
        $t2->math("b + c > a");
        $t2->math("c + a > b");
        $t2->math("a + b > c");
    };

    push @steps, sub {
        $t1->explain( "Construct a line DE of sufficient length such that "
              . "it is greater than the sum of a,b,c" );
        $p{D} = Point->new($pn,@D)->label( "D", "left" );
        $l{DE} = Line->new($pn, @D, @E );
        $p{E} = Point->new($pn,@E)->label( "E", "right" );
    };
    push @steps, sub {
        $t1->explain("Define a point F such that DF is equal in length to A\\{nb}(I.3)");
        ( $l{DF}, $p{F} ) = $l{A}->copy_to_line( $p{D}, $l{DE} );
        $p{F}->label( "F", "bottom" );
        $l{DF}->label( "a", "bottom" );
        $t3->math("DF = a");
    };

    push @steps, sub {
        $t1->explain("Define a point G such that FG is equal in length to B\\{nb}(I.3)");
        ( $l{FG}, $p{G} ) = $l{B}->copy_to_line( $p{F}, $l{DE} );
        $p{G}->label( "G", "bottom" );
        $l{FG}->label( "b", "bottom" );
        $t3->math("FG = b");
    };

    push @steps, sub {
        $t1->explain("Define a point H such that GH is equal in length to C\\{nb}(I.3)");
        ( $l{GH}, $p{H} ) = $l{C}->copy_to_line( $p{G}, $l{DE} );
        $p{H}->label( "H", "bottom" );
        $l{GH}->label( "c", "bottom" );
        $t3->math("GH = c");
    };

    push @steps, sub {
        $t1->explain("Draw a circle, with center F, and radius DF");
        $c{F} = Circle->new($pn, $p{F}->coords, @D );
    };

    push @steps, sub {
        $t1->explain("Draw a circle, with center G, and radius GH");
        $c{G} = Circle->new($pn, $p{G}->coords, $p{H}->coords );
    };

    push @steps, sub {
        $t1->explain( "From the intersection point K, construct two lines "
              . "KF and KG" );
        my @p=$c{G}->intersect( $c{F});
        $p{K} = Point->new($pn,  @p[0,1] )->label( "K", "top" );
        $l{FK} = Line->join( $p{K}, $p{F});
        $l{GK} = Line->join( $p{K}, $p{G});
        $c{G}->grey;
        $c{F}->grey;
    };

    push @steps, sub {
        $t1->explain( "Triangle FKG has been constructed from lines of "
              . "length a, b and c" );
    };

    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t1->explain( "Line FK and FD are equal, since they are the radius "
              . "of the same circle, and FD is equal to a" );
        $l{GK}->grey;
        $c{F}->normal;
        $l{FK}->label( "a", "left" );
        $t3->math("FK = FD = a");
    };

    push @steps, sub {
        $t1->explain( "Line GK and GH are equal, since they are the radius "
              . "of the same circle, and GH is equal to c" );
        $l{FK}->grey;
        $c{F}->grey;
        $c{G}->normal;
        $l{GK}->normal;
        $l{GK}->label( "c", "right" );
        $t3->math("GK = GH = c");
    };
    push @steps, sub {
        $l{FK}->normal;
        $c{F}->remove;
        $c{G}->remove;
    };

    return \@steps;
}

