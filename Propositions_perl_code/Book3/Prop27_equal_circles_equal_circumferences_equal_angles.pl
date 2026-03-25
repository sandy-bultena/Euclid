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
    "In equal circles angles standing on equal circumferences are equal "
  . "to one another, whether they stand at the centres or "
  . "at the circumferences.";

$pn->title( 27, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 200, 480 );
my $t2 = $pn->text_box( 400, 500 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 27 );
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
              "If the circumference BC equals the circumference BF,\\{nb}then");
        $t4->explain(
                  "\\{alpha} equals \\{delta} and \\{gamma} equals \\{lambda}");

        $c{C2} = Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] );
        $c{C1} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
        $p{G} = Point->new( $pn, @c1 )->label( "G ", "top" );
        $p{H} = Point->new( $pn, @c2 )->label( "H",  "top" );
        $p{A} = $c{C1}->point(120)->label( "A ", "top" );
        $p{B} = $c{C1}->point( 180 + 40 )->label( "B ", "bottom" );
        $p{C} = $c{C1}->point(-40)->label( " C", "bottom" );
        $p{D} = $c{C2}->point(100)->label( "D ", "top" );
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
        $a{BGC} = Angle->new( $pn, $l{GB}, $l{GC} )->label( "\\{gamma}", 20 );
        $a{EDF} = Angle->new( $pn, $l{DE}, $l{DF} )->label("\\{delta}");
        $a{EHF} = Angle->new( $pn, $l{HE}, $l{HF} )->label( "\\{lambda}", 20 );
        $a{K} = Arc->new( $pn, $r1, $p{B}->coords, $p{C}->coords )->green;
        $a{L} = Arc->new( $pn, $r1, $p{E}->coords, $p{F}->coords )->green;
        $t3->math("\\{circle}ABC = \\{circle}EDF");
        $t3->math("\\{arc}BC = \\{arc}EF");
        $t3->allblue;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof by Contradiction");
        $t3->down;
    };

    push @$steps, sub {
        $t4->explain("Assume that \\{gamma} is larger than \\{lambda}");
        $t2->math("\\{gamma} > \\{lambda}");
        $t2->allblue;
    };

    push @$steps, sub {
        $t4->explain(
                   "Construct angle BGK such that it equals \\{lambda} (I.23)");
        $p{K} = $c{C1}->point(-60)->label( " K", "bottom" );
        $l{GK} = Line->join( $p{G}, $p{K} );
        $a{BGK} = Angle->new( $pn, $l{GB}, $l{GK} )->label( "\\{lambda}", 60 );
        $t2->math("\\{arc}BC > \\{arc}BK");
    };

    push @$steps, sub {
        $t4->explain(
            "If angle BGK is equal to EHF, then the circumferences subtended "
              . "by these angles are also equal (III.26), in other words BK equals EF"
        );
        $t2->math("\\{arc}BK = \\{arc}EF");
    };

    push @$steps, sub {
        $t4->explain(
               "But EF equals BC, therefore BK equals BC, which is impossible");
        $t2->math("\\{arc}BK = \\{arc}BC ");
    };

    push @$steps, sub {
        $t2->allgrey;
        $t2->red( [ -1, -3 ] );
    };

    push @$steps, sub {
        $t4->explain("Therefore the original assumption is wrong");
        $t2->allgrey;
        $t2->red(0);
    };

    push @$steps, sub {
        $t4->down;
        $t4->explain("Therefore the angles BGC equals EHF");
        $l{GK}->grey;
        $a{BGK}->remove;
        $t2->allgrey;
        $t2->down;
        $t2->math("\\{therefore} \\{gamma} = \\{lambda}");
    };

    push @$steps, sub {
        $t4->explain( "The angle at the circumference is half "
            . "the angle at the centre of a circle if the base is the same (III.20) "
            . "therefore \\{alpha} is half \\{gamma} and \\{delta} is half \\{lambda}"
        );
        $t2->math("\\{alpha} = \\{half} \\{gamma}");
        $t2->math("\\{delta} = \\{half} \\{lambda}");
    };

    push @$steps, sub {
        $t4->explain(   "Then since \\{gamma} is equal to \\{lambda}, "
                      . "\\{alpha} is equal to \\{delta}" );
        $t2->math("\\{alpha} = \\{delta}");
    };

    return $steps;

}

