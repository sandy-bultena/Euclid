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
    "In equal circles equal straight lines cut off equal circumferences, "
  . "the greater equal to the greater and the less to the less.";

$pn->title( 28, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 200, 480 );
my $t2 = $pn->text_box( 400, 500 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 28 );
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
    my $tC = $pn->text_box( $c1[0] - 10, $c1[1] - $r1 + 30 );
    my $tF = $pn->text_box( $c2[0] - 10, $c2[1] - $r2 + 30 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("In other words");
        $t4->explain("Given two equal circles (as shown)");
        $t4->explain(
                "If line AB equals line DE, then the circumference AGB "
              . "equals DHE, and the circumference ACB equals DFE"
        );

        $c{C2t} = Circle->new( $pn, @c2, $c2[0] + $r2, $c2[1] )->grey;
        $c{C1t} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $tC->math("C");
        $tF->math("F");
        $p{A} = $c{C1t}->point( 180 + 40 )->label( "A ", "bottom" );
        $p{B} = $c{C1t}->point(-40)->label( " B", "bottom" );
        $p{D} = $c{C2t}->point( 180 + 40 )->label( "D ", "bottom" );
        $p{E} = $c{C2t}->point(-40)->label( " E", "bottom" );
        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{DE} = Line->join( $p{D}, $p{E} );
        $c{C2t}->remove;
        $c{C1t}->remove;
        $c{C1t} =
          Arc->new( $pn, $r1, $p{A}->coords, $p{B}->coords )->green()
          ->label( "G", "bottom" );
        $c{C2t} =
          Arc->new( $pn, $r2, $p{D}->coords, $p{E}->coords )->green()
          ->label( "H", "bottom" );
        $c{C1b} = Arc->newbig( $pn, $r1, $p{B}->coords, $p{A}->coords );
        $c{C2b} = Arc->newbig( $pn, $r2, $p{E}->coords, $p{D}->coords );
        $t3->math("\\{circle}C = \\{circle}F");
        $t3->math("AB = DE");
        $t3->allblue;
        $t3->math("\\{arc}AGB = \\{arc}DHE");
        $t3->math("\\{arc}ACB = \\{arc}DFE");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof");
        $t3->erase;
        $t3->math("\\{circle}C = \\{circle}F");
        $t3->math("AB = DE");
        $t3->allblue;
    };

    push @$steps, sub {
        $t4->explain(   "Take the centre (K,L) of the circles C and F and "
                      . "and draw the radii KA, KB, LD and LE" );
        $p{K} = Point->new( $pn, @c1 )->label( "K", "top" );
        $p{L} = Point->new( $pn, @c2 )->label( "L", "top" );
        $l{KA} = Line->join( $p{K}, $p{A} );
        $l{KB} = Line->join( $p{K}, $p{B} );
        $l{LD} = Line->join( $p{L}, $p{D} );
        $l{LE} = Line->join( $p{L}, $p{E} );
        $t3->allgrey;

    };

    push @$steps, sub {
        $t4->explain(
            "Since they are all radii of equal circles, then they are all equal"
        );
        $t3->blue(0);
        $t3->math("KA = KB = LD = LE");
    };

    push @$steps, sub {
        $t4->explain(   "Since each triangle has each line equal to "
                      . "the lines in the other "
                      . "triangle (side-side-side), then the triangles "
                      . "are equal in all respects\\{nb}(I.8)" );
        $s{ABK} = Triangle->join( $p{A}, $p{B}, $p{K} )->fill($sky_blue);
        $s{DEL} = Triangle->join( $p{D}, $p{E}, $p{L} )->fill($sky_blue);
        $t3->blue( [1] );
        $t3->grey(0);
        $t3->math("\\{triangle}ABK = \\{triangle}DEL");
    };

    push @$steps, sub {
        $t4->explain("Therefore the angles AKB and DLE are equal");
        $a{AKB} = Angle->new( $pn, $l{KA}, $l{KB} )->label("\\{alpha}");
        $a{DLE} = Angle->new( $pn, $l{LD}, $l{LE} )->label("\\{alpha}");
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{angle}AKB = \\{angle}DLE");
    };

    push @$steps, sub {
        $s{ABK}->remove;
        $s{DEL}->remove;
        $t4->explain(   "But for equal circles, equal angles stand "
                      . "on equal circumferences\\{nb}(III.26)" );
        $c{C1b}->grey;
        $c{C2b}->grey;
        $l{AB}->grey;
        $l{DE}->grey;
        $t3->allgrey;
        $t3->blue("0");
        $t3->black(-1);
        $t3->math("\\{arc}AGB = \\{arc}DHE");
    };

    push @$steps, sub {
        $t4->explain( "Since the circles are equal, the remainder of the "
             . "circumference after AGB and DHE are removed, will also be equal"
        );
        $c{C1b}->normal;
        $c{C2b}->normal;
        $l{KA}->grey;
        $l{KB}->grey;
        $l{LD}->grey;
        $l{LE}->grey;
        $a{AKB}->grey;
        $a{DLE}->grey;
        $t3->allgrey;
        $t3->blue(0);
        $t3->black(-1);
        $t3->math("\\{circle}C - \\{arc}AGB = \\{circle}F - \\{arc}DHE");
        $t3->math("\\{arc}ACB = \\{arc}DFE");
    };

    push @$steps, sub {
        $l{AB}->normal;
        $l{DE}->normal;
        $t3->allgrey;
        $t3->blue( [ 0, 1 ] );
        $t3->black( [ -1, -3 ] );
    };

    return $steps;

}

