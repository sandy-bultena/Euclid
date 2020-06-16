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
"to a given rectilineal figure and deficient by a parallelogrammic ".
"figure similar to a given one: thus the given rectilineal figure ".
"must not be greater than the parallelogram described on the half of ".
"the straight line and similar to the defect";

$pn->title( 28, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 500 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 28 );
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
    my $xs   = 140;
    my $dx1  = 300; # length of AB
    my $dx2  = -40;
    my $off  = 60;
 
    # straight line
    my @A = ( $xs, $yb );
    my @B = ( $xs+$dx1, $yb );
    my @E = ( $xs + $dx1/2, $yb ); # midpoint of AB

    # polygon
    my @C = ($B[0]+$off, $yh-10,
            $B[0]+$off+50,  $yb+0.5*($yh-$yb),
            $B[0]+$off+150, $yb+0.5*($yh-$yb)-20,
            $B[0]+$off+120, $yh);
    
    # parallelogram
    my $dx3 = 80;       # length of base
    my $xds = $B[0]+40; # bottom corner
    my $y3 = 80;        # height
    my $dx4 = 20;       # offset

    my @D = ($xds, $yb,
            $xds+$dx3, $yb,
            $xds+$dx3+$dx4,  $yb-$y3,
            $xds+$dx4,  $yb-$y3);

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
        $p{A} = Point->new( $pn, @A )->label( "A", "bottom" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $l{AB} = Line->join($p{A},$p{B});
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let C be a rectilineal figure and D be a parallelogram");
        $p{A} = Point->new( $pn, @A )->label( "A", "bottom" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $l{AB} = Line->join($p{A},$p{B});
        $t{C} = Polygon->new($pn,4,@C)->fill($colour2)->label("C");
        $t{D} = Polygon->new($pn,4,@D)->label("D");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("We want to draw a parallelogram on AB such that ... ");
        $t1->point("If a parallelogram similar to parallelogram D is removed, then... ");
        $t1->point("the remainder is equal in area to C");

        $t{huh} = Polygon->new($pn,4,150,339,409,339,398,380,140,380)->fill($colour2);
        $t{boo} = Polygon->new($pn,4,409,339,450,339,440,380,399,380);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $p{D1} = Point->new( $pn, @D1 );
        $l{DB} = VirtualLine->join($p{D1},$p{B});#->dash();
        $blue = Polygon->new($pn,4,@A,@A1,@D1,@E)->fill($colour1);
        $blank = Polygon->new($pn,4,@E,@D1,@G,@B);
        $p{D1}->remove;

        my $callback = sub{ my $new = shift; redraw_polygons(\@A,\@A1,\@B,$blue,$blank,$new);};
        $p{drag} = create_drag_button(\@D1,$l{DB},$callback);

        $t1->explain("Note that: ");
        $t1->point("the area of C cannot be greater than the area of ".
        "half the parallelogram on the line AB");
    };
    
    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{huh}->remove;
        $t{boo}->remove;
        $p{drag}->remove;
        $blue->remove;
        $blank->remove;
        $t1->erase;
        $t1->down;
        $t1->title("Construction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Bisect the line AB at point E");
        $p{E}=Point->new($pn,@E)->label("E","bottom");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Create a parallelogram similar to D on line EB (VI.18)");
        $p{F} = Point->new($pn,@G)->label("F","top");
        $p{G} = Point->new($pn,@D1)->label("G","top");
        $blank = Polygon->new($pn,4,@E,@D1,@G,@B);
        $t3->math("GB ~ D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the parallelogram AG be completed");
        $p{H} = Point->new($pn,@A1)->label("H","top");
        $blue = Polygon->new($pn,4,@A,@A1,@D1,@E)->fill($colour1);        
        };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If AG is equal in size to C, then we are finished, ".
        "otherwise ... HE is greater than C");
        $t3->math("If HE > C")->blue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("HE is equal to GB, therefore GB is also greater than C");
        $t3->math("HE = GB");
        $t3->math("GB > C");
        $blue->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let KLMN be constructed such that it is equal to the ".
        "the area of GB minus the area of C, and is similar to D (VI.25)");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->y($t1->y);
        $t4->down;
        $t4->title("??");        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->clear;
        $t3->clear;
        $t4->clear;
        $t4->down;
        $t4->title("Let KLMN be constructed... ");
        $t4->explain("... such that it is equal to the area ".
        "of GB minus the area of C, and is similar to D");
    };

    push @$steps, sub {
        $t4->explain("Copy the rectilineal figure C to a parallelogram ".
        "on line EB, with an inner angle of GEB");
    };

    push @$steps, sub {
        $t4->point("Split C into two triangles C1 and C2");
        $t{C}->fill();
        $t{xC1} = Triangle->new($pn,@C[0..5])->fill($colour2);
        $t{xC2} = Triangle->new($pn,@C[4..7],@C[0..1])->fill($colour3);
    };

    push @$steps, sub {
        $t4->point("Construct a parallelogram on the base EB such that it is equal in area "
        . "to the triangle C1 (I.44)" );
        $l{FB} = Line->join($p{F},$p{B});
        $l{EB} = Line->join($p{E},$p{B});
        $a{EBF} = Angle->new($pn,$l{FB},$l{EB});
        $a{EBF}->remove;
        $t{x1} = $t{xC1}->copy_to_parallelogram_on_line($l{EB},$a{EBF});
        $t{x1}->fill($colour2);
     };
    
    push @$steps, sub {
        $t4->point("Construct a parallelogram on the top of the previous parallelogram such that it is equal in area "
        . "to the triangle C2 (I.44)" );
        $l{xtop} = Line->join($t{x1}->points->[3],$t{x1}->points->[2]);
        $t{x2} = $t{xC2}->copy_to_parallelogram_on_line($l{xtop},$a{EBF});
        $t{x2}->fill($colour3);
        $l{xtop}->remove;
     };
    
    push @$steps, sub {
        $t4->explain("What is left over in the parallelogram EF is now equal ".
        "to the area of EF minus the area of C");
        $t{xr} = Polygon->join(4,$p{G},$p{F},$t{x2}->points->[2],$t{x2}->points->[3]);
        $t{xr}->fill($colour4);
        $t{xC1}->remove;
        $t{xC2}->remove;
        $t{x1}->grey;
        $t{x2}->grey;
        $t{C}->fill($colour2);
     };
    
    push @$steps, sub {
        $t4->explain("Now, copy this new polygon to KLMN, which is similar to ".
        "the polygon D (VI.25)");
        if (! $ENV{EUCLID_AUTO} ) {
            $pn->force_update();
        }
        
        $p{K} = Point->new($pn,$D[0]+100,$D[1]+50);
        $t{KLMN} = $t{xr}->copy_to_polygon_shape($p{K},$t{D});
        $t{KLMN}->fill($colour4);
        $p{K}->remove;
        $p{K} = $t{KLMN}->p(1)->label("K","left");
        $p{L} = $t{KLMN}->p(2)->label("N","right");
        $p{M} = $t{KLMN}->p(3)->label("M","right");
        $p{N} = $t{KLMN}->p(4)->label("L","top");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        # clean up and go back to original page?
        foreach my $type ( \%l, \%t, \%a ) {
            foreach my $o ( keys %$type ) {
                $type->{$o}->remove if substr($o,0,1,) eq "x";
            }
        }
        $t1->clear;
        $t3->clear;
        $t4->clear;
        $t1->down;
        $t1->title("Construction");
        $t1->explain("Bisect the line AB at point E");
        $t1->explain("Create a parallelogram similar to D on line EB (VI.18)");
        $t1->explain("Let the parallelogram AG be completed");
        $t1->explain("If AG is equal in size to C, then we are finished, ".
        "otherwise ... HE is greater than C");
        $t1->explain("HE is equal to GB, therefore GB is also greater than C");
        $t3->math("HE = GB");
        $t3->math("GB ~ D");
        $t3->math("If HE > C")->blue;
        $t3->math("GB > C");
        $t1->explain("Let KLMN be constructed such that it is equal to the ".
        "the area of GB minus the area of C, and is similar to D (VI.25)");
        $t3->grey([1,2,3]);
        
        $t3->math("KM + C = GB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("KLMN is similar to D, which is also similar to GB, ".
        "therefore KLMN is similar to GB (VI.21)");
        $t3->math("KM ~ D");
        $t3->math("D ~ GB");
        $t3->math("\\{therefore} KM ~ GB");
        $t3->grey(4);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since KM is smaller than GB, and since they are ".
        "similar, LM is less than GF and LK is less than GE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Copy line KL to GE, and LM to GF");
        my $len1 = $t{KLMN}->l(1)->length;
        my $len2 = $t{KLMN}->l(2)->length;
        $p{P} = Point->new($pn,$D1[0]+$len1,$D1[1])->label("P","top");
        my ($ltmp, $ptmp) = $t{KLMN}->l(4)->copy_to_line($blank->p(2),$blank->l(1));
        $ltmp->remove;
        $p{O} = $ptmp->label("O","topleft");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Complete the parallelogram OGPQ");
        $t{OGPQ} = Parallelogram->new($pn,$p{O}->coords,$p{G}->coords,$p{P}->coords)->fill($colour4);
        $p{Q} = $t{OGPQ}->p(4)->label("Q","topleft");
        $t3->math("GQ = KM");
        $t3->grey([1..7]);
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since GB is similar to KM, so is GQ similar to GB (VI.21), ".
        "thus the points Q and B lie on the same diagonal (VI.26)");
        $l{BG} = Line->join($p{G},$p{B})->dash;
        $t2->down;
        $t2->down;
        $t2->math("GQ ~ KM ~ D ~ GB");
        $t3->black([5,6,7]);
        $t3->grey(8);
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("GB is equal to sum of KM and C, and since GQ is ".
        "equal to KM, the remaining gnomon (OEBFPQ) is equal in area to C");
        $t{gnomon} = Polygon->join(6,$p{O},$p{E},$p{B},$p{F},$p{P},$p{Q})->fill($colour2);
        $t3->grey([1..20]);
        $t3->black([4,8]);
        $t2->grey(0);
        $t2->math("OEBFQP = C"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->clear;
        $t1->down;
        $t1->title("Construction (cont.)");
        $t1->explain("extend OQ to R, and PQ to S");
        my @p = $t{OGPQ}->l(3)->intersect($blank->l(4));
        $p{S} = Point->new($pn,@p)->label("S","bottom");
        @p = $t{OGPQ}->l(4)->intersect($blank->l(3));
        $p{R} = Point->new($pn,@p)->label("R","right");
        $l{QR} = Line->join($p{Q},$p{R});
        $l{QS} = Line->join($p{Q},$p{S});
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The parallelograms PR and OS are equal");
        $t{gnomon}->grey;
        $t{OGPQ}->grey;
        $t{OGPQ}->p(4)->normal;
        $t{PR} = Polygon->join(4,$p{P},$p{F},$p{R},$p{Q})->fill($colour1);
        $t{OS} = Polygon->join(4,$p{O},$p{Q},$p{S},$p{E})->fill($colour1);
        $t2->grey([0..20]);
        $t3->grey([1..20]);
        $t2->math("PR = OS"); 
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If QB is added to PR and OS, then OB and PB ".
        "are equal");
        $t2->math("PB = OB");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("OB is equal to TE, since AE and EB are equal (I.36)");
        $t{PR}->fill();
        $t{QB} = Polygon->join(4,$p{Q},$p{R},$p{B},$p{S})->fill($colour1);
        my @p = $t{OS}->l(1)->intersect($blue->l(1));
        $p{T} = Point->new($pn,@p)->label("T","left");
        $t{TE} = Polygon->join(4,$p{T},$p{O},$p{E},$p{A})->fill($colour1);
        $t2->grey([0..20]);
        $t2->math("TE = OB");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("PB equals OB, TE is equal to PB");
        $t2->grey([0..20]);
        $t2->black([3,4]);
        $t2->math("TE = PB");
        $t{OS}->fill();
        $t{PR}->fill($colour1);        
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But PB, or TE, added together with OS is the gnomon that is ".
        "equal to the area of C");
        $t{QB}->fill($colour2);
        $t{PR}->fill($colour2);
        $t{TE}->fill();
        $t{OS}->fill($colour2);
        $t2->grey([0..20]);
        $t2->black(1);
        $t2->math("OS + PB = C");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{QB}->fill();
        $t{PR}->fill();
        $t{TE}->fill($colour2);
        $t{OS}->fill($colour2);
        $t2->grey([0..20]);
        $t2->black(1);
        $t2->grey([0..20]);
        $t2->math("OS + TE = C");
        $t2->black([5,6]);
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Thus TS is a parallelogram, drawn on AB, minus ".
        "the parallelogram QB (which is similar to D), whose area ".
        "equals the polygon C");
        $t2->grey([0..20]);
        $t2->black(8);
        $t2->math("TS = C");
        grey_shit();
        $blank->grey;
        $t{C}->normal;
        $t{D}->normal;
        $t{TS} = Polygon->join(4,$p{T},$p{Q},$p{S},$p{A})->fill($colour2);

        $p{T}->normal;
        $p{Q}->normal;
        $p{S}->normal;
        $t{QB}->normal;
               
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


