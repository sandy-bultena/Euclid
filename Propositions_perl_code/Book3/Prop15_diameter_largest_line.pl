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
my $title =
    "Of straight lines in a circle the diameter is "
  . "greatest, and of the rest the "
  . "nearer to the centre is always greater than the more remote.";

$pn->title( 15, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 840, 150, -width => 480 );
my $t3 = $pn->text_box( 450, 180 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 15 );
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

    my @c1 = ( 260, 360 );
    my $r1 = 150;
    my $f  = 0.6;
    my $ao = 40 * 3.14159 / 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words ");
        $t1->explain(   "The line AD is larger than BC, since it "
                      . "passes through the centre of the circle, "
                      . "and line BC will be larger than FG since "
                      . "it is closer to the centre of the circle" );

        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{E} = Point->new( $pn, $c{A}->center )->label( "E", "topright" );
        $p{A} = $c{A}->point(90)->label( "A", "top" );
        $p{D} = $c{A}->point(-90)->label( "D", "bottom" );
        $l{AD} = Line->join( $p{A}, $p{D} );
        $p{B} = $c{A}->point(50)->label( "B", "top" );
        $p{C} = $c{A}->point(-70)->label( "C", "bottom" );
        $l{BC} = Line->join( $p{B}, $p{C} );
        $p{F} = $c{A}->point( 50 + 90 )->label( "F", "top" );
        $p{G} = $c{A}->point( -50 - 90 )->label( "G", "bottom" );
        $l{FG} = Line->join( $p{F}, $p{G} );

        $t3->math("AD > BC > FG");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof");
        $t3->erase();
    };

    push @$steps, sub {
        $t1->explain(   "Draw lines from the centre of the circle "
                      . "perpendicular to the lines BC and FG" );
        $l{EH} = $l{BC}->perpendicular( $p{E} );
        $p{H} =
          Point->new( $pn, $l{BC}->intersect( $l{EH} ) )->label( "H", "right" );
        $l{EK} = $l{FG}->perpendicular( $p{E} );
        $p{K} =
          Point->new( $pn, $l{FG}->intersect( $l{EK} ) )->label( "K", "left" );
    };

    push @$steps, sub {
        $t1->explain(   "Since BC is nearer to centre E than line FG, "
                      . "EH is less than EK (by definition)" );
        $t3->math("EH < EK");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain("Define a point L on line EK, such that LE equals EH");
        my @p = $p{E}->coords;
        $c{L} = Circle->new( $pn, $p{E}->coords, $p{H}->coords )->grey;
        $p{L} =
          Point->new( $pn, $c{L}->intersect( $l{EK} ) )->label( "L ", "top" );
        $t3->math("EL = EH");
    };

    push @$steps, sub {
        $c{L}->remove;
        $t1->explain(   "Draw a line perpendicular to EL, touching the "
                      . "circle at points M and N" );
        $t1->explain("The lines BC and MN are equal (III.14)");
        $l{FG}->grey;
        $l{AD}->grey;
        $l{MNt} = $l{EK}->perpendicular( $p{L} )->grey;
        $l{MNt}->extend($r1);
        $l{MNt}->prepend($r1);
        my @p = $c{A}->intersect( $l{MNt} );
        $p{M} = Point->new( $pn, @p[ 0, 1 ] )->label( "M", "bottom" );
        $p{N} = Point->new( $pn, @p[ 2, 3 ] )->label( "N", "top" );
        $l{MN} = Line->join( $p{M}, $p{N} );
        $l{MNt}->remove;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("MN = BC");
    };

    push @$steps, sub {
        $t1->explain("Draw the lines FE, GE, ME and NE");
        $l{FE} = Line->join( $p{E}, $p{F} );
        $l{GE} = Line->join( $p{E}, $p{G} );
        $l{ME} = Line->join( $p{E}, $p{M} );
        $l{NE} = Line->join( $p{E}, $p{N} );
        $l{BC}->grey;
        $l{FG}->normal;
    };

    push @$steps, sub {
        $t1->explain(   "Since EA equals EM, and ED equals "
                      . "EN (all radii), then the sum"
                      . " of EA and ED equals the sum of EM and EN" );
        $l{FE}->grey;
        $l{GE}->grey;
        $l{AD}->normal;
        $l{FG}->grey;
        $l{MN}->grey;
        $l{EK}->grey;
        $l{EH}->grey;
        $t3->allgrey;
        $t3->math("AE+ED = AD = ME+EN");
    };

    push @$steps, sub {
        $t1->explain("One side of a triangle is less than "
                   . "the sum of the two other sides (I.20), "
                   . "thus MN is less than ME,EN, or MN is less than\\{nb}AD" );
        $l{AD}->grey;
        $s{MNE} = Triangle->join( $p{M}, $p{N}, $p{E} )->fill($sky_blue);
        $t3->math("MN < ME+EN");
        $t3->math("\\{therefore} MN < AD");
    };

    push @$steps, sub {
        $t1->explain(   "ME equals FE, NE equals GE, the angle MEN is "
                      . "greater than FEG, therefore the "
                      . "base MN is greater than the base FG\\{nb}(I.24)" );
        $s{FGE} = Triangle->join( $p{F}, $p{G}, $p{E} )->fill($lime_green);
        $s{FGE}->set_angles( undef, undef, " " );
        $a{MEN} = Angle->new( $pn, $l{NE}, $l{ME} )->label( " ", 25 );

        my @p = $l{MN}->intersect( $l{FE} );
        $p{1} = Point->new( $pn, @p );
        @p    = $l{MN}->intersect( $l{GE} );
        $p{2} = Point->new( $pn, @p );
        $s{tmp} = Triangle->join( $p{1}, $p{2}, $p{E} );
        $s{tmp}->fillover( $s{MNE}, $teal );
        $p{1}->remove;
        $p{2}->remove;
        $s{tmp}->l(1)->remove;
        $s{tmp}->l(2)->remove;
        $s{tmp}->l(3)->remove;
        $s{tmp}->p(1)->remove;
        $s{tmp}->p(2)->remove;
        $s{tmp}->p(3)->remove;

        $t3->down;
        $t3->allgrey;
        $t3->math("ME = FE");
        $t3->math("NE = GE");
        $t3->math("\\{angle}MEN > \\{angle}FEG");
        $t3->math("\\{therefore} FG < MN");
    };

    push @$steps, sub {
        $t1->explain(   "Putting it all together gives FG is less than BC, "
                      . "is less than AD, or in "
                      . "other words, the further away from the centre, "
                      . "the smaller the line" );
        $s{FGE}->remove;
        $s{MNE}->remove;
        $s{tmp}->remove;
        $a{MEN}->grey;
        $p{L}->grey;
        $l{ME}->grey;
        $l{NE}->grey;
        $l{FE}->grey;
        $l{GE}->grey;
        $l{MN}->grey;
        $l{BC}->normal;
        $l{AD}->normal;
        $l{FG}->normal;
        $t3->down;
        $t3->allgrey;
        $t3->black( [ -1, -5 ] );
        $t3->math("FG < MN < AD");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ -1, 2 ] );
        $t3->math("FG < BC < AD");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
        $t3->blue(0);

    };

    return $steps;

}

