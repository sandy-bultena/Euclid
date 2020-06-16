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
my $title =
    "If two triangles have two angles equal to two angles "
  . "respectively, and one side equal to one side, namely, "
  . "either the side adjoining the equal angles, or that "
  . "opposite one of the equal angles, then the remaining "
  . "sides equal the remaining sides and the remaining angle "
  . "equals the remaining angle.";

my $pn = PropositionCanvas->new( -number => 26, -title => $title );
my $t1 = $pn->text_box( 800, 150, -width => 480 );
my $t2 = $pn->text_box( 475, 175 );
my $t3 = $pn->text_box( 475, 175 );
my $t3ystart = 175;

Proposition::init($pn);
my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,26);
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

    my ( %l, %p, %c, %a, %t );
    my @objs;

    my @A = ( 200, 200 );
    my @B = ( 75,  425 );
    my @D = ( 200, 500 );
    my @E = ( 75,  660 );

    my $ab  = 250;
    my $bc  = 300;
    my $ef  = $bc;
    my $de  = 200;
    my $abc = 60;
    my @steps;

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain( "Given two triangles ABC and DEF, where "
              . "BC equals EF, and angles ABC and DEF are equal, "
              . "and angles BCA and EFD are equal (ASA)" );

        my ( $x2, $y2, $x3, $y3, $r3 ) =
          Triangle->calculate_SAS( @A, $ab, $abc, $bc );

        $t{ABC} = Triangle->SSS($pn,
            @B, $ab, $bc, $r3,1,
            -points => [ "A", "top", "B", "left", "C", "right" ],
            -angles => [ undef, "\\{beta}", "\\{gamma}" ],
        );

        ( $x2, $y2, $x3, $y3, $r3 ) =
          Triangle->calculate_SAS( @D, $de, $abc, $ef );
        $t{DEF} = Triangle->SSS($pn,
            @E, $de, $ef, $r3,1,
            -points => [ "D", "top", "E", "left", "F", "right" ],
            -angles => [ undef, "\\{epsilon}", "\\{phi}" ],
        );
        $t2->math("\\{epsilon} = \\{beta} ");
        $t2->math("\\{phi} = \\{gamma}");
        $t2->math("EF = BC");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then the two triangles are equivalent");
        $t2->down;
        $t2->math("\\{triangle}ABC \\{equivalent} \\{triangle}DEF");
        $t2->math("DE = AB");
        $t2->math("DF = AC");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t2->erase;

        $t1->title("Proof by Contradiction");
        $t2->math("\\{epsilon} = \\{beta} ");
        $t2->math("\\{phi} = \\{gamma}");
        $t2->math("EF = BC");
        $t2->allblue;
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Assume that AB is greater than DE");
        $t{ABC}->grey;
        $t{DEF}->grey;
        $t{ABC}->l(1)->normal;
        $t{DEF}->l(1)->normal;
        $t{ABC}->p(1)->normal;
        $t{ABC}->p(2)->normal;
        $t{DEF}->p(1)->normal;
        $t{DEF}->p(2)->normal;
        $t3->y($t2->y);
        $t2->allgrey;
        $t2->math("AB > DE");   
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create a point G such that BG equals DE");
        $t2->math("BG = DE");

        $t{ABC}->l(1)->label;
        ( $l{BG}, $p{G} ) = $t{DEF}->l(1)->copy_to_line( $t{ABC}->p(2), $t{ABC}->l(1) );
        $p{G}->label( "G", "left" );
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create line GC, angle BCA is greater than BCG");
        $l{GC} = Line->new($pn, $t{ABC}->p(3)->coords, $p{G}->coords );
        $a{BCG} = Angle->new($pn, $l{GC}, $t{ABC}->l(2), -size => 80 )->label("\\{theta}");

        $t{ABC}->normal;
        $t{DEF}->grey;
        $t{ABC}->a(2)->grey;
        $t{ABC}->remove_line_labels;
        $t{ABC}->l(1)->grey;
        $l{BG}->grey;

        $t2->math("\\{theta} < \\{gamma}");
    };

=remove
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        
        $t2->math("\\{theta} < \\{phi}");        
    };
=cut 

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Triangle GBC has two sides and an angle "
              . "that is equivalent in triangle DEF, hence they "
              . "are equal in all respects (I.4)" );
        $t{BGC}=Triangle->new($pn,@B,$t{ABC}->p(3)->coords,$p{G}->coords,-1);
        $t{ABC}->a(2)->normal;
        $t{BGC}->fill($sky_blue);
        $t{DEF}->normal;
        $t{DEF}->fill($sky_blue);
        $t{ABC}->a(3)->grey;
        $t{ABC}->l(3)->grey;
        $t2->allgrey;
        $t2->black([2,0,-2]);
        $t2->math("\\{triangle}GBC \\{equivalent} \\{triangle}DEF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Thus, angle BCG is equal "
              . "to angle DFE, which is defined as equal to angle BCA" );
              $t2->allgrey;
              $t2->black(-1);
        $t2->math("\\{theta} = \\{phi}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
            "Angle BCG cannot be both less than AND equal " . "to BCA" );
            $t2->allgrey;
            $t2->red([1,5,-1]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
            "Thus the original assumption must be incorrect" );
            $t2->allgrey;
            $t2->red([3]);
        $t3->math("          \\{wrong}");
        $t3->red(-1);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Therefore AB equals DE");
        $t{ABC}->l(1)->remove;
        $t{ABC}->l(3)->remove;
        $t{ABC}->a(3)->remove;
        $t{ABC}->p(1)->remove;
        $p{A} = Point->new($pn, $p{G}->coords )->label( "A", "top" );
        $p{G}->remove;
        $a{BCG}->label("\\{gamma}");
        $t{BGC}->fill;
        $t{DEF}->fill;
        $t2->math("AB = DE");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->explain( "Since we have two triangles, with two equal "
              . "sides, with equivalent angles, then the two triangles "
              . "are equal in all respects (I.4)" );
        $t2->math("\\{triangle}ABC \\{equivalent} \\{triangle}DEF");
        $t2->allgrey;
        $t3->allgrey;
        $t2->blue([0,2]);
        $t2->black([-1,-2]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->blue([0,1,2]);
        $t2->grey([-2,-3]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->erase;
        $t2->erase;
        $t3->erase;
        $t{ABC}->remove;
        $t{DEF}->remove;
        $l{BG}->remove;
        $l{GC}->remove;
        $a{BCG}->remove;
        $t{BGC}->remove;
        $p{A}->remove;
    };

    # -------------------------------------------------------------------------
    # Construction
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain( "Given two triangles ABC and DEF, where "
              . "AB equals DE, and angles ABC and DEF are equal, "
              . "and angles BCA and EFD are equal (SSA)" );

        my ( $x2, $y2, $x3, $y3, $r3 ) =
          Triangle->calculate_SAS( @A, $de, $abc, $bc + 75 );

        $t{ABC} = Triangle->SSS($pn,
            @B, $de, $bc + 75, $r3,1,
            -points => [ "A", "top", "B", "left", "C", "right" ],
            -angles => [ undef, "\\{beta}", "\\{gamma}" ],
        );

        ( $x2, $y2, $x3, $y3, $r3 ) =
          Triangle->calculate_SAS( @D, $de, $abc, $ef );
        $t{DEF} = Triangle->SSS($pn,
            @E, $de, $ef, $r3,1,
            -points => [ "D", "top", "E", "left", "F", "right" ],
            -angles => [ undef, "\\{epsilon}", "\\{phi}" ],
        );
        $t2->math("\\{epsilon} = \\{beta} ");
        $t2->math("\\{phi} = \\{gamma}");
        $t2->math("AB = DE");
        $t2->allblue;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then the two triangles are equal in all respects");
        $t{ABC}->set_angles("\\{alpha}");
        $t{DEF}->set_angles("\\{delta}");
        $t2->down;
        $t2->math("\\{delta} = \\{alpha}");
        $t2->math("AC = DF");
        $t2->math("BC = EF");
        $t2->math("\\{triangle}ABC \\{equivalent} \\{triangle}DEF");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t2->erase;
        $t{ABC}->a(1)->remove;
        $t{DEF}->a(1)->remove;
        $t{ABC}->l(2)->label;
        $t{ABC}->l(3)->label;
        $t{DEF}->l(2)->label;
        $t{DEF}->l(3)->label;

        $t1->title("Proof by Contradiction");
        $t2->math("\\{epsilon} = \\{beta} ");
        $t2->math("\\{phi} = \\{gamma}");
        $t2->math("AB = DE");
        $t2->allblue;
        $t2->down;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Assume that BC is greater than EF");
        $t3->y($t2->y);
        $t2->allgrey;
        $t2->math("BC > EF");   
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create a point H such that BG equals EF\\{nb}(I.2)");
        ( $l{BH}, $p{H} ) = $t{DEF}->l(2)->copy_to_line( $t{ABC}->p(2), $t{ABC}->l(2) );
    
        $t{ABC}->l(1)->grey;
        $t{ABC}->l(3)->grey;
        $t{ABC}->a(2)->grey;
        $t{ABC}->a(3)->grey;
        $t{DEF}->l(1)->grey;
        $t{DEF}->l(3)->grey;
        $t{DEF}->a(2)->grey;
        $t{DEF}->a(3)->grey;
    
    
        $p{H}->label( "H", "bottom" );
        $t2->math("BH = EF");
    
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Create line HA");
        $l{HA} = Line->join( $p{G}, $p{H});
    };

=remove
    # -------------------------------------------------------------------------
    push @steps, sub {
        $l{HA} = Line->join( $p{G}, $p{H});
        $t{ABC}->l(3)->normal;
        $t{ABC}->l(1)->normal;
        $t{ABC}->l(2)->grey;
        $t{ABC}->a(1)->draw;
        $l{BH}->grey;
        $t{DEF}->l(2)->grey;
        
        $a{CAB} = Angle->new($pn, $l{HA}, $t{ABC}->l(3) )->label("\\{lambda}",110);
        $t2->math("\\{alpha} > \\{lambda}");
    };
=cut
    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Triangle ABH has two sides and an angle "
              . "that is equivalent in triangle DEF, hence they "
              . "are equal in all respects (I.4)" );
        $t{DEF}->normal;
        $t{ABH}=Triangle->new($pn,$p{G}->coords,@B,$p{H}->coords,-1);
        $t{ABH}->fill($sky_blue);
        $t{DEF}->fill($sky_blue);
        $t{ABC}->a(2)->draw;
        $t2->allgrey;
        $t2->blue([0,2,-2]);
        $t2->black([-2]);
        $t2->math("\\{triangle}ABH \\{equivalent} \\{triangle}DEF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Thus, angle AHB is equal " . "to angle DFE" );
        $a{BAH} = Angle->new($pn, $l{HA}, $l{BH} )->label("\\{theta}");
        $t2->math("\\{theta} = \\{phi}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since angle AHB is an exterior angle to the "
              . "triangle AHC, it must be larger than angle ACH (I.16)" );
        $t{DEF}->fill;
        $t{ABH}->fill();
        $t{AHC}=Triangle->new($pn,$p{G}->coords,$p{H}->coords,$t{ABC}->p(3)->coords,-1);
        $t{AHC}->fill($pale_pink);
        $t{ABC}->a(3)->draw;
        $t{DEF}->grey;
        $t{ABC}->l(1)->grey;
        $t{ABH}->l(1)->grey;
        $t{ABC}->a(2)->grey;
        $t{ABC}->a(1)->grey;
        $t2->allgrey;
        $t2->math("\\{theta} > \\{gamma}");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
            "Angle BHA cannot be both greater than AND equal " . "to BCA" );
        $t2->allgrey;
        $t2->red([-1,6,1]);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("So the initial assumption is incorrect");
        $t3->math("          \\{wrong}");
        $t3->red(0);
        $t{ABC}->l(2)->remove;
        $t{ABC}->l(3)->remove;
        $t{ABC}->a(3)->remove;
        $t{ABC}->p(3)->remove;
        $t{AHC}->remove;
        $t{ABH}->remove;
        $p{C} = Point->new($pn, $p{H}->coords )->label( "C", "right" );
        $p{H}->remove;
        $t2->allgrey;
        $t2->red(3);
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Thus, BC equals EF");
        $t2->math("BC = EF");
        $t{DEF}->l(2)->normal;
        $t{DEF}->p(2)->normal;
        $t{DEF}->p(3)->normal;
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t3->allgrey;
        $t1->explain( "Since we have two triangles, with two equal "
              . "sides, with equivalent angles, then the two triangles "
              . "are equal in all respects (I.4)" );
        $t{ABC}->set_angles("\\{alpha}");
        $t{DEF}->set_angles("\\{delta}");
        $t{ABC}->l(1)->normal;
        $t{ABC}->a(2)->draw;
        $t{DEF}->normal;
        $t2->down;
        $t2->allgrey;
        $t2->blue([0,2]);
        $t2->black(-1);
        $t2->math("\\{triangle}ABC \\{equivalent} \\{triangle}DEF");
    };

    # -------------------------------------------------------------------------
    push @steps, sub {
        $t2->allgrey;
        $t2->blue([0..2]);
        $t2->black(-1);
    };

    return \@steps;
}

