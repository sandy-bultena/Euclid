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
    "If a straight line be cut into equal and unequal segments, the "
  . "squares on the unequal segments of the whole are double of the square on "
  . "the half and of the square on the straight line between the points of section.";

$pn->title( 9, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 480, 200 );
my $t7 = $pn->text_box( 520, 200 );
my $t6 = $pn->text_box( 560, 340 );
my $t3 = $pn->text_box( 140, 480 );

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

    my @A = ( 100, 400 );
    my @B = ( 500, 400 );
    my @D = ( 380, 400 );
    my @C;
    my @E;
    $t6->down;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain(
                "Let AB be a straight line, bisected at point C, "
              . "and cut at an arbitrary point D"
        );
        $p{A} = Point->new( $pn, @A )->label(qw(A left));
        $p{B} = Point->new( $pn, @B )->label(qw(B right));
        $l{AB} = Line->new( $pn, @B, @A );
        $p{C}  = $l{AB}->bisect->label(qw(C bottom));
        $p{D}  = Point->new( $pn, @D )->label(qw(D bottom));
        @C     = $p{C}->coords;
        $l{AC} = Line->new( $pn, @A, @C, -1 );
        $t2->math("AC = CB, AC,CD,DB = AB");
        $t2->blue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "The sum of the squares of AD and DB is equal to "
                      . "twice the sum of the squares of AC and DC" );
        $t2->math(   "AD\\{squared} + DB\\{squared} "
                   . "= 2\\{dot}(AC\\{squared}+CD\\{squared})" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->down;
        $t2->math("(x+y)\\{squared} + (x-y)\\{squared} ");
        $t2->math(" = 2(x\\{squared} + y\\{squared})");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t2->erase;
        $t2->math("AC = CB, AC,CD,DB = AB");
        $t2->blue;

        $t4->title("Construction:");
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
        $t4->explain("Draw a line parallel to EC through point D");
        $l{DFt} = $l{CE}->parallel( $p{D} )->grey;
        my @f = $l{EB}->intersect( $l{DFt} );
        $p{F} = Point->new( $pn, @f )->label(qw(F topright));
        $l{DF} = Line->new( $pn, @D, @f );
        $l{DFt}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Draw a line parallel to AB through point F");
        $l{FGt} = $l{AB}->parallel( $p{F} )->grey;
        my @g = $l{CE}->intersect( $l{FGt} );
        $p{G} = Point->new( $pn, @g )->label(qw(G left));
        $l{GF} = Line->new( $pn, @g, $p{F}->coords );
        $l{FGt}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Join AF");
        $l{AF} = Line->new( $pn, @A, $p{F}->coords );
    };

    # -------------------------------------------------------------------------
    # Proof (Angles)
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->erase;
        $t1->title("Proof");
        $t4->y( $t1->y );

        $s{ACE} =
          Triangle->new( $pn, $p{A}->coords, $p{C}->coords, $p{E}->coords, -1 );
        $s{ACE}->fill($blue);
        foreach my $line ( keys %l ) {
            if ( ref( $l{$line} ) ) { $l{$line}->grey }
        }
        $p{G}->label;

        $t4->explain( "Triangle AEC is a right angle triangle, "
              . "and AC and CE are equal, therefore it is an isosceles triangle"
        );
        $t4->explain( "Since the sum of the angles in a triangle "
            . "equals two right angles\\{nb}(I.32), "
            . "and ACE is a right angle, then the two base angles "
            . "(being equal (I.5)) each equal one half a right angle (45 degrees)"
        );

        $s{ACE}->set_angles( "45", undef, "45" );
        $t2->allgrey;
        $t2->math("\\{angle}EAC = \\{angle}CEA = 45");
        $t3->allgrey;
        $t3->black(0);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{CBE} =
          Triangle->new( $pn, $p{C}->coords, $p{B}->coords, $p{E}->coords, -1 );
        $s{CBE}->fill($purple);

        $t4->explain(   "By the same reason, angles CEB and CBE are each "
                      . "half a right angle, which makes AEB a right angle" );
        $s{CBE}->set_angles( undef, "45", "45" );
        $a{AEB} = Angle->new( $pn, $l{AE}, $l{EB} );
        $t2->allgrey;
        $t2->math("\\{angle}CEB = \\{angle}CBE = 45");
        $t6->allgrey;
        $t6->black(1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{CBE}->grey;
        $s{ACE}->grey;
        $l{AB}->normal;
        $l{GF}->normal;
        $l{CE}->normal;
        $a{AEB}->remove;
        $p{G}->label(qw(G left));

        $t4->explain(   "Since AB and GF are parallel, and CE intersects them, "
                      . "the opposite and interior angles "
                      . "are equal\\{nb}(I.29), so EGF is a right angle" );
        $a{FGE} =
          Angle->new( $pn, $l{GF},
                      VirtualLine->new( $p{G}->coords, $p{E}->coords ) );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $a{ACE}->remove;
        $l{AB}->grey;
        $l{GF}->grey;
        $l{CE}->grey;
        $s{EGF} =
          Triangle->new( $pn, $p{E}->coords, $p{G}->coords, $p{F}->coords, -1 );
        $s{EGF}->fill($pale_yellow);
        $s{EGF}->set_angles( "45", undef, undef, 20, 0, 0 );

        $t4->explain(   "The angle EFG is one half a right angle\\{nb}(I.32), "
                      . "and since two angles are equal, "
                      . "EGF is isosceles\\{nb}(I.6), so EG equals\\{nb}GF" );

        $s{EGF}->set_angles( "45", undef, 45, 20, 0, 20 );
        $t6->allgrey;
        $t2->math("\\{angle}GEF = \\{angle}EFG = 45");
        $t6->math("EG = GF");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{EGF}->grey;
        $a{FGE}->remove;
        $s{FDB} =
          Triangle->new( $pn, $p{F}->coords, $p{D}->coords, $p{B}->coords, -1 );
        $s{FDB}->fill($yellow);

        $t4->explain(   "Using the same logic, FDB is also an isosceles "
                      . "triangle, and DB equals FD" );
        $s{FDB}->set_angles( "45", " ", "45", 20, 0, 20 );
        $t2->allgrey;
        $t6->allgrey;
        $t2->math("\\{angle}DFB = \\{angle}FBD = 45");
        $t6->math("DB = FD");

    };

    # -------------------------------------------------------------------------
    # Proof (squares)
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->y( $t1->y );
        $s{FDB}->remove;
        $s{ACE}->draw;
        $s{ACE}->fill($purple);
        $p{G}->label;
        $t2->allgrey;
        $t6->allgrey;

        $t4->explain(   "The triangle AEC is a right angle, thus the square "
                      . "on AE equals the sum of the squares of AC and AE" );
        $t3->math("AE\\{squared} = AC\\{squared} + EC\\{squared} ");
    };

    # -------------------------------------------------------------------------
    # Proof (squares)
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "Since AC equals CE, the sum of the squares of "
                      . "AC and CE equals twice the square of AC " );
        $t3->erase;
        $t6->black(0);
        $t3->math(   "AE\\{squared} = AC\\{squared} + EC\\{squared} "
                   . "= 2\\{dot}AC\\{squared}" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{ACE}->remove;
        $p{G}->label(qw(G left));
        $s{EGF}->draw;

        $s{EGF}->fill($pale_yellow);

        $t4->explain(   "Since EG equals GF, the sum of the squares of EG "
                      . "and GF equals twice the square of GF " );
        $t4->explain(   "The triangle EGF is a right angle, thus the square "
                      . "on EF equals the sum of the squares of EG and GF" );

        $t6->allgrey;
        $t6->black(2);
        $t3->allgrey;
        $t3->math(   "EF\\{squared} = EG\\{squared} + GF\\{squared} "
                   . "= 2\\{dot}GF\\{squared}" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "GF equals CD (I.34), thus the square on "
                      . "EF equals twice the sum of CD" );
        $t3->allgrey;
        $t6->allgrey;
        $t3->math("EF\\{squared} = 2\\{dot}CD\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{EGF}->remove;
        $p{G}->remove;
        $s{EAF} =
          Triangle->new( $pn, $p{E}->coords, $p{A}->coords, $p{F}->coords, -1 );
        $s{EAF}->set_angles(" ");
        $s{EAF}->fill($lime_green);

        $t4->explain(   "The triangle EAF is a right angle, thus the square "
                      . "on AF equals the sum of the squares of AE and EF" );
        $t3->allgrey;
        $t3->math("AF\\{squared} = AE\\{squared} + EF\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ 0, 2, 3 ] );
        $t3->math(
                "AF\\{squared} = 2\\{dot}AC\\{squared} + 2\\{dot}CD\\{squared} "
                  . "= 2(AC\\{squared} + CD\\{squared})" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{EAF}->remove;
        $s{ADF} =
          Triangle->new( $pn, $p{A}->coords, $p{D}->coords, $p{F}->coords, -1 );
        $s{ADF}->set_angles( undef, " " );
        $s{ADF}->fill($pale_pink);

        $t4->explain(   "The triangle FAD is a right angle, thus the square on "
                      . "AF equals the sum of the squares of AD and DF" );
        $t3->allgrey;
        $t3->math("AF\\{squared} = AD\\{squared} + DF\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "But DF equals DB, so the square of AF is the sum "
                      . "of the squares of AD and DB" );
        $t6->allgrey;
        $t6->black(-1);
        $t3->math("AF\\{squared} = AD\\{squared} + DB\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{ADF}->remove;
        $s{CBE}->remove;
        $p{G}->draw;
        foreach my $line ( keys %l ) {
            next if $line =~ /t$/;
            $l{$line}->draw, $l{$line}->normal;
        }

        $t6->allgrey;
        $t3->allgrey;
        $t3->black([-1,-3]);
        $t4->explain("Rearranging the equalities gives the original postulate");
        $t3->down;
        $t3->math(
            "AD\\{squared} + DB\\{squared} = 2(AC\\{squared} + CD\\{squared})");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
        $t2->allgrey;
        $t2->blue(0);
    };

    return $steps;

}

