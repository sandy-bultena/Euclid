#!/usr/bin/perl
use strict;
use warnings;

$ENV{EUCLID_AUTO} = 1;
$ENV{EUCLID_CREATE_PDF} = 1;
$ENV{SPELL_CHECK} = 1;

my $dir = shift @ARGV || ".";
opendir(my $dfh, $dir) || die "Cannot open <$dir>\n";

my @props = ();

while (my $file = readdir($dfh)) {
    next unless $file =~ /\.pl/;
    push @props,$file;
} 

foreach my $file (sort @props) {
    print "$dir/$file\n";
    system "perl","$dir/$file";
} 