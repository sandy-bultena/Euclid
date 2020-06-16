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
my $title = "In equiangular triangles the sides about the equal angles are "
  . "proportional, and those are corresponding sides which subtend the equal angles.";

$pn->title( 4, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 500, 175 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 4 );
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
    my $yh  = 250;
    my $yb  = 400;
    my $dx1 = 150;
    my $dx2 = 75;
    my @B   = ( 100, $yb );
    my @A   = ( $B[0] + $dx1, $yh );
    my @C   = ( $A[0] + $dx2, $yb );
    my @E   = ( $C[0] + ( $C[0] - $B[0] ) * .65, $yb );
    my @D   = ( $C[0] + ( $A[0] - $B[0] ) * .65, $yb + ( $yh - $yb ) * .65 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain( "Given two equiangular triangles ABC and CDE, "
                . "where the angle \\{alpha} equals angle \\{delta}, \\{gamma} "
                . "equals \\{theta}, and finally "
                . "\\{beta} equals \\{epsilon}, then..." );
        $t1->explain("The ratio of the sides (BC, CE) subtending the "
                   . "angles \\{gamma} and \\{theta} is proportional "
                   . "to the ratio of the sides (AC, DE) subtending the angles "
                   . "\\{alpha} and \\{delta}, etc." );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "right" );
        $p{E} = Point->new( $pn, @E )->label( "E", "bottom" );

        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} );
        $l{AB}  = $t{ABC}->lines->[0];
        $l{AC}  = $t{ABC}->lines->[2];
        $l{BC}  = $t{ABC}->lines->[1];
        $t{CDE} = Triangle->join( $p{C}, $p{D}, $p{E} );
        $l{CD}  = $t{CDE}->lines->[0];
        $l{CE}  = $t{CDE}->lines->[2];
        $l{DE}  = $t{CDE}->lines->[1];

        $a{alpha} =
          Angle->new( $pn, $l{BC}, $l{AB}, -size => 30 )->label("\\{alpha}");
        $a{beta} =
          Angle->new( $pn, $l{AC}, $l{BC}, -size => 20 )->label("\\{beta}");
        $a{gamma} =
          Angle->new( $pn, $l{AB}, $l{AC}, -size => 20 )->label("\\{gamma}");

        $a{a} =
          Angle->new( $pn, $l{CE}, $l{CD}, -size => 30 )->label("\\{delta}");
        $a{b} =
          Angle->new( $pn, $l{DE}, $l{CE}, -size => 20 )->label("\\{epsilon}");
        $a{c} =
          Angle->new( $pn, $l{CD}, $l{DE}, -size => 20 )->label("\\{theta}");

        $t4->math(   "\\{alpha} = \\{delta}, \\{beta} = "
                   . "\\{epsilon}, \\{gamma} = \\{theta}" )->blue;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{alpha}->grey;
        $a{beta}->grey;
        $a{a}->grey;
        $a{b}->grey;
        $l{AB}->grey;
        $l{AC}->grey;
        $l{CD}->grey;
        $l{DE}->grey;
        my $y = $t3->y;
        $t3->math("BC:CE ");
        $t3->y($y);

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{alpha}->normal;
        $a{gamma}->grey;
        $a{beta}->grey;
        $a{a}->normal;
        $a{b}->grey;
        $a{c}->grey;
        $l{AB}->grey;
        $l{AC}->normal;
        $l{BC}->grey;
        $l{CD}->grey;
        $l{DE}->normal;
        $l{CE}->grey;

        my $y = $t3->y;
        $t3->math("        = AC:DE ");
        $t3->y($y);

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{alpha}->grey;
        $a{gamma}->grey;
        $a{beta}->normal;
        $a{a}->grey;
        $a{b}->normal;
        $a{c}->grey;
        $l{AB}->normal;
        $l{AC}->grey;
        $l{BC}->grey;
        $l{CD}->normal;
        $l{DE}->grey;
        $l{CE}->grey;

        my $y = $t3->y;
        $t3->math("                  = AB:CD ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain(   " Also, the ratio of the lines on either side of "
                      . " an angle in one triangle "
                      . " will be equal to the ratio of the lines in the other "
                      . " triangle which are on either side of "
                      . " the equal angle. AB to BC equals DE to CE, "
                      . " AC to BC equals DE to CE and "
                      . " AC to BC equals DE to CE " );

        $a{alpha}->grey;
        $a{gamma}->normal;
        $a{beta}->grey;
        $a{a}->grey;
        $a{b}->grey;
        $a{c}->normal;
        $l{AB}->normal;
        $l{AC}->normal;
        $l{BC}->grey;
        $l{CD}->normal;
        $l{DE}->normal;
        $l{CE}->grey;

        $t3->down;
        $t3->math("AB:AC = CD:DE ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{alpha}->normal;
        $a{gamma}->grey;
        $a{beta}->grey;
        $a{a}->normal;
        $a{b}->grey;
        $a{c}->grey;
        $l{AB}->normal;
        $l{AC}->grey;
        $l{BC}->normal;
        $l{CD}->normal;
        $l{DE}->grey;
        $l{CE}->normal;

        $t3->math("BC:AB = CE:CD ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{alpha}->grey;
        $a{gamma}->grey;
        $a{beta}->normal;
        $a{a}->grey;
        $a{b}->normal;
        $a{c}->grey;
        $l{AB}->grey;
        $l{AC}->normal;
        $l{BC}->normal;
        $l{CD}->grey;
        $l{DE}->normal;
        $l{CE}->normal;

        $t3->math("BC:AC = CE:DE ");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof ");
        $t3->erase();
        $a{alpha}->normal;
        $a{gamma}->normal;
        $a{beta}->normal;
        $a{a}->normal;
        $a{b}->normal;
        $a{c}->normal;
        $l{AB}->normal;
        $l{AC}->normal;
        $l{BC}->normal;
        $l{CD}->normal;
        $l{DE}->normal;
        $l{CE}->normal;
        $t{ABC}->fill($sky_blue);
        $t{CDE}->fill($lime_green);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Since the sum of the angles \\{alpha} and \\{beta} are "
                  . "less than two right angles (I .17), "
                  . "and the angles \\{beta} and \\{epsilon} are equal, ... " );
        $t1->explain(
                " ... the sum of the angles \\{alpha} and \\{epsilon} are less "
                  . "than two right angles, thus the lines AB and DE will meet "
                  . "( at point F ) if extended (I\\{dot}Post\\{dot}5) " );
        my @p = $l{AB}->intersect( $l{DE} );
        $p{F} = Point->new( $pn, @p )->label( "F", "top" );
        $l{AF} = Line->join( $p{A}, $p{F} );
        $l{DF} = Line->join( $p{D}, $p{F} );

        $t3->math("\\{alpha} + \\{beta} < 2\\{dot}\\{right} ");
        $t3->math("\\{beta} = \\{epsilon} ");
        $t3->math("\\{alpha} + \\{epsilon} < 2\\{dot}\\{right} ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase();
        $t1->erase;
        $t1->down;
        $t1->title("Proof ");

        $t1->explain(
               "Since \\{alpha} equals \\{delta}, AF is parallel to CD (I.28)");
        $l{BFx} = Line->join( $p{B}, $p{F}, -1, 1 )->extend(50)->prepend(50);
        $l{CDx} = Line->join( $p{C}, $p{D}, -1, 1 )->extend(50)->prepend(50);
        $a{gamma}->grey;
        $a{beta}->grey;
        $a{c}->grey;
        $a{b}->grey;
        $t{ABC}->grey;
        $t{CDE}->grey;
        $l{BC}->normal;
        $l{CE}->normal;
        $l{AF}->grey;
        $l{DF}->grey;
        $t3->math("AF \\{parallel} CD ");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Similarly, since \\{beta} equals \\{epsilon}, "
                      . "AC is parallel to FE (I.28) " );
        $l{BFx}->remove;
        $l{CDx}->remove;
        $l{ACx} = Line->join( $p{A}, $p{C}, -1, 1 )->extend(50)->prepend(50);
        $l{EFx} = Line->join( $p{E}, $p{F}, -1, 1 )->extend(50)->prepend(50);
        $a{gamma}->grey;
        $a{alpha}->grey;
        $a{c}->grey;
        $a{a}->grey;
        $a{beta}->normal;
        $a{b}->normal;
        $t3->math("AC \\{parallel} FE ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Therefore FACD is a parallelogram, and AF, CD are "
                      . "equal as are AC, FD (I.34) " );
        $l{ACx}->remove();
        $l{EFx}->remove();
        $a{beta}->grey;
        $a{b}->grey;
        $t{FACD} = Polygon->join( 4, $p{F}, $p{A}, $p{C}, $p{D} )->fill($pale_pink);
        $t3->math("AF = CD ");
        $t3->math("AC = FD ");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{FACD}->grey;
        $l{CD}->grey;
        $t{BFE} = Triangle->join( $p{B}, $p{F}, $p{E} )->fill($blue);
        $l{AC}->normal;
        $t3->grey( [ 0, 2, 3, 4 ] );
        $t1->explain(   "Since AC is parallel FE, the ratios AB to AF "
                      . "and BC to CE are equal (VI.2) " );
        $t3->math("AB:AF = BC:CE ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
               "But since AF equals CD, AB to CD is equal to BC to CE (V.16) ");
        $l{CD}->normal;
        $t3->grey(1);
        $t3->black(2);
        $t3->math("AB:CD = BC:CE ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{CD}->normal;
        $t3->grey(1);
        $t3->black(2);
        $a{beta}->normal;
        $a{b}->normal;
        $a{gamma}->normal;
        $a{c}->normal;
        $t4->math("AB:CD = BC:CE ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{beta}->grey;
        $a{b}->grey;
        $a{gamma}->grey;
        $a{c}->grey;
        $t3->grey(2);
        $t3->grey( [ 3, 4 ] );
        $t1->explain("And alternately AB to BC is equal to CD to CE (V.16)");
        $t2->down;
        $t2->math("AB:BC = CD:CE ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{CD}->normal;
        $l{AC}->grey;
        $t3->grey( [ 1 .. 10 ] );
        $t2->grey;
        $t3->black(0);
        $t1->explain( "Since CD is parallel BF, therefore the ratios FD to DE "
                      . "and BC to CE are equal (VI.2) " );
        $t2->math("FD:DE = BC:CE ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->black(3);
        $t1->explain(
               "But since AC equals FD, AC to DE is equal to BC to CE (V.16) ");
        $t3->grey(0);
        $t2->math("AC:DE = BC:CE ");
        $l{AC}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{alpha}->normal;
        $a{a}->normal;
        $a{gamma}->normal;
        $a{c}->normal;
        $t4->math("AC:DE = BC:CE ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{alpha}->grey;
        $a{a}->grey;
        $a{gamma}->grey;
        $a{c}->grey;
        $t3->grey(3);
        $t1->explain(" And alternately AC to BC is equal to DE to CE (V.16)");
        $t3->grey(0);
        $t2->grey(1);
        $t2->math("AC:BC = DE:CE ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
"Since AB is to BC, so is CD to CE, and as BC is to AC, so is CE to DE, "
              . " therefore AB is is to AC so is CD to DE (V.22 ) " );
        $t{BFE}->grey;
        $t{ABC}->normal;
        $t{CDE}->normal;
        $a{alpha}->normal;
        $a{beta}->normal;
        $a{gamma}->normal;
        $a{a}->normal;
        $a{b}->normal;
        $a{c}->normal;
        $t3->grey(4);
        $t3->grey(2);
        $t2->grey( [ 0 .. 10 ] );
        $t2->math("AB:AC = CD:DE ");
        $t2->black( [ 0, 3, 4 ] );

        #$t3->blue(5);

    };
    return $steps;

}

