#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/";
use Geometry::Canvas::PropositionCanvas;
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
Proposition::set_animation(0);

# ============================================================================
# Definitions
# ============================================================================
my $title =
  "Colour Test";

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 500, 430 );
$pn->title(1,$title);

my $steps;
explanation( $pn );
$pn->define_steps($steps);
$pn->go;



# ============================================================================
sub explanation {

    my ( %l, %p, %c );

    # -------------------------------------------------------------------------

    push @$steps, sub {
        my @c = ($pale_yellow, $pale_pink, $pink, $tan, $purple, $yellow, $orange,);
        foreach my $i (1..7) {
#            Line->new($pn,$i*100,10,$i*100+90,$i*100+90);
            Square->new($pn,10,$i*100,10,$i*100+90)->fill($c[$i-1]);
        }
    };
    return $steps;

}

