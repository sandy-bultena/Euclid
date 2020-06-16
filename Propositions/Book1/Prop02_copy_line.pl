#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

# ============================================================================
# Definitions
# ============================================================================
my $title = "To place a straight line equal to a given straight line "
  . "with one end at a given point.";

my $pn = PropositionCanvas->new( -number => 2 );
$pn->title(2,$title);
Proposition::init($pn);
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 580, 430, -width => 500 );
my $t5 = $pn->text_box( 800, 150, -width => 500 );
my $t6 = $pn->text_box( 800, 150, -width => 500 );

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,2);
push @$steps, Proposition::reset();
push @$steps, explanation( $pn );
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->go;

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $p = shift;
    my %l;
    my %p;
    my %c;
    my %t;
    my @A = ( 200, 500 );
    my @B = ( 300, 500 );
    my @C = ( 450, 400 );
    my @D = ( 250, 400 );

    # ------------------------------------------------------------------------
    # Explanation
    # ------------------------------------------------------------------------
    push @$steps, sub {
        $p{A} = Point->new($pn,@A)->label( 'A', 'left' );
        $l{AB} = Line->new($pn, @A, @B )->blue;
        $p{B} = Point->new($pn,@B)->label( 'B', 'right' );
        $p{C} = Point->new($pn,@C)->label( 'C', 'bottom' );
    };

    push @$steps, sub {
    local $Shape::AniSpeed        = 20*$Shape::AniSpeed;
        $l{Cx} = Line->new($pn, @C, $C[0]+$B[0]-$A[0],$C[1] );
    };

    push @$steps, sub {
        $pn->clear;
        $pn->title(2,$title);
    };

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Construction:");
        $t1->explain("Start with line segment AB and point C");

        $p{A} = Point->new($pn,@A)->label( 'A', 'left' );
        $l{AB} = Line->new($pn, @A, @B )->blue  ;
        $p{B} = Point->new($pn,@B)->label( 'B', 'right' );
        $p{C} = Point->new($pn,@C)->label( 'C', 'bottom' );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Construct line segment AC");
        $l{AC} = Line->new($pn, @A, @C );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Construct an equilateral triangle on line AC\\{nb}(I.1)");
        $t{1} = EquilateralTriangle->build($pn, @A, @C, 2 );
        $l{AD} = $t{1}->l(3);
        $l{CD} = $t{1}->l(2);
        $p{D} = $t{1}->p(3);
        $p{D}->label( 'D', 'top' );
        $l{AD}->normal;
        $l{CD}->normal;
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a circle with A as the center and AB as the radius");
        $c{A} = Circle->new($pn, @A, @B );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Label the intersection of the circle and line AD as E");
        my @p = $c{A}->intersect( $l{AD} );
        $p{E} = Point->new($pn,@p)->label( "E", "topleft" );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a circle with D as the center and ED as the radius");
        $c{A}->grey;
        $c{D} = Circle->new($pn, $p{D}->coords, $p{E}->coords );

    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Label the intersection of the circle and line CD as F");
        my @F = $c{D}->intersect( $l{CD} );
        $p{F} = Point->new($pn,@F)->label( "F", "right" );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Line AB is equal to line CF");
        $c{D}->grey;
        $l{AC}->grey;
        $l{CD}->grey;
        $l{AD}->grey;
        $l{CF} = Line->new($pn, @C, $p{F}->coords );
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof:");
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $l{CD}->normal;
        $l{AD}->normal;
        $l{AB}->grey;
        $p{E}->remove;
        $p{F}->remove;
        $l{CF}->remove;

        $t1->explain("Line AD is equal to line DC (equilateral triangle)");
        $l{CD}->label( 'x', 'left' );
        $l{AD}->label( 'x', 'right' );
        $t2->math("AD = DC = x");
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $l{AD}->green;
        $l{AC}->grey;
        $l{AB}->grey;
        $l{CD}->green;
        $l{CF}->grey;
        $c{D}->normal;

        $t1->explain("DE and DF are equal (radii of the same circle)");
        $p{E}->draw;
        $p{F}->draw;
        $l{DE} = Line->join( $p{D}, $p{E});
        $l{DF} = Line->join( $p{D}, $p{F});
        $l{DE}->label( 'y', 'left' );
        $l{DF}->label( 'y', 'right' );
        $t2->math("DE = DF = y");
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $c{D}->grey;
        $l{AE}->remove if $l{AE};
        $l{CD}->grey;
        $l{AD}->grey;
        $l{DE}->grey;

        $t1->explain("AE is the difference between DA and DE");
        $l{AE} = Line->new($pn, @A, $p{E}->coords );
        $l{AE}->label("x-y","left");
        $t2->math("AE = DA - DE");
        $t2->math("AE = x  - y");

    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $c{D}->grey;
        $l{CF}->remove if $l{CF};
        $l{CD}->grey;
        $l{DF}->grey;

        $t1->explain("CF is the difference between DC and DF");
        $l{CF} = Line->new($pn, @C, $p{F}->coords );
        $l{CF}->label("x-y","right");
        $t2->math("CF = DC - DF");
        $t2->math("CF = x  - y");

    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $l{AD}->grey;
        $l{CD}->grey;
        $l{DE}->grey;
        $l{DF}->grey;

        $t1->explain( "AE and FC are the differences of equals, "
              . "so they are equal" );
        $l{AE}->label( "z", "left" );
        $l{CF}->label( "z", "right" );
        $t2->math("AE = CF = z");
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $c{A}->normal;
        $l{AB}->blue;
        $l{AD}->grey;
        $l{CD}->grey;
        $l{CF}->grey;

        $t1->explain("AB and AE are radii of the same circle");
        $l{AB}->label( "z", "bottom" );
        $t2->math("AB = AE = z");
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $c{A}->normal;
        $c{A}->grey;
        $l{AD}->grey;
        $l{AE}->grey;
        $l{CF}->normal;

        $t1->explain("AB and CF are equal");
        $t2->math("AB = CF = z");
    };

    # ------------------------------------------------------------------------
    # clean and do second construction
    # ------------------------------------------------------------------------

    push @$steps, sub {
        $t1->delete;
        $t2->delete;
        foreach my $key ( keys %l ) {
            $l{$key}->remove if $l{$key};
        }
        foreach my $key ( keys %p ) {
            $p{$key}->remove if $p{$key};
        }
        foreach my $key ( keys %c ) {
            $c{$key}->remove if $c{$key};
        }
        $t{1}->remove;
        $t5->title("But what if?");
        $t5->explain("Start with line segment AB and point C");
        $l{AB} = Line->new($pn, @A, @C )->blue;
        $p{A} = Point->new($pn,@A)->label( 'A', 'left' );
        $p{B} = Point->new($pn,@C)->label( 'B', 'right' );
        $p{C} = Point->new($pn,@D)->label( 'C', 'bottom' );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t5->explain("Construct line segment AC");
        $l{AC} = Line->new($pn, @A, @D );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t5->explain("Construct an equilateral triangle on line AC");
        $t{2}=EquilateralTriangle->build($pn, @A, @D );
        $l{AD}=$t{2}->l(3);
        $l{CD}=$t{2}->l(2);
        $p{D}=$t{2}->p(3);
        $p{D}->label( 'D', 'top' );
        $l{AD}->normal;
        $l{CD}->normal;
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t5->explain("Draw a circle with A as the center and AB as the radius");
        $c{A} = Circle->new($pn, @A, @C );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t5->explain( "Label the intersection of the circle and line AD as E ");
        $t5->explain("  ...hang on... there isn't any intersection point, what now?"
        );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t5->explain("Extend DA and DC such that they intersect the circle");
#        $l{AD2} = $l{AD}->clone;
#        $l{CD2} = $l{CD}->clone;
        $l{AD}->extend(400);
        $l{CD}->prepend(400);
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t5->explain("Label the intersection of the circle and line AD as E");
        my @p = $c{A}->intersect( $l{AD} );
        $p{E} = Point->new($pn,@p)->label( "E", "topleft" );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $c{A}->grey;
        $t5->explain("Draw a circle with D as the center and ED as the radius");
        $c{D} = Circle->new($pn, $p{D}->coords, $p{E}->coords );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t5->explain("Label the intersection of the circle and line CD as F");
        my @F = $c{D}->intersect( $l{CD} );
        $p{F} = Point->new($pn,@F)->label( "F", "right" );
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $c{D}->grey;
        $t{2}->grey;
        $l{AC}->grey;
        $l{CD}->grey;
        $l{AD}->grey;
        $l{CD}->grey;

        $t5->explain("Line AB is equal to line CF");
        $l{CF} = Line->new($pn, @D, $p{F}->coords );
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @$steps, sub {
        $t5->down;
        $t5->title("Proof:");
    };
    push @$steps, sub {
        $t5->explain("... I will leave it to the reader to prove ...");
    };

    # ------------------------------------------------------------------------
    push @$steps, sub {
        $l{AB}->normal;
        $c{D}->remove;
        $l{AC}->remove;
        $l{CD}->remove;
        $l{AD}->remove;
        $c{A}->remove;
        $t{2}->remove;
        $p{E}->remove;
    };

    # ------------------------------------------------------------------------
    return $steps;
}
