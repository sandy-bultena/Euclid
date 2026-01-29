#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title = "To draw a straight line at right angles to a given "
  . "straight line from a given point on it.";

my $pn = PropositionCanvas->new( -number => 11, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 500, 430 );
my $t3 = $pn->text_box( 700, 150, -anchor => "c", -width => 1000 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,11);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #11
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @A = ( 100, 400 );
    my @B = ( 450, 400 );

    my @steps;

    push @steps, sub {
        $t3->title("Definition - Right Angle");
        $t3->down;
        $t3->explain( "When a straight line standing on a straight line makes "
              . "the adjacent angles equal to one another, each of the equal angles "
              . "is right, and the straight line standing on the other is called a "
              . "perpendicular to that on which it stands." );
        $p{1} = Point->new($pn, 100, 600 )->label( "A", "left" );
        $p{2} = Point->new($pn, 400, 600 )->label( "B", "right" );
        $p{3} = Point->new($pn, 250, 600 )->label( "C", "bottom" );
        $p{4} = Point->new($pn, 250, 300 )->label( "D", "top" );
        $l{1} = Line->new($pn, 100, 600, 250, 600, -1 );
        $l{2} = Line->new($pn, 250, 600, 400, 600, -1 );
        $l{3} = Line->new($pn, 250, 300, 250, 600, -1 );
        $a{1} = Angle->new($pn, $l{3}, $l{1}, -size => 40 );
        $a{2} = Angle->new($pn, $l{2}, $l{3}, -size => 60 );
        $t2->math("\\{angle}ACD = \\{angle}BCD = \\{right} (right angle)");
    };
    push @steps, sub {
        $l{1}->remove;
        $l{2}->remove;
        $l{3}->remove;
        $a{1}->remove;
        $a{2}->remove;
        $t3->erase;
        $p{1}->remove;
        $p{2}->remove;
        $p{3}->remove;
        $p{4}->remove;
        $t2->erase;
    };
    push @steps, sub {
        $t1->title("Construction:");
        $t1->explain("Start with a line segment AB, and an arbitrary "
        . "point C on this line");
        $p{A} = Point->new($pn,@A)->label( "A", "left" );
        $p{B} = Point->new($pn,@B)->label( "B", "right" );
        $l{AB} = Line->new($pn, @A, @B );
        $p{C} =
          Point->new($pn, $l{AB}->point( 0.55 * $l{AB}->length ) )
          ->label( "C", "bottom" );
        ( $l{AC}, $l{BC} ) = $l{AB}->split( $p{C} );
    };

    push @steps, sub {
        $t1->explain("Define another point D on line AB");
        $t1->explain("Define point E such that EC equals CD");
        $p{D} =
          Point->new($pn, $l{AC}->point( 0.28 * $l{AC}->length ) )
          ->label( "D", "bottom" );
        $c{C} = Circle->new($pn, $p{C}->coords, $p{D}->coords );
        my @p  = $c{C}->intersect( $l{BC} );
        my @pp = $p{D}->coords;
        $p{E} = Point->new($pn,@p)->label( "E", "bottom" );
        ( $l{CE}, $l{EB} ) = $l{BC}->split( $p{E} );
        ( $l{AD}, $l{CD} ) = $l{AC}->split( $p{D} );
    };

    push @steps, sub {
        $c{C}->grey;
        $t1->explain(
            "Construct an equilateral triangle on DE and label the vertex F".
            "\\{nb}(I.1)");
        $t{1} =  EquilateralTriangle->build($pn, $p{D}->coords, $p{E}->coords, 2 );
        ( $l{DF}, $l{EF}, $p{F} ) = ($t{1}->l(3),$t{1}->l(2),$t{1}->p(3));
        $p{F}->label( "F", "top" );
        $l{DF}->normal;
        $l{EF}->normal;
    };

    push @steps, sub {
        $t1->explain("Construct line segment FC");
        $l{CF} = Line->join( $p{F}, $p{C});
    };

    push @steps, sub {
        $t1->explain("Angle ACF and angle BCF are right angles");
        $a{ACF} = Angle->new($pn, $l{CF}, $l{AC} );
        $a{BCF} = Angle->new($pn, $l{BC}, $l{CF}, -size => 50 );
        $l{DF}->grey;
        $l{EF}->grey;
    };

    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $a{ACF}->remove;
        $a{BCF}->remove;
    };
    push @steps, sub {
        $t1->explain(
            "Line DC equals line CE since they are radii of the same circle");
        $c{C}->normal;
        $l{CD}->label( "r1", "bottom" );
        $l{CE}->label( "r1", "bottom" );
        $t2->math("DC = CE = r1");
    };
    push @steps, sub {
        $c{C}->grey;
        $t1->explain( "FD and FE are equal since they are two "
              . "sides of an equilateral triangle" );
        $l{DF}->normal;
        $l{EF}->normal;
        $l{DF}->label( "r2", "topleft" );
        $l{EF}->label( "r2", "topright" );
        $t2->math("FD = FE = r2");
    };
    push @steps, sub {
        $t1->explain(
                "Triangle DCF and triangle FCE have all three "
              . "sides equal to each other, "
              . "thus all the angles are equal to each other\\{nb}(I.8)"
        );
        $t{3} = Triangle->assemble($pn,-lines=>[$l{DF},$l{CF},$l{CD}])->fill($sky_blue);;
        $t{2} = Triangle->assemble($pn,-lines=>[$l{EF},$l{CF},$l{CE}])->fill($lime_green);

        $a{CDF} = Angle->new($pn, $l{CD}, $l{DF} )->label("\\{beta}");
        $a{CEF} = Angle->new($pn, $l{EF}, $l{CE} )->label("\\{beta}");
        $a{DFC} = Angle->new($pn, $l{DF}, $l{CF}, -size => 50 )->label("\\{theta}");
        $a{CFE} = Angle->new($pn, $l{CF}, $l{EF}, -size => 60 )->label("\\{theta}");
        $a{ACF} = Angle->new($pn, $l{CF}, $l{AC} )->label("\\{alpha}");
        $a{BCF} = Angle->new($pn, $l{BC}, $l{CF}, -size => 30 )->label("\\{alpha}");
        $t2->math("\\{angle}CDF = \\{angle}CEF = \\{beta}");
        $t2->math("\\{angle}DFC = \\{angle}EFC = \\{theta}");
        $t2->math("\\{angle}FCD = \\{angle}FCE = \\{alpha}");
    };

    push @steps, sub {
        $t1->explain(
            "Angles FCD and FCE are equal, and therefore are 'right angles'");
        $a{CDF}->remove;
        $a{CEF}->remove;
        $a{DFC}->remove;
        $a{CFE}->remove;
        $l{DF}->grey;
        $l{EF}->grey;
        $l{CD}->label;
        $l{CE}->label;
        $a{ACF}->label;
        $a{BCF}->label;
        $t{3}->fill;
        $t{2}->fill;
    };
    return \@steps;
}

