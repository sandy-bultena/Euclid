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
    "In a circle the angle in the semicircle is right, "
  . "that in a greater segment less than a right angle, "
  . "and that in a less segment greater than a right angle, "
  . "and further the angle of the greater segment is greater than a right angle, "
  . "and the angle of the less segment less than a right angle.";

$pn->title( 31, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 500, 200 );
my $t5 = $pn->text_box( 500, 200 );
my $t2 = $pn->text_box( 400, 500 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 31 );
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

    my @c1 = ( 280, 380 );
    my $r1 = 190;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("In other words");
        $t4->explain("Let E be the centre of the circle and BC the diameter");

        $c{1} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $p{E} = Point->new( $pn, @c1 )->label( "E", "right" );
        $p{C} = $c{1}->point(60)->label( " C", "top" );
        $p{B} = $c{1}->point( 180 + 60 )->label( "B", "bottom" );
        $p{A} = $c{1}->point(170)->label( "A", "left" );
        $p{D} = $c{1}->point(100)->label( "D", "top" );
        $c{DA} = Arc->join( $r1, $p{D}, $p{A} );
        $c{AB} = Arc->join( $r1, $p{A}, $p{B} );
        $c{BC} = Arc->join( $r1, $p{B}, $p{C} );
        $c{CD} = Arc->join( $r1, $p{C}, $p{D} );
        $l{BC} = Line->join( $p{B}, $p{C} );
        $c{1}->remove;
    };

    push @$steps, sub {
        $t4->explain("The angle BAC in the semicircle segment BAC is right");
        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $a{BAC} = Angle->new( $pn, $l{AB}, $l{AC} );
        $c{BC}->grey;
        $t3->math("\\{angle}BAC = \\{right}");
    };

    push @$steps, sub {
        $a{BAC}->remove;
        $t4->explain(   "The angle ABC in the 'greater than a semicircle' "
                      . "segment ABC is less than a right angle" );
        $a{ABC} = Angle->new( $pn, $l{BC}, $l{AB} );
        $c{BC}->normal;
        $c{DA}->grey;
        $c{CD}->grey;
        $t3->math("\\{angle}ABC < \\{right}");
    };

    push @$steps, sub {
        $a{ABC}->remove;
        $t4->explain(   "The angle ADC in the 'less than a semicircle' "
                      . "segment ADC is greater than a right angle" );
        $c{BC}->grey;
        $c{AB}->grey;
        $c{DA}->normal;
        $c{CD}->normal;
        $l{AB}->grey;
        $l{BC}->grey;
        $l{AD} = Line->join( $p{A}, $p{D} );
        $l{DC} = Line->join( $p{D}, $p{C} );
        $a{ADC} = Angle->new( $pn, $l{AD}, $l{DC} );
        $t3->math("\\{angle}ADC > \\{right}");
    };

    push @$steps, sub {
        $a{ADC}->remove;
        $t4->down;
        $t3->down;
        $t4->explain(   "The angle between the line AC and the segment "
                      . "ABC is larger than a right angle" );
        $c{CD}->grey;
        $c{DA}->grey;
        $c{AB}->normal;
        $c{BC}->normal;
        $l{AD}->grey;
        $l{DC}->grey;
        $l{tmp} = Line->new( $pn, $c{AB}->tangent( $p{A}->coords ) )->grey;
        $l{tmp}->extend(50);
        $a{gs} = Angle->new( $pn, $l{tmp}, $l{AC} )->label("\\{theta}");
        $t3->math("\\{theta} > \\{right}");
    };

    push @$steps, sub {
        $t4->explain(   "The angle between the line AC and the segment "
                      . "ADC is less than a right angle" );
        $c{CD}->normal;
        $c{DA}->normal;
        $c{AB}->grey;
        $c{BC}->grey;
        $l{AD}->grey;
        $l{DC}->grey;
        $a{gs}->remove;
        $l{tmp3} = $l{tmp}->clone;
        $l{tmp3}->prepend(100)->grey;
        $l{tmp2} = Line->new( $pn, $p{A}->coords, $l{tmp3}->start )->grey;
        $l{tmp3}->remove;
        $l{tmp}->remove;
        $a{ls} = Angle->new( $pn, $l{AC}, $l{tmp2} )->label( "\\{beta}", 30 );
        $t3->math("\\{beta} < \\{right}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t3->erase;
        $t4->down;
        $l{tmp2}->remove;
        $a{ls}->remove;
        $t4->title("In other words");
        $t4->math(   "  \\{angle}BAC = \\{right}, \\{angle}ABC < \\{right}, "
                   . "\\{angle}ADC > \\{right}" );
        $t4->down;
        $t4->title("Proof");
        $l{AD}->normal;
        $l{DC}->normal;
        $l{AB}->normal;
        $l{BC}->normal;
        $c{BC}->normal;
        $c{AB}->normal;
        $t5->math("BC = diameter");
        $t5->math("BE = EC");
        $t5->allblue;
        $t3->y( $t5->y );
    };

    push @$steps, sub {
        $t4->explain("Draw line AE, and extend line BA to the point F");
        $l{AE}  = Line->join( $p{A}, $p{E} );
        $l{BFt} = $l{AB}->clone->prepend(100);
        $p{F}   = Point->new( $pn, $l{BFt}->start )->label( "F", "top" );
        $l{AF}  = Line->join( $p{A}, $p{F}, -1 );
        $l{BFt}->remove;
    };

    push @$steps, sub {
        $t4->explain( "Since AE and BE are equal, ABE is an "
            . "isosceles triangle, and the angles BAE and ABE are equal\\{nb}(I.5)"
        );
        $l{AD}->grey;
        $l{DC}->grey;
        $l{AC}->grey;
        $l{BC}->grey;
        $c{DA}->grey;
        $c{AB}->grey;
        $c{BC}->grey;
        $c{CD}->grey;
        $s{ABE} = Triangle->join( $p{A}, $p{B}, $p{E} )->fill($sky_blue);
        $a{ABE} = Angle->new( $pn, $l{BC}, $l{AB} )->label("\\{gamma}");
        $a{BAE} = Angle->new( $pn, $l{AB}, $l{AE} )->label("\\{gamma}");
        $t3->math("\\{angle}ABE = \\{angle}BAE = \\{gamma}");
    };

    push @$steps, sub {
        $t4->explain( "Similarly AE and CE are equal, ACE is an "
            . "isosceles triangle, and the angles CAE and ACE are equal\\{nb}(I.5)"
        );
        $s{ACE} = Triangle->join( $p{A}, $p{C}, $p{E} )->fill($blue);
        $a{CAE} = Angle->new( $pn, $l{AE}, $l{AC} )->label( "\\{theta}", 30 );
        $a{ACE} = Angle->new( $pn, $l{AC}, $l{BC} )->label( "\\{theta}", 30 );
        $t3->math("\\{angle}CAE = \\{angle}ACE = \\{theta}");
    };

    push @$steps, sub {
        $t4->explain("Thus, the angle BAC is the sum of CAE,BAE, or ACE,ABE");
        $t3->math("\\{angle}BAC = \\{gamma} + \\{theta}");
    };

    push @$steps, sub {
        $t4->explain( "The exterior angle FAC is equal to the sum "
             . "of the opposite interior angles of the triangle BAC\\{nb}(I.32)"
        );
        $a{FAC} =
          Angle->new( $pn, $l{AC}, $l{AF}, -noright => 1 )
          ->label( "\\{gamma}+\\{theta}", 50 );
        $t3->allgrey;
        $t3->math("\\{angle}FAC = \\{gamma} + \\{theta}");

        $s{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($sky_blue);
        $a{BAC} =
          Angle->new( $pn, $l{AB}, $l{AC}, -noright => 1 )
          ->label("\\{gamma}+\\{theta}");

        $a{CAE}->remove;
        $a{BAE}->remove;
        $s{ABE}->remove;
        $s{ACE}->remove;
        $l{AE}->grey;
    };

    push @$steps, sub {
        $t4->explain(   "By definition, if angle FAC equals angle BAC, "
                      . "then they are both right angles" );
        $t3->black(-2);
        $t3->math("\\{angle}FAC = \\{angle}BAC = \\{alpha} = \\{right}");
    };

    push @$steps, sub {
        $a{BAC}->remove;
        $a{BAC} = Angle->new( $pn, $l{AB}, $l{AC} )->label("\\{alpha}");
        $a{FAC}->remove;
    };

    push @$steps, sub {
        $t4->explain(   "In the triangle ABC, the angles ABC,BAC "
                      . "are less than two right angles (I.17)" );
        $t3->down;
        $t3->allgrey;
        $t3->math("\\{alpha} + \\{gamma} < 2\\{right}");
    };

    push @$steps, sub {
        $t4->explain(   "... and since BAC is a right angle, angle "
                      . "ABC is less than a right angle" );
        $t3->black( [ -1, -2 ] );
        $t3->math("\\{gamma} < \\{right}");
    };

    push @$steps, sub {
        $t4->explain( "A quadilateral inscribed in a circle has "
            . "the sum of the opposite angles equal to two right angles (III.22), "
            . "so ADC,ABC equals two right angles" );
        $s{ABCD} = Polygon->join( 4, $p{A}, $p{B}, $p{C}, $p{D} )->fill($lime_green);
        $a{ADC} = Angle->new( $pn, $l{AD}, $l{DC} )->label("\\{delta}");
        $a{BAC}->remove;
        $a{ACE}->remove;
        $s{ABC}->remove;
        $a{BAC}->remove;
        $t3->down;
        $t3->allgrey;
        $t3->math("\\{gamma} + \\{delta} = 2\\{right}");

    };

    push @$steps, sub {
        $t4->explain(   "Since ABC is less than one right angle, "
                      . "then ADC must be larger than a right angle" );
        $t3->black(-2);
        $t3->math("\\{delta} > \\{right}");
    };

    push @$steps, sub {
        $s{ABCD}->fill;
        $a{BAC}->draw;
        $t3->allgrey;
        $t3->black( [ -1, -3, -5 ] );
        $l{AC}->normal;
        $l{AF}->grey;
        $c{1}->normal;
    };

    push @$steps, sub {
        $a{BAC}->remove;
        $t4->erase;
        $t3->erase;
        $t3->y( $t5->y );
        $t4->down;

        $a{ABC}->remove;
        $a{ABE}->remove;
        $a{ADC}->remove;
        $s{ABCD}->remove;
        $l{AB}->grey;
        $l{AF}->grey;

        $c{DA}->normal;
        $c{AB}->normal;
        $c{BC}->normal;
        $c{CD}->normal;
        $l{AC}->normal;

        $t4->title("In other words");
        $t4->math(
                "  \\{angle}BAC = \\{right}, \\{angle}ABC "
              . "< \\{right}, \\{angle}ADC > \\{right}"
        );
        $t4->explain(   "The angle between the line AC and the segment ADC is "
                      . "less than a right angle" );
        $t4->explain(   "The angle between the line AC and the segment ABC is "
                      . "greater than a right angle" );
        $t4->down;
        $t4->title("Proof");

        $l{tmp} = Line->new( $pn, $c{AB}->tangent( $p{A}->coords ) )->grey;
        $l{tmp}->extend(50);
        $a{gs} = Angle->new( $pn, $l{tmp}, $l{AC} )->label("\\{theta}");

        $l{tmp3} = $l{tmp}->clone;
        $l{tmp3}->prepend(100)->grey;
        $l{tmp2} = Line->new( $pn, $p{A}->coords, $l{tmp3}->start )->grey;
        $l{tmp3}->remove;
        $a{ls} = Angle->new( $pn, $l{AC}, $l{tmp2} )->label( "\\{beta}", 30 );
    };

    push @$steps, sub {
        $t4->explain(   "Angle BAC is right, and it is obvious that \\{theta} "
                      . "is greater than BAC, "
                      . "thus \\{theta} is greater than a right angle" );
        $l{AB}->normal;
        $a{ls}->grey;
        $c{DA}->grey;
        $c{AB}->normal;
        $c{BC}->grey;
        $t3->math("\\{theta} > \\{right}");
        $c{CD}->grey;

    };
    push @$steps, sub {
        $t4->explain(   "Angle FAB is right, and it is obvious that \\{beta} "
                      . "is less than FAB, "
                      . "thus \\{beta} is less than a right angle" );
        $l{AB}->grey;
        $a{gs}->grey;
        $c{DA}->normal;
        $a{ls}->normal;
        $l{AF}->normal;
        $t3->math("\\{beta} < \\{right}");
    };

    return $steps;

}

