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
my $title = "Given a circle and its centre, draw a square within the circle. "
  . "(6L 7E)";

$pn->title( 7, $title, '1' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $tdot    = $pn->text_box( 800, 150, -width => 500 );
my $tindent = $pn->text_box( 840, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 500 );
my $t3      = $pn->text_box( 500, 300 );
my $t2      = $pn->text_box( 520, 200 );

my $steps = explanation($pn);
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my ( %l, %p, %c, %s, %a );
    my $k = 2;
    my @A = ( 320, 380 );
    my @B = ( 320, 250 );
    my @E = ( 150, 250 );
    my @C = ( 350, 200 );
    my @D = ( 550, 200 );
    my @F = ( 350, 250 );

    my @c = ( 240, 400 );
    my $r = 100;

    push @$steps, sub {
        $c{A} = Circle->new( $pn, @A, @B )->green;
        $p{A} = Point->new( $pn, @A )->green->label( "A", "bottomleft" );
        $p{B} = Point->new( $pn, @B )->green->label( "B", "topleft" );
    };

    # -------------------------------------------------------------------------
    # Steps
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->title("Steps");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e1) Draw a circle with B as the centre, with radius BA");
        $c{B} = Circle->new( $pn, @B, @A );
        my @p = $c{A}->intersect( $c{B} );
        $p{C} = Point->new( $pn, @p[ 0, 1 ] )->label( "C", "left" );
        $p{D} = Point->new( $pn, @p[ 2, 3 ] )->label( "D", "right" );
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e2) Draw a circle with C as the centre, with radius CD");
        my @tmp = $p{C}->coords;
        $c{C} = Circle->new( $pn, @tmp, $p{D}->coords );
        my @p = $c{C}->intersect( $c{A} );
        $p{E} = Point->new( $pn, @p[ 2, 3 ] )->label( "E", "bottom" );
        @p    = $c{C}->intersect( $c{B} );
        $p{F} = Point->new( $pn, @p[ 0, 1 ] )->label( "F", "top" );

    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("The line EF goes through the points A and B");
        $l{ef} = Line->join( $p{E}, $p{F} )->grey;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t4->y( $t1->y );
        $t4->title("Proof");
        $p{F}->grey;
        $p{A}->normal;
        $p{B}->normal;
        $c{C}->grey;
        $c{A}->normal;
        $c{B}->normal;
        $p{E}->grey;
        $l{cab} = Triangle->join( $p{C}, $p{A}, $p{B} )->fill("#abcdef");
        $l{bad} = Triangle->join( $p{B}, $p{A}, $p{D} )->fill("#fedcba");
        $t4->explain("Triangle ABC is an equilateral triangle, and equals BAD");
        $t3->math("\\{triangle}ABC = \\{triangle}BAD");
    };

    push @$steps, sub {
        $t4->explain(
              "Equilateral triangles have angles of 60 degrees, thus angle CBD "
                . "is equal to 120 degrees" );
        $t3->math("\\{angle}CBD = 120 \\{degrees}");
    };

    push @$steps, sub {
        $c{A}->grey;
        $c{B}->grey;
        $t4->explain("The line BA bisects CD and is perpendicular to CD");
        $t3->math("BA \\{perp} CD");
        $t3->math("CG = GD");
        $l{ab} = Line->join( $p{A}, $p{B} );
        $l{cd} = Line->join( $p{C}, $p{D} );
        $p{G} =
          Point->new( $pn, $l{cd}->intersect( $l{ab} ) )
          ->label( "G", "topright" );
    };

    push @$steps, sub {
        $l{cab}->remove;
        $l{bad}->remove;
        $p{F}->normal;
        $p{B}->grey;
        $l{ab}->grey;
        $l{cgf} = Triangle->join( $p{C}, $p{G}, $p{F} )->fill("#abcdef");
        $l{gdf} = Triangle->join( $p{G}, $p{D}, $p{F} )->fill("#fedcba");
        $t4->explain(
"Extend AB to F.  CGF and GDF are equal (SAS - CG equals GD, right angle, GF common)"
        );
        $t3->math("\\{triangle}CGF = \\{triangle}GDF");
    };

    push @$steps, sub {
        $t4->explain("Therefore FD equals CF");
        $t3->math("FD = CF");
    };

    push @$steps, sub {
        $t4->explain(
                  "Angles from a circumference are half those from the centre, "
                    . "so CFD is 60 degrees" );
        $t3->math("\\{angle}CFD = 60 \\{degrees}");
        $l{cgf}->remove;
        $l{gdf}->remove;
        $c{B}->normal;
        $p{B}->normal;
        $l{cf} = Line->join( $p{C}, $p{F} );
        $l{bd} = Line->join( $p{B}, $p{D} );
        $l{fd} = Line->join( $p{F}, $p{D} );
        $l{cb} = Line->join( $p{C}, $p{B} );
        $l{cd}->grey;
        $p{G}->grey;
        $p{A}->grey;
        $a{cfd} = Angle->new( $pn, $l{cf}, $l{fd} )->label("60");
        $a{cbd} = Angle->new( $pn, $l{cb}, $l{bd} )->label("120");
    };

    push @$steps, sub {
        $t4->explain(
                    "CF and FD are equal, so the angles FCD and FDC are equal, "
                      . "making them also 60 degrees" );
        $a{cbd}->remove;
        $l{cb}->remove;
        $l{bd}->remove;
        $l{cd}->normal;
        $a{fcd} = Angle->new( $pn, $l{cd}, $l{cf} )->label("60");
        $a{fdc} = Angle->new( $pn, $l{fd}, $l{cd} )->label("60");
        $t3->math("\\{angle}FDC = \\{angle}FDC = 60 \\{degrees}");
    };

    push @$steps, sub {
        $t4->explain("FCD is an equilateral triangle");
        $t3->math("FC = CD = DF");

    };

    push @$steps, sub {
        $c{C}->normal;
        $c{B}->grey;
        $c{A}->grey;
        $p{A}->grey;
        $p{B}->grey;
        $p{E}->grey;
        $a{cfd}->remove;
        $a{fcd}->remove;
        $a{cbd}->remove;
        $a{fdc}->remove;
        $l{cd}->label( "a", "bottom" );
        $l{cf}->label( "a", "left" );
        $l{fd}->remove;

        $t4->explain(
            "A circle, with centre C, and radius CD, will intercept the point F"
        );

    };

    push @$steps, sub {
        $t4->explain("Similarly with point E");
        $p{E}->normal;
    };
    
    # -------------------------------------------------------------------------
    # Steps
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        $t3->erase;
        $l{ef} = Line->join( $p{E}, $p{F} )->grey;
        $l{cf}->remove;
        $l{cd}->remove;
        $c{A}->green;
        $c{B}->normal;
        $p{A}->normal;
        $p{B}->normal;
        $p{G}->remove;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e3) Draw a line through AC, intersecting the larger ".
        "circle at H");
        $l{db} = Line->join($p{A},$p{C})->extend(300)->prepend(300);
        my @p = $c{C}->intersect($l{db});
        $p{H} = Point->new($pn,@p[2,3])->label("H","top");
        $p{K} = Point->new($pn,@p[0,1])->label("K","right");
        $l{hk} = Line->join($p{H},$p{K});
        $l{db}->remove;
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e4) Draw a line from H to E");
        $l{he} = Line->join($p{H},$p{E});
        my @p = $c{A}->intersect($l{he});
        $p{J} = Point->new($pn,@p[2,3])->label("J","bottomleft");        
    };
    
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e5) Draw a line from E through K");
        $t1->explain("Angle HEK is a right angle");
        $l{ek} = Line->join($p{E},$p{K})->extend(300);
        my @p=$c{A}->intersect($l{ek});
        $p{L} = Point->new($pn,@p[0,1])->label("L","right");
        $l{ek}->remove;
        $l{ek} = Line->join($p{E},$p{K});
        $l{el} = Line->join($p{E},$p{L})->dash();
        $t3->math("\\{angle}HEK = 90 \\{degrees}");
        
    };
    
    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t4->y( $t1->y );
        $t4->title("Proof");
        foreach my $pt ("A".."Z") {
            $p{$pt}->grey if $p{$pt};
        }
        foreach my $pt (qw(H E K C)) {
            $p{$pt}->normal;
        }
        $c{C}->normal;
        $c{A}->grey;
        $c{B}->grey;
        $t4->explain("A triangle in a semi circle is always a right angle triangle");
        $a{HEK} = Angle->new($pn,$l{ek},$l{he});
    };

    # -------------------------------------------------------------------------
    # Steps
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
        foreach my $pt ("A".."Z") {
            $p{$pt}->normal if $p{$pt};
        }
        $p{G}->remove;
        $c{A}->green;
        $c{B}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("(e6) Draw line from J to B");
        $t1->explain("(e7) Draw line from B to L");
        $l{jb} = Line->join($p{J},$p{B});
        $l{bl} = Line->join($p{B},$p{L});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->explain("Angle BJE is a right angle, angle BLE is a right angle");
        $t3->math("\\{angle}BJE = 90 \\{degrees}");
        $t3->math("\\{angle}BLE = 90 \\{degrees}");
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t4->y( $t1->y );
        $t4->title("Proof");
        foreach my $pt ("A".."Z") {
            $p{$pt}->grey if $p{$pt};
        }
        foreach my $pt (qw(B J E L A)) {
            $p{$pt}->normal;
        }
        $c{C}->grey;
        $c{A}->green;
        $c{B}->grey;
        $t4->explain("A triangle in a semi circle is always a right angle triangle");
        $l{ej} = Line->join($p{E},$p{J});
        $a{BJE} = Angle->new($pn,$l{ej},$l{jb});
        $a{ELB} = Angle->new($pn,$l{bl},$l{el});
        $l{he}->remove;
        $l{hk}->remove;
        $l{be} = Line->join($p{B},$p{E});
        $a{HEK}->grey;
    };

    # -------------------------------------------------------------------------
    # Steps
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->erase;
    };

    # -------------------------------------------------------------------------
    # Proof
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t1->erase;
        $t1->explain("BJEL is a square");
        $t1->down;
        $t4->y( $t1->y );
        $t4->title("Proof");
        $t4->explain("Since three of the angles are right angles, so is the fourth");
        $t3->math("\\{angle}JBL = 90 \\{degrees}");
        $a{JBL} = Angle->new($pn,$l{jb},$l{bl});
        $a{HEK}->normal;
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        foreach my $ll (keys %l) {
            $l{$ll}->remove if $l{$ll};
        }
        foreach my $aa (keys %a) {
            $a{$aa}->remove if $a{$aa};
        }
        $l{CD} = Line->join($p{C},$p{D});
        $l{DE} = Line->join($p{D},$p{E});
        $l{EC} = Line->join($p{E},$p{C});
        $p{E}->normal;
        $p{D}->normal;
        $p{A}->normal;
        $p{C}->normal;
        $t4->explain("As was shown earlier for points FCD, CDE is an equilateral triangle "
        ."and CD is perpendicular to AB");
        $t3->math("CD \\{perp} AB");
        $l{AB} = Line->join($p{A},$p{B});
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Angle DCA and ACE are both half DCE since CA goes through the centre ".
        "of the circle");
        $l{CA} = Line->join($p{C},$p{A});
        $a{dca} = Angle->new($pn,$l{CA},$l{CD})->label("30");
        $a{ace} = Angle->new($pn,$l{EC},$l{CA},-size=>50)->label("30"); 
        $t3->math("DCA = 30 \\{degrees}");
        $t3->math("ACE = 30 \\{degrees}");
    };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Draw a line perpendicular to AB from H to point M");
        $p{H}->normal;
        $l{HM} = $l{AB}->perpendicular($p{H});
        $p{M} = Point->new($pn,$l{HM}->end)->label("M");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("The angle MHK is also 30 degrees, since CD and HK ".
        "are parallel");
        $l{HK} = Line->join($p{H},$p{K});
        $p{K}->normal;
        $a{mhk} = Angle->new($pn,$l{HK},$l{HM})->label("30");
        $t3->math("MHK = 30 \\{degrees}");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("The angle KHE is half KCE");
        $t3->math("KHE = 15 \\{degrees}");
        $l{HE} = Line->join($p{H},$p{E});
        $a{KHE} = Angle->new($pn,$l{HE},$l{HK},-size=>80)->label("15");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("Draw a line perpendicular to BE through J, JE will be at ".
        "45 degrees from this line");
        $l{JL} = Line->join($p{J},$p{L});
        $p{A}->grey;
        $p{L}->grey;
        $l{JE} = Line->join($p{J},$p{E});
        $a{EJL}= Angle->new($pn,$l{JE},$l{JL})->label("45");
        $p{A}->normal->label("A'","topright");
        $t3->math("JA'E = 45 \\{degrees}");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        foreach my $ll (keys %l) {
            $l{$ll}->remove if $l{$ll};
        }
        foreach my $aa (keys %a) {
            $a{$aa}->remove if $a{$aa};
        }
        $l{JA} = Line->join($p{J},$p{A});
        $l{JE} = Line->join($p{J},$p{E});
        $l{AE} = Line->join($p{A},$p{E});
        $a{aje} = Angle->new($pn,$l{JE},$l{JA})->label("45");
        $a{jea} = Angle->new($pn,$l{AE},$l{JE})->label("45");
        $a{jae} = Angle->new($pn,$l{JA},$l{AE});
        $t4->explain("JAE is a right angle triangle, so angle JEA is 45 degrees");
        $t3->math("JEA' = 45 \\{degrees}");
     };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t4->explain("JA'E is an isoceles triangle, so JA' equals A'E, therefore ".
        "A is the centre of the circle");
        $p{A}->label("A","topright");
      };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $l{JB} = Line->join($p{J},$p{B});
        $t4->explain("JL passes through the centre of the circle and is perpendicular to BE");
        $t4->explain("Therefore BJEL is a square");
        $l{BL} = Line->join($p{B},$p{L});
        $l{LE} = Line->join($p{L},$p{E});
        $l{BA} = Line->join($p{B},$p{A});
        $l{JL} = Line->join($p{J},$p{L});
      };

    # -------------------------------------------------------------------------
    push @$steps, sub {
        $t3->erase;
        $t1->erase;
        $t4->erase;
        foreach my $ll (keys %l) {
            $l{$ll}->remove if $l{$ll};
        }
        foreach my $aa (keys %a) {
            $a{$aa}->remove if $a{$aa};
        }
        $p{M}->remove;
        $c{C}->normal;
        $t1->title("Steps");
        $t1->explain("(e1) Draw a circle with B as the centre, with radius BA");
        $t1->explain("(e2) Draw a circle with C as the centre, with radius CD");
        $t1->explain("The line EF goes through the points A and B");
        $l{ef} = Line->join( $p{E}, $p{F} )->grey;

        $t1->explain("(e3) Draw a line through AC, intersecting the larger ".
        "circle at H");
        $l{db} = Line->join($p{A},$p{C})->extend(300)->prepend(300);
        my @p = $c{C}->intersect($l{db});
        $p{H} = Point->new($pn,@p[2,3])->label("H","top");
        $p{K} = Point->new($pn,@p[0,1])->label("K","right");
        $l{hk} = Line->join($p{H},$p{K});
        $l{db}->remove;
        $t1->explain("(e4) Draw a line from H to E");
        $l{he} = Line->join($p{H},$p{E});
        $t1->explain("(e5) Draw a line from E through K");
        $t1->explain("Angle HEK is a right angle");
        $l{ek} = Line->join($p{E},$p{K});
        $l{el} = Line->join($p{E},$p{L})->dash();
        $c{A}->green;
        $c{B}->normal;
        $t1->explain("(e6) Draw line from J to B");
        $t1->explain("(e7) Draw line from B to L");
        $l{jb} = Line->join($p{J},$p{B});
        $l{bl} = Line->join($p{B},$p{L});
        $p{L}->normal;
        $t1->explain("Angle BJE is a right angle, angle BLE is a right angle");
    };
        

    return $steps;

}

