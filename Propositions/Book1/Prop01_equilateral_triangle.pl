#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
Proposition::set_animation(0);

# ============================================================================
# Definitions
# ============================================================================
my $title =
  "To construct an equilateral triangle on a given finite straight line.";

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 500, 430 );
$pn->title(1,$title);

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,1);
push @$steps, Proposition::reset();
explanation( $pn );
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();

$pn->go;



# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my ( %l, %p, %c );

    my @A = ( 200, 500 );
    my @B = ( 450, 500 );

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Construction:");
        $t1->explain("Start with line segment AB");
        Point->new($pn,@A)->label( 'A', 'left' );
        $l{AB} = Line->new($pn, @A, @B );
        Point->new($pn,@B)->label( 'B', 'right' );
    };

    push @$steps, sub {
        $t1->explain("Create a circle with center A and radius AB");
        $c{A} = Circle->new($pn, @A, @B );
    };

    push @$steps, sub {
        $t1->explain("Create a circle with center B and radius AB");
        $c{B} = Circle->new($pn, @B, @A );
    };

    push @$steps, sub {
        $t1->explain("Label the intersection point C");
        my @ps = $c{A}->intersect( $c{B} );
        $p{C} = Point->new($pn, @ps[ 0, 1 ] )->label( "C", 'top' );
    };

    push @$steps, sub {
        $t1->explain("Create line AC and CB");
        $l{AC} = Line->new($pn, @A,            $p{C}->coords );
        $l{BC} = Line->new($pn, $p{C}->coords, @B );
    };

    push @$steps, sub {
        $t1->explain("Triangle ABC is an equilateral triangle");
        $c{A}->grey;
        $c{B}->grey;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("Proof:");
        $l{AC}->grey;
        $c{A}->grey;
        $c{B}->normal;

        $t1->explain(
            "AB and CB are radii of the same circle - hence they are equal");
        $l{AB}->label( "r", "bottom" );
        $l{BC}->label( "r", "right" );
        $t2->math("AB = CB = r");
    };

    push @$steps, sub {
        $l{BC}->grey;
        $c{B}->grey;
        $l{AB}->normal;
        $l{AC}->normal;
        $c{A}->normal;

        $t1->explain(
            "AB and AC are radii of the same circle - hence they are equal");
        $l{AC}->label( "r", "left" );
        $t2->math("AB = AC = r");
    };

    push @$steps, sub {
        $l{AC}->normal;
        $l{AB}->normal;
        $l{BC}->normal;
        $c{B}->grey;
        $c{A}->grey;

        $t1->explain(
                "If AB equals AC and AB equals CB, "
              . "then AC equals CB"
        );
        $l{BC}->label( "r", "right" );
        $t2->math("AB = CB = CA = r");
    };

    push @$steps, sub {
        $t2->down;
        $t2->math("\\{therefore} Equilateral Triangle!");

    };
    return $steps;

}

