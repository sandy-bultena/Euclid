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
my $title = "To describe a square on a given straight line.";

my $pn = PropositionCanvas->new( -number => 46, -title => $title );
$pn->copyright;

my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 450, 200 );
my $t3 = $pn->text_box( 450, 400 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,46);
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

    my ( %l, %p, %c, %a, %t, %s );
    my @objs;
    my $top = 125;
    my $bot = 325;
    my @A   = ( 175, $bot );
    my @B   = ( 350, $bot );

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("Construction");
        $t1->explain("Start with a given line AB");
        $p{A} = Point->new( $pn, @A )->label(qw(A bottom));
        $l{AB} = Line->new( $pn, @A, @B );
        $p{B} = Point->new( $pn, @B )->label(qw(B bottom));
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
            "Draw a line AC perpendicular to AB, from point A\\{nb}(I.11)")
          ;
        $l{AC} = $l{AB}->perpendicular( $p{A} );
        $l{AC}->extend(100);
        $p{C} = Point->new( $pn, $l{AC}->end )->label(qw(C top));
        $a{BAC} = Angle->new( $pn, $l{AB}, $l{AC} )->label("\\{alpha}");
        $t2->math("\\{alpha} = \\{right}");
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Define point D such that AD equals AB\\{nb}(I.3)");
        $c{A} = Circle->new( $pn, @A, @B );
        $p{D} =
          Point->new( $pn, $c{A}->intersect( $l{AC} ) )->label(qw(D left));
        ( $l{AD}, $l{DC} ) = $l{AC}->split( $p{D} );
        $l{AD}->label(qw(a left));
        $l{AB}->label(qw(a bottom));
        $c{A}->remove;
        $t2->math("AD = AB");
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
            "Draw a line DE through D parallel to line AB\\{nb}(I.31)");
        $l{DE1} = $l{AB}->parallel( $p{D} );
        $t2->math("AB \\{parallel} DE");
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Draw a line through B parallel to line AD\\{nb}(I.31) "
              . "intersecting the previous line at point E" );
        $l{BE1} = $l{AD}->parallel( $p{B} );
        $p{E} =
          Point->new( $pn, $l{BE1}->intersect( $l{DE1} ) )->label(qw(E top));
        ( $l{BE2}, $l{BE}, $l{BE1} ) = $l{BE1}->split( $p{E}, $p{B} );
        ( $l{DE2}, $l{DE}, $l{DE1} ) = $l{DE1}->split( $p{E}, $p{D} );
        $l{BE}->normal;
        $l{DE}->normal;
        $l{DE1}->grey;
        $l{DE2}->grey;
        $l{BE1}->grey;
        $l{BE2}->grey;
        $t2->math("AD \\{parallel} BE");
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("ABED is a square");
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof:");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since AB is parallel to DE, and AD is parallel to "
              . "BE, ABED is a parallelogram, and AB equals DE and AD equals "
              . "BE\\{nb}(I.34)" );

        $t2->allgrey;
        $t2->blue([2,3]);
        $l{DE}->label( "a", "top" );
        $l{BE}->label( "a", "right" );
        $t3->math("AB = DE");
        $t3->math("AD = BE");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "But, AD equals AB, thus all the sides of the "
              . "parallelogram are equal, so ABED is an equilateral" );
        $t2->allgrey;
        $t2->blue([1]);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Line DA intersects two parallel lines, thus the "
              . "angles DAB and ADE equal two right angles\\{nb}(I.29)" );
        $a{D} = Angle->new( $pn, $l{AD}, $l{DE} )->label("\\{delta}");

        $t3->allgrey;
        $t2->allgrey;
        $t2->blue([2]);

        $t3->math("\\{alpha} + \\{delta} = 2\\{right}");
        $t3->math("\\{delta} = \\{right}");

    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "In a parallelogram, the opposite angles are equal "
              . "to one another, so angles DEB and EBA are also right angles"
              . "\\{nb}(I.34)" );
        $a{E} = Angle->new( $pn, $l{DE}, $l{BE} )->label("\\{epsilon}");
        $a{B} = Angle->new( $pn, $l{BE}, $l{AB} )->label("\\{beta}");
        $t3->allgrey;
        $t2->allgrey;
        $t2->blue(0);
        $t3->black(-1);
        $t3->math("\\{epsilon} = \\{right}");
        $t3->math("\\{beta} = \\{right}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "An equilateral parallelogram with all right "
              . "angles is a square" );
        $t2->allblue;
        $t3->allblack;
        $t3->grey(2);
    };

    return \@steps;
}
