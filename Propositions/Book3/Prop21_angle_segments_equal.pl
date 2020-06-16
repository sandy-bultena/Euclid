#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);

# ============================================================================
# Definitions
# ============================================================================
my $title = "In a circle the angles in the same segment are equal to one another.";

$pn->title( 21, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 560, 180 );
my $t5 = $pn->text_box( 560, 180 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 21 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my ( %l, %p, %c, %s, %a );

    my @c1 = ( 290, 420 );
    my $r1 = 225;
    my $f  = 0.6;
    my $ao = 40 * 3.14159 / 180;

    # -------------------------------------------------------------------------
    # definition
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("Definition - Segment of a Circle");
        $t4->explain("A 'segment of a circle' is the figure contained by a straight "."line and a circumference of a circle");
        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $p{B} = $c{A}->point( 180 + 46 )->label( "B", "bottom" );
        $p{D} = $c{A}->point(-46)->label( "D", "bottom" );
        $l{DB} = Line->join( $p{B}, $p{D} );
        $c{DB} = Arc->newbig( $pn, $r1, $p{D}->coords, $p{B}->coords );

    };

    push @$steps, sub {
        $t4->down;
        $t4->title("Definition - Angles in a Segment");
        $t4->explain("An 'angle in a segment' is the angle which, ");
        $t1->y( $t4->y );
        $t4->explain("-");
        $t1->explain( "when a point is taken on the circumference of the segment (point A) and " );
        $p{A} = $c{A}->point(115)->label( "A", "top" );

    };

    push @$steps, sub {
        $t4->y( $t1->y );
        $t4->explain("-");
        $t1->explain(   "straight lines are "
                      . "joined from it to the extremities of the straight "
                      . "line (BD) which is the 'base of the segment', " );
        local $Shape::AniSpeed = 20000;
        $l{AD} = Line->join( $p{A}, $p{D} );
        $l{AB} = Line->join( $p{A}, $p{B} );
        $t4->y( $t1->y );
        $t4->explain( "is contained by the straight lines so joined (angle \\{alpha})" );

        $a{A} = Angle->new( $pn, $l{AB}, $l{AD} )->label("\\{alpha}");

    };

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->erase;
        $t4->title("In other words");
        $t4->explain("If we have a circle segment BAD, "
        ."any angle formed by lines from a given point on the ".
        "circumference of the circle "
        ."to the points B and D will be equal to any other angle formed in the same fashion");
        $p{E} = $c{A}->point(0)->label( "E", "right" );
        $l{EB} = Line->join( $p{E}, $p{B} );
        $l{ED} = Line->join( $p{E}, $p{D} );

        $a{E} = Angle->new( $pn, $l{EB}, $l{ED} )->label("\\{epsilon}");

        $t3->math("\\{epsilon} = \\{alpha}");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof");
        $t3->erase;
        $t1->y( $t4->y );
    };

    push @$steps, sub {
        $t4->explain("Let F be the centre of the circle, and join lines FB and\\{nb}FD");
        $t5->explain("F is the centre of the circle");
        $t5->allblue;
        $t3->y($t5->y);
        $t3->down;

        $p{F} = Point->new($pn,@c1)->label("F","top");
        $l{FB} = Line->join($p{F},$p{B});
        $l{FD} = Line->join($p{F},$p{D});
    };

    push @$steps, sub {
        $t4->explain("The angle BFD (\\{theta}) formed from the centre has the same base "
        ."as BAD (\\{alpha}) formed from the circumference of the circle, ");
        $t4->explain("Therefore BFD equals twice BAD (III.20)");
        $l{EB}->grey;
        $l{ED}->grey;
        $c{DB}->grey;
        $a{E}->grey;
        $a{F}=Angle->new($pn,$l{FB},$l{FD})->label("\\{theta}");
        $t3->math("\\{theta} = 2\\{alpha}");
    };

    push @$steps, sub {
        $t4->explain("Similarly, the angle BFD equals twice BED");        
        $l{EB}->normal;
        $l{ED}->normal;
        $l{AB}->grey;
        $l{AD}->grey;
        $a{A}->grey;
        $a{E}->normal;
        $t3->math("\\{theta} = 2\\{epsilon}");
    };

    push @$steps, sub {
        $t4->explain("Thus, BAD (\\{alpha}) and BED (\\{epsilon}) are equal");
        $l{FD}->grey;
        $l{FB}->grey;
        $l{AB}->normal;
        $l{AD}->normal;
        $a{A}->normal;
        $a{F}->grey;
        $t3->down;
        $t3->math("\\{epsilon} = \\{alpha}");
    };

    return $steps;

}

