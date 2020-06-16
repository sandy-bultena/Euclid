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
my $title = "To two given straight lines to find a mean proportional.";

$pn->title( 13, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 13 );
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
    my (%p,%c,%s,%t,%l,%a);
    my $off = 30;
    my $yh = 250;
    my $yb = 350;
    my $dx1 = 200;
    my $xs = 100;
    
    my @A = ($xs,$yb,$xs+$dx1,$yb);
    my @B = ($xs+$dx1+$off,$yb,$xs+$dx1+$off+.70*$dx1,$yb);
    my @B2 = ($xs+$dx1,$yb,$xs+$dx1+.70*$dx1,$yb);
    my @C = @B2[2,3];
    my @D = ($xs,$yh,$xs+.85*$dx1,$yh);
    
    my $colour1 = "#abcdef";
    my $colour2 = "#cdefab";
    my $colour3 = "#efabcd";
    my $colour4 = "#abefcd";

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given two lines A and B, find a third D, such that the ratio "
        ."of A to D is equal to the ratio D to B");
        
        $p{A} = Point->new($pn,@A[0,1])->label("A","bottom");
        $p{B} = Point->new($pn,@B[0,1])->label("B","bottom");
        $p{D} = Point->new($pn,@D[0,1])->label("D","bottom");
        $l{A} = Line->new($pn,@A);
        $l{B} = Line->new($pn,@B);
        $l{D} = Line->new($pn,@D);
        
        $t3->math("A:D = D:B");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Construction");
        $t3->erase();
        $p{D}->remove;
        $l{D}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Position the two lines so that they form a straight line");
        $p{B}->remove;
        $l{B}->remove;
        $p{B} = Point->new($pn,@B2[0,1])->label("B","bottom");
        $p{C} = Point->new($pn,@C)->label("C","bottom");
        $l{B} = Line->join($p{B},$p{C});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a semi-circle on line AC");
        $a{D} = Arc->new($pn,($l{A}->length+$l{B}->length)/2,@C, @A[0,1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a line perpendicular to AC, from point B, intersecting ".
        "the semi-circle at point D");
        $l{BDx} = $l{A}->perpendicular($p{B},1,"negative")->dash;
        my @p = $a{D}->intersect($l{BDx});
        $p{D} = Point->new($pn,@p)->label("D","top");
        $l{BD} = Line->join($p{B},$p{D});
        $l{BDx}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("BD is the mean proportional to AB, BC");
        $t3->math("AB:BD = BD:BC");
    };

    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Join points AD, and CD");
        $l{AD} = Line->join($p{A},$p{D});
        $l{CD} = Line->join($p{D},$p{C});
    };

    push @$steps, sub {
        $t1->explain("The angle ADC is a right angle (III.31)");
        $a{ADC} = Angle->new($pn,$l{AD},$l{CD});
   };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since DB has been drawn from a right angle triangle ".
        "to its base, DB is the mean proportional to AB, BC (VI.8.Por)");
    };
    

    return $steps;

}

