#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 10;

# ============================================================================
# Definitions
# ============================================================================
my $title = "In a given circle to inscribe a fifteen angled figure which shall ".
"be both equilateral and equiangular.";

$pn->title( 16, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 440, 200 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 16 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();
my ( %l, %p, %c, %s, %a );

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $r = 140;
    my @c = ( 200, 300 );
    my @a = ( $c[0]+$r+60, $c[1] );
    my @b = ( $c[0]+$r+60+2*$r*cos(72/180*3.14), $c[1]+$r-2*$r*sin(72/180*3.14) );
    my @info;
        my @ps;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a circle, draw an fifteen sided polygon with equal sides ".
        "and equal angles on the inside of the circle.");

        $c{a} = Circle->new($pn,@c,$c[0]+$r,$c[1])->grey;
        
        foreach my $i (1..15) {
            $p{$i} = Point->new($pn,$c{a}->coords(-90 - ($i-1)*360/15));
            push @ps,$p{$i};
        }
        $s{a} = Polygon->join(15,@ps);
        
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $s{a}->remove;
        foreach my $p (@ps) {
            $p->remove;
        }
        $c{a}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw an equilateral triangle (I.1) and copy an equiangular "
        ."version into the circle (IV.2)");
        $s{et} = EquilateralTriangle->build($pn,@a,$a[0]+$r,$a[1],5);
        $s{e} = $s{et}->copy_to_circle($c{a},5)->normal;
        $s{et}->remove;
        $p{A}=$s{e}->p(1)->label("A","top");
        $p{C}=$s{e}->p(2)->label("C","left");
        $p{D}=$s{e}->p(3)->label("D","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Inscribe a pentagon in the circle (IV.11)");
        $s{pent} = RegularPolygon->hexagon($pn,$c{a}->centre,$c{a}->radius,5);
        $p{B} = $s{pent}->p(2)->label("B","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Bisect the arc BC at point E");
        $c{a}->grey;
        $s{e}->grey;
        $s{pent}->grey;
        $p{B}->normal;
        $p{C}->normal;
        $c{BC} = Arc->join($c{a}->radius,$p{B},$p{C});
        $p{E} = $c{BC}->bisect->label("E","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Join the line CE, and copy this line into the circle, "
        ."always contiguous to the previous line.");
        
        $l{CE} = Line->join($p{C},$p{E});
        
        my @start = $l{CE}->end;
        my @not = $l{CE}->start;
        foreach my $i (1..14) {
            my $c = Circle->new($pn,@start,$start[0]+$l{CE}->length,$start[1])->grey;
            my @p = $c->intersect($c{a});
            
            my @new;
            if (abs($p[2] - $not[0]) < 2 && abs($p[3] - $not[1]) < 2) {
                @new = @p[0,1];
            }    
            else {
                @new = @p[2,3];
            }
            $l{$i} = Line->new($pn,@start,@new);
            @start = $l{$i}->end;
            @not = $l{$i}->start;
            $c->remove;
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The resulting figure is a 15 sided equiangular, ".
        "equilateral polygon");
        
    };




    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        #$t1->erase;
        $t1->title("Proof");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Circumference AC is one third of the circle, so it will "
        ."contain five segments of a fifteen sided equilateral figure");
        greyall();
        $p{E}->grey;
        $c{BC}->grey;
        $s{e}->normal;
        $p{A}->normal;
        $p{B}->normal;
        $c{AC} = Arc->join($c{a}->radius,$p{A},$p{C})->fill($sky_blue);
        $t3->math("AC = 1/3 x 15 = 5/15");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Circumference AB is one fifth of the circle, so it will "
        ."contain three segments of a fifteen sided equilateral figure");
         $c{AC}->fill();
        $s{e}->grey;
        $p{A}->normal;
        $s{pent}->normal;
        $c{AC}->grey;
        $c{AB} = Arc->join($c{a}->radius,$p{A},$p{B})->fill($lime_green);
        $t3->math("AB = 1/5 x 15 = 3/15");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, the remainder of AB substracted from ".
        "AC (BC) will contain two segments of a fifteen sided equilateral figure"); 
        $c{AB}->fill();
         $c{BC} = Arc->join($c{a}->radius,$p{B},$p{C})->fill($pink);
         $l{BC}=Line->join($p{C},$p{B});
        $s{pent}->grey;
        $p{A}->normal;
        $p{B}->normal;
        $p{C}->normal;
        $c{AB}->grey;
        $c{BC}->normal;
        $t3->down;
        $t3->math("BC = AC - BC = 2/15");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, since E bisects BC, EC is one-fifteenth ".
        "of a circle");
        $p{E}->normal;
        $t3->math("EC = 1/15");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Using the same arguments as for pentagons and "
        ."hexagons, the points used to divide a circle into equal ".
        "segments will create an equiangular, equilateral polygon");
        $c{BC}->fill;
        $l{BC}->remove;
        $l{CE}->normal;
        foreach my $i (1..14) {
            $l{$i}->normal;
        }
    };

    return $steps;

}

sub greyall {
    foreach my $o ( keys %l ) {
        $l{$o}->grey;
    }
    foreach my $o ( keys %a ) {
        $a{$o}->grey;
    }
    foreach my $o ( keys %s ) {
        $s{$o}->grey;
    }
    foreach my $o ( keys %p ) {
#        $p{$o}->grey;
    }
}

