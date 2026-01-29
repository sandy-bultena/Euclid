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
    "If a point be taken outside a circle and from it there fall on "
  . "the circle two straight lines, and if one of them cut the circle and the other "
  . "touch it, the rectangle contained by the whole of the straight line which "
  . "cuts the circle and the straight line intercepted on it outside between "
  . "the point and the convex circumference will be equal to the square on the tangent.";

$pn->title( 36, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 480, 200 );
my $t2 = $pn->text_box( 400, 650 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 36 );
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
    my ( %l, %p, %c, %s, %a, %txt );

    my @c1 = ( 260, 350 );
    my $r1 = 150;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->down;
        $t4->title("In other words");
        $t4->explain(
                 "Let line AD cut a circle in two places, where A,C are the "
                   . "intersection points on the circumference of the circle" );
        $t4->sidenote(
            "   Definition of secant: a line that cuts a circle in two points");
        $t4->down;
        $t4->explain("Let a line drawn from D touch the circle at point B");
        $t4->explain("Then the product AD,CD equals BD squared");
        $c{1} = Circle->new( $pn, $c1[0], $c1[1], $c1[0], $c1[1] + $r1 );
        $p{A} = $c{1}->point(20)->label( "A", "right" );
        $p{B} = $c{1}->point(180)->label( "B", "left" );
        $p{C} = $c{1}->point(-120)->label( "C", "bottom" );
        $p{F} = Point->new( $pn, @c1 )->label( "F", "right" );
        $l{AC} = Line->join( $p{A}, $p{C} );

        $l{ADt} = $l{AC}->clone->extend($r1)->grey;
        my @p = $p{B}->coords;
        $l{BDt} = Line->new( $pn, @p, $p[0], $p[1] + 2 * $r1 )->grey;
        @p = $l{ADt}->intersect( $l{BDt} );
        $p{D} = Point->new( $pn, @p )->label( "D", "bottom" );

        $l{CD} = Line->join( $p{C}, $p{D} );
        $l{BD} = Line->join( $p{B}, $p{D} );

        $l{ADt}->remove;
        $l{BDt}->remove;
        $t3->math("AD\\{dot}CD = BD\\{squared}");
    };

    # -------------------------------------------------------------------------
    # Proof 1 - centre of circle
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->down;
        $t4->down;
        $t3->erase;
        $t4->title("Proof - AD passes through centre of circle");
        $p{A}->remove;
        $p{A} = $c{1}->point(60)->label( "A", "top" );
        $l{AC}->remove;
        $l{AC} = Line->join( $p{A}, $p{C} );

        $l{ADt} = $l{AC}->clone->extend($r1)->grey;
        my @p = $p{B}->coords;
        $l{BDt} = Line->new( $pn, @p, $p[0], $p[1] + 2 * $r1 )->grey;
        @p = $l{ADt}->intersect( $l{BDt} );
        $p{D}->remove;
        $p{D} = Point->new( $pn, @p )->label( "D", "bottom" );

        $l{CD}->remove;
        $l{CD} = Line->join( $p{C}, $p{D} );
        $l{BD}->remove;
        $l{BD} = Line->join( $p{B}, $p{D} );

        $l{ADt}->remove;
        $l{BDt}->remove;
        $t3->math("AF = FC");
    };

    push @$steps, sub {
        $t4->explain(   "If a line AC is bisected at point F, "
                      . "and extended from C to point D, "
                      . "the product AD,CD plus the square of FC "
                      . "equals the square of FD (II.6)" );
        $l{BD}->grey;
        $p{B}->grey;
        $c{1}->grey;
        $t3->math("AD\\{dot}CD + FC\\{squared} = FD\\{squared}");
    };

    # ------------------------
    # aside...
    # ------------------------
    {

        my ( $a, $f, $c, $d ) = ( 500, 675, 850, 920 );
        my $y = 400;
        push @$steps, sub {

            # draw the line AE, with appropriate points and labels
            $p{tA} = Point->new( $pn, $a, $y )->label( "A", "top" );
            $p{tC} = Point->new( $pn, $c, $y )->label( "C", "top" );
            $p{tF} = Point->new( $pn, $f, $y )->label( "F", "top" );
            $p{tD} = Point->new( $pn, $d, $y )->label( "D", "top" );
            $l{tAF} = Line->join( $p{tA}, $p{tF} )->label( "x", "top" );
            $l{tFC} = Line->join( $p{tF}, $p{tC} )->label( "x", "top" );
            $l{tCD} = Line->join( $p{tC}, $p{tD} )->label( "y", "top" );
        };

        push @$steps, sub {

            $s{2} =
              Polygon->new(
                            $pn, 6, $f, $y,
                            $d, $y, $d, $y + ( $d - $f ),
                            $c, $y + ( $d - $f ), $c, $y + ( $d - $c ),
                            $f, $y + ( $d - $c )
              )->fill($sky_blue);
            $s{1} = Polygon->new(
                                  $pn, 4,
                                  $a,  $y,
                                  $d,  $y,
                                  $d,  $y + ( $d - $c ),
                                  $a,  $y + ( $d - $c )
            )->fillover( $s{2}, $lime_green );

            $s{1}->move( 0, ( $d - $f ), 1 );

            $l{t5} = Line->new( $pn, $a, $y + ( $d - $f ),
                                $a, $y + ( $d - $f ) + ( $d - $c ) )
              ->label( "y", "left" );
            $l{t1} = Line->new( $pn, $a, $y + ( $d - $c ),
                                $a, $y + ( $c - $f ) + ( $d - $c ),
                                1, 1 )->label( "x", "left" );
            $l{t4} =
              Line->new( $pn, $a, $y, $a, $y + ( $d - $c ), 1, 1 )
              ->label( "y", "left" );
            $l{t2} =
              Line->new( $pn, $f, $y, $f, $y + ( $d - $f ) + ( $d - $c ), 1,
                         1 );
            $l{t3} =
              Line->new( $pn, $a, $y + ( $d - $c ), $d, $y + ( $d - $c ), 1,
                         1 );
            $txt{txt2} = $pn->text_box( $d + 20, $y + 40 );
            $txt{txt2}->math("<= AD\\{dot}CD");
            $txt{txt5} = $pn->text_box( $d + 20, $f );
            $txt{txt5}->math("<= AD\\{dot}CD");
            $txt{txt3} = $pn->text_box( $f + 60, $y + 140 );
            $txt{txt3}->math("FC\\{squared}");
        };

        push @$steps, sub {
            $s{2}->remove;
            $s{1}->remove;
            $l{t1}->remove;
            $l{t2}->remove;
            $l{t3}->remove;
            $l{t4}->remove;
            $l{t5}->remove;
            $p{tA}->remove;  # = Point->new( $pn, $a, $y )->label( "A", "top" );
            $p{tC}->remove;  # = Point->new( $pn, $c, $y )->label( "C", "top" );
            $p{tF}->remove;  # = Point->new( $pn, $g, $y )->label( "G", "top" );
            $p{tD}->remove;  # = Point->new( $pn, $e, $y )->label( "E", "top" );
            $l{tAF}
              ->remove; # = Line->join( $p{tA}, $p{tG} )->label( "x",   "top" );
            $l{tCD}->remove;    # = Line->join( $p{tG}, $p{tE} );
            $l{tFC}
              ->remove; # = Line->join( $p{tE}, $p{tC} )->label( "y",   "top" );
            foreach my $x ( keys %txt ) { $txt{$x}->erase; }
        };
    }

    # ------------------------
    # back to the proof
    # ------------------------

    push @$steps, sub {
        $t4->explain("Draw line FB");
        $l{FB} = Line->join( $p{F}, $p{B} );
        $c{1}->normal;
        $t4->explain("Angle FBD is right (III.18)");
        $a{FBD} = Angle->new( $pn, $l{BD}, $l{FB} );
        $p{B}->normal;
        $l{BD}->normal;
        $t3->allgrey;
        $t3->math("BF = FC");
    };

    push @$steps, sub {
        $t4->explain( "The triangle FBD is a right triangle, "
                . "and thus follows Pythagoras' rule (I.47), "
                . "thus the sum of the squares BF,BD equals the square of FD" );
        $s{FBD} = Triangle->join( $p{F}, $p{B}, $p{D} )->fill($sky_blue);
        $t3->allgrey;
        $t3->math("BD\\{squared} + BF\\{squared} = FD\\{squared}");
    };

    push @$steps, sub {
        $t4->explain(
             "Since BF equals FC, then the square of BF equals the square of FC"
        );
        $t3->black(-2);
        $t3->math("BD\\{squared} + FC\\{squared} = FD\\{squared}");
    };

    push @$steps, sub {
        $t3->down;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("BD\\{squared}   = FD\\{squared} - FC\\{squared}");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black(1);
        $t3->math("AD\\{dot}CD = FD\\{squared} - FC\\{squared}");
    };

    push @$steps, sub {
        $t4->explain("Thus, the product of AD,CD equals the square of BD");
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("AD\\{dot}CD = BD\\{squared}");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ 0, -1 ] );
    };

    # -------------------------------------------------------------------------
    # Proof 2 - centre of circle
    # -------------------------------------------------------------------------
    push @$steps, sub {
        @c1 = ( $c1[0] + 20, $c1[1] );
        $t4->erase;
        $t4->down;
        $t4->down;
        $t3->erase;
        $t4->title("Proof - AD does not pass through centre of circle");

        foreach my $type ( \%c, \%a, \%l, \%p, \%s ) {
            foreach my $obj ( keys %$type ) {
                $type->{$obj}->remove;
            }
        }

        $c{1} = Circle->new( $pn, $c1[0], $c1[1], $c1[0], $c1[1] + $r1 );
        $p{A} = $c{1}->point(-25)->label( " A", "bottom" );
        $p{B} = $c{1}->point(-90)->label( "B",  "bottom" );
        $p{C} = $c{1}->point(-130)->label( "C", "top" );
        $p{E} = Point->new( $pn, @c1 )->label( "E", "top" );
        $l{AC} = Line->join( $p{A}, $p{C} );

        $l{ADt} = $l{AC}->clone->extend($r1)->grey;
        my @p = $p{B}->coords;
        $l{BDt} = Line->new( $pn, @p, $p[0] - 2 * $r1, $p[1] )->grey;
        @p = $l{ADt}->intersect( $l{BDt} );
        $p{D} = Point->new( $pn, @p )->label( "D", "bottom" );

        $l{CD} = Line->join( $p{C}, $p{D} );
        $l{BD} = Line->join( $p{B}, $p{D} );

        $l{ADt}->remove;
        $l{BDt}->remove;

    };

    push @$steps, sub {
        $t4->explain(   "Draw a line EF from the centre of the "
                      . "circle E, perpendicular to the line DA" );
        $l{tmp} = $l{AC}->perpendicular( $p{E} );
        my @p = $l{AC}->intersect( $l{tmp} );
        $p{F} = Point->new( $pn, @p )->label( "F", "bottom" );
        $l{EF} = Line->join( $p{E}, $p{F} );
        $l{tmp}->remove;
        $l{AF} = Line->join( $p{A}, $p{F}, -1 );
        $a{EFA} = Angle->new( $pn, $l{AF}, $l{EF} );
    };

    push @$steps, sub {
        $t4->explain("Lines CF and FA are equal (III.18)");
        $t3->math("CF = FA");
    };

    push @$steps, sub {
        $t4->explain(   "If a line AC is bisected at point F, "
                      . "and extended from C to point D, "
                      . "the product AD,CD plus the square "
                      . "of FC equals the square of FD (II.6)" );
        $l{BD}->grey;
        $p{B}->grey;
        $c{1}->grey;
        $l{EF}->grey;
        $a{EFA}->grey;
        $t3->allgrey;
        $t3->math("AD\\{dot}CD + FC\\{squared} = FD\\{squared}");
    };

    push @$steps, sub {
        $t4->explain("Add the square of EF to both sides of the equality");
        $t3->math("AD\\{dot}CD + FC\\{squared} + EF\\{squared} ");
        $t3->math("  = FD\\{squared} + EF\\{squared}");
        $l{EF}->normal;
    };

    push @$steps, sub {
        $t4->explain(   "In the triangle ECF, the sum of the "
                      . "squares EF,FC equal the square of EC (I.47)" );
        $s{ECF} = Triangle->join( $p{E}, $p{C}, $p{F} )->fill($sky_blue);
        $t3->allgrey;
        $t3->math("FC\\{squared} + EF\\{squared} = EC\\{squared}");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ -1, -2, -3 ] );
        $t3->math("AD\\{dot}CD + EC\\{squared} ");
        $t3->math("  = FD\\{squared} + EF\\{squared}");
    };

    push @$steps, sub {
        $t4->explain(   "Similarly, the sum of the squares FD,EF "
                      . "equal the square of ED (I.47)" );
        $s{ECF}->grey;
        $s{EFD} = Triangle->join( $p{E}, $p{F}, $p{D} )->fill($blue);
        $t3->allgrey;
        $t3->math("FD\\{squared} + EF\\{squared} = ED\\{squared}");
    };

    push @$steps, sub {
        $t3->down;
        $t3->black( [ -2, -3 ] );
        $t3->math("AD\\{dot}CD + EC\\{squared} = ED\\{squared}");
    };

    push @$steps, sub {
        $t3->down;
        $t4->explain(
                "But the square of ED is just the sum of the squares of DB,EB");
        $p{B}->normal;
        $s{EFD}->remove;
        $s{EDB} =
          Triangle->join( $p{E}, $p{D}, $p{B} )
          ->fill( Colour->add( $sky_blue, $blue ) );
        $t3->allgrey;
        $t3->math("DB\\{squared} + EB\\{squared} = ED\\{squared}");
    };

    push @$steps, sub {
        $t4->explain(   "And since EB equals EC, the square of "
                      . "ED is the sum of the squares DB,EC" );
        $t3->math("EB = EC");
        $t3->math("DB\\{squared} + EC\\{squared} = ED\\{squared}");
    };

    push @$steps, sub {
        $t4->explain("Subtract EC from both sides of both equations");
        $t3->down;
        $t3->allgrey;
        $t3->black( [ -1, -4 ] );
        $t3->math("AD\\{dot}CD = ED\\{squared} - EC\\{squared}");
        $t3->math("DB\\{squared}   = ED\\{squared} - EC\\{squared}");
    };

    push @$steps, sub {
        $s{EDB}->remove;
        $l{DB} = Line->join( $p{D}, $p{B} );
        $l{EF}->grey;
        $t4->explain(
             "Since equals are equal to equals, we have proven this proposition"
        );
        $t3->down;
        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("AD\\{dot}CD = DB\\{squared}");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
    };

    return $steps;

}

