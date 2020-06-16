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
my $title = "Straight lines which join the ends of equal and parallel straight "
  . "lines in the same directions are themselves equal and parallel.";

my $pn = PropositionCanvas->new( -number => 33, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 500 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,33);
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

    my @A = ( 50,  200 );
    my @B = ( 300, 200 );
    my @C = ( 125, 350 );
    my @D = ( 375, 350 );

    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Let lines AB and CD be parallel and equal");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $l{AB} = Line->new( $pn, @A, @B )->label( "x", "top" );

        $p{D} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "bottom" );
        $l{CD} = Line->new( $pn, @C, @D )->label( "x", "bottom" );

        $t2->math("AB = CD");
        $t2->math("AB \\{parallel} CD");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create lines AC and BD");
        $l{AC} = Line->new( $pn, @A, @C );
        $l{BD} = Line->new( $pn, @B, @D );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Lines AC and BD are equal and parallel");
        $l{AC}->label( "y", "left" );
        $l{BD}->label( "y", "right" );
        $t2->down;
        $t2->math("AC = BD");
        $t2->math("AC \\{parallel} BD");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("AB = CD");
        $t2->math("AB \\{parallel} CD");
        $t2->allblue;
        $l{AC}->label;
        $l{BD}->label;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Join points BC");
        $l{BC} = Line->new( $pn, @B, @C );
        $t2->allgrey;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{XBC} = $l{BC}->clone;
        $l{XBC}->extend(100);
        $l{XBC}->prepend(100);

        $l{XAB} = $l{AB}->clone;
        $l{XAB}->extend(100);

        $l{XCD} = $l{CD}->clone;
        $l{XCD}->prepend(100);

        $l{AC}->grey;
        $l{BD}->grey;

        $t1->explain( "Since line BC intersects two parallel lines (AB and CD), angles ABC and BCD are equal (I.29)" );

        $a{ABC} = Angle->new( $pn, $l{AB}, $l{BC} )->label("\\{alpha}");
        $a{BCD} = Angle->new( $pn, $l{CD}, $l{BC} )->label("\\{alpha}");

        $t2->down;
        $t2->down;
        $t2->math("\\{angle}ABC = \\{angle}BCD = \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{AC}->normal;
        $l{BD}->normal;
        $t1->explain(   "Since triangles ABC and BCD have two "
                      . "sides equal to each other, with the angle between the "
                      . "two sides equal, then the triangles are equal\\{nb}(I.4)" );

        $t{ABC} = Triangle->new( $pn, @A, @B, @C, -1 )->fill($sky_blue);
        $t{BCD} = Triangle->new( $pn, @B, @C, @D, -1 )->fill($lime_green);

        $t2->allgrey;
        $t2->blue(0);
        $t2->black(2);
        $t2->math("\\{triangle}ABC \\{equivalent} \\{triangle}BCD");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $a{CBD} = Angle->new( $pn, $l{BC}, $l{BD}, -size => 20 )->label("\\{beta}");
        $a{ACB} = Angle->new( $pn, $l{BC}, $l{AC}, -size => 20 )->label("\\{beta}");
        $a{BAC} = Angle->new( $pn, $l{AC}, $l{AB}, -size => 20 )->label("\\{delta}");
        $a{CDB} = Angle->new( $pn, $l{BD}, $l{CD}, -size => 20 )->label("\\{delta}");

        $l{AC}->label( "y", "left" );
        $l{BD}->label( "y", "right" );

        $t2->down;
        $t2->math("\\{therefore} AC = BD");
        $t2->math("  \\{angle}CBD = \\{angle}ACB = \\{beta}");
        $t2->math("  \\{angle}BAC = \\{angle}CDB = \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{XAB}->remove;
        $l{AB}->grey;
        $l{XCD}->remove;
        $l{CD}->grey;
        $l{XBD} = $l{BD}->clone;
        $l{XBD}->prepend(100);
        $l{XAC} = $l{AC}->clone(100);
        $l{XAC}->extend(100);
        $a{ABC}->remove;
        $a{BCD}->remove;
        $a{BAC}->remove;
        $a{CDB}->remove;
        $t{ABC}->remove;
        $t{BCD}->remove;
        $t1->explain( "Lines BD and AC are parallel since the alternate angles are equal (I.27)" );
        $t2->down;
        $t2->allgrey;
        $t2->black(-2);
        $t2->math("BD \\{parallel} AC");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{XAC}->remove;
        $l{BC}->remove;
        $l{XBC}->remove;
        $l{XBD}->remove;
        $l{AB}->normal;
        $l{CD}->normal;
        $a{CBD}->remove;
        $a{ACB}->remove;
        $t2->allgrey;
        $t2->black(-1);
        $t2->blue([0,1]);
    };

    return \@steps;
}

