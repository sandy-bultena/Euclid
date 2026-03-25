#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title = "To bisect a given rectilinear angle.";

my $pn = PropositionCanvas->new( -number => 9, -title => $title );
Proposition::init($pn);
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 500, 430 );

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,9);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #9
# ============================================================================
sub explanation {

    my (%l,%p,%c,%a,%t);
    my @objs;

    my @A = ( 100, 400 );
    my @B = ( 400, 200 );
    my @C = ( 400, 500 );

    my @steps;

    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Start with two straight lines joined at a single point");
        $l{AC_} = Line->new($pn, @B, @A );
        $l{AB_} = Line->new($pn, @A, @C );
        $p{A} = Point->new($pn,@A)->label( "A", "bottom" );

    };
    push @steps, sub {
        $t1->explain("Divide the resulting angle into two, using only a straight edge and compass");

        my @p = $l{AB_}->point(250);
        $p{B} = Point->new($pn,@p)->remove;
        $c{A} = Circle->new($pn, @A, $p{B}->coords )->remove;
        @p = $c{A}->intersect( $l{AC_} );
        $p{C} = Point->new($pn, @p[ 0, 1 ] )->remove;
        $l{AB} = Line->new($pn, @A, $p{B}->coords,-1 )->remove;
        $l{AC} = Line->new($pn, @A, $p{C}->coords,-1 )->remove;
        $l{BC} = Line->join( $p{B}, $p{C})->remove;
        $t{1} = EquilateralTriangle->build($pn, $p{C}->coords, $p{B}->coords, 2 )->remove;
        ($l{CD},$l{BD},$p{D}) = ($t{1}->l(3),$t{1}->l(2),$t{1}->p(3));

        $l{AD} = Line->new($pn, @A, $p{D}->coords );
        $a{DAC} = Angle->new($pn, $l{AD}, $l{AC} )->label("\\{alpha}");
        $a{DAB} = Angle->new($pn, $l{AB}, $l{AD}, -size => 50 )->label("\\{alpha}");

    };
    push @steps, sub {
        $t1->erase;
        $t1->title("Construction:");
        $l{AD}->remove;
        $a{DAC}->remove;
        $a{DAB}->remove;

    };
    push @steps, sub {
        $t1->explain( "Pick an arbitrary point B on one of the lines, and "
              . "construct another point C on the other line, such that AB and AC "
              . "are equal" );
        my @p = $l{AB_}->point(250);
        $p{B} = Point->new($pn,@p)->label( "B", "bottom" );
    };
    push @steps, sub {
        $c{A} = Circle->new($pn, @A, $p{B}->coords );
        my @p = $c{A}->intersect( $l{AC_} );
        $p{C} = Point->new($pn, @p[ 0, 1 ] )->label( "C", "top" );
        $l{AB} = Line->new($pn, @A, $p{B}->coords,-1 );
        $l{AC} = Line->new($pn, @A, $p{C}->coords,-1 );
        $t2->math("AC = AB");
        $t2->allblue;
    };
    push @steps, sub {
        $t1->explain( "Construct an equilateral triangle on line AC, "
              . "and label the vertex D\\{nb}(I.1)" );
        $c{A}->grey;
        $l{BC} = Line->join( $p{B}, $p{C});
        $t{1} = EquilateralTriangle->build($pn, $p{C}->coords, $p{B}->coords, 2 );
        ($l{CD},$l{BD},$p{D}) = ($t{1}->l(3),$t{1}->l(2),$t{1}->p(3));
        $p{D}->label( "D", "bottom" );
        $t2->math("CB = BD = DC");
        $t2->allblue;
    };
    push @steps, sub {
        $t1->explain("Create a line between points A and D");
        $l{BC}->grey;
        $l{AD} = Line->new($pn, @A, $p{D}->coords );
    };
    push @steps, sub {
        $t1->explain("Line AD bisects the angle CAB");
        $l{CD}->grey;
        $l{BD}->grey;
        $a{DAC} = Angle->new($pn, $l{AD}, $l{AC} )->label("\\{alpha}");
        $a{DAB} = Angle->new($pn, $l{AB}, $l{AD}, -size => 50 )->label("\\{alpha}");
        $t2->allblue;
        $t2->math("\\{angle}DAB = \\{angle}DAC");
    };

    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $a{DAC}->remove;
        $a{DAB}->remove;
    };

    push @steps, sub {
        $t2->allblue;
        $t1->explain( "Points B and C are equi-distance from point A since they "
              . "are the radii of the same circle" );
        $c{A}->normal;
        $t2->allgrey;
        $t2->black(0);
        $t2->math("AB = AC");
    };

    push @steps, sub {
        $t1->explain( "Points B and C are equi-distance from point D since they "
              . "are sides of an equilateral triangle" );
        $c{A}->remove;
        $l{BD}->normal;
        $l{BC}->normal;
        $l{CD}->normal;
        $t{1}->fill($sky_blue);
        $l{AD}->grey;
        $t2->allgrey;
        $t2->black(1);
        $t2->math("DB = DC");
    };
    push @steps, sub {
        $t1->explain( "Triangle ACD and ABD are congruent because they have "
              . "three equal sides\\{nb}(I.8)" );
        $t{1}->fill;
        $l{AD}->normal;
        $l{BC}->remove;
        $t{3} = Triangle->assemble($pn,-lines=>[$l{AB},$l{BD},$l{AD}])->fill($lime_green);;
        $t{2} = Triangle->assemble($pn,-lines=>[$l{AC},$l{CD},$l{AD}])->fill($pale_pink);
      
        $t2->allgrey;
        $t2->black([4,3]);
    };

    push @steps, sub {
        $t1->explain("Hence, the angles are congruent as well");
        $a{CAD} = Angle->new($pn, $l{AD}, $l{AC} )->label("\\{alpha}");
        $a{DAB} = Angle->new($pn, $l{AB}, $l{AD}, -size => 50 )->label("\\{alpha}");
        $a{ACD} = Angle->new($pn, $l{AC}, $l{CD} )->label("\\{beta}");
        $a{ABD} = Angle->new($pn, $l{BD}, $l{AB} )->label("\\{beta}");
        $a{CDA} = Angle->new($pn, $l{CD}, $l{AD} )->label("\\{theta}");
        $a{BDA} = Angle->new($pn, $l{AD}, $l{BD}, -size => 50 )->label("\\{theta}");
      
        $t2->math("\\{angle}CAD = \\{angle}DAB = \\{alpha}");
        $t2->math("\\{angle}ACD = \\{angle}ABD = \\{beta}");
        $t2->math("\\{angle}CDA = \\{angle}BDA = \\{theta}");
    };
    push @steps, sub {
        $t1->explain("Angle CAB is equal to twice angle CAD");
        $l{CD}->remove;
        $l{BD}->remove;
        $l{AC}->label;
        $l{AB}->label;
        $a{ACD}->remove;
        $a{ABD}->remove;
        $a{CDA}->remove;
        $a{BDA}->remove;
        $t{3}->fill;
        $t{2}->fill;
        $t2->allgrey;
        $t2->black(5);
        $t2->math("\\{angle}CAB = 2 x \\{alpha}");
    };
    push @steps, sub {
        $t1->down;
        $t1->explain("Or angle CAD is half the angle CAB");
        $a{DAB}->remove;
         $a{CAB} = Angle->new($pn, $l{AB}, $l{AC} )->label(" \n2\\{alpha}",80);
        
        $t2->allgrey;
        $t2->math("\\{angle}CAD = \\{half} \\{angle}CAB");
    };

    return \@steps;
}

