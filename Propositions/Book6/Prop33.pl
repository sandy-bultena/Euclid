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
my $title = "In equal circles angles have the same ratio as the ".
"circumferences on which they stand, whether they stand at the centres or at ".
"the circumferences";

$pn->title( 33, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 500 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 33 );
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
    my $r = 100; # radius
    my ($x1,$y1) = ($r+60,$r+150);
    my ($x2,$y2) = (160+3*$r,$r+150);    
    
    my @angles=(40,175,230,55,195,245);
   
    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given two circles ABC,DEF with centres G and H respectively");
        $c{ABC} = Circle->new($pn,$x1,$y1,$x1+$r,$y1);
        $c{DEF} = Circle->new($pn,$x2,$y2,$x2+$r,$y2);
        
        $p{B} = $c{ABC}->point($angles[1])->label("B","left");
        $p{A} = $c{ABC}->point($angles[0])->label("A","topright");
        $p{C} = $c{ABC}->point($angles[2])->label("C","bottomleft");
        
        $p{D} = $c{DEF}->point($angles[3])->label("D","topright");
        $p{E} = $c{DEF}->point($angles[4])->label("E","bottomleft");
        $p{F} = $c{DEF}->point($angles[5])->label("F","bottom");
        
        $p{G} = Point->new($pn,$x1,$y1)->label("G","top");
        $p{H} = Point->new($pn,$x2,$y2)->label("H","top");
    };
    
    push @$steps, sub {
        $t1->explain("Let the angles BAC, BGC and EDF and EHF be drawn");
        
        $l{AB} = Line->join($p{A},$p{B});
        $l{AC} = Line->join($p{A},$p{C});
        $l{BG} = Line->join($p{B},$p{G});
        $l{CG} = Line->join($p{C},$p{G});
        
        $a{BAC} = Angle->new($pn,$l{AB},$l{AC})->label("\\{alpha}");
        $a{BGC} = Angle->new($pn,$l{BG},$l{CG})->label("\\{theta}\\{_1}",20);
                
        $l{DE} = Line->join($p{D},$p{E});
        $l{DF} = Line->join($p{D},$p{F});
        $l{EH} = Line->join($p{E},$p{H});
        $l{FH} = Line->join($p{F},$p{H});
        
        $a{EDF} = Angle->new($pn,$l{DE},$l{DF})->label("\\{gamma}");
        $a{EHF} = Angle->new($pn,$l{EH},$l{FH})->label("\\{delta}\\{_1}",20);              
     };
    
    push @$steps, sub {
        $t1->explain("Then the ratio of the circumferences BC to EF is equal ".
        "to the ratios of BGC to EHF and BAC to EDF");
        $t3->math("BC:EF = \\{theta}\\{_1}:\\{delta}\\{_1} = \\{alpha}:\\{gamma}"); 
    };
    
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t3->erase;
        $t1->explain("Create an number of consecutive circumferences CK, KL ".
        "equal to BC");
        $t1->explain("And create and number of consecutive circumferences FM, MN ".
        "equal to EF");
        $p{K} = $c{ABC}->point(2*$angles[2]-$angles[1])->label("K","bottom");
        $p{L} = $c{ABC}->point(3*$angles[2]-2*$angles[1])->label("L","bottomright");
        
        $p{M} = $c{DEF}->point(2*$angles[5]-$angles[4])->label("M","bottom");
        $p{N} = $c{DEF}->point(3*$angles[5]-2*$angles[4])->label("N","bottomright");
        
        $t3->math("BC = CK = KL");
        $t3->math("EF = EM = MN");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase;
        $a{BAC}->grey;
        $a{EDF}->grey;
        $l{AB}->grey;
        $l{AC}->grey;
        $l{DE}->grey;
        $l{DF}->grey;
        $t1->explain("And draw the lines GK, GL, HM, HN");
        $l{GK} = Line->join($p{G},$p{K});
        $l{GL} = Line->join($p{G},$p{L});
        $l{HM} = Line->join($p{H},$p{M});
        $l{HN} = Line->join($p{H},$p{N});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And since BC, CK, KL are equal, so are the angles ".
        "BGC, CGK, KGL (III.27)");
        $a{CGK}=Angle->new($pn,$l{CG},$l{GK})->label("\\{theta}\\{_2}",25); 
        $a{KGL}=Angle->new($pn,$l{GK},$l{GL})->label("\\{theta}\\{_3}",30); 

        $t3->math("\\{theta}\\{_1} = \\{theta}\\{_2} = \\{theta}\\{_3}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus, whatever multiple BL is of BC, it is the same ".
        "multiple that BGL is to BGC");
        
        $a{CGK}->remove;
        $a{KGL}->remove;
        $a{BGL} = Angle->new($pn,$l{BG},$l{GL})->label("\\{theta}");
        $t3->math("BL = n\\{dot}BC");
        $t3->math("\\{theta}  = n\\{dot}\\{theta}\\{_1}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("For the same reason, whatever multiple EN is of EF, it is the same ".
        "multiple that EHN is to EHF");
#        $t3->math("\\{delta}\\{_1} = \\{delta}\\{_2} = \\{delta}\\{_3}"); 
     #   $a{FHM}=Angle->new($pn,$l{FH},$l{HM})->label("\\{delta}\\{_2}",25); 
     #   $a{MHN}=Angle->new($pn,$l{HM},$l{HN})->label("\\{delta}\\{_3}",30);
        $a{EHN} = Angle->new($pn,$l{EH},$l{HN})->label("\\{delta}");
        $t3->math("EN = m\\{dot}EF");
        $t3->math("\\{delta}  = m\\{dot}\\{delta}\\{_1}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Equal circumferences on equal circles have equal angles (III.27), ".
        "thus if BL is greater than EN, BGL will also be greater ".
        "than EHN, if equal then equal, if less than, then less ");
        $t3->math("BL <=> EN \\{then} \\{theta} <=> \\{delta}");       
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But BL,EN are equimultiples of BGC, EHF, so substitute them in the previous equation");
        $t3->math("n\\{dot}BC <=> m\\{dot}EF \\{then} n\\{dot}\\{theta}\\{_1} <=> m\\{dot}\\{delta}\\{_1}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Which in turn is the definition for equal ratios");
        $t3->down;
        $l{GK}->grey;
        $l{GL}->grey;
        $l{HM}->grey;
        $l{HN}->grey;
        $a{EHN}->grey;
        $a{BGL}->grey;
        $t2->math("BC:EF = \\{theta}\\{_1}:\\{delta}\\{_1}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And since BAC is half BGC, and EDF is half EHF, the ".
        "ratio of BC,EF is also equal to the angles BAC,EHF");
        $t2->math("BC:EF = \\{alpha}:\\{gamma}");
        $l{AB}->normal;
        $l{AC}->normal;
        $l{DE}->normal;
        $l{DF}->normal;
        $a{BAC}->normal;
        $a{EDF}->normal;
        
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


