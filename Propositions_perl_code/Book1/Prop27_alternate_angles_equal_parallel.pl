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
my $title = "If a straight line falling on two straight "
  . "lines makes the alternate angles equal to one another, "
  . "then the straight lines are parallel to one another.";

my $pn = PropositionCanvas->new( -number => 27, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 400, 200, -width =>600 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,27);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my ( %l, %p, %c, %a, %t );
    my @objs;

    my @A = ( 100, 350 );
    my @B = ( 400, 350 );
    my @C = ( 100, 500 );
    my @D = ( 400, 500 );
    my @E = ( 275, 300 );
    my @F = ( 375, 600);
    my @G = ( 750, 425);

    my @steps;

    # -------------------------------------------------------------------------
    # Definition
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->title("Definition - Parallel Lines");
        $t3->normal( "Parallel straight lines are straight lines which, "
              . "being in the same plane and being produced indefinitely "
              . "in both directions, do not meet one another in "
              . "either direction." );
        $l{1} = Line->new($pn,@A,@B);
        $l{2} = Line->new($pn,@C,@D);
        for my $i (1..800) {
            $l{1}->extend(1);
            $l{2}->extend(1);
        }
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->erase;
        $t3->title("Definition - Alternate Angles");
        $t3->normal( "If a line intersect two straight lines AB and CD at ".
        "the points E and F, then the pairs of alternate "
        ."angles are: AEF (\\{alpha}), DFE (\\{delta}) and ".
        "CFE (\\{gamma}), BEF (\\{beta})" );
        
        $p{1}=Point->new($pn,$l{1}->start)->label("A","top");
        $p{2}=Point->new($pn,$l{1}->end)->label("B","top");
        $p{3}=Point->new($pn,$l{2}->start)->label("C","top");
        $p{4}=Point->new($pn,$l{2}->end)->label("D","top");
        $l{3}=Line->new($pn,@E,@F);
        
        $p{6}=Point->new($pn,$l{1}->intersect($l{3}))->label("E","topright");
        $p{7}=Point->new($pn,$l{2}->intersect($l{3}))->label("F","bottom");
        
        ($l{4},$l{5}) = $l{1}->split($p{6});
        ($l{6},$l{7}) = $l{2}->split($p{7});
        ($l{8},$l{9},$l{10}) = $l{3}->split($p{6},$p{7});
        
        $a{1}=Angle->new($pn,$l{4},$l{9},-size=>20)->label("\\{alpha}");
        $a{2}=Angle->new($pn,$l{9},$l{5})->label("\\{beta}");
        $a{3}=Angle->new($pn,$l{9},$l{6})->label("\\{gamma}");
        $a{4}=Angle->new($pn,$l{7},$l{9},-size=>20)->label("\\{delta}");
        
        
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        foreach my $o (values %a, values %l, values %p) {
            $o->remove;
        }
        $t3->erase;            
    };
    
    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain( "Start with two straight lines AB and CD" );

        $p{A}=Point->new($pn,@A)->label("A","top");
        $p{B}=Point->new($pn,@B)->label("B","top");
        $l{AB} = Line->new($pn,@A,@B);

        $p{C}=Point->new($pn,@C)->label("C","top");
        $p{D}=Point->new($pn,@D)->label("D","top");
        $l{CD} = Line->new($pn,@C,@D);

    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Construct a third line such that it intersects "
        . "lines AB and CD at points E and F" );

        $l{EF}=Line->new($pn,@E,@F);
        $p{E}=Point->new($pn,$l{1}->intersect($l{EF}))->label("E","topright");
        $p{F}=Point->new($pn,$l{2}->intersect($l{EF}))->label("F","bottom");
        
        ($l{AE},$l{EB}) = $l{AB}->split($p{E});
        ($l{CF},$l{FD}) = $l{CD}->split($p{F});
        ($l{XE},$l{EF},$l{FY}) = $l{EF}->split($p{E},$p{F});
        
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("If angles AEF and EFD are equal, then the lines ".
        "are parallel");
        $a{AEF}=Angle->new($pn,$l{AE},$l{EF})->label("\\{alpha}");
        $a{FDE}=Angle->new($pn,$l{FD},$l{EF})->label("\\{delta}");
        $t2->math("if \\{alpha} = \\{delta}");
        $t2->math("=> AB \\{parallel} CD");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t2->erase;
        $t2->math("\\{alpha} = \\{delta}");
        $t2->allblue;
        
        $t1->title("Proof by Contradiction");
        $t1->explain("Assume that the lines intersect at point G");
        $l{BG}=Line->new($pn,@B,@G)->grey;
        $l{DG}=Line->new($pn,@D,@G)->grey;
        $p{G}=Point->new($pn,@G)->label("G","top");
        $t2->math("\\{thereexists} \\{triangle}EFG");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then angle AEF is an exterior angle to the ".
        "triangle EFG, which means that angle AEF is larger than ".
        "angle EFG (I.16)");
        $t2->math("\\{alpha} > \\{delta} ");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("But AEF equals EFG, so there is a contradiction");
        $t2->allgrey;
        $t2->red([0,-1]);
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Thus the initial assumption must be wrong");
        $t2->allgrey;
        $t2->red(1);
    };
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The two lines can never meet at point G, and are therefore parallel");
        $t2->math("\\{therefore} AB \\{parallel} CD");
    };    
    push @steps, sub {
        $t2->allgrey;
        $t2->blue(0);
        $t2->black(-1);
    };    
    


    return \@steps;
}

