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
    "In isosceles triangles the angles at the base equal one another, and, "
  . "if the equal straight lines are produced further, "
  . "then the angles under the base equal one another.";

my $pn = PropositionCanvas->new( -number => 5, -title => $title );
Proposition::init($pn);
$pn->copyright;
my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 400, 180 );
my $t3 = $pn->text_box( 800, 150, -width => 480 );

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,5);
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

    my %l;
    my %p;
    my %c;
    my %a;
    my %t;
    my @objs;

    my @A = ( 200, 200 );
    my @B = ( 300, 450 );
    my @C = ( 100, 450 );
    my @steps;

    # ------------------------------------------------------------------------
    # In other words
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain("Given an isosceles triangle ABC");
        $p{A} = Point->new($pn,@A)->label( "A", "top" );
        $p{B} = Point->new($pn,@B)->label( "B", "right" );
        $p{C} = Point->new($pn,@C)->label( "C", "left" );
        $l{AB} = Line->new($pn,@A,@B);
        $l{BC} = Line->new($pn,@B,@C);
        $l{AC} = Line->new($pn,@A,@C);
        $a{BAC} = Angle->new($pn, $l{AC}, $l{AB} )->label("\\{gamma}");
        $t2->math("AB = AC");
        $t2->blue(0);
        
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then the angles at the base ACB and ABC are equal");
        $t2->math("\\{angle}ACB = \\{angle}ABC");
        $a{ABC} = Angle->new($pn, $l{AB}, $l{BC}, -size => 30 )->label("\\{alpha}");
        $a{ACB} = Angle->new($pn, $l{BC}, $l{AC}, -size => 30 )->label("\\{alpha}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("In addition, if we extend lines AB and AC");

        $l{AB}->extend(150);
        $l{AC}->extend(150);
        ( $l{AB}, $l{BY} ) = $l{AB}->split( $p{B} );
        ( $l{AC}, $l{CZ} ) = $l{AC}->split( $p{C} );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("Then the exterior angles are equal");
        my @D = $l{BY}->point(100);
        my @E = $l{CZ}->point(100);
        $a{YBC} = Angle->new($pn, $l{BC}, $l{BY} )->label("\\{beta}");
        $a{ZCB} = Angle->new($pn, $l{CZ}, $l{BC} )->label("\\{beta}");
        $p{D} = Point->new($pn,@D)->label( "D", "right" );
        $p{E} = Point->new($pn,@E)->label( "E", "left" );
        $t2->math("\\{angle}BCE = \\{angle}CBD");
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $a{YBC}->remove;
        $a{ZCB}->remove;
        $a{ABC}->remove;
        $a{ACB}->remove;
        $p{E}->remove;
        $p{D}->remove;
        $t1->delete;
        $t3->title("Proof");
        $t2->clear;
        $t2->math("AB = AC");
        $t2->blue(0);
        
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t3->explain("Define a point along the extension of AB");
        my @D = $l{BY}->point(100);
        $p{D} = Point->new($pn,@D)->label( "D", "right" );
        $l{BD} = Line->new($pn, @B, @D, -1 );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t3->explain( "Construct a line starting at C, with length BD, "
              . "on the line segment of AC\\{nb}(I.2)" );
        ( $l{CE}, $p{E} ) = $l{BD}->copy_to_line( $p{C}, $l{CZ} );
        $p{E}->label( "E", "left" );
        $t2->math("BD = CE");
        $t2->allblue;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t3->explain("AC and AB are equal, as are BD and CE, thus AE and AD which ".
        "are the sum of AC,CE and AB,BD respectively, are also equal");
        $t2->math("AE = AC + CE");
        $t2->math("AD = AB + BD");
        $t2->math("AE = AD ");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{BC}->grey;
        $t3->explain("Create triangle AEB");
        $t2->down;
        $l{BE} = Line->new($pn, @B, $p{E}->coords );
        $t{AEB} = Triangle->join($p{E},$p{A},$p{B})->fill($sky_blue);
        $t2->math("AE, \\{angle}EAB=\\{gamma}, AB");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t3->explain("Create triangle ADC");
        $l{CZ}->grey;
        $t{AEB}->grey;
        $l{BC}->grey;
        $l{CE}->grey;
        $l{BE}->grey;
        $l{BD}->normal;
        $l{BY}->grey;
        $l{AC}->remove;
        $l{AC} = Line->new($pn, @A, @C, -1 );
        $l{CD} = Line->new($pn, @C, $p{D}->coords );
        $t2->math("AD, \\{angle}DAC=\\{gamma}, AC");
        $t{ADC} = Triangle->join($p{C},$p{A},$p{D})->fill($sky_blue);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{CE}->normal;
        $l{BE}->normal;
        $t{ADC}->remove;
        my @ps = $l{CD}->intersect($l{BE});
        $t{inner} = Polygon->new($pn,4,@A,@C,@ps,@B)->fill($blue);
        $t{outer1} = Polygon->new($pn,3,@C,$p{E}->coords,@ps)->fill($sky_blue);        
        $t{outer2} = Polygon->new($pn,3,@B,$p{D}->coords,@ps)->fill($sky_blue);        
    

        $t3->explain( "Since two sides and the angle between are "
              . "the same for both triangles, ");
    
        $t2->allgrey;
        $t2->black([4,0,5,6]);
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
    

        $t3->explain( "then all the sides and angles are equal\\{nb}(I.4)" );
        $a{ACD} = Angle->new($pn, $l{CD}, $l{AC}, -size => 40 )->label("\\{delta}");
        $a{ABE} = Angle->new($pn, $l{AB}, $l{BE}, -size => 40 )->label("\\{delta}");
        $t2->down;
        $t2->math("CD = BE");
        $t2->math("\\{angle}ACD = \\{angle}ABE = \\{delta}");
        $a{CDB} = Angle->new($pn, $l{BD}, $l{CD}, -size => 20 )->label("\\{sigma}");
        $a{CEB} = Angle->new($pn, $l{BE}, $l{CE}, -size => 20 )->label("\\{sigma}");
        $t2->math("\\{angle}CDA = \\{angle}BEA = \\{sigma}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $a{ACD}->grey;
        $a{ABE}->grey;
        $a{CDB}->grey;
        $l{AC}->grey;
        $l{AB}->grey;
        $l{CD}->grey;
        $l{BD}->grey;
        $l{BY}->grey;
        $l{BC}->normal;
        $t{inner}->remove;
        $t{outer1}->remove;        
        $t{outer2}->remove; 
        $t2->allgrey;    

        $t3->explain("Lets look at triangle CEB");
        $t{CEB} = Triangle->join($p{C},$p{E},$p{B})->fill($pale_pink);
        $t2->down;
        $t2->math("CE, \\{angle}BEA=\\{angle}BEC=\\{sigma}, BE");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $a{ACD}->grey;
        $a{ABE}->grey;
        $a{CDB}->normal;
        $a{CEB}->grey;
        $l{AC}->grey;
        $l{AB}->grey;
        $l{CD}->grey;
        $l{CE}->grey;
        $l{BE}->grey;
        $l{CD}->normal;
        $l{BD}->normal;
        $l{BC}->normal;
        $t{CEB}->grey;
        $t{CDB} = Triangle->join($p{C},$p{D},$p{B})->fill($pale_pink);

        $t3->explain("And at triangle CDB");
        $t2->math("BD, \\{angle}CDA=\\{angle}CDB=\\{sigma}, CD");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{CE}->normal;
        $l{BE}->normal;
        $a{CEB}->normal;

        $t2->black([1,7,9]);   
        $t3->explain( "Since two sides and the angle between are the "
              . "same for both triangles, "
              . "then all the sides and angles are equal\\{nb}(I.4)" );

        $a{BCD} =
          Angle->new($pn, $l{CD}, $l{BC}, -size => 50 )->label("\\{epsilon}");
        $a{CBE} =
          Angle->new($pn, $l{BC}, $l{BE}, -size => 50 )->label("\\{epsilon}");
          $t{CDB}->grey;
          
        my @ps = $l{CD}->intersect($l{BE});
        $t{inner} = Polygon->new($pn,3,@C,@ps,@B)->fill(Colour->add($pale_pink,$pale_pink));
        $t{outer1} = Polygon->new($pn,3,@C,$p{E}->coords,@ps)->fill($pale_pink);        
        $t{outer2} = Polygon->new($pn,3,@B,$p{D}->coords,@ps)->fill($pale_pink);        

        
        $t2->math("\\{angle}CBE = \\{angle}BCD = \\{epsilon}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $a{CBD} = Angle->new($pn, $l{BC}, $l{BD}, -size => 25 )->label("\\{beta}");
        $a{BCE} = Angle->new($pn, $l{CE}, $l{BC}, -size => 25 )->label("\\{beta}");
        $t2->math("\\{angle}BCE = \\{angle}CBD = \\{beta}");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $l{CE}->grey;
        $l{BE}->grey;
        $a{CBE}->grey;
        $a{CEB}->remove;
        $a{CDB}->remove;
        $a{BCD}->grey;
        $a{BCE}->normal;
        $a{CBD}->normal;
        $l{AB}->normal;
        $l{AC}->normal;
        $l{CE}->normal;
        $l{BD}->normal;
        $p{E}->remove;
        $l{CE}->label;
        $l{BD}->label;
        $p{D}->remove;
        $l{CD}->grey;

        $t{inner}->remove;
        $t{outer1}->remove;        
        $t{outer2}->remove; 
        $t2->allgrey;
        $t2->blue(0);
        $t3->explain(
            "And, we have just shown that the exterior angles are equal");
        $t2->down;
        $t2->math("\\{angle}BCE = \\{angle}CBD = \\{beta}");
        $t2->down;
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $a{CBE}->normal;
        $l{BE}->grey;
        $l{CD}->grey;
        $a{BCD}->normal;
        $a{CBE}->grey;
        $a{CBE}->normal;
        $a{ACD}->normal;
        $a{ABE}->normal;

        $t3->explain( "Let's look now at the interior angles.  "
              . "The differences between equals are equal"
              . " so that means the interior angles are the same" );
        $t2->math(
            "\\{angle}ABC = \\{angle}ACB = \\{delta} - \\{epsilon} = \\{alpha}"
        );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $a{ABC} = Angle->new($pn, $l{AB}, $l{BC}, -size => 30 )->label("\\{alpha}");
        $a{ACB} = Angle->new($pn, $l{BC}, $l{AC}, -size => 30 )->label("\\{alpha}");
        $a{BCD}->remove;
        $a{CBE}->remove;
        $a{BCD}->remove;
        $a{CBE}->remove;
        $a{ACD}->remove;
        $a{ABE}->remove;
        $l{CD}->remove;
        $l{BE}->remove;
        $l{BY}->normal;
        $l{CZ}->normal;
    };

    # ------------------------------------------------------------------------
    return \@steps;
}

