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
my $title = "To cut a finite straight line in extreme ratio";

$pn->title( 30, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 500 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 30 );
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
    my $yb   = 300;
    my $xs   = 160;
    my $dx1  = 200; # length of AB
 
    # straight line
    my @A = ( $xs, $yb );
    my @B = ( $xs+$dx1, $yb );
    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;
    my @E = (284, 300);
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a straight line AB");
        $t1->explain("Construct a point E such that ");
        $p{A} = Point->new( $pn, @A )->label( "A", "left" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottomright" );
        $l{AB} = Line->join($p{A},$p{B});
        $p{E} = Point->new($pn, @E)->label("E","bottom");
        $t1->explain("AB is to AE as AE is to EB and AE is greater than EB");
        $t3->math("AB:AE = AE:EB");
        $t3->math("AE > EB");
    };
    
    
    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase;
        $t1->erase;
        $t1->down;
        $p{E}->remove;
        $t1->title("Construction");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a square on AB");
        ($l{BH},$l{CH},$l{AC}) = $l{AB}->square();
        $p{C}=Point->new($pn,$l{CH}->end)->label("C","topleft");
        $p{H}=Point->new($pn,$l{CH}->start)->label("H","topright");
        $t{BC}=Polygon->join(4,$p{C},$p{A},$p{B},$p{H});
        if (0) {
        $p{c} = Point->new($pn,$B[0]+150,$B[1])->label("C","bottom");
        $p{a} = Point->new($pn,$B[0]+150+$dx1,$B[1])->label("A","bottom");
        $l{ac} = Line->join($p{c},$p{a});
        }
        $t{BC}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("On the line AC, draw a parallelogram that is ".
        "equal to the square BC, and whose excess (the part that is ".
        "drawn past the line AC) is similar to the square BC (VI.29)");
        $t1->point("Bisect the line AC at point \\{alpha}");
        $p{alpha} = $l{AC}->bisect()->label("\\{alpha}","left");     
        if(0) {$p{alpha1} = $l{ac}->bisect()->label("\\{alpha}","bottom");}  
        $l{BH}->grey;
        $l{CH}->grey;
        $l{AB}->grey;      
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->point("Create a square on the line A\\{alpha}");
        $l{tmp4} = Line->join($p{A},$p{alpha});
        ($l{tmp1},$l{tmp2},$l{tmp3}) = $l{tmp4}->square();
        $p{tmp1}=Point->new($pn,$l{tmp2}->start)->label("\\{gamma}","left");        
        $p{tmp2}=Point->new($pn,$l{tmp2}->end)->label("\\{beta}","left");        

        if (0) {
        $l{tmp4_1} = Line->join($p{alpha1},$p{a});
        ($l{tmp1_1},$l{tmp2_1},$l{tmp3_1}) = $l{tmp4_1}->square();
        $p{tmp1_1}=Point->new($pn,$l{tmp2_1}->end)->label("\\{gamma}","top");        
        $p{tmp2_1}=Point->new($pn,$l{tmp2_1}->start)->label("\\{beta}","top");        
        }
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->point("Let a parallelogram H\\{delta} be constructed such that is equal to the ".
        "area of A\\{gamma} plus the area of BC");
        $a{right} = Angle->new($pn,new VirtualLine(10,10,100,10),new VirtualLine(10,10,10,100));
        $a{right}->remove;
        $l{tmp10} = Line->join($p{B},$p{A});
        $t{tmp1} = Polygon->join(4,$p{A},$p{alpha},$p{tmp1},$p{tmp2});
        $t{tmp2} = $t{tmp1}->copy_to_parallelogram_on_line($l{tmp10},$a{right});
        $t{tmp1}->remove;   
        $t{tmp2}->p(3)->label("\\{delta}","bottom");     
        $t{tmp5} = Polygon->join(4,$p{C},$p{H},$t{tmp2}->p(4),$t{tmp2}->p(3))->fill($colour1); 
        $l{tmp10}->remove;    
      #  $t{tmp2}->remove;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{tmp2}->remove;
        $t1->point("Copy this parallelogram to a square and move it "
        ."such that the top left corner coincides with gamma"); 
        $t{tmp10} = $t{tmp5}->copy_to_polygon_shape($p{C},$t{BC});
        my $side = $t{tmp10}->l(1)->length;
        $t{tmp10}->remove;
        $p{tmp11}= Point->new($pn,$p{tmp1}->x,$p{tmp1}->y+$side);
        $p{D}= Point->new($pn,$p{tmp11}->x+$side,$p{tmp11}->y)->label("D","bottomright");
        $p{tmp13}= Point->new($pn,$p{tmp1}->x+$side,$p{tmp1}->y);
        $t{tmp10} = Polygon->join(4,$p{tmp1},$p{tmp11},$p{D},$p{tmp13})->fill($colour1);
        
        if(0) {
        $p{tmp11_1}= Point->new($pn,$p{tmp1_1}->x,$p{tmp1_1}->y+$side);
        $p{d}= Point->new($pn,$p{tmp11_1}->x+$side,$p{tmp11_1}->y);
        $p{tmp13_1}= Point->new($pn,$p{tmp1_1}->x+$side,$p{tmp1_1}->y);
        $t{tmp10_1} = Polygon->join(4,$p{tmp1_1},$p{tmp11_1},$p{d},$p{tmp13_1})->fill($colour1);
        }
        $t{tmp5}->remove;
        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->point("The resulting gnomon is equal to the square BC");
        $p{F} = Point->new($pn,$t{tmp10}->l(3)->intersect($l{CH}))->label("F","top");
        $p{unnamed} = Point->new($pn,$t{tmp10}->l(2)->intersect($l{AC}));
        $t{CD} = Polygon->join(4,$p{C},$p{unnamed},$p{D},$p{F});
        $t{little} = Polygon->join(4,$p{A},$p{alpha},$p{tmp1},$p{tmp2})->fill("white")->raise();
        
    };
    
     # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->point("And therefore the area CD is ".
        "equal to the area BC");
        $t{little}->remove;
        $p{F} = Point->new($pn,$t{tmp10}->l(3)->intersect($l{CH}))->label("F","top");
        $p{unnamed} = Point->new($pn,$t{tmp10}->l(2)->intersect($l{AC}));
        $t{tmp10}->fill->grey;
        $t{CD} = Polygon->join(4,$p{C},$p{unnamed},$p{D},$p{F})->fill($colour1);
 
        if(0) {
        $p{unamed_1} = Point->new($pn,$t{tmp10_1}->l(3)->intersect($l{ac}));
        $p{f} = Point->new($pn,$p{c}->x,$t{tmp10}->p(2)->y);
        $t{tmp10_1}->fill;
        $t{tmp10_1}->grey;
        $t{cd} = Polygon->join(4,$p{c},$p{unamed_1},$p{d},$p{f})->fill($colour1);
        }
 
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        remove_tmp();
        $t{CD}->fill();
        $t3->math("BC = CD");
        $t3->math("AD = \\{square}");
        $p{alpha}->remove;
        $t{BC}->draw();
     };
    
   # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("The intersection E of the polygon and line AB ".
        "cuts the line into the extreme and mean ratio");
        $t3->math("AB:AE = AE:EB");
        $p{E}=Point->new($pn,$l{AB}->intersect($t{tmp10}->l(3)))->label("E","bottomright");
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t3->erase;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("BC is equal to CD (by construction)");
        $t3->math("BC = CD");
        $t3->math("AD = \\{square}");
     };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Subtract CE from BC and CD, and the remainders ".
        "FB and AD are equal");
        $t3->math("BC - CE = CD - CE");
        $t3->math("AD = FB");
        $t3->grey(1);
        $t{CD}->fill;
        $t{AD} = Polygon->join(4,$p{A},$p{E},$p{D},$p{unnamed})->fill($colour3);
         $t{AD}->fill($colour3);
         $t{FB}= Polygon->join(4,$p{F},$p{H},$p{B},$p{E})->fill($colour3);
     };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("AD and FB are equiangular, and equal, therefore the sides ".
        "about the equal angles are reciprocally proportional (VI.14)");
        $t3->grey([0..2]);
        $t3->math("FE:ED = AE:EB");
     };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->grey(3);
        $t1->explain("BC is a square, so therefore FE is equal to AB ...");
        $t3->math("AB:ED = AE:EB");
     };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("... and AD is a square, so therefore ED is equal to AE");
        $t1->explain("Therefore AB is to AE as AE is to EB");
        $t3->allgrey;
        $t3->black([-1,1]);
        $t3->math("AB:AE = AE:EB");
     };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("AB is greater than AE, therefore AE is greater than EB");
        $t3->allgrey;
        $t3->black([-1]);
        $t3->math("AB > AE \\{therefore} AE > EB");
     };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->black([0,1]);
        $t1->explain("Therefore AB has been cut in extreme and mean ".
        "ratio at E, where AE is the larger segment");
    };
    


    return $steps;

}

sub remove_tmp {
    foreach my $type ( \%l, \%t, \%a, \%p ) {
        foreach my $o ( keys %$type ) {
            if ($o =~ /tmp/) {
                $type->{$o}->remove;
            }
        }
    }
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


