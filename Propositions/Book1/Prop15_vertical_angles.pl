#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title = "If two straight lines cut one another, then they make "
  . "the vertical angles equal to one another.";

my $pn = PropositionCanvas->new( -number => 15, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 430 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,15);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #15
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my @objs;

    my @C = ( 100, 400 );
    my @D = ( 400, 400 );
    my @A = ( 150, 250 );
    my @B = ( 300, 500 );
    my @E = ( 450, 375 );

    my @steps;

    push @steps, sub {
        $t1->title("In other words");
        $t1->explain( "Given two arbitrary line segments AB "
              . "and CD which intersect at point E" );
        $p{A} = Point->new($pn,@A)->label( "A", "top" );
        $p{B} = Point->new($pn,@B)->label( "B", "bottom" );
        $l{AB} = Line->new($pn, @A, @B );
        $p{C} = Point->new($pn,@C)->label( "C", "left" );
        $p{D} = Point->new($pn,@D)->label( "D", "right" );
        $l{CD} = Line->new($pn, @C, @D );
        $p{E} =
          Point->new($pn, $l{AB}->intersect( $l{CD} ) )->label( "E", "bottom" );
    };
    push @steps, sub {
        $t1->explain("Angles AEC and DEB are equal");
        $t1->explain("Angles AED and CEB are equal");
        ($l{CE},$l{DE}) = $l{CD}->split($p{E});
        ($l{AE},$l{BE}) = $l{AB}->split($p{E});
        $a{alpha} = Angle->new($pn, $l{AE}, $l{CE} )->label("\\{alpha}");
        $a{beta} = Angle->new($pn, $l{BE}, $l{DE} )->label("\\{beta}");
        $a{gamma} = Angle->new($pn, $l{DE}, $l{AE}, -size => 50 )->label("\\{gamma}");
        $a{theta} = Angle->new($pn, $l{CE}, $l{BE}, -size => 50 )->label("\\{theta}");
        $t2->math("\\{alpha} = \\{beta}");
        $t2->math("\\{gamma} = \\{theta}");
    };

    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
        $t2->erase;
    };

    push @steps, sub {
        $t1->explain( "CD is a straight line, so the sum of AEC and AED equals "
              . "two right angles (I.13)" );
        $t2->math("\\{alpha} + \\{gamma} = \\{right} + \\{right}");
        $l{BE}->grey;
        $a{theta}->grey;
        $a{beta}->grey;
    };

    push @steps, sub {
        $t1->explain( "AB is a straight line, so the sum of AED and DEB equals "
              . "two right angles (I.13)" );
        $t2->math("\\{gamma} + \\{beta} = \\{right} + \\{right}");
        $l{BE}->normal;
        $l{CE}->grey;
        $a{beta}->normal;
        $a{alpha}->grey;
    };
    push @steps, sub {
        $t1->explain(
                "Since the sums of the angles are equal to the same thing "
              . "(two right angles), they are equal to each other" );
              $l{CE}->normal;
              $a{alpha}->normal;
        $t2->math("\\{alpha} + \\{gamma} = \\{gamma} + \\{beta}");
    };
    push @steps, sub {
        $t2->allgrey;
        $t2->black(-1);
        $a{gamma}->grey;
        $t1->explain("Thus angle AEC is equal to angle DEB");
        $t2->math("\\{therefore} \\{alpha} = \\{beta}");        
    };

    push @steps, sub {
        $t1->down;
        $t1->explain( "CD is a straight line, so the sum of DEB and CEB equals "
              . "two right angles (I.13)" );
              $l{AE}->grey;
              $a{theta}->normal;
              $a{alpha}->grey;
              $a{gamma}->grey;
        $t2->down;
        $t2->allgrey;
        $t2->math("\\{beta} + \\{theta} = \\{right} + \\{right}");
    };

    push @steps, sub {
        $t1->explain( "AB is a straight line, so the sum of AED and DEB equals "
              . "two right angles (I.13)" );
              $l{CE}->grey;
              $a{gamma}->normal;
              $a{theta}->grey;
              $l{AE}->normal;
        $t2->math("\\{gamma} + \\{beta} = \\{right} + \\{right}");
    };
    push @steps, sub {
        $t1->explain(
                "Since the sums of the angles are equal to the same thing "
              . "(two right angles), they are equal to each other" );
              $a{theta}->normal;
              $l{CE}->normal;
        $t2->math("\\{beta} + \\{theta} = \\{gamma} + \\{beta}");
    };
    push @steps, sub {
        $t2->allgrey;
        $t2->black(-1);
        $a{beta}->grey;
        $t1->explain("Thus angle CEB equals angle AED");
        $t2->math("\\{therefore} \\{theta} = \\{gamma}");
    };
    push @steps, sub {
        $a{beta}->normal;
        $a{alpha}->normal;
        $t2->allgrey;
        $t2->black([-1,3]);
    };

    return \@steps;
}

