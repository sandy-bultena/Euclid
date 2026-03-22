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
my $title = "Similar triangles are to one another in the duplicate ratio ".
"of the corresponding sides";

$pn->title( 19, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 450 );
my $t3 = $pn->text_box( 100, 150 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 19 );
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
    my $off = 100;
    my $yoff = 200;
    my $yh = 180;
    my $yb = 380;
    my $dx1 = 300;
    my $dx2 = 240;
    my $dx3 = 1.3*$dx2;
    my $xs = 100;
    my $k = 1.4;
    
    my @B = ($xs,$yb);
    my @A = ($xs+$dx2,$yh);
    my @C = ($xs+$dx1,$yb);
    my @E = ($C[0]+$off,$yb);
    my @F = ($E[0]+$dx1/$k,$yb);
    my @D = ($E[0]+$dx2/$k,$yb-($yb-$yh)/$k);
    
    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;

    push @$steps, sub {
        $t3->down;
        $t3->title("Definition - Duplicate Ratio (V.Def.9)");
        $t3->down;
        $t1->y($t3->y);
        $t3->explain("If A is to B as B is to C, then the ratio of A to C is the ".
        "duplicate ratio of A to B");
        $t3->down;
        $t1->math("A:B=B:C \\{then} A:C duplicate ratio of A:B");

        $t1->down(15);
        $t1->fancy("Examples:");
        my $y = $t1->y;
        $t1->math("4:6 = 6:9");
        my $y2 = $t1->y;
        $t1->y($y);
        $t1->explain("                           (both equal 2:3)");
        $t1->y($y2);
        $t1->math("\\{therefore} 4:9 is duplicate ratio of 2:3 ");
        $t1->down;
 
        $y = $t1->y;
        $t1->math("4:10 = 10:25");
        $y2 = $t1->y;
        $t1->y($y);
        $t1->explain("                                  (both equal 2:5)");
        $t1->y($y2);
        $t1->math("\\{therefore} 4:25 is duplicate ratio of 2:5 ");
        $t1->down;
        
        $t1->fancy("Fractions:");
            $t3->y($t1->y);        
        $t1->y( $t3->y);
        $t3->explain("Using fractions, if 'a' over 'b' equals 'b' over 'c', what is 'a' over 'c' ?");
        $t1->math("a   b   a   ");
        $t1->down(-28);
        $t1->math("_   _,  _ ");
        $t1->down(-20);
        $t1->math("  =       = ?");
        $t1->down(-15);
        $t1->math("b   c   c");
        $t1->down(10);
                
        $t3->y( $t1->y);
        $t3->explain("Multiply both sides of the equation by 'a' over 'b'");
        $t1->math("a a   b a    a\\{times}a   1 a   a\\{^2}   a");
        $t1->down(-28);
        $t1->math("_ _   _ _    ___   _ _   _    _");
        $t1->down(-20);
        $t1->math(" \\{times}  =  \\{times}         =  \\{times}       =");
        $t1->down(-15);
        $t1->math("b b   c b    b\\{times}b   c 1   b\\{^2}   c");
        $t1->down(10);

        $t1->down;
        $t3->y($t1->y);
        $t3->explain("Thus the duplicate ratio can be written as:");
        $t1->math("A:B = B:C \\{then} A:C = (A:B)\\{squared}");

        $t1->down;
        $t1->down;

    };
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t3->erase;
        $t3->y($t2->y);
        $t1->down;
        $t1->title("In other words");
        $t1->explain("If there are two triangles which are similar (equal angles, ".
        "sides proportional), then the ratio of the areas of the triangles is the square ".
        "of the ratio of the sides");



        $p{A} = Point->new($pn,@A[0,1])->label("A","top");
        $p{B} = Point->new($pn,@B[0,1])->label("B","bottom");
        $p{C} = Point->new($pn,@C[0,1])->label("C","bottom");
        $p{D} = Point->new($pn,@D[0,1])->label("D","top");
        $p{E} = Point->new($pn,@E[0,1])->label("E","bottom");
        $p{F} = Point->new($pn,@F[0,1])->label("F","bottom");

        $t{B} = Polygon->join(3,$p{B},$p{A},$p{C})->fill($colour1);
        $t{E} = Polygon->join(3,$p{E},$p{D},$p{F})->fill($colour2);
        ($l{AB},$l{AC},$l{BC}) = $t{B}->lines;
        ($l{DE},$l{DF},$l{EF}) = $t{E}->lines;
        
        $a{B} = Angle->new($pn,$l{BC},$l{AB})->label("\\{alpha}",30);
        $a{E} = Angle->new($pn,$l{EF},$l{DE})->label("\\{alpha}",30);
        
        
        $t3->math("\\{triangle}ABC ~ \\{triangle}DEF") -> blue;
        $t3->math("\\{then} \\{triangle}ABC:\\{triangle}DEF = (AB:DE)\\{squared}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t3->erase;
        $t3->y($t2->y);
        $t3->math("\\{triangle}ABC ~ \\{triangle}DEF") -> blue;
    };
    
    push @$steps, sub {
        $t1->explain("Construct a third proportional BG such that BC to EF is EF to BG (VI.11)");
        $l{BG} = Line->third_mean($l{BC},$l{EF},$p{B},0,-1);
        $p{G} = Point->new($pn,$l{BG}->end)->label("G","bottom");
        $t3->math("BC:EF = EF:BG");
    };
    
    push @$steps, sub {
        $t1->explain("Draw the line AG");
        $l{AG} = Line->join($p{A},$p{G});
    };
    
    push @$steps, sub {
        $t1->explain("As AB is to BC, so is DE to EF, or alternately, AB is to DE as BC is to EF (V.16)");
        $t3->grey(1);
        $t3->math("AB:BC = DE:EF");
        $t3->math("AB:DE = BC:EF");
    };
    
    push @$steps, sub {
        $t1->explain("Therefore, AB is to DE as EF is to BG (V.11)");
        $t3->black(1);
        $t3->grey(2);
        $t3->math("AB:DE = EF:BG");
    };
    
    push @$steps, sub {
        $t1->explain("The sides about the the equal angle in triangles ABG and DEF are reciprocally proportional");
        $t{B}->grey;
        $t{G} = Triangle->join($p{B},$p{A},$p{G})->fill($colour3); 
    };
    
    push @$steps, sub {
        $t1->explain("And triangles whose sides are reciprocally proportional about an".
        " equal angle, are also equal (VI.15)");
        $t3->grey([0..3]);
        $t3->math("\\{triangle}ABG = \\{triangle}DEF");
   };
    
    push @$steps, sub {
        $t1->explain("Since BC is to EF is as EF is to BG, the ratio BC to BG is the duplicate ratio of ".
        "BC to EF (V.Def.9)");
        $t3->grey([0..10]);
        $t3->black(1);
        $t3->math("BC:BG = (BC:EF)\\{squared}");
   };
    
    push @$steps, sub {
        $t{E}->grey;
        $t{B}->normal;
        $t{G}->raise;
        $t1->explain("The ratio of the triangles ABC and ABG is proportional to the bases, BC and BG (VI.1)");
        $t3->grey([0..10]);
        $t2->math("\\{triangle}ABC:\\{triangle}ABG = BC:BG");
   };
    
    push @$steps, sub {
        $t1->explain("Thus the ratio of BC to BG is the duplicate ratio of BC to EF");
        $t2->math("\\{triangle}ABC:\\{triangle}ABG = (BC:EF)\\{squared}");
        $t3->black(6);
   };
    
    push @$steps, sub {
        $t1->explain("But ABG equals DEF, therefore the ratio of ABC to DEF is the ".
        "duplicate ratio of their sides");
        $t{G}->grey;
        $t3->grey(6);
        $t3->black(5);
        $t2->grey(0);
        $t2->math("\\{triangle}ABC:\\{triangle}DEF = (BC:EF)\\{squared}");
        $t{E}->normal;
   };
    
    push @$steps, sub {
        $t3->grey([0..10]);
        $t3->blue(0);
        $t2->grey([0..10]);
        $t2->black(2);
        $l{AG}->grey;
    };
    
    # -------------------------------------------------------------------------
    # Porism
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Porism");
        $t1->explain("If three straight lines are proportional (A is to B as B is to C)");
        $t1->explain("If a two similar figures are drawn on A and B");
        $t1->explain("Then the ratio of these two figures is equal to the ratio of A to\\{nb}C");


        $p{AA} = Point->new($pn,800,550)->label("A","left");
        $l{AA} = Line->new($pn,$p{AA}->coords,$p{AA}->x+100,$p{AA}->y);
        $p{BB} = Point->new($pn,1000,550)->label("B","left");
        $l{BB} = Line->new($pn,$p{BB}->coords,$p{BB}->x+200,$p{BB}->y);
        $p{CC} = Point->new($pn,800,600)->label("C","left");
        $l{CC} = Line->new($pn,$p{CC}->coords,$p{CC}->x+400,$p{CC}->y);
        $t3->grey([0..10]);
        $t2->grey([0..10]);
        $t2->down;
        $t1->down();
        $t1->math("A:B = B:C");
     };
    
    push @$steps, sub {
        $p{A2} = Point->new($pn,900,450);
        $p{A3} = Point->new($pn,900,550);
        $t{A} = Triangle->join($p{AA},$p{A3},$p{A2})->fill($sky_blue);
        $p{B2} = Point->new($pn,1200,350);
        $p{B3} = Point->new($pn,1200,550);
        $t{B} = Triangle->join($p{BB},$p{B3},$p{B2})->fill($lime_green);
        $t1->math("\\{triangle}A:\\{triangle}B = A:C");
    };
    

    

    return $steps;

}

