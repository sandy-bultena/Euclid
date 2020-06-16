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
    "If in a right-angled triangle a perpendicular be drawn from the "
  . "right angle to the base, the triangles adjoining the perpendicular are similar "
  . "both to the whole and to one another.";

$pn->title( 8, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 100, 150 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 8 );
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
    my $yh  = 200;
    my $yb  = 400;
    my $dx1 = 250;
    my $m   = ( $yh - $yb ) / $dx1;
    my $dx2 = ( $yh - $yb ) * $m;
    my $d   = $dx1 + $dx2 + 30;

    my @B = ( 50, $yb );
    my @A = ( $B[0] + $dx1, $yh );
    my @C = ( $A[0] + $dx2, $yb );
    my @D = ( $A[0], $B[1] );
    my @Bd = ( $B[0] + $d, $B[1] );
    my @Dd = ( $D[0] + $d, $D[1] );
    my @Ad = ( $A[0] + $d, $A[1] );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("If we take a right angle triangle (ABC), "
                   . "where the angle BAC is a right angle, "
                   . "and we drop a perpendicular AD to the side BC, then..." );
        $t1->explain(   "The triangles BAD and ADC will be similar to "
                      . "the original triangle ABC, AND they "
                      . "will be similar to each other" );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{D} = Point->new( $pn, @D )->label( "D", "bottom" );

        $t{ABD} = Triangle->join( $p{A}, $p{B}, $p{D} )->fill($sky_blue);
        $l{AB}  = $t{ABD}->lines->[0];
        $l{AD}  = $t{ABD}->lines->[2];
        $l{BD}  = $t{ABD}->lines->[1];
        $t{ADC} = Triangle->join( $p{A}, $p{D}, $p{C} )->fill($lime_green);
        $l{AD2} = $t{ADC}->lines->[0];
        $l{CD}  = $t{ADC}->lines->[1];
        $l{AC}  = $t{ADC}->lines->[2];

        $a{A} = Angle->new( $pn, $l{AB}, $l{AC}, -size => 30 );
        $a{D} = Angle->new( $pn, $l{AD}, $l{BD}, -size => 30 );
        $a{B}  = Angle->new( $pn, $l{BD}, $l{AB} )->label("\\{beta}");
        $a{C}  = Angle->new( $pn, $l{AC}, $l{CD} )->label("\\{gamma}");
        $a{A1} = Angle->new( $pn, $l{AB}, $l{AD} )->label("\\{theta}");
        $a{A2} =
          Angle->new( $pn, $l{AD}, $l{AC}, -size => 30 )->label("\\{epsilon}");

        $t3->math("\\{gamma} = \\{theta}, \\{beta} = \\{epsilon}");
        $t3->math("AD:AB = AC:BC = CD:AC");
        $t3->math("AB:BD = BC:AB = AC:AD");
        $t3->math("AD:BD = AC:AB = CD:AD");
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
        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($pale_pink);
        $p{Ad} = Point->new( $pn, @Ad )->label( "A", "top" );
        $p{Bd} = Point->new( $pn, @Bd )->label( "B", "bottom" );
        $p{Dd} = Point->new( $pn, @Dd )->label( "D", "bottom" );

        $t{ABDd} = Triangle->join( $p{Ad}, $p{Bd}, $p{Dd} )->fill($sky_blue);
        $l{ABd}  = $t{ABDd}->lines->[0];
        $l{ADd}  = $t{ABDd}->lines->[2];
        $l{BDd}  = $t{ABDd}->lines->[1];
        $a{Dd}   = Angle->new( $pn, $l{ADd}, $l{BDd}, -size => 30 );
        $a{Bd}   = Angle->new( $pn, $l{BDd}, $l{ABd} )->label("\\{beta}");
        $a{A1d}  = Angle->new( $pn, $l{ABd}, $l{ADd} )->label("\\{theta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{A2}->grey;
        $a{A1}->grey;
        $a{D}->grey;
        $t{ADC}->grey;
        $t{ABD}->grey;
        $t1->explain(
                  "Angle BAC equals angle ADB (both are right angles), and the "
                . "angle \\{beta} is common to the two triangles ABD and ABC" );
        $t1->explain(
                "Thus the remaining angles (BCA and BAD) must be equal (I.32)");

        $t3->math("\\{angle}BAC = \\{angle}BDA = \\{right}");
        $t3->blue(0);
        $t3->math("\\{theta} = \\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore triangle ABC is equiangular with triangle ABD");
        $t1->explain(
                    "Therefore, as BC (subtends the right angle in ABC) is to "
                      . "BA (subtends the right angle in the triangle ABD), " );
        $t{ABC}->lines->[0]->grey;
        $t{ABC}->lines->[2]->grey;
        $l{BDd}->grey;
        $l{ADd}->grey;
        $a{B}->grey;
        $a{C}->grey;
        $a{A}->normal;
        $a{Bd}->grey;
        $a{A1d}->grey;
        my $y = $t3->y;
        $t3->math("BC:BA");
        $t3->y($y);
    };
    push @$steps, sub {
        $t1->explain(   "so is AB (subtends angle \\{gamma} in ABC) to BD "
                      . "(subtends the angle \\{theta} in ABD)" );
        $a{A}->grey;
        $t{ABC}->lines->[1]->grey;
        $l{AB}->normal;
        $l{ABd}->grey;
        $l{ABd}->grey;
        $l{BDd}->normal;
        $l{CD}->grey;
        $l{AC}->grey;
        $l{AD}->grey;
        $a{A1d}->normal;
        $a{C}->normal;
        $a{B}->grey;
        $a{Dd}->grey;
        $l{AD2}->grey;
        my $y = $t3->y;
        $t3->math("      = AB:BD");
        $t3->y($y);
    };
    push @$steps, sub {
        $t1->explain(   "and so is AC (subtends angle \\{beta} in ABC) "
                      . "to AD (subtends the angle \\{beta} in ABD) (VI.4)" );
        $l{AB}->grey;
        $l{BDd}->grey;
        $l{CD}->grey;
        $l{AC}->normal;
        $l{ADd}->normal;
        $a{A}->grey;
        $a{A1d}->grey;
        $a{C}->grey;
        $a{B}->normal;
        $a{Bd}->normal;
        $a{D}->grey;
        $t3->math("              = AC:AD");
    };
    push @$steps, sub {
        $t1->explain( "So, ABC and ABD are equiangular, and their sides "
               . "are proportional, which, "
               . "by definition (VI.Def.1), means they are similar triangles" );
        $t{ABC}->normal;
        $t{ABDd}->normal;
        $a{A}->normal;
        $a{C}->normal;
        $a{B}->normal;
        $a{A1d}->normal;
        $a{Bd}->normal;
        $a{Dd}->normal;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{A}->grey;
        $a{A2}->normal;
        $a{D2} = Angle->new( $pn, $l{CD}, $l{AD} );
        $t1->erase();
        $t1->down;
        $t1->title("Proof (cont)");
        $t{ABC}->grey;
        $t{ADC}->normal;
        $t{ADC}->fill($lime_green);
        $a{B}->grey;
        $t3->allgrey;
        $t3->black(1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "Angle BDA equals angle ADC (both are right angles), and the "
                . "angle \\{theta} is already been proven equal to \\{gamma}" );
        $t1->explain(   "Thus the remaining angles (\\{beta} and \\{epsilon})"
                      . " must be equal (I.32)" );
        $t3->math("\\{angle}BDC = \\{angle}BDA = \\{right}");
        $t3->math("\\{epsilon} = \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore triangle ABD is equiangular with triangle ADC");
        $t1->explain(
                    "Therefore, as AB (subtends the right angle in ABD) is to "
                      . "AC (subtends the right angle in the triangle ADC), " );
        $l{ABd}->normal;
        $l{AC}->normal;
        $l{AD}->grey;
        $l{ADd}->grey;
        $l{BD}->grey;
        $l{BDd}->grey;
        $l{AD2}->grey;
        $l{CD}->grey;

        $a{A}->grey;
        $a{A1d}->grey;
        $a{A2}->grey;
        $a{C}->grey;
        $a{Bd}->grey;
        $a{Dd}->normal;
        $a{D2}->normal;

        my $y = $t3->y;
        $t3->math("AB:AC");
        $t3->y($y);
    };
    push @$steps, sub {
        $t1->explain(   "so BD (subtends the angle \\{theta} in ABD) is to "
                      . "AD (subtends angle \\{gamma} in ACD)" );
        $l{ABd}->grey;
        $l{BDd}->normal;
        $l{CD}->grey;
        $l{AC}->grey;
        $l{AD}->normal;
        $a{A}->grey;
        $a{A1d}->normal;
        $a{A2}->grey;
        $a{C}->normal;
        $a{B}->grey;
        $a{Dd}->grey;
        $a{D2}->grey;
        $l{AD2}->grey;
        my $y = $t3->y;
        $t3->math("      = BD:AD");
        $t3->y($y);
    };
    push @$steps, sub {
        $t1->explain(   "and so is AD (subtends angle \\{beta} in ABD) "
                      . "to DC (subtends the angle \\{epsilon} in ACD (VI.4)" );
        $l{AB}->grey;
        $l{BDd}->grey;
        $l{CD}->normal;
        $l{AC}->grey;
        $l{AD}->grey;
        $l{ADd}->normal;
        $a{A1d}->grey;
        $a{A}->grey;
        $a{A1}->grey;
        $a{A2}->normal;
        $a{C}->grey;
        $a{Bd}->normal;
        $a{D}->grey;
        $t3->math("              = AD:DC");
    };
    push @$steps, sub {
        foreach my $o ( \%l, \%t, \%a, \%p ) {
            foreach my $x ( keys %$o ) {
                if ( $x =~ /d$/ ) { $o->{$x}->remove }
            }
        }
        $t1->explain(
                "So, ADC and ABD are equiangular, and their "
              . "sides are proportional, which, "
              . "by definition (VI.Def.1), means they are similar triangles"
        );
        $t{ADC}->normal;
        $t{ABD}->normal;
        $a{A}->normal;
        $a{A1}->normal;
        $a{A2}->normal;
        $a{C}->normal;
        $a{B}->normal;
        $a{D}->normal;
        $t3->allblack;
        $t3->blue(0);
    };

    # -------------------------------------------------------------------------
    # Porism
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Porism");
        $t1->explain("In a right angle triangle, if a line be drawn from the right angle, "
              . "perpendicular to the base, then this line will "
              . "be the mean proportional between "
              . "the segments of the base." );
        $t3->down;
        $t3->math("BD:AD = AD:DC");
    };

    return $steps;

}

