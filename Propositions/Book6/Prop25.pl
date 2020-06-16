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
my $title =
    "To construct one and the same figure similar to a given rectilineal "
  . "figure and equal to another given rectilineal figure";

$pn->title( 25, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 140, 660 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 350 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 25 );
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
    my $off  = 40;
    my $yoff = 30;
    my $yh   = 150;
    my $yb   = 300;
    my $ym   = 230;
    my $xs   = 150;
    my $dx1  = -40;
    my $dx2  = 120;
    my $dx3  = 90;

    my @A = ( $xs + $dx1, $yh );
    my @B = ( $xs, $yb );
    my @C = ( $xs + $dx2, $yb );
    my @D = ( $C[0] + 50, $ym );
    push @D, ( $D[0] + $dx3, $yb - 20 );
    push @D, ( $D[2] + $dx3, $ym + 20 );
    push @D, ( $D[4] - $dx3 - $dx1, $yh );

        $l{1} = Line->new( $pn, 50, 50, 100, 50 );
        $l{2} = Line->new( $pn, 50, 50, 40,  100 );
        $a{1} = Angle->new($pn,$l{2},$l{1});
        $l{1}->remove;
        $l{2}->remove;
        $a{1}->remove;

    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Given two rectilineal figures (ABC and D for example)");
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "left" );
        $p{C} = Point->new( $pn, @C )->label( "C", "topright" );
        $t{ABC} = Triangle->join( $p{A}, $p{B}, $p{C} )->fill($colour1);
        $t{D} = Polygon->new( $pn, 4, @D )->label("D")->fill($colour2);
        ( $l{AB}, $l{BC}, $l{AC} ) = $t{ABC}->lines;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "Construct a third figure that is similar to the first (ABC), and "
               . "equal in area to the second (D)" );
        $t{x} = Triangle->new( $pn, $D[2]+30+$B[0],$B[1],
                                       $D[2]+30+$A[0],$A[1],
                                       $D[2]+30+$C[0],$C[1],  )->fill($colour3);
        
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $t{x}->remove;
        $t3->down;
        $t3->down;        
        $t3->down;        
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Construct a parallelogram to the base BC such that it is equal in area "
              . "to the triangle ABC (I.44)" );
        $t3->math("\\{square}BE = \\{triangle}ABC");

         ( $t{x} , my $a1 ) = $t{ABC}->parallelogram( $a{1} );
        $a1->remove;
        
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{x}->remove;

        $s{BE} = $t{x}->copy_to_line( Line->new($pn,@C,@B)->remove )->fill(Colour->lighten(12,$colour1));
        (undef,undef,$p{L},$p{E}) = $s{BE}->points;
        $p{L}->label("L","bottom");
        $p{E}->label("E","bottom");
        $a{CBL} = Angle->new($pn,$s{BE}->lines->[1],$l{BC})->label("\\{alpha}",20);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Construct a parallelogram to the line CE equal in area to D, and ".
        "with an angle equal to CBL (I.45)" );

        $a{1} = Angle->new($pn,Line->join($p{L},$p{E})->remove,Line->join($p{L},$p{B})->remove);        
        my @points = $t{D}->points;
        $a{1}->remove;
        my $triangle1 = Triangle->join($points[0],$points[1],$points[2])->remove;
        my $triangle3 = Triangle->join($points[0],$points[2],$points[3])->remove;
        
        my ($tmp , $a1 ) = $triangle1->parallelogram( $a{1} );
        $tmp->remove;
        $a1->remove;
        
        $s{CM1} = $tmp->copy_to_line( Line->new($pn,@C,$p{E}->coords)->remove );
        my($p1,$p2,$p3,$p4) = $s{CM1}->points;       

        ($tmp , $a1 ) = $triangle3->parallelogram( $a{1} );
        $tmp->remove;
        $a1->remove;
        $s{CM2} = $tmp->copy_to_line( Line->new($pn,$p4->coords,$p3->coords)->remove);
        (undef,undef,$p{M},$p{F}) = $s{CM2}->points;
        
        $p3->remove;
        $p4->remove;
        $s{CM1}->remove;
        $s{CM2}->remove;
        $p{F}->label("F","right");
        $p{M}->label("M","bottom");
        
        $s{CM} = Polygon->join(4,$p{C},$p{F},$p{M},$p{E})->fill(Colour->lighten(12,$colour2));
        $a{FCE} = Angle->new($pn,$s{CM}->lines->[3],$s{CM}->lines->[0])->label("\\{alpha}",20);
        $l{CF} = $s{CM}->lines->[0];

        $t3->math("\\{square}EF = \\{square}D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since the angles CBL and FCE are equal, the lines BC,CF".
        " are in a straight line as are LE and EM");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a line GH which is in a mean proportion to BC,CF (VI.13)");
        $p{G} = Point->new($pn,$D[2]+30+$B[0],$B[1])->label("G","left");
        $l{GH} = Line->mean_proportional($l{BC},$l{CF},$p{G},0);
        $p{H} = Point->new($pn,$l{GH}->end)->label("H","right");
        $t3->math("BC:GH = GH:CF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a figure similar to ABC on the line GH (VI.18)");
        $a{ABC} = Angle->new($pn,$l{BC},$l{AB})->label("\\{beta}",25);
        $a{BCA} = Angle->new($pn,$l{AC},$l{BC})->label("\\{theta}");
        ($l{GKx},$a{KGH}) = $a{ABC}->copy($p{G},$l{GH});
        ($l{HKx},$a{KHG}) = $a{BCA}->copy($p{H},$l{GH},"negative");
        $a{KGH}->label("\\{beta}",25);
        $a{KHG}->label("\\{theta}");
        my @p = $l{GKx}->intersect($l{HKx});
        $p{K} = Point->new($pn,@p)->label("K","left");
        $l{GKx}->remove;
        $l{HKx}->remove;
        $t{GHK} = Triangle->join($p{G},$p{H},$p{K})->fill($colour3);
        $t3->math("\\{triangle}ABC ~ \\{triangle}KGH");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Now, the triangle KGH is equal in area to the polygon D");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("If there are two lines A,B, and if A is to B as B is to C, ...");
        $t1->explain("... and two similar figures are drawn on A and B, ...");
        $t1->explain("... then the ratio of the areas of the two figures (being the ".
        "duplicate ratio of A,B) is the ratio A:C (VI.19.Por)");        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus the ratio of BC to CF is the ratio of the two ".
        "triangles ABC to KGH");
        foreach my $angle (keys %a) {
            $a{$angle}->grey;
        }
        $s{CM}->grey;
        $s{BE}->grey;
        $t{D}->grey;
        $l{CF}->normal;
        $t3->down;
        $t3->grey([0..20]);
        $t3->black([-1,-2]);
        $t3->math("\\{triangle}ABC:\\{triangle}KGH = BC:CF");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But the ratio of the parallelograms BE to EF is equal to the ratio ".
        "of their bases, BC to CF (VI.1)");
        $t{ABC}->grey;
        $s{CM}->normal;
        $s{BE}->normal;
        $t{GHK}->grey;
        $l{GH}->grey;
        $t3->grey([0..20]);
        $t3->math("BC:CF = \\{square}BE:\\{square}EF");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The ratio of BC to CF is equal to both the ratio of the triangles ".
        "ABC and KGH, and to the ratio of the parallelograms BE and EF");
        $t1->explain("Therefore the ratio of the parallelograms is equal to ".
        "the ratio of the triangles");
        $t3->black(-2);
        $t{ABC}->normal;
        $t{GHK}->normal;
        $t3->math("\\{triangle}ABC:\\{triangle}KGH = \\{square}BE:\\{square}EF");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Alternately, the triangle ABC to the parallelogram BE is ".
        "equal to the triangle KGH to the square EF (V.16)");
        $t3->grey([0..20]);
        $t3->black([-1]);
        $t3->math("\\{triangle}ABC:\\{square}BE = \\{triangle}KGH:\\{square}EF");
    };
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But the triangle ABC is equal to the parallelogram BE, ".
        "so therefore the triangle KGH is equal to EF");
        $t3->grey([0..20]);
        $t3->black([-1,0]);
        $t2->math("\\{square}BE:\\{square}BE = \\{triangle}KGH:\\{square}EF");
        $t2->math("\\{triangle}KGH = \\{square}EF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But the polygon D is equal to the parallelogram EF, ".
        "so therefore the triangle KGH is equal to D");
        $t{D}->normal;
        $t3->grey([0..20]);
        $t3->black([1]);
        $t2->grey([0..20]);
        $t2->black(-1);
        $t2->math("\\{triangle}KGH = D");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Thus KGH is similar to ABC, and equal in area to D");
        $t3->grey([0..20]);
        $t3->blue([3]);
        $t2->grey([0..20]);
        $t2->blue(-1);
        $s{CM}->grey;
        $s{BE}->grey;
    };
    return $steps;

}

sub grey_shit {
    print "_" x 40, "\n";
    foreach my $type ( \%l, \%t, \%a ) {
        foreach my $o ( keys %$type ) {
            $type->{$o}->grey;
            print $type->{$o}, ": $o\n";
        }
    }
}

