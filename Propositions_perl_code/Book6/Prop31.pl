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
my $title = "In right-angled triangles the figure on the side subtending the ".
"right angle is equal to the similar and similarly described figures ".
"on the sides containing the right angle.";

$pn->title( 31, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 500 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 31 );
push @$steps, Proposition::reset();
push @$steps, explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go();
my ( %p, %c, %s, %t, %l, %a );

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $yb   = 320;
    my $xs   = 160;
    my $dx1  = 80; # horizontal length B to A
    my $dy1  = 120; # vertical length B to A
    my $dy2  = 100; # height of AC figure
 
    # straight line
    my @B = ( $xs, $yb );
    my @A = ( $xs+$dx1, $yb-$dy1 );
    my @C = ( $A[0]+$dy1*$dy1/$dx1,$A[1]+$dx1*$dy1/$dx1);
    my $colour1 = $blue;
    my $colour2 = $turquoise;
    my $colour3 = $pink;
    my $colour4 = $pale_yellow;
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->title("In other words");
        $t1->explain("Given a right angle triangle ABC where the right angle "
        ."is at the vertex A");
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottomleft" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottomright" );
        $t{ABC} = Triangle->join($p{A},$p{B},$p{C});
    };
    
    push @$steps, sub {
        $t1->explain("Construct three similar polygons on each of "
        ."the sides of the triangle (similarly situated)");
        
        $p{B1} = Point->new($pn,$B[0],$B[1]+$dy2);
        $p{C1} = Point->new($pn,$C[0],$C[1]+$dy2);
        $p{B1}->remove;
        $p{C1}->remove;
        $t{A} = Polygon->join(4,$p{B},$p{C},$p{C1},$p{B1})->fill($colour1)->label("A1");
        
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottomleft" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottomright" );
        
        $t{B} = $t{A}->copy_to_similar_shape ($t{ABC}->l(1))->fill($colour2)->label("A2"); 
        $t{C} = $t{A}->copy_to_similar_shape ($t{ABC}->l(3))->fill($colour3)->label("A3"); 
    
    };
    
    push @$steps, sub {
        $t1->explain("The sum of the polygons on sides adjacent to the right ".
        "angle equals the polygon opposite the right angle");
        $t3->math("A\\{_1} = A\\{_2} + A\\{_3}"); 
        
    };
    
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t3->erase;
        $t{A}->label;
        $t{B}->label;
        $t{C}->label;
        $t{A}->remove;
        $t{B}->remove;
        $t{C}->remove;
        $t{B}->grey;
        $t{C}->grey;
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Draw a line from A to D, perpendicular to BC");
        $l{AD} = $t{ABC}->l(2)->perpendicular($p{A});
        $p{D} = Point->new($pn,$l{AD}->intersect($t{ABC}->l(2)))->label("D","bottom");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Since a perpendicular line (AD) has been drawn from ".
        "the right angle in a right angle triangle (ABC) to its base, ".
        "the resulting triangles (ABD, ADC) are similar to each other and the ".
        "whole (ABC) (VI.8)");
        $t3->math("ABD ~ ADC ~ ABC");
        $t{ADC} = Triangle->join($p{A},$p{D},$p{C})->fill("#fff8ba");
        $t{ABD} = Triangle->join($p{A},$p{B},$p{D})->fill("#fcea4e"); 
        $a{alpha1} = Angle->new($pn,$t{ABD}->l(1),$t{ABD}->l(3))->label("\\{alpha}");        
        $a{alpha2} = Angle->new($pn,$t{ABC}->l(3),$t{ABC}->l(2))->label("\\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the ratio BC to AB is equal to the ratio AB to BD (VI.Def 1)");
        $t3->math("BC:AB = AB:BD");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The three lines BC, AB, BD are proportional, therefore ".
        "the ratio of BC to BD is equal to the ratio of the figures drawn".
        " on BC and AB (VI.19, Por)");
        $t3->math("BC:BD = A\\{_1}:A\\{_2}");
        $t{A}->draw->label("A\\{_1}");
        $t{B}->draw->label("A\\{_2}");
       
        $t{ABC}->grey;
        $t{ADC}->grey;
        $t{ABD}->grey;
        $t3->grey(0);
        $a{alpha1}->remove;
        $a{alpha2}->remove;
        $l{AD}->remove;
    };
    
        # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Similarly, the ratio BC to AB is equal to the ratio AB to BD, ");
        
        $t3->down;
        $t3->math("BC:AC = AC:CD");
        $t{A}->label;
        $t{A}->grey;
        $t{B}->label;
        $t{B}->grey;

        $t{ABC}->normal;
        $t{ADC}->normal;
        $t{ABD}->normal;
        $a{alpha1}->draw;
        $a{alpha2}->draw;
        $l{AD}->remove;
        
        $t3->grey([0..2]);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Thus ".
        "the ratio of BC to CD is equal to the ratio of the figures drawn".
        " on BC and AC");
        $t3->math("BC:CD = A\\{_1}:A\\{_3}");
        $t{A}->label("A\\{_1}");
        $t{C}->label("A\\{_3}");
        $t{C}->draw;
        $t{A}->draw;
        $t{ABC}->grey;
        $t{ADC}->grey;
        $t{ABD}->grey;
        $t3->grey(3);
        $a{alpha1}->remove;
        $a{alpha2}->remove;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Therefore, the ratio of BC to the sum of BD,CD is equal ".
        "to the ratio of the figure on AC to the sum of the figures on AB,AC (V.24)");
        $t3->black(2);
        $t{B}->label("A\\{_2}");
        $t{B}->draw;
        $t3->math("BC:(BD+CD) = A\\{_1}:(A\\{_2}+A\\{_3})");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But BD,CD is equal to BC");
        $t3->math("BC:BC = 1 = A\\{_1}:(A\\{_2}+A\\{_3})");
        
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->down;
        $t1->explain("Thus the figure drawn on BC is equal to the sum of the figures ".
        "drawn on AB and AC");
        $t2->down;
        $t2->down;
        $t2->math("A\\{_1} = A\\{_2} + A\\{_3}");
    };
    
    


    return $steps;

}

sub remove_tmp {
    foreach my $type ( \%l, \%t, \%a, \%p ) {
        foreach my $o ( keys %$type ) {
            if ($o =~ /tmp/) {
                $type->{$o}->remove;
            }
        }
    }
}
sub normal_shit {
    foreach my $type ( \%l, \%t, \%a, \%p ) {
        foreach my $o ( keys %$type ) {
            $type->{$o}->normal;
        }
    }
}
sub grey_shit {
    foreach my $type ( \%l, \%t, \%a, \%p) {
        foreach my $o ( keys %$type ) {
            $type->{$o}->grey;
        }
    }
}


