#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 5;

# ============================================================================
# Definitions
# ============================================================================
my $title = "About a given triangle to circumscribe a circle.";

$pn->title( 5, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 500, 500 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 5 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();
my ( %l, %p, %c, %s, %a );

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $r       = 130;
    my @centres = ( [ 200, 200 ], [ 200, 500 ], [ 500, 350 ] );
    my @angles  = ( [ -20, 200, 70 ], [ 0, 180, 50 ], [ 20, 160, 90 ] );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a triangle ABC");
        $t1->explain(   "Draw a circle so that it passes "
                      . "through each vertex of the triangle" );

        foreach my $i ( 0 .. 2 ) {
            my $j = $i + 1;
            my @c = @{ $centres[$i] };
            my @p = @c;
            $p[0] = $p[0] + $r;
            $c{$j} = Circle->new( $pn, @c, @p )->grey;
            $p{"A$j"} = $c{$j}->point( $angles[$i][2] )->label( "A", "top" );
            $p{"B$j"} = $c{$j}->point( $angles[$i][1] )->label( "B", "left" );
            $p{"C$j"} = $c{$j}->point( $angles[$i][0] )->label( "C", "right" );
            $s{"ABC$j"} = Triangle->join( $p{"A$j"}, $p{"B$j"}, $p{"C$j"} );
        }

    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $c{1}->remove;
        $c{2}->remove;
        $c{3}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Bisect line AB at point D and line AC at point E (I.10)");
        foreach my $i ( 1 .. 3 ) {
            $p{"D$i"} = $s{"ABC$i"}->l(1)->bisect();
            $p{"D$i"}->label(qw(D left));
            $p{"E$i"} = $s{"ABC$i"}->l(3)->bisect();
            $p{"E$i"}->label(qw(E right));
        }

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Draw lines from the points D,E "
                      . "perpendicular to their respective "
                      . "sides of the triangle, "
                      . "intersecting at point F (I.11)" );
        foreach my $i ( 1 .. 3 ) {
            $l{1} = $s{"ABC$i"}->l(1)->perpendicular( $p{"D$i"} );
            $l{1}->grey;
            $l{2} = $s{"ABC$i"}->l(3)->perpendicular( $p{"E$i"} );
            $l{2}->grey;
            my @p = $l{1}->intersect( $l{2} );
            $p{"F$i"} = Point->new( $pn, @p )->label(qw(F bottom));
            $l{1}->remove;
            $l{2}->remove;
            $l{"DF$i"} = Line->join( $p{"D$i"}, $p{"F$i"} );
            $l{"EF$i"} = Line->join( $p{"E$i"}, $p{"F$i"} );
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "With F as the centre, and AF "
                      . "as the radius, it is possible "
                      . "to draw a circle that passes "
                      . "through each point A, B and\\{nb}C" );
        foreach my $i ( 1 .. 3 ) {
            $l{"AF$i"} = Line->join( $p{"A$i"}, $p{"F$i"} );
            $c{$i} = Circle->new( $pn, $p{"F$i"}->coords, $p{"A$i"}->coords );
        }
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof");
        foreach my $i ( 1 .. 3 ) {
            $l{"AF$i"}->remove;
            $c{$i}->remove;
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw lines BF and AF");
        $t1->explain(   "The two triangles ADF and BDF are equal "
                      . "in all respects, since they have "
                      . "a side (BD,AD), angle (ADF = BDF = "
                      . "\\{right}), side (DF) equal\\{nb}(I.4)" );

        foreach my $i ( 1 .. 3 ) {
            $s{"ABC$i"}->grey;
            $l{"DF$i"}->grey;
            $l{"EF$i"}->grey;
            $s{"ADF$i"} =
              Triangle->join( $p{"A$i"}, $p{"D$i"}, $p{"F$i"} )->fill($sky_blue);
            $s{"BDF$i"} =
              Triangle->join( $p{"B$i"}, $p{"D$i"}, $p{"F$i"} )->fill($lime_green);
        }

        $t3->math("BD = AD");
        $t3->math("\\{angle}ADF = \\{angle}BDF = \\{right}");
        $t3->math("DF is common");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Hence BF equals AF");
        $t3->math("\\{therefore} BF = AF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly,it can be shown that AF is equal to CF");
        foreach my $i ( 1 .. 3 ) {
            $s{"ADF$i"}->grey;
            $s{"BDF$i"}->grey;
            $s{"AEF$i"} =
              Triangle->join( $p{"A$i"}, $p{"E$i"}, $p{"F$i"} )->fill($pale_pink);
            $s{"CEF$i"} =
              Triangle->join( $p{"C$i"}, $p{"E$i"}, $p{"F$i"} )->fill($pale_yellow);
        }
        $t3->math("  AF = CF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "Since BF, AF and CF are all equal, a circle with the centre "
                . "at F, with radius AF will pass through the points A, B, C" );
        $t3->math("  BF = AF = CF");
        foreach my $i ( 1 .. 3 ) {
            $s{"AEF$i"}->grey;
            $s{"CEF$i"}->grey;
            $s{"ABC$i"}->normal->fill($purple);
            $l{"AF$i"} = Line->join( $p{"A$i"}, $p{"F$i"} );
            $l{"BF$i"} = Line->join( $p{"B$i"}, $p{"F$i"} );
            $l{"CF$i"} = Line->join( $p{"C$i"}, $p{"F$i"} );
            $c{$i} = Circle->new( $pn, $p{"F$i"}->coords, $p{"A$i"}->coords );
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->bold("Note: (III.31)");
        $t1->explain(
                  "If the centre of the circle falls within the triangle, then "
                    . "the angle BAC is less than a right angle" );
        $t1->explain( "If the centre of the circle falls on the line AC, then "
                      . "the angle BAC is less than a right angle" );
        $t1->explain(
                 "If the centre of the circle falls outside the triangle, then "
                   . "the angle BAC is greater than a right angle" );
    };

    return $steps;

}

sub greyall {
    foreach my $o ( keys %l ) {
        $l{$o}->grey;
    }
    foreach my $o ( keys %a ) {
        $a{$o}->grey;
    }
    foreach my $o ( keys %s ) {
        $s{$o}->grey;
    }
    foreach my $o ( keys %p ) {
        $p{$o}->grey;
    }
}

