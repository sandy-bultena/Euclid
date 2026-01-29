#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title = "To bisect a given finite straight line.";

my $pn = PropositionCanvas->new( -number => 10, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 500, 430 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,10);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #10
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @A = ( 100, 400 );
    my @B = ( 400, 400 );
    my @C = ( ($A[0]+$B[0])/2, $A[1]-20);
    my @D = ( ($A[0]+$B[0])/2, $A[1]+20);

    my @steps;

    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Start with a line segment AB");
        $p{A} = Point->new( $pn, @A )->label( "A", "left" );
        $p{B} = Point->new( $pn, @B )->label( "B", "right" );
        $l{AB} = Line->new( $pn, @A, @B );
    };

    push @steps, sub {
        $t1->explain("and cut it in half");
        $l{half} = Line->new($pn, @C, @D);
    };

    push @steps, sub {
        $t1->title("Construction:");
        $l{half}->remove;
    };

    push @steps, sub {
        $t1->explain( "Construct an equilateral triangle on AB and label the vertex\\{nb}C\\{nb}(I.1)" );
        $t{1} = EquilateralTriangle->build( $pn, @A, @B, 2 );
        ( $l{AC}, $l{BC}, $p{C} ) = ( $t{1}->l(3), $t{1}->l(2), $t{1}->p(3) );
        $p{C}->label( "C", "top" );
        $l{AC}->normal;
        $l{BC}->normal;
    };

    push @steps, sub {
        $t1->explain("Bisect angle ACB, and extend line past the line segment AB\\{nb}(I.9)");
        $a{t}=Angle->new($pn,$l{AC},$l{BC});
        ( $l{CD}, $p{D}, @objs ) = $a{t}->bisect( 2 );
        $l{CD}->normal;
        $a{t}->remove();
    };

    push @steps, sub {
        my @p = $l{CD}->intersect( $l{AB} );
        $p{D}->remove;
        foreach my $o (@objs) {
            $o->remove if $o;
        }
        $p{D} = Point->new( $pn, @p )->label( "D", "topright" );
    };

    push @steps, sub {
        $t1->explain("Line AD is equal to line DB");
        ( $l{AD}, $l{BD} ) = $l{AB}->split( $p{D} );
        ( $l{CD}, $l{Dx} ) = $l{CD}->split( $p{D} );
        $l{AD}->label( "r", "bottom" );
        $l{BD}->label( "r", "bottom" );
        $l{AC}->grey;
        $l{BC}->grey;
        $l{CD}->grey;
        $l{Dx}->grey;
        $t2->math("AD = DB");
    };

    push @steps, sub {
        $t1->down;
        $l{AD}->label;
        $l{BD}->label;
        $t2->erase;
        $t1->title("Proof");
        $t{1}->fill($sky_blue);
        $l{AC}->normal;
        $l{BC}->normal;
        $t1->explain("AC equals BC since they are sides of an equilateral triangle");
        $l{AC}->label( "r1", "left" );
        $l{BC}->label( "r1", "right" );
        $t2->math("AC = CB");
    };

    push @steps, sub {
        $t1->explain("Angle ACD equals BCD since we bisected angle ACB");
        $l{CD}->normal;
        $a{ACD} = Angle->new( $pn, $l{AC}, $l{CD} )->label("\\{alpha}");
        $a{DCB} = Angle->new( $pn, $l{CD}, $l{BC}, -size => 50 )->label("\\{alpha}");
        $t2->math("\\{angle}ACD = \\{angle}BCD = \\{alpha}");
    };

    push @steps, sub {
        $t1->explain(   "Since the two triangles ACD and CDB have two "
                      . "equal sides, and an equal angle between them," );
        $t{1}->fill();
        $t{3} = Triangle->assemble( $pn, -lines => [ $l{AD}, $l{CD}, $l{AC} ] )->fill($lime_green);
        $t{2} = Triangle->assemble( $pn, -lines => [ $l{BD}, $l{BC}, $l{CD} ] )->fill($pale_pink);

    };

    push @steps, sub {
        $t1->explain(   "then "
                      . "the third side of each triangle is equal (I.4)" );
        $l{AD}->label( "r", "bottom" );
        $l{BD}->label( "r", "bottom" );
        $t2->math("AD = DB = r");
    };

    push @steps, sub {
        $t{3}->fill(undef);
        $t{2}->fill(undef);

        $t{3}->grey;
        $t{2}->grey;
        $p{C}->remove;
        $l{AB}->draw(-1);
        $l{AD}->label( "r", "bottom" );
        $l{BD}->label( "r", "bottom" );
        $a{ACD}->grey;
        $a{DCB}->grey;
        $l{Dx}->grey;
        $t2->allgrey;
        $t2->black(-1);
    };

    return \@steps;
}

