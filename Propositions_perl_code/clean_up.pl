#!/usr/bin/perl
use strict;
use warnings;

while ( my $file = shift @ARGV ) {
    next unless $file =~ /\.p[lm]$/;

    open my $fh, "<", $file or next;
    my @f = <$fh>;
    close $fh;

    unless (-e $file . ".old") {
    open $fh, ">", $file . ".old" or next;
    print $fh @f;
    close $fh;
    }

    open $fh, ">", $file or next;
    my $index      = "";
    my $text_flag  = 0;
    my $text       = "";
    my $prelim     = "";
    foreach my $l (@f) {
        if ($l =~ /^\s*$/) {
            print $fh $l;
            next;
        }
        if ($l =~ /^\s*#/) {
            print $fh $l;
            next;
        }
        
        if ( $l =~ /explain|math|title\(/ ) {
            $text_flag = 1;
            $index     = "";
            if ( $l =~ /^(\s*)(.*?)\"/ ) {
                $index  = $1;
                $prelim = $2;
            }
            $text = "";
        }
        if ($text_flag) {
            if ($l =~ /"(.*)"/) {
                $text = $text . $1
            }

            if ( $l =~ /;/ ) {
                $text_flag = 0;
                my $len = length($index.$prelim.'"');
                print $fh $index,$prelim,'"';
                print $index,$prelim,'"';
                my @words = split /(\s+)/,$text;
                
                foreach my $word (@words) {
                    $len = $len + length($word);
                    if ($len < 75) {
                        print $fh $word;
                        print  $word;
                    } 
                    else {
                        if ($word =~ /\s+/) {
                            print $fh $word,'"',"\n";
                            print $fh $index,"  . ",'"';
                            print  $word,'"',"\n";
                            print  $index,"  . ",'"';
                            $len = length($index."  . ".'"');
                        }
                        else {
                            print $fh '"',"\n";
                            print $fh $index,"  . ",'"',$word;
                            print  '"',"\n";
                            print  $index,"  . ",'"',$word;
                            $len = length($index."  . ".'"'.$word);
                        }
                    }
                }
                print $fh "\");\n";
                print "\");\n";
                
                
                
            }
        }
        else {
            print $fh $l;
        }
    }
}
