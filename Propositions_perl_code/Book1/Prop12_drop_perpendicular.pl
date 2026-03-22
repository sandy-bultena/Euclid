#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title = "To draw a straight line perpendicular to a given infinite "
  . "straight line from a given point not on it.";

my $pn = PropositionCanvas->new( -number => 12, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 500, 430 );
my $t3 = $pn->text_box( 700, 150, -anchor=>"n",-width => 1000 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,12);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #12
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @A = ( 80, 500 );
    my @B = ( 480, 500 );
    my @C = ( 255, 290 );
    my @D = ( 180, 525 );

    my @steps;

    push @steps, sub {
        $t3->title("Definition - Right Angle");
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
        $t2->explain("DC is perpendicular to AB");
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
        $t1->explain( "Start with an arbitrary line segment AB and an "
              . "arbitrary point C not on the line" );
        $p{A} = Point->new($pn, @A )->label( "A", "bottom" );
        $p{B} = Point->new($pn, @B )->label( "B", "bottom" );
        $l{AB} = Line->new($pn, @A, @B );
        $p{C} = Point->new($pn,@C)->label( "C", "top" );
    };

    push @steps, sub {
        $t1->explain("Define another point D on the other side of the line");
        $p{D} = Point->new($pn,@D)->label( "D", "bottom" );
    };

    push @steps, sub {
        $t1->explain("Construct a circle with center C, and radius CD");
        $c{C} = Circle->new($pn, @C, @D );
    };

    push @steps, sub {
        $t1->explain( "Define points E and F as the "
              . "intersection between line and the circle " );
        my @p = $c{C}->intersect( $l{AB} );
        $p{F} = Point->new($pn, @p[ 0, 1 ] )->label( "F", "top" );
        $p{E} = Point->new($pn, @p[ 2, 3 ] )->label( "E", "top" );
        $c{C}->grey;
    };

    push @steps, sub {
        $t1->explain("Bisect line EF at point G (I.9)");
        $p{D}->remove;
        $l{EF} = Line->join( $p{E}, $p{F});
        $p{G} = $l{EF}->bisect;
        $l{AB}->grey;
        $p{G}->label( "G", "bottom" );
    };

    push @steps, sub {
        $t1->explain("Create line CG");
        $l{CG} = Line->join( $p{C}, $p{G});
    };

    push @steps, sub {
        $t1->explain("Line CG is perpendicular to EF");
        ( $l{AE}, $l{EG}, $l{FG}, $l{BF} ) =
          $l{AB}->split( $p{E}, $p{G}, $p{F} );
        $a{CGE} = Angle->new($pn, $l{CG}, $l{EG} );
        $a{CGF} = Angle->new($pn, $l{FG}, $l{CG} );
        $l{AE}->grey;
        $l{BF}->grey;
        $l{EG}->remove;
        $l{FG}->remove;
    };

    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $a{CGE}->remove;
        $a{CGF}->remove;
    };

    push @steps, sub {
        $t1->explain("Create lines CE and CF");
        $t1->explain(
            "CE and CF are equal since they are radii of the same circle");
        $c{C}->normal;
        $l{CG}->grey;
        $l{EF}->grey;
        $p{G}->grey;
 
        $l{CE} = Line->join( $p{C}, $p{E});
        $l{CF} = Line->join( $p{C}, $p{F});
        $l{CE}->label( "r1", "left" );
        $l{CF}->label( "r1", "right" );

        $t2->math("CE = CF = r1");
    };

    push @steps, sub {
        $c{C}->grey;
        $t1->explain("EG and GF are equal since G bisects EF");
        $l{EF}->normal;
        $p{G}->normal;
        $l{EG}->label( "r2", "bottom" );
        $l{FG}->label( "r2", "bottom" );
        $l{CE}->grey;
        $l{CF}->grey;
        $l{EG}->normal;
        $t2->math("EG = GF = r2");
    };

    push @steps, sub {
        $t1->explain( "Triangles ECG and FCG have three congruent sides "
        );
        $t{3} = Triangle->assemble($pn,-lines=>[$l{EG},$l{CG},$l{CE}])->fill($sky_blue);;
        $t{2} = Triangle->assemble($pn,-lines=>[$l{FG},$l{CF},$l{CG}])->fill($lime_green);
        $l{CE}->normal;
        $l{CG}->normal;
        $l{CF}->normal;
    };

    push @steps, sub {
        $t1->explain( "hence the triangles are congruent, ".
        "and all the angles are congruent"
        );
        $a{ECG} = Angle->new($pn, $l{CE}, $l{CG} )->label("\\{alpha}",30);
        $a{FCG} = Angle->new($pn, $l{CG}, $l{CF} )->label("\\{alpha}");
        $a{CEG} = Angle->new($pn, $l{EG}, $l{CE} )->label("\\{beta}",20);
        $a{CFG} = Angle->new($pn, $l{CF}, $l{FG} )->label("\\{beta}",30);
        $a{CGE} = Angle->new($pn, $l{CG}, $l{EG} )->label("\\{gamma}",30);
        $a{CGF} = Angle->new($pn, $l{FG}, $l{CG} )->label("\\{gamma}");
        $t2->math("\\{angle}CGE = \\{angle}CGF = \\{gamma}");
    };

    push @steps, sub {
        $t1->explain(
                "Since CGE and CGF are equal, and EF is a line, by definition "
              . "the angles are right angles, and CG is perpendicular to EF" );
        $a{ECG}->remove;
        $a{FCG}->remove;
        $a{CEG}->remove;
        $a{CFG}->remove;
        $a{CGE}->label;
        $a{CGF}->label;
        $l{CE}->remove;
        $l{CF}->remove;
        $l{EG}->label;
        $l{FG}->label;
        $t{3}->fill;
        $t{2}->fill;
        $t2->down;
        $t2->math("\\{angle}CGE = \\{angle}CGF = \\{right}");
    };

    return \@steps;
}
