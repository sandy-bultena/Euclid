#!/usr/bin/perl
use strict;
use warnings;

package Validate;
#use Tk;
our $DEBUG_MODE                 = 1;
our $NO_COMPLAIN                = 1;
our $VALIDATE_DIE               = 0;
our $VALIDATE_SUPRRESS_WARNINGS = 0;
our $QUIET_MODE                 = 0;
use Data::Dumper;

my $cn;

my $object = sub {
    my $object = shift;
    return sub {
        my $input = shift;
        return 1 unless ( $input && ref($input) && $input->isa($object) );
        return;
    };
};

my $ref = sub {
    my $object = shift;
    return sub {
        my $input = shift;
        return 1 unless ( $input && ref($input) && ref($input) eq $object );
        return;
    };
};

my $line_circle = sub {
    my $input = shift;
    return 1
      unless (    $input
               && ref($input)
               && ( $input->isa('VirtualCircle') || $input->isa('VirtualLine') ) );
    return;
};

my $canvas = sub {
    my $input = shift;
    return 1 unless ( $input && ref($input) && $input->can('createText') );
    return;
};

my $number = sub {
    my $type = shift;
    my $sign = shift;
    return sub {
        my $input = shift;
        return 1
          unless (    $input =~ /^\s*[+-]?\d*\.?\d*(e[+-]\d+)?\s*$/
                   && $input =~ /\d/ );
        if ($sign) {
            return 1
              unless ( $input >= 0 && $sign eq 'positive' )
              || ( $input <= 0 && $sign eq 'negative' );
        }
        return;
    };
};
my $colour = sub {
    my $input = shift;
    if ( $input =~ /^\#/ ) {
        return 1 unless $input =~ /^\#[0-9A-Fa-f]{6}$/;
    }
    return;
};
my $text = sub { return };
my $side = sub {
    my $input = shift;
    return 1 unless $input =~ /positive|negative/i;
    return;
};
my $where = sub {
    my $input = shift;
    return 1
      unless $input =~ /^(|left|right|top|bottom|topright|topleft|bottomleft|bottomright|exactly)$/;
    return;
};

my %rules = (
              'Line'       => $object->('VirtualLine'),
              'Polygon'    => $object->('Polygon'),
              'Circle'     => $object->('VirtualCircle'),
              'Point'      => $object->('Point'),
              'Angle'      => $object->('Angle'),
              'canvas'     => $canvas,
              'LineCircle' => $line_circle,
              'coord'      => $number->('coord'),
              'float'      => $number->('float'),
              'number'     => $number->('number'),
              'colour'     => $colour,
              'text'       => $text,
              'speed'      => $number->('speed'),
              'big'        => $number->('big'),
              'side'       => $side,
              'angle'      => $number->('angle'),
              'where'      => $where,
              'dir'        => $side,
              'array'      => $ref->('ARRAY'),
              'hash'       => $ref->('HASH'),
              'radius'     => $number->( 'number', 'positive' ),
              'dash'       => $number->('dash'),
            );

=head1 NAME

Validate - Validates the inputs used for EuclidGeometry package

=head SYNOPSIS

=cut

sub Inputs {
    my @c       = caller();
    my @inputs  = @{ +shift };
    my @rules   = @{ +shift };
    my $orules  = shift || [];
    my $options = shift || {};
    my $error   = "";
    my $num     = 0;

    my @info   = caller(1);
    my $caller = $info[3];
    my @ok;

    my $bad_inputs = 0;

    # ------------------------------------------------------------------------
    # go through all the mandatory rules
    # ------------------------------------------------------------------------
    while (@rules) {
        my $input = shift @inputs;
        my $rule  = shift @rules;
        $num++;
        my $error;
        push @ok, $rule, $input;

        if ( defined $input ) {
            if ( exists $rules{$rule} ) {
                $error = $rules{$rule}->($input);
            }
            else {
                $error = "Rule '$rule' not defined!";
            }
        }
        else {
            $error = "Parameter $num ($rule) must be defined";
        }

        error_trap( $caller, $error, \@ok ) if $error;

        if ( !$cn && $rule eq 'canvas' ) {
            $cn = $input;
        }
        $bad_inputs++ if $error;
    }

    # optional stuff
    while ( @$orules && @inputs ) {
        my $input = shift @inputs;
        my $rule  = shift @$orules;
        $num++;
        push @ok, $rule, $input;

        my $error;
        if ( defined $input ) {
            if ( exists $rules{$rule} ) {
                $error = $rules{$rule}->($input);
            }
            else {
                $error = "Rule '$rule' not defined!";
            }
            error_trap( $caller, $error, \@ok ) if $error;
        }
        $bad_inputs++ if $error;

    }

    # hash of options
    if (@inputs) {
        my %inputs;
        eval { %inputs = @inputs };
        foreach my $opt ( keys %inputs ) {

            # option not valid
            unless ( exists $options->{$opt} ) {
                $error = "'$opt' invalid option";
            }

            # option valid, check value
            if ( exists $options->{$opt} ) {
                $error = $rules{ $options->{$opt} }->( $inputs{$opt} );
                $error = "option '$opt': " . $error if $error;
            }
            error_trap( $caller, $error, \@ok ) if $error;
        }
        $bad_inputs++ if $error;
    }

    return 0 if $bad_inputs;
    return 1;

}

sub error_trap {
    my $caller   = shift;
    my $error    = shift;
    my $ok       = shift || [];
    my $num      = 0;
    my $preamble = '';
    no warnings;
    while (@$ok) {
        $num++;
        my $type  = shift @$ok;
        my $input = shift @$ok;
        $preamble .= "$num\t$type\t'$input'\n";
    }
    no warnings;
    no strict;
    complain("Invalid Parameters passed to $caller:\n$preamble\n$error\nStack dump:");
}

sub complain {
    my $msg = shift || "";
    no strict;
    my @info  = caller(0);
    my $where = $info[3];
    if ( $where =~ /Validate::complain/ ) {
        @info  = caller(1);
        $where = $info[3];
    }

    my $stuff = "";

    $stuff .= "\n\nError from $where\n";
    $stuff .= $msg;
    $stuff .= "\n";
    foreach my $i ( 1 .. 20 ) {
        my @info = caller($i);
        last unless @info;
        my $package = $info[0];
        my $str     = "$package" . "::NO_COMPLAIN";
        next if ${$str} && !$DEBUG_MODE;
        next if $info[1] =~ /Tk\.pm/;

        $stuff .= "  line:" . sprintf( "%5d ", $info[2] ) . $info[1] . "\n";
    }
    $stuff .= "\n";

    unless ($QUIET_MODE) {
        if ($cn) {
            print $stuff unless $VALIDATE_SUPRRESS_WARNINGS;
            $cn->toplevel->messageBox( -message => $stuff );
            $cn->toplevel->exit() if $VALIDATE_DIE;
        }
        else {
            print $stuff unless $VALIDATE_SUPRRESS_WARNINGS;
            die("\n") if $VALIDATE_DIE;
        }
    }

}

sub moan {
    my $msg = shift || "";
    no strict;
    my @info  = caller(0);
    my $where = $info[3];

    my $stuff = "";

    $stuff .= "\n\nWarning from $where\n";
    $stuff .= $msg;
    $stuff .= "\n";
    foreach my $i ( 1 .. 20 ) {
        my @info = caller($i);
        last unless @info;
        my $package = $info[0];
        my $str     = "$package" . "::NO_COMPLAIN";
        next if ${$str} && !$DEBUG_MODE;
        next if $info[1] =~ /Tk\.pm/;

        $stuff .= "  line:" . sprintf( "%5d ", $info[2] ) . $info[1] . "\n";
    }
    $stuff .= "\n";

    if ($cn) {
        $cn->toplevel->messageBox( -message => $stuff );
        print $stuff;
    }
    else {
        print $stuff;
    }

}

=head1 AUTHOR

Sandy Bultena

=head1 COPYRIGHT

This module is copyright (c) 2014 Sandy Bultena. All rights reserved.

This library is free software; you may redistribute and/or modify it under the same terms as Perl itself.

=cut

1;
