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
my $title = "If two triangles having two sides proportional to two sides be ".
"placed together at one angle so that their corresponding sides are also ".
"parallel, the remaining sides of the triangle will be in a straight line";

$pn->title( 32, $title, 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 500 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps;
push @$steps, Proposition::title_page6($pn);
push @$steps, Proposition::toc6( $pn, 32 );
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
    my $xs   = 80;
    my $dx1  = 160; # horizontal length B to A
    my $dy1  = 100; # vertical length B to A
    my $dx2 = 120; # horizontal length B to C
    my $scale = 1.5; # proportion of BC to CE
 
    
    my @B = ( $xs, $yb );
    my @A = ( $xs+$dx1, $yb-$dy1 );
    my @C = ( $xs+$dx2,$yb);
    
    my @E = ($C[0]+$dx2*$scale,$C[1]);
    my @D = ($C[0]+$dx1*$scale,$yb-$dy1*$scale);
    
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
        $t1->explain("Start with two triangles, where the ratio AB to AC equals the ratio CD to DE");
        $t1->explain("and AB is parallel to DC and AC is parallel to DE");
        $p{A} = Point->new( $pn, @A )->label( "A", "top" );
        $p{B} = Point->new( $pn, @B )->label( "B", "bottomleft" );
        $p{C} = Point->new( $pn, @C )->label( "C", "bottom" );
        $p{E} = Point->new( $pn, @E )->label( "E", "bottom");
        $p{D} = Point->new( $pn, @D )->label( "D", "topright");
        $t{ABC} = Triangle->join($p{A},$p{B},$p{C});
        $t{CDE} = Triangle->join($p{C},$p{D},$p{E});
        
        $t3->math("AB:AC = CD:DE");
        $t3->math("AB \\{parallel} DC");
        $t3->math("AC \\{parallel} DE");
    };
    
    push @$steps, sub {
        $t1->explain("The lines BC, CE form a straight line");        
    };
    
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->down;
        $t1->title("Proof");
        $t1->explain("Since AB is parallel to DC, the alternate angles BAC, ACD are equal (I.29)");
        $l{AB} = Line->join($p{A},$p{B})->dash;
        $l{CD} = Line->join($p{C},$p{D})->dash;
        $l{AC} = Line->join($p{A},$p{C});
        $a{BAC} = Angle->new($pn,$l{AB},$l{AC})->label("\\{alpha}");
        $a{ACD} = Angle->new($pn,$l{CD},$l{AC})->label("\\{alpha}",30);
        
        $t{ABC}->grey;
        $t{CDE}->grey;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Similarly, the angle CDE is equal to the angle ACD");
        $l{AB}->grey;;
        $l{CD}->undash;
        $l{AC}->dash;
        $l{DE} = Line->join($p{D},$p{E})->dash;
        $a{CDE} = Angle->new($pn,$l{CD},$l{DE})->label("\\{alpha}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t{ABC}->normal;
        $t{CDE}->normal;

        $t1->explain("Since ABC, DCE have equal angles at A and D, and the ".
        "sides about the equal angle are proportional, ABC is equiangular to DCE (VI.6)");
        $l{BC} = Line->join($p{B},$p{C});
        $l{CE} = Line->join($p{C},$p{E});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Therefore the angles ABC equals DCE");
        $a{ABC} = Angle->new($pn,$l{BC},$l{AB})->label("\\{theta}");
        $a{DCE} = Angle->new($pn,$l{CE},$l{CD})->label("\\{theta}",20);
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The angle ACE equals the sum of ABC and BAC");
        $a{ACE} = Angle->new($pn,$l{CE},$l{AC})->label("\\{beta}",60);
        $t3->math("\\{beta} = \\{alpha} + \\{theta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Let the angle ACB be added to each;");
        $t1->explain("Therefore the angles ACE, ACB equal BAC, ACB, CBA");
        $a{ACB} = Angle->new($pn,$l{AC},$l{BC})->label("\\{gamma}",10);
        $a{ACD}->grey;
        $a{DCE}->grey;
        $t3->math("\\{gamma} + \\{beta} = \\{gamma} + \\{alpha} + \\{theta}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("But the sum of the angles BAC, ABC, ACB is equal ".
        "to two right angles (I.32)");
        $t3->math("\\{alpha} + \\{theta} + \\{gamma} = 2\\{right}");
        $t3->down;
        $t3->math("\\{therefore} \\{gamma} + \\{beta} = 2\\{right}"); 
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Given a straight line AC, if two straight lines BC,CE (not lying ".
        "on the same side) have the sum of the angles ACE and ACB equal to two ".
        "right angles, the lines BC and CE form a straight line (I.14)");
        $t{ABC}->grey;
        $t{CDE}->grey;
        $l{AB}->grey;
        $l{CD}->grey;
        $l{AC}->undash;
        $l{DE}->grey;
        $a{ABC}->grey;
        $a{BAC}->grey;
        $a{CDE}->grey;
          
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


