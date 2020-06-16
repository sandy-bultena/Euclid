#!/usr/bin/perl
use strict;
use warnings;
use Tk;
use Geometry::CalculatePoints;
use Test::More tests => 9;

my @pts = ( 0, 0, 50, 50 );
my $h   = sqrt( 50**2 + 50**2 );
my $h2  = sqrt( $h**2 - ( 0.5 * $h )**2 );
my @results;
my @tmp;
my @tmp2;

@results = CalculatePoints->square(@pts);
is_deeply( \@results, [ 50, -50, 0, 0, 50, 50, 100, 0 ], 'square 1' );
@results = CalculatePoints->square( reverse @pts );
is_deeply( \@results, [ 0, 100, 50, 50, 0, 0, -50, 50 ], 'square 2' );

@results = CalculatePoints->right_triangle( @pts, $h );
is_deeply( \@results, [ 0, 0, 50, 50, 100, 0 ], 'right triangle 1' );
@results = CalculatePoints->right_triangle( reverse(@pts), $h );
is_deeply( \@results, [ 50, 50, 0, 0, -50, 50 ], 'right triangle 2' );

@tmp = CalculatePoints->right_triangle( 0, 0, 25, 25, $h2 );
@results = CalculatePoints->equilateral_triangle(@pts);
is_deeply( \@results, [ 0, 0, 50, 50, $tmp[4], $tmp[5] ], 'equilateral triangle 1' );
@tmp = CalculatePoints->right_triangle( 50, 50, 25, 25, $h2 );
@results = CalculatePoints->equilateral_triangle( reverse(@pts) );
is_deeply( \@results, [ 50, 50, 0, 0, $tmp[4], $tmp[5] ], 'equilateral triangle 2' );

@tmp  = CalculatePoints->right_triangle( @pts,          $h );
@tmp2 = CalculatePoints->right_triangle( reverse(@pts), $h );
@results =
  CalculatePoints->parallelogram( @tmp[ 0 .. 1 ], @tmp2[ 4 .. 5 ], @tmp[ 2 .. 3 ] );
is_deeply( \@results, [ @tmp[ 0 .. 1 ], @tmp2[ 4 .. 5 ], @tmp[ 2 .. 3 ], @tmp[ 4 .. 5 ] ],
           'parallelogram' );

@tmp = CalculatePoints->right_triangle( 0, 0, 25, 25, $h2 );
@results = CalculatePoints->isosceles_triangle( 10, 10, 40, 40, $h2 );
is_deeply( \@results, [ 10, 10, 40, 40, $tmp[4], $tmp[5] ], 'isosceles triangle 1' );
@tmp = CalculatePoints->right_triangle( 50, 50, 25, 25, $h2 );
@results = CalculatePoints->isosceles_triangle( 40, 40, 10, 10, $h2 );
is_deeply( \@results, [ 40, 40, 10, 10, $tmp[4], $tmp[5] ], 'isosceles triangle 2' );

