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
  "If a straight line be cut at random, four times the rectangle contained by "
  . "the whole and one of the segments together with the square on the "
  . "remaining segment is equal to the square described on the whole and "
  . "aforesaid segment as on one straight line.";

$pn->title( 8, $title, 'II' );
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t4 = $pn->text_box( 800, 150, -width => 480 );
my $t5 = $pn->text_box( 820, 150, -width => 480 );
my $t2 = $pn->text_box( 520, 200 );
my $t3 = $pn->text_box( 180, 560 );

my $cag = $sky_blue;
my $crf = $lime_green;
my $cql = $green;
my $cmq = $blue;
my $cck = Colour->add( $cag, $cql );
my $cbn = Colour->add( $crf, $cag );
my $ckp = Colour->add( $cmq, $crf );
my $cgr = Colour->add( $cmq, $cql );
my $coh = $pale_pink;

my $steps;

push @$steps, Proposition::title_page2($pn);
push @$steps, Proposition::toc2( $pn, 8 );
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

    my @A = ( 120, 160 );
    my @B = ( 380, 160 );
    my @C = ( 300, 160 );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Let AB be a straight line, arbitrarily cut at point C");
        $p{A} = Point->new( $pn, @A )->label(qw(A top));
        $p{B} = Point->new( $pn, @B )->label(qw(B top));
        $l{A} = Line->new( $pn, @B, @A );
        $p{C} = Point->new( $pn, @C )->label(qw(C top));
        $t2->math("AB = AC+CB");
        $t2->allblue;

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
             "Then four times the rectangle formed by lines AB and BC plus the "
               . "square of AC is equal to the square of AB added to BC" );
        $t2->math("4AB\\{dot}BC + AC\\{dot}AC ");
        $t2->math(" = (AB+BC)\\{dot}(AB+BC)");
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t2->math("AB = AC+CB");
        $t2->allblue;
        $t4->y( $t1->y );
        $t4->down;
        $t4->title("Construction:");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(
              "Extend the line AB to point D such that CB is equal to\\{nb}BD");
        $l{A}->prepend(100);
        $c{B} = Circle->new( $pn, @B, @C )->grey;
        my @bd = $c{B}->intersect( $l{A} );
        $p{D} = Point->new( $pn, @bd[ 0, 1 ] )->label(qw(D top));
        $t2->erase;
        $t2->math("AB = AC+CB, CB = BD");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "Draw a square AEFD on the line AD\\{nb}(I.46), "
                      . "and draw the diagonal\\{nb}DE" );
        $c{B}->remove;
        $s{AF} = Square->new( $pn, $p{D}->coords, $p{A}->coords );
        $s{AF}->p(1)->label(qw(F right));
        $s{AF}->p(4)->label(qw(E bottom));
        $p{F}  = $s{AF}->p(1);
        $p{E}  = $s{AF}->p(4);
        $l{ED} = Line->join( $p{E}, $p{D} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Draw lines CH,BL parallel to AE (I.31)");
        $t4->explain("Draw lines MN,OP parallel to AD (I.31)");

        $l{BLt} = $s{AF}->l(3)->parallel( $p{B} );
        $l{BLt}->prepend(100);
        $p{L} =
          Point->new( $pn, $l{BLt}->intersect( $s{AF}->l(4) ) )
          ->label(qw(L bottom));
        $l{BL} = Line->join( $p{B}, $p{L} );
        $l{BLt}->remove();
        $p{K} =
          Point->new( $pn, $l{BL}->intersect( $l{ED} ) )
          ->label(qw(K bottomright));

        $l{CHt} = $s{AF}->l(3)->parallel( $p{C} );
        $l{CHt}->prepend(100);
        $p{H} =
          Point->new( $pn, $l{CHt}->intersect( $s{AF}->l(4) ) )
          ->label(qw(H bottom));
        $l{CH} = Line->join( $p{C}, $p{H} );
        $l{CHt}->remove();
        $p{Q} =
          Point->new( $pn, $l{CH}->intersect( $l{ED} ) )
          ->label(qw(Q bottomright));

        $l{MNt} = $s{AF}->l(2)->parallel( $p{K} );
        $l{MNt}->prepend(100);
        $l{MNt}->extend(100);
        $p{M} =
          Point->new( $pn, $l{MNt}->intersect( $s{AF}->l(3) ) )
          ->label(qw(M left));
        $p{N} =
          Point->new( $pn, $l{MNt}->intersect( $s{AF}->l(1) ) )
          ->label(qw(N right));
        $l{MN} = Line->join( $p{M}, $p{N} );
        $l{MNt}->remove();
        $p{G} =
          Point->new( $pn, $l{MN}->intersect( $l{CH} ) )->label(qw(G topright));

        $l{OPt} = $s{AF}->l(2)->parallel( $p{Q} );
        $l{OPt}->prepend(100);
        $l{OPt}->extend(100);
        $p{O} =
          Point->new( $pn, $l{OPt}->intersect( $s{AF}->l(3) ) )
          ->label(qw(O left));
        $p{P} =
          Point->new( $pn, $l{OPt}->intersect( $s{AF}->l(1) ) )
          ->label(qw(P right));
        $l{OP} = Line->join( $p{O}, $p{P} );
        $l{OPt}->remove();
        $p{R} =
          Point->new( $pn, $l{OP}->intersect( $l{BL} ) )
          ->label(qw(R bottomright));

        $l{ED}->grey;

    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->y( $t1->y );
        $t4->erase;
        $t1->down;
        $t1->title("Proof:");
        $t4->y( $t1->y );
        $t4->explain(   "Since CB is equal to BD, and CB is "
                      . "also equal to GK\\{nb}(I.34) "
                      . "and BD is equal to\\{nb}KN, then GK "
                      . "is equal to\\{nb}KN" );
        $t4->explain("Similarly, QR is equal to RP");
        $t2->math("GK = KN");
        $t2->math("QR = RP ");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Thus CK and BN are equal, as are GR and KP\\{nb}(I.36)");
        $t2->math("\\{square}CK = \\{square}BN");
        $t2->math("\\{square}GR = \\{square}KP ");
        $s{CK} =
          Polygon->new( $pn, 4, $p{C}->coords, $p{G}->coords, $p{K}->coords,
                        $p{B}->coords, -1 )->grey->fill($cck);
        $s{BN} =
          Polygon->new( $pn, 4, $p{B}->coords, $p{K}->coords, $p{N}->coords,
                        $p{D}->coords, -1 )->grey->fill($cbn);
        $s{GR} =
          Polygon->new( $pn, 4, $p{G}->coords, $p{Q}->coords, $p{R}->coords,
                        $p{K}->coords, -1 )->grey->fill($cgr);
        $s{KP} =
          Polygon->new( $pn, 4, $p{K}->coords, $p{R}->coords, $p{P}->coords,
                        $p{N}->coords, -1 )->grey->fill($ckp);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("CK and KP are equal\\{nb}(I.43)");
        $t2->allgrey;
        $t2->math("\\{square}CK = \\{square}KP");
        $s{CK}->fill($cck);
        $s{BN}->fill("#f4f4f4");
        $s{GR}->fill("#f4f4f4");
        $s{KP}->fill($ckp);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->explain(
            "Therefore CK, BN, GR, KP are all equal, and the sum equals four CK"
        );
        $t4->y( $t1->y );
        $s{CK}->fill($cck);
        $s{GR}->fill($cgr);
        $s{BN}->fill($cbn);
        $s{KP}->fill($ckp);
        $t2->black( [ -1, -2, -3 ] );
        $t3->math("\\{square}CK = \\{square}BN = \\{square}GR = \\{square}KP");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain(   "Again, since CB is equal to BD, and BD is also "
                      . "equal to BK which is equal to CG, "
                      . "and CB is equal to GK, which is equal "
                      . "to\\{nb}GQ, then CG is equal to GQ" );
        $t3->allgrey;
        $t2->allgrey;
        $t2->math("CG = GQ ");
        $s{CK}->fill();
        $s{BN}->fill();
        $s{GR}->fill();
        $s{KP}->fill();
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Thus AG and MQ are equal, as are QL and RF\\{nb}(I.36)");
        $t2->allgrey;
        $t2->black(-1);
        $t2->math("\\{square}AG = \\{square}MQ");
        $t2->math("\\{square}QL = \\{square}RF ");
        $s{AG} =
          Polygon->new( $pn, 4, $p{A}->coords, $p{M}->coords, $p{G}->coords,
                        $p{C}->coords, -1 )->grey->fill($cag);
        $s{MQ} =
          Polygon->new( $pn, 4, $p{M}->coords, $p{O}->coords, $p{Q}->coords,
                        $p{G}->coords, -1 )->grey->fill($cmq);
        $s{QL} =
          Polygon->new( $pn, 4, $p{Q}->coords, $p{H}->coords, $p{L}->coords,
                        $p{R}->coords, -1 )->grey->fill($cql);
        $s{RF} =
          Polygon->new( $pn, 4, $p{R}->coords, $p{L}->coords, $p{F}->coords,
                        $p{P}->coords, -1 )->grey->fill($crf);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("MQ and QL are equal\\{nb}(I.43)");
        $t2->allgrey;
        $t2->math("\\{square}MQ = \\{square}QL");
        $s{OH} =
          Polygon->new( $pn, 4, $p{O}->coords, $p{E}->coords, $p{H}->coords,
                        $p{Q}->coords, -1 );
        $s{MQ}->fill($cmq);
        $s{AG}->fill();
        $s{RF}->fill();
        $s{QL}->fill($cql);
        $s{GR}->fill("#f4f4f4");
        $s{OH}->fill("#f4f4f4");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t1->explain(   "Therefore MQ,QL,AG,RF are all equal, "
                      . "and the sum of the areas is four AG" );
        $s{GR}->fill();
        $s{OH}->fill();
        $s{AG}->fill($cag);
        $s{MQ}->fill($cmq);
        $s{QL}->fill($cql);
        $s{RF}->fill($crf);
        $t2->black( [ -1, -2, -3 ] );
        $t3->math("\\{square}MQ = \\{square}QL = \\{square}AG = \\{square}RF");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "The gnomon STU is equal to the sum of all eight areas, "
                      . "which is also equal to four times AG plus CK" );
        $a{STU} = Gnomon->new(
                          $pn, VirtualLine->new( $p{Q}->coords, $p{H}->coords ),
                          VirtualLine->new( $p{Q}->coords, $p{O}->coords ),
                          -size   => 60,
                          -center => 40
        )->label("STU");
        $s{CK}->fill($cck);
        $s{GR}->fill($cgr);
        $s{BN}->fill($cbn);
        $s{KP}->fill($ckp);

        $t2->allgrey;
        $t3->allblack;
        $t3->math(   "\\{gnomon}STU = 4\\{dot}(\\{square}AG "
                   . "+ \\{square}CK) = 4\\{square}AK" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
              "AK is the rectangle formed by AB, BD (since BK equals\\{nb}BD), "
                . "hence four AK is equal to four"
                . " times AB, BD, which is also equal to the gnomon STU" );
        $s{GR}->fill();
        $s{BN}->fill();
        $s{KP}->fill();
        $s{MQ}->fill();
        $s{QL}->fill();
        $s{RF}->fill();

        $a{STU}->grey;
        $t3->allgrey;
        $t3->black(-1);
        $t3->math(   "\\{gnomon}STU = 4\\{square}AK = 4\\{dot}AB\\{dot}BD  "
                   . "\\{therefore} \\{gnomon}STU = 4\\{dot}AB\\{dot}BD" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "Add the square of AC (which is also equal to OH) and we "
                      . "have four times the rectangle AB,BD plus "
                      . "the square of AC is equal to the gnomon "
                      . "plus OH, which is equal to the square of AD" );
        $a{STU}->remove;

        $a{STU} = Gnomon->new(
                          $pn, VirtualLine->new( $p{Q}->coords, $p{H}->coords ),
                          VirtualLine->new( $p{Q}->coords, $p{O}->coords ),
                          -size   => 60,
                          -center => 40
        )->label("STU");

        $s{AG}->fill($cag);
        $s{MQ}->fill($cmq);
        $s{QL}->fill($cql);
        $s{RF}->fill($crf);
        $s{GR}->fill($cgr);
        $s{BN}->fill($cbn);
        $s{KP}->fill($ckp);
        $s{CK}->fill($cck);

        $s{OH}->grey->fill($coh);

        $t3->allgrey;
        $t3->black(-1);
        $t3->math(   "\\{gnomon}STU + \\{square}OH = AD\\{dot}AD "
                   . "= 4\\{dot}AB\\{dot}BD + AC\\{dot}AC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain( "And finally, since BD is equal to CB, and AD is equal "
            . "to AB with AC added in a straight line, "
            . "the square of AC added with quadruple the "
            . "rectangle of AB and AC, is equal to the square of AB added to BC"
        );
        $s{OH} =
          Polygon->new( $pn, 4, $p{O}->coords, $p{E}->coords, $p{H}->coords,
                        $p{Q}->coords, -1 )->grey->fill($coh);

        $t3->allgrey;
        $t3->black(-1);
        $t3->math(   "(AB + BC)\\{dot}(AB + BC) "
                   . "= 4\\{dot}AB\\{dot}BC + AC\\{dot}AC" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->allgrey;
        $t3->black(-1);
        $t2->blue(0);
    };

    return $steps;

}

