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
my $title = "On a given straight line to describe a segment of a circle "
  . "admitting an angle equal to a given rectilineal angle.";

$pn->title( 33, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 520, 200 );
my $t2 = $pn->text_box( 400, 500 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 33 );
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

    my @c1 = ( 300, 450 );
    my $r1 = 190;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("In other words");
        $t4->explain("Given an angle C, and a line segment AB...");
        my $yend = $c1[1] - 1.6 * $r1;
        my $xend = 150;
        $l{C1} = Line->new( $pn, $xend - 100, $yend, $xend, $yend );
        $l{C2} =
          Line->new( $pn, $xend - .30 * $r1, $yend + .35 * $r1, $xend, $yend );
        $p{C} = Point->new( $pn, $xend, $yend )->label( "C", "right" );

        $p{A} = Point->new( $pn, $c1[0], $c1[1] - $r1 )->label( "A", "top" );
        $p{B} =
          Point->new( $pn, $c1[0] - .3 * 3 * $r1, $c1[1] - $r1 + $r1 * 3 * .35 )
          ->label( "B", "left" );
        $l{AB} = Line->join( $p{A}, $p{B} );

        $a{C} = Angle->new( $pn, $l{C1}, $l{C2} );

    };

    push @$steps, sub {
        $t4->explain(   "... construct a circle segment such that the angle "
                      . "within the segment is equal to C" );
        $c{tmp}  = Arc->joinbig( $r1, $p{B}, $p{A} );
        $p{tmp}  = $c{tmp}->point(-10);
        $l{tmp1} = Line->join( $p{A}, $p{tmp} );
        $l{tmp2} = Line->join( $p{B}, $p{tmp} );
        $a{tmp}  = Angle->new( $pn, $l{tmp1}, $l{tmp2} )->label("C");

    };

    if (1) {

     # -------------------------------------------------------------------------
     # Construction
     # -------------------------------------------------------------------------
        push @$steps, sub {
            $t4->down;
            $t3->erase;
            $t4->erase;
            $t4->title("Construction (Acute Angle)");
            $c{tmp}->remove;
            $p{tmp}->remove;
            $l{tmp1}->remove;
            $l{tmp2}->remove;
            $a{tmp}->remove;
        };

        push @$steps, sub {
            $t4->explain("Copy the angle C to the line AB, at point A");
            ( $l{AD}, $a{BAD} ) = $a{C}->copy( $p{A}, $l{AB}, 'negative' );
            $a{BAD}->label("C");
            $l{AD}->extend(100);
            $l{AD}->prepend(100);
            $p{D} = Point->new( $pn, $l{AD}->end )->label( "D", "top" );
        };

        push @$steps, sub {
            $t4->explain("Draw a line perpendicular to AD, from point A");
            $l{AE} = $l{AD}->perpendicular( $p{A}, 1, "negative" );
            $l{AE}->extend(50);
            $p{E} = Point->new( $pn, $l{AE}->end )->label( "E", "bottom" );
            $l{DAt} = Line->new( $pn, $p{A}->coords, $l{AD}->start, -1 );
            $a{DAG} = Angle->new( $pn, $l{AE}, $l{DAt} );
            $l{DAt}->remove;
        };

        push @$steps, sub {
            $t4->explain("Bisect line AB at point F");
            $p{F} = $l{AB}->bisect()->label( "F ", "top" );
            $t3->math("BF = FA");
        };

        push @$steps, sub {
            $t4->explain( "Draw a line FG perpendicular to AB from point F, "
                     . "where G is the intersection between this line and AE" );
            $l{FG} = $l{AB}->perpendicular( $p{F}, 1, "negative" );
            my @p = $l{FG}->intersect( $l{AE} );
            $p{G} = Point->new( $pn, @p )->label( "G", "right" );
            $l{AF} = Line->join( $p{A}, $p{F}, -1 );
            $a{AFG} = Angle->new( $pn, $l{FG}, $l{AF} );
            $l{AF}->remove;
        };

        push @$steps, sub {
            $t4->explain("Draw line BG");
            $l{BG} = Line->join( $p{B}, $p{G} );
        };

        push @$steps, sub {
            $t4->explain(   "Since BF equals FA and FG is common, "
                          . "and the angles AFG equals BFG, "
                          . "then the two triangles are equal (I.4), "
                          . "and the lines BG and AG are equal" );
            $s{AFG} = Triangle->join( $p{A}, $p{F}, $p{G} )->fill($sky_blue);
            $s{FBG} = Triangle->join( $p{F}, $p{B}, $p{G} )->fill($lime_green);
            $t3->math("BG = AG");
        };

        push @$steps, sub {
            $t4->explain(   "Thus, drawing a circle with centre G and "
                          . "radius AG will pass through points A and B" );
            $c{1} = Circle->new( $pn, $p{G}->coords, $p{A}->coords );
        };

        push @$steps, sub {
            $t4->explain("The circle segment BHA contains the angle C");
            $l{FG}->grey;
            $l{BG}->grey;
            $l{AE}->grey;
            $l{AD}->grey;
            $c{1}->grey;
            $s{AFG}->grey;
            $s{FBG}->grey;
            $a{BAD}->grey;
            $a{DAG}->grey;
            $a{AFG}->grey;
            $p{G}->grey;
            $p{F}->grey;
            my $radius = VirtualLine->join( $p{G}, $p{A} );
            $c{arc}  = Arc->joinbig( $radius->length, $p{B}, $p{A} );
            $p{arc}  = $c{arc}->point(-10);
            $l{arc1} = Line->join( $p{A}, $p{arc} );
            $l{arc2} = Line->join( $p{B}, $p{arc} );
            $a{arc}  = Angle->new( $pn, $l{arc1}, $l{arc2} )->label("C");
            $p{arc}->label("H","right");
        };

     # -------------------------------------------------------------------------
     # Proof
     # -------------------------------------------------------------------------
        push @$steps, sub {
            $t4->down;
            $t4->title("Proof");
        };

        push @$steps, sub {
            $t4->explain(
                    "The line AD is at the extremity of the circle diameter, "
                      . "and is at right angles to the diameter, thus the line "
                      . "AD touches the circle (III.16)" );
            $c{arc}->remove;
            $p{arc}->remove;
            $l{arc1}->remove;
            $l{arc2}->remove;
            $a{arc}->remove;
            $l{AB}->grey;
            $l{AD}->normal;
            $c{arc}->grey;
            $l{AE}->normal;
            $c{1}->normal;
            $a{DAG}->normal;
        };

        push @$steps, sub {
            $t4->explain( "Since AD touches the circle, the angle DAB "
                    . "equals the angle in the opposite circle segment (III.32)"
            );
            $t4->explain(   "The angle DAB is equal to C by construction, "
                          . "so thus the angle in the segment BEA equals C" );
            $l{AB}->normal;
            $l{AE}->grey;
            $c{1}->grey;
            my $radius = VirtualLine->join( $p{G}, $p{A} );
            $c{arc}  = Arc->joinbig( $radius->length, $p{B}, $p{A} );
            $p{arc}  = $c{arc}->point(30);
            $l{arc1} = Line->join( $p{A}, $p{arc} );
            $l{arc2} = Line->join( $p{B}, $p{arc} );
            $a{arc}  = Angle->new( $pn, $l{arc1}, $l{arc2} )->label("C");
            $a{BAD}->normal;
            $a{DAG}->grey;
        };

    }

    if (1) {

     # -------------------------------------------------------------------------
     # Construction (right angle)
     # -------------------------------------------------------------------------
        push @$steps, sub {
            foreach my $obj ( keys %l ) {
                $l{$obj}->remove;
            }
            foreach my $obj ( keys %p ) {
                $p{$obj}->remove;
            }
            foreach my $obj ( keys %a ) {
                $a{$obj}->remove;
            }
            foreach my $obj ( keys %c ) {
                $c{$obj}->remove;
            }
            foreach my $obj ( keys %s ) {
                $s{$obj}->remove;
            }

            $t4->erase;
            $t4->down;
            $t3->erase;
            $t4->title("Construction (Right Angle)");
        };

        push @$steps, sub {
            my $yend = $c1[1] - 1.6 * $r1;
            my $xend = 150;
            $l{C1} = Line->new( $pn, $xend - 100, $yend, $xend, $yend );
            $l{C2} = Line->new( $pn, $xend, $yend + .35 * $r1, $xend, $yend );
            $p{C} = Point->new( $pn, $xend, $yend )->label( "C", "right" );

            $p{A} =
              Point->new( $pn, $c1[0], $c1[1] - $r1 )->label( "A", "top" );
            $p{B} =
              Point->new( $pn, $c1[0], $c1[1] + $r1 )->label( "B", "bottom" );
            $l{AB} = Line->join( $p{A}, $p{B} );

            $a{C} = Angle->new( $pn, $l{C1}, $l{C2} );
        };

        push @$steps, sub {

            $t4->explain("Copy the angle C to the line AB, at point A");
            ( $l{AD}, $a{BAD} ) = $a{C}->copy( $p{A}, $l{AB}, 'negative' );
            $a{BAD}->label("C ");
            $l{AD}->extend(100);
            $l{AD}->prepend(100);
            $p{D} = Point->new( $pn, $l{AD}->end )->label( "D", "top" );
        };

        push @$steps, sub {
            $t4->explain("Bisect line AB at point F");
            $p{F} = $l{AB}->bisect()->label( "F ", "right" );
            $t3->math("BF = FA");
        };

        push @$steps, sub {
            $t4->explain(   "Drawing a circle with centre F and radius AF "
                          . "will pass through points A and B" );
            $c{1} = Circle->new( $pn, $p{F}->coords, $p{A}->coords );
        };

        push @$steps, sub {
            $t4->explain("The circle segment BHA contains the angle C");
            $l{AD}->grey;
            $c{1}->grey;
            $a{BAD}->grey;

            $c{arc}  = Arc->join( $r1, $p{A}, $p{B} );
            $p{arc}  = $c{arc}->point(-170);
            $l{arc1} = Line->join( $p{A}, $p{arc} );
            $l{arc2} = Line->join( $p{B}, $p{arc} );
            $a{arc} =
              Angle->new( $pn, $l{arc2}, $l{arc1} )->label( "C", "right" );
            $p{arc}->label("H","left");
        };

     # -------------------------------------------------------------------------
     # Proof
     # -------------------------------------------------------------------------
        push @$steps, sub {
            $t4->down;
            $t4->title("Proof");
        };

        push @$steps, sub {
            $t4->explain(
                    "The line AD is at the extremity of the circle diameter, "
                  . "and is at right angles to the diameter, thus the "
                  . "line AD touches the circle (III.16)"
            );
            $c{arc}->remove;
            $p{arc}->remove;
            $l{arc1}->remove;
            $l{arc2}->remove;
            $a{arc}->remove;
            $l{AD}->normal;
            $c{1}->normal;
        };

        push @$steps, sub {
            $t4->explain( "The angle ACB is right, because it is in a "
                      . "semi-circle (III.31), which is equal to the angle C" );
            $c{1}->grey;
            $c{arc}->draw;
            $p{arc}->draw;
            $l{arc1}->draw->normal;
            $l{arc2}->draw->normal;
            $a{arc} =
              Angle->new( $pn, $l{arc2}, $l{arc1} )->label( "C", "right" );
            $a{BAD}->normal;
        };

    }
    if (1) {

     # -------------------------------------------------------------------------
     # Construction (obtuse angle)
     # -------------------------------------------------------------------------
        push @$steps, sub {
            foreach my $obj ( keys %l ) {
                $l{$obj}->remove;
            }
            foreach my $obj ( keys %p ) {
                $p{$obj}->remove;
            }
            foreach my $obj ( keys %a ) {
                $a{$obj}->remove;
            }
            foreach my $obj ( keys %c ) {
                $c{$obj}->remove;
            }

            $t4->erase;
            $t4->down;
            $t3->erase;
            $t4->title("Construction (Obtuse Angle)");
        };

        push @$steps, sub {
            my $yend = $c1[1] - 1.6 * $r1;
            my $xend = 150;

            $l{C1} = Line->new( $pn, $xend - 100, $yend, $xend, $yend );
            $l{C2} = Line->new( $pn,
                                $xend + .30 * $r1,
                                $yend + .35 * $r1,
                                $xend, $yend );
            $p{C} = Point->new( $pn, $xend, $yend )->label( "C", "right" );

            $p{A} =
              Point->new( $pn, $c1[0], $c1[1] - $r1 )->label( "A", "top" );
            $p{B} = Point->new( $pn,
                                $c1[0] - .3 * 3 * $r1,
                                $c1[1] - $r1 + $r1 * 3 * .35 )
              ->label( "B", "left" );
            $l{AB} = Line->join( $p{A}, $p{B} );

            $a{C} = Angle->new( $pn, $l{C1}, $l{C2} );
        };

        push @$steps, sub {
            $t4->explain("Copy the angle C to the line AB, at point A");
            ( $l{AD}, $a{BAD} ) = $a{C}->copy( $p{A}, $l{AB} );
            $a{BAD}->label("C");
            $l{AD}->extend(100);
            $l{AD}->prepend(100);
            $p{D} = Point->new( $pn, $l{AD}->end )->label( "D", "top" );
        };

        push @$steps, sub {
            $t4->explain("Draw a line perpendicular to AD, from point A");
            $l{AE} = $l{AD}->perpendicular( $p{A}, 1, "negative" );
            $l{AE}->extend(50);
            $p{E} = Point->new( $pn, $l{AE}->end )->label( "E", "bottom" );
            $l{DAt} = Line->new( $pn, $p{A}->coords, $l{AD}->end, -1 );
            $a{DAG} = Angle->new( $pn, $l{AE}, $l{DAt} );
            $l{DAt}->remove;
        };

        push @$steps, sub {
            $t4->explain("Bisect line AB at point F");
            $p{F} = $l{AB}->bisect()->label( "F", "bottom" );
            $t3->math("BF = FA");
        };

        push @$steps, sub {
            $t4->explain( "Draw a line FG perpendicular to AB from point F, "
                     . "where G is the intersection between this line and AE" );
            $l{FG} = $l{AB}->perpendicular( $p{F}, 1, "negative" );
            my @p = $l{FG}->intersect( $l{AE} );
            $p{G} = Point->new( $pn, @p )->label( "G", "right" );
            $l{AF} = Line->join( $p{A}, $p{F}, -1 );
            $a{AFG} = Angle->new( $pn, $l{FG}, $l{AF} );
            $l{AF}->remove;
        };

        push @$steps, sub {
            $t4->explain("Draw line BG");
            $l{BG} = Line->join( $p{B}, $p{G} );
        };

        push @$steps, sub {
            $t4->explain(   "Since BF equals FA and FG is common, "
                          . "and the angles AFG equals BFG, "
                          . "then the two triangles are equal (I.4), and the "
                          . "lines BG and AG are equal" );
            $s{AFG} = Triangle->join( $p{A}, $p{F}, $p{G} )->fill($sky_blue);
            $s{FBG} = Triangle->join( $p{F}, $p{B}, $p{G} )->fill($lime_green);
            $t3->math("BG = AG");
        };

        push @$steps, sub {
            $t4->explain(   "Thus, drawing a circle with centre G and "
                          . "radius AG will pass through points A and B" );
            $c{1} = Circle->new( $pn, $p{G}->coords, $p{A}->coords );
        };

        push @$steps, sub {
            $t4->explain("The circle segment BHA contains the angle C");
            $p{G}->grey;
            $l{FG}->grey;
            $l{BG}->grey;
            $l{AE}->grey;
            $l{AD}->grey;
            $c{1}->grey;
            $p{F}->grey;
            $s{AFG}->grey;
            $s{FBG}->grey;
            $a{BAD}->grey;
            $a{DAG}->grey;
            $a{AFG}->grey;
            my $radius = VirtualLine->join( $p{G}, $p{A} );
            $c{arc}  = Arc->join( $radius->length, $p{A}, $p{B} );
            $p{arc}  = $c{arc}->point(150);
            $l{arc1} = Line->join( $p{A}, $p{arc} );
            $l{arc2} = Line->join( $p{B}, $p{arc} );
            $a{arc}  = Angle->new( $pn, $l{arc2}, $l{arc1} )->label( "C", 20 );
            $p{arc}->label("H","left");
        };

     # -------------------------------------------------------------------------
     # Proof
     # -------------------------------------------------------------------------
        push @$steps, sub {
            $t4->erase;
            $t4->down;
            $t4->title("Proof");
        };

        push @$steps, sub {
            $t4->explain(
                    "The line AD is at the extremity of the circle diameter, "
                      . "and is at right angles to the diameter, thus the line "
                      . "AD touches the circle (III.16)" );
            $c{arc}->remove;
            $p{arc}->remove;
            $l{arc1}->remove;
            $l{arc2}->remove;
            $a{arc}->remove;
            $l{AB}->grey;
            $l{AD}->normal;
            $c{arc}->grey;
            $l{AE}->normal;
            $c{1}->normal;
            $a{DAG}->normal;
        };

        push @$steps, sub {
            $t4->explain(
                        "Since AD touches the circle, the angle DAB equals the "
                          . "angle in the opposite circle segment (III.32)" );
            $t4->explain(   "The angle DAB is equal to C by construction, "
                          . "so thus the angle in the segment BEA equals C" );
            $l{AB}->normal;
            $l{AE}->grey;
            $c{1}->grey;
            my $radius = VirtualLine->join( $p{G}, $p{A} );
            $c{arc}  = Arc->join( $radius->length, $p{A}, $p{B} );
            $p{arc}  = $c{arc}->point(150);
            $l{arc1} = Line->join( $p{A}, $p{arc} );
            $l{arc2} = Line->join( $p{B}, $p{arc} );
            $a{arc}  = Angle->new( $pn, $l{arc2}, $l{arc1} )->label( "C", 20 );
            $a{BAD}->normal;
            $a{DAG}->grey;
        };

    }
    push @$steps, sub {
    };

    return $steps;

}

