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
my $title = "To construct a parallelogram equal to a given ".
"triangle in a given rectilinear angle.";

my $pn = PropositionCanvas->new( -number => 42, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 400, 500 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,42);
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
    my $top = 200;
    my $bot = 400;
    my @A   = ( 150, $top );
    my @B   = ( 125, $bot );
    my @C   = ( $B[0] + 200, $bot );
    my @D   = ( 100, $bot + 125 );
    my @E   = ( 300, $bot + 125 );
    my @F   = ( 100, $bot + 250 );

    my @steps;

    # ------------------------------------------------------------------------
    # In other words
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Create a parallelogram with a specific angle, whose area is equal to a given triangle");
    };

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->erase;
        $t1->title("Construction");
        $t1->explain("Start with triangle ABC and angle \\{delta}");
        $t{ABC} = Triangle->new( $pn, @A, @B, @C, 1, -points => [qw(A top B bottom C bottom)] );
        $l{DF} = Line->new( $pn, @D, @F );
        $l{EF} = Line->new( $pn, @E, @F );
        $a{DFE} = Angle->new( $pn, $l{EF}, $l{DF} )->label("\\{delta}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Bisect line BC at point E\\{nb}(I.10).  Draw line AC");
        $p{E} = $t{ABC}->l(2)->bisect->label(qw(E bottom));
        $l{AE} = Line->new( $pn, @A, $p{E}->coords );
        ( $l{BE}, $l{EC} ) = $t{ABC}->l(2)->split( $p{E} );

        $t{ABE} = Triangle->assemble( $pn, -lines => [ $t{ABC}->l(1), $l{BE}, $l{AE} ] );
        $t{AEC} = Triangle->assemble( $pn, -lines => [ $l{AE},        $l{EC}, $t{ABC}->l(3) ] );

        $t3->math("BE = EC");
        $t3->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Copy angle \\{delta} onto line EC, with the vertex at point E\\{nb}(I.23)" );
        ( $l{EF}, $a{CEF} ) = $a{DFE}->copy( $p{E}, $l{EC} );
        $l{EF}->extend(200);
        $l{EF}->normal;
        $a{CEF}->label( "\\{delta}", 30 );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw a line AF, through A, parallel to BC\\{nb}(I.31)");
        $l{AG} = $t{ABC}->l(2)->parallel( $t{ABC}->p(1) );
        $l{AG}->prepend(150);
        $p{F} = Point->new( $pn, $l{AG}->intersect( $l{EF} ) )->label( "F", "top" );
        $t3->math("AF \\{parallel} BC");
        $t3->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Draw a line CG, through C, parallel to EF\\{nb}(I.31)");
        $l{CG} = $l{EF}->parallel( $t{ABC}->p(3) );
        $l{EF}->normal;
        $l{CG}->prepend(100);
        $p{G} = Point->new( $pn, $l{CG}->intersect( $l{AG} ) )->label( "G", "top" );
        $t3->math("CG \\{parallel} EF");
        $t3->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $s{FECG} = Polygon->new( $pn, 4, $p{F}->coords, $p{E}->coords, $t{ABC}->p(3)->coords, $p{G}->coords );
        $l{CG}->grey;
        $l{AG}->grey;
        $l{EF}->grey;

        $t1->explain("The parallelogram FECG is equal in area to the triangle ABC");
        
        my @a = $t{ABC}->l(3)->intersect($s{FECG}->l(1));
        $t{aEC} = Triangle->new($pn,@a,$p{E}->coords,@C,-1);
        
        $t{ABC}->fill($sky_blue);
        $s{FECG}->fillover( $t{ABC}, $lime_green );
        $t{aEC}->fillover($s{FECG},$teal);
        
        $t3->math("\\{triangle}ABC = FECG");
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof:");
        $t3->erase;
        $t3->math("BE = EC");
        $t3->math("AF \\{parallel} BC");
         $t3->math("CG \\{parallel} EF");
        $t3->allblue;
        
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Triangle ABE and AEC have equal bases (BE and EC) "
                      . "and are on the same parallels, so their areas "
                      . "are equal\\{nb}(I.38)" );
        $s{FECG}->fill;
        $t{ABC}->fill;
        $t{aEC}->fill;
        $t{ABE}->fill($sky_blue);
        $t{AEC}->fill($blue);
        $t3->allgrey;
        $t3->blue(1);
        $t3->math("\\{triangle}ABE = \\{triangle}AEC = \\{half} \\{triangle}ABC");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Triangle AEC shares the same base as the parallelogram "
                      . "FECG, so it is half the area of the parallelogram\\{nb}(I.41)" );
        $t{ABE}->fill;
        $s{FECG}->fillover( $t{AEC}, $lime_green );
        $t{aEC}->fillover($s{FECG},Colour->add($blue,$lime_green));
        $t3->allgrey;
        $t3->blue(1);
        $t3->math("       \\{triangle}AEC = \\{half} FECG");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Hence, FECG is equal in area to ABC");
        $t{AEC}->fill;
        $t{ABC}->fill($sky_blue);
        $t{aEC}->fillover($t{ABC},$teal);
        $t3->allgrey;
        $t3->black([-1,-2]);
        $t3->math("FECG = \\{triangle}ABC");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->blue([0,1,2]);
        $t3->black(-1);
    };

    return \@steps;
}

