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
my $title =
    "If in a triangle the square on one of the sides equals the "
  . "sum of the squares on the remaining two sides of the triangle, then "
  . "the angle contained by the remaining two sides of the triangle is right.";

my $pn = PropositionCanvas->new( -number => 48, -title => $title );
Proposition::init($pn);
$pn->copyright;

my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 450, 420 );
my $t3 = $pn->text_box( 450, 400 );

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,48);
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
    my $top = 300;
    my $bot = 475;
    my @A   = ( 225, $bot );
    my @B   = ( 350, $bot );
    my @C   = ( 225, $top );

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a triangle ABC, where the square of AB and AC equals the square of BC");
        $t{ABC} = Triangle->new( $pn, @A, @B, @C, 1, -points => [qw(A bottomleft B bottomright C top)] );
        $s{AB} = Polygon->new( $pn, 4, CalculatePoints->square( @B, @A ) )->fill($sky_blue);
        $s{AC} = Polygon->new( $pn, 4, CalculatePoints->square( @A, @C ) )->fill($lime_green);
        $s{BC} = Polygon->new( $pn, 4, CalculatePoints->square( @C, @B ) )->fill($pale_pink);
        $t2->math("\\{square}AB + \\{square}AC = \\{square}BC");
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then the angle CAB is a right angle");
        $t{ABC}->set_angles( " ", undef, undef );
        $t2->math("\\{angle}CAB = \\{right}");
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t2->erase;
        $t2->math("\\{square}AB + \\{square}AC = \\{square}BC");
        $t2->allblue;
        $t2->down;
        $t3->y($t2->y);
        $t1->down;
        $t1->title("Proof:");
        $t{ABC}->a(1)->remove;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $s{AC}->remove;
        $s{AB}->remove;
        $s{BC}->remove;
        $t1->explain("Draw a line perpendicular to AC, from point A");
        $l{ADx} = $t{ABC}->l(3)->perpendicular( $t{ABC}->p(1) );
        $a{CAD} = Angle->new( $pn, $t{ABC}->l(3), $l{ADx} );
        $t3->math("AC \\{right} AD");
        $t2->allgrey;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Define a point D such that AD equals AB");
        $c{A} = Circle->new( $pn, @A, @B );
        my @p = $c{A}->intersect( $l{ADx} );
        $p{D} = Point->new( $pn, @p )->label( "D", "bottom" );
        $l{AD} = Line->new( $pn, @A, @p );
        $l{ADx}->remove;
        $c{A}->remove;
        $t{ABC}->p(1)->label( "A", "bottom" );
        $t{ABC}->p(2)->label( "B", "bottom" );
        $t3->allgrey;
        $t3->math("AD = AB");
    };
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw line CD");
        $l{CD} = Line->new( $pn, @C, $p{D}->coords );
        $t3->allgrey;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Since the triangle CDA is a right angle triangle, "
                      . "the square of line CD equals the squares of AD and AC\\{nb}(I.47)" );
        my @D = $p{D}->coords;
        $s{DA} = Polygon->new( $pn, 4, CalculatePoints->square( @A, @D ) )->fill($blue);
        $s{CA} = Polygon->new( $pn, 4, CalculatePoints->square( @C, @A ) )->fill($green);
        $s{CD} = Polygon->new( $pn, 4, CalculatePoints->square( @D, @C ) )->fill($pink);

        $t3->math("\\{square}AD + \\{square}AC = \\{square}CD");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("But since AD equals AB,");
        
        $t3->allgrey;
        $t2->allgrey;
        $t3->black([1]);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then the square on AD equals the square on AB");
        $s{AB} = Polygon->new( $pn, 4, CalculatePoints->square( @B, @A ) )->fill($sky_blue);
        
        $t3->allgrey;
        $t2->allgrey;
        $t3->black([1]);
        $t3->math("\\{square}AD = \\{square}AB");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Thus the square of CD equals the square of CB");
        $s{DA}->remove;
        $s{CA}->remove;
        $s{BC} = Polygon->new( $pn, 4, CalculatePoints->square( @C, @B ) )->fill($pale_pink);
        $s{AB}->remove;

        $t3->allgrey;
        $t2->allgrey;
        $t3->black([-1,-2]);
        $t2->blue(0);
        $t3->math("\\{square}CD = \\{square}CB");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("If the squares are equal, so are the lines");
    
        $t3->allgrey;
        $t2->allgrey;
        $t3->black([-1]);
        $t3->math("CD = CB");
    };


    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Triangle ABC and ADC have three equal sides");
        $s{BC}->remove;
        $s{CD}->remove;
        Angle->new( $pn, $t{ABC}->l(1), $t{ABC}->l(3), -size => 30 );
        $t3->allgrey;
        $t3->black([1,5]);
        $t3->math("\\{triangle}CAD \\{equivalent} \\{triangle}CAB");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Thus their angles are also equal\\{nb}(I.8)");
        $t3->allgrey;
        $t3->black([-1]);
        $t3->math("\\{angle}CAD = \\{angle}CAB = \\{right}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->black(-1);
        $t2->blue(0);
    };

    return \@steps;
}
