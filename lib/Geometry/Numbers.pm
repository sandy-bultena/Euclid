#!/usr/bin/perl
use strict;
use warnings;

package Numbers;

our $NO_COMPLAIN = 1;

=head1 NAME

Numbers - a bunch of methods to simplify the numbers calculations

=head1 SYNOPSIS

    use Geometry::Geometry;


=head1 CLASS METHODS

=cut

# ============================================================================
# new
# ============================================================================

=head2 new ( [n1, [n2, [n3,..]]] )  # any number of positive integer inputs

B<Parameters>

B<Returns>

=over

=item * Numbers object

=back

=cut

# -----------------------------------------------------------------------------
sub new {
    my $class = shift;
    my $self = { -numbers => [] };
    foreach my $i (@_) {
        die "invalid input ($i) into Numbers\n" unless $i =~ /^\d+$/;
        push @{ $self->{-numbers} }, $i;
    }
    bless $self;
    return $self;
}

sub size {
    my $self = shift;
    return scalar( @{ $self->{-numbers} } );
}

sub item {
    my $self = shift;
    my $i    = shift;
    if ( $i < $self->size ) {
        return $self->{-numbers}[$i];
    }
    return;
}

sub array {
    my $self = shift;
    return @{ $self->{-numbers} };
}

# ============================================================================
# gcd
# ============================================================================
# Note, this is a terribly inefficient algorithm  :)

=head2 gcd() 

B<Returns>

=over

=item * greatest common divisor (VII.1)

=back

=cut

# -----------------------------------------------------------------------------
sub gcd {
    my $self = shift;
    return $self->item(0) if $self->size < 2;
    my @numbers = $self->array;

    # recursivley find gcd, for each pair
    my $first          = shift @numbers;
    my $common_measure = $first;
    while ( @numbers > 0 ) {
        my $second  = $numbers[0];
        my $larger  = $first > $second ? $first : $second;
        my $smaller = $first < $second ? $first : $second;

        while ( $common_measure > 1 && $larger != $smaller && $smaller > 0 ) {
            $common_measure = $smaller;
            my $tmp = $larger % $smaller;
            $larger  = $smaller;
            $smaller = $tmp;
        }
        $first = $common_measure;
        shift @numbers;
    }
    return $common_measure;
}

# ============================================================================
# isprime
# ============================================================================

=head2 isprime() 

B<Returns>

=over

=item * are the numbers prime to one another (VII.1)

=back

=cut

# -----------------------------------------------------------------------------
sub isprime {
    my $self = shift;
    return 0 if $self->gcd() != 1;
    return 1;
}

# ============================================================================
# least_ratio
# ============================================================================

=head2 least_ratio() 

B<Returns>

=over

=item * least ratio (VII.33)

=back

=cut

# -----------------------------------------------------------------------------
sub least_ratio {
    my $self = shift;
    return $self->item(0) if $self->size < 2;

    my @numbers = $self->array;

    # if isprime, then it is the array itself
    return @numbers if $self->isprime;

    # find the gcd for set
    my $gcd = $self->gcd;
    my @return = map { $_ / $gcd } @numbers;
    return @return;
}

# ============================================================================
# lcm
# ============================================================================

=head2 lcm() 

B<Returns>

=over

=item * least common multiple (VII.34)

=back

=cut

# -----------------------------------------------------------------------------
sub lcm {
    my $self = shift;
    return $self->item(0) if $self->size < 2;

    my @numbers = $self->array;

    # recursivley find lcm, for each pair
    my $lcm = shift @numbers;
    while ( @numbers > 0 ) {
        my $second = $numbers[0];
        if ( Numbers->new( $lcm, $second )->isprime ) {
            $lcm = $lcm * $second;
        }
        else {
            my @tmp = Numbers->new( $lcm, $second )->least_ratio;
            $lcm = $tmp[1] * $lcm;
        }
        shift @numbers;
    }
    return $lcm;
}

# ============================================================================
# find_continued_proportion
# ============================================================================

=head2 find_continued_proportion( size_of_list )

B<Returns>

=over

=item * array of least numbers in continuous proportion to 1st two numbers
in self. (VIII.2)

=back

=cut

# -----------------------------------------------------------------------------
sub find_continued_proportion {
    my $self   = shift;
    my $length = shift;    # size of list to return

    return $self->item(0) if $self->size < 2 || $length < 2;

    my @numbers = $self->array;
    my $a       = $self->item(0);
    my $b       = $self->item(1);

    my @return;
    return ( $a, $b ) if $length == 2;

    my $n = $a**( $length - 1 );
    push @return, $n;
    foreach my $i ( 2 .. $length ) {
        $n = $n * $b / $a;
        push @return, $n;
    }

    return @return;
}

# ============================================================================
# find median(s) of similar (plane), or (solid) numbers
# ============================================================================

=head2 find_median_plane(  )

B<Returns>

=over

=item * array of four numbers where the 1st two are the sides of the 
first plane number, and 2nd two are the sides of the second plane number. 
TWO PLANE NUMBERS MUST BE SIMILAR
(VIII.18)

=back

=cut

# -----------------------------------------------------------------------------
sub find_median_plane {
    my $self = shift;
    die("find_median_plane: Not enough sides for two plane numbers")
      unless $self->size == 4;
    die("find_median_plane: Plane numbers are not similar")
      unless $self->item(0) / $self->item(1) == $self->item(2) / $self->item(3);

    return $self->item(1) * $self->item(2);
}

# ============================================================================
# find plane numbers from 3 numbers proportional to each other
# ============================================================================

=head2 find_plane_from_proportional(1|2|3)

B<Returns>

=over

=item * Given three numbers in proportion, find the two sides of 
each plane number

Must specify which number to find the sides

(VIII.20)

=back

=cut

# -----------------------------------------------------------------------------
sub find_plane_from_proportional {
    my $self  = shift;
    my $which = shift;

    # verify inputs
    die("Must specify which number you want the sides for (1|2|3)")
      unless $which == 1 || $which == 2 || $which == 3;
    die("find_plane_from_proportional: Must specify 3 numbers only")
      unless $self->size == 3;
    die("find_median_plane: Plane numbers are not similar")
      unless $self->item(0) / $self->item(1) == $self->item(1) / $self->item(2);

    # calculate sides
    my ( $A, $C, $B ) = ( $self->item(0), $self->item(1), $self->item(2) );
    my ( $D, $E ) = Numbers->new( $A, $C )->least_ratio();
    my $F = $A / $D;
    my $G = $C / $D;
    
    # return appropriate sides
    if ( $which == 1 ) {
        return ( $F, $D ) if $F < $D;
        return ( $D, $F );
    }
    elsif ( $which == 2 ) {
        return ( $D, $G ) if $D < $G;
        return ( $G, $D );
    }
    else {
        return ( $G, $E ) if $G < $E;
        return ( $E, $G )
    }

}

if (0) {
    print "2:3 continued proportion",
      Numbers->new( 2, 3 )->find_continued_proportion(5), "\n";
    print "2,6 gcd? ",    Numbers->new( 2,   6 )->gcd(),  "\n";
    print "1,6 gcd? ",    Numbers->new( 1,   6 )->gcd(),  "\n";
    print "3,6 gcd? ",    Numbers->new( 3,   6 )->gcd(),  "\n";
    print "4,10 gcd? ",   Numbers->new( 4,   10 )->gcd(), "\n";
    print "145,63 gcd? ", Numbers->new( 145, 63 )->gcd(), "\n";
    print "2,6,3 gcd? ",   Numbers->new( 2,  6, 3 )->gcd(),  "\n";
    print "12,6,18 gcd? ", Numbers->new( 12, 6, 18 )->gcd(), "\n";
    print "12,6,21 gcd? ", Numbers->new( 12, 6, 21 )->gcd(), "\n";
    print "\n";
    print "2,6 least_ratio? ",
      join( ", ", Numbers->new( 2, 6 )->least_ratio() ), "\n";
    print "1,6 least_ratio? ",
      join( ", ", Numbers->new( 1, 6 )->least_ratio() ), "\n";
    print "3,6 least_ratio? ",
      join( ", ", Numbers->new( 3, 6 )->least_ratio() ), "\n";
    print "4,10 least_ratio? ",
      join( ", ", Numbers->new( 4, 10 )->least_ratio() ), "\n";
    print "145,63 least_ratio? ",
      join( ", ", Numbers->new( 145, 63 )->least_ratio() ), "\n";
    print "2,6,3 least_ratio? ",
      join( ", ", Numbers->new( 2, 6, 3 )->least_ratio() ), "\n";
    print "12,6,18 least_ratio? ",
      join( ", ", Numbers->new( 12, 6, 18 )->least_ratio() ), "\n";
    print "12,6,21 least_ratio? ",
      join( ", ", Numbers->new( 12, 6, 21 )->least_ratio() ), "\n";
    print "\n";
    print "2,6 lcm? ",    Numbers->new( 2,   6 )->lcm(),  "\n";
    print "1,6 lcm? ",    Numbers->new( 1,   6 )->lcm(),  "\n";
    print "3,6 lcm? ",    Numbers->new( 3,   6 )->lcm(),  "\n";
    print "4,10 lcm? ",   Numbers->new( 4,   10 )->lcm(), "\n";
    print "145,63 lcm? ", Numbers->new( 145, 63 )->lcm(), "\n";
    print "2,6,3 lcm? ",   Numbers->new( 2,  6, 3 )->lcm(),  "\n";
    print "12,6,18 lcm? ", Numbers->new( 12, 6, 18 )->lcm(), "\n";
    print "12,6,21 lcm? ", Numbers->new( 12, 6, 21 )->lcm(), "\n";
}

1;

