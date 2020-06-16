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
my $title = "If two triangles have one angle equal to one angle and the sides ".
"about the equal angles proportional, the triangles will be equiangular and ".
"will have those angles equal which the corresponding sides subtend.";

$pn->title( 6, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 150 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 6 );
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
    my $off = 250;
    my $yh = 200;
    my $yb = 400;
    my $dx1 = 50;
    my $dx2 = 150;
    my @B = (100,$yb);
    my @A = ($B[0]+$dx1,$yh);
    my @C = ($A[0]+$dx2,$yb);
    
    my @D = ($A[0]+$off,$A[1]);
    my @E = ($D[0]-$dx1*.85,$yh-($yh-$yb)*.85);
    my @F = ($D[0]+$dx2*.85,$yh-($yh-$yb)*.85);
    

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("If two triangles have one angle that is equal between them, ".
        "AND the ratio of the sides of ".
        "around that angle are also equal, then the two triangles are equiangular");

        $p{A} = Point->new($pn,@A)->label("A","top");
        $p{B} = Point->new($pn,@B)->label("B","bottom");
        $p{C} = Point->new($pn,@C)->label("C","bottom");
        $p{D} = Point->new($pn,@D)->label("D","top");
        $p{E} = Point->new($pn,@E)->label("E","bottom");
        $p{F} = Point->new($pn,@F)->label("F","bottom");
            
        $t{ABC} = Triangle->join($p{A},$p{B},$p{C})->fill($sky_blue);
        $l{AB} = $t{ABC}->lines->[0]->blue;
        $l{AC} = $t{ABC}->lines->[2]->blue;
        $l{BC} = $t{ABC}->lines->[1];
        $t{DEF} = Triangle->join($p{D},$p{E},$p{F})->fill($lime_green);
        $l{DE} = $t{DEF}->lines->[0]->blue;
        $l{EF} = $t{DEF}->lines->[1];
        $l{DF} = $t{DEF}->lines->[2]->blue;
        
        $a{alpha} = Angle->new($pn,$l{BC},$l{AB}, -size=>30)->label("\\{alpha}");
        $a{beta} = Angle->new($pn,$l{AC},$l{BC}, -size=>20)->label("\\{beta}");
        $a{gamma} = Angle->new($pn,$l{AB},$l{AC}, -size=>20)->label("\\{gamma}");
        
        $a{c} = Angle->new($pn,$l{DE},$l{DF}, -size=>30)->label("\\{gamma}");
        $a{b} = Angle->new($pn,$l{DF},$l{EF}, -size=>20)->label("\\{epsilon}");
        $a{a} = Angle->new($pn,$l{EF},$l{DE}, -size=>20)->label("\\{delta}");  
        
        $t4->math("       AB:AC = DE:DF");
        $t3->math("\\{alpha} = \\{delta}, \\{beta} = \\{epsilon}");
        $t4->blue([0..2]);
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase();
        $t1->down;
        $t1->title("Proof");
        $t3->erase();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("On the point D, construct an angle FDG on the ".
        "line DF equal to the angle \\{gamma} (I.23)");
        ($l{DGx},$a{gamma2}) = $a{gamma}->copy($p{D},$l{DF},'positive',-1);
        $a{gamma2}->label("\\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("On the point F, construct an angle DFG on the line ".
        "DF equal to the angle \\{beta} (I.23)");
        ($l{FGx},$a{beta2}) = $a{beta}->copy($p{F},$l{DF},'negative',-1);
        $a{beta2}->label("\\{beta}");
        
        my @p = $l{FGx}->intersect($l{DGx});
        $p{G} = Point->new($pn,@p)->label("G","right");
        $l{FG} = Line->join($p{F},$p{G});
        $l{FGx}->remove;
        $l{DG} = Line->join($p{D},$p{G});
        $l{DGx}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And thus, the angle at G will also be the angle at B (I.32)");
        $a{alpha2} = Angle->new($pn,$l{DG},$l{FG},-size=>20)->label("\\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the triangle ABC is equiangular to DFG, and as such, ".
        "the edges surrounding the equal angles will be in proportion, ".
        "i.e. AB is to AC as DG to DF (VI.4)");
        $t{DFG} = Triangle->join($p{D},$p{F},$p{G})->fill($pale_yellow);
        $t3->math("AB:AC = DG:DF"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But the ratio AB to AC is equal to DE to DF, therefore ".
        "the ratio DE to DF equals DG to DF (V.11)");
        $t3->math("DE:DF = DG:DF"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since DE and DG have the same ratio to DF, "."DE and DG are equal (V.9)");
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("DE = DG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since ED equals DG, and DF is common, and the angles EDF and FDG ".
        "are equal, triangle DEF is equal to the triangle DGF in all respects (I.4)");
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("EF = FG");
        $t3->math("\\{alpha} = a");
        $t3->math("\\{beta} = b");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So finally, the triangle DEF is equiangular to triangle ABC");
        $t3->allgrey;
        $t3->black([-1,-2]);
    };
    

    return $steps;

}

