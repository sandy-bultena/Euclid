#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);

# ============================================================================
# Definitions
# ============================================================================
my $title = "To bisect a given circumference.";

$pn->title( 30, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 200, 400 );
my $t2 = $pn->text_box( 400, 500 );

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 30 );
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
    my ( %l, %p, %c, %s, %a );

    my @c1 = ( 300, 420 );
    my $r1 = 250;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("In other words");
        $t4->explain("Describe the necessary steps to bisect the circumference ADB");

        $c{1} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] )->grey;
        $p{A} = $c{1}->point(180-40)->label("A","bottom");
        $p{B} = $c{1}->point(40)->label("B","bottom");
        $c{1}->remove;
        $c{1} = Arc->new( $pn, $r1, $p{B}->coords, $p{A}->coords )->label("D","top");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Construction");
    };

    push @$steps, sub {
        $t4->explain("Draw line AB, and bisect at point C");
        $l{AB} = Line->join($p{A},$p{B});
        $p{C} = $l{AB}->bisect()->label("C","bottom");
        $l{AC} = Line->join($p{A},$p{C});
        $l{CB} = Line->join($p{C},$p{B});
        $t3->math("AC = CB");
        $t3->allblue;
    };

    push @$steps, sub {
        $t4->explain("Draw a line perpendicular to AB, and "."label the intersection of the circumference point D");
        $l{ADt} = $l{AB}->perpendicular($p{C})->grey;
        my @p = $c{1}->intersect($l{ADt});
        $p{D} = Point->new($pn,@p[0,1])->label("D","top");
        $c{1}->label();
        $l{ADt}->remove;
        $l{CD}=Line->join($p{C},$p{D});
        $a{ACD} = Angle->new($pn,$l{CD},$l{AC})->label(" ",35);
        $a{DCB} = Angle->new($pn,$l{CB},$l{CD});
    };

    push @$steps, sub {
        $t4->explain("The point D bisects the circumference ADB");
        $l{CD}->grey;
        $l{AB}->grey;
        $l{AC}->grey;
        $l{CB}->grey;
        $a{ACD}->grey;
        $a{DCB}->grey;
        $t3->math("\\{arc}AD = \\{arc}DB");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase;
        $t4->down;
        $t4->title("Proof");
        $l{CD}->normal;
        $l{AB}->normal;
        $l{AC}->normal;
        $l{CB}->normal;
        $a{ACD}->normal;
        $a{DCB}->normal;
        $t3->math("AC = CB");
        $t3->allblue;
    };

    push @$steps, sub {
        $t4->explain("Draw the lines AD and DB");
        $l{AD} = Line->join($p{A},$p{D});
        $l{DB} = Line->join($p{D},$p{B});
    };

    push @$steps, sub {
        $t4->explain("Since the two triangles ACD "."and DCB have two sides equal ".
        "to two sides respectively, and the angles "."between them are also equal ".
        "(side-angle-side), then the two triangles "."are equal in all respects (I.4)");
        $s{ACD} = Triangle->join($p{A},$p{C},$p{D})->fill($pale_yellow);
        $s{DCB} = Triangle->join($p{D},$p{C},$p{B})->fill($yellow);
        $t3->math("\\{triangle}ACD \\{equivalent} \\{triangle}DCB");
    };

    push @$steps, sub {
        $t4->explain("Therefore, AD equals DB");
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("AD = DB");
    };

    push @$steps, sub {
        $t4->explain("But equal straight lines cut off equal circumferences (III.28), ".
        "therefore the circumference AD equals DB");
        $l{AB}->grey;
        $l{AC}->grey;
        $l{CB}->grey;
        $l{CD}->grey;
        $a{ACD}->grey;
        $a{DCB}->grey;
        $s{ACD}->remove;
        $s{DCB}->remove;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("\\{arc}AD = \\{arc}DB");
        
    };

    push @$steps, sub {
        $t3->allgrey;
        $l{AD}->grey;
        $l{DB}->grey;
        $l{AC}->normal;
        $l{CB}->normal;
        $l{CD}->normal;
        $a{ACD}->normal;
        $a{DCB}->normal;
        $t3->black(-1);
        $t3->blue(0);
    };
    


    return $steps;

}

