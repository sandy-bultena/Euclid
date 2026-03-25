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
    "If a straight line be cut into equal and unequal segments, "
  . "the rectangle contained by the unequal "
  . "segments of the whole together with the square on the straight line between the "
  . "points of section is equal to the square on the half";

$pn->title( 5, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 200, 500 );
my $t3 = $pn->text_box( 200, 500 );

my $steps;

push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 5 );
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

    my @A = ( 125, 200 );
    my @B = ( 600, 200 );
    my @D = ( 450, 200 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->title("In other words");
        $t4->explain(   "Let AB be a straight line, bisected at point C, "
                      . "and cut at an arbitrary point D" );
        $p{A} = Point->new( $pn, @A )->label(qw(A left));
        $p{B} = Point->new( $pn, @B )->label(qw(B right));
        $l{A} = Line->new( $pn, @B, @A );
        $p{C} = $l{A}->bisect->label(qw(C top));
        $p{D} = Point->new( $pn, @D )->label(qw(D top));

        $t2->math("AC = CB, AD = AC+CD, DB = BC-CD");
        $t2->allblue;
        $t3->y( $t2->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain( "The rectangle formed by the uneven segments "
                . "(AD and\\{nb}DB) added to the "
                . "square of the tiny segment CD, is equal to the half segment "
                . "(CB) all squared." );
        $t2->math("AD\\{dot}DB + CD\\{dot}CD = CB\\{dot}CB");
        $t2->math("AD\\{dot}DB = CB\\{dot}CB - CD\\{dot}CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        my @C = $p{C}->coords;
        $l{x}  = Line->new( $pn, @A, @C, -1 )->label(qw(x top));
        $l{y}  = Line->new( $pn, @C, @D, -1 )->label(qw(y top));
        $l{xy} = Line->new( $pn, @D, @B, -1 )->label( "x-y", "top" );

        $t2->math("(x+y)\\{dot}(x-y) = x\\{squared}-y\\{squared}");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t2->math("AC = CB, AD = AC+CD, DB = AC-CD");
        $t2->allblue;

        $t1->y( $t4->y );
        $t1->down;
        $t1->title("Construction:");
        $t1->explain(   "Draw a square CEFB on the line CB\\{nb}(I.46) and "
                      . "draw the diagonal BE" );
        $s{CF} = Square->new( $pn, $p{B}->coords, $p{C}->coords );
        $s{CF}->p(4)->label(qw(E bottom));
        $s{CF}->p(1)->label(qw(F bottom));
        $p{F}  = $s{CF}->p(1);
        $p{E}  = $s{CF}->p(4);
        $l{BE} = Line->join( $p{B}, $p{E} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "From point D, draw a line parallel to either CE or BF\\{nb}(I.31)"
        );
        $l{Dt} = $s{CF}->l(3)->parallel( $p{D} );
        $p{G} =
          Point->new( $pn, $l{Dt}->intersect( $s{CF}->l(4) ) )
          ->label(qw(G bottom));
        $l{D} = Line->join( $p{D}, $p{G} );
        $p{H} =
          Point->new( $pn, $l{Dt}->intersect( $l{BE} ) )->label(qw(H topleft));
        $l{Dt}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "From point H, draw a line parallel to either "
                      . "AB or EF\\{nb}(I.31)" );
        $l{Ht} = $l{A}->parallel( $p{H} );
        $p{M} =
          Point->new( $pn, $l{Ht}->intersect( $s{CF}->l(1) ) )
          ->label(qw(M right));
        $p{L} =
          Point->new( $pn, $l{Ht}->intersect( $s{CF}->l(3) ) )
          ->label(qw(L bottomleft));
        $l{Ht}->extend(150);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "From point A, draw a line parallel to either "
                      . "CL or BM\\{nb}(I.31)" );
        $l{Kt} = $s{CF}->l(3)->parallel( $p{A} );
        $p{K} =
          Point->new( $pn, $l{Kt}->intersect( $l{Ht} ) )->label(qw(K bottom));
        $l{Ht}->remove;
        $l{KL} = Line->join( $p{K}, $p{H} );
        $l{LM} = Line->join( $p{H}, $p{M} );
        $l{Kt}->remove;
        $l{K}   = Line->join( $p{A}, $p{K} );
        $l{y2}  = Line->join( $p{M}, $p{F}, -1 )->label( "y", "right" );
        $l{xy2} = Line->join( $p{B}, $p{M}, -1 )->label( "x-y", "right" );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->y( $t4->y );
        $t1->down;
        $t1->title("Proof:");
        $t1->explain(   "The complements CH and HF are equal\\{nb}(I.43), "
                      . "and if we add the rectangle DM, "
                      . "then the rectangles CM and DF are equal" );
        $s{CH} =
          Polygon->new( $pn, 4, $p{C}->coords, $p{L}->coords, $p{H}->coords,
                        $p{D}->coords, -1 )->grey->fill($sky_blue);
        $s{HF} =
          Polygon->new( $pn, 4, $p{H}->coords, $p{G}->coords, $p{F}->coords,
                        $p{M}->coords, -1 )->grey->fill($sky_blue);
        $s{DM} =
          Polygon->new( $pn, 4, $p{D}->coords, $p{H}->coords, $p{M}->coords,
                        $p{B}->coords, -1 )->grey->fill($blue);
        $l{BE}->grey;

        $t3->allgrey;
        $t3->math(   "\\{square}CH = \\{square}HF   "
                   . "\\{therefore}  \\{square}CM = \\{square}DF" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The rectangles CM and AL are equal\\{nb}(I.36)");
        $s{AL} =
          Polygon->new( $pn, 4, $p{A}->coords, $p{K}->coords, $p{L}->coords,
                        $p{C}->coords, -1 )->grey->fill($lime_green);
        $s{CH}->fill($sky_blue);
        $s{DM}->fill($sky_blue);
        $s{HF}->fill();
        $l{D}->grey;

        $t3->allgrey;
        my $y = $t3->y();
        $t3->math("\\{square}AL = \\{square}CM ");
        $t3->y($y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("which means that AL and DF are also equal");

        $t3->math("          = \\{square}DF");
        $l{D}->normal;
        $l{LM}->grey;
        $s{DM}->fill($sky_blue);
        $s{HF}->fill($sky_blue);
        $s{CH}->fill();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Let CH be added to each of AL and DF. "
                      . "Now AH is equal to gnomon NOP" );
        $l{vHG} = VirtualLine->new( $p{H}->coords, $p{G}->coords );
        $l{vHL} = VirtualLine->new( $p{H}->coords, $p{L}->coords );
        $a{NOP} =
          Gnomon->new( $pn, $l{vHG}, $l{vHL}, -size => 60 )->label("NOP");

        $s{CH}->fill($teal);
        $t3->math("\\{square}AH = \\{gnomon}NOP");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                   "For a proof showing that DM and LG are squares, see II.4 ");
        $t3->allgrey;
        $t3->math("DH = DB, \\{square}LG = CD\\{dot}CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "AH is equal to the rectangle formed by AD,DH, "
                      . "and also by AD,DB, therefore AD\\{dot}DB "
                      . "is equal to the gnomon NOP" );

        $t3->allgrey;
        $t3->black( [ -1, -2 ] );
        $t3->math("\\{square}AH = AD\\{dot}DB = \\{gnomon}NOP");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "LG is equal to the square on CD, add it "
                      . "to both AH and NOP, retaining the equality" );
        $s{LG} =
          Polygon->new( $pn, 4, $p{L}->coords, $p{E}->coords, $p{G}->coords,
                        $p{H}->coords, -1 )->grey->fill($pale_pink);
        $s{LG}->fill($pale_pink);
        $t3->allgrey;
        $t3->black(-2);
        $t3->math("AD\\{dot}DB + CD\\{dot}CD = \\{gnomon}NOP + \\{square}LG");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                     "But CF is equal to the square on CB, which is also equal "
                       . "to the gnomon NOP added to the rectangle LG, "
                       . "we have demonstrated the proof for this postulate" );
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("AD\\{dot}DB + CD\\{dot}CD = CB\\{dot}CB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
    };

    # -------------------------------------------------------------------------
    # pictoral
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t3->erase;
        $s{CH}->fill($sky_blue);
        $s{AL}->fill;
        $a{NOP}->grey;
        foreach my $p ( keys %p ) {
            next if $p =~ /[ABCD]/;
            $p{$p}->label;
        }
        $l{ak} = $l{K}->clone->extend(400)->dash;
        $l{ce} = Line->join( $p{C}, $p{E} )->extend(400)->dash;
        $l{dg} = Line->join( $p{D}, $p{G} )->extend(400)->dash;

        #        $l{bf} = Line->join($p{B},$p{F})->extend(400)->dash;
        $p{a} = Point->new( $pn, $A[0], ( $B[0] - $A[0] ) + 30 );
        $p{d} = Point->new( $pn, $D[0], ( $B[0] - $A[0] ) + 30 );
        $p{k} =
          Point->new( $pn, $A[0], ( $B[0] - $A[0] ) + ( $B[0] - $D[0] ) + 30 );
        $p{h} =
          Point->new( $pn, $D[0], ( $B[0] - $A[0] ) + ( $B[0] - $D[0] ) + 30 );
        $s{ah} = Polygon->join( 4, $p{a}, $p{d}, $p{h}, $p{k} )->fill($lime_green);
        $s{ah}->l(2)->label("x-y");

        my $t;
        $t = $pn->text_box(
                            ( $p{a}->x + $p{C}->x ) / 2,
                            ( $p{a}->y + $p{k}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("AC\\{dot}BD = BC\\{dot}BD");

        $t = $pn->text_box(
                            ( $p{D}->x + $p{C}->x ) / 2,
                            ( $p{a}->y + $p{k}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("CD\\{dot}BD");

        $t = $pn->text_box(
                            ( $p{D}->x + $p{C}->x ) / 2,
                            ( $p{A}->y + $p{K}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("CD\\{dot}BD");

        $t = $pn->text_box(
                            ( $p{D}->x + $p{C}->x ) / 2,
                            ( $p{H}->y + $p{G}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("CD\\{dot}CD");

        $t = $pn->text_box(
                            ( $p{D}->x + $p{B}->x ) / 2,
                            ( $p{A}->y + $p{K}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("BC\\{dot}BD");

        $t = $pn->text_box( ( $p{D}->x + $p{B}->x ) / 2,
                            $p{a}->y, -anchor => "nw" );
        $t->footnote("BC\\{dot}BD+CD\\{dot}BD = AD\\{dot}BD");
        $t->down;
        $t->footnote("AD\\{dot}BD+CD\\{dot}CD = BC\\{dot}BC");

    };

    return $steps;

}

