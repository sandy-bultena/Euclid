#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

# ============================================================================
# Definitions
# ============================================================================
my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 480 );
my $t3      = $pn->text_box( 100, 350 );
my $t2      = $pn->text_box( 520, 200 );

my $steps = explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my ( %l, %p, %c, %s, %a );

    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        my $k = 2;
        my @A = ( 150, 200 );
        my @B = ( 300, 200 );
        my @E = ( 150, 250 );
        my @C = ( 350, 200 );
        my @D = ( 550, 200 );
        my @F = ( 350, 250 );

        my @c = ( 240, 400 );
        my $r = 180;

        my $title =
            "If there be any number of magnitudes whatever which are, "
          . "respectively, equimultiples of any magnitudes equal in  multitude, "
          . "then, whatever multiple one the magnitudes is of one, that "
          . "multiple also will all be of all";

        $pn->title( 1, $title, 'V' );

        $t1->title("In other words");
        $t1->explain(
                 "If we have two lines (AB and CD) that are equal multiples of "
                   . "two other lines (E and F respectively) then ..." );
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{CD} = Line->join( $p{C}, $p{D} );
        $l{E} =
          Line->new( $pn, @E, $E[0] + ( 1 / $k ) * $l{AB}->length, $E[1] );
        $l{F} =
          Line->new( $pn, @F, $F[0] + ( 1 / $k ) * $l{CD}->length, $E[1] );

        $t3->math("If   AB = n\\{dot}E, CD = n\\{dot}F");
        $t1->explain(   "The sum of AB and CD will also be an "
                      . "equal multiple of the sum of E and F" );
        $t3->math("then AB + CD = n\\{dot}(E + F)");
    };

    push @$steps, sub {
        $pn->clear;
        my $title =
          "If a first magnitude be the same multiple of a second that a third "
          . "is of a fourth, and a fifth also be the same multiple of the second that a "
          . "sixth is of the fourth, the sum of the first and fifth will also be the same "
          . "multiple of the second that the sum of the third and sixth is of the fourth";

        $pn->title( 2, $title, 'V' );

        my $k  = 3;
        my $k2 = 2;
        my @A  = ( 150, 200 );
        my @B  = ( 300, 200 );
        my @C  = ( 150, 250 );
        my @D  = ( 150, 300 );
        my @E  = ( 350, 300 );
        my @F  = ( 150, 350 );
        my @G  = ( $B[0] + ( $B[0] - $A[0] ) * $k2 / $k, 200 );
        my @H  = ( $E[0] + ( $E[0] - $D[0] ) * $k2 / $k, 300 );

        my @c = ( 240, 400 );
        my $r = 180;

        $t1->title("In other words");
        $t1->explain(
                    "If we have two lines (AB and DE) that are equal multiples "
                      . "of two other lines (C and F respectively) and ..." );
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{DE} = Line->join( $p{D}, $p{E} );
        $l{C} =
          Line->new( $pn, @C, $C[0] + ( 1 / $k ) * $l{AB}->length, $C[1] );
        $l{F} =
          Line->new( $pn, @F, $F[0] + ( 1 / $k ) * $l{DE}->length, $F[1] );

        $l{AB}->tick_marks( $l{C}->length );
        $l{DE}->tick_marks( $l{F}->length );

        $t3->math("If   AB=n\\{dot}C, DE=n\\{dot}F");
        $t1->explain(
                    "we have another two lines (BG and EH) that are also equal "
                      . "multiples of lines C and F, then..." );
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );
        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
        $l{BG} = Line->join( $p{B}, $p{G} );
        $l{EH} = Line->join( $p{E}, $p{H} );
        $l{BG}->tick( $l{C}->length );
        $l{EH}->tick( $l{F}->length );
        $t3->math("and  BG=m\\{dot}C, EH=m\\{dot}F");

        $t1->explain(
                  "the line AG will be the same multiplier of C as DH is to F");
        $t3->math("then AG=k\\{dot}C and DH=k\\{dot}F");
    };

    push @$steps, sub {
        $pn->clear;
        my $title =
            "If a first magnitude be the same multiple of a second that a "
          . "third is of a fourth, and if equimultiples be taken of the first and third, "
          . "then also, ex aequali, the magnitudes taken will be equimultiples respectively, "
          . "the one of the second, and the other of the fourth.";

        $pn->title( 3, $title, 'V' );

        my $down = 30;
        my $k    = 3;
        my $b    = 75;
        my $d    = 50;
        my $k2   = 2;
        my @A    = ( 150, 200 );
        my @B    = ( 150, 200 + $down );
        my @C    = ( 150, 200 + 3 * $down );
        my @D    = ( 150, 200 + 4 * $down );
        my @E    = ( 150, 200 + 2 * $down );
        my @G    = ( 150, 200 + 5 * $down );
        my @H;
        my @F;

        $t1->title("In other words");
        $t1->explain( "If we have two lines (A and C) that are equal multiples "
                      . "of two other lines (B and D respectively) and ..." );
        $p{A} = Point->new( $pn, @A )->label( "A", "left" );
        $p{B} = Point->new( $pn, @B )->label( "B", "left" );
        $p{C} = Point->new( $pn, @C )->label( "C", "left" );
        $p{D} = Point->new( $pn, @D )->label( "D", "left" );

        $l{A} = Line->new( $pn, @A, $A[0] + $k * $b, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b,      $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $k * $d, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d,      $D[1] );

        $l{A}->tick_marks($b);
        $l{C}->tick_marks($d);

        $t3->math("If   A=n\\{dot}B, C=n\\{dot}D");
        $t1->explain(   "we draw two new lines (E and G), "
                      . "equimultiple to A and C respectively ..." );
        $p{G} = Point->new( $pn, @G )->label( "G", "left" );
        $p{E} = Point->new( $pn, @E )->label( "E", "left" );
        $l{E} = Line->new( $pn, @E, $E[0] + 2 * $l{A}->length, $E[1] );
        $l{G} = Line->new( $pn, @G, $G[0] + 2 * $l{C}->length, $G[1] );
        $l{E}->tick_marks( $l{A}->length );
        $l{G}->tick_marks( $l{C}->length );

        ( undef, undef, @H ) = $l{G}->endpoints();
        ( undef, undef, @F ) = $l{E}->endpoints();

        $p{H} = Point->new( $pn, @H )->label( "H", 'top' );
        $p{F} = Point->new( $pn, @F )->label( "F", 'top' );

        $t3->math("and  EF=m\\{dot}A, GH=m\\{dot}C");
        $t1->explain(   "then the lines EF and GH will be equimultiples of "
                      . "B and D respectively" );
        $t3->math("then EF=k\\{dot}B and GH=k\\{dot}D");
        $t3->math("where n,m,k are integers");

    };

    push @$steps, sub {
        $pn->clear;
        my $title =
            "If a first magnitude have to a second the same ratio as a third "
          . "to a fourth, any equimultiples whatever of the first and third will also "
          . "have the same ratio to any equimultiples whatever of the second and fourth "
          . "respectively, taken in corresponding order.";

        $pn->title( 4, $title, 'V' );

        my $down   = 30;
        my $offset = 15;
        my $p      = 1 / 1.2;
        my $k      = 3;
        my $a      = 45;
        my $c      = 60;
        my $k2     = 2;
        my @A      = ( 150, 200 );
        my @B      = ( 150, 200 + $down );
        my @C      = ( 400, 200 );
        my @D      = ( 400, 200 + $down );
        my @E      = ( 150, 200 + 2 * $down + $offset );
        my @F      = ( 400, 200 + 2 * $down + $offset );
        my @G      = ( 150, 200 + 3 * $down + $offset );
        my @H      = ( 400, 200 + 3 * $down + $offset );
        my @K      = ( 150, 200 + 4 * $down + 2 * $offset );
        my @L      = ( 400, 200 + 4 * $down + 2 * $offset );
        my @M      = ( 150, 200 + 5 * $down + 2 * $offset );
        my @N      = ( 400, 200 + 6 * $down + 2 * $offset );

        $t3->erase();
        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let the ratio of A to B be the same ratio C to D");

        $p{A} = Point->new( $pn, @A )->label( "A", "left" );
        $p{B} = Point->new( $pn, @B )->label( "B", "left" );
        $l{A} = Line->new( $pn, @A, $A[0] + $a,      $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $a * $p, $B[1] );

        $p{C} = Point->new( $pn, @C )->label( "C", "left" );
        $p{D} = Point->new( $pn, @D )->label( "D", "left" );
        $l{C} = Line->new( $pn, @C, $C[0] + $c,      $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $c * $p, $D[1] );

        $t3->math("A:B = C:D");
        $t3->down;
        $t1->explain("Draw lines E and F that are equimultiple to A and C");

        $p{E} = Point->new( $pn, @E )->label( "E", "left" );
        $p{F} = Point->new( $pn, @F )->label( "F", "left" );
        $l{E} = Line->new( $pn, @E, $E[0] + $k2 * $a, $E[1] )->tick_marks($a);
        $l{F} = Line->new( $pn, @F, $F[0] + $k2 * $c, $F[1] )->tick_marks($c);

        $t3->math("E = p\\{dot}A");
        $t3->math("F = p\\{dot}C");

        $t1->explain("Draw lines G and H that are equimultiple to B and D");

        $p{G} = Point->new( $pn, @G )->label( "G", "left" );
        $p{H} = Point->new( $pn, @H )->label( "H", "left" );
        $l{G} =
          Line->new( $pn, @G, $G[0] + $k * $a * $p, $G[1] )
          ->tick_marks( $a * $p );
        $l{H} =
          Line->new( $pn, @H, $H[0] + $k * $c * $p, $H[1] )
          ->tick_marks( $c * $p );

        $t3->math("G = q\\{dot}B");
        $t3->math("H = q\\{dot}D");
        $t1->explain("The ratio E to G is equal to the ratio F to H");

        $t3->down;
        $t3->math("E:G = F:H");
        $t3->math("... or if    A:B  =  C:D ");
        $t3->math("     then p\\{dot}A:q\\{dot}B = p\\{dot}C:q\\{dot}D");
    };

    push @$steps, sub {
        $pn->clear;
        my $title =
            "If a magnitude be the same multiple of a magnitude that a part "
          . "subtracted is of a part subtracted, the remainder will also be "
          . "the same multiple of the remainder that the whole is of the whole";

        $pn->title( 5, $title, 'V' );

        my $down    = 60;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t4      = $pn->text_box( 550, 375, -width => 480 );
        my $t3      = $pn->text_box( 160, 200 + 2 * $down );
        my $t2      = $pn->text_box( 450, 200 + 8 * $down );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );
        my ( %l, %p, %c, %s, %a );
        my $p  = 1 / 1.2;
        my $k  = 3;
        my $a  = 45;
        my $cd = 160;
        my $cf = 100;
        my $k2 = 2;
        my @A  = ( 150, 200 );
        my @C  = ( 300, 200 + $down );
        my @D  = ( 300 + $cd, 200 + $down );
        my @B  = ( 150 + $k * $cd, 200 );
        my @E  = ( 150 + $k * $cf, 200 );
        my @F  = ( 300 + $cf, 200 + $down );
        my @G  = ( $C[0] - ( $cd - $cf ), 200 + $down );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let AB be the same multiple of CD as AE is of CF");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );

        $l{AE} = Line->join( $p{A}, $p{E} );
        $l{EB} = Line->join( $p{E}, $p{B} );
        $l{CF} = Line->join( $p{C}, $p{F} );
        $l{FD} = Line->join( $p{F}, $p{D} );

        $t3->math("AB = n\\{dot}CD");
        $t3->math("AE = n\\{dot}CF");
        $t3->down;

        $t1->explain( "Then the remainder of AB minus the part AE is the same "
                      . "multiple of the remainder of CD minus CF" );
        $t3->math("EB = n\\{dot}FD");
        $t3->down;
        $t3->math("AB - AE = n\\{dot}CD - n\\{dot}CF = n\\{dot}(CD - CF)");

    };

    push @$steps, sub {
        $pn->clear;
        my $title =
            "If two magnitudes be equimultiples of two magnitudes, and "
          . "any magnitudes subtracted from them be equimultiples of the same, the "
          . "remainders are also are either equal to the same or equimultiples of them";

        $pn->title( 6, $title, 'V' );

        my $down    = 50;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t4      = $pn->text_box( 550, 375, -width => 480 );
        my $t3      = $pn->text_box( 160, 200 + 4 * $down );
        my $t2      = $pn->text_box( 450, 200 + 4 * $down );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 1 / 1.2;
        my $k  = 4;
        my $a  = 45;
        my $e  = 110;
        my $f  = 75;
        my $k2 = 3;
        my @A  = ( 150, 200 );
        my @C  = ( 150, 200 + 2 * $down );
        my @D  = ( 150 + 4 * $f, 200 + 2 * $down );
        my @B  = ( 150 + $k * $e, 200 );
        my @E  = ( 150, 200 + $down );
        my @F  = ( 150, 200 + 3 * $down );
        my @G  = ( 150 + $k2 * $e, 200 );
        my @K  = ( 150 - $f, 200 + 2 * $down );
        my @H  = ( 150 + 3 * $f, 200 + 2 * $down );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let AB be the same multiple of E as CD is of F");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $l{AB} = Line->join( $p{A}, $p{B} )->tick_marks($e);
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $l{E} = Line->new( $pn, @E, $E[0] + $e, $E[1] );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $l{CD} = Line->join( $p{C}, $p{D} )->tick_marks($f);
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] );

        $t3->math("AB = nE");
        $t3->math("CD = nF");

        $t1->explain( "Subtract AG and CH be subtracted from AB and CD, where "
                      . "AG,CH are equimultiples of E and F respectively" );

        $p{H} = Point->new( $pn, @H )->label( "H", "top" );
        $p{G} = Point->new( $pn, @G )->label( "G", "top" );

        $t3->math("AG = mE");
        $t3->math("CH = mF");

        $t1->explain(   "Then, either EG,HD are equal to E,F, "
                      . "or they are equimultiples of them" );

        $t3->down;
        $t3->math("GB = kE");
        $t3->math("HD = kF");

    };

    push @$steps, sub {
        $pn->clear;
        my $title =
            "Equal magnitudes have the same ratio, as also has the same "
          . "to equal magnitudes";

        $pn->title( 7, $title, 'V' );

        my $down    = 50;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t4      = $pn->text_box( 550, 375, -width => 480 );
        my $t3      = $pn->text_box( 160, 200 + 3 * $down );
        my $t2      = $pn->text_box( 400, 200 + 3 * $down );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 1 / 1.2;
        my $k  = 4;
        my $k2 = 3;
        my $a  = 45;
        my $c  = 65;
        my @A  = ( 150, 200 );
        my @B  = ( 150, 200 + $down );
        my @C  = ( 150, 200 + 2 * $down );
        my @D  = ( 250, 200 );
        my @E  = ( 250, 200 + $down );
        my @F  = ( 250, 200 + 2 * $down );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let A,B be equal, and C not equal");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );

        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $l{B} = Line->new( $pn, @B, $B[0] + $a, $B[1] );

        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $t3->math("A = B \\{notequal} C");
        $t3->blue(0);
        $t3->down;

        $t1->explain(
                "Then the ratio of A to C is the same as the ratio of B to C ");
        $t3->math("A:C = B:C");

        $t1->explain(
                 "And the ratio of C to A is the same as the ratio of C to B ");
        $t3->math("C:A = C:B");
    };

    push @$steps, sub {
        $pn->clear;
        my $title =
            "Of unequal magnitudes, the greater has to the same a greater "
          . "ratio than the less has; and the same has to the less a "
          . "greater ratio than it has to the greater";

        $pn->title( 8, $title, 'V' );

        my $down    = 40;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t3      = $pn->text_box( 160, 200 + 7 * $down + $offset );
        my $t4      = $pn->text_box( 160, 200 + 0 * $down );
        my $t2      = $pn->text_box( 500, 200 + 4 * $down );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 1 / 1.2;
        my $k  = 4;
        my $k2 = 3;
        my $a  = 180;
        my $c  = 125;
        my $d  = 70;
        $offset = 20;
        my @A = ( 150, 200 );
        my @B = ( 150 + $a, 200 );
        my @C = ( 150, 200 + $down );
        my @D = ( 150, 200 + 4 * $down + $offset );
        my @E = ( $B[0] - $c, $B[1] );
        my @F = ( 150, 200 + 2 * $down );
        my @G = ( $F[0] + 2 * ( $a - $c ), $F[1] );
        my @H = ( $G[0] + 2 * $c, $G[1] );
        my @K = ( 150, 200 + 3 * $down );
        my @M = ( 150, $D[1] + $down );
        my @N = ( 150, $M[1] + $down );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain(
                "Let AB be greater than C and let D be an arbitrary magnitude");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $l{AB} = Line->join( $p{A}, $p{B} );

        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );

        $t3->math("AB > C \\{notequal} D");
        $t3->blue(0);
        $t3->down;
        $t1->explain(
              "Then the ratio of AB to D is greater than the ratio of C to D ");
        $t1->explain(
                 "Then the ratio of D to AB is less than the ratio of D to C ");
        $t3->math("AB:D > C:D");
        $t3->math("D:AB < D:C");
    };
    push @$steps, sub {
        $pn->clear;

        my $title =
            "Magnitudes which have the same ratio to the same are equal to "
          . "one another; and magnitudes to which the same has the same ratio "
          . "are equal";

        $pn->title( 9, $title, 'V' );

        my $down    = 40;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t3      = $pn->text_box( 160, 200 + 3 * $down + $offset );
        my $t4      = $pn->text_box( 160, 200 + 0 * $down );
        my $t2      = $pn->text_box( 500, 200 + 4 * $down );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 1 / 1.2;
        my $k  = 4;
        my $k2 = 3;
        my $a  = 180;
        my $c  = 250;
        $offset = 20;
        my @A = ( 150, 200 );
        my @B = ( 150 + $a + 100, 200 );
        my @C = ( 150 + 0.5 * $a, 200 + $down );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain("Let the ratios of A to C and B to C be equal");
        $t1->explain("Then A and B are equal");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $a, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $t3->math("A:C = B:C \\{then} A = B");
        $t3->math("C:A = C:B \\{then} A = B");
        $t3->blue( [ 0, 1 ] );
        $t3->down;
    };

    push @$steps, sub {
        $pn->clear;
        my $title =
            "Of magnitudes which have a ratio to the same, that which "
          . "has a greater ratio is greater; and that to "
          . "which the same has a greater ratio is less.";

        $pn->title( 10, $title, 'V' );

        my $down    = 40;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t3      = $pn->text_box( 160, 200 + 3 * $down + $offset );
        my $t4      = $pn->text_box( 160, 200 + 0 * $down );
        my $t2      = $pn->text_box( 500, 200 + 4 * $down );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 1 / 1.2;
        my $k  = 4;
        my $k2 = 3;
        my $a  = 180;
        my $b  = 150;
        my $c  = 250;
        $offset = 20;
        my @A = ( 150, 200 );
        my @B = ( 150 + $a + 100, 200 );
        my @C = ( 150 + 0.5 * $a, 200 + $down );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain(
                    "Let the ratio of A to C be greater than the ratio B to C");
        $t1->explain("Then A is greater than B");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );

        $t3->math("A:C > B:C \\{then} A > B");
        $t3->math("C:B > C:A \\{then} B < A");
        $t3->blue( [ 0, 1 ] );
        $t3->down;
    };

    push @$steps, sub {
        $pn->clear;
        my $title = "Ratios which are the same with the same ratio are also "
          . "the same with one another.";

        $pn->title( 11, $title, 'V' );

        my $down    = 40;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t3      = $pn->text_box( 160, 200 + 4 * $down + $offset );
        my $t4      = $pn->text_box( 160, 200 + 0 * $down );
        my $t2      = $pn->text_box( 400, 200 + 4 * $down + $offset );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 2.2 / 3;
        my $k  = 2;
        my $k2 = 3;
        my $a  = 120;
        my $c  = 100;
        my $e  = 80;
        my $b  = $a * $p;
        my $d  = $c * $p;
        my $f  = $e * $p;
        $offset = 20;
        my @A = ( 50, 200 );
        my @C = ( 50 + 3 * $b + 20, 200 );
        my @E = ( 50 + 3 * $b + 3 * $d + 40, 200 );
        my @B = ( 50, $A[1] + $down );
        my @D = ( 50 + 3 * $b + 20, $C[1] + $down );
        my @F = ( 50 + 3 * $b + 3 * $d + 40, $E[1] + $down );

        my @G = ( $B[0], $B[1] + $down + $offset );
        my @H = ( $D[0], $D[1] + $down + $offset );
        my @K = ( $F[0], $F[1] + $down + $offset );

        my @L = ( $G[0], $G[1] + $down );
        my @M = ( $H[0], $H[1] + $down );
        my @N = ( $K[0], $K[1] + $down );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain(   "If A is to B as C is to D, and C is to D as "
                      . "E is to F then ..." );
        $t1->explain("... A is to B as E is to F");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );
        $l{E} = Line->new( $pn, @E, $E[0] + $e, $E[1] );
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] );

        $t3->math("A:B = C:D");
        $t3->math("C:D = E:F ");
        $t3->blue( [ 0, 1 ] );
        $t3->math("\\{then} A:B = E:F");
        $t3->down;
    };

    push @$steps, sub {
        $pn->clear;
        my $title =
"If any number of magnitudes be proportional, as one of the antecedents "
          . "is to one of the consequents, so will all the antecedents be to all "
          . "the consequents.";

        $pn->title( 12, $title, 'V' );

        my $down    = 40;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t3      = $pn->text_box( 160, 200 + 5 * $down + $offset );
        my $t4      = $pn->text_box( 160, 200 + 0 * $down );
        my $t2      = $pn->text_box( 400, 200 + 5 * $down + $offset );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 2.2 / 3;
        my $k  = 2;
        my $k2 = 3;
        my $a  = 120;
        my $c  = 100;
        my $e  = 80;
        my $b  = $a * $p;
        my $d  = $c * $p;
        my $f  = $e * $p;
        $offset = 20;
        my @A = ( 150, 200 );
        my @C = ( 150 + $a + 50, 200 );
        my @E = ( 150 + $a + $c + 100, 200 );
        my @B = ( 150, $A[1] + $down );
        my @D = ( 150 + $a + 50, $C[1] + $down );
        my @F = ( 150 + $a + $c + 100, $E[1] + $down );

        my @G = ( $B[0], $B[1] + $down + $offset );
        my @H = ( $B[0], $G[1] + $down );
        my @K = ( $B[0], $H[1] + $down );

        my @L = ( $F[0], $G[1] );
        my @M = ( $F[0], $H[1] );
        my @N = ( $F[0], $K[1] );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain(   "If A is to B as C is to D, and C is to D as "
                      . "E is to F then ..." );
        $t1->explain(   "... the ratio of the sum of A,C,E to the sum of "
                      . "B,D,F is also the ratio of A to B" );

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );
        $l{E} = Line->new( $pn, @E, $E[0] + $e, $E[1] );
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] );

        $t3->math("A:B = C:D = E:F ");
        $t3->blue( [0] );
        $t3->math("\\{then} (A+C+E):(B+D+F) = A:B");
        $t3->down;
    };

    push @$steps, sub {
        $pn->clear;
        my $title =
"If a first magnitude have to a second the same ratio as a third to a "
          . "fourth, and the third have to the fourth a greater ratio than a fifth "
          . "has to a sixth, the first will also have to the second a greater ratio "
          . "than the fifth to the sixth";

        $pn->title( 13, $title, 'V' );

        my $down    = 40;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t3      = $pn->text_box( 160, 200 + 4 * $down + $offset );
        my $t4      = $pn->text_box( 160, 200 + 0 * $down );
        my $t2      = $pn->text_box( 400, 200 + 4 * $down + $offset );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 1.8 / 3;
        my $k  = 2;
        my $k2 = 3;
        my $a  = 80;
        my $c  = 100;
        my $e  = 120;
        my $b  = $a * $p;
        my $d  = $c * $p;
        my $f  = $e * ( $p * 1.3 );
        $offset = 20;
        my @start =
          ( 50, 50 + $a + 30, 50 + $a + $c + 60, 50 + $a + $c + $k * $a + 90 );
        my @A = ( $start[0], 200 );
        my @C = ( $start[1], 200 );
        my @B = ( $start[0], $A[1] + $down );
        my @E = ( $start[0] + 50, $B[1] + $down + $offset );
        my @D = ( $start[1], $C[1] + $down );
        my @F = ( $start[0] + 50, $E[1] + $down );

        my @G = ( $start[3], $A[1] );
        my @H = ( $E[0] + 50 + $e, $B[1] + $down + $offset );
        my @K = ( $start[3], $B[1] );

        my @L = ( $H[0],     $H[1] + $down );
        my @M = ( $start[2], $A[1] );
        my @N = ( $start[2], $B[1] );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain(   "If A is to B as C is to D, and C is to D greater than "
                      . "E is to F " );
        $t1->explain("... then A is to B is also greater than E is to F");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );
        $l{E} = Line->new( $pn, @E, $E[0] + $e, $E[1] );
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] );

        $t3->math("A:B = C:D");
        $t3->math("C:D > E:F");
        $t3->blue( [ 0, 1 ] );
        $t3->math("\\{then} A:B > E:F");
    };

    push @$steps, sub {
        $pn->clear;

        my $title =
            "If a first magnitude have to a second the same ratio as a third "
          . "has to a fourth, and the first be greater than the third, the second "
          . "will also be greater than the fourth; if equal, equal; and if less, less.";

        $pn->title( 14, $title, 'V' );

        my $down    = 40;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t3      = $pn->text_box( 160, 200 + 2 * $down + $offset );
        my $t4      = $pn->text_box( 160, 200 + 0 * $down );
        my $t2      = $pn->text_box( 400, 200 + 2 * $down + $offset );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 1.8 / 3;
        my $k  = 2;
        my $k2 = 3;
        my $a  = 160;
        my $c  = 120;
        my $b  = $a * $p;
        my $d  = $c * $p;
        $offset = 20;
        my @start = ( 150, 150 + $a + 100 );
        my @A = ( $start[0], 200 );
        my @C = ( $start[1], 200 );
        my @B = ( $start[0], $A[1] + $down );
        my @D = ( $start[1], $C[1] + $down );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain("If A is to B as C is to D, and A is greater than C ...");
        $t1->explain("... then B is also greater than D");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );

        $p{D} = Point->new( $pn, @D )->label( "D", "top" );

        $l{A} = Line->new( $pn, @A, $A[0] + $a, $A[1] );
        $l{B} = Line->new( $pn, @B, $B[0] + $b, $B[1] );
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
        $l{D} = Line->new( $pn, @D, $D[0] + $d, $D[1] );

        $t3->math("A:B = C:D");
        $t3->math("A >=< C");
        $t3->blue( [ 0, 1 ] );
        $t3->math("\\{then} B >=< D");
    };

    push @$steps, sub {
        $pn->clear;

        my $title =
            "Parts have the same ratio as the same multiples of them taken "
          . "in corresponding order";

        $pn->title( 15, $title, 'V' );

        my $down    = 60;
        my $offset  = 15;
        my $t1      = $pn->text_box( 800, 150, -width => 500 );
        my $t3      = $pn->text_box( 160, 200 + 2 * $down + $offset );
        my $t4      = $pn->text_box( 160, 200 + 0 * $down );
        my $t2      = $pn->text_box( 400, 200 + 2 * $down + $offset );
        my $tdot    = $pn->text_box( 800, 150, -width => 500 );
        my $tindent = $pn->text_box( 840, 150, -width => 500 );

        my ( %l, %p, %c, %s, %a );
        my $p  = 1.8 / 3;
        my $k  = 2;
        my $k2 = 3;
        my $c  = 80;
        my $f  = 60;
        $offset = 20;
        my @start = ( 150, 150 + 3 * $c + 100 );
        my @A = ( $start[0], 200 );
        my @C = ( $start[1], $A[1] );
        my @B = ( $start[0] + 3 * $c, $A[1] );
        my @D = ( $start[0], $A[1] + $down );
        my @E = ( $start[0] + 3 * $f, $A[1] + $down );
        my @F = ( $start[1], $A[1] + $down );

        $t1->erase();
        $t1->title("In other words");
        $t1->explain("If AB is the same multiple of C as DE is of F ...");
        $t1->explain("... then the ratio of AB to DE is the same as D is to F");

        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "top" );
        $p{C} = Point->new( $pn, @C )->label( "C", "top" );
        $p{D} = Point->new( $pn, @D )->label( "D", "top" );
        $p{E} = Point->new( $pn, @E )->label( "E", "top" );
        $p{F} = Point->new( $pn, @F )->label( "F", "top" );

        $l{A} = Line->join( $p{A}, $p{B} )->tick_marks($c);
        $l{D} = Line->join( $p{D}, $p{E} )->tick_marks($f);
        $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] )->tick_marks($c);
        $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] )->tick_marks($f);

        $t3->math("AB = m\\{dot}C");
        $t3->math("DE = m\\{dot}F");
        $t3->blue( [ 0, 1 ] );
        $t3->down;
        $t3->math("AB:DE = C:F");
    };
    push @$steps, sub {
        $pn->clear;

        my $title =
            "Summary of all props for this book";

        $pn->title( 26, $title, 'V' );
    };

    return $steps;

}
