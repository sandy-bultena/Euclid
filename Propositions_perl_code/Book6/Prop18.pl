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
my $title = "On a given straight line to describe a rectilineal figure similar ".
"and similarly situated to a given rectilineal figure.";

$pn->title( 18, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 18 );
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
    my $yoff = 100;
    my $y0 = 180;
    my $y1 = $y0+$yoff;
    my $y2 = $y1+$yoff;
    my $dx1 = 300;
    my $dx2 = 40;
    my $dx3 = 4.5*$dx2;
    my $xs = 100;
    my $k = 1.4;
    
    my @C = ($xs,$y2);
    my @D = ($xs+$dx1,$y2);
    my @F = ($xs+$dx2,$y1);
    my @E = ($F[0]+$dx3,$y0);
    my @A = ($D[0]+$off,$y2);
    my @B = ($A[0]+$dx1/$k,$y2);
    my @G = ($A[0]+$dx2/$k,$y2-$yoff/$k);
    my @H = ($G[0]+$dx3/$k,$y2-2*$yoff/$k);
    
    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;
    my $y;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Copy one figure onto another straight line so that both figures are similar, ".
        "i.e. equiangular and proportional sides");
        $p{A} = Point->new($pn,@A[0,1])->label("A","bottom");
        $p{B} = Point->new($pn,@B[0,1])->label("B","bottom");
        $p{C} = Point->new($pn,@C[0,1])->label("C","bottom");
        $p{D} = Point->new($pn,@D[0,1])->label("D","bottom");
        $p{E} = Point->new($pn,@E[0,1])->label("E","top");
        $p{F} = Point->new($pn,@F[0,1])->label("F","left");
        $p{G} = Point->new($pn,@G[0,1])->label("G","left");
        $p{H} = Point->new($pn,@H[0,1])->label("H","top");
        $l{AB} = Line->join($p{A},$p{B});

        $t{C} = Polygon->join(4,$p{C},$p{F},$p{E},$p{D})->fill($colour1);
        $t{A} = Polygon->join(4,$p{A},$p{G},$p{H},$p{B})->grey;
        
        $t3->math("\\{square}CDEF ~ \\{square}ABHG");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Construction");
        $t3->erase;
        $t{A}->remove;
        $p{G}->remove;
        $p{H}->remove;
    };
    
    push @$steps, sub {
        $t1->explain("Let line DF be drawn");
        $l{DF} = Line->join($p{D},$p{F});
    };
    
    push @$steps, sub {
        $t1->explain("Copy the angle FCD to point A on line AB (I.23)");
        $l{CF} = $t{C}->lines->[0];
        $l{CD} = $t{C}->lines->[3];
        $a{FCD} = Angle->new($pn,$l{CD},$l{CF},-size=>20)->label("c");
        ($l{AGx},$a{GAB}) = $a{FCD}->copy($p{A},$l{AB},undef,-1);
        $l{AGx}->extend(100)->dash;
        $a{GAB}->label("c",20);
        $t3->math("\\{angle}FCD = \\{angle}GAB = c");
    };

    push @$steps, sub {
        $t1->explain("Copy the angle CDF to point B on line AB (I.23)");
        $a{CDF} = Angle->new($pn,$l{DF},$l{CD},-size=>40)->label("d");
        ($l{BGx},$a{ABG}) = $a{CDF}->copy($p{B},$l{AB},"negative",-1);
        $l{BGx}->dash->extend(220);
        $a{ABG}->label("d",40);
        $t3->math("\\{angle}CDF = \\{angle}ABG = d");
        $p{G}->draw;
    };

    push @$steps, sub {
        $t{C}->grey;
        $t{CDF} = Triangle->join($p{C},$p{D},$p{F})->fill($colour2);
        $a{CDF}->normal;
        $a{FCD}->normal;
        $t{AGB} = Triangle->join($p{A},$p{B},$p{G})->fill($colour2);
        $a{ABG}->normal;
        $a{GAB}->normal;
        $l{AGx}->remove;
        $l{BGx}->remove;
        
        $l{AG} = $t{AGB}->lines->[2];
        $l{AB} = $t{AGB}->lines->[0];
        $l{BG} = $t{AGB}->lines->[1];
    };

    push @$steps, sub {
        $t1->explain("On the straight line BG, construct BGH equal to angle DFE and ".
        "angle GBH equal to angle FDE (I.23)");
        $l{EF} = $t{C}->lines->[1];
        $l{DE} = $t{C}->lines->[2];
        $a{EFD} = Angle->new($pn,$l{DF},$l{EF},-size=>30)->label("\\{phi}");
        ($l{GHx},$a{BGH}) = $a{EFD}->copy($p{G},$l{BG},undef,-1);
        $l{GHx}->dash;
        $a{BGH}->label("\\{phi}",30);
        $t3->math("\\{angle}DFE = \\{angle}BGH = \\{phi}");
        $p{H}->draw;
        $a{FDE} = Angle->new($pn,$l{DE},$l{DF},-size=>30)->label("\\{delta}");
        ($l{BHx},$a{GBH}) = $a{FDE}->copy($p{B},$l{BG},"negative",-1);
        $l{BHx}->dash->extend(200);
        $a{GBH}->label("\\{delta}",30);
        $t3->math("\\{angle}FDE = \\{angle}GBH = \\{delta}");
    
    };

    push @$steps, sub {
        $t{C}->grey;
        $t{FED} = Triangle->join($p{F},$p{E},$p{D})->fill($colour3);
        $a{FDE}->normal;
        $a{EFD}->normal;
        $t{GHB} = Triangle->join($p{G},$p{H},$p{B})->fill($colour3);
        $l{BH} = $t{GHB}->lines->[1];
        $l{GH} = $t{GHB}->lines->[0];
        $a{BGH}->normal;
        $a{GBH}->normal;
        $l{GHx}->remove;
        $l{BHx}->remove;
    };

    push @$steps, sub {
        $t1->down;
        $t3->down;        
        $t4->y($t3->y);
        $t1->explain("The rectilineal figure ABHG is similar to CDEF");
        $t4->math("\\{square}CDEF ~ \\{square}ABHG");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t4->erase;
    };   

    push @$steps, sub {
        $t{FED}->fill();
        $t{GHB}->fill();
        $t1->explain("Compare triangles FCD and GAB, the remaining angle AGB is equal to the angle CFD (I.32), "
        ."thus the two triangles are equiangular");
        $a{DFC} = Angle->new($pn,$l{CF},$l{DF})->label("f",20);
        $a{BGA} = Angle->new($pn,$l{AG},$l{BG})->label("f",20);
        
        $t3->math("\\{angle}CFD = \\{angle}AGB = f");
    };

    push @$steps, sub {
        $t1->explain("Thus the sides of FCD and GAB are proportional (VI.4)");
        $t3->math("FD:GB = FC:GA = CD:AB");
    };

    push @$steps, sub {
        $t1->explain("Compare the triangles FED and GHB, the remaining angle GHB is equal to the angle FED (I.32), "
        ."thus the two triangles are equiangular");
        $t{FED}->fill($colour3);
        $t{GHB}->fill($colour3);
        $t{CDF}->fill();# = Triangle->join($p{C},$p{D},$p{F})->fill($colour2);
        $t{AGB}->fill();# = Triangle->join($p{A},$p{B},$p{G})->fill($colour2);
        $a{FED} = Angle->new($pn,$l{EF},$l{DE})->label("\\{epsilon}",20);
        $a{GHB} = Angle->new($pn,$l{GH},$l{BH})->label("\\{epsilon}",20);
        
        $t3->math("\\{angle}GHB = \\{angle}FED = \\{epsilon}");
    };

    push @$steps, sub {
        $t1->explain("Thus the sides of FED and GHB are proportional (VI.4)");
        $t3->math("FD:GB = FE:GH = ED:BH");
    };

    push @$steps, sub {
        $t{FED}->fill();
        $t{GHB}->fill();
        $t{CDF}->fill();# = Triangle->join($p{C},$p{D},$p{F})->fill($colour2);
        $t{AGB}->fill();# = Triangle->join($p{A},$p{B},$p{G})->fill($colour2);
        $t1->explain("The ratio of FD to GB is simultaneously equal to the ratios of "
        ."the sides FC,AG, CD,AB, FE,GH and ED,HB");
        $t3->grey([0..4,6]);
        $t3->blue([5,7]);
        $t2->math("FD:GB = FC:AG = CD:AB");
        $t2->math("      = FE:GH = ED:HB");
    };

    push @$steps, sub {
        $t3->grey([0..20]);
        $t3->blue([2,4]);
        $t1->explain("The angles at AGB,BGH are equal to the angles at CFD,DFE, so their sums ".
        "are also equal, therefore angle CFE equals AGH");
        $y = $t2->y;
        $t2->math("\\{angle}AGH = \\{angle}CFE = f + \\{phi}");
    };

    push @$steps, sub {
         $a{F} = Angle->new($pn,$l{CF},$l{EF})->label("f'",20);
        $a{G} = Angle->new($pn,$l{AG},$l{GH})->label("f'",20);
        $a{BGA}->remove;
        $a{BGH}->remove;
        $a{DFC}->remove;
        $a{EFD}->remove;
        $t2->y($y);
        $t2->math("                    = f'");
    };

    push @$steps, sub {
        $t3->grey([0..20]);
        $t3->blue([1,3]);
        $t1->explain("The angles at ABG,GBH are equal to the angles at CDF,FDE, so their sums ".
        "are also equal, therefore angle ABH equals CDE");
        $y = $t2->y;
        $t2->math("\\{angle}ABH = \\{angle}CDE = d + \\{delta}");
    };

    push @$steps, sub {
        $a{FDE}->remove;
        $a{GBH}->remove;
        $a{CDF}->remove;
        $a{ABG}->remove;
        $a{D} = Angle->new($pn,$l{DE},$l{CD})->label("d'",20);
        $a{B} = Angle->new($pn,$l{BH},$l{AB})->label("d'",20);        
        $t2->y($y);
        $t2->math("                    = d'");
        $t{CDF}->grey;
        $t{AGB}->grey;
        $t{FED}->grey;
        $t{GHB}->grey;
        $l{DF}->grey;
        $t{A}->draw->normal;
        $t{C}->normal->fill();
    };

    push @$steps, sub {
        $t1->down;
        $t1->explain("If the angles are all equal, and the sides about the equal angles ".
        "are proportional, then the two figures are similar (VI.Def.1)");
        
        $t{A}->fill($colour1);
        $t{C}->fill($colour1);
        
        $t3->black([0..20]);
        $t2->down;
        $t2->math("\\{square}CDEF ~ \\{square}ABHG");
        
    };
    

    return $steps;

}

