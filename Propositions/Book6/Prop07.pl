#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If two triangles have one angle equal to one angle, the sides "
  . "about other angles proportional, and the remaining angles either both less "
  . "or both not less than a right angle, the triangles will be equiangular and "
  . "will have those angles equal, the sides about which are proportional.";

$pn->title( 7, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 100, 420 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 7 );
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
    my ( %p, %c, %s, %t, %l, %a );
    my $off = 250;
    my $yh  = 180;
    my $yb  = 380;
    my $dx1 = 50;
    my $dx2 = 150;
    my @B   = ( 100, $yb );
    my @A   = ( $B[0] + $dx1, $yh );
    my @C   = ( $A[0] + $dx2, $yb );

    my @D = ( $A[0] + $off, $A[1] );
    my @E = ( $D[0] - $dx1 * .85, $yh - ( $yh - $yb ) * .85 );
    my @F = ( $D[0] + $dx2 * .85, $yh - ( $yh - $yb ) * .85 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain(
                "If two triangles have one angle that is equal between them, "
              . "AND the ratio of the sides of "
              . "around a different angle are also equal, AND that the remaining angles "
              . "are either both less than, or both greater than a right angle, then "
              . "the two triangles will be equiangular" );

        $t1->explain("Let the angles at C and F be less than a right angle");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "bottom" );
        $p{F} = Point->new( $pn, @F )->label( "F", "bottom" );

        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($sky_blue);
        $l{AB}  = $t{ABC}->lines->[0]->blue;
        $l{AC}  = $t{ABC}->lines->[2];
        $l{BC}  = $t{ABC}->lines->[1]->blue;
        $t{DEF} = Triangle->join( $p{D}, $p{E}, $p{F} )->fill($lime_green);
        $l{DE}  = $t{DEF}->lines->[0]->blue;
        $l{EF}  = $t{DEF}->lines->[1]->blue;
        $l{DF}  = $t{DEF}->lines->[2];

        $a{alpha} =
          Angle->new( $pn, $l{BC}, $l{AB}, -size => 30 )->label("\\{alpha}");
        $a{beta} =
          Angle->new( $pn, $l{AC}, $l{BC}, -size => 20 )->label("\\{beta}");
        $a{gamma} =
          Angle->new( $pn, $l{AB}, $l{AC}, -size => 20 )->label("\\{gamma}");

        $a{c} =
          Angle->new( $pn, $l{DE}, $l{DF}, -size => 30 )->label("\\{gamma}");
        $a{b} =
          Angle->new( $pn, $l{DF}, $l{EF}, -size => 20 )->label("\\{epsilon}");
        $a{a} =
          Angle->new( $pn, $l{EF}, $l{DE}, -size => 20 )->label("\\{delta}");

        $t4->math("AB:BC = DE:EF");
        $t4->math("\\{beta} < \\{right}, \\{epsilon} < \\{right}");
        $t3->y( $t4->y );
        $t3->math("\\{alpha} = \\{delta}, \\{beta} = \\{epsilon}");
        $t4->blue( [ 0 .. 3 ] );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof by Contradiction (1)");
        $t3->erase();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
"Assume that the angle \\{alpha} is unequal to the angle \\{delta}, "
              . "and that \\{alpha} is the greater" );
        $t4->allgrey;
        $t3->y( $t4->y );
        $t3->math("\\{alpha} > \\{delta}")->blue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Construct the angle ABG such that is is equal "
                      . "to the angle \\{delta} (I.23)" );
        $l{BG2} = $l{BC}->clone();
        $l{BG2}->rotateTo( 15, -1 );
        my @p = $l{BG2}->intersect( $l{AC} );
        $p{G} = Point->new( $pn, @p )->label( "G", "top" );
        $a{a2} =
          Angle->new( $pn, $l{BG2}, $l{AB}, -size => 70 )->label("\\{delta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Now, since triangles AGB and AFE have two angles equal, "
                      . "the third must "
                      . "also be equal (I.32)" );
        $t{ABG} = Triangle->join( $p{A}, $p{G}, $p{B} )->fill($pale_pink);
        $t{ABC}->grey;
        $a{alpha}->grey;
        $a{beta}->grey;
        $l{AG} = $t{ABG}->lines->[0];
        $l{BG} = $t{ABG}->lines->[1];
        $a{b2} = Angle->new( $pn, $l{AG}, $l{BG} )->label("\\{epsilon}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "ABG is equiangular to DEF, so AB is to BG, as DE is to EF (VI.4)");
        $t3->allgrey;
        $t3->math("AB:BG = DE:EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                 "The ratios AB to BG and AB to BC are both equal to DE to EF, "
                   . "so then they are equal to each other (V.11)" );
        $t4->blue(0);
        $t3->math("AB:BG = AB:BC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore BG equals BC (V.9)");
        $t4->allgrey;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("BG = BC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Thus the triangle ABG is an isosceles, and angle BGC "
                      . "is equal to BCG (I.5)" );
        $t{ABG}->grey;
        $t{DEF}->grey;
        $a{c}->grey;
        $a{a}->grey;
        $a{b}->grey;
        $a{gamma}->grey;
        $a{a2}->grey;
        $a{b2}->grey;
        $a{beta}->normal;
        $t{BGC} = Triangle->join( $p{B}, $p{G}, $p{C} )->fill($pale_yellow);
        $l{CG} = $t{BGC}->lines->[1];
        $a{BGC} =
          Angle->new( $pn, $l{BG}, $l{CG}, -size => 10 )->label("\\{beta}");
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{angle}BGC = \\{angle}GCB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "By definition, angle ACB is less than a right angle, "
                      . "so therefore so is angle BGC" );
        $t1->explain( "Thus, the outside exterior angle must be greater "
            . "than one right angle "
            . "(the sum of the angles AGB and BGC equal two right angles) (I.13)"
        );
        $l{AG}->normal;
        $a{b2}->normal;
        $t3->allgrey;
        $t3->black(-1);
        $t4->blue(1);
        $t3->math("\\{epsilon} + \\{beta} = 2\\{dot}\\{right}");
        my $y = $t3->y;
        $t3->math("\\{therefore} \\{epsilon} > \\{right} ");
        $t3->y($y);
        $t3->red(-1);
        $t4->red(1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since there is a contradiction, the original assumption "
                      . "was wrong, so we know that angle \\{alpha} "
                      . "equals \\{delta}" );
        $a{b2}->grey;
        $a{BGC}->grey;
        $t{ABC}->normal;
        $t{DEF}->normal;
        $t{BGC}->grey;
        $a{alpha}->normal;
        $a{beta}->normal;
        $a{gamma}->normal;
        $a{a}->normal;
        $a{b}->normal;
        $a{c}->normal;
        $l{BG}->grey;
        $l{BG2}->grey;
        $t2->math("\\{alpha} = \\{delta}");
        $t3->allgrey;
        $t4->allgrey;
        $t3->red(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "And since angles BAC and EDF are equal, "
                      . "angles ACB equals DFE (I.32)" );
        $t2->black(-1);
        $t3->allgrey;
        $t2->math("\\{beta} = \\{epsilon}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The two triangles are equiangular");
        $t4->allblue;
    };

    # -------------------------------------------------------------------------
    # Cleanup
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t2->erase;
        $t3->erase;
        $t4->erase;
        foreach my $o ( \%a, \%l, \%t, \%p ) {
            foreach my $k ( keys %$o ) {
                $o->{$k}->remove();
            }
        }
        $dx1 = 200;
        $dx2 = -50;
        @B   = ( 100, $yb );
        @A   = ( $B[0] + $dx1, $yh );
        @C   = ( $A[0] + $dx2, $yb );

        @D = ( $A[0] + $off, $A[1] );
        @E = ( $D[0] - $dx1 * .85, $yh - ( $yh - $yb ) * .85 );
        @F = ( $D[0] + $dx2 * .85, $yh - ( $yh - $yb ) * .85 );

        $t1->down;
        $t1->title("In other words");
        $t1->explain(
                "If two triangles have one angle that is equal between them, "
              . "AND the ratio of the sides of "
              . "around a different angle are also equal, AND that the remaining angles "
              . "are either both less than, or both greater than a right angle, then "
              . "the two triangles will be equiangular" );

        $t1->explain(
             "Let the angles at C and F greater than or less than a right angle"
        );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "bottom" );
        $p{F} = Point->new( $pn, @F )->label( "F", "bottom" );

        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($sky_blue);
        $l{AB}  = $t{ABC}->lines->[0]->blue;
        $l{AC}  = $t{ABC}->lines->[2];
        $l{BC}  = $t{ABC}->lines->[1]->blue;
        $t{DEF} = Triangle->join( $p{D}, $p{E}, $p{F} )->fill($lime_green);
        $l{DE}  = $t{DEF}->lines->[0]->blue;
        $l{EF}  = $t{DEF}->lines->[1]->blue;
        $l{DF}  = $t{DEF}->lines->[2];

        $a{alpha} =
          Angle->new( $pn, $l{BC}, $l{AB}, -size => 30 )->label("\\{alpha}");
        $a{beta} =
          Angle->new( $pn, $l{AC}, $l{BC}, -size => 20 )->label("\\{beta}");
        $a{gamma} =
          Angle->new( $pn, $l{AB}, $l{AC}, -size => 20 )->label("\\{gamma}");

        $a{c} =
          Angle->new( $pn, $l{DE}, $l{DF}, -size => 30 )->label("\\{gamma}");
        $a{b} =
          Angle->new( $pn, $l{DF}, $l{EF}, -size => 20 )->label("\\{epsilon}");
        $a{a} =
          Angle->new( $pn, $l{EF}, $l{DE}, -size => 20 )->label("\\{delta}");

        $t4->math("AB:BC = DE:EF");
        $t4->math(   "\\{beta} \\{greaterthanorequal} \\{right},"
                   . " \\{epsilon} \\{greaterthanorequal} \\{right}" );
        $t3->y( $t4->y );
        $t3->math("\\{alpha} = \\{delta}, \\{beta} = \\{epsilon}");
        $t4->blue( [ 0 .. 3 ] );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof by Contradiction (2)");
        $t3->erase();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Assume that the angle \\{alpha} is unequal to the "
                      . "angle \\{delta}, and that \\{alpha} is the greater" );
        $t3->y( $t4->y );
        $t4->allgrey;
        $t3->math("\\{alpha} > \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Construct the angle ABG such that is is "
                      . "equal to the angle \\{delta} (I.23)" );
        $l{BG2} = $l{BC}->clone();
        $l{BG2}->rotateTo( 15, -1 );
        my @p = $l{BG2}->intersect( $l{AC} );
        $p{G} = Point->new( $pn, @p )->label( "G", "right" );
        $a{a2} =
          Angle->new( $pn, $l{BG2}, $l{AB}, -size => 70 )->label("\\{delta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Now, since triangles AGB and AFE have "
                      . "two angles equal, the third must "
                      . "also be equal (I.32)" );
        $t{ABG} = Triangle->join( $p{A}, $p{G}, $p{B} )->fill($pale_pink);
        $t{ABC}->grey;
        $a{alpha}->grey;
        $a{beta}->grey;
        $l{AG} = $t{ABG}->lines->[0];
        $l{BG} = $t{ABG}->lines->[1];
        $t3->allgrey;
        $a{b2} = Angle->new( $pn, $l{AG}, $l{BG} )->label("\\{epsilon}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "ABG is equiangular to DEF, so AB is to BG, as DE is to EF (VI.4)");
        $t3->math("AB:BG = DE:EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                 "The ratios AB to BG and AB to BC are both equal to DE to EF, "
                   . "then they are equal to each other (V.11)" );
        $t4->blue(0);
        $t3->math("AB:BG = AB:BC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore BG equals BC (V.9)");
        $t4->allgrey;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("BG = BC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Thus the triangle BGC is an isosceles, "
                      . "and angle BGC is equal to angle BCG (I.5)" );
        $t{ABG}->grey;
        $t{DEF}->grey;
        $a{c}->grey;
        $a{a}->grey;
        $a{b}->grey;
        $a{gamma}->grey;
        $a{a2}->grey;
        $a{b2}->grey;
        $a{beta}->normal;
        $t{BGC} = Triangle->join( $p{B}, $p{G}, $p{C} )->fill($pale_yellow);
        $l{CG} = $t{BGC}->lines->[1];
        $a{BGC} =
          Angle->new( $pn, $l{BG}, $l{CG}, -size => 10 )->label("\\{beta}");
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{angle}BGC = \\{angle}GCB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "By definition, angle \\{beta} is greater than "
                      . "or equal to a right angle, "
                      . "so therefore so is angle BGC" );
        $l{AG}->normal;
        $a{b2}->normal;
        $t4->blue(1);
        $t3->math(   "\\{angle}BGC = "
                   . "\\{angle}GCB \\{greaterthanorequal} \\{right}" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Thus we have two angles inside a triangle, "
                      . "each of which is greater than "
                      . "or equal to a right angle, "
                      . "which is impossible (I.17)" );
        $t4->blue(1);
        $t3->allgrey;
        $t3->red(-1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "Since there is a contradiction, we know that angle \\{alpha} "
              . "equals \\{delta}, and since BAC and EDF are equal, \\{beta} "
              . "equals \\{epsilon} (I.32)"
        );
        $a{b2}->grey;
        $a{BGC}->grey;
        $t{ABC}->normal;
        $t{DEF}->normal;
        $t{BGC}->grey;
        $a{alpha}->normal;
        $a{beta}->normal;
        $a{gamma}->normal;
        $a{a}->normal;
        $a{b}->normal;
        $a{c}->normal;
        $l{BG}->grey;
        $l{BG2}->grey;
        $t3->allgrey;
        $t3->red(0);
        $t4->allgrey;
        $t2->math("\\{alpha} = \\{delta}");
        $t2->math("\\{beta} = \\{epsilon}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The two triangles are equiangular");
        $t4->blue( [ 0, 1 ] );
        $t3->allgrey;

    };

    return $steps;

}

