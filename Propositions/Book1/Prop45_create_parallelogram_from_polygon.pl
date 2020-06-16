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
my $title = "To construct a parallelogram equal to a given rectilinear figure in a given rectilinear angle.";

my $pn = PropositionCanvas->new( -number => 45, -title => $title );
$pn->copyright;

my $t1 = $pn->text_box( 800, 130, -width => 480 );
my $t2 = $pn->text_box( 475, 200 );
my $t3 = $pn->text_box( 475, 525 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,45);
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
    my $top = 125;
    my $bot = 325;
    my @A   = ( 75, $top + 30 );
    my @B   = ( 300, $bot );
    my @C   = ( 425, $top + 70 );
    my @D   = ( 275, $top );
    my @K   = ( 200, 700 );

    my @E1 = ( $A[0] + 10, $A[1]+300 );
    my @E2 = ( $E1[0] + 100, $E1[1] );
    my @E3 = ( $E1[0] + 150, $E1[1] - 125 );

    my @steps;

    # ------------------------------------------------------------------------
    # In other words
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Start with a given rectilinear figure ABCD and a ".
        "given angle\\{nb}\\{epsilon}");
        $s{ABCD} = Polygon->new( $pn, 4, @A, @B, @C, @D, 1, -points => [qw(A left B bottom C right D top)] );
        $l{E12} = Line->new( $pn, @E1, @E2 );
        $l{E23} = Line->new( $pn, @E2, @E3 );
        $a{E} = Angle->new( $pn, $l{E23}, $l{E12} )->label("\\{epsilon}");
        $s{ABCD}->fill($sky_blue);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create a parallelogram with an angle\\{nb}\\{epsilon}, ".
        "such that it is equal in area to the polygon ABCD");
        $p{x} = Point->new($pn,@K);
        $t{x} = $s{ABCD}->copy_to_parallelogram_on_point($p{x},$a{E});
        $t{x}->fill($sky_blue);
        $t{x}->set_angles(undef,"\\{epsilon}");
    };

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("Construction");
        $t{x}->remove;
        $p{x}->remove;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw line DB, creating two triangles");
        $l{DB} = Line->new( $pn, @B, @D );
        $t{ABD} = Triangle->assemble( $pn, -lines => [ $s{ABCD}->l(1), $l{DB},         $s{ABCD}->l(4) ] );
        $t{DBC} = Triangle->assemble( $pn, -lines => [ $l{DB},         $s{ABCD}->l(2), $s{ABCD}->l(3) ] );
        $t2->math("ABCD = \\{triangle}ABD + \\{triangle}DBC");
        $t{ABD}->fillover($s{ABCD},$lime_green);
        $t{DBC}->fillover($s{ABCD},$lime_green);
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create a parallelogram equal to triangle ABD, with angle\\{nb}\\{epsilon}\\{nb}(I.42)");
        ( $s{ABD}, $a{D2} ) = $t{ABD}->parallelogram( $a{E} );
        $s{ABD}->fill($lime_green);
        $s{ABCD}->fill;
        $s{ABD}->set_angles(undef,"\\{epsilon}");
        $t{ABD}->fill;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        local $Shape::DefaultSpeed = 5;
        $p{K} = Point->new( $pn, @K );
        $s{FGHK} = $s{ABD}->copy_to_point( $p{K} );
        $s{ABD}->remove;
        $a{D2}->remove;
        $p{K}->remove;
        $s{FGHK}->set_angles( undef, "\\{epsilon}", undef );
        $s{FGHK}->set_points(qw(F top K bottom H bottom G top));

        $s{FGHK}->fill($lime_green);
        $t{ABD}->fill($lime_green);

        $t2->math("\\{angle}FKH = \\{epsilon}");
        $t2->math("\\{triangle}ADB = \\{parallelogram}FGHK");
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create a parallelogram equal to triangle DBC, with angle\\{nb}\\{epsilon}\\{nb}(I.42)");
        ( $s{DBC}, $a{D2} ) = $t{DBC}->parallelogram( $a{E} );
        $s{DBC}->fillover($t{ABD},$lime_green);
        $t{DBC}->fill;
        $s{DBC}->set_angles(undef,"\\{epsilon}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        local $Shape::DefaultSpeed = 5;
        $t1->explain("Create a parallelogram, equal to triangle DBC, on side GH\\{nb}(I.44) ");
        my $t = Line->new( $pn, $s{FGHK}->l(3)->end, $s{FGHK}->l(3)->start, -1 );

        $s{GHLM} = $s{DBC}->copy_to_line($t);
        $t->remove;
        $s{DBC}->remove;
        $a{D2}->remove;
        $s{GHLM}->set_points( undef, undef, undef, undef, qw(M bottom L top) );
        $s{GHLM}->set_angles( undef, "\\{epsilon}", undef, undef, 0, 20, 0, 0 );

        $t{DBC}->fill($lime_green);
        $s{GHLM}->fill($lime_green);

        $t2->math("\\{angle}GHM = \\{epsilon}");
        $t2->math("\\{triangle}DBC = \\{parallelogram}GHLM");
        $t2->allblue;
        $t3->y($t2->y);

    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("FLMK is a parallelogram, and it's area is equal to the polygon ABCD");
        $t3->math("\\{parallelogram}FLMK = ABCD");
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->erase;
        $t3->erase;
        $t1->title("Proof:");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("FGHK is a parallelogram by construction so its sides are parallel");
        $t2->allgrey;
        $t2->math("FK \\{parallel} GH, FG \\{parallel} KH");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Since FK and GH are parallel lines, angles FKH and GHK sum to two right angles\\{nb}(I.29)");

        $s{FGHK}->set_angles( undef, undef, "\\{delta}", undef, 0, 0, 25, 0 );

        $t2->math("\\{epsilon} + \\{delta} = 2\\{right}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Since angles GHK and GHM sum to two right angles, KH is in a straight line with HM\\{nb}(I.14)");
        $l{KM} = Line->new( $pn, $s{FGHK}->p(2)->coords, $s{GHLM}->p(3)->coords );
        $l{KM}->notice;
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("KH,HM = KM");
        $s{FGHK}->a(2)->grey;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Lines KM and FG are parallel since FGHK is a parallelogram" );
        $t2->allgrey;
        $t2->math("KM \\{parallel} FG");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Thus, the ".
                      "alternate angles (HGF and GHM) are equal\\{nb}(I.29)" );

        $s{FGHK}->set_angles( undef, undef, undef, "\\{epsilon}" );
        $s{FGHK}->a(2)->grey;
        $s{FGHK}->a(3)->grey;
    };
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("GLMH is a parallelogram by construction, so all its sides are parallel");
        $t2->allgrey;
        $t2->math("GL \\{parallel} HM, GH \\{parallel} LM");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Angles LGH and GHM sum to two right angles\\{nb}I.29");
        $s{FGHK}->a(4)->grey;
 
        $s{GHLM}->set_angles( "\\{beta}", undef, undef, undef, 20 );

        $t2->allgrey;
        $t2->black(-1);
        $t2->math("\\{epsilon} + \\{beta} = 2\\{right}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Since angles FGH and LGH sum to two right angles, FG is in a straight line with GL\\{nb}(I.14)");
        $l{FL} = Line->new( $pn, $s{FGHK}->p(1)->coords, $s{GHLM}->p(4)->coords );
        $l{FL}->notice;
        $s{FGHK}->a(4)->draw;
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("FG,GL = FL");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Lines FK and GH are parallel to each other, "
                      . "and lines GH and LM are parallel to each other, therefore "
                      . "lines FK and LM are parallel\\{nb}(I.30)" );
        $t2->allgrey;
        $t2->black([5,9]);
        $t2->math("FK \\{parallel} LM");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("By their construction, lines GK and GH and LM are all of equal length");
        $s{FGHK}->set_labels( "x", "left" );
        $s{GHLM}->set_labels( qw(x left), undef, undef, qw(x right) );
        $t2->allgrey;
        $t2->math("GK = GH = LM = x");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Lines joined to the extremities of equal parallel lines are themselves equal and parallel\\{nb}(I.33)");
        $t2->math("FL = KM   FL \\{parallel} KM");
        $t2->allgrey;
        $t2->black([-1,-2,-3]);
    };
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("FKML is a parallelogram");
        $t2->allgrey;
        $t2->black([-1,-2,-3]);
        $t2->math("FKML = \\{parallelogram}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "By construction, FGHK equals the area of ABD, "
                      . "and GHML equals the area DBC, and the addition of equals are "
                      . "equal, therefore ABCD equals FKLM" );
        $t2->allgrey;
        $t2->blue([0,2,4]);
        $t2->black([7,11]);
        $t2->math("\\{parallelogram}FKML = ABCD");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->blue([0..4]);
        $t2->black(-1);
    };

    return \@steps;
}
