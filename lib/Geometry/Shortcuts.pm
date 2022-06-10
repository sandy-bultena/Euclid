#!/usr/bin/perl
use strict;
use warnings;

=head1 NAME

just a set of "helper" functions to make useful functions;

=head1 SYNOPSIS

=head2 Subroutines

=cut

=head2 make_make_lines ( letters )

returns function make_lines

=cut
package Shortcuts;

 use Exporter 'import';
    # set the version for version checking
    our $VERSION     = '1.00';
    # Functions and variables which are exported by default
    our @EXPORT      = qw(make_some_line_subs);


# -------------------------------------------------------------------------------
# -------------------------------------------------------------------------------

{
    my $x     = 0;
    my $y     = 0;
    my $xorig = 0;

    sub make_some_line_subs {
        my $package = "main";
        my $pn   = shift;
        my $ds   = shift;
        my $unit = shift;
        my $p    = shift;
        my $l    = shift;
        
        my $make_lines_sub = sub {
            my @letters = @_;
            foreach my $e (@letters) {
                no strict;
                my $label = substr( $e, 0, 1 );
                if ( $p->{$e} ) { $p->{$e}->remove; }
                if ( $l->{$e} ) { $l->{$e}->remove; }
                my $var=$package."::".$e;
               # $p->{$e} =
               #   Point->new( $pn, @$var[ 0, 1 ] )->label( $label, "left" );
                $l->{$e} = Line->new( $pn, @$var )->label_edge($label);
            }
        };

        my $make_coords_sub = sub {
            die ("Must have even number of inputs",
                join(", ",@_),"\n") if scalar(@_)%2;
            my %p = @_;
            $y     = $p{-yorig} if $p{-yorig};
            $x     = $p{-xorig} if $p{-xorig};
            $xorig = $p{-xorig} if $p{-xorig};
            $y     = $y + $p{-yskip}* $ds   if $p{-yskip};
            my $after = $p{-after};
            my @afters;
            @afters = ($after) if $after;
            @afters = (@$after) if $after && ref $after;
                
            if (@afters) {
            $x = $xorig;
                foreach my $a (@afters) {
                    $x = $x + $a * $unit + 2 * $ds;
                }
            }
            
            
            my $l = $p{-length};
            my @coords = ( $x, $y, $x + $l * $unit, $y );
            $x = $x + $l * $unit + 2 * $ds;
            return @coords;
        };
        
        my $make_xy_sub = sub {
            return ( $x, $y );
        };
        return ( $make_lines_sub, $make_coords_sub, $make_xy_sub );
    }
}

1;
