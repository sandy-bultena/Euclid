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
"In a circle the angle at the centre is double of the angle at the circumference,"
  . " when the angles have the same circumference as base.";

$pn->title( 20, $title, 'III' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 545, 180 );
my $t5 = $pn->text_box( 545, 180 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 20 );
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

    my @c1 = ( 270, 420 );
    my $r1 = 205;
    my $f  = 0.6;
    my $ao = 40 * 3.14159 / 180;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("In other words ");
        $t4->explain(
            "If E is the centre of a circle, and the arc BC the base of the "
              . "angle BEC (\\{epsilon}) then \\{epsilon} will be double... " );
        $t4->explain(
                     "... any angle drawn from the circumference of the circle "
                       . "with the BC as its base, " );
        $t4->explain(
             "... angle BAC (\\{alpha}) and angle BDC (\\{delta}) for example, "
        );

        $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $p{E} = Point->new( $pn, @c1 )->label( "E", "bottomleft" );
        $p{A} = $c{A}->point(165)->label( "A", "left" );
        $p{B} = $c{A}->point(-55)->label( "B", "bottom" );
        $p{C} = $c{A}->point(10)->label( "C", "right" );
        $p{D} = $c{A}->point(80)->label( "D", "top" );
        $l{EB} = Line->join( $p{E}, $p{B} );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{DB} = Line->join( $p{D}, $p{B} );
        $l{DC} = Line->join( $p{D}, $p{C} );
        $l{EC} = Line->join( $p{E}, $p{C} );
        $l{AB} = Line->join( $p{A}, $p{B} );

        $a{A} = Angle->new( $pn, $l{AB}, $l{AC} )->label("\\{alpha}");
        $a{D} = Angle->new( $pn, $l{DB}, $l{DC} )->label("\\{delta}");
        $a{E} = Angle->new( $pn, $l{EB}, $l{EC} )->label("\\{epsilon}");

        $c{BC} = Arc->new( $pn, $r1, $p{B}->coords, $p{C}->coords );

        $t5->explain("E is the centre of the circle");
        $t5->blue();
        $t3->y( $t5->y );
        $t3->math("\\{epsilon} = 2\\{alpha}");
        $t3->math("\\{epsilon} = 2\\{delta}");

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof");
        $t3->erase;
        $t3->y( $t5->y );
        $t3->down;
        $t1->y( $t4->y );
    };

    push @$steps, sub {
        $t1->explain("Draw the line from A to E and extend it to point F");
        $l{AEt} = Line->join( $p{A}, $p{E} )->extend( 1.5 * $r1 )->grey;
        my @p = $c{A}->intersect( $l{AEt} );
        $p{F} = Point->new( $pn, @p[ 0, 1 ] )->label( "F", "right" );
        $l{AF} = Line->join( $p{A}, $p{F} );
        $l{EF} = Line->join( $p{E}, $p{F} );
        $l{AEt}->remove;
    };

    push @$steps, sub {
        $t1->explain(   "Since AE and BE are equal, triangle ABE is isosceles, "
                      . "and its base angles EAB and EBA are equal (I.5)" );
        $l{AC}->grey;
        $l{EC}->grey;
        $l{DB}->grey;
        $l{DC}->grey;
        $a{A}->remove;
        $a{D}->remove;
        $a{E}->remove;
        $s{ABE} = Triangle->join( $p{A}, $p{B}, $p{E} )->fill($sky_blue);
        $a{ABAF} = Angle->new( $pn, $l{AB}, $l{AF} )->label( "\\{theta}", 60 );
        $a{EBAB} = Angle->new( $pn, $l{EB}, $l{AB} )->label( "\\{theta}", 60 );
        $t3->math("\\{angle}EAB = \\{angle}EBA = \\{theta}");
    };

    push @$steps, sub {
        $t1->explain(   "The exterior angle FEB is equal to the sum "
                      . "of the opposite interior angles (I.32) "
                      . "so FEB equals twice the angle BAE" );
        $a{EBEF} = Angle->new( $pn, $l{EB}, $l{EF} )->label("2\\{theta}");
        $t3->math("\\{angle}FEB = 2\\{theta}");
    };

    push @$steps, sub {
        $t1->explain(
                "Similarly, it can be shown that angle FEC is twice angle EAC");
        $s{ABE}->remove;
        $l{AB}->grey;
        $l{EB}->grey;
        $a{ABAF}->grey;
        $a{EBAB}->grey;
        $a{EBEF}->grey;
        $s{AEC} = Triangle->join( $p{A}, $p{E}, $p{C} )->fill($lime_green);
        $a{AFAC} = Angle->new( $pn, $l{AF}, $l{AC} )->label( "\\{gamma}", 120 );
        $a{ECAC} = Angle->new( $pn, $l{AC}, $l{EC} )->label( "\\{gamma}", 120 );
        $a{EFEC} =
          Angle->new( $pn, $l{EF}, $l{EC} )->label( "2\\{gamma}", 100 );
        $t3->allgrey;
        $t3->math("\\{angle}EAC = \\{angle}ECA = \\{gamma}");
        $t3->math("\\{angle}FEC = 2\\{gamma}");

    };

    push @$steps, sub {
        $t1->explain(   "Now, angle BAC (\\{alpha}) is equal to the sum of "
                      . "\\{theta} and \\{gamma}, "
                      . " and the angle BEC (\\{epsilon}) is equal to "
                      . "the sum of 2\\{theta} and 2\\{gamma}, "
                      . "thus giving us BEC is twice BAC" );

        $s{AEC}->remove;
        $l{AF}->grey;
        $l{EF}->grey;
        $l{AB}->normal;
        $l{EB}->normal;
        $l{AC}->normal;
        $l{EC}->normal;
        $a{ABAF}->normal;
        $a{EBAB}->remove;
        $a{ECAC}->remove;
        $a{EBEF}->normal;
        $a{alpha1} =
          Angle->new( $pn, $l{AB}, $l{AF} )->label( "\\{alpha}", 100 );
        $a{alpha2} = Angle->new( $pn, $l{AF}, $l{AC} )->label( " ", 100 );
        $a{ep1} = Angle->new( $pn, $l{EB}, $l{EF} )->label( "\\{epsilon}", 80 );
        $a{ep2} = Angle->new( $pn, $l{EF}, $l{EC} )->label( " ",           80 );
        $t3->down;
        $t3->allgrey;
        $t3->math("\\{angle}BAC = \\{alpha}");
        $t3->math("\\{alpha} = \\{gamma} + \\{theta}");
        $t3->down;
        $t3->math("\\{angle}BEC = \\{epsilon}");
        $t3->math("\\{epsilon} = 2\\{gamma} + 2\\{theta}");
        $t3->down;
        $t3->math("\\{epsilon} = 2\\{alpha}");

    };

    push @$steps, sub {
        $a{EFEC}->remove;
        $a{EBEF}->remove;
        $a{AFAC}->remove;
        $a{ABAF}->remove;
        $t3->erase;
        $t3->y( $t5->y );
        $t3->math("\\{epsilon} = 2\\{alpha}");
        $t3->down;
    };

    push @$steps, sub {
        $t1->erase;
        $t1->y( $t4->y );
        $l{AC}->grey;
        $l{AB}->grey;
        $l{AF}->grey;
        $a{alpha2}->remove;
        $a{alpha1}->remove;
        $a{ep1}->remove;
        $a{ep2}->remove;
        $l{DB}->normal;
        $l{DC}->normal;
    };

    push @$steps, sub {
        $t1->explain("Draw a line from DE and extend to G");
        $l{DEt} = Line->join( $p{D}, $p{E} )->extend( 1.5 * $r1 )->grey;
        my @p = $c{A}->intersect( $l{DEt} );
        $p{G} = Point->new( $pn, @p[ 2, 3 ] )->label( "G", "bottom" );
        $l{DEt}->remove;
        $l{DG} = Line->join( $p{D}, $p{G} );
        $l{EG} = Line->join( $p{E}, $p{G} );
        $l{ED} = Line->join( $p{E}, $p{D} );
        $t3->allgrey;
    };

    push @$steps, sub {
        $t1->explain(   "Using the same arguments as before, it can "
                      . "be seen that GEC is twice EDC" );
        $s{DEC} = Triangle->join( $p{D}, $p{E}, $p{C} )->fill($pale_pink);
        $l{DB}->grey;
        $l{EB}->grey;
        $a{EGEC} =
          Angle->new( $pn, $l{EG}, $l{EC} )->label( "   2\\{beta}", 70 );
        $a{DEDC} = Angle->new( $pn, $l{ED}, $l{DC} )->label("  \\{beta}");
        $a{DCEC} = Angle->new( $pn, $l{DC}, $l{EC} )->label("\\{beta}");
        $t3->allgrey;
        $t3->math("\\{angle}EDC = \\{angle}DCE = \\{beta}");
        $t3->math("\\{angle}GEC = 2\\{beta}");
    };

    push @$steps, sub {
        $t1->explain("It can also be seen that GEB is twice EDB");
        $s{DEC}->remove;
        $s{EDB} = Triangle->join( $p{E}, $p{D}, $p{B} )->fill($pale_yellow);
        $l{DC}->grey;
        $l{EC}->grey;
        $l{AF}->grey;
        $a{EGEC}->grey;
        $a{DEDC}->grey;
        $a{DCEC}->remove;
        $a{EGEB} =
          Angle->new( $pn, $l{EG}, $l{EB} )->label( "2\\{lambda}", 30 );
        $a{EDDB} = Angle->new( $pn, $l{ED}, $l{DB} )->label( "\\{lambda}", 60 );
        $a{DBEB} = Angle->new( $pn, $l{DB}, $l{EB} )->label( "\\{lambda}", 60 );
        $t3->allgrey;
        $t3->math("\\{angle}EDB = \\{angle}DBE = \\{lambda}");
        $t3->math("\\{angle}GEB = 2\\{lambda}");
    };

    push @$steps, sub {
        $t1->explain(
                   "Thus the angle CDB (\\{delta}) is the difference between "
                 . "CDE\\{nb}(\\{beta}) and BDE (\\{lambda}) and angle CEB "
                 . "(\\{epsilon}) is the "
                 . "difference between CEG (2\\{beta}) and BEG (2\\{lambda})" );
        $a{EGEC}->normal;
        $a{DEDC}->normal;
        $a{DBEB}->remove;
        $s{EDB}->remove;
        $l{ED}->remove;
        $l{EG}->remove;
        $l{EB}->normal;
        $l{EC}->normal;
        $l{DB}->normal;
        $l{DC}->normal;
        $a{delta} = Angle->new( $pn, $l{DB}, $l{DC} )->label( "\\{delta}", 90 );
        $a{epsilon} =
          Angle->new( $pn, $l{EB}, $l{EC} )->label( "\\{epsilon}", 20 );
        $t3->down;
        $t3->allgrey;
        $t3->math("\\{angle}CDB = \\{delta}");
        $t3->math("\\{delta} = \\{beta} - \\{lambda}");
        $t3->down;
        $t3->math("\\{angle}BEC = \\{epsilon}");
        $t3->math("\\{epsilon} = 2\\{beta} - 2\\{lambda}");
    };

    push @$steps, sub {
        $t1->explain("Thus, angle BEC (\\{epsilon}) is twice BDC (\\{delta})");
        $l{DG}->grey;
        $a{EGEB}->remove;
        $a{EDDB}->remove;
        $a{DBEB}->remove;
        $a{EGEC}->remove;
        $a{DEDC}->remove;
        $t3->down;
        $t3->math("\\{epsilon} = 2\\{delta}");

    };

    push @$steps, sub {
        $t3->erase;
        $l{AB}->normal;
        $l{AC}->normal;
        $a{delta}->remove;
        $a{epsilon}->remove;
        $a{A} = Angle->new( $pn, $l{AB}, $l{AC} )->label("\\{alpha}");
        $a{D} = Angle->new( $pn, $l{DB}, $l{DC} )->label("\\{delta}");
        $a{E} = Angle->new( $pn, $l{EB}, $l{EC} )->label("\\{epsilon}");
        $t3->y( $t5->y );
        $t3->down;
        $t3->math("\\{epsilon} = 2\\{alpha}");
        $t3->math("\\{epsilon} = 2\\{delta}");
    };

    return $steps;

}

