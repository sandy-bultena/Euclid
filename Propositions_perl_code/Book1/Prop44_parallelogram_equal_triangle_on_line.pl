#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

# ============================================================================
# Definitions
# ============================================================================
my $title = "To a given straight line in a given rectilinear angle, ".
"to apply a parallelogram equal to a given triangle.";

my $pn = PropositionCanvas->new( -number => 44, -title => $title );
$pn->copyright;

my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t4 = $pn->text_box( 825, 150, -width => 455 );
my $t2 = $pn->text_box( 525, 175 );
my $t3 = $pn->text_box( 525, 200 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,44);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my ( %l, %p, %c, %a, %t, %s );
    my @objs;
    my $top = 100;
    my $bot = 300;
    my @C1  = ( 150, $top );
    my @C2  = ( 125, $bot );
    my @C3  = ( $C2[0] + 300, $bot );
    my @A   = ( $C1[0] + 50, $bot + 375 );
    my @B   = ( $C1[0] + 100, $bot + 300 );
    my @D1  = ( $C3[0] - 75, ( $bot + $top ) / 1.75 );
    my @D2  = ( $D1[0] + 100, $D1[1] );
    my @D3  = ( $D1[0] + 150, $D1[1] - 125 );

    my @steps;

    # ------------------------------------------------------------------------
    # In other words
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Start with a given triangle C, a straight line AB and ".
        "an angle\\{nb}\\{delta}");
        $t{C} = Triangle->new( $pn, @C1, @C2, @C3, 1, -points => [] );
        $t{C}->l(2)->label( "C", "bottom" );
        $t{C}->fill($sky_blue);

        $p{A} = Point->new( $pn, @A )->label( "A", "bottom" );
        $p{B} = Point->new( $pn, @B )->label( "B", "right" );

        $l{AB}  = Line->new( $pn, @A,  @B );
        $l{D12} = Line->new( $pn, @D1, @D2 );
        $l{D23} = Line->new( $pn, @D2, @D3 );

        $a{D} = Angle->new( $pn, $l{D23}, $l{D12} )->label("\\{delta}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create a parallelogram, on the line AB, with an angle\\{nb}\\{delta}, ".
        "such that it is equal in area to the triangle C");
        $t{x} = $t{C}->copy_to_parallelogram_on_line($l{AB},$a{D});
        $t{C}->l(2)->normal;
        $t{x}->fill($sky_blue);
        $t{x}->set_angles(undef,"\\{delta}");
    };

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->erase;
        $t{x}->remove;
        $t1->title("Construction");
        $t1->explain("Start with a given triangle C, a straight line AB and an angle\\{nb}\\{delta}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create a parallelogram equal to triangle C, with angle\\{nb}\\{delta}\\{nb}(I.42)");
        ( $s{BEFG}, $a{D2} ) = $t{C}->parallelogram( $a{D} );
        $s{BEFG}->fill($lime_green);
        my @x = $s{BEFG}->l(1)->intersect($t{C}->l(3));
        $s{x} = Polygon->new($pn,3,@x,$s{BEFG}->p(2)->coords,$s{BEFG}->p(3)->coords);
        $s{x}->fillover($t{C},$teal);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Copy the parallelogram so that one side is in a ".
        "straight line with AB");
        $t4->y( $t1->y );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {

        $t4->explain("copy one side of parallelogram to AB");
        $l{AB}->extend(300);
        ( $l{AB}, $l{BE1} ) = $l{AB}->split( $p{B} );
        ( $l{BE}, $p{E} ) = $s{BEFG}->l(1)->copy_to_line( $p{B}, $l{BE1} );
        $l{BE1}->remove;
        $p{E}->label( "E", "top" );

    };

    # ------------------------------------------------------------------------
    push @steps, sub {

        $t4->explain("copy angle \\{delta} to BE");
        ( $l{BG1}, $a{EBG} ) = $a{D}->copy( $p{B}, $l{BE} );
        $l{BG1}->extend(300);
        $a{EBG}->label("\\{delta}");

    };

    # ------------------------------------------------------------------------
    push @steps, sub {

        $t4->explain("copy the other side of parallelogram to BG");
        ( $l{BG}, $p{G} ) = $s{BEFG}->l(2)->copy_to_line( $p{B}, $l{BG1} );
        $l{BG1}->remove;
        $p{G}->label( "G", "left" );

    };

    # ------------------------------------------------------------------------
    push @steps, sub {

        $t4->explain("create parallel lines to existing lines");
        $l{x1} = $l{BG}->parallel($p{E} );
        $l{x1}->extend(100);
        $l{x2} = $l{BE}->parallel( $p{G} );
        $l{x2}->prepend(100);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {

        $t4->explain("get last and final point");
        $p{F} = Point->new( $pn, $l{x1}->intersect( $l{x2} ) )->label( "F", "top" );

    };

    # ------------------------------------------------------------------------
    push @steps, sub {

        $t4->explain("construct the last two lines of the polygon");
        $l{EF} = Line->join( $p{E}, $p{F});
        $l{FG} = Line->join( $p{F}, $p{G});

    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        # cleanup
        $a{D2}->remove;
        $l{x1}->remove;
        $l{x2}->remove;
        $s{FGBE} = Polygon->assemble( $pn, 4, -lines => [ $l{FG}, $l{BG}, $l{BE}, $l{EF} ] );
        $s{FGBE}->fill($lime_green);
        $t3->math("EFGB = \\{triangle}C");
        
    };
    # ------------------------------------------------------------------------
    push @steps, sub {
        $s{BEFG}->remove;
        $s{x}->remove;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t4->erase;
        $t1->explain("Draw a line parallel to GB, through A\\{nb}(I.31)");
        $l{x3} = $l{BG}->parallel( $p{A} );
        $l{x3}->extend(200);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Extend line FG so that it intersects with the previously drawn line, at point H");
        $l{GH} = Line->new( $pn, $p{G}->coords, $l{x3}->intersect( $l{FG} ) );
        $p{H} = Point->new( $pn, $l{x3}->intersect( $l{FG} ) )->label( "H", "left" );
        $l{AH} = Line->new( $pn, @A, $p{H}->coords );
        $l{x3}->remove;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw line HB, extending the line so that it intersects the extension of line FE at point K");
        $l{HB} = Line->new( $pn, $p{H}->coords, @B );

        $l{x4} = $l{HB}->clone;
        $l{x4}->grey;
        $l{x4}->extend(500);
        $l{x5} = $l{EF}->clone;
        $l{x5}->grey;
        $l{x5}->prepend(500);

        $p{K} = Point->new( $pn, $l{x4}->intersect( $l{x5} ) )->label( "K", "top" );
        $l{BK} = Line->new( $pn, @B, $p{K}->coords );
        $l{EK} = Line->join( $p{E}, $p{K});
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw a line parallel to BE, through K\\{nb}(I.31)");
        $l{x4} = $l{BE}->parallel( $p{K} );
        $l{x4}->extend(600);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Extend GB so that it intersects with the previously drawn line, at point M");
        $p{M} = Point->new( $pn, $l{BG}->intersect( $l{x4} ) )->label( "M", "right" );
        $l{KM} = Line->join( $p{M}, $p{K});
        $l{BM} = Line->new( $pn, @B,              $p{M}->coords );
        $l{x4}->remove;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Extend HA and KM so that they intersects at point L");
        $p{L} = Point->new( $pn, $l{AH}->intersect( $l{x4} ) )->label( "L", "right" );
        $l{AL} = Line->new( $pn, @A,              $p{L}->coords );
        $l{LM} = Line->join( $p{L}, $p{M});
    };

    # ------------------------------------------------------------------------
    push @steps, sub {

        # construct the necessary polygons
        $s{BALM} = Polygon->assemble( $pn, 4, -lines => [ $l{AB}, $l{AL}, $l{LM}, $l{BM} ] );

        $t1->explain(   "Parallelogram BALM is equal in area to triangle C, "
                      . "and it contains the angle \\{delta} and one of it's sides "
                      . "is the given line AB" );

        $s{FGBE}->grey;
        $l{GH}->grey;
        $l{HB}->grey;
        $l{BE}->grey;
        $l{BK}->grey;
        $l{AH}->grey;
        $l{KM}->grey;
        $l{EK}->grey;
        $a{EBG}->grey;

        $s{BALM}->fill($sky_blue);

        $t3->math("BALM = \\{triangle}C");

    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof:");
        $t3->erase;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $s{FGBE}->normal;
        $l{GH}->normal;
        $l{HB}->normal;
        $l{BE}->normal;
        $l{BK}->normal;
        $l{AH}->normal;
        $l{KM}->normal;
        $l{EK}->normal;
        $a{EBG}->normal;
        $s{BALM}->fill;

        $t1->explain("By definition of the construction techniques EFGB is equal to the given triangle C\\{nb}(I.42)");
        $s{FGBE}->fill($lime_green);
        $t2->erase;
        $t3->math("EFGB = \\{triangle}C");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $s{FGBE}->fill;
        $s{BALM}->grey;
        $l{KM}->grey;
        $l{BE}->grey;
        $l{EK}->grey;
        $l{BG}->grey;
        $a{EBG}->grey;
        $l{HB}->grey;
        $l{BK}->grey;

        $t1->explain("The extension of HB will intersect the extension of line FK because...");
        $t4->y( $t1->y );
        $t4->explain("Lines FE and HA are parallel, ");
        $t4->explain(
            "therefore the sum of the angles EFG and GHA is equal the "
              . "sum of two right angles\\{nb}(I.42)" );

        $a{EFG} = Angle->new( $pn, $l{FG}, $l{EF} )->label("\\{alpha}");
        $a{GHA} = Angle->new( $pn, $l{AH}, $l{GH} )->label("\\{beta}");

        $t3->allgrey;
        $t3->math("FE \\{parallel} HA");
        $t3->math("\\{alpha} + \\{beta} = \\{right} + \\{right}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t4->explain("Angle BHG is less than GHA,");
        $t4->explain("so the sum of angles EFG and GHA is less than two right angles");
        $l{HB}->normal;
        $a{BHG} = Angle->new( $pn, $l{HB}, $l{GH} )->label( "\\{epsilon}", 75 );
        $t3->math("\\{epsilon} < \\{beta}");
        $t3->math("\\{epsilon} + \\{alpha} < \\{right} + \\{right}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t4->explain("So, by Postulate 5, HB and FE will intersect");
        $l{BK}->normal;
        $l{EK}->normal;
        $t3->allgrey;
        $t3->black(-1);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{HB}->grey;
        $l{BK}->grey;
        $l{GH}->grey;
        $l{AH}->grey;
        $l{EK}->grey;
        $a{EFG}->remove;
        $a{GHA}->remove;
        $a{BHG}->remove;

        $t1->y( $t4->y );
        $t1->explain(   "The two parallelograms FGBE and BALM are complements "
                      . "of the parallelogram FHLK, thus they are equal in "
                      . "area\\{nb}(I.43)" );

        $s{FGBE}->normal;
        $s{BALM}->normal;
        $s{FGBE}->fill($sky_blue);
        $s{BALM}->fill($lime_green);
        $t3->allgrey;
        $t3->black(0);
        $t3->math("BALM = EFGB");
        $t3->math("BALM = \\{triangle}C");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $s{FGBE}->fill;
        $s{FGBE}->grey;
        $t1->explain( "The angle ABM is the vertical angle of GBE, so they are " 
        . "equal\\{nb}(I.15)" );
        $a{EBG}->normal;
        $a{ABM} = Angle->new( $pn, $l{AB}, $l{BM} )->label("\\{delta}");
        $t3->allgrey;
        $t3->math("\\{angle}ABM = \\{angle}GBE = \\{delta}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $a{EBG}->grey;
        $t3->allgrey;
        $t3->black([-1,-2]);
    };

    return \@steps;
}

