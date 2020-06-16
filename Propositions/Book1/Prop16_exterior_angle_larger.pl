#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $title =
    "In any triangle, if one of the sides is produced, "
  . "then the exterior angle is greater than either of "
  . "the interior and opposite angles.";

my $pn = PropositionCanvas->new( -number => 16, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 430 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,16);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Proposition #16
# ============================================================================
sub explanation {

    my (%l,%p,%c,%a,%t);
    my @objs;

    my @D = ( 450, 450 );
    my @B = ( 100, 450 );
    my @A = ( 150, 200 );
    my @C = ( 350, 450 );

    my @steps;

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Start with a triangle ABC");
        $t{ABC} =
          Triangle->new($pn, @A, @B, @C,1,
            -points => [ qw(A top B bottom C bottom) ] );
        $l{AB} = $t{ABC}->l(1);
        $l{BC} = $t{ABC}->l(2);
        $l{AC} = $t{ABC}->l(3);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Extend line BC to point D");
        $l{CD} = Line->new($pn, @C, @D );
        $p{D} = Point->new($pn,@D)->label( "D", "bottom" );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The angle ACD is larger than either ABC or CAB");
        $a{alpha} = Angle->new($pn, $l{CD}, $t{ABC}->l(3), -size => 20 )->label("\\{alpha}");
        $a{gamma} = Angle->new($pn, $l{BC}, $l{AB}, -size => 40 )->label("\\{gamma}");
        $a{beta} = Angle->new($pn, $l{AB}, $l{AC} )->label("\\{beta}");

        $t2->math("\\{alpha} > \\{gamma}");
        $t2->math("\\{alpha} > \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->erase;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Bisect line AC at point E (I.10)");
        $t2->erase;
        $a{gamma}->grey;
        $a{alpha}->grey;
        $l{AB}->grey;
        $l{BC}->grey;
        $l{CD}->grey;
        $a{beta}->grey;
        $p{E} = $t{ABC}->l(3)->bisect( );
        $p{E}->label( "E", "top" );
        ( $l{CE}, $l{AE} ) = $t{ABC}->l(3)->split( $p{E} );
        $l{CE}->label( "y", "left" );
        $l{AE}->label( "y", "right" );
        $t2->math("AE = EC = y");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create line segment BE");
        $l{BE} = Line->new($pn, @B, $p{E}->coords )->label( "x", "top" );
        
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Extend line BE to line F, where EF equals BE");
        $l{BF1} = $l{BE}->extend( $p{E}->distance_to(@B) + 50);
        $c{E} = Circle->new($pn, $p{E}->coords, @B );
        my @p = $c{E}->intersect( $l{BF1} );
        $p{F} = Point->new($pn,@p[0,1])->label( "F", "right" );
        $c{E}->remove;

        ( $l{BE}, $l{EF}, my $x ) = $l{BF1}->split( $p{E}, $p{F} );
        $x->remove;
        
        $l{BE}->label(qw(x top));
        $l{EF}->label( "x", "top" );
        $l{BF1}->remove;
        $t2->math("BE = EF = x");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Angles AEB and CEF are vertical to each other, "
              . "hence they are equal (I.15)" );
        $a{theta1} = Angle->new($pn,$l{AE},$l{BE})->label("\\{theta}",20);
        $a{theta2} = Angle->new($pn,$l{CE},$l{EF})->label("\\{theta}",20);
        $t2->math("\\{angle}AEB = \\{angle}CEF = \\{theta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create line CF");
        $l{CF} = Line->new($pn, @C, $p{F}->coords );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Triangles ABE and FEC are equivalent since they "
              . "have two equal sides, with an equal angle AEB and FEC" );
        $l{AB}->normal;
        $t{ABE}=Triangle->assemble($pn,-lines=>[$t{ABC}->l(1),$l{BE},$l{AE}],
        -angles=>[$t{ABC}->a(1),undef,undef])->fill($sky_blue);
        $t{ECF}=Triangle->assemble($pn,-lines=>[$l{CE},$l{CF},$l{EF}])->fill($lime_green);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Thus, angles BAE and ECF are equal (I.4)");
        
    $a{beta}->normal;
        $t{ECF}->set_angles(undef,"\\{beta}",undef,0,60,0);
        $t2->math("\\{angle}BAE = \\{angle}ECF = \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{ABE}->l(2)->remove;
        $a{theta1}->remove;
        $t{ECF}->l(3)->remove;
        $a{theta2}->remove;
        $a{alpha}->normal;
        
        $t1->explain( "As can be seen angle ECF, which is equals to angle BAC, "
              . "is less than angle ACD" );
        $t2->math("\\{angle}ECF = \\{angle}BAC< \\{angle}ACD");
        $t{ABE}->fill;
        $t{ECF}->fill;
        $t2->math("\\{alpha} > \\{beta}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->explain("Thus it has been shown that the exterior ".
        "angle ACD is larger than the interior angle BAC");
        $t2->allgrey;
        $t2->black(-1);
        $t{ECF}->remove;
        $t{ABE}->remove;
        $p{E}->remove;
        $l{AB}->draw;
        $l{BC}->draw;
        $l{AC}->draw;
        $l{CD}->normal;        
        $t{ABC}->fill($pale_pink);
    };


    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->explain( "Using the same method as before, "
              . "we can prove that angle BCG is greater than ABC" );
              $t{ABC}->fill;
              $a{alpha}->normal;
    };
    
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{ECF}->remove;
        $t{ABE}->remove;
        $p{E}->remove;

        $t{ABC}->draw(-1);
        $p{F}->remove;

        $l{AG} = $t{ABC}->l(3)->clone;
        $l{AG}->prepend(100);
        $l{CG} = Line->new($pn, @C, $l{AG}->start );
        $l{AG}->remove;
        
        $p{G} = Point->new($pn, $l{CG}->end )->label( "G", "bottom" );
        $a{BCG} = Angle->new($pn, $t{ABC}->l(2), $l{CG}, -size => 20 )->label("\\{alpha}");
        $t{ABC}->p(3)->label;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $p{E} = $t{ABC}->l(2)->bisect;
        $l{BE} = Line->new($pn, $p{E}->coords, @B )->label( "y", "bottom" );
        $l{CE} = Line->new($pn, $p{E}->coords, @C )->label( "y", "top" );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{AE} = Line->new($pn, @A, $p{E}->coords )->label( "x", "right" );
        $a{beta}->grey;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{AF1} = $l{AE}->clone;
        $l{AF1}->extend( $p{E}->distance_to(@A) + 50 );
        $c{E} = Circle->new($pn, $p{E}->coords, @A );
        my @p = $c{E}->intersect( $l{AF1} );
        $p{F} = Point->new($pn,@p[0,1]);
        $c{E}->remove;
        $l{EF} =
          Line->join( $p{E}, $p{F}, -1 )->label( "x", "left" );
        $l{AF1}->remove;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{CF} = Line->new($pn, @C, $p{F}->coords );
        $t{ABE}=Triangle->assemble($pn,-lines=>[$t{ABC}->l(1),$l{BE},$l{AE}],
        -angles=>[undef,$t{ABC}->a(2),undef])->fill($lime_green);
        $t{CEF}=Triangle->assemble($pn,-lines=>[$l{CE},$l{EF},$l{CF}])->fill($sky_blue);
        $t{ABE}->set_angles(undef,undef,"\\{epsilon}",20,0,0);
        $t{CEF}->set_angles(undef,"\\{epsilon}",undef,20,0,0);
        $t{ABC}->grey;
        $t{ABE}->normal;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{CEF}->set_angles("\\{gamma}",undef,undef,60,0,0);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {

        $p{E}->remove;
        $t{ABE}->l(3)->remove;
        $t{ABE}->a(3)->remove;
        $t{ABE}->remove_labels;
        $t{CEF}->l(2)->remove;
        $t{CEF}->a(2)->remove;
        $t{CEF}->remove_labels;
        $t{ABE}->fill;
        $t{CEF}->fill;
        
        $t2->math("\\{alpha} > \\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t{ABE}->remove;
        $t{CEF}->remove;
        $p{F}->remove;
        $p{G}->remove;
        $l{CG}->remove;
        $a{BCG}->remove;
        $t{ABC} =
          Triangle->new($pn, @A, @B, @C,-1,
            -points => [ qw(A top B bottom C bottom) ] );
        $l{CD} = Line->new($pn, @C, @D );
        $a{alpha} = Angle->new($pn, $l{CD}, $t{ABC}->l(3), -size => 20 )->label("\\{alpha}");
        $t{ABC}->set_angles(qw(\\{beta} \\{gamma}),undef,0,40,0);
    };

    # -------------------------------------------------------------------------
    return \@steps;
}

