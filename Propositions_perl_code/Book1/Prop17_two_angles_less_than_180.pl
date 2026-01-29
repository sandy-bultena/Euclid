#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
  "Any two angles of a triangle are together less than two right angles.";

my $pn = PropositionCanvas->new( -number => 17, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 430 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,17);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #17
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @D = ( 450, 450 );
    my @B = ( 100, 450 );
    my @A = ( 150, 200 );
    my @C = ( 350, 450 );

    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given any triangle ABC");
        
        $t{ABC} = Triangle->new($pn, @A, @B, @C,1,
            -points => [ qw(A top B bottom C bottom) ] );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "The sum of any of the two inner angles "
              . "is less than two right angles" );
        $t{ABC}->set_angles( qw(\\{beta} \\{gamma} \\{theta}) );
        $t2->math("\\{theta}+\\{gamma} < \\{right}+\\{right}");
        $t2->math("\\{theta}+\\{beta} < \\{right}+\\{right}");
        $t2->math("\\{gamma}+\\{beta} < \\{right}+\\{right}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t2->erase;
        $t1->title("Proof");
        $t1->explain("Extend line BC to point D");
        
        $l{CD} = Line->new($pn, @C, @D );
        $p{D} = Point->new($pn,@D)->label( "D", "bottom" );
        $a{CBD} = Angle->new($pn, $l{CD}, $t{ABC}->l(3), -size => 20 )->label("\\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->down;
        $t1->explain(
            "The sum of the angles ACB and ACD is equal to two right angles (I.13)");
        $t2->math("\\{alpha}+\\{theta} = \\{right}+\\{right}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The angle ACD is greater than either angle ABC or CAB\\{nb}(I.16)");
        $t1->explain(
                "Therefore the sum of either ABC or CAB with angle ACB will be "
              . "less than 2 right angles" );
        $t2->math( "\\{beta} < \\{alpha}  \\{therefore} "
              . "\\{beta}+\\{theta} < \\{alpha}+\\{theta}" );
        $t2->math( "\\{gamma} < \\{alpha}  \\{therefore} "
              . "\\{gamma}+\\{theta} < \\{alpha}+\\{theta}" );
        $t2->down;
        $t2->math("\\{beta}+\\{theta} < \\{right}+\\{right}");
        $t2->math("\\{gamma}+\\{theta} < \\{right}+\\{right}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->explain( "The same logic can be applied to the "
              . "other vertices of the triangle" );
        $t2->down;
        $t2->math("\\{beta}+\\{gamma} < \\{right}+\\{right}");

    };

    # -------------------------------------------------------------------------
    return \@steps;
}
