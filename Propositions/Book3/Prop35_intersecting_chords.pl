#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If in a circle two straight lines cut one another, the rectangle "
  . "contained by the segments of the one is equal to the rectangle contained by "
  . "the segments of the other.";

$pn->title( 35, $title, 'III' );
my $t1 = $pn->text_box( 820, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t3 = $pn->text_box( 460, 200 );
my $t2 = $pn->text_box( 400, 650 );
my %txt;

my $steps;
push @$steps, Proposition::title_page3($pn);
push @$steps, Proposition::toc3( $pn, 35 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my ( %l, %p, %c, %s, %a );

    my @c1 = ( 260, 350 );
    my $r1 = 190;

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("In other words");
        $t4->explain(
                "If lines AC and BD cross each other in a circle at point E, "
                  . "then the product of AE,EC is equal to the product BE,ED" );
        $c{1} = Circle->new( $pn, $c1[0], $c1[1], $c1[0], $c1[1] + $r1 );
        $p{A} = $c{1}->point(130)->label( "A", "left" );
        $p{B} = $c{1}->point(260)->label( "B", "bottom" );
        $p{C} = $c{1}->point(-70)->label( "C", "bottom" );
        $p{D} = $c{1}->point(30)->label( "D", "right" );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{BD} = Line->join( $p{B}, $p{D} );

        my @p = $l{AC}->intersect( $l{BD} );
        $p{E} = Point->new( $pn, @p )->label( "E", "bottom" );
        $t3->math("AE\\{dot}EC = BE\\{dot}ED");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("Proof 1");
        $t3->erase;
        $p{A}->remove;
        $p{B}->remove;
        $p{C}->remove;
        $p{D}->remove;
        $p{E}->remove;
        $l{AC}->remove;
        $l{BD}->remove;

        $p{A} = $c{1}->point( 180 - 30 )->label( "A", "left" );
        $p{B} = $c{1}->point(180)->label( "B", "left" );
        $p{C} = $c{1}->point(-30)->label( "C", "right" );
        $p{D} = $c{1}->point(0)->label( "D", "right" );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{BD} = Line->join( $p{B}, $p{D} );

        my @p = $l{AC}->intersect( $l{BD} );
        $p{E} = Point->new( $pn, @p )->label( "E", "bottom" );
    };

    push @$steps, sub {
        $t4->explain(  "If E is the centre of the circle, then AE,BE,DE,CE are "
                     . "all equal (radii of the same circle), so it is obvious "
                     . "that AE,CE equals BE, ED" );
        $t3->math("AE = BE = ED = EC");
        $t3->math("AE\\{dot}EC = BE\\{dot}ED");
    };

    push @$steps, sub {
        $t4->erase;
        $t4->down;
        $t4->title("Proof 2");
        $t4->explain("F is the centre of the circle, not E");
        $t3->erase;
        $p{A}->remove;
        $p{B}->remove;
        $p{C}->remove;
        $p{D}->remove;
        $p{E}->remove;
        $l{AC}->remove;
        $l{BD}->remove;

        $p{A} = $c{1}->point(130)->label( "A", "left" );
        $p{B} = $c{1}->point(260)->label( "B", "bottom" );
        $p{C} = $c{1}->point(-70)->label( "C", "bottom" );
        $p{D} = $c{1}->point(30)->label( "D", "right" );
        $l{AC} = Line->join( $p{A}, $p{C} );
        $l{BD} = Line->join( $p{B}, $p{D} );

        my @p = $l{AC}->intersect( $l{BD} );
        $p{E} = Point->new( $pn, @p )->label( "E", "bottom" );
        $p{F} = Point->new( $pn, @c1 )->label( "F", "top" );
    };

    push @$steps, sub {
        $t4->explain("From F, draw FG perpendicular to AC");
        $l{FG} = $l{AC}->perpendicular( $p{F} );
        $p{G} = Point->new( $pn, $l{FG}->end )->label( "G ", "bottom" );
    };

    push @$steps, sub {
        $t4->explain( "Since FG passes through the centre of the "
            . "circle, and is at right angles to AC, it also bisects AC (III.3)"
        );
        $t3->math("AG = GC");
        $p{E}->grey;
        $l{BD}->grey;
    };

    push @$steps, sub {
        $t4->explain(   "When a line (AC) is broken into equal parts "
                      . "(AG,GC) and unequal parts (AE,EC), then the product "
                      . "AE,EC plus the square of GE is equal to the "
                      . "square of GC\\{nb}(II.5)" );
        $t3->math("AE\\{dot}EC + GE\\{squared} = GC\\{squared}");
        $p{E}->normal;
        $l{FG}->grey;
        $c{1}->grey;
        $p{F}->grey;
        $p{B}->grey;
        $p{D}->grey;
    };

    # ------------------------
    # aside...
    # ------------------------
    {

        my ( $a, $c, $g, $e ) = ( 500, 900, 700, 840 );
        my $y = 440;
        push @$steps, sub {

            # draw the line AE, with appropriate points and labels
            $p{tA} = Point->new( $pn, $a, $y )->label( "A", "top" );
            $p{tC} = Point->new( $pn, $c, $y )->label( "C", "top" );
            $p{tG} = Point->new( $pn, $g, $y )->label( "G", "top" );
            $p{tE} = Point->new( $pn, $e, $y )->label( "E", "top" );
            $l{tAG} = Line->join( $p{tA}, $p{tG} )->label( "x", "top" );
            $l{tGE} = Line->join( $p{tG}, $p{tE} );
            $l{tEC} = Line->join( $p{tE}, $p{tC} )->label( "y", "top" );
        };

        push @$steps, sub {

            $s{2} = Polygon->new(
                                  $pn, 6,
                                  $g,  $y,
                                  $c,  $y,
                                  $c,  $y + ( $g - $a ),
                                  $e,  $y + ( $g - $a ),
                                  $e,  $y + ( $c - $e ),
                                  $g,  $y + ( $c - $e )
            )->fill($sky_blue);
            $s{1} = Polygon->new(
                                  $pn, 4,
                                  $a,  $y,
                                  $e,  $y,
                                  $e,  $y + ( $c - $e ),
                                  $a,  $y + ( $c - $e )
            )->fillover( $s{2}, $lime_green );

            $s{1}->move( 0, ( $g - $a ), 1 );
            $l{t5} = Line->new( $pn, $a, $y + ( $g - $a ),
                                $a, $y + ( $g - $a ) + ( $c - $e ) )
              ->label( "y", "left" );
            $l{t1} =
              Line->new( $pn, $a, $y, $a, $y + ( $g - $a ), 1, 1 )
              ->label( "x", "left" );
            $l{t2} =
              Line->new( $pn, $g, $y, $g, $y + ( $g - $a ) + ( $c - $e ), 1,
                         1 );
            $l{t3} = Line->new( $pn, $e, $y, $e, $y + ( $c - $e ), 1, 1 );
            $l{t4} =
              Line->new( $pn, $g, $y, $g, $y + ( $c - $e ) )
              ->label( "y", "left" );

            $txt{txt1} = $pn->text_box( $g + 20, $y + .5 * ( $g - $a ) );
            $txt{txt1}->math("GE\\{squared}");
            $txt{txt2} = $pn->text_box( $c + 20, $y + 40 );
            $txt{txt2}->math("<= AE\\{dot}EC");
            $txt{txt3} =
              $pn->text_box( $g + 20, $y + ( $g - $a ) + .5 * ( $c - $e ) );
            $txt{txt3}->math("GE\\{dot}EC");
            $txt{txt5} = $pn->text_box( $g + 20, $y + 20 );
            $txt{txt5}->math("GE\\{dot}EC");
            $txt{txt4} =
              $pn->text_box( $c + 20, $y + ( $g - $a ) + .5 * ( $c - $e ) );
            $txt{txt4}->math("<= AE\\{dot}EC");

        };

        push @$steps, sub {
            $s{2}->remove;
            $s{1}->remove;
            $l{t1}->remove;
            $l{t2}->remove;
            $l{t3}->remove;
            $l{t4}->remove;
            $l{t5}->remove;
            $txt{txt1}->erase;
            $txt{txt2}->erase;
            $txt{txt3}->erase;
            $txt{txt4}->erase;
            $txt{txt5}->erase;
            $p{tA}->remove;  # = Point->new( $pn, $a, $y )->label( "A", "top" );
            $p{tC}->remove;  # = Point->new( $pn, $c, $y )->label( "C", "top" );
            $p{tG}->remove;  # = Point->new( $pn, $g, $y )->label( "G", "top" );
            $p{tE}->remove;  # = Point->new( $pn, $e, $y )->label( "E", "top" );
            $l{tAG}
              ->remove; # = Line->join( $p{tA}, $p{tG} )->label( "x",   "top" );
            $l{tGE}->remove;    # = Line->join( $p{tG}, $p{tE} );
            $l{tEC}
              ->remove; # = Line->join( $p{tE}, $p{tC} )->label( "y",   "top" );
        };
    }

    # ------------------------
    # back to the proof
    # ------------------------

    push @$steps, sub {
        $t4->explain(
             "Add the square of FG (the radius) to both sides of the equality");
        $t3->down;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math(   "AE\\{dot}EC + GE\\{squared}+FG\\{squared} "
                   . "= GC\\{squared}+FG\\{squared}" );
        $l{FG}->normal;
        $p{F}->normal;
    };

    push @$steps, sub {
        $t4->explain(   "By pythagoras' theorem (I.47), the sum of the "
                      . "squares GE, GF is equal to the square of FE" );
        $s{FGE} = Triangle->join( $p{F}, $p{G}, $p{E} )->fill($pale_pink);
        $t3->allgrey;
        $t3->math("GE\\{squared}+FG\\{squared} = FE\\{squared}");
    };

    push @$steps, sub {
        $t4->explain(   "Similarly, the sum of the squares GC, GF is equal "
                      . "to the square of FC" );
        $s{FGE}->grey;
        $s{FGC} = Triangle->join( $p{F}, $p{G}, $p{C} )->fill($pale_yellow);
        $t3->allgrey;
        $t3->math("GC\\{squared}+FG\\{squared} = FC\\{squared} = r\\{squared}");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ -1, -2, -3 ] );
        $t3->math("AE\\{dot}EC + FE\\{squared} = r\\{squared}");
    };

    # --------------- Repeat -------------------------------------------------
    push @$steps, sub {
        $t4->explain("Follow the same steps for line BD");
        $l{BD}->normal;
        $p{B}->normal;
        $p{D}->normal;
        $s{FGC}->grey;
        $l{AC}->grey;
        $l{FG}->grey;
        $p{A}->grey;
        $p{G}->grey;
        $p{C}->grey;
    };

    push @$steps, sub {
        $t3->allgrey;
        $l{FH} = $l{BD}->perpendicular( $p{F} );
        $p{H} = Point->new( $pn, $l{FH}->end )->label( "H", "right" );
    };

    push @$steps, sub {
        $t3->down;
        $t3->down;
        $t3->math("BH = DH");
        $p{E}->grey;
    };

    push @$steps, sub {
        $p{E}->normal;
        $l{FH}->grey;
        $p{F}->grey;
        $t3->math("DE\\{dot}EB + HE\\{squared} = HB\\{squared}");
    };

    push @$steps, sub {
        $t3->down;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math(   "DE\\{dot}EB + HE\\{squared}+HF\\{squared}"
                   . " = HB\\{squared}+HF\\{squared}" );
        $l{FH}->normal;
        $p{F}->normal;
    };

    push @$steps, sub {
        $t3->allgrey;
        $s{FHE} = Triangle->join( $p{F}, $p{H}, $p{E} )->fill($pale_pink);
        $t3->math("HE\\{squared}+HF\\{squared} = FE\\{squared}");
    };

    push @$steps, sub {
        $s{FHE}->grey;
        $s{FHB} = Triangle->join( $p{F}, $p{H}, $p{B} )->fill($pale_yellow);
        $t3->allgrey;
        $t3->math("HB\\{squared}+HF\\{squared} = FB\\{squared} = r\\{squared}");
    };

    push @$steps, sub {
        $t3->allgrey;
        $t3->black( [ -1, -2, -3 ] );
        $t3->math("DE\\{dot}EB + FE\\{squared} = r\\{squared}");
    };

    push @$steps, sub {
        $t4->explain( "Since FB and FC are both equal to the circle's radius, "
                      . "it can be easily seen that the rectangle formed by "
                      . "AE,EC is equal to the rectangle formed by DE,EB" );
        $t3->allgrey;
        $t3->black( [ -1, 5 ] );
        $t3->down;
        $t3->math("AE\\{dot}EC = DE\\{dot}EB");
    };

    # --------- Finale -------------------------------------------------------
    push @$steps, sub {
        $s{FHB}->grey;
        $l{FH}->grey;
        $p{H}->grey;
        $l{AC}->normal;
        $c{1}->normal;
        $p{A}->normal;
        $p{C}->normal;
        $t3->allgrey;
        $t3->black(-1);
    };

    # -------------------------------------------------------------------------
    # Compare to (II.14)
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t4->down;
        $t4->title("Compare to II-14 - squaring a rectangle");
        $t3->erase;
        foreach my $type ( \%l, \%c, \%p, \%a, \%s ) {
            foreach my $key ( keys %$type ) {
                $type->{$key}->remove;
            }
        }
        $p{B} = Point->new( $pn, 100, 500 )->label( "B", "left" );
        $p{C} = Point->new( $pn, 100, 600 )->label( "C", "left" );
        $p{D} = Point->new( $pn, 400, 600 )->label( "D", "right" );
        $p{E} = Point->new( $pn, 400, 500 )->label( "E", "bottomright" );
        $s{R} = Polygon->join( 4, $p{B}, $p{C}, $p{D}, $p{E} );
        $s{R}->fill($sky_blue);
    };

    push @$steps, sub {
        $t1->y( $t4->y );
        $t1->explain("Extend BE to F, where EF equals ED");
        $l{BF} = $s{R}->l(4)->clone();
        $l{BF}->prepend(200);
        $c{E} = Circle->new( $pn, $p{E}->coords, $p{D}->coords )->grey;
        my @cuts = $c{E}->intersect( $l{BF} );
        $p{F} = Point->new( $pn, @cuts[ 0, 1 ] )->label(qw(F bottom));
        $l{BF}->remove;
        $l{BF} = Line->join( $p{B}, $p{F} );
        $t3->math("EF = ED");
        $t3->allblue;
    };

    push @$steps, sub {
        $t1->explain("Bisect BF (and label it point G)");
        $c{E}->remove();
        $p{G} = $l{BF}->bisect()->label(qw(G topleft));
    };

    push @$steps, sub {
        $t1->explain("Draw a circle with G as the center and GF as the radius");
        $c{G} = Circle->new( $pn, $p{G}->coords, $p{F}->coords )->grey;
    };

    push @$steps, sub {
        $t1->explain("Extend DE to intersect with the circle at point H");
        $l{H1} = $s{R}->l(3)->clone->extend(200);
        $p{H} =
          Point->new( $pn, $c{G}->intersect( $l{H1} ) )->label(qw(H topright));

        $l{H} = Line->join( $p{E}, $p{H} );
        $l{H1}->remove;
    };

    push @$steps, sub {
        $t1->explain(   "According to II.14, the square on HE is "
                      . "equal in area of the rectangle" );
        $t3->math("BE\\{dot}ED = EH\\{squared}");
        $t3->allblue;
        $s{EH} = Square->new( $pn, $l{H}->end, $l{H}->start );
        $s{EH}->fill($lime_green);
    };

    push @$steps, sub {
        $t3->erase;
        $t3->math("EF = BD");
        $t3->allblue;
        $t1->down;
        $t1->explain( "Since BF is perpendicular to HE (BCDE is a rectangle), "
                      . "and BF passes through the centre of the "
                      . "circle, HE is equal to EI (III.3)" );
        $s{EH}->grey;
        $s{R}->grey;
        $l{H}->extend(300)->prepend(300)->grey;
        my @p = $c{G}->intersect( $l{H} );
        $p{I} = Point->new( $pn, @p[ 0, 1 ] )->label( "I", "bottom" );
        $l{I} = Line->join( $p{H}, $p{I} );
        $l{H}->remove;
        $t3->down;
        $t3->math("HE = EI");
    };

    push @$steps, sub {
        $t1->explain(
                 "And, according to this proposition, BE,EF is equal to HE,EI");
        $t3->math("BE\\{dot}EF = HE\\{dot}EI");
    };

    push @$steps, sub {
        $t1->explain(   "With the appropriate substitutions, "
                      . "we get the same result as II.14" );
        $t3->down;
        $t3->math("BE\\{dot}EF = HE\\{squared}");
        $t3->math("BE\\{dot}ED = HE\\{squared}");
    };

    return $steps;

}

