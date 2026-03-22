#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
    "If a straight line stands on a straight line, "
  . "then it makes either two right angles or angles "
  . "whose sum equals two right angles.";

my $pn = PropositionCanvas->new( -number => 13, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 50,  500 );
my $t3 = $pn->text_box( 150, 450 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,13);
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

    my @D = ( 100, 400 );
    my @C = ( 450, 400 );
    my @A = ( 400, 150 );
    my @B = ( 300, 400 );

    my @steps;

    push @steps, sub {
        $t1->title("In other words");
        $t1->explain( "Start with an arbitrary line segment CD "
              . "and an arbitrary point B on the line" );
        $p{D} = Point->new($pn,@D)->label( "D", "left" );
        $p{C} = Point->new($pn,@C)->label( "C", "right" );
        $l{CD} = Line->new($pn, @D, @C );
        $p{B} = Point->new($pn,@B)->label( "B", "bottom" );
        ( $l{BD}, $l{BC} ) = $l{CD}->split( $p{B} );
    };

    push @steps, sub {
        $t1->explain("Draw a line from point an arbitrary point A to point B");
        $p{A} = Point->new($pn,@A)->label( "A", "top" );
        $l{AB} = Line->new($pn, @A, @B );
    };
    push @steps, sub {
        $t1->explain("The sum of the angles ABD and ABC is equal to two right angles");
        $a{alpha} = Angle->new($pn, $l{AB}, $l{BD}, -size => 70 )->label("\\{alpha}");
        $a{beta} = Angle->new($pn, $l{BC}, $l{AB}, -size => 80 )->label("\\{beta}");
        $t2->math("\\{angle}DBA + \\{angle}ABC = 2 \\{right}");
        $t2->math("   \\{alpha} +    \\{beta} = 2 \\{right}");
    };

    push @steps, sub {
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $a{alpha}->grey;
        $a{beta}->grey;
        $l{AB}->grey;
        $t1->explain("Construct a perpendicular line to point E (I.11)");
        $l{BE} = $l{CD}->perpendicular($p{B} );
        $p{E}=Point->new($pn,$l{BE}->end)->label( "E", "top" );
        $a{gamma} = Angle->new($pn, $l{BC}, $l{BE} )->label("\\{gamma}");
        $a{epsilon} =
          Angle->new($pn, $l{BE}, $l{BD}, -size => 20 )->label("\\{epsilon}");
        $t1->explain("1. Angles \\{gamma} and \\{epsilon} are right angles");
        $t3->math("1.     \\{epsilon} = \\{gamma}");
    };

    push @steps, sub {
        $t1->explain("2. Angle \\{gamma} is the sum of angles \\{beta} and \\{theta}");
        $a{theta} = Angle->new($pn, $l{AB}, $l{BE}, -size => 90 )->label("\\{theta}");
        $a{alpha}->grey;
        $a{epsilon}->grey;
        $a{beta}->normal;
        $l{AB}->normal;
        $t3->math("2.     \\{gamma} = \\{beta} + \\{theta}");
    };

    push @steps, sub {
        $t1->explain("3. Add angle \\{epsilon} to \\{gamma} and to \\{theta} plus \\{beta}");
        $t3->math( "3. \\{epsilon} + \\{gamma} = "
              . "\\{beta} + \\{theta} + \\{epsilon}" );
        $a{epsilon}->normal;
    };

    push @steps, sub {
        $a{alpha}->normal;
        $a{beta}->grey;
        $a{gamma}->grey;
        $l{BE}->normal;
        $t3->down;
        $t1->explain("4. Angle \\{alpha} is the sum of angles \\{theta} and \\{epsilon}");
        $t3->math("4.     \\{alpha} =     \\{theta} + \\{epsilon}");
    };
    push @steps, sub {
        $a{beta}->normal;
        $t1->explain("5. Add angle \\{beta} to \\{alpha} and to \\{theta} plus \\{epsilon}");
        $t3->math( "5. \\{beta} + \\{alpha} = "
              . "\\{beta} + \\{theta} + \\{epsilon}" );
    };

    push @steps, sub {
        $a{gamma}->normal;
        $a{theta}->grey;
        $t1->explain( "6. From equations 3 and 5, we have the sums of two angles ".
        "equal to the sum of \\{beta}, ".
        "\\{theta} and \\{epsilon} " );
        $t1->explain( "And since things that equal the"
              . " same thing equal each other..." );
        $t1->explain( "The sum of \\{beta} and \\{alpha} equals the sum of the"
              . " two right angles, \\{gamma} and\\{nb}\\{epsilon}" );

        $t3->math("6. \\{beta} + \\{alpha} = \\{gamma} + \\{epsilon} = 2 \\{right}");
    };

    push @steps, sub {
        $t3->down;
        $a{epsilon}->grey;
        $a{gamma}->grey;
        $a{theta}->grey;
        $l{BE}->grey;
        $t3->math("\\{angle}ABC + \\{angle}ABD = 2 \\{right}");
    };

    return \@steps;
}
