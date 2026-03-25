#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If from a parallelogram there be taken away a parallelogram similar and ".
    "similarly situated to the whole and having a common angle with it, it ".
    "is about the same diameter with the whole";

$pn->title( 26, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 140, 660 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 26 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();
my ( %p, %c, %s, %t, %l, %a );

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $off  = 40;
    my $yoff = 30;
    my $k = 1/2.6;
    my $yh   = 180;
    my $yb   = 380;
    my $ym   = $yh - $k*($yh-$yb);
    my $xs   = 150;
    my $dx1  = -40;
    my $dx2  = 320;
    my $dx3  = 90;

    my @A = ( $xs, $yh );
    my @B = ( $xs+$dx1, $yb );
    my @C = ( $xs + $dx2 + $dx1, $yb );
    my @D = ( $xs + $dx2, $yh );
    my @E = ($xs + $dx1*$k,$ym);
    my @F = ($xs + $k*($dx2+$dx1),$ym);
    my @G = ($xs + $k*$dx2,$yh);

    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a parallelogram ABCD");
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $t{1} = Polygon->join(4,$p{A},$p{B},$p{C},$p{D} );
        ( $l{AB}, $l{BC}, $l{CD}, $l{AD} ) = $t{1}->lines;
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And a smaller similar parallelogram AGFE, sharing a common angle DAB, ".
        "and the lines AG and AD being collinear");
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "right" );
        $p{E} = Point->new( $pn, @E )->label( "E", "left" );
        $t{2} = Polygon->join(4,$p{A},$p{G},$p{F},$p{E} );
        ( $l{AG}, $l{FG}, $l{EF}, $l{AE} ) = $t{2}->lines;
        $t3->math("AGFE ~ ABCD")->blue;;
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The diameters of these two parallelograms will be collinear");
        $l{AC}=Line->join($p{A},$p{C});
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof by Contradiction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that the diameter of ABCD is the 'line' AHC");
        $l{GH} = $l{FG}->clone->extend(40)->remove;
        $p{H}=Point->new($pn,$l{GH}->end)->label("H","bottom");
        $l{AH} = Line->join($p{A},$p{H});
        $l{CH} = Line->join($p{H},$p{C});        
   };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Extend GF to the 'diameter' of ABCD to point H, ".
        "and draw a line from H to the line AB, parallel to AG (I.31)");
        $l{GH}->draw;
        $l{HKx} = $l{AD}->parallel($p{H});
        my @K = $l{HKx}->intersect($l{AB});
        $p{K} = Point->new($pn,@K)->label("K","left");
        $l{HK} = Line->join($p{K},$p{H});
        $l{HKx}->remove;
   };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{AGHK} = Polygon->join(4,$p{A},$p{G},$p{H},$p{K});
        $l{AC}->grey;
        $t1->explain("Since AGHK and ABCD share the same diameter, then DA ".
        "is to AB as GA is to AK (VI.24)");
        $t3->math("DA:AB = GA:AK");
        $l{EF}->grey;
   };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But AEFG is similar to ABCD, so by definition its sides are ".
        "also proportional, as DA is to AB, so is GA to AE");
        $t3->math("DA:AB = GA:AE");
        $l{AH}->grey;
        $l{CH}->grey;
        $t{AGHK}->grey;
        $l{HK}->grey;
        $l{GH}->grey;
        $l{EF}->normal;
   };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore GA is to AK as GA is to AE (VI.11)");
        normal_shit();        
        $t3->math("GA:AK = GA:AE");    
   };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore AE equals AK (VI.9), but AE is smaller than AK");
        $t3->down;
        $t3->math("AE = AK");
   };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Hence a contradiction, and therefore ABCD must "."be about the same diameter as AEFG");
        $l{HK}->grey;
        $l{GH}->grey;
        $t{AGHK}->grey;
        $l{AH}->grey;
        $l{HK}->grey;
        $l{CH}->grey;
    };

    return $steps;

}

sub normal_shit {
    foreach my $type ( \%l, \%t, \%a ) {
        foreach my $o ( keys %$type ) {
            $type->{$o}->normal;
        }
    }
}

