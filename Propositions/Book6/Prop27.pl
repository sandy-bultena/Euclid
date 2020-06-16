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
my $title = "Of all the parallelograms applied to the same straight line ".
"and deficient by parallelogrammic figures similar and similarly situated ".
"to that described on the half of the straight line, that parallelogram ".
"is greatest which is applied to the half of the straight line and ".
"is similar to the defect";

$pn->title( 27, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 140, 660 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 27 );
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
    my $xs   = 80;
    my $dx1  = 300;
    my $dx2  = -40;
    my $offset = 360;

    my @A = ( $xs, $yb );
    my @B = ( $xs+$dx1, $yb );
    my @C = ( $xs + $dx1/2, $yb );
    my @A1 = ( $xs + $dx2, $yh );
    my @D = ($C[0]+$dx2,$yh);
    my @E = ($B[0]+$dx2,$yh);
    
    my (@a,@b,@c,@a1,@d,@e);
    @a = ($A[0]+$offset,$A[1]);
    @b = ($B[0]+$offset,$B[1]);
    @c = ($C[0]+$offset,$C[1]);
    @a1 = ($A1[0]+$offset,$A1[1]);
    @d = ($D[0]+$offset,$D[1]);
    @e = ($E[0]+$offset,$E[1]);

    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;
    my $colour5 = Colour->lighten(10,$colour4);

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a straight line AB");
        $p{A} = Point->new( $pn, @A )->label( "A", "bottom" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $l{AB} = Line->join($p{A},$p{B});
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("and a midpoint C");
        $t3->math("AC = \\{half} AB")->blue(0);
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a parallelogram on AB");
        $t{AD} = Polygon->new($pn,4,@A,@A1,@E,@B)->fill($colour1);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Remove the section described by the parallelogram CE");
        $t{AD}->remove;
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $t{AD} = Polygon->new($pn,4,@A,@A1,@D,@C)->fill($colour1);
        $t{CE} = Polygon->new($pn,4,@C,@D,@E,@B);
        $t3->math("\\{square}AD = \\{square}DB")->blue(1);
    };
    
    my $blue;
    my $blank;
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Then the parallelogram AD is the largest of all parallelograms ".
        "drawn on AB, where another parallelogram similar to CE (and similarly situated) ".
        "is removed");
        $l{DB} = Line->join($p{D},$p{B})->dash();
        $blue = Polygon->new($pn,4,@A,@A1,@D,@C)->fill($colour1);
        $blank = Polygon->new($pn,4,@C,@D,@E,@B);
        $t{AD}->grey;
        $t{CE}->grey;
        my $callback = sub{ 
            my $new = shift; 
            redraw_polygons(\@A,\@A1,\@B,$blue,$blank,$new);
        };
        $p{drag} = create_drag_button(\@D,$l{DB},$callback);
        $t{GK} = $blue;
        $t{KH} = $blank;
         if ($ENV{EUCLID_CREATE_PDF}) {
             $l{DB}->remove;
             $p{drag}->remove;
         }
    };
    
 
    if ($ENV{EUCLID_CREATE_PDF}) {
    push @$steps, sub {
        my $x = $D[0]+0.3*($B[0]-$D[0]);        
        my $y = $D[1]+0.3*($B[1]-$D[1]); 
            redraw_polygons(\@A,\@A1,\@B,$blue,$blank,[$x,$y]);
        $t3->math("\\{square}DB ~ \\{square}FB")->blue(3);
        $p{F} = $t{GK}->points->[2]->label("F","topright");
        $blue->fill();
        $t{CE}->fill(Colour->lighten(10,$colour2));
        $blank->fillover($t{CE},$colour2);
    };
    }
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{drag}->remove;
        $t{AD}->normal;
        $t{CE}->normal;
        $t{GK}->fill;
        $p{G} = $t{GK}->points->[1]->label("G","left");
        $p{F} = $t{GK}->points->[2]->label("F","topright");
        $p{H} = $t{KH}->points->[2]->label("H","right");
        $p{K} = $t{GK}->points->[3]->label("K","bottom");
        
        $t{CE}->fill;
        $blank->fill();
        $t{AD}->fill(Colour->lighten(10,$colour1));
        $blue->fillover($t{AD},$colour1);
       if (!$ENV{EUCLID_CREATE_PDF}) {
        $t3->math("\\{square}DB ~ \\{square}FB")->blue(3);
       }
        $t3->math("\\{square}AD > \\{square}AF");
        
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t3->erase;
        $t3->math("AC = \\{half} AB")->blue(0);
        $t3->math("\\{square}AD = \\{square}DB")->blue(1);
        $t3->math("\\{square}DB ~ \\{square}FB")->blue(2);
        $t{AD}->fill();
        $blue->fill();

        $p{A} = Point->new( $pn, @A )->label( "A", "bottom" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottom" );
        $l{AB} = Line->join($p{A},$p{B});
    };
    


    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the parallelograms DB and FB are similar, they are "
        ."both on the same diameter (VI.26)"); 
        $t{AD}->grey;
        $t{GK}->grey;
        $p{F}->normal;
             $l{DB}->draw;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $p{K}->normal;
        $p{F}->normal;
        $l{KF} = $t{KH}->lines->[0];
        my @p = $l{KF}->intersect($t{AD}->lines->[1]);
        $p{N} = Point->new($pn,@p);
        $l{FN} = Line->new($pn,$l{KF}->end,@p);
        $t1->explain("Parallelograms CF and FE are equal (I.43)");
        $p{L} = Point->new($pn,$t{GK}->lines->[1]->intersect($t{AD}->lines->[2]));
        $t{CF} = Parallelogram->join(4,$p{C},$p{L},$p{F},$p{K})->fill($colour2);
        $t{FE} = Parallelogram->join(4,$p{F},$p{N},$p{E},$p{H})->fill($colour3);
        $t3->grey([0..20]);
        $t3->math("\\{square}CF     = \\{square}FE");

       $p{a} = Point->new( $pn, @a )->label( "A", "bottom" );
        $p{b} = Point->new( $pn, @b )->label( "B", "bottom" );
        $l{ab} = Line->join($p{a},$p{b});
        $p{c} = Point->new( $pn, @c )->label( "C", "bottom" );
        $p{d} = Point->new( $pn, @d )->label( "D", "top" );
        $p{e} = Point->new( $pn, @e )->label( "E", "top" );
        $t{ad} = Polygon->new($pn,4,@a,@a1,@d,@c);
        $t{ce} = Polygon->new($pn,4,@c,@d,@e,@b);
        $l{db} = Line->join($p{d},$p{b})->dash();
      
        @p = $t{GK}->points->[1]->coords;
        $p{g} = Point->new($pn,$p[0]+$offset,$p[1])->grey;
        @p = $t{GK}->points->[2]->coords;
        $p{f} = Point->new($pn,$p[0]+$offset,$p[1])->label("F","topright");
        @p = $t{KH}->points->[2]->coords;
        $p{h} = Point->new($pn,$p[0]+$offset,$p[1])->label("H","right");
        @p = $t{GK}->points->[3]->coords;
        $p{k} = Point->new($pn,$p[0]+$offset,$p[1])->label("K","bottom");
        $t{gk} = Polygon->join(4,$p{a},$p{g},$p{f},$p{k});
        $t{kh} = Polygon->join(4,$p{k},$p{f},$p{h},$p{b});
        $t{ad}->grey;
        $t{gk}->grey;
         $l{kf} = $t{kh}->lines->[0];
        @p = $l{kf}->intersect($t{ad}->lines->[1]);
        $p{n} = Point->new($pn,@p);
        $l{fn} = Line->new($pn,$l{kf}->end,@p);
        $p{l} = Point->new($pn,$t{gk}->lines->[1]->intersect($t{ad}->lines->[2]));
        $t{cf} = Parallelogram->join(4,$p{c},$p{l},$p{f},$p{k})->fill($colour2);
        $t{fe} = Parallelogram->join(4,$p{f},$p{n},$p{e},$p{h})->fill($colour3);
        










    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the parallelogram FB is common, ".
        "the whole of CH is equal to the whole KE");
        $t3->math("\\{square}CF+\\{square}FB = \\{square}FE+\\{square}FB ");
        $t3->math("\\{square}CH = \\{square}KE");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{KH} = Parallelogram->join(4,$p{K},$p{F},$p{H},$p{B})->fill($colour2);
        $t{FE}->fill();
        $t{kh} = Parallelogram->join(4,$p{k},$p{f},$p{h},$p{b})->fill($colour3);
        $t{cf}->fill;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But CH is equal to CG, since AC is also equal to CB (I.36)");
        $t{KH}->normal->fill($colour2);;
        $t{CF}->normal->fill($colour2);
        $t{FE}->grey;
        $p{G}->normal;
        $t{GC} = Polygon->join(4,$p{A},$p{G},$p{L},$p{C})->fill($colour1);
        $t3->grey([0..20]);
        $t3->blue([0]);
        
        $t3->math("\\{square}CH = \\{square}CG");        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore CG is also equal to KE");
        $t3->grey([0..20]);
        $t3->black([5..20]);
        $t{CF}->fill;
        $t{KH}->fill;
        $t3->math("\\{square}CG = \\{square}KE");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Add the parallelogram CF to each, therefore the gnomon ".
        "CBEF is equal to the parallelogram AF");
        $t3->math("\\{square}AF = \\{gnomon}CBEF");
        $t3->grey([0..20]);
        $t3->black([7,8]);
        $t{cf}->fill($colour3);
        $t{CF}->fill($colour1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The gnomon CBEF is less than the parallelogram DB");
        $t3->grey([0..20]);
        $t2->math("CBEF < \\{square}DB");
        $t{GC}->fill;
        $t{CF}->fill;
        $t{DB} = Polygon->join(4,$p{D},$p{E},$p{B},$p{C})->fill($colour5);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And thus, the gnomon is also less than AD");
        $t2->math("CBEF < \\{square}AD");
        $t3->grey([0..20]);
        $t3->blue(1);
        $t{DB}->fill;
        $t{AD}->normal->fill($colour1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Finally, since CBEF is equal to AF, AF is less than ".
        "the AD");
        $t{fe}->fill;
        $t{kh}->fill;
        $t{gk}->fill($colour3);
        $t{ad}->normal;
        Line->join($p{g},$p{f});
        $t3->grey([0..20]);
        $t3->black(8);
        $t2->grey([0..20]);
        $t2->black(-1);
        $t2->math("\\{square}AF < \\{square}AD");
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
sub grey_shit {
    foreach my $type ( \%l, \%t, \%a ) {
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
        $pn->force_update;
        _start_moving( $cn, $self  );

    }

    # -------------------------------------------------------------------------
    # _stop_moving ... dragging has stopped
    # -------------------------------------------------------------------------
    sub _stop_moving {
        my $cn   = shift;
        my $self = shift;
        foreach my $obj ( $self->cn_objects ) {
            $cn->toplevel->bind( "<Motion>", sub{} );
        }
        $self->raise;
    }
}


