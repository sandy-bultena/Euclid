#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
    "If with any straight line, and at a point on it, two straight lines "
  . "not lying on the same side make the sum of the adjacent angles equal "
  . "to two right angles, then the two straight lines are in a straight "
  . "line with one another.";

my $pn = PropositionCanvas->new( -number => 14, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 275, 275 );
my $t2 = $pn->text_box( 500, 430 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,14);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #13
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my @objs;

    my @C = ( 100, 450 );
    my @D = ( 400, 450 );
    my @A = ( 150, 250 );
    my @B = ( 250, 450 );
    my @E = ( 450, 375 );

    my @steps;

    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Start with an arbitrary line segment AB");
        $p{A} = Point->new($pn,@A)->label( "A", "top" );
        $p{B} = Point->new($pn,@B)->label( "B", "bottom" );
        $l{AB} = Line->new($pn, @A, @B );
    };

    push @steps, sub {
        $t1->explain("Draw a line from B to an arbitrary point C");
        $p{C} = Point->new($pn,@C)->label( "C", "left" );
        $l{BC} = Line->new($pn, @B, @C );
    };

    push @steps, sub {
        $t1->explain(
                "Draw a line from B to a point D (not on the same side as C),"
        );
        $p{C} = Point->new($pn,@D)->label( "D", "right" );
        $l{BD} = Line->new($pn, @B, @D );
        $a{alpha} = Angle->new($pn, $l{AB}, $l{BC}, -size => 40 )->label("\\{alpha}");
        $a{beta} = Angle->new($pn, $l{BD}, $l{AB}, -size => 30 )->label("\\{beta}");
    };
    push @steps, sub {
        $t1->explain("If the sum of the angles ABC and ABD equals ".
        "the sum of two right angles...");
        $t2->math("\\{alpha} + \\{beta} = \\{right} + \\{right}");
    };
    push @steps, sub {
        $t1->explain("... then BC and BD make a single line CD");
        $t2->math("CB, BD = CD");
    };
    push @steps, sub {
        $t2->erase;
        $t2->math("\\{alpha} + \\{beta} = \\{right} + \\{right}");
        $t1->down;
        $t1->title("Proof by Contradiction");
        $t2->blue([0,1]);
    };
    push @steps, sub {
        $t1->explain("Assume line BE makes a straight line with CB");
        $t2->down;
        $t2->math("CB, BE = CE");
        $t2->blue([0,1]);

        $p{E} = Point->new($pn,@E)->label( "E", "top" );
        $l{BE} = Line->new($pn, @B, @E );
        $a{theta} = Angle->new($pn, $l{BE}, $l{AB}, -size => 70 )->label("\\{theta}");
          $l{BD}->grey;
          $a{beta}->grey;
    };

    push @steps, sub {
        $t1->explain( "If CBE is a straight line, then the sum of \\{alpha} and \\{theta} "
              . " equals two right angles (I.13)" );
        $t2->math("\\{alpha} + \\{theta} = \\{right} + \\{right}");
    };

    push @steps, sub {
        $l{BD}->normal;
        $a{beta}->normal;
        $a{alpha}->normal;
        $t1->explain("But the sum of \\{alpha} and \\{beta} also equals two right angles");
        $t2->math("\\{alpha} + \\{theta} = \\{alpha} + \\{beta}");
    };

    push @steps, sub {
        $t1->explain( "This implies that angles \\{beta} equals \\{theta}..." );
        $t2->math("\\{beta} = \\{theta}");
        $a{alpha}->grey;
        $t2->blue([0,1]);
    };

    push @steps, sub {
        $t1->explain( "... which is "
              . "impossible since \\{beta} is the sum of \\{theta} and \\{epsilon}" );
        $t2->math("\\{beta} = \\{theta} + \\{epsilon}");
       $a{epsilon} =
        Angle->new($pn, $l{BD}, $l{BE}, -size => 60 )->label("\\{epsilon}");
        $t2->allgrey;
        $t2->blue([0,1]);
        $t2->red([4,5]);
    };

    push @steps, sub {
        $t1->explain("The assumption that CB,BE make a straight line led to a ".
        "contradiction, and therefore must be incorrect");
        $t2->allgrey;
        $t2->blue([0]);
        $t2->red(1);
    };

    push @steps, sub {
        $t1->down;
        $t1->explain("Thus, CB and BD form a straight line\n");
        $t2->allgrey;
        $t2->blue([0]);
        $a{alpha}->normal;
        $a{epsilon}->grey;
        $a{theta}->grey;
        $l{BE}->grey;
        $t2->math("CB, BD = CD");
    };

    return \@steps;
}

