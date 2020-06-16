#!/usr/bin/perl 
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 300, 200 );
my $tp = $pn->text_box( 300, 200 );
my $t3 = $pn->text_box( 400, 160 );
my $t4 = $pn->text_box( 700, 160 );

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If there be as many numbers as we please in continued proportion, and ".
    "the extremes of them be prime to one another, the numbers are the least ".
    "of those which have the same ratio with them";

Proposition::play(
                   $pn,
                   -steps  => \&explanation,
                   -title  => $title,
                   -book   => "VIII",
                   -number => 1
);

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my ( %p, %c, %s, %t, %l );
    my $ds  = 80;
    my $dx  = 60;
    my $dy  = 3;
    my $dx1 = $ds;
    my $dx2 = $ds + $dx;
    my $dx3 = $ds + 2 * $dx;
    my $A   = 145;
    my $B   = 0;
    my $C   = 63;
    my $D   = 0;
    my $F   = $A - $A % $C;
    my $G   = $C - $C % ( $A - $F );
    my $H   = $A - ( $A - $F ) % ( $C - $G );
    my $E   = 5;
    my $yl  = 180 + $A * $dy;
    my $sep = 5;

    my $steps;
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("In other words");
        $t1->explain( "Start with two unequal natural numbers, continuously "
            . "subtract the smaller "
            . "from the larger as long as one number is not a multiple of the other"
        );
        $t1->explain( "If the resulting number is the number one, then the two "
                      . "numbers are relatively prime" );

        $p{A} = Point->new( $pn, $dx1, $yl - $A * $dy )->label( "A", "right" );
        $p{B} = Point->new( $pn, $dx1, $yl - $B * $dy )->label( "B", "right" );
        $p{C} = Point->new( $pn, $dx2, $yl - $C * $dy )->label( "C", "right" );
        $p{D} = Point->new( $pn, $dx2, $yl - $D * $dy )->label( "D", "right" );
        $l{AB} = Line->join( $p{A}, $p{B} );
        $l{DC} = Line->join( $p{C}, $p{D} );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Example");
        $t2->erase;
        $t2->math("AB = 145, CD = 63");
        $t3->y( $t2->y );
        $t3->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let CD measure BF with the remainder AF less than CD, ");
        $p{F} = Point->new( $pn, $dx1, $yl - $F * $dy )->label( "F", "right" );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->math("145- 63 = 82");
        $l{AB}->grey;
        $p{t1} = Point->new( $pn, $dx1, $yl - $C * $dy );
        $l{t1} = Line->join( $p{t1}, $p{A} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->math(" 82- 63 = 19");
        $t3->down($sep);
        $t2->y( $t3->y );
        $l{t1}->remove;
        $p{t1}->grey;
        $p{t2} = Point->new( $pn, $dx1, $yl - 2 * $C * $dy );
        $l{t2} = Line->join( $p{t2}, $p{A} );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t2}->remove;
        $p{t2}->grey;
        $t2->math("AF=19");
        $t3->y( $t2->y );
        $t3->down($sep);
        $l{AF} = Line->join( $p{A}, $p{F} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let AF measure DG, with CG less than AF");
        $p{G} = Point->new( $pn, $dx2, $yl - $G * $dy )->label( "G", "right" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t2}->remove;
        $p{t2}->grey;
        $l{DC}->grey;
        $p{t3} = Point->new( $pn, $dx2, $yl - ( $A - $F ) * $dy );
        $l{t3} = Line->join( $p{t3}, $p{C} );
        $t3->math(" 63- 19 = 44");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t3}->remove;
        $p{t3}->grey;
        $p{t4} = Point->new( $pn, $dx2, $yl - 2 * ( $A - $F ) * $dy );
        $l{t4} = Line->join( $p{t4}, $p{C} );
        $t3->math(" 44- 19 = 25");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t4}->remove;
        $p{t4}->grey;
        $p{t5} = Point->new( $pn, $dx2, $yl - 3 * ( $A - $F ) * $dy );
        $l{t5} = Line->join( $p{t5}, $p{C} );
        $t3->math(" 25- 19 =  6");
        $t3->down($sep);
        $t2->y( $t3->y );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->math("CG=6");
        $t2->down($sep);
        $l{CG} = Line->join( $p{C}, $p{G} );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("And let CG measure FH ...");
        $p{H} = Point->new( $pn, $dx1, $yl - $H * $dy )->label( "H", "left" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->y( $t2->y );
        $t3->down($sep);
        $l{AF}->grey;
        $p{t7} = Point->new( $pn, $dx1, $yl - ( $F - ( $G - $C ) ) * $dy );
        $l{t7} = Line->join( $p{t7}, $p{A} );
        $t3->math(" 19-  6 =  13");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t7}->remove;
        $p{t7}->grey;
        $p{t8} = Point->new( $pn, $dx1, $yl - ( $F - 2 * ( $G - $C ) ) * $dy );
        $l{t8} = Line->join( $p{t8}, $p{A} );
        $t3->math(" 13-  6 =   7");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{t8}->remove;
        $p{t8}->grey;
        $p{t9} = Point->new( $pn, $dx1, $yl - ( $F - 3 * ( $G - $C ) ) * $dy );
        $l{t9} = Line->join( $p{t9}, $p{A} );
        $t3->math("  7-  6 =   1");
    };

    push @$steps, sub {
        $t1->explain("... leaving a single unit as the remainder");
        $t3->down($sep);
        $t2->y( $t3->y );
        $t2->math("AH = 1");
        $t2->down($sep);
    };

    push @$steps, sub {
        $t1->explain("145 and 63 are prime to one another");
        $t2->down;
        $t2->math("gcd(145,63) = 1");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{AB}->normal;
        $l{DC}->normal;

        $t1->erase();
        $t1->title("Proof by Contradiction");
        $t3->erase();
        $t2->erase();
        $t2->math("BF = CD + CD + ... = \\{sum(i=1,a)} CD, AF < CD");
        $t2->down($sep);
        $t2->math("DG = AF + AF + ... = \\{sum(i=1,b)}  AF, CG < AF");
        $t2->down($sep);
        $t2->math("FH = CG + CG + ... = \\{sum(i=1,c)}  CG");
        $t2->down($sep);
        $t2->math("AH = 1");
        $t2->down($sep);
        $l{AB}->normal;
        $l{DC}->normal;
        $t2->allblue;

        $t1->explain("Let CD measure BF with the remainder AF less than CD, ");
        $t1->explain("And AF measure DG, with CG less than AF");
        $t1->explain("And let CG measure FH, leaving AH equal to one");

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Assume that AB,CD are not relatively prime");
        $t1->explain(
"Therefore there is some natural number 'E' which measures both AB and CD" );
        $t2->down;
        $t2->explain("Let");
        $t2->math("AB = \\{sum(_i=1,p)}  E");
        $t2->down($sep);
        $t2->math("CD = \\{sum(i=1,q)}  E");
        $t2->down($sep);
        $t2->math("E \\{notequal} 1");
        $l{E} =
          Line->new( $pn, $dx3, $yl, $dx3, $yl - $E * $dy )
          ->label( "E", "right" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey( [ 0 .. 20 ] );
        $t2->black( [ 0, -2 ] );
        $t1->explain(
                 "Since E measures CD, and CD measures BF, E also measures BF");
        $t2->math(
"BF = \\{sum(i=1,q)}  E + \\{sum(i=1,q)}  E + ... = \\{sum(i=1,d)}  E" );
        $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey( [ 0 .. 20 ] );
        $t2->black( [ -1, -4 ] );
        $t1->explain("But E also measures AB, therefore it also measures AF");
        $t2->math(
"AF = AB-BF = \\{sum(i=1,p)}  E - \\{sum(i=1,d)}  E = \\{sum(i=1,e)}  E" );
        $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey( [ 0 .. 20 ] );
        $t2->black( [ 1, -1 ] );
        $t1->explain("But AF measures DG, therefore E also measures DG");
        $t2->math(
"DG = \\{sum(i=1,e)}  E + \\{sum(i=1,e)}  E + ... = \\{sum(i=1,f)}  E" );
        $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey( [ 0 .. 20 ] );
        $t2->black( [ -5, -1 ] );
        $t1->explain(
            "But it also measures the whole CD, therefore it also measures CG");
        $t2->math(
"CG = CD-DG = \\{sum(i=1,q)}  E - \\{sum(i=1,f)}  E = \\{sum(i=1,g)}  E" );
        $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey( [ 0 .. 20 ] );
        $t2->black( [ 2, -1 ] );
        $t1->explain("But CG measures FH, therefore E also measures FH");
        $t2->math(
"FH = \\{sum(i=1,g)}  E + \\{sum(i=1,g)}  E + ... = \\{sum(i=1,h)}  E" );
        $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain(
                  "But E also measures the whole of AF, therefore it will also "
                    . "measure the remainder AH" );
        $t2->grey( [ 0 .. 20 ] );
        $t2->black( [ -4, -1 ] );
        $t2->math(
"AH = AF - FH = \\{sum(i=1,e)}  E - \\{sum(i=1,h)}  E = \\{sum(i=1,m)}  E" );
        $t2->down($sep);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->grey( [ 0 .. 20 ] );
        $t2->red( [ 3, 7, -1 ] );
        $t1->down;
        $t1->explain(
                     "But... AH cannot be simultaneously be equal to one and a "
                       . "multiple of a number greater than one" );
        $t1->explain(
"Therefore we have a contradiction, and AB and CD must be relatively prime" );
        $t2->down;
        $t2->math("AH = \\{sum(i=1,m)}  E = 1 \\{wrong}");
        $t2->red( [-1] );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->allgrey;
        $t2->blue( [ 0, 1, 2, 3 ] );
        $t2->red( [ 5, 6, 7 ] );
    };

    return $steps;

}

