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
    "In equal and equiangular parallelograms, the sides about the "
  . "equal angles are reciprocally proportional; and equiangular parallelograms in "
  . "which the sides about the equal angles are reciprocally proportional are equal.";

$pn->title( 14, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 100, 150 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 14 );
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
    my $y;
    my ( %p, %c, %s, %t, %l, %a );
    my $off = 30;
    my $yh  = 300;
    my $yb  = 450;
    my $dx1 = 80;
    my $xs  = 100;

    my @A = ( $xs, $yb );
    my @D = ( $xs + $dx1, $yb );
    my @F = ( $xs + $off, $yh );
    my @B = ( $xs + $off + $dx1, $yh );
    my @G;
    my @C;
    my @E;

    my $colour1 = "#abcdef";
    my $colour2 = "#cdefab";
    my $colour3 = "#efabcd";
    my $colour4 = "#abefcd";

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain(
            "Given two equiangular parallelograms, where the areas are equal, "
              . "then the ratios of the sides around the equal angle FB,BD "
              . "and EB,BG are reciprocally proportional"
        );
        $t1->explain( "... or ... the multiplication of the two "
            . "sides of the parallelogram "
            . "remains constant as long as the area and the angles remain the same"
        );
        $t1->down;
        $t1->explain("And the inverse");

        $p{A} = Point->new( $pn, @A[ 0, 1 ] )->label( "A", "bottom" );
        $p{B} = Point->new( $pn, @B[ 0, 1 ] )->label( "B", "bottomright" );
        $p{D} = Point->new( $pn, @D[ 0, 1 ] )->label( "D", "bottom" );
        $p{F} = Point->new( $pn, @F[ 0, 1 ] )->label( "F", "left" );
        $l{AD} = Line->join( $p{A}, $p{D} );
        $l{AF} = Line->join( $p{A}, $p{F} );
        $l{BF} = Line->join( $p{B}, $p{F} );
        $l{BD} = Line->join( $p{D}, $p{B} );

        $l{DEx} = $l{BD}->clone->extend( 1.5 * $l{BF}->length );
        $p{E}   = Point->new( $pn, $l{DEx}->end )->label( "E", "top" );
        @E      = $p{E}->coords;
        $l{BE}  = Line->join( $p{B}, $p{E} );
        $l{DEx}->remove;
        @G = ( $B[0] + ( $l{BD}->length ) / 1.5, $yh );
        $p{G} = Point->new( $pn, @G )->label( "G", "bottom" );
        $l{BG} = Line->join( $p{B}, $p{G} );
        @C = ( $E[0] + $l{BG}->length, $E[1] );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $l{CE} = Line->join( $p{C}, $p{E} );
        $l{CG} = Line->join( $p{C}, $p{G} );

        $t{AB} = Polygon->join( 4, $p{A}, $p{D}, $p{B}, $p{F} )->fill($sky_blue);
        $t{BC} = Polygon->join( 4, $p{B}, $p{G}, $p{C}, $p{E} )->fill($lime_green);

        $a{FBD} =
          Angle->new( $pn, $l{BF}, $l{BD}, -size => 20 )->label("\\{alpha}");
        $a{EBC} =
          Angle->new( $pn, $l{BG}, $l{BE}, -size => 20 )->label("\\{theta}");

        $t3->math("          \\{alpha} = \\{theta}")->blue(0);
        $t3->math("          \\{parallelogram}AB = \\{parallelogram}BC")
          ->blue(1);

        $t3->math(
            "          DB:BE = BG:BF   \\{then} DB\\{times}BF = BG\\{times}BE");
        $t3->down;
        $t3->math("          \\{alpha} = \\{theta}")->blue(3);
        $t3->math("          DB:BE = BG:BF")->blue(4);
        $t3->math("          \\{parallelogram}AB = \\{parallelogram}BC");

        $t1->down;
        $t1->title("Note:");
        $t1->explain(
            "Assume two objects 'x' and 'y', both with properties '1' and '2'");
        $t1->explain("Proportional:");
        $t1->math("   \\{x_1}:\\{y_1} = \\{x_2}:\\{y_2}");
        $t1->explain("Reciprocally Proportional:");
        $t1->math(   "   \\{x_1}:\\{y_1} = \\{y_2}:\\{x_2}, "
                   . " \\{x_1}\\{dot}\\{x_2} = \\{y_1}\\{dot}\\{y_2}" );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof (Part 1)");
        $t3->erase;
        $t3->math("          \\{alpha} = \\{theta}")->blue(0);
        $t3->math("          \\{parallelogram}AB = \\{parallelogram}BC")
          ->blue(1);
    };

    push @$steps, sub {
        $t1->explain(   "Let DB, BE be place in in a straight line, "
                      . "therefore FB, BG are also in a straight line (I.14)" );
        $t1->explain("Create the parallelogram FE");
        my @p = $l{CE}->intersect( $l{AF} );
        $p{x} = Point->new( $pn, @p );
        $l{Fx} = Line->join( $p{F}, $p{x} );
        $l{Ex} = Line->join( $p{E}, $p{x} );
        $t{EF} = Polygon->join( 4, $p{E}, $p{B}, $p{F}, $p{x} )->fill($pale_pink);
    };

    push @$steps, sub {
        $t1->explain(
                  "Since parallelograms AB and BC are equal, then the ratios "
                . "of these to the parallelogram FE will also be equal (V.7)" );
        $t3->down;
        $t3->math(   "\\{parallelogram}AB:\\{parallelogram}FE = "
                   . "\\{parallelogram}BC:\\{parallelogram}FE" );
    };

    push @$steps, sub {
        $t1->explain("But, as AB is to FE, so is DB to BE (VI.1) ");
        $t{BC}->grey();
        $t3->allgrey;
        $t3->down;
        $t3->math("\\{parallelogram}AB:\\{parallelogram}FE = DB:BE");
    };

    push @$steps, sub {
        $t1->explain("and as BC is to FE, so is BG to BF (VI.1)");
        $t{BC}->normal;
        $t{AB}->grey;
        $t3->allgrey;
        $y = $t3->y;
        $t3->math("\\{parallelogram}BC:\\{parallelogram}FE = BG:BF");
    };

    push @$steps, sub {
        $t1->explain("Therefore, as DB is to BE, so is BG to BF (V.11)");
        $t3->black( [ -1, -2, -3 ] );
        $t3->math("DB:BE = BG:BF");
        $t{EF}->grey;
        $t{BC}->grey;
        foreach my $l ( keys %l ) {
            $l{$l}->grey;
        }
        $l{BD}->normal;
        $l{BE}->normal;
        $l{BG}->normal;
        $l{BF}->normal;
    };

    push @$steps, sub {
        $t{EF}->grey;
        $t{AB}->normal;
        $t{BC}->normal;
        $t1->down;
        $t1->explain(   "Thus, in two equal parallelograms, "
                      . "the sides about the equal angles are "
                      . "reciprocally proportional" );
        $t3->allgrey;
        $t3->black(-1);
        $t3->blue( [ 0, 1 ] );
        $t3->math("          \\{then} DB\\{times}BF = BG\\{times}BE");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof (Part 2)");
        $t3->erase;
        $t3->math("          \\{alpha} = \\{theta}")->blue(0);
        $t3->math("          DB:BE = BG:BF")->blue(1);
        $t1->explain(   "Let DB, BE be place in in a straight line, "
                      . "therefore FB, BG are also in a straight line (I.14)" );
        $t1->explain("Create the parallelogram FE");
        $t{EF}->normal;
    };

    push @$steps, sub {
        $t1->explain(   "The ratio of DB to BE is equal to the ratio "
                      . "of the parallelograms AB to EF (VI.1)" );
        $t3->down;
        $t{BC}->grey;
        $t3->allgrey;
        $t3->math("DB:BE = \\{parallelogram}AB:\\{parallelogram}EF");
    };

    push @$steps, sub {
        $t1->explain(   "The ratio of BG to BF is equal to the ratio of "
                      . "the parallelograms BC to EF (VI.1)" );
        $t{BC}->normal;
        $t{AB}->grey;
        $l{BD}->grey;
        $t3->allgrey;
        $t3->math("BG:BF = \\{parallelogram}BC:\\{parallelogram}EF");
    };

    push @$steps, sub {
        $t1->explain(   "Therefore the ratio of the parallelograms AB to "
                      . "FE is equal to BC to FE (V.11)" );
        $t{BC}->normal;
        $t{AB}->normal;
        $t3->black( [ -2, -1 ] );
        $t3->blue(1);
        $t3->math(   "\\{parallelogram}AB:\\{parallelogram}EF = "
                   . "\\{parallelogram}BC:\\{parallelogram}EF" );
    };

    push @$steps, sub {
        $t1->explain("And thus the parallelograms AB and EF are equal(V.9)");
        $t3->down;
        $t{EF}->grey;
        $t3->math("\\{parallelogram}AB = \\{parallelogram}BC");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->black(-1);
    };
    return $steps;

}

