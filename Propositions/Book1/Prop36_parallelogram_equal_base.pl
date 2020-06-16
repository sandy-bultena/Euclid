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
my $title = "Parallelograms which are on equal bases and in the same parallels equal one another.";

my $pn = PropositionCanvas->new( -number => 36, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 400, 500 );

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,36);
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

    my @A = ( 100, 200 );
    my @B = ( 75,  400 );
    my @C = ( 225, 400 );
    my @H = ( 500, 200 );
    my @G = ( 600, 400 );
    my @F = ( $G[0] - ( $C[0] - $B[0] ), 400 );
    my @E;

    my @steps;

    # ------------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Parallelograms with equal bases and equal heights have equal area");
        $t1->explain("Given two parallel lines ");

        $l{AH} = Line->new( $pn, @A, @H )->dash;
        $l{BG} = Line->new( $pn, @B, @G )->dash;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Let ABCD and EFGH be parallelograms with equal bases ".
        "BC and FG on the same parallels AH and BG" );
        $s{ABCD} = Parallelogram->new( $pn, @A, @B, @C, 1, -points => [qw(A top B bottom C bottom D top)] );
        $s{EFGH} = Parallelogram->new( $pn, @H, @G, @F, 1, -points => [qw(H top G bottom F bottom E top)] );
        @E       = $s{EFGH}->p(4)->coords;
        $s{ABCD}->l(2)->label( "x", "bottom" );
        $s{EFGH}->l(2)->label( "x", "bottom" );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("The area ABCD is equal to EFGH");
        $l{AH}->grey;
        $l{BG}->grey;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("Proof");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("FG equals EH since EFGH is a parallelogram\\{nb}(I.34)");
        $s{EFGH}->l(4)->label( "x", "top" );
        $t3->math("FG = EH = x");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create lines BE and CH");
        $l{BE} = Line->new( $pn, $s{ABCD}->p(2)->coords, $s{EFGH}->p(4)->coords );
        $l{CH} = Line->new( $pn, $s{ABCD}->p(3)->coords, $s{EFGH}->p(1)->coords );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("BC equals FG and FG equals EH, therefore BC equals\\{nb}EH");
        $t3->math("BC = FG = EH = x");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "BC and EH are parallel, and equal, therefore the "
                      . "lines joining the endpoints are also equal and "
                      . "parallel\\{nb}(I.33), making EBCH a parallelogram" );

        $l{BE}->label( "y", "left" );
        $l{CH}->label( "y", "right" );

        $t3->math( "BC \\{parallel} EH \\{therefore} BE \\{parallel} CH" );
        $t3->math("BE = CH = y");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "ABCD and EBCH are parallelograms which "
                      . "share the same base and are on the same parallels, "
                      . "so their areas are equal\\{nb}(I.35)" );
        $l{BE}->label;
        $l{CH}->label;
        $s{EBCH} = Parallelogram->new( $pn, @B, @C, @H, -1, -fill => $sky_blue );
        
        my @a = $l{BE}->intersect( $s{ABCD}->l(3) );
        $s{ABCD}->fill($lime_green);
        $t{aBC} = Triangle->new( $pn, @a, @B, @C, -1 )->fillover( $s{ABCD}, $teal );

        $t3->math("EBCH = ABCD");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Similarly, EBCH and EFGH are parallelograms which "
                      . "share the same base and are on the same parallels, "
                      . "so their areas are equal\\{nb}(I.35)" );
        $t{aBC}->remove;
        $s{ABCD}->fill;
        $s{EFGH}->fill($pale_pink);

        my @f = $l{CH}->intersect( $s{EFGH}->l(3) );
        $t{EfH} = Triangle->new( $pn, @E, @f, @H, -1 )->fillover( $s{EFGH}, $purple );

        $t3->math("EFGH = EBCH");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore ABCD is equal to EFGH");
        $s{ABCD}->fill($lime_green);
        $s{EBCH}->remove;
        $s{EBCH}->grey;
        $t{EfH}->remove;
        $l{BE}->grey;
        $l{CH}->grey;
        $t3->allgrey;
        $t3->black([-1,-2]);
        $t3->down;
        $t3->math("ABCD = EFGH");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t3->allgrey;
        $t3->black(-1);
    };

    return \@steps;
}

