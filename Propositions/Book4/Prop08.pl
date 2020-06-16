#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 5;

# ============================================================================
# Definitions
# ============================================================================
my $title = "In a given square, to inscribe a circle.";

$pn->title( 8, $title, 'IV' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 820, 150, -width => 480 );
my $t3 = $pn->text_box( 400, 300 );
my $t2 = $pn->text_box( 520, 200 );

my $steps;
push @$steps, Proposition::title_page4($pn);
push @$steps, Proposition::toc4( $pn, 8 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();
my ( %l, %p, %c, %s, %a );

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my $r = 140;
    my @b = ( 140, 400 );
    my @c = ( 200, 300 );
    my @a = ( 500, 140 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given a square ABCD, draw a circle inside the square, "
        ."touching each side of the square");

        my @p = @c;
        $p[0] = $p[0] + $r;
        $p{A} = Point->new($pn,$c[0]-$r,$c[1]-$r)->label("A","top");
        $p{B} = Point->new($pn,$c[0]-$r,$c[1]+$r)->label("B","bottom");
        $p{C} = Point->new($pn,$c[0]+$r,$c[1]+$r)->label("C","bottom");
        $p{D} = Point->new($pn,$c[0]+$r,$c[1]-$r)->label("D","top");
        $l{AB}=Line->join($p{A},$p{B});
        $l{BC}=Line->join($p{B},$p{C});
        $l{CD}=Line->join($p{C},$p{D});
        $l{DA}=Line->join($p{D},$p{A});
        $c{a} = Circle->new( $pn, @c, @p ,undef, 1);

    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $c{a}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Bisect the lines AB and AD at points E and\\{nb}F\\{nb}(I.10)");
        $p{E} = $l{DA}->bisect()->label("E","top");
        $p{F} = $l{AB}->bisect()->label("F","left");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw EH parallel to AB (I.31)");
        $l{EHt} = $l{AB}->parallel($p{E})->grey;
        my @p = $l{EHt}->intersect($l{BC});
        $p{H} = Point->new($pn,@p)->label("H","bottom");
        $l{EH} = Line->join($p{E},$p{H});
        $l{EHt}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw FK parallel to AD (I.31)");
        $l{FKt} = $l{DA}->parallel($p{F})->grey;
        my @p = $l{FKt}->intersect($l{CD});
        $p{K} = Point->new($pn,@p)->label("K","right");
        $l{FK} = Line->join($p{F},$p{K});
        $l{FKt}->remove;
        @p = $l{FK}->intersect($l{EH});
        $p{G} = Point->new($pn, @p)->label("G","topright");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a circle with centre G, and radius GE");
        $t1->explain("This circle is inscribed in the square");
        $c{A}= Circle->new($pn,$p{G}->coords,$p{E}->coords);
    };


    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        # $t1->erase;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{A}->grey;
        $t1->explain("Because all of the lines are parallel to each other, ".
        "each sub-figure (AK,KB,AH,HD,AG,GC,BG,GD) is also a parallelogram ".
        "and their opposite sides are equal (I.34)");
        greyall();
        $s{AEGF} = Polygon->join(4,$p{A},$p{E},$p{G},$p{F})->fill(Colour->add($blue,$sky_blue));
        $s{EGKD} = Polygon->join(4,$p{E},$p{G},$p{K},$p{D})->fill(Colour->add($blue,$blue));
        $s{BFGH} = Polygon->join(4,$p{B},$p{F},$p{G},$p{H})->fill($blue);
        $s{GHCK} = Polygon->join(4,$p{G},$p{H},$p{C},$p{K})->fill($sky_blue);
        $t3->math("AE = FG = BH");
        $t3->math("ED = GK = HC");
        $t3->math("AF = EG = DK");
        $t3->math("BF = HG = CK");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{ABHE} = Polygon->join(4,$p{A},$p{B},$p{H},$p{E})->fill($lime_green);
        $s{EHCD} = Polygon->join(4,$p{E},$p{H},$p{C},$p{D})->fill($green);       
        $s{AEGF}->remove;
        $s{EGKD}->remove;
        $s{BFGH}->remove;
        $s{GHCK}->remove;
        $t3->allgrey;
        $t3->math("AB = EH = DC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{AFKD} = Polygon->join(4,$p{A},$p{F},$p{K},$p{D})->fill($pale_pink);
        $s{FBCK} = Polygon->join(4,$p{F},$p{B},$p{C},$p{K})->fill($pink);       
        $s{ABHE}->remove;
        $s{EHCD}->remove;
        $t3->allgrey;
        $t3->math("AD = FK = BC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{AFKD}->remove;
        $s{FBCK}->remove;
        $l{AB}->normal;
        $l{DA}->normal;
        $t1->explain("Since AD equals AB, and AE is half of AD and AF is half "
        ."of AB, AE = EF");
        $t3->allgrey;
        $t3->down;
        $t3->math("AD = AB");
        $t3->math("AE = \\{half} AD, AF = \\{half} AB");
        $t3->math("\\{therefore} AE = AF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("From our prior equalities, we know that AE equals FG ".
        "and AF equals EG, so FG equals GE");
        $l{EH}->normal;
        $l{FK}->normal;
        $t3->allgrey;
        $t3->black([-1,0,2]);
        $t3->math("=> FG = GE");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Using similar logic, it can be shown that GK and GH are equal, "
        ."thus a circle drawn with the centre at G, with radius EG will pass through ".
        "the points E,F,H,K");
        $c{A}->normal;
        $l{AB}->grey;
        $l{BC}->grey;
        $l{CD}->grey;
        $l{DA}->grey;
        $t3->allgrey;
        $t3->math("GE = GF = GH = GK");
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And finally, since the angles at E,F,H,K are right, the ".
        "lines comprising the square touch the circle (III.16)");
        $l{AB}->normal;
        $l{BC}->normal;
        $l{CD}->normal;
        $l{DA}->normal;
    };
    


    return $steps;

}

sub greyall {
    foreach my $o ( keys %l ) {
        $l{$o}->grey;
    }
    foreach my $o ( keys %a ) {
        $a{$o}->grey;
    }
    foreach my $o ( keys %s ) {
        $s{$o}->grey;
    }
    foreach my $o ( keys %p ) {
#        $p{$o}->grey;
    }
}

