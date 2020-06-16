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
my $title = "In parallelogrammic areas the opposite sides and angles equal one another, and the diameter bisects the areas.";

my $pn = PropositionCanvas->new( -number => 34, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 300 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,34);
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

    my @A = ( 75,  200 );
    my @B = ( 350, 200 );
    my @C = ( 150, 400 );
    my @D = ( 425, 400 );

    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Let ABCD define a parallelogram");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{D} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "bottom" );
        $l{AB} = Line->new( $pn, @A, @B );
        $l{BD} = Line->new( $pn, @B, @D );
        $l{CD} = Line->new( $pn, @D, @C );
        $l{AC} = Line->new( $pn, @C, @A );

        $t2->math("AB \\{parallel} CD");
        $t2->math("AC \\{parallel} BD");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The opposite angles are equal");
        $a{BAC} = Angle->new( $pn, $l{AC}, $l{AB} )->label("\\{theta}");
        $a{CDB} = Angle->new( $pn, $l{BD}, $l{CD} )->label("\\{theta}");
        $a{DBA} = Angle->new( $pn, $l{AB}, $l{BD} )->label("\\{alpha}");
        $a{ACD} = Angle->new( $pn, $l{CD}, $l{AC} )->label("\\{alpha}");
        $t2->down;
        $t2->math("\\{angle}BAC = \\{angle}CDB = \\{theta}");
        $t2->math("\\{angle}DBA = \\{angle}ACD = \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The opposite sides are equal");
        $l{AB}->label( "x", "top" );
        $l{CD}->label( "x", "bottom" );
        $t2->math("AB = CD = x");
        $l{AC}->label( "y", "left" );
        $l{BD}->label( "y", "right" );
        $t2->math("AC = BD = y");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $a{BAC}->remove;
        $a{CDB}->remove;
        $a{DBA}->remove;
        $a{ACD}->remove;
        $l{AC}->label;
        $l{BD}->label;
        $l{CD}->label;
        $l{AB}->label;
        $t1->explain("Let BC be the diameter (diagonal) of the parallelogram");
        $l{BC} = Line->new( $pn, @B, @C );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The diameter BC bisects the parallelogram");
        $t2->math("\\{triangle}ABC = \\{triangle}BCD");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
        $t2->math("AB \\{parallel} CD");
        $t2->math("AC \\{parallel} BD");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{XBC} = $l{BC}->clone;
        $l{XBC}->extend(100);
        $l{XBC}->prepend(100);

        $l{XAB} = $l{AB}->clone;
        $l{XAB}->extend(100);

        $l{XCD} = $l{CD}->clone;
        $l{XCD}->extend(100);

        $l{AC}->grey;
        $l{BD}->grey;

        $t1->explain("Since line BC intersects two parallel lines (AB and CD), angles ABC and BCD are equal (I.29)");

        $a{ABC} = Angle->new( $pn, $l{AB}, $l{BC}, -size => 30 )->label("\\{epsilon}");
        $a{BCD} = Angle->new( $pn, $l{CD}, $l{BC}, -size => 30 )->label("\\{epsilon}");

        $t2->grey(1);
        $t3->allgrey;
        $t3->math("\\{angle}ABC = \\{angle}BCD = \\{epsilon}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{XAB}->remove;
        $l{XCD}->remove;

        $l{XAC} = $l{AC}->clone;
        $l{XAC}->prepend(100);

        $l{XBD} = $l{BD}->clone;
        $l{XBD}->prepend(100);

        $l{AB}->grey;
        $l{CD}->grey;

        $a{ABC}->grey;
        $a{BCD}->grey;

        $t1->explain("Since line BC intersects two parallel lines (AC and BD), angles ACB and CBD are equal (I.29)");

        $a{ACB} = Angle->new( $pn, $l{BC}, $l{AC} )->label("\\{beta}");
        $a{CBD} = Angle->new( $pn, $l{BC}, $l{BD} )->label("\\{beta}");

        $t2->grey(0);
        $t2->blue(1);
        $t3->allgrey;
        $t3->math("\\{angle}ACB = \\{angle}CBD = \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{XAC}->remove;
        $l{XBD}->remove;
        $l{XBC}->remove;
        $l{AB}->normal;
        $l{CD}->normal;
        $l{AC}->normal;
        $l{BD}->normal;
        $a{ABC}->normal;
        $a{BCD}->normal;

        $t{ABC} = Triangle->new( $pn, @A, @B, @C, -1 )->fill($sky_blue);
        $t{BCD} = Triangle->new( $pn, @B, @C, @D, -1 )->fill($lime_green);

        $t1->explain(   "Triangles ABC and BDC have two equal angles, "
                      . "and one equal side (CB), hence they are equivalent (I.26), ");
        $t1->down;


        $t2->allgrey;
        $t3->black(0);
        $t3->math("\\{triangle}ABC \\{equivalent} \\{triangle}BCD");
    };


    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Which means all the sides, angles and areas are equal" );
        $l{AC}->label( "y", "left" );
        $l{BD}->label( "y", "right" );
        $l{AB}->label( "x", "top" );
        $l{CD}->label( "x", "bottom" );

        $a{BAC} = Angle->new( $pn, $l{AC}, $l{AB} )->label("\\{theta}");
        $a{BDC} = Angle->new( $pn, $l{BD}, $l{CD} )->label("\\{theta}");

        $t3->down;
        $t3->math("AB = CD = x");
        $t3->math("AC = BD = y");
        $t3->math("\\{angle}BAC = \\{angle}CBD = \\{theta}");
        $t3->math("\\{triangle}ABC = \\{triangle}BCD");
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{ABC}->remove;
        $t{BCD}->remove;
        $t1->explain( "Angle ABD is equal to the sum of ABC and CBD " . "and angle ACD is equal to the sum of ACB and BCD" );
        $t3->allgrey;
        $t3->math("\\{angle}ABD = \\{epsilon} +  \\{beta}");
        $t3->math("\\{angle}ACD = \\{beta} +  \\{epsilon}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore, angles ABD and ACD are equal");

        $a{ABC}->remove;
        $a{BCD}->remove;
        $a{ACB}->remove;
        $a{CBD}->remove;
        $l{BC}->remove;
        $a{DBA} = Angle->new( $pn, $l{AB}, $l{BD} )->label("\\{alpha}");
        $a{ACD} = Angle->new( $pn, $l{CD}, $l{AC} )->label("\\{alpha}");

        $t3->math("\\{angle}ABD = \\{angle}ACD = \\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allblue;
        $t3->allgrey;
        $t3->black([3,4,5,6,-1]);
    };

    return \@steps;
}

