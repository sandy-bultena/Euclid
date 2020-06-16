#!/usr/bin/perl
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

my $pn = PropositionCanvas->new;
Proposition::init($pn);

# ============================================================================
# Definitions
# ============================================================================
 my $title = '';

$pn->title( 0, $title, 'II' );
my $steps;
    push @$steps, Proposition::toc2($pn);
$pn->define_steps($steps);
$pn->copyright();
$pn->go;

