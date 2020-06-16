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
"If a straight line be bisected, and a straight line be added to it in a straight line, "
  . "the square on the whole with the added straight line and the square on the added straight line both "
  . "together are double of the square on the half and of the square described on the "
  . "straight line made up of the half and the added straight line as on one straight line.";

$pn->title( 10, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 480, 200 );
my $t6 = $pn->text_box( 560, 380 );
my $t3 = $pn->text_box( 80,  520 );

my $steps;
push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 9 );
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

    my @A = ( 80,  400 );
    my @B = ( 380, 400 );
    my @D;
    my @C;
    my @E;
    my $d = 100;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain(   "Let AB be a straight line, bisected at point C, "
                      . "and extended to an arbitrary point D" );
        $p{A} = Point->new( $pn, @A )->label(qw(A left));
        $p{B} = Point->new( $pn, @B )->label(qw(B bottom));
        $l{AB} = Line->new( $pn, @A, @B );
        $p{C} = $l{AB}->bisect->label(qw(C bottom));
        $l{AB}->extend($d);
        my @d = $l{AB}->coords;
        @D = @d[ 2, 3 ];
        $p{D} = Point->new( $pn, @D )->label(qw(D right));
        @C = $p{C}->coords;
        $l{AC} = Line->new( $pn, @A, @C, -1 );
        $t2->math("AC = CB, AC,CB,BD = AD");
        $t2->allblue;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "The sum of the squares of AD and DB "
                    . "is equal to twice the sum of the squares of AC and DC" );
        $t5->y( $t1->y );
        $t2->math("AD\\{squared} + DB\\{squared} ");
        $t2->math(" = 2\\{dot}(AC\\{squared} + CD\\{squared})");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t2->math("AC = CB, AC,CB,BD = AD");
        $t2->allblue;
        $t4->y( $t5->y );
        $t4->down;
        $t4->title("Construction:");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "Draw a line perpendicular to AB through "
                      . "point\\{nb}C\\{nb}(I.11), and make its "
                      . "length equal to AC or\\{nb}CB\\{nb}(I.3)" );
        $l{CEt} = $l{AB}->perpendicular( $p{C} )->grey;
        $c{C}   = Circle->new( $pn, @C, @A )->grey();
        @E      = $c{C}->intersect( $l{CEt} );
        $p{E}   = Point->new( $pn, @E )->label(qw(E top));
        $l{CE}  = Line->new( $pn, @E, @C );
        $l{CEt}->remove;
        $a{ACE} = Angle->new( $pn, $l{CE}, $l{AC} );
        $t6->math("AC = CE");
        $t6->math("CB = CE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{C}->remove;
        $t4->explain("Connect AE and EB");
        $l{AE} = Line->new( $pn, @A, @E );
        $l{EB} = Line->new( $pn, @E, @B );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Draw a line parallel to AD through point E\\{nb}(I.31)");
        $l{EFt} = $l{AB}->parallel( $p{E} );
        $l{EFt}->prepend(100);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Draw a line parallel to EC through point D\\{nb}(I.31)");
        $l{DFt} = $l{CE}->parallel( $p{D} );
        my @f = $l{EFt}->intersect( $l{DFt} );
        $p{F} = Point->new( $pn, @f )->label(qw(F topright));
        $l{FD} = Line->new( $pn, @f, @D, -1 );
        $l{EF} = Line->new( $pn, @E, @f, -1 );
        $l{EFt}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        foreach my $line ( keys %l ) {
            if ( ref( $l{$line} ) ) { $l{$line}->grey }
        }
        $l{CE}->normal;
        $l{DFt}->normal;
        $l{EF}->normal;
        $t4->explain(   "Since EF crosses two parallel lines (EC and FD), "
                      . "then the sum of the "
                      . "interior angles is two right angles (FEC and EFD)" );
        $a{FEC} = Angle->new( $pn, $l{CE}, $l{EF} )->label("\\{epsilon}");
        $a{EFD} = Angle->new( $pn, $l{EF}, $l{FD} )->label("\\{gamma}");
        $t3->math("\\{epsilon} + \\{gamma} = 2\\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{EB}->normal;
        $t4->explain(
               "Thus the angles BEF and EFD sum to less than two right angles, "
                 . "and from proposition 5, EB and FD will intersect. "
                 . "Label this intersection G" );
        $a{BEF} = Angle->new( $pn, $l{EB}, $l{EF} )->label("\\{theta}");
        $t3->math("\\{theta} + \\{gamma} < 2\\{right}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{FEC}->remove;
        $a{EFD}->remove;
        $a{BEF}->remove;
        $l{EGt} = $l{EB}->clone->extend(100);
        $l{FD}->remove;
        my @g = $l{DFt}->intersect( $l{EB} );
        $p{G} = Point->new( $pn, @g )->label( "G", "bottom" );
        $l{EG} = Line->new( $pn, @E,            @g );
        $l{FG} = Line->new( $pn, $p{F}->coords, @g );
        $l{DFt}->remove;
        $l{AB}->normal;
        $l{AE}->normal;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Draw line from A to G");
        $l{AG} = Line->new( $pn, @A, $p{G}->coords );

        $t3->erase;
    };

    # -------------------------------------------------------------------------
    # Proof (Angles)
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->y( $t5->y );
        $t1->down;
        $t1->title("Proof");
        $t4->y( $t1->y );

        $s{ACE} =
          Triangle->new( $pn, $p{A}->coords, $p{C}->coords, $p{E}->coords, -1 );
        $s{ACE}->fill($sky_blue);
        foreach my $line ( keys %l ) {
            if ( ref( $l{$line} ) ) { $l{$line}->grey }
        }

        $t4->explain(   "Triangle AEC is a right angle triangle, "
                      . "and AC and CE are equal, "
                      . "therefore it is an isosceles triangle" );

        $t6->allgrey;
        $t6->black(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain( "Since the sum of the angles in a triangle "
            . "equals two right angles\\{nb}(I.32), "
            . "and ACE is a right angle, then the two base angles "
            . "(being equal (I.5)) each equal one half a right angle (45 degrees)"
        );

        $s{ACE}->set_angles( "45", undef, "45" );
        $t2->allgrey;
        $t2->math("    \\{angle}EAC = \\{angle}CEA = 45");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{ACE}->remove;
        $s{CBE} =
          Triangle->new( $pn, $p{C}->coords, $p{B}->coords, $p{E}->coords, -1 );
        $s{CBE}->fill($pale_pink);

        $t4->explain( "By the same reason, angles CEB and CBE are each half a "
                      . "right angle, which makes AEB a right angle" );
        $s{CBE}->set_angles( undef, "45", "45" );
        $a{AEB} = Angle->new( $pn, $l{AE}, $l{EB} );
        $t6->allgrey;
        $t6->black(1);
        $t2->allgrey;
        $t2->math("    \\{angle}CEB = \\{angle}CBE = 45");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{CBE}->grey;
        $s{ACE}->grey;
        $l{AB}->normal;
        $l{EG}->normal;
        $a{AEB}->remove;

        $t6->allgrey;
        $t2->allgrey;
        $t4->explain("The angle CBE and GBD are equal (I.15)");

        $a{GBD} = Angle->new( $pn,
                              VirtualLine->new( $p{G}->coords, @B ),
                              VirtualLine->new( @D,            @B ) );
        $a{GBD}->label("45");
        $a{CBE} = Angle->new( $pn,
                              VirtualLine->new( @E, @B ),
                              VirtualLine->new( @A, @B ) );
        $a{CBE}->label("45");

        $t2->math("    \\{angle}CBE = \\{angle}GBD = 45");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AB}->normal;
        $l{CE}->normal;
        $l{FG}->normal;
        $l{EG}->grey;
        $a{GBD}->remove;
        $a{CBE}->remove;

        $t4->explain(
                    "EC and FG are parallel, thus opposite and interior angles "
                      . "are equal (I.29), therefore BDG is a right angle" );
        $a{BDG} = Angle->new( $pn,
                              VirtualLine->new( @A, @D ),
                              VirtualLine->new( @D, $p{G}->coords ) );
        $a{ECB} = Angle->new( $pn,
                              VirtualLine->new( @C, @D ),
                              VirtualLine->new( @E, @C ) );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AB}->grey;
        $l{FG}->grey;
        $l{CE}->grey;
        $a{BDG}->remove;
        $a{ECB}->remove;
        $s{BDG} =
          Triangle->new( $pn, $p{B}->coords, $p{G}->coords, $p{D}->coords, -1 );
        $s{BDG}->fill($pale_yellow);
        $s{BDG}->set_angles( "45", "45" );

        $t4->explain(   "The angle DBG is one half a right angle, "
                      . "therefore BGD is one half a right "
                      . "angle\\{nb}(I.32), so BD equals\\{nb}DG\\{nb}(I.6)" );

        $t2->math("    \\{angle}DBG = \\{angle}BGD = 45");
        $t6->math("BD = DG");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{BDG}->grey;
        $s{FEG} =
          Triangle->new( $pn, $p{F}->coords, $p{E}->coords, $p{G}->coords, -1 );
        $s{FEG}->fill($yellow);

        $t4->explain(   "Using the same logic, FEG is also an isosceles "
                      . "triangle, and GF equals EF" );
        $s{FEG}->set_angles( " ", "45", "45" );
        $t2->allgrey;
        $t6->allgrey;
        $t2->math("    \\{angle}FEG = \\{angle}EGF = 45");
        $t6->math("GF = EF = CD");

    };

    # -------------------------------------------------------------------------
    # Proof (squares)
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->y( $t1->y );
        $s{FEG}->grey;
        $s{ACE}->draw;
        $s{ACE}->fill($sky_blue);

        $t2->allgrey;
        $t6->allgrey;
        $t4->explain(   "The triangle AEC is a right angle, thus the square "
                      . "on AE equals the sum of the squares of AC and AE" );
        $t3->math("AE\\{squared} = AC\\{squared} + EC\\{squared} ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "Since AC equals CE, the sum of the squares "
                      . "of AC and CE equals twice the square of AC " );

        $t6->black(0);
        $t3->erase;
        $t3->math(   "AE\\{squared} = AC\\{squared} + EC\\{squared} "
                   . "= 2\\{dot}AC\\{squared}" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{ACE}->remove;
        $s{FEG}->draw;
        $s{FEG}->fill($yellow);

        $t6->allgrey;
        $t6->black(-1);
        $t4->explain( "The triangle EGF is a right angle, thus the square "
            . "on EG equals the sum of the squares of EF and\\{nb}FG\\{nb}(I.47)"
        );
        $t4->explain(   "EF equals FG, and EF equals CD (I.34) the sum of the "
                      . "squares of EF and FG equals twice the square of CD" );

        $t3->allgrey;
        $t3->math(   "EG\\{squared} = EF\\{squared} + FG\\{squared} "
                   . "= 2\\{dot}CD\\{squared}" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{B}->label;
        $p{C}->label;
        $s{FEG}->remove;
        $s{AGE} =
          Triangle->new( $pn, $p{A}->coords, $p{G}->coords, $p{E}->coords, -1 );
        $s{AGE}->set_angles( undef, undef, " " );
        $s{AGE}->fill($teal);

        $t4->explain(   "The triangle AGE is a right angle, thus the square "
                      . "on AG equals the sum of the squares of AE and EG" );
        $t6->allgrey;
        $t3->allgrey;
        $t3->math("AG\\{squared} = AE\\{squared} + EG\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allblack;
        $t3->math(
                "AG\\{squared} = 2\\{dot}AC\\{squared} + 2\\{dot}CD\\{squared} "
                  . "= 2(AC\\{squared} + CD\\{squared})" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{AGE}->remove;
        $p{B}->label( "B", "bottom" );
        $s{AGD} =
          Triangle->new( $pn, $p{A}->coords, $p{G}->coords, $p{D}->coords, -1 );
        $s{AGD}->set_angles( undef, undef, " " );
        $s{AGD}->fill($purple);

        $t6->allgrey;
        $t4->explain(   "The triangle AGD is a right angle, thus the square on "
                      . "AG equals the sum of the squares of AD and DG" );
        $t3->allgrey;
        $t3->math("AG\\{squared} = AD\\{squared} + DG\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "But DG equals DB, so the square of AG is the "
                      . "sum of the squares of AD and DB" );
        $t6->allgrey;
        $t6->black(-2);
        $t3->math("AG\\{squared} = AD\\{squared} + DB\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{AGD}->remove;
        $p{C}->label( "C", "bottom" );
        foreach my $line ( keys %l ) {
            next if $line =~ /t$/;
            $l{$line}->draw, $l{$line}->normal;
        }

        $t6->allgrey;
        $t3->allgrey;
        $t3->black([-1,-3]);
        $t4->explain("Rearranging the equalities gives the original postulate");
        $t3->down;
        $t3->math(   "        AD\\{squared} + DB\\{squared} "
                   . "= 2(AC\\{squared} + CD\\{squared})" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->allgrey;
        $t2->blue(0);
        $t3->allgrey;
        $t3->black(-1);
    };

    return $steps;

}

