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
"If a straight line be cut at random, the square on the whole and that of one of the "
  . "segments both together are equal to twice the rectangle contained by the whole and the said segment "
  . "and the square on the remaining segment.";

$pn->title( 7, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 200, 490 );
my $t3 = $pn->text_box( 200, 490 );

my $steps;

push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 7 );
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
    my @B = ( 450, 200 );
    my @C = ( 350, 200 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain("Let AB be a straight line, arbitrarily cut at point C");
        $p{A} = Point->new( $pn, @A )->label(qw(A left));
        $p{B} = Point->new( $pn, @B )->label(qw(B right));
        $l{A} = Line->new( $pn, @B, @A );
        $l{a} = Line->new( $pn, @A, @C, -1 );
        $l{b} = Line->new( $pn, @C, @B, -1 );
        $p{C} = Point->new( $pn, @C )->label(qw(C top));
        $t2->math("AB = AC + CB");
        $t2->allblue;
        $t3->y($t2->y);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "Then the squares formed by lines AB and BC are "
                      . "equal in area to the sum of the square "
                      . "formed by line AC, plus twice the area of the "
                      . "rectangle formed by "
                      . "lines AB and\\{nb}CB" );
        $t2->math(
               "AB\\{dot}AB + BC\\{dot}BC = AC\\{dot}AC + 2\\{dot}AB\\{dot}BC");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{a}->label( "x", "top" );
        $l{b}->label( "y", "top" );
        $t2->math("(x+y)\\{squared} + y\\{squared} = x\\{squared} + 2(x+y)y");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t2->math("AB = AC + CB");
        $t2->allblue;
        $t4->y($t1->y);
        $t4->down;
        $t4->title("Construction:");
        $t4->explain(   "Draw a square ADEB on the line AB\\{nb}(I.46), "
                      . "and draw the diagonal  BD" );
        $s{AB} = Square->new( $pn, $p{B}->coords, $p{A}->coords );
        $s{AB}->p(1)->label(qw(E right));
        $s{AB}->p(4)->label(qw(D bottom));
        $p{D}  = $s{AB}->p(4);
        $p{E}  = $s{AB}->p(1);
        $l{BD} = Line->join( $p{B}, $p{D} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "Draw a line CN parallel to AD (I.31), labelling "
                      . "the intersection with the diagonal as G" );
        $t4->explain(
                 "Draw a line parallel to AB through the point G\\{nb}(I.31).");

        $l{Ct} = $s{AB}->l(3)->parallel( $p{C} );
        $l{Ct}->prepend(100);
        $p{N} =
          Point->new( $pn, $l{Ct}->intersect( $s{AB}->l(4) ) )
          ->label(qw(N bottom));
        $l{C} = Line->join( $p{C}, $p{N}, -1 );
        $l{Ct}->remove();
        $p{G} =
          Point->new( $pn, $l{C}->intersect( $l{BD} ) )->label(qw(G topleft));

        $l{Gt} = $l{A}->parallel( $p{G} );
        $l{Gt}->prepend(100);
        $l{Gt}->extend(100);
        $p{H} =
          Point->new( $pn, $l{Gt}->intersect( $s{AB}->l(3) ) )
          ->label(qw(H left));
        $p{F} =
          Point->new( $pn, $l{Gt}->intersect( $s{AB}->l(1) ) )
          ->label(qw(F right));
        $l{G} = Line->join( $p{H}, $p{F}, -1 );
        $l{Gt}->remove();
        $l{BD}->grey;

        $l{a1} = Line->new( $pn, @B, $p{F}->coords, -1 )->label(qw(y right));
        $l{b1} = Line->join( $p{F}, $p{E}, -1 )->label(qw(x right));
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->down;
        $t1->title("Proof:");
        $t1->explain(   "AG equals GE\\{nb}(I.43), add CF to both, "
                      . "thus preserving the equality" );

        $s{AG} =
          Polygon->new( $pn, 4, $p{A}->coords, $p{H}->coords, $p{G}->coords,
                        $p{C}->coords, -1 )->grey->fill($lime_green);
        $s{GE} =
          Polygon->new( $pn, 4, $p{G}->coords, $p{N}->coords, $p{E}->coords,
                        $p{F}->coords, -1 )->grey->fill($sky_blue);
        $s{CF} =
          Polygon->new( $pn, 4, $p{C}->coords, $p{G}->coords, $p{F}->coords,
                        $p{B}->coords, -1 )->grey->fill($teal);

        $t3->math(   "\\{square}AF = \\{square}CE,  \\{square}AF "
                   . "+ \\{square}CE = 2\\{square}AF" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(   "But AF plus CE is equal to the gnomon KLM plus CE, "
                      . "therefore the gnomon KLM and CE is twice AF" );

        $l{vHG} = VirtualLine->new( $p{H}->coords, $p{G}->coords );
        $l{vGN} = VirtualLine->new( $p{G}->coords, $p{N}->coords );
        $a{KLM} =
          Gnomon->new( $pn, $l{vGN}, $l{vHG}, -size => 50 )->label("KLM");
        $s{AG}->fill($sky_blue);
        $s{CF}->fill($blue);

        $t3->math(   "\\{gnomon}KLM + \\{square}CF = \\{square}AF "
                   . "+ \\{square}CE = 2\\{square}AF" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let DG, the square on AC, be added to each");
        $s{DG} =
          Polygon->new( $pn, 4, $p{H}->coords, $p{D}->coords, $p{N}->coords,
                        $p{G}->coords, -1 )->grey->fill($pale_pink);
        $t3->down;
        $t3->math(   "\\{gnomon}KLM + \\{square}DG + \\{square}CF "
                   . "= 2\\{square}AF + \\{square}DG " );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let DG, the square on AC, be added to each");
        $t1->explain("But the gnomon KLM and DG equals the square AE");

        $t3->allgrey;
        $t3->black(-1);
        $t3->math(
             "\\{square}AE       + \\{square}CF = 2\\{square}AF + \\{square}DG"
        );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                "AE equals the square on AB, CF equals the square on CB, "
              . "AF is the rectangle formed by AB and BC, "
              . "and finally DG is the square on AC"
        );
        $s{AG}->fill($lime_green);
        $s{CF}->fill($teal);
        $t3->allgrey;
        $t3->black(-1);
        $t3->math("AB\\{dot}AB + CB\\{dot}CB = 2AB\\{dot}BC + AC\\{dot}AC");

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
        $a{KLM}->remove;
        foreach my $p ( keys %p ) {
            next if $p =~ /[ABC]/;
            $p{$p}->label;
        }
        $l{ad} = $s{AB}->l(3)->clone->extend(300)->dash->grey;
        $l{be} = $s{AB}->l(1)->clone->extend(300)->dash->grey;
        $l{cn} = $l{C}->clone->extend(300)->dash->grey;

        $p{a} = Point->new( $pn, $A[0], $p{A}->y + ( $p{B}->x-$p{A}->x ) + 30 );
        $p{d} = Point->new( $pn, $p{a}->x, $p{a}->y + ( $p{B}->x-$p{A}->x ) );
        $p{h} = Point->new( $pn, $p{a}->x, $p{a}->y + ( $p{B}->x-$p{C}->x ) );

        $p{c} = Point->new( $pn, $C[0], $p{A}->y + ( $p{B}->x-$p{A}->x ) + 30 );
        $p{g} = Point->new( $pn, $p{c}->x, $p{a}->y + ( $p{B}->x-$p{C}->x ) );
        $p{n} = Point->new( $pn, $p{c}->x, $p{a}->y + ( $p{B}->x-$p{A}->x ) );

        $p{b} = Point->new( $pn, $B[0], $p{A}->y + ( $p{B}->x-$p{A}->x ) + 30 );
        $p{f} = Point->new( $pn, $p{b}->x, $p{a}->y + ( $p{B}->x-$p{C}->x ) );
        $p{e} = Point->new( $pn, $p{b}->x, $p{a}->y + ( $p{B}->x-$p{A}->x ) );

        $s{ac} = Polygon->join( 4, $p{h}, $p{d}, $p{n}, $p{g} )->fill($pale_pink)->l(3)->label("x");
        
        $l{ab}=Line->join($p{a},$p{b})->extend(180)->prepend(40)->dash->grey;
        $l{hf}=Line->join($p{h},$p{f})->extend(180)->prepend(40)->dash->grey;
        $l{AB}=Line->join($p{A},$p{B})->extend(180)->prepend(40)->dash->grey;
        $l{HF}=Line->join($p{H},$p{F})->extend(180)->prepend(40)->dash->grey;
        $l{de}=Line->join($p{d},$p{e})->extend(180)->prepend(40)->dash->grey;

        my $t;
        $t = $pn->text_box(
                            ( $p{a}->x + $p{c}->x ) / 2,
                            ( $p{d}->y + $p{h}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("AC\\{dot}AC");
        $t = $pn->text_box(
                            ( $p{a}->x + $p{c}->x ) / 2,
                            ( $p{D}->y + $p{H}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("AC\\{dot}AC");


        $s{af} = Polygon->join( 4, $p{a}, $p{h}, $p{f}, $p{b} )->fill($lime_green)->l(3)->label("y");

        $t = $pn->text_box(
                            ( $p{a}->x + $p{b}->x ) / 2,
                            ( $p{a}->y + $p{h}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("AB\\{dot}BC");

        $p{c2} = Point->new($pn,$p{c}->x+($p{B}->x-$p{C}->x)+50,$p{c}->y);
        $p{n2} = Point->new($pn,$p{n}->x+($p{B}->x-$p{C}->x)+50,$p{n}->y);
        $p{e2} = Point->new($pn,$p{e}->x+($p{B}->x-$p{C}->x)+50,$p{e}->y);
        $p{b2} = Point->new($pn,$p{b}->x+($p{B}->x-$p{C}->x)+50,$p{b}->y);
        $s{ce} = Polygon->join( 4, $p{c2}, $p{n2}, $p{e2}, $p{b2} )->fill($sky_blue);

        $t = $pn->text_box(
                            ( $p{c2}->x + $p{b2}->x ) / 2,
                            ( $p{e2}->y + $p{b2}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("AB\\{dot}BC");


        $p{C2} = Point->new($pn,$p{C}->x+($p{B}->x-$p{C}->x)+50,$p{C}->y);
        $p{G2} = Point->new($pn,$p{G}->x+($p{B}->x-$p{C}->x)+50,$p{G}->y);
        $p{F2} = Point->new($pn,$p{F}->x+($p{B}->x-$p{C}->x)+50,$p{F}->y);
        $p{B2} = Point->new($pn,$p{B}->x+($p{B}->x-$p{C}->x)+50,$p{B}->y);
        $s{CF} = Polygon->join( 4, $p{B2}, $p{F2}, $p{G2}, $p{C2} )->fill($teal);
        Line->join($p{C2},$p{B2})->label("y","top");
        Line->join($p{B2},$p{e2})->extend(40)->prepend(40)->grey->dash->grey;
        Line->join($p{C2},$p{n2})->extend(40)->prepend(40)->grey->dash->grey;

        $t = $pn->text_box(
                            ( $p{C2}->x + $p{B2}->x ) / 2,
                            ( $p{F2}->y + $p{B2}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("BC\\{dot}BC");

        $t = $pn->text_box(
                            ( $p{A}->x + $p{C}->x ) / 2,
                            ( $p{H}->y + $p{C}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("AC\\{dot}BC");

        $t = $pn->text_box(
                            ( $p{B}->x + $p{C}->x ) / 2,
                            ( $p{G}->y + $p{N}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("AC\\{dot}BC");

        $t = $pn->text_box(
                            ( $p{B}->x + $p{C}->x ) / 2,
                            ( $p{G}->y + $p{C}->y ) / 2,
                            -anchor => "c"
        );
        $t->footnote("BC\\{dot}BC");


=remove
        $s{bm}->l(3)->label("y");

#               "AB\\{dot}AB + BC\\{dot}BC = AC\\{dot}AC + 2\\{dot}AB\\{dot}BC");


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
=cut
    };
    
    return $steps;

}

