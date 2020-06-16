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
my $title = "In any parallelogram the parallelograms about the diameter are ".
"similar both to the whole and to one another.";

$pn->title( 24, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 140, 660 );
my $t5 = $pn->text_box( 140, 150, -width=>1100 );
my $t3 = $pn->text_box( 100, 350 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 24 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();
    my (%p,%c,%s,%t,%l,%a);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $off = 40;
    my $yoff = 30;
    my $yh = 150;
    my $yb = 300;
    my $xs = 150;
    my $dx1 = 400;
    my $dx2 = 20;
    my $dx3 = 140;

    my @A = ($xs,$yh);
    my @B = ($xs+$dx1,$yh);
    my @C = ($xs+$dx1+$dx2,$yb);
    my @D = ($xs+$dx2,$yb);
    
    my @E = ($A[0]+$dx3,$yh);
    my @K = ($D[0]+$dx3,$yb);
    
    my @F = VirtualLine->new(@A,@C)->intersect(VirtualLine->new(@E,@K));
    my $ym = $F[1];
    my $dx4 = $dx2/($yh-$yb)*($yh-$ym);
    
    my @G = ($A[0]+$dx4,$ym);
    my @H = ($G[0]+$dx1,$ym);
    

    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;

    

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Start with a parallelogram");
        
        $p{A} = Point->new($pn,@A)->label("A","top");
        $p{B} = Point->new($pn,@B)->label("B","top");
        $p{C} = Point->new($pn,@C)->label("C","bottom");
        $p{D} = Point->new($pn,@D)->label("D","bottom");
        $t{AC} = Polygon->join(4,$p{A},$p{B},$p{C},$p{D})->fill($colour1);                
    };

    push @$steps, sub {
        $t1->explain("Draw the diameter AC");
        $l{AC} = Line->join($p{A},$p{C});
    };

    push @$steps, sub {
        $t1->explain("Construct a parallelogram EG on the diameter AC");
        $p{E} = Point->new($pn,@E)->label("E","top");
        $p{F} = Point->new($pn,@F)->label("F","topright");
        $p{G} = Point->new($pn,@G)->label("G","left");
        $l{EF} = Line->join($p{E},$p{F});        
        $l{FG} = Line->join($p{G},$p{F});
        $t{EG} = Polygon->join(4,$p{A},$p{E},$p{F},$p{G})->fill($colour2)->raise;
        $l{AC}->raise;        
    };

    push @$steps, sub {
        $t1->explain("Construct a parallelogram HK on the diameter AC");
        $p{H} = Point->new($pn,@H)->label("H","right");
        $p{K} = Point->new($pn,@K)->label("K","bottom");
        $l{FH}=Line->join($p{F},$p{H});        
        $l{FK}=Line->join($p{F},$p{K});
        $t{FK} = Polygon->join(4,$p{F},$p{H},$p{C},$p{K})->fill($colour3)->raise;        
        $l{AC}->raise;        
    };

    push @$steps, sub {
        $t1->explain("The resulting parallelograms will all be similar to one another");
        $t{AC}->grey;
        $t3->grey([0..20]);
        $t3->math("\\{square}AC ~ \\{square}EG ~ \\{square}HK");
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof");
        $t3->erase;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("In the triangle ABC, EF and BC are parallel, thus BE is to EA as CF is to FA (VI.2)");
        grey_shit();
        $t{ABC} = Triangle->join($p{A},$p{B},$p{C})->fill($colour1);
        $l{EF}->normal; 
        $t3->math("BE:EA = CF:FA");      
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("In the triangle ACD, FG and CD are parallel, thus CF is to FA as DG is to GA (VI.2)");
        grey_shit();
        $t{ACD} = Triangle->join($p{A},$p{D},$p{C})->fill($colour1);
        $l{FG}->normal; 
        $t3->math("CF:FA = DG:GA");      
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, BE is to EA as DG is to GA");
        $t3->math("BE:EA = DG:GA");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore (componendo) BA is to EA as DA is to AG (V.18)");
        $t3->grey([0..20]);
        $t3->black(-1);
        $t3->math("(BE+EA):EA = (DG+GA):GA");
        $t3->math("BA:EA = DA:GA");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("and alternately BA is to DA so is AE to AG (V.16)");
        $t3->grey([0..20]);
        $t3->black(-1);
        $t3->math("BA:DA = EA:GA");
    };
    
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    push @$steps, sub {
        grey_shit();
        $t{AC}->normal;
        $t{EG}->normal;
        $t1->erase;
        $t1->title("Proof (cont)");
        $t1->explain("For the parallelograms ABCD, EG, the sides about the common angle BAD are proportional");
        $t3->erase;
        $t3->math("BA:DA = EA:GA");
        $t3->blue(-1);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since GF is parallel to DC, then angles AFG, DCA are equal");
        $l{AF} = Line->join($p{A},$p{F});
        $l{FG} = Line->join($p{F},$p{G});
        $l{CD} = Line->join($p{C},$p{D});
        $l{AC}->normal;
        $a{AFG} = Angle->new($pn,$l{AF},$l{FG})->label("\\{phi}",55);
        $a{ACD} = Angle->new($pn,$l{AC},$l{CD})->label("\\{theta}",55);
        $t3->math("\\{phi} = \\{theta}");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("and angle GAF is common to both triangles AGF and ADC, therefore these ".
        "two triangles are equiangular");
        grey_shit();
        $t{ACD}->normal;
        $t{AFG} = Triangle->join($p{A},$p{F},$p{G})->fill($colour2)->raise;
        $t3->math("\\{triangle}AGF equiangular to \\{triangle}ADC");
        $a{AFG}->normal;
        $a{ACD}->normal;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("For the same reason triangle ACB is equiangular with triangle AFE");
        grey_shit();
        $t{ABC}->normal;
        $t{AGE} = Triangle->join($p{A},$p{F},$p{E})->fill($colour2)->raise;
        $t3->math("\\{triangle}AFE equiangular to \\{triangle}ACB");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So the whole parallelogram AF is equiangular to the parallelogram ABCD");
        grey_shit();
        $t{AC}->normal;
        $t{EG}->normal;
        $l{AC}->normal;
        $t3->math("\\{square}ABCD equiangular to \\{square}EG");        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And the sides of the equiangular triangles are in proportion");
        $t3->grey([0..20]);
        $t3->black([2,3]);
        $t3->math("AD:DC = AG:GF");
        $t3->math("DC:CA = GF:FA");
        $t3->math("AC:CB = AF:FE");
        $t3->math("CB:BA = FE:EA");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("therefore (ex aequali) DC is to CB as GF is to FE (V.22)");
        $t3->grey([0..20]);
        $t3->black([-2,-3]);
        $t3->math("DC:CB = GF:FE");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, the sides about equal angles in the parallelograms ABCD, EG are proportional");
        $t3->grey([0..20]);
        $t3->black([0,5,8,9]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, the parallelograms ABCD and GE are similar (VI.Def.1)");
        $t3->black([0,4,5,8,9]);
        $t3->down;
        $t3->math("\\{square}ABCD ~ \\{square}GE");
    };
    
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof (cont)");
        $t3->erase;
        $t3->math("\\{square}ABCD ~ \\{square}GE");
        $t1->explain("Therefore, the parallelograms ABCD and GE are similar (VI.Def.1)");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Using the same logic, it can be shown that KH is similar to ABCD");
        $t3->math("\\{square}ABCD ~ \\{square}KH");
        grey_shit();
        $t{AC}->normal;
        $t{FK}->normal->raise;
        $l{AC}->normal;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But if two figures are similar to a third, they are ".
        "also similar to each other (VI.21)");
        $t3->math("\\{square}GE ~ \\{square}KH");
        $t{EG}->normal;
    };

    return $steps;

}

    sub grey_shit{
 #       print "_"x40,"\n";
        foreach my $type (\%l, \%t, \%a) {
            foreach my $o (keys %$type) {
                $type->{$o}->grey;
 #               print $type->{$o},": $o\n";
            }
        }
    } 

