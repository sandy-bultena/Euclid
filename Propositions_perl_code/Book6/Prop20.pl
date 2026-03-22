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
my $title = "Similar polygons are divided into similar triangles, and into ".
"triangles equal in multitude and in the same ratio as the wholes, and the ".
"polygon has to the polygon a ratio duplicate of that which the corresponding ".
"side has to the corresponding side.";

$pn->title( 20, $title, 'VI' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $tdot = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4 = $pn->text_box( 100, 450 );
my $t3 = $pn->text_box( 100, 450 );
my $t2 = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 20 );
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
    my $off = 200;
    my $yoff = 200;
    my $yh = 150;
    my $ym = 260;
    my $yb = 380;
    my $dx1 = 180;
    my $dx2 = -100;
    my $dx3 = 20;
    my $dx4 = 20;
    my $xs = 150;
    my $k = 1/1.1;
    
    my @C = ($xs,$yb);
    my @D = ($xs+$dx1,$yb);
    my @B = ($C[0]+$dx2,$ym);
    my @A = ($C[0]+$dx3,$yh);
    my @E = ($D[0]+$dx4,$ym);
    
    my @H = ($D[0]+$off,$yb);
    my @K = ($H[0]+$k*$dx1,$yb);
    my @G = ($H[0]+$k*$dx2,$yb+$k*($ym-$yb));
    my @F = ($H[0]+$k*$dx3,$yb+$k*($yh-$yb));
    my @L = ($K[0]+$k*$dx4,$yb+$k*($ym-$yb));    
    
    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;

    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
   #     $t1->down;
        $t1->title("In other words");
        $t1->explain("If there are two polygons which are similar (equal angles, ".
        "sides proportional), ");
        $t1->explain("then the polygons can be divided into an equal number of ".
        "similar triangles");
        $t1->explain("And the ratio of all the triangles are equal, which is also ".
        "equal to the ratio of the original polygons");
        $t1->explain("And finally, the ratio of the areas of the polygons is in ".
        "duplicate ratio to the ratio of the sides");

        $p{A} = Point->new($pn,@A[0,1])->label("A","top");
        $p{B} = Point->new($pn,@B[0,1])->label("B","left");
        $p{C} = Point->new($pn,@C[0,1])->label("C","bottom");
        $p{D} = Point->new($pn,@D[0,1])->label("D","bottom");
        $p{E} = Point->new($pn,@E[0,1])->label("E","right");
        $p{F} = Point->new($pn,@F[0,1])->label("F","top");
        $p{G} = Point->new($pn,@G[0,1])->label("G","left");
        $p{H} = Point->new($pn,@H[0,1])->label("H","bottom");
        $p{K} = Point->new($pn,@K[0,1])->label("K","bottom");
        $p{L} = Point->new($pn,@L[0,1])->label("L","right");

        $t{C} = Polygon->join(5,$p{C},$p{B},$p{A},$p{E},$p{D});
        $t{H} = Polygon->join(5,$p{H},$p{G},$p{F},$p{L},$p{K});
        ($l{BC},$l{AB},$l{AE},$l{DE},$l{CD}) = $t{C}->lines;
        ($l{GH},$l{FG},$l{FL},$l{KL},$l{HK}) = $t{H}->lines;
        
        $t{ABE} = Triangle->join($p{A},$p{B},$p{E})->fill($colour1);
        $t{BEC} = Triangle->join($p{B},$p{E},$p{C})->fill(Colour->new($colour1)->lighten(7));        
        $t{CED} = Triangle->join($p{C},$p{E},$p{D})->fill(Colour->new($colour1)->lighten(14));        

        $t{FGL} = Triangle->join($p{F},$p{G},$p{L})->fill($colour2);
        $t{GHL} = Triangle->join($p{G},$p{H},$p{L})->fill(Colour->new($colour2)->lighten(7));        
        $t{HLK} = Triangle->join($p{H},$p{L},$p{K})->fill(Colour->new($colour2)->lighten(14));        
        
        
        $t3->math("ABCDE ~ FGHKL") -> blue;
        $t3->math("\\{triangle}ABE ~ \\{triangle}FGL");
        $t3->math("\\{triangle}BEC ~ \\{triangle}GLH");
        $t3->math("\\{triangle}ECD ~ \\{triangle}LHK");
        $t3->down;
        $t3->math("\\{triangle}ABE:\\{triangle}FGL = \\{triangle}BEC:\\{triangle}LHK");
        $t3->math("   = \\{triangle}ECD:\\{triangle}GHK = ABCDE:FGHKL");
        $t3->down;
        $t3->math("ABCDE:FGHKL = (AB:FG)\\{squared}");
        
        
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
  #      $t1->down;
        $t1->title("Proof - Similar Triangles");
        $t3->erase;
        $t3->math("ABCDE ~ FGHKL") -> blue;
        
        $t{C}->fill($colour1);
        $t{H}->fill($colour2);

        $t{ABE}->grey;
        $t{BEC}->grey;        
        $t{CED}->grey;        

        $t{FGL}->grey;
        $t{GHL}->grey;        
        $t{HLK}->grey;        

        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw lines BE, EC, GL and LH");
        $l{BE} = Line->join($p{B},$p{E});
        $l{CE} = Line->join($p{C},$p{E});
        $l{GL} = Line->join($p{G},$p{L});
        $l{HL} = Line->join($p{H},$p{L});
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The two polygons are similar, therefore angle BAE is equal to angle GFL,");
        $t1->explain("and the ratio of BA to AE is equal to the ratio GF to FL (VI\\{dot}Def\\{dot}1)");
        $a{BAE} = Angle->new($pn,$l{AB},$l{AE})->label("\\{alpha}",10);
        $a{GFL} = Angle->new($pn,$l{FG},$l{FL})->label("a",10);
        $t3->math("a = \\{alpha}");
        $t3->math("AB:AE = FG:FL");
        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{ABE}->normal;
        $t{C}->grey;
        $l{CE}->grey;
        $t{FGL}->normal;
        $t{H}->grey;
        $l{HL}->grey;
        $t1->explain("Since ABE, FGL are two triangles with one equal angle and the ".
        "sides about the equal angle are proportional, the two triangles are equiangular (VI.6) ".
        "and similar (VI.4), (VI\\{dot}Def\\{dot}1)");
        $t1->explain("So angle ABE is equal to angle FGL");
        $t3->math("\\{triangle}ABE ~ \\{triangle}FGL, b' = \\{beta}'");
        $a{ABE} = Angle->new($pn,$l{BE},$l{AB})->label("\\{beta}'",20);
        $a{FGL} = Angle->new($pn,$l{GL},$l{FG})->label("b'",20);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But angle ABC is equal to angle FGH because the polygons ".
        "are similar, therefore the angles EBC and LGH are also equal");
        $l{BC}->normal;
        $l{GH}->normal;
        $a{EBC} = Angle->new($pn, $l{BC},$l{BE})->label(" \\{beta}".'" ',15);
        $a{LGH} = Angle->new($pn, $l{GH},$l{GL})->label(" b".'" ',15);
        $t3->math("b = b' + b\" = \\{beta} = \\{beta}' + \\{beta}\"");
        $t3->math("b\" = \\{beta}\"");
        $t3->grey([1,2]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Because the triangle ABE is similar to the triangle FGL, BE is to AB as GL is to GF");
        $t3->math("BE:AB = GL:FG");
        $t3->grey([0,1,2,4,5]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Again, because the polygons are similar, AB is to BC as FG is to GH");
        $t3->math("AB:BC = FG:GH");
        $t3->allgrey();
        $t3->blue([0]);
        $t3->black([-1]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("therefore BE is to BC as GL is to GH (V.22)");
        $t3->math("BE:BC = GL:GH");
        $t3->allgrey();
        $t3->black([-1,-2,-3]);
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{ABE}->grey;
        $t{BEC}->normal;
        $t{FGL}->grey;
        $t{GHL}->normal;
        $t1->explain("Since BEC, LGH are two triangles with one equal angle and the ".
        "sides about the equal angle are proportional, the two triangles are equiangular (VI.6) ".
        "and similar (VI.4), (VI\\{dot}Def\\{dot}1)");
        $a{ABE}->grey;;
        $a{FGL}->grey;
        $a{BAE}->grey;
        $a{GFL}->grey;
        $t3->allgrey;
        $t3->black([5,-1]);
        $t2->math("\\{triangle}BEC ~ \\{triangle}LGK");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("For the same reasons, the triangle ECD is similar to the triangle LHK");
        $t2->math("\\{triangle}ECD ~ \\{triangle}LHK");
        $t{BEC}->grey;
        $t{GHL}->grey;
        $l{GL}->grey;
        $l{GH}->grey;
        $l{BE}->grey;
        $l{BC}->grey;
        $t{CED}->normal;
        $t{HLK}->normal;
        $t3->allgrey;
        $a{EBC}->grey;
        $a{LGH}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("So the two similar polygon has been divided into similar triangles, equal ".
        "in multitude");
        $t{BEC}->normal;
        $t{GHL}->normal;
        $t{ABE}->normal;
        $t{FGL}->normal;
        $t{CED}->normal;
        $t{HLK}->normal;
        $t3->grey([1..20]);
        $t3->black(3);
        $t3->blue(0);
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
  #      $t1->down;
        $t1->title("Proof - Duplicate Ratio to Sides");
        $t3->erase;
        $t2->erase;
        
        $t{C}->remove;$t{C}->draw;
        $t{H}->remove;$t{H}->draw;

        $t{ABE}->grey;
        $t{BEC}->grey;        
        $t{CED}->grey;        

        $t{FGL}->grey;
        $t{GHL}->grey;        
        $t{HLK}->grey;        
        
        $t3->math("ABCDE ~ FGHKL") -> blue;
        $t3->math("b = \\{beta}")->blue(1);
        $t3->math("b' = \\{beta}'")->blue(2);
        $a{ABC} = Angle->new($pn,$l{BC},$l{AB})->label("\\{beta}",10);
        $a{FGH} = Angle->new($pn,$l{GH},$l{FG})->label("b",10);
        $t3->math("AB:BC = FG:GH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw AC, FH");
        $l{AC} = Line->join($p{A},$p{C});
        $l{FH} = Line->join($p{F},$p{H});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Triangle ABC is similar to FGH (VI.6)");
        $t{C}->grey;
        $t{H}->grey;
        $t{ABC} = Triangle->join($p{A},$p{B},$p{C})->fill($colour1);
        
        $t{FGH} = Triangle->join($p{F},$p{G},$p{H})->fill($colour2);
        $a{BAC} = Angle->new($pn,$l{AB},$l{AC})->label("\\{alpha}'",5);        
        $a{GFH} = Angle->new($pn,$l{FG},$l{FH})->label("a'",5);       
        $t3->math("a' = \\{alpha}'");

        $t3->allgrey;
        $t3->black([-1,-2]);
        $t3->blue(1);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the angles ABM and FGN are equal, and the angles ".
        "BAM and GFN are equal, the angles AMB and FNG are also equal (I.32)");
        $l{BE}->normal;
        $l{GL}->normal;
        my @p = $l{BE}->intersect($l{AC});
        $p{M} = Point->new($pn,@p)->label("M","bottomright");
        @p = $l{FH}->intersect($l{GL});
        $p{N} = Point->new($pn,@p)->label("N","bottomright");
        
        $a{ABC}->grey;
        $a{FGH}->grey;
        $a{ABE}->normal;
        $a{FGL}->normal;
        
        $l{AM} = Line->join($p{A},$p{M});
        $l{BM} = Line->join($p{B},$p{M});
        $a{AMB} = Angle->new($pn,$l{AM},$l{BM})->label("\\{eta}",5);

        $l{FN} = Line->join($p{F},$p{N});
        $l{GN} = Line->join($p{G},$p{N});
        $a{FNG} = Angle->new($pn,$l{FN},$l{GN})->label("n",5);
        
        $t3->math("n = \\{eta}");

        $t3->allgrey;
        $t3->black([-1,-2]);
        $t3->blue(2);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{FGH}->grey;
        $t{ABC}->grey;
        $t{ABM} = Triangle->join($p{A},$p{B},$p{M})->fill(Colour->new($colour1)->lighten(7));
        $t{FGN} = Triangle->join($p{F},$p{G},$p{N})->fill(Colour->new($colour2)->lighten(7));
        $t1->explain("Therefore triangle ABM is equiangular with triangle FGN and similar, so "
        ."the ratio of AM to MB is equal to FN to NG");
        $t3->math("AM:BM = FN:NG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        foreach my $a (sort keys %a) {$a{$a}->grey;}
        $t{ABM}->grey;
        $t{FGN}->grey;
        $t{BMC} = Triangle->join($p{C},$p{B},$p{M})->fill(Colour->new($colour1)->lighten(14));
        $t{GNH} = Triangle->join($p{H},$p{G},$p{N})->fill(Colour->new($colour2)->lighten(14));
        $t1->explain("Similarly we can prove that triangle BMC is also equiangular with triangle GNH, thus "
        ."BM is to MC as NG is to NH");
        $t3->math("BM:MC = NG:NH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("In addition, ex aequali, AM is to MC as is FN to NH");
        $t3->math("AM:MC = FN:NH");
        $t3->allgrey;
        $t3->black([-1,-2,-3]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But, the ratio of AM to MC is equal to the ratio of the triangles ABM to MBC ".
        "(VI.1)");
        $t2->math("AM:MC");
        $l{t2} = $t2->y;
        $t2->math(" = \\{triangle}ABM:\\{triangle}MBC ");
        $t{BMC}->normal;
        $t{ABM}->normal;
        $t{GNH}->grey;
        $t3->allgrey;
        $t3->black([-1]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Likewise, the ratio of AM to MC is equal to the ratio of the triangles AME to EMC (VI.1)");
         $t2->y($l{t2});
        $t2->math("             = \\{triangle}AME:\\{triangle}EMC");
        $t{BMC}->grey;
        $t{ABM}->grey;
        $t{AME}= Triangle->join($p{A},$p{M},$p{E})->fill(Colour->new($colour1)->lighten(-7));
        $t{EMC}= Triangle->join($p{E},$p{M},$p{C})->fill(Colour->new($colour1)->lighten(-14));
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If two ratios are equal, so is this the ratio of the sum of ".
        "antecedents to the sum of consequents (V.12), so AME to EMC is equal to ABE to BCE");
        $t2->math(" = (\\{triangle}ABM+\\{triangle}AME):(\\{triangle}MBC+\\{triangle}EMC)");
        $t2->math(" = \\{triangle}ABE:\\{triangle}BCE");
        $t{AME}->grey;
        $t{ABM}->grey;
        $t{BMC}->grey;
        $t{ABC}->grey;
        $t{EMC}->grey;
        $l{AM}->grey;
        $l{AC}->normal->dash;
        $t{BEC}->normal;
        $t{ABE}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, FN to NH is equal to the triangles FGL to GHL");
        $t2->math("FN:NH = \\{triangle}FGL:\\{triangle}GHL");
        $l{BM}->grey;
        $l{AC}->grey;
        $l{BE}->grey;
        $l{FH}->normal->dash;
        $l{FN}->grey;
        $t{FGH}->grey;
        $t{FGN}->grey;
        $t{GNH}->grey;
        $t{BEC}->grey;
        $t{GHL}->normal;
        $t{ABE}->grey;
        $t{FGL}->normal;
        $t{CED}->grey;
        $t{HLK}->grey;
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
  #      $t1->down;
        $t1->title("Proof - Duplicate Ratio to Sides");
        $t3->erase;
        $t2->erase;
        $t3->math("ABCDE ~ FGHKL");
        $t3->math("AB:BC = FG:GH");
        $t3->math("AM:MC = FN:NH");
        $t3->math("AM:MC = \\{triangle}ABE:\\{triangle}BCE");
        $t3->math("FN:NH = \\{triangle}FGL:\\{triangle}GHL");
        $t{ABE}->normal;
        $t{BEC}->normal;
        $l{AC}->normal->dash;
        $l{FH}->normal->dash;
        $t3->blue([0..10]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Substitute the triangle ratios for the ratios AM to MC and FN to NH ".
        "with the result that the ratios of the triangles ABC to BCE equals the ratio of the ".
        "triangles FGL to GHL");
        $t3->grey([0,1]);
        $t3->math("\\{triangle}ABE:\\{triangle}BCE = \\{triangle}FGL:\\{triangle}GHL");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And alternately, the ratio of triangles ABE to FGL is equal".
        " to the ratio BCE to GHL");
        $t3->math("\\{triangle}ABE:\\{triangle}FGL = \\{triangle}BCE:\\{triangle}GHL");
        $t3->grey([0..4]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, we can show that if the lines BD and GK are drawn, ".
        " the ratio of the triangles BCE to GHL ".
        "is equal to the ratio of the triangles ECD to LHK.");
        $t{HLK}->normal;
        $t{CED}->normal;
        $t{ABE}->grey;
        $t{FGL}->grey;
        $l{AC}->grey;
        $l{FH}->grey;
        $t3->grey([0..6]);
        $l{BD} = Line->join($p{B},$p{D})->dash;
        $l{GK} = Line->join($p{G},$p{K})->dash;
        $t3->math("\\{triangle}BCE:\\{triangle}GHL = \\{triangle}ECD:\\{triangle}LHK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{ABE}->normal;
        $t{FGL}->normal;
        $l{BD}->grey;
        $l{GK}->grey;
        $t3->black([6,7]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If a number of ratios are equal, then they are also equal to ".
        "the ratio of the sums of the antecedents to the sums of the consequents (V.12)");
        $t3->math(" = (\\{triangle}ABE+\\{triangle}BCE+\\{triangle}ECD):".
        "(\\{triangle}FGL+\\{triangle}GHL+\\{triangle}LHK)");
        $t2->math("\\{triangle}ABE:\\{triangle}FGL = ABCDE:FGHKL")
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->math("\\{triangle}ABE:\\{triangle}FGL = (AB:FG)\\{squared}")->blue(1);
        $t1->explain("But the ratio of the triangles ABE to FGL is a ".
        "duplicate ratio of the sides AB to FG (VI.19)");
        $t3->grey([0..20]);        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore, the ratio of the two polygons ABCDE and FGHKL is a duplicate ".
        "ratio of the sides AB to FG ");
        $t2->math("ABCDE:FGHKL = (AB:FG)\\{squared}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Thus, it has been shown that the ratio of the two polygons is ".
        "a duplicate ratio of their respective sides");
        $t3->blue(0);
        $t2->grey([0..20]);
        $t2->black(2);
    };

    return $steps;

}

