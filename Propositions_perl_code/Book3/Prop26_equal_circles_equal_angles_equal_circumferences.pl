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
my $title = "In equal circles equal angles stand on equal circumferences, "
  . "whether they stand at the centres or at the circumferences.";

$pn->title( 26, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 200, 500 );
my $t5 = $pn->text_box( 200, 460 );
my $t2 = $pn->text_box( 60,  180 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 26 );
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

    my @c1 = ( 180, 280 );
    my $r1 = 140;
    my @c2 = ( 500, 280 );
    my $r2 = 140;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("In other words");
        $t4->explain("Given two equal circles (as shown)");
        $t4->explain(
            "If \\{alpha} equals \\{delta} OR \\{gamma} equals \\{lambda}, then"
        );
        $t4->explain("the circumference K equals the circumference L");

        $c{C2} =
          Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] )->label( "L", "bottom" );
        $c{C1} =
          Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->label( "K", "bottom" );
        $p{G} = Point->new( $pn, @c1 )->label( "G ", "top" );
        $p{H} = Point->new( $pn, @c2 )->label( "H",  "top" );
        $p{A} = $c{C1}->point(110)->label( "A ", "top" );
        $p{B} = $c{C1}->point( 180 + 40 )->label( "B ", "bottom" );
        $p{C} = $c{C1}->point(-40)->label( " C", "bottom" );
        $p{D} = $c{C2}->point(30)->label( " D", "top" );
        $p{E} = $c{C2}->point( 180 + 40 )->label( "E ", "bottom" );
        $p{F} = $c{C2}->point(-40)->label( " F", "bottom" );
        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{GB} = Line->join( $p{G}, $p{B} );
        $l{GC} = Line->join( $p{G}, $p{C} );
        $l{DE} = Line->join( $p{D}, $p{E} );
        $l{DF} = Line->join( $p{D}, $p{F} );
        $l{HE} = Line->join( $p{H}, $p{E} );
        $l{HF} = Line->join( $p{H}, $p{F} );
        $a{BAC} = Angle->new( $pn, $l{AB}, $l{AC} )->label("\\{alpha}");
        $a{BGC} = Angle->new( $pn, $l{GB}, $l{GC} )->label("\\{gamma}");
        $a{EDF} = Angle->new( $pn, $l{DE}, $l{DF} )->label("\\{delta}");
        $a{EHF} = Angle->new( $pn, $l{HE}, $l{HF} )->label("\\{lambda}");
        $a{K} = Arc->new( $pn, $r1, $p{B}->coords, $p{C}->coords )->green;
        $a{L} = Arc->new( $pn, $r1, $p{E}->coords, $p{F}->coords )->green;
        $t5->math("\\{circle}ABC = \\{circle}EDF");
        $t3->y($t5->y);
        $t5->allblue;
        $t3->math("\\{alpha} = \\{delta}");
        $t3->math("\\{gamma} = \\{lambda}");
        $t3->allblue;
        $t3->math("\\{arc}K = \\{arc}L");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof");
        $t3->erase;
        $t3->y($t5->y);
        $t5->allblue;
        $t3->math("\\{alpha} = \\{delta}");
        $t3->math("\\{gamma} = \\{lambda}");
        $t3->allblue;
    };

    push @$steps, sub {
        $t4->explain("Draw the lines BC and EF");
        $l{BC} = Line->join( $p{B}, $p{C} );
        $l{EF} = Line->join( $p{E}, $p{F} );
    };

    push @$steps, sub {
        $t4->explain( "Since the two circles are equal, the radii are equal, "
              . "thus BG and GC are equal, and they are also equal to EH and HF"
        );
        $a{BAC}->grey;
        $a{EDF}->grey;
        $l{AB}->grey;
        $l{AC}->grey;
        $l{DE}->grey;
        $l{DF}->grey;
        $s{BGC} = Triangle->join( $p{B}, $p{G}, $p{C} )->fill($sky_blue);
        $s{EHF} = Triangle->join( $p{E}, $p{H}, $p{F} )->fill($sky_blue);
        $t3->allgrey;
        $t3->math("BG = GC = EH = HF");
    };

    push @$steps, sub {
        $t4->explain(
               "Since the angles at G and H are also equal, the two triangles, "
                 . "having side-angle-side equal, are equal in all "
                 . "respects\\{nb}(I.4), so BC equals EF" );
        $t3->blue( [ 0, 1 ] );
        $t3->math("BC = EF");
    };

    push @$steps, sub {
        $s{BGC}->remove;
        $s{EHF}->remove;
        $l{AB}->normal;
        $l{AC}->normal;
        $l{DE}->normal;
        $l{DF}->normal;
        $l{GB}->grey;
        $l{GC}->grey;
        $l{HE}->grey;
        $l{HF}->grey;
        $a{BAC}->normal;
        $a{BGC}->grey;
        $a{EDF}->normal;
        $a{EHF}->grey;
        $t4->explain(   "The segments BAC and EDF are similar (since "
                      . "\\{alpha}\\{nb}equals\\{nb}\\{delta}) " );
        $t3->allgrey;
        $t3->blue(0);
    };

    push @$steps, sub {
        $t4->explain( "Since similar circle segments on equal "
                 . "straight lines (BC and EF) are "
                 . "equal\\{nb}(III.24), the segments BAC and EDF are equal." );
        $t3->math("\\{arc}BAC = \\{arc}EDF");
    };

    push @$steps, sub {
        $c{C1}->grey;
        $t3->allgrey;
        $t3->math("\\{circle}ABC - \\{arc}BAC = \\{arc}BC");
        $c{C2}->grey;
        $t3->math("\\{circle}EDF - \\{arc}EDF = \\{arc}EF");
    };
    push @$steps, sub {
        $a{BAC}->grey;
        $a{EDF}->grey;
        $l{AB}->grey;
        $l{AC}->grey;
        $l{DE}->grey;
        $l{DF}->grey;
        $t4->explain(   "The circles are equal (by definition), and since "
                      . "the circle segments are equal, "
                      . "the difference between the two (the "
                      . "circumferences BC and EF) are also equal" );
        $t3->black(4);
        $t3->math("\\{arc}BC = \\{arc}EF");
        
    };
    push @$steps, sub {
        $l{AC}->normal;
        $l{AB}->normal;
        $l{DE}->normal;
        $l{DF}->normal;
        $l{GB}->normal;
        $l{GC}->normal;
        $l{HE}->normal;
        $l{HF}->normal;
        $a{BAC}->normal;# = Angle->new( $pn, $l{AB}, $l{AC} )->label("\\{alpha}");
        $a{BGC}->normal;# = Angle->new( $pn, $l{GB}, $l{GC} )->label("\\{gamma}");
        $a{EDF}->normal;# = Angle->new( $pn, $l{DE}, $l{DF} )->label("\\{delta}");
        $a{EHF}->normal;# = Angle->new( $pn, $l{HE}, $l{HF} )->label("\\{lambda}");
        $l{BC}->grey;
        $l{EF}->grey;
        $t3->allgrey;
        $t3->blue(0);
        $t3->black(-1);
        $c{C1}->normal;
        $c{C2}->normal;
        $a{K} = Arc->new( $pn, $r1, $p{B}->coords, $p{C}->coords )->green;
        $a{L} = Arc->new( $pn, $r1, $p{E}->coords, $p{F}->coords )->green;
    };


    return $steps;

}

