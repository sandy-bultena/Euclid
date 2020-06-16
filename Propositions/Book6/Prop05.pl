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
    "It two triangles have their sides proportional, the triangles will "
  . "be equiangular and will have those angles equal which "
  . "the corresponding sides subtend";

$pn->title( 5, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 100, 150 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 5 );
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
    my $off = 200;
    my $yh  = 200;
    my $yb  = 400;
    my $dx1 = 250;
    my $dx2 = -50;
    my @B   = ( 100, $yb );
    my @A   = ( $B[0] + $dx1, $yh );
    my @C   = ( $A[0] + $dx2, $yb );

    my @D = ( $A[0] + $off, $A[1] - 50 );
    my @E = ( $D[0] - $dx1 * .85, $yh - ( $yh - $yb ) * .85 - 50 );
    my @F = ( $D[0] + $dx2 * .85, $yh - ( $yh - $yb ) * .85 - 50 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain( "If side 'a' is to side 'b' of one triangle, and is "
             . "equal to side 'd' to 'e' of another, "
             . "and similarly for all sides, "
             . "then the angle between 'a' and 'b' will be equal to the angles "
             . "between 'd' and\\{nb}'e'" );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "right" );
        $p{E} = Point->new( $pn, @E )->label( "E", "bottom" );
        $p{F} = Point->new( $pn, @F )->label( "F", "right" );

        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($sky_blue);
        $l{AB}  = $t{ABC}->lines->[0];
        $l{AC}  = $t{ABC}->lines->[2];
        $l{BC}  = $t{ABC}->lines->[1];
        $t{DEF} = Triangle->join( $p{D}, $p{E}, $p{F} )->fill($lime_green);
        $l{DE}  = $t{DEF}->lines->[0];
        $l{EF}  = $t{DEF}->lines->[1];
        $l{DF}  = $t{DEF}->lines->[2];

        $a{alpha} =
          Angle->new( $pn, $l{BC}, $l{AB}, -size => 30 )->label("\\{alpha}");
        $a{beta} =
          Angle->new( $pn, $l{AC}, $l{BC}, -size => 20 )->label("\\{beta}");
        $a{gamma} =
          Angle->new( $pn, $l{AB}, $l{AC}, -size => 20 )->label("\\{gamma}");

        $a{c} =
          Angle->new( $pn, $l{DE}, $l{DF}, -size => 30 )->label("\\{theta}");
        $a{b} =
          Angle->new( $pn, $l{DF}, $l{EF}, -size => 20 )->label("\\{epsilon}");
        $a{a} =
          Angle->new( $pn, $l{EF}, $l{DE}, -size => 20 )->label("\\{delta}");

        $t4->math("AB:BC = DE:EF");
        $t4->math("BC:AC = EF:DF");
        $t4->math("AB:AC = DE:DF");
        $t3->math("\\{alpha} = \\{delta}, \\{beta} = \\{epsilon}, \\{gamma} = \\{theta}");
        $t4->blue( [ 0 .. 2 ] );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t3->erase();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "On the point E, construct an angle FEG on the "
                      . "line EF equal to the angle \\{alpha} (I.23)" );
        ( $l{EGx}, $a{alpha2} ) =
          $a{alpha}->copy( $p{E}, $l{EF}, 'negative', -1 );
        $a{alpha2}->label("\\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "On the point F, construct an angle EFG on the "
                      . "line EF equal to the angle \\{beta} (I.23)" );
        ( $l{FGx}, $a{beta2} ) =
          $a{beta}->copy( $p{F}, $l{EF}, 'positive', -1 );
        $a{beta2}->label("\\{beta}",30);

        my @p = $l{FGx}->intersect( $l{EGx} );
        $p{G} = Point->new( $pn, @p )->label( "G", "bottom" );
        $l{FG} = Line->join( $p{F}, $p{G} );
        $l{FGx}->remove;
        $l{EG} = Line->join( $p{E}, $p{G} );
        $l{EGx}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                 "And thus, the angle at G will also be the angle at A (I.32)");
        $a{gamma2} =
          Angle->new( $pn, $l{FG}, $l{EG}, -size => 20 )->label("\\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
            "Therefore the triangle ABC is equiangular to EFG, and as such, "
              . "the edges surrounding the equal angles will be in proportion, "
              . "i.e. AB is to BC as EG to EF (VI.4)" );
        $t{EFG} = Triangle->join($p{E},$p{F},$p{G})->fill($pale_yellow);
        $t3->math("AB:BC = EG:EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "But the ratio AB to BC is equal to DE to EF, therefore "
                      . "the ratio DE to EF equals EG to EF (V.11)" );
        $t4->grey( [ 1, 2 ] );
        $t3->math("DE:EF = EG:EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since DE and EG have the same ratio to EF, "
                      . "DE and EG are equal (V.9), "
                      . "" );
        $t4->blue( [ 1, 2 ] );
        $t3->grey(0);
        $t3->math("DE = EG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("and for the same reason DF is also equal to FG");
        $t3->allgrey;
        $t3->math("DF = FG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Since DE is equal to EG, and DF equals FG, "
                      . "and there is a common base EF (three sides equal) "
                      . "then the angle DEF is equal to GEF (I.8)," );
        $t3->black([-1,-2]);
        $t3->math("\\{alpha} = \\{delta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "and finally, since there are two equal sides "
            . "subtending an equal angle, both triangles DEF and EFG are equal (I.4)"
        );
        $t3->math("\\{beta} = \\{epsilon}");
        $t3->math("\\{gamma} = \\{theta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black([-1,-2,-3]);
        $t1->explain(
                 "So finally, the triangle DEF is equiangular to triangle ABC");

    };

    # -------------------------------------------------------------------------
    # Aside
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Aside - Trigonometry");
        $t3->erase();
        $t4->erase();
        foreach my $o ( \%a, \%t, \%l, \%p ) {
            foreach my $i ( keys %$o ) {
                $o->{$i}->remove;
            }
        }
        $A[0] = $C[0];
        $D[0] = $F[0];
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "right" );
        $p{E} = Point->new( $pn, @E )->label( "E", "bottom" );
        $p{F} = Point->new( $pn, @F )->label( "F", "right" );

        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($sky_blue);
        $l{AB}  = $t{ABC}->lines->[0];
        $l{AC}  = $t{ABC}->lines->[2];
        $l{BC}  = $t{ABC}->lines->[1];
        $t{DEF} = Triangle->join( $p{D}, $p{E}, $p{F} )->fill($lime_green);
        $l{DE}  = $t{DEF}->lines->[0];
        $l{EF}  = $t{DEF}->lines->[1];
        $l{DF}  = $t{DEF}->lines->[2];

        $a{alpha} =
          Angle->new( $pn, $l{BC}, $l{AB}, -size => 30 )->label("\\{alpha}");
        $a{beta} = Angle->new( $pn, $l{AC}, $l{BC} );
        $a{b}    = Angle->new( $pn, $l{DF}, $l{EF} );
        $a{a}    = Angle->new( $pn, $l{EF}, $l{DE}, -size => 20 )->label("\\{delta}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
               "Consider two right angle triangles where angle ABC equals angle DEF");
        $t3->math("\\{alpha} = \\{delta}")->blue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
               "Since two of the angles are equal in both triangles, the third "
                 . "must also be equal, hence angle BAC equals EDF" );
        $a{gamma} =
          Angle->new( $pn, $l{AB}, $l{AC}, -size => 20 )->label("\\{gamma}");

        $a{c} = Angle->new( $pn, $l{DE}, $l{DF}, -size => 30 )->label("\\{theta}");
        $t3->math("\\{gamma} = \\{theta}")->blue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "Then, according to (VI.4), the ratio of the sides will be equal, "
               . "in other words, AC to AB equals DF to DE, etc" );
        $t3->math("AC:AB = DF:DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Aside - Trigonometry");
        $t1->explain(   "Conversly, consider two right triangles where "
                      . "AC to AB equals DF to DE" );
        $t3->erase;
        $t3->math("AC:AB = DF:DE")->blue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that \\{alpha} is not equal to angle \\{delta}...");
        $t1->explain("Draw line EG, such that angle GEF equals \\{alpha}");
        $p{G} = Point->new( $pn, $D[0], $D[1] + 40 )->label( "G", "right" );
        $l{EG} = Line->join( $p{E}, $p{G} );
        $a{a}->grey;
        $a{c}->grey;
        $a{alpha2} = Angle->new( $pn, $l{EF}, $l{EG} )->label("\\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "Triangle GEF is equiangular to ABC, so therefore AC to BE equals "
               . "FG to EG" );
        $t3->math("FG:EG = AC:AB = DF:DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                    "With a bit of math (pythagoras' theorem), it can be shown "
                      . "that the point G must be the same point as D" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase;
        $t3->math("c = ED, b = DF, a = EF, d = FG, e = EG")->blue;
        $t3->math("FG:EG = AC:AB = DF:DE \\{then} d/e = b/c")->blue(1);
        $t3->math(   "a\\{squared}+b\\{squared} = c\\{squared}; "
                   . "a\\{squared}+d\\{squared} = e\\{squared}" );
        $t3->math("a\\{squared}+(b\\{dot}(e/c))\\{squared} = e\\{squared}");
        $t3->math(
             "a\\{squared} = e\\{squared}\\{dot}(1-(b\\{squared}/c\\{squared}))"
        );
        $t3->math(
                "a\\{squared} = e\\{squared}\\{dot}((c\\{squared}-b\\{squared})"
                  . "/c\\{squared})" );
        $t3->math(
               "a\\{squared} = e\\{squared}\\{dot}(a\\{squared}/c\\{squared})");
        $t3->math("a\\{squared} = a\\{squared}\\{dot}(e/c)\\{squared}");
        $t3->math("\\{therefore} e = c");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So the angle \\{alpha} equals the angle \\{delta}");
        $t3->erase;
        $t3->math("AC:AB = DF:DE")->blue;
        $t3->math("\\{delta} = \\{alpha}");
        $p{G}->remove;
        $l{EG}->remove;
        $a{alpha2}->remove;
        $a{a}->normal;
        $a{c}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase;
        $t1->erase;
        $t1->down;
        $t1->title("Aside - Trigonometry");
        $t1->explain("Conclusion:");
        $t1->explain("Given two right triangles ABC and DEF");
        $tindent->y( $t1->y );
        $t1->explain("*");
        $tindent->explain(
                     "If the ratio of AC to AB equals DF to DE, then the angle "
                       . "ABC is equal to the angle DEF" );
        $t1->y( $tindent->y );
        $t1->explain("*");
        $tindent->explain( "If the angle "
            . "ABC is equal to the angle DEF, then the ratio of AC to AB equals DF to DE"
        );
        $t3->math("AC:AB = DF:DE \\{then} \\{alpha} = \\{delta}");
        $t3->math("\\{alpha} = \\{delta}         \\{then} AC:AB = DF:DE");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->y( $tindent->y );
        $t1->down;
        $t1->explain(
                   "So for every right angle triangle, the ratio of the sides "
                     . "(opposite over hypotenuse) is unique for every angle" );
        $t1->explain(
                    "Lets call this ratio, as a function of the angle, 'sine'");
        $t3->down;
        $t3->explain("Definition:");
        $l{tmp} = $t3->y;
        $t3->math("sin(\\{alpha}) = AC:AB");
        $t3->math("sin(\\{delta}) = DF:DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "We can use the same arguments to define the 'cosine' of an angle "
               . "as the ratio of BC to AB" );
        $t3->y( $l{tmp} );
        $t3->math("                  cos(\\{alpha}) = BC:AB");
        $t3->math("                  cos(a) = EF:DE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->down;
        $t3->math( "sin\\{squared}(\\{alpha}) + cos\\{squared}(\\{alpha})"
            . " = (AC)\\{squared}/(AB)\\{squared} + (BC)\\{squared}/(AB)\\{squared}"
        );
        $t3->math(   " " x 17
                   . " = ((AC)\\{squared} + (BC)\\{squared})/(AB)\\{squared}" );
        $t3->math( " " x 17 . " = (AB)\\{squared}/(AB)\\{squared} = 1" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain(
                "Sine and cosine have been expanded to include definitions for "
              . "angles larger than a right angle, and even negative angles, but "
              . "these ratios shown above are the roots of trigonometry" );
    };

    return $steps;

}

