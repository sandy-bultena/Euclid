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
"If a straight line be bisected and a straight line be added to it in a straight line, "
  . "the rectangle contained by the whole with the added straight line and the added "
  . "straight line together with the square on the half is equal to the square on the "
  . "straight line made up of the half and the added straight line.";

$pn->title( 6, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 200, 490 );
my $t3 = $pn->text_box( 200, 490 );

my $steps;

push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 6 );
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

    my @A = ( 200, 200 );
    my @B = ( 500, 200 );
    my $D = 75;
    my @D = ( $B[0] + $D, $B[1] );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->down;
        $t4->title("In other words");
        $t4->explain(   "Let AB be a straight line, bisected at point C, "
                      . "and extend the line AB to an arbitrary point D" );
        $p{A} = Point->new( $pn, @A )->label(qw(A topleft));
        $p{B} = Point->new( $pn, @B )->label(qw(B top));
        $l{A} = Line->new( $pn, @A, @B );
        $p{C} = $l{A}->bisect->label(qw(C top));
        $l{A}->extend($D);
        $p{D} = Point->new( $pn, $l{A}->end )->label(qw(D topright));
        $t2->math("AD=AB+BD, CB=\\{half}AB, CD=CB+BD");
        $t2->allblue;
        $t3->y( $t2->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "The rectangle formed by the extended "
                      . "line AD, and the extension BD plus the square on CB "
                      . "is equal to the square on CD" );
        $t2->math("AD\\{dot}DB + CB\\{dot}CB = CD\\{dot}CD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->math("(2x+y)y + x\\{squared} = (x+y)\\{squared}");

        my @C = $p{C}->coords;
        my @D = $p{D}->coords;
        $l{x1} = Line->new( $pn, @A, @C, -1 )->label( "x", "top" );
        $l{x2} = Line->new( $pn, @C, @B, -1 )->label( "x", "top" );
        $l{y1} = Line->new( $pn, @B, @D, -1 )->label( "y", "top" );
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t2->math("AD=AB+BD, CB=\\{half}AB, CD=CB+BD");
        $t2->allblue;

        $t1->y( $t4->y );
        $t1->down;
        $t1->title("Construction:");
        $t1->explain(   "Draw a square CEFB on the line CD\\{nb}(I.46) "
                      . "and draw the diagonal DE" );
        $s{CF} = Square->new( $pn, $p{D}->coords, $p{C}->coords );
        $s{CF}->p(4)->label(qw(E bottom));
        $s{CF}->p(1)->label(qw(F bottom));
        $p{F}  = $s{CF}->p(1);
        $p{E}  = $s{CF}->p(4);
        $l{DE} = Line->join( $p{D}, $p{E} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "From point B, draw a line parallel to either CE or DF\\{nb}(I.31)"
        );
        $l{Bt} = $s{CF}->l(3)->parallel( $p{B} );
        $p{G} =
          Point->new( $pn, $l{Bt}->intersect( $s{CF}->l(4) ) )
          ->label(qw(G bottom));
        $l{B} = Line->join( $p{B}, $p{G} );
        $p{H} =
          Point->new( $pn, $l{Bt}->intersect( $l{DE} ) )->label(qw(H topleft));
        $l{Bt}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "From point H, draw a line parallel to either AB or EF\\{nb}(I.31)"
        );
        $l{Ht} = $l{A}->parallel( $p{H} );
        $p{M} =
          Point->new( $pn, $l{Ht}->intersect( $s{CF}->l(1) ) )
          ->label(qw(M right));
        $p{L} =
          Point->new( $pn, $l{Ht}->intersect( $s{CF}->l(3) ) )
          ->label(qw(L bottomleft));
        $l{Ht}->extend(200);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "From point A, draw a line parallel to either CL or BH\\{nb}(I.31)"
        );
        $l{Kt} = $s{CF}->l(3)->parallel( $p{A} );
        $p{K} =
          Point->new( $pn, $l{Kt}->intersect( $l{Ht} ) )->label(qw(K bottom));
        $l{Ht}->remove;
        $l{KL} = Line->join( $p{K}, $p{H} );
        $l{LM} = Line->join( $p{H}, $p{M} );
        $l{Kt}->remove;
        $l{K} = Line->join( $p{A}, $p{K} );

        my @D = $p{D}->coords;
        my @M = $p{M}->coords;
        my @F = $p{F}->coords;
        $l{x1} = Line->new( $pn, @D, @M, -1 )->label( "y", "right" );
        $l{x2} = Line->new( $pn, @M, @F, -1 )->label( "x", "right" );
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->y( $t4->y );
        $t1->down;
        $t1->title("Proof:");
        $t1->explain(   "Since AC equals CB, then AL equals CH\\{nb}(I.36), "
                      . "and CH equals HF\\{nb}(I.43), "
                      . "then AL = HF" );
        $s{CH} =
          Polygon->new( $pn, 4, $p{C}->coords, $p{L}->coords, $p{H}->coords,
                        $p{B}->coords, -1 )->grey->fill($sky_blue);
        $s{HF} =
          Polygon->new( $pn, 4, $p{H}->coords, $p{G}->coords, $p{F}->coords,
                        $p{M}->coords, -1 )->grey->fill($sky_blue);
        $s{AL} =
          Polygon->new( $pn, 4, $p{A}->coords, $p{K}->coords, $p{L}->coords,
                        $p{C}->coords, -1 )->grey->fill($lime_green);
        $l{DE}->grey;

        $t3->math( "AC=CB \\{therefore} \\{square}AL=\\{square}CH=\\{square}HF "
                   . "\\{therefore} \\{square}AL=\\{square}HF" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $s{CH}->fill();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Add CM to both");
        $s{BM} =
          Polygon->new( $pn, 4, $p{B}->coords, $p{H}->coords, $p{M}->coords,
                        $p{D}->coords, -1 )->grey->fill($teal);
        $s{CH}->fill($teal);

        $l{vHG} = VirtualLine->new( $p{H}->coords, $p{G}->coords );
        $l{vHL} = VirtualLine->new( $p{H}->coords, $p{L}->coords );
        $a{NOP} =
          Gnomon->new( $pn, $l{vHG}, $l{vHL}, -size => 50 )->label("NOP");

        $t3->math(   "\\{square}AL + \\{square}CM = \\{square}AM = "
                   . "\\{square}HF + \\{square}CM" );
        $t3->math("\\{square}AM = \\{gnomon}NOP");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
               "Since DB equals DM, AM is the rectangle formed from AD and DB");
        $t3->allgrey;
        $t3->math("\\{square}AM = AD\\{dot}DB");
        $s{BM}->fill($lime_green);
        $s{CH}->fill($lime_green);
        $s{HF}->fill();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("LG is the square of CB");
        $t3->allgrey;
        $t3->math("\\{square}LG = CB\\{dot}CB");
        $s{BM}->fill();
        $s{CH}->fill();
        $s{AL}->fill();
        $s{LG} =
          Polygon->new( $pn, 4, $p{L}->coords, $p{E}->coords, $p{G}->coords,
                        $p{H}->coords, -1 )->grey;
        $s{LG}->fill($green);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Add LG to AM and the gnomon NOP");
        $s{BM}->fill($lime_green);
        $s{CH}->fill($lime_green);
        $s{AL}->fill($lime_green);
        $s{LG}->fill($green);
        $t3->allgrey;
        $t3->black( [ -1, -2, -3 ] );
        $t3->math("AD\\{dot}DB + CB\\{dot}CB = \\{gnomon}NOP + CB\\{dot}CB");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "But LG added to the gnomon NOP is also "
              . "equal to the square on CD, therefore "
              . "AM plus LG is equal to CF"
        );
        $s{LG}->fill($blue);
        $s{CH}->fill($sky_blue);
        $s{BM}->fill($sky_blue);
        $s{HF}->fill($sky_blue);
        $t3->allgrey;
        $t3->black( [-1] );
        $t3->math("AD\\{dot}DB + CB\\{dot}CB = CD\\{dot}CD");
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
        $l{ak} = $l{K}->clone->extend(300)->dash;
        $l{ce} = Line->join( $p{C}, $p{L} )->extend(300)->dash;
        $l{dm} = Line->join( $p{D}, $p{M} )->extend(300)->dash;
        $l{bh} = Line->join( $p{B}, $p{H} )->extend(300)->dash;

        #        $l{bf} = Line->join($p{B},$p{F})->extend(400)->dash;
        $p{a} = Point->new( $pn, $A[0], $p{A}->y + ( $D[0] - $p{C}->x ) + 40 );
        $p{k} = Point->new( $pn, $p{K}->x, $p{a}->y + ( $D[0] - $B[0] ) );
        $p{c} = Point->new( $pn, $p{C}->x, $p{a}->y );
        $p{l} = Point->new( $pn, $p{c}->x, $p{k}->y );
        $p{b} = Point->new( $pn, $p{B}->x, $p{a}->y );
        $p{h} = Point->new( $pn, $p{b}->x, $p{k}->y );
        $p{d} = Point->new( $pn, $p{D}->x, $p{a}->y );
        $p{m} = Point->new( $pn, $p{d}->x, $p{k}->y );

        $s{bm} = Polygon->join( 4, $p{b}, $p{h}, $p{m}, $p{d} )->fill($lime_green);
        $s{bm}->l(3)->label("y");

        my $t;
        $t = $pn->text_box(
                            ( $p{b}->x + $p{d}->x ) / 2,
                            ( $p{b}->y + $p{m}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("BD\\{dot}BD");
        $t = $pn->text_box(
                            ( $p{b}->x + $p{d}->x ) / 2,
                            ( $p{B}->y + $p{H}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("BD\\{dot}BD");

        $s{cl} = Polygon->join( 4, $p{c}, $p{l}, $p{h}, $p{b} )->fill($lime_green);
        $t = $pn->text_box(
                            ( $p{c}->x + $p{b}->x ) / 2,
                            ( $p{b}->y + $p{m}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("CB\\{dot}BD");
        $t = $pn->text_box(
                            ( $p{c}->x + $p{b}->x ) / 2,
                            ( $p{B}->y + $p{H}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("CB\\{dot}BD");

        $s{al} = Polygon->join( 4, $p{a}, $p{k}, $p{l}, $p{c} )->fill($lime_green);
        $t = $pn->text_box(
                            ( $p{a}->x + $p{c}->x ) / 2,
                            ( $p{b}->y + $p{m}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("AC\\{dot}BD");
        $t = $pn->text_box(
                            ( $p{b}->x + $p{d}->x ) / 2,
                            ( $p{M}->y + $p{F}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("AC\\{dot}BD");

        $t = $pn->text_box(
                            ( $p{c}->x + $p{b}->x ) / 2,
                            ( $p{M}->y + $p{F}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("CB\\{dot}CB");

        $t = $pn->text_box( $p{A}->x, $p{k}->y + 50, -anchor => "nw" );
        $t->footnote("AC\\{dot}BD + CB\\{dot}BD + BD\\{dot}BD = AD\\{dot}BD");
        $t->down;
        $t->footnote("AD\\{dot}BD + CB\\{dot}CB = CD\\{dot}CD");

    };

    return $steps;

}

