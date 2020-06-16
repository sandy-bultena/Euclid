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
    "To cut a given straight line so that the rectangle contained "
  . "by the whole and one "
  . "of the segments is equal to the square on the remaining segment.";

$pn->title( 11, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 520, 200 );
my $t6 = $pn->text_box( 500, 280 );
my $t3 = $pn->text_box( 160, 580 );

my $steps;
push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 11 );
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

    my @A = ( 160, 300 );
    my @B = ( 380, 300 );
    my @H = ( .75 * ( $B[0] - $A[0] ) + $A[0], $A[1] - 10 );
    my @D;
    my @C;
    my @E;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "Find the point H on the line AB such that the "
               . "rectangle formed by AB and BH is equal to the square on AH" );
        $p{A} = Point->new( $pn, @A )->label(qw(A left));
        $p{B} = Point->new( $pn, @B )->label(qw(B topright));
        $l{AB} = Line->new( $pn, @A, @B );
        $p{Ht} = Point->new( $pn, @H )->label( " H?", "top" );
        $t2->math("AB\\{dot}BH = AH\\{squared}");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $p{Ht}->remove;
        $t4->y( $t1->y );
        $t4->down;
        $t4->title("Construction");

        $t4->explain(   "Draw a square ABCD on AB (I.46), and bisect AC (I.10) "
                      . "at point\\{nb}E" );
        $s{AB} = Square->new( $pn, $p{B}->coords, $p{A}->coords );
        $s{AB}->set_points(qw(D bottom B topright A left C bottom));
        $l{AC} = $s{AB}->l(3);
        $l{CD} = $s{AB}->l(4);
        $p{C}  = $s{AB}->p(4);
        $p{D}  = $s{AB}->p(1);

        $p{E} = $l{AC}->bisect;
        $p{E}->label(qw(E left));
        @E = $p{E}->coords;
        $t6->math("AE = EC");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
            "Let EB be joined, and extend CA to F such that EF equals\\{nb}AB");

        $l{EB} = Line->new( $pn, @E, @B );
        $l{ACt} = $l{AC}->clone->grey;
        $l{ACt}->prepend(200);
        $c{E} = Circle->new( $pn, @E, @B )->grey;
        my @c = $c{E}->intersect( $l{ACt} );
        $p{F} = Point->new( $pn, @c )->label( "F", "topleft" );
        $l{AF} = Line->new( $pn, @A, $p{F}->coords );

        $t6->math("EF = EB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{ACt}->remove;
        $c{E}->remove;
        $t4->explain(
               "Draw a square FAGH on FA, and extend GH to line CD at point K");

        $s{FA} = Square->new( $pn, $p{F}->coords, $p{A}->coords );
        $s{FA}->set_points(qw(G topright F topleft A left H topright));
        $l{GH} = $s{FA}->l(4);
        $p{H}  = $s{FA}->p(4);
        $p{G}  = $s{FA}->p(1);

        $l{GKt} = $l{GH}->clone->grey;
        $l{GKt}->prepend(400);
        my @c = $l{GKt}->intersect( $l{CD} );
        $p{K} = Point->new( $pn, @c )->label(qw(K bottom));
        $l{HK} = Line->join( $p{H}, $p{K} );

        $t6->math("FA = AH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{GKt}->remove;
        $t4->explain( "The point H has been defined such that FH equals HD " );
        $t2->y( $t6->y );
        $t2->math("AB\\{dot}BH = AH\\{dot}AH");
        $s{HD} =
          Polygon->new( $pn, 4, $p{H}->coords, $p{K}->coords, $p{D}->coords,
                        $p{B}->coords, -1 );
        $s{FA}->fill($pale_pink);
        $s{HD}->fill($pale_yellow);

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->y( $t1->y );
        $t4->down;

        $t4->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t6->down;
        $s{FA}->fill;
        $s{HD}->fill;
        $t4->explain(
                "From proposition 6 (II.6), if we have a bisected line, "
              . "and an addition to that line, "
              . "then the extended line CF times the extension AF plus "
              . "the square on AE is equal to the square on EF"
        );

        # grey everything out for now, 
        
        foreach my $line ( keys %l ) { $l{$line}->grey }
        foreach my $poly ( keys %s ) { $s{$poly}->grey }
        $l{FCt} = Line->join($p{C},$p{F});        
        $p{C}->normal;
        
        # relationship (math)
        $t6->allgrey;
        $t6->math("CF\\{dot}AF + AE\\{squared} = EF\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        # remove all temporary lines and rectangles
        foreach my $line ( keys %l ) { $l{$line}->remove if $line =~ /t$/ }
        foreach my $poly ( keys %s ) { $s{$poly}->remove if $poly =~ /t$/ }

        # normalize the original drawing
        foreach my $line ( keys %l ) { $l{$line}->normal if $line !~ /t$/ }
        foreach my $poly ( keys %s ) { $s{$poly}->normal if $poly !~ /t$/ }

        $t4->explain("But EB equals EF");
        
        $t6->allgrey;
        $t6->black([-1,1]);
        $t6->math("CF\\{dot}AF + AE\\{squared} = EB\\{squared}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t4->explain(
                   "Triangle AEB is right angled, thus the square on AB plus "
                     . "the square on AE equals the square on EB\\{nb}(I.47)" );
        $s{AEB} =
          Triangle->new( $pn, $p{A}->coords, $p{E}->coords, $p{B}->coords, -1 );
        $s{AEB}->fill($sky_blue);
        $t6->allgrey;
        $t6->math("AB\\{squared}   + AE\\{squared} = EB\\{squared}");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t4->explain( "By comparing the equalities, we see that the square ".
        "of AB is equal to the "
            . "rectangle formed by CF and AF" );
        $s{AEB}->remove;
        $t6->allgrey;
        $t6->black([-1,-2]);
        $t6->math("AB\\{squared} = CF\\{dot}AF");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t4->explain("The square of AB is the the rectangle AD");
        $s{AB}->fill($pale_yellow);
        $t6->allgrey;
        $t6->math("AB\\{squared} = \\{square}AD"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t4->explain(
               "The rectangle CF,AF is the rectangle FK, since AF equal\\{nb}AH");
        $s{AK} =
          Polygon->new( $pn, 4, $p{A}->coords, $p{C}->coords, $p{K}->coords,
                        $p{H}->coords, -1 );
        $s{FA}->fill($pale_pink);
        $s{AK}->fill( $pale_pink );
        $s{AB}->fill;
        $t6->allgrey;
        $t2->allgrey;
        $t2->black([-2]);
        $t6->allgrey;
        $t6->math("CF\\{dot}AF = \\{square}FK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->allgrey;
        $s{FA}->fill($pale_pink);
        $s{AB}->fill($pale_yellow);
        $s{AK}->fillover( $s{AB}, Colour->add($pale_pink,$pale_yellow) );
        $t6->allgrey;
        $t6->black([-1,-2,-3]);
        $t6->math("\\{square}AD = \\{square}FK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t4->explain(
               "Subtract AK from both sides of the equality, and FH equals\\{nb}HD");
        $s{HD}->fill($pale_yellow);
        $s{AB}->fill;
        $s{AK}->remove;
        $t6->allgrey;
        $t6->black(-1);
        $t6->math("\\{square}FH = \\{square}HD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t4->explain(
                "But FH is formed as the square on AH, and HD is the rectangle "
                  . "formed by AB,BH since AB equals BD" );
        $t4->explain("Thus AH squared is equal to AB times BH");
        $t6->allgrey;
        $t6->black(-1);
        $t6->math("AH\\{dot}AH = AB\\{dot}BH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t6->allgrey;
        $t6->black(-1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->y($t1->y);
        $t4->down;
        $t4->title("Golden Ratio");
        $t4->explain("The golden ratio is defined as");
        $t4->math("   a/b = (a+b)/a, where a>b");
        $t4->down;
        $t4->explain(
            "Since AB is equal to AH + BH, this proposition finds H such that");
        $t4->math("    AH\\{dot}AH = (AH + BH)\\{dot}BH");
        $t4->down;
        $t4->explain("or, the golden ratio...");
        $t4->math("   AH/BH = (AH + BH)/AH");
    };

    return $steps;

}

