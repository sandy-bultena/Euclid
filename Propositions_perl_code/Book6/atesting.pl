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
my $title = "In equal circles angles have the same ratio as the ".
"cirucmferences on which they stand, whether they stand at the centres or at ".
"the circumferences";

$pn->title( 33, "", 'VI' );

my $t1      = $pn->text_box( 800, 150, -width => 500 );
my $t4      = $pn->text_box( 800, 150, -width => 500 );
my $t5      = $pn->text_box( 140, 150, -width => 1100 );
my $t3      = $pn->text_box( 100, 450 );
my $t2      = $pn->text_box( 400, 450 );

my $steps = explanation($pn);
push @$steps, sub { Proposition::last_page };
$pn->define_steps($steps);
$pn->copyright();
$pn->go;
my ( %p, %c, %s, %t, %l, %a );

# ============================================================================
# Explanation
# ============================================================================
sub explanation {
    my $r = 300; # radius
    my ($x1,$y1) = ($r+600,$r+150);
    my ($x2,$y2) = (160+3*$r,$r+150);    
    
    my @angles=(40,175,230,55,195,245);
   
    my $colour1 = "#abcdef";
    my $colour3 = "#cdefab";
    my $colour2 = "#efabcd";
    my $colour4 = "#abefcd";
    
    # -------------------------------------------------------------------------
    # In other words
    # -------------------------------------------------------------------------
    push @$steps, sub {
        $c{ABC} = Circle->new($pn,$x1,$y1,$x1+$r,$y1);
    };
    

    


    return $steps;

}

