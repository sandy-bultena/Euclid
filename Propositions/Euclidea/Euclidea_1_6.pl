#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;


# ============================================================================
# Definitions
# ============================================================================
my $title = "Find the centre of a circle ".
"(-L 5E)";

$pn->title( 6, $title, '1' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 500 );
my $t3 = $pn->text_box( 500, 220 );
my $t2 = $pn->text_box( 520, 200 );

my $steps = explanation($pn);
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my ( %l, %p, %c, %s, %a );
    my $k = 2;
    my @A = (200, 350);
    my @B = (200, 550);
    my @E = (150, 250);
    my @C = (350, 200);
    my @D = (550, 200);
    my @F = (350, 250);
    my $r1 = 120;

    my @c = ( 240, 400 );
    my $r = 180;

    push @$steps, sub {
        $c{1} = Circle->new($pn,@A,@B)->green;
    };
    
    # -------------------------------------------------------------------------
    # Steps
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Steps");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e1) Draw a circle with the centre on some point of the original, and ".
        "label the intersection points B,C");
        $p{A} = Point->new($pn,@B)->label("A","bottom");
        $c{A} = Circle->new($pn,@B,$B[0],$B[1]+$r1);
        my @p = $c{A}->intersect($c{1});
        $p{B} = Point->new($pn,@p[2,3])->label("B","bottom");
        $p{C} = Point->new($pn,@p[0,1])->label("C","bottom");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e2) Draw a second circle with radius AB, with the centre ".
        "at B, intersect circle A at point D,E");
        my @p = $c{A}->intersect($c{1});
        $c{B} = Circle->new($pn,@p[2,3,2],$p[3]+$r1);        
        @p = $c{A}->intersect($c{B});
        $p{D} = Point->new($pn,@p[0,1])->label("D");        
        $p{E} = Point->new($pn,@p[2,3])->label("E");  
        $c{A}->grey;      
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e3) Draw a line through CD, intersecting original circle at F");
        $l{CD} = Line->join($p{C},$p{D})->extend(200)->prepend(50);
        my @p = $c{1}->intersect($l{CD});
        $p{F} = Point->new($pn,@p[0,1])->label("F");
        $c{B}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e4) Construct a circle with F as the centre, and FB as the ".
        "radius");
        $c{F} = Circle->new($pn,$p{F}->coords,$p{B}->coords);    
        $l{CD}->grey;    
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e5) Draw a line through ED");
        $l{ED}=Line->join($p{E},$p{D})->extend(250)->prepend(40);
        $c{F}->grey;       
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Circle F will intersect ED at point D, and the center of the "
        ."original circle");
        $p{O} = Point->new($pn,@A)->label("O");
        $l{ED}->grey;
        foreach my $point (qw(A B C D E F)) {
            $p{$point}->grey;
        }
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        foreach my $point (qw(A B C)) {
            $p{$point}->normal;
        }
        $t1->erase;
        $t1->title("Proof");
        $t1->explain("AC,AB are both equal to the radius of the small circles");
        $t3->math("AC = AB = r");
        $l{AC} = Line->join($p{A},$p{C});
        $l{AB} = Line->join($p{A},$p{B});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore angles AOC and AOB are equal");
        $l{OA} = Line->join($p{O},$p{A});
        $l{OB} = Line->join($p{O},$p{B});
        $l{OC} = Line->join($p{O},$p{C});
        $a{COA} = Angle->new($pn,$l{OC},$l{OA},-size=>20)->label("\\{theta}");
        $a{AOB} = Angle->new($pn,$l{OA},$l{OB})->label("\\{theta}");
        $t3->math("\\{angle}AOC = \\{angle}AOB = \\{theta}");
        $t3->math("\\{angle}COB = 2\\{theta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AB}->remove;
        $l{AC}->remove;
        $l{OA}->remove;
        $a{COA}->remove;
        $a{AOB}->remove;
        $a{COB} = Angle->new($pn,$l{OC},$l{OB},-size=>10)->label("2\\{theta}");
        $p{P} = $c{1}->point(20)->label("P","right");
        $l{PC} = Line->join($p{P},$p{C});
        $l{PB} = Line->join($p{P},$p{B});
        $a{CPB} = Angle->new($pn,$l{PC},$l{PB})->label("\\{theta}");
        $t1->explain("For any point P on the circumference of the circle, the angle CPB ".
        "will be half of angle COB");
        $t3->math("\\{angle}CPB = \\{theta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So, the angle CFB is also equal to the angle COB");
        $p{P}->remove;
        $l{PC}->remove;
        $l{PB}->remove;
        $a{CPB}->remove;
        $p{F}->normal;
        $l{CF} = Line->join($p{C},$p{F});
        $l{BF} = Line->join($p{B},$p{F});
        $a{CFB} = Angle->new($pn,$l{CF},$l{BF})->label("\\{theta}");
        $t3->math("\\{angle}CFB = \\{theta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof (cont.)");
        $t1->explain("So, the angle CFB is also equal to the angle COB");
        foreach my $point (qw(C F)) {
            $p{$point}->grey;
        }
        $p{D}->normal;
        $a{COB}->remove;
        $l{OC}->remove;
        $l{OB}->remove;
        $l{OA}->remove;
        $l{CF}->remove;
        $l{BF}->remove;
        $a{CFB}->remove;
        $t3->down;
        $t1->down;
        $t1->explain("Triangle ABD is an equilateral triangle");
        $t3->math("AB = BD = DA = r");
        $l{AB} = Line->join($p{A},$p{B});
        $l{BD} = Line->join($p{B},$p{D});
        $l{DA} = Line->join($p{D},$p{A});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a line through the midpoint of DB and A");
        $t1->explain("This line will be perpendicular to BD because ABD is equilateral");
        $l{AF} = Line->join($p{A},$p{F});
        $p{Fp} = Point->new($pn,$p{F}->coords)->label("P","right");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("DPB is split into two equal triangles");
        $l{AB}->remove;
        $l{DA}->remove;
        $l{DF}=Line->join($p{D},$p{F});
        $l{FB} = Line->join($p{F},$p{B});
        $a{DFA} = Angle->new($pn,$l{DF},$l{AF},-size=>50)->label("\\{alpha}");;
        $a{AFB} = Angle->new($pn,$l{AF},$l{FB})->label("\\{alpha}");
        $t3->math("\\{angle}DPA = \\{angle}APB = \\{alpha}");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But angle APB will be half of AOB");
        $l{DF}->remove;
        $l{BD}->remove;
        $p{D}->grey;
        $l{OA}=Line->join($p{O},$p{A});
        $l{OB}=Line->join($p{O},$p{B});
        $a{AOB} = Angle->new($pn,$l{OA},$l{OB})->label("\\{theta}");
        $t3->math("\\{alpha} = \\{half}\\{theta}");
        $a{DFA}->remove;
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the angle DFB will be equal to angle AOB");
        $t3->math("\\{angle}DPB = 2\\{alpha} = \\{theta}");
        $p{D}->normal;
        $l{DF}->draw;
        $l{BD}->draw;
        $a{DFA}->draw; 
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The bases AB,DB are equal, and the two isoceles triangle have the ".
        "same angles, the two triangles DPB and AOB are equal");
        $l{AF}->remove;
        $l{AB}=Line->join($p{A},$p{B});
        $a{DFA}->remove;
        $a{AFB}->remove;
        $a{DFB} = Angle->new($pn,$l{DF},$l{FB})->label("\\{theta}");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore DP and OA are both equal, and if a circle is drawn ".
        "with a centre at P, with radius DP, the circumference will pass through 'O' ".
        "the centre of the original circle");
        $t3->math("DP = OA");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof (cont.)");
        $t1->explain("So, the angle CFB is also equal to the angle COB");
        $t1->down;
        $t1->explain("Therefore DP and OA are both equal, and if a circle is drawn ".
        "with a centre at P, with radius DP, the circumference will pass through 'O' ".
        "the centre of the original circle");
        $l{OA}->remove;
        $l{OB}->remove;
        $l{AB}->remove;
        $a{AOB}->remove;
        $l{BD}->remove;
        $l{CD}=Line->join($p{C},$p{D});
        $p{C}->normal;
        $t1->down;
        $t1->explain("Any angle on the circumference of size \\{theta} passing through ".
        "the point B will also pass through the point C, therefore DP and DC are collinear");
        $t3->math("\\{angle}CDP = 180 \\{degrees}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("In other words, F is the same point as P");
        $t3->math("P = F");
        $p{F}->normal;
        $p{Fp}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("A perpendicular line through the midpoint of AB will pass ".
        "through the centre of the original circle");
        $l{CD}->remove;
        $l{DF}->remove;
        $l{FB}->remove;
        $a{DFB}->remove;
        $l{AB}->draw;
        $l{ED}->normal;
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("The circle FD will also pass through the centre of the original ".
        "circle");
        $c{F}->normal;
        $l{AB}->remove;
    };
        


    return $steps;

}

