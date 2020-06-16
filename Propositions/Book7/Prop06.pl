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


# ============================================================================
# Definitions
# ============================================================================
my $title = "If a number be parts of a number, and another be the same parts ".
"of another, the sum will also be the same parts of the sum that the one ".
"is of the one.";

$pn->title( 6, $title, 'VII' );

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 340, 200 );
my $t3 = $pn->text_box( 600, 200 );
my $tp = $pn->text_box( 600, 180 );
    $t2->wide_math(1);

my $steps;
push @$steps, Proposition::title_page7($pn);
push @$steps, Proposition::toc7( $pn, 6 );
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
    my (%p,%c,%s,%t,%l);
    my $ds = 80;
    my $dx = 60;
    my $dy = 10;
    my $dx1 = $ds;
    my $dx2 = $ds + $dx;
    my $dx3 = $ds + 2*$dx;
    my $dx4 = $ds + 3*$dx;
    my $dx5 = $ds + 4*$dx;
    my $dx6 = $ds + 5*$dx;
    my $A = 30;
    my $B = 0;
    my $C = 3/2*$A;
    my $E = 40;
    my $D = 18;
    my $F = 3/2*$D;
    my $G = $A/2;
    my $H = $D/2;
    my $yl = 180+$C*$dy;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->title("In other words");
        $t1->explain("If b is the same fraction of a as d is to c, then the sum b,d "
        ."will also be the same fraction of the sum a,c");
        $t2->math("b = (p/q)\\{dot}a");
        $t2->math("d = (p/q)\\{dot}c");
        $t2->math("\\{then} (b+d) = (p/q)\\{dot}(a+c)");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t2->erase;
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Let the number AB be parts of C, and let another number DE ".
        "be the same parts of F");
       $l{A} = Line->new($pn,$dx1,$yl,$dx1,$yl-$A*$dy);
       $l{C} = Line->new($pn,$dx2,$yl,$dx2,$yl-($C)*$dy)->label("C");
       $p{A} = Point->new($pn,$dx1,$yl-($A)*$dy)->label("A");
       $p{B} = Point->new($pn,$dx1,$yl)->label("B");
       $l{D} = Line->new($pn,$dx3,$yl,$dx3,$yl-$D*$dy);
       $l{F} = Line->new($pn,$dx4,$yl,$dx4,$yl-($F)*$dy)->label("F");
       $p{D} = Point->new($pn,$dx3,$yl-($D)*$dy)->label("D");
       $p{E} = Point->new($pn,$dx3,$yl)->label("E");
       
       $t2->math("AB = \\{sum(i=1,p)} C/q = p\\{dot}C/q");
       $t2->math("DE = \\{sum(i=1,p)} F/q = p\\{dot}F/q");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since there as parts of DE in F as there are parts of AB in C, ".
        "therefore there are as many parts of F in DE as there are parts of C in AB");
        my $sp=5;
        my $xp = 10;
       $l{A0} = Line->new($pn,$dx1+$xp,$yl-$sp,$dx1+$xp,$yl-$A*$dy/2+$sp)->grey;
       $l{A1} = Line->new($pn,$dx1+$xp,$yl-$sp-$A*$dy/2,$dx1+$xp,$yl-$A*$dy+$sp)->grey;

       $l{C0} = Line->new($pn,$dx2+$xp,$yl-$sp-$C*$dy/3*0,$dx2+$xp,$yl-$C/3*1*$dy+$sp)->grey;
       $l{C1} = Line->new($pn,$dx2+$xp,$yl-$sp-$C*$dy/3*1,$dx2+$xp,$yl-$C/3*2*$dy+$sp)->grey;
       $l{C2} = Line->new($pn,$dx2+$xp,$yl-$sp-$C*$dy/3*2,$dx2+$xp,$yl-$C/3*3*$dy+$sp)->grey;

       $l{D0} = Line->new($pn,$dx3+$xp,$yl-$sp-$D*$dy/2*0,$dx3+$xp,$yl-$D/2*1*$dy+$sp)->grey;
       $l{D1} = Line->new($pn,$dx3+$xp,$yl-$sp-$D*$dy/2*1,$dx3+$xp,$yl-$D/2*2*$dy+$sp)->grey;

       $l{F0} = Line->new($pn,$dx4+$xp,$yl-$sp-$F*$dy/3*0,$dx4+$xp,$yl-$F/3*1*$dy+$sp)->grey;
       $l{F1} = Line->new($pn,$dx4+$xp,$yl-$sp-$F*$dy/3*1,$dx4+$xp,$yl-$F/3*2*$dy+$sp)->grey;
       $l{F2} = Line->new($pn,$dx4+$xp,$yl-$sp-$F*$dy/3*2,$dx4+$xp,$yl-$F/3*3*$dy+$sp)->grey;

       
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let AB be divided into the parts of C");        
        $t1->explain("Let DE be divided into the parts of F");        
       $p{G} = Point->new($pn,$dx1,$yl-$G*$dy)->label("G");
       $p{H} = Point->new($pn,$dx3,$yl-$H*$dy)->label("H");
       $t2->down;
       $t2->math("AG = GB = C/q");
       $t2->math("DH = HE = F/q");
       $t2->down;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since DH is the same part of F that AG is of C, the sum of ".
        "DH,AG will be the same part of the sum C,F as DH is to F (VII.5)");
        $t2->math("AG + DH = (C+F)/q");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Likewise, since HE is the same part of F that GB is of C, the sum of ".
        "HE,GB will be the same part of the sum C,F as HE is to F (VII.5)");
        $t2->math("GB + HE = (C+F)/q");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Given that AB and DE have the same number of parts, the previous ".
        "process can be repeated for every part in AB and DE");
       $t2->down;
        $t2->math("AB + DE = \\{sum(i=1,p)} (C+F)/q");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
         $t1->explain("Thus the sum of AB,DE will be the same parts of C,F as AB is to C ");
        $t2->blue([0..20]);
        $t2->grey([2..5]);
        my $mw = $pn->Tk_canvas->toplevel;
#use Tk::WinPhoto;        
#        my $canvas_to_get_photo=$mw->Photo(-format=>'', -data=>oct($mw->id));
 #       $canvas_to_get_photo->write('./image.png', -format=>'png');
    };

    

    
    return $steps;

}

