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
my $title = "To a given straight line to apply a parallelogram equal ".
"to a given rectilineal figure and exceeding by a parallelogrammic ".
"figure similar to a given one";

$pn->title( 29, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 500 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 29 );
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
    my $yh   = 180;
    my $yb   = 380;
    my $xs   = 300;
    my $dx1  = 300; # length of AB
    my $dx2  = -40;
    my $off  = 60;
 
    # straight line
    my @A = ( $xs, $yb );
    my @B = ( $xs+$dx1, $yb );
    my @E = ( $xs + $dx1/2, $yb ); # midpoint of AB

    # polygon
    my @C = ($xs-1.5*$off, $yb-20,
            $xs-$off,  $yb-90,
            $xs-3*$off, $yb-120,
            $xs-4*$off, $yb-50,
            $xs-3.1*$off, $yb+30);
    
    # parallelogram
    my $dx3 = 60;       # length of base
    my $xds = $A[0];    # x bottom corner
    my $y3 = 80;        # height
    my $dx4 = 20;       # offset

    my @D = ($C[4]+20,$C[5]-10,
            $C[4]+20+$dx3, $C[5]-10,
            $C[4]+20+$dx3+$dx4,  $C[5]-10-$y3,
            $C[4]+20+$dx4,  $C[5]-10-$y3);

    # points to define "new" similar polygons on AE
    my @A1 = ( $xs + $dx4*$dx1/$dx3/2.0, $yb - $y3*$dx1/2.0/$dx3); # top left
    my @D1 = ( $A1[0]+$dx1/2, $yb - $y3*$dx1/2.0/$dx3); # top middle
    my @G = ($A1[0]+$dx1, $yb - $y3*$dx1/2.0/$dx3); # top right
 
    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;
    
    my $blue ;
    my $blank;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a straight line AB and");
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "topleft" );
        $l{AB} = Line->join($p{A},$p{B});
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let C be a rectilineal figure and D be a parallelogram");
        $l{AB} = Line->join($p{A},$p{B});
        $t{C} = Polygon->new($pn,5,@C)->fill($colour2)->label("C");
        $t{D} = Polygon->new($pn,4,@D)->label("D");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("We want to draw a parallelogram on AB such that ... ");
        $t1->point("If a parallelogram similar to parallelogram D is added, then... ");
        $t1->point("the sum is equal in area to C");

        $p{noname} = Point->new($pn,288,428);
        $p{O} = Point->new($pn,624,428);
        $p{P} = Point->new($pn,636,380);
        $p{Q} = Point->new($pn,588,428);
        
        $t{1}=Polygon->join(4,$p{A},$p{P},$p{O},$p{noname})->fill($colour2);
        $t{2}=Polygon->join(4,$p{B},$p{P},$p{O},$p{Q});
    };
    
    
    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{O}->remove;
        $p{noname}->remove;
        $p{P}->remove;
        $p{Q}->remove;
        $t{1}->remove;
        $t{2}->remove;
        $t1->erase;
        $t1->down;
        $t1->title("Construction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Bisect the line AB at point E");
        $p{E}=Point->new($pn,@E)->label("E","topleft");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Create a parallelogram similar to D on line EB (VI.18)");
        $p{L} = Point->new($pn,@G)->label("L","top");
        $p{F} = Point->new($pn,@D1)->label("F","top");
        $blank = Polygon->new($pn,4,@E,@D1,@G,@B);
        $t3->math("FB ~ D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let GH be constructed such that it is equal to the ".
        "the area of FB plus the area of C, and is similar to D (VI.25)");
        if (! $ENV{EUCLID_AUTO} ) {
            $pn->force_update;
        }
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->point("Copy the rectilineal figure C to a rectangle");
        if (! $ENV{EUCLID_AUTO} ) {
            $pn->force_update;
        }
        $t{x1} = $t{C}->copy_to_rectangle(Point->new($pn,@E))->fill($colour2);

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->point("Construct another rectangle on the top of the previous rectangle such that it is equal in area "
        . "to the parallelogram FB (I.44)" );
        if (! $ENV{EUCLID_AUTO} ) {
            $pn->force_update;
        }
        $l{xtop} = Line->join($t{x1}->points->[2],$t{x1}->points->[3]);
        $a{right} = Angle->new($pn,new VirtualLine(10,10,100,10),new VirtualLine(10,10,10,100));
        $a{right}->remove;
        $t{x2} = $blank->copy_to_parallelogram_on_line($l{xtop},$a{right});
        $t{x2}->fill($colour3);
        $l{xtop}->remove;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->point("Copy the sum of these two rectangles to a polygon similar to D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{xr} = Polygon->join(4,$t{x1}->p(1),$t{x1}->p(2),$t{x2}->p(0),$t{x2}->p(3));
        $t{xr}->fill($colour4);
        $t{x1}->grey;
        $t{x2}->grey;
        if (! $ENV{EUCLID_AUTO} ) {
            $pn->force_update;
        }

        
        $p{K} = Point->new($pn,$D[0]+90,$D[1]+170);
        $t{GH} = $t{xr}->copy_to_polygon_shape($p{K},$t{D});
        $t{GH}->fill($colour4);
        $p{K}->remove;
        $p{G} = $t{GH}->p(1)->label("G","bottom");
        $p{N} = $t{GH}->p(2)->label("","right");
        $p{H} = $t{GH}->p(3)->label("H","top");
        $p{K} = $t{GH}->p(4)->label("K","top");
        
        $t{x1}->remove;
        $t{x2}->remove;
        $t{xr}->remove;
        $t3->math("GH = C + FB");
    };


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("GH is similar to D, which is also similar to FB, ".
        "therefore GH is similar to FB (VI.21)");
        $t3->grey([1]);
        $t3->math("GH ~ D");
        $t3->math("\\{therefore} GH ~ FB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("GH is larger than FB, and since they are ".
        "similar, GK is larger than FE and KH is larger than FL");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Extend the line FL and FE such that FLM is equal to KH ".
        "and FEN is equal to KG");
        $l{tmp1} = $blank->l(1)->clone();
        $l{tmp1}->prepend(300);
        ($l{FN}, $p{N}) = $t{GH}->l(2)->copy_to_line($blank->p(2),$l{tmp1});
        $l{tmp1}->remove;
        $p{N}->label("N","bottom");

        $l{tmp1} = $blank->l(2)->clone();
        $l{tmp1}->extend(300);
       
        ($l{FM}, $p{M}) = $t{GH}->l(1)->copy_to_line($blank->p(2),$l{tmp1});
        $l{tmp1}->remove;
        $p{M}->label("M","top");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Complete the parallelogram MN");
        $t{MFNO} = Parallelogram->new($pn,$p{M}->coords,$p{F}->coords,$p{N}->coords)->fill($colour4);
        $p{O} = $t{MFNO}->p(4)->label("O","bottom");
        $t3->grey([0..20]);
        $t3->math("MN = GH");
        $t{GH}->grey;
        $p{G}->grey;
        $p{K}->grey;
        $p{H}->grey;
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since MN is similar to GH, so is MN similar to FB (VI.21), ".
        "thus the points F,B, and O lie on the same diagonal (VI.26)");
        $l{FO} = Line->join($p{F},$p{O})->dash;
        $t2->down;
        $t2->down;
        $t3->grey([0..20]);
        $t3->black([0,2,3,4]);
        $t2->math("MN ~ GH ~ D ~ FB");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Construction (cont.)");
        $t1->explain("GH is equal to sum of FB and C, and since MN is ".
        "equal to GH, the remaining gnomon (NOMLBE) is equal in area to C");
        $t{gnomon} = Polygon->join(6,$p{E},$p{N},$p{O},$p{M},$p{L},$p{B})->fill($colour4);
        $t{MFNO}->grey; 

        $t3->grey([0..20]);
        $t2->grey([0..20]);
        $t3->black([1,4]);
        $t2->math("NOMLBE = C");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since AE equals EB, the parallelogram AN equals NB (VI.21) and LP (VI.26)");
        $t{gnomon}->grey;
        $blank->grey;
        $l{FM}->grey;
        $l{FN}->grey;
        $l{FO}->grey;
        $l{tmp1} = Line->join($p{O},$p{N});
        $l{tmp2} = Line->join($p{E},$p{F});
        $l{tmp3} = $l{tmp2}->parallel($p{A});
        $p{noname} = Point->new($pn,$l{tmp3}->intersect($l{tmp1}));
        $l{tmp1}->remove;
        $l{tmp2}->remove;
        $l{tmp3}->remove;
        $t{AN} = Polygon->join(4,$p{A},$p{E},$p{N},$p{noname})->fill($colour1);

        $l{tmp1} = Line->join($p{L},$p{B});
        $l{tmp2} = Line->join($p{noname},$p{N});
        $p{Q} = Point->new($pn,$l{tmp1}->intersect($l{tmp2}))->label("Q","bottom");
        $l{tmp1}->remove;
        $l{tmp2}->remove;
        $t{NB} = Polygon->join(4,$p{E},$p{B},$p{Q},$p{N})->fill($colour2);

        $l{tmp1} = Line->join($p{E},$p{B});
        $l{tmp2} = Line->join($p{L},$p{B});
        $l{tmp3} = $l{tmp2}->parallel($p{M});
        $p{P} = Point->new($pn,$l{tmp1}->intersect($l{tmp3}))->label("P","right");
        $l{tmp1}->remove;
        $l{tmp2}->remove;
        $l{tmp3}->remove;
        $t{LP} = Polygon->join(4,$p{L},$p{M},$p{P},$p{B})->fill($colour3);

         $t3->grey([0..20]);
        $t2->grey([0..20]);
        $t2->math("AN = NB = LP");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Add EO to AN and LP, thus AO is equal to the gnomon (NOMLBE) ");
        $p{O}->normal;
        $p{E}->normal;
        $t{EO} = Polygon->join(4,$p{B},$p{P},$p{O},$p{Q})->fill($colour4);
        $t2->math("AO = AN + EO");
        $t2->math("AO = LP + EO = NOMLBE ");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("It has already been shown that the gnomon is equal to C, "
        ."hence AO is equal to C");
        $t2->grey([0..20]);
        $t2->black([1,4]);
        $t2->math("AO = C");
        $t{EO}->grey;
        $t{LP}->grey;
        $t{AN}->grey;
        $t{NB}->grey;
        $p{E}->grey;
        $p{N}->grey;
        $p{Q}->grey;
        $t{AO} = Polygon->join(4,$p{A},$p{P},$p{O},$p{noname})->fill($colour2);
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, AO is a parallelogram drawn on AB, ".
        "equal in size to C, exceeding AB by a parallelogram figure (QP) similar ".
        "to D");
        $t{BO} = Polygon->join(4,$p{B},$p{P},$p{O},$p{Q});
        $p{Q}->normal;
        $t2->grey(1);
        
     };


    return $steps;

}

sub normal_shit {
    foreach my $type ( \%l, \%t, \%a, \%p ) {
        foreach my $o ( keys %$type ) {
            $type->{$o}->normal;
        }
    }
}
sub grey_shit {
    foreach my $type ( \%l, \%t, \%a, \%p) {
        foreach my $o ( keys %$type ) {
            $type->{$o}->grey;
        }
    }
}


##########################################################################################
# DRAG AND RESHAPE THE POLYGONS
##########################################################################################
sub redraw_polygons {
    my @A = @{+shift};
    my @A1 = @{+shift};
    my @B = @{+shift};
    my $blue = shift;
    my $blank = shift;
    
    # new coords
    my @red = @{+shift};
    my @a = (($red[1]-$A[1])/($A1[1]-$A[1])*($A1[0]-$A[0])+$A[0],$red[1]);
    my @e = (($red[1]-$A[1])/($A1[1]-$A[1])*($A1[0]-$A[0])+$B[0],$red[1]);
    my @c = ($A[0]+($red[0]-$a[0]),$A[1]);
    
    $blue->reposition(@A,@a,@red,@c);
    $blank->reposition(@c,@red,@e,@B);
    
}

sub create_drag_button {
    my $coords = shift;
    my $line_constraint = shift;
    my $callback = shift || sub {return};
        my @start = $line_constraint->start;
        my @end = $line_constraint->end;
        my $xmin = $start[0] < $end[0] ? $start[0] : $end[0];
        my $xmax = $start[0] > $end[0] ? $start[0] : $end[0];
        my $slope = $line_constraint->slope;
        
    
    my $Point = Point->new($pn,@$coords)->red;
    $Point->{-line_xmin} = $xmin;
    $Point->{-line_xmax} = $xmax;
    $Point->{-line_slope} = $slope;
    $Point->{-line_start} = \@start;
    $Point->{-exec} = $callback;
    
    # bind the mouse down and mouse movements to this object
        $Point->{-draggable} = 1;
        $Point->_unbind_notice();
        foreach my $obj ( $Point->cn_objects ) {
            $Point->canvas->bind( $obj, "<ButtonPress-1>", [ \&_start_moving, $Point ] );
            $Point->canvas->bind( $obj, "<ButtonRelease-1>", [ \&_stop_moving, $Point ] );
        }
    return $Point;  

}

{

    # -------------------------------------------------------------------------
    # _start_moving ... dragging has started
    # -------------------------------------------------------------------------
    sub _start_moving {
        print ("start_moving: @_\n");
        my $cn   = shift;
        my $self = shift;
        $cn->toplevel->bind( "<Motion>", [ \&_mouse_move, Tcl::Ev('%x', '%y'), $cn, $self ] );
    }

    # -------------------------------------------------------------------------
    # _mouse_move ... dragging is happening!
    # -------------------------------------------------------------------------
    sub _mouse_move {
        my $x    = shift;
        my $y    = shift;
        my $cn   = shift;
        my $self = shift;

        # the point must stay on the line (use x-coordinate as real, calculate y)
        $x = $self->{-line_xmin} if $x < $self->{-line_xmin};
        $x = $self->{-line_xmax} if $x > $self->{-line_xmax};
        $y = $self->{-line_start}->[1] + $self->{-line_slope} * ($x - $self->{-line_start}->[0]);
        
        _stop_moving( $cn, $self );
        $self->move_to( $x, $y  );
        my @coords = $self->coords;
        $self->{-exec}->(\@coords);
        $self->raise;
        $pn->force_update;
        _start_moving( $cn, $self  );

    }

    # -------------------------------------------------------------------------
    # _stop_moving ... dragging has stopped
    # -------------------------------------------------------------------------
    sub _stop_moving {
        print ("stop_moving: @_\n");
        my $cn   = shift;
        my $self = shift;
        $cn->toplevel->bind( "<Motion>", sub{} );
        $self->raise;
        $pn->force_update;
     }
}


