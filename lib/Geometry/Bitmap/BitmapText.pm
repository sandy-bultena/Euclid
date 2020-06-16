#!/usr/bin/perl
use strict;
use warnings;

package BitmapText;
my $read_font;
my %fonts;
use Time::HiRes qw(usleep);
use Carp;

our $WriteSpeed = 30000;
our $Notice     = "#ddddff";

# ============================================================================
# new
# ============================================================================
sub new {
    my $class = shift;
    my $cn    = shift;
    my $x     = shift;
    my $y     = shift;
    read_font( $cn->toplevel() ) unless $read_font;

    my $self = bless {
                       -x      => $x,
                       -y      => $y,
                       -cn     => $cn,
                       -xstart => $x,
                       -ystart => $y,
                       @_
                     }, $class;
    return $self;

}

# ============================================================================
# title
# ============================================================================
sub title {
    my $self = shift;
    my $text = shift;

    my $cn = $self->{-cn};
    $self->_write_text( $text, "text", 0, 30, 0 );
    $self->{-y} += 30;
    return $self;
}

# ============================================================================
# math
# ============================================================================
sub math {
    my $self = shift;
    my $text = shift;
    my $cn   = $self->{-cn};
    $self->_write_text( $text, "math", 15, 30, 1, @_ );
    $self->{-y} += 30;
    return $self;
}

# ============================================================================
# label
# ============================================================================
sub label {
    my $self = shift;
    my $text = shift;
    my $cn   = $self->{-cn};
    $self->_write_text( $text, "label", 0, 30, 0 );
    $self->{-y} += 30;
    return $self;
}

# ============================================================================
# explain
# ============================================================================
sub explain {
    my $self = shift;
    my $text = shift;
    my $cn   = $self->{-cn};
    $self->_write_text( $text, "explain", 0, 22, 1, @_ );
    $self->{-y} += 27;
    $cn->update();
    return $self;
}

# ============================================================================
# normal
# ============================================================================
sub normal {
    my $self = shift;
    my $text = shift;
    my $cn   = $self->{-cn};
    $self->_write_text( $text, "explain", 0, 22, 0 );
    $self->{-y} += 27;
    $cn->update();
    return $self;
}

# ============================================================================
# down
# ============================================================================
sub down {
    my $self = shift;
    my $down = shift || 25;
    $self->{-y} = $self->{-y} + $down;
}

# ============================================================================
# read font
# ============================================================================
sub read_font {
    my $mw = shift;

    # get font directory
    my $font_dir = ".";
    foreach my $lib ( keys %INC ) {
        if ( $lib =~ /BitmapText.pm/ ) {
            $font_dir = $INC{$lib};
            $font_dir =~ s/^(.*)\/BitmapText.pm/$1/;
            $font_dir = "$font_dir/fonts";
        }
    }

    # chalkboard
    opendir my $dh, "$font_dir/chalkboard";
    while ( my $file = readdir $dh ) {
        next unless $file =~ /^(.*)\.gif$/;
        $fonts{text}{$1} = $mw->Photo( -file => "$font_dir/chalkboard/$file" );
    }
    closedir $dh;
    opendir $dh, "$font_dir/chalkboard/caps";
    while ( my $file = readdir $dh ) {
        next unless $file =~ /^(.*)\.gif$/;
        $fonts{text}{$1} = $mw->Photo( -file => "$font_dir/chalkboard/caps/$file" );
    }

    # gujrati
    closedir $dh;
    opendir $dh, "$font_dir/explain";
    while ( my $file = readdir $dh ) {
        next unless $file =~ /^(.*)\.gif$/;
        $fonts{explain}{$1} = $mw->Photo( -file => "$font_dir/explain/$file" );
    }
    closedir $dh;
    opendir $dh, "$font_dir/explain/caps";
    while ( my $file = readdir $dh ) {
        next unless $file =~ /^(.*)\.gif$/;
        $fonts{explain}{$1} = $mw->Photo( -file => "$font_dir/explain/caps/$file" );
    }
    closedir $dh;

    # greek
    opendir $dh, "$font_dir/greek";
    while ( my $file = readdir $dh ) {
        next unless $file =~ /^(.*)\.gif$/;
        $fonts{explain}{$1} = $mw->Photo( -file => "$font_dir/greek/$file" );
        $fonts{text}{$1}    = $mw->Photo( -file => "$font_dir/greek/$file" );
    }
    closedir $dh;
}

# ============================================================================
# delete
# ============================================================================
sub delete {
    my $self = shift;
    my $text = shift;
    my $cn   = $self->{-cn};
    foreach my $i ( @{ $self->{-images} } ) {
        $cn->delete($i);
    }
    undef @{ $self->{-images} };
}

# ============================================================================
# erase
# ============================================================================
sub clear { erase(@_) }

sub erase {
    my $self = shift;
    my $text = shift;
    my $cn   = $self->{-cn};
    foreach my $i ( @{ $self->{-images} } ) {
        $cn->delete($i);
    }
    undef @{ $self->{-images} };
    $self->{-x} = $self->{-xstart};
    $self->{-y} = $self->{-ystart};
    if ( $self->{-notice} && ref( $self->{-notice} ) ) {
        foreach my $i ( @{ $self->{-notice} } ) {
            $cn->delete($i);
        }
    }
}

# ============================================================================
# scale
# ============================================================================
sub scale {
    my $self  = shift;
    my $scale = shift;
    my @orig  = @_;
    my $cn    = $self->{-cn};
    foreach my $i ( @{ $self->{-images} } ) {
        $cn->scale( $i, @orig, $scale, $scale );
    }
}

# ============================================================================
# write text
# ============================================================================
sub _write_text {
    my $self  = shift;
    my $text  = shift || "";
    my $type  = shift;
    my $fixed = shift || 0;
    my $down  = shift;
    my $pause = shift || 0;

    my %font = ( math => "text", explain => "explain", text => "text", label => "text" );

    # get info from data object
    my $anchor = $self->{-anchor} || 'w';
    my $width  = $self->{-width}  || 0;
    my $xinit  = $self->{-x};
    my $yinit  = $self->{-y};
    my $cn     = $self->{-cn};

    # define the individual characters
    my @chars = split "", $text;

    # initial values
    my @pics;
    my @y;
    my @x;
    my @lines;
    my $line = 0;
    my $y    = $yinit;
    my $v    = 0;

    my %punc = (
        "," => "comma",
        "/" => "slash",
        "." => "period",
        "+" => "plus",
        "-" => "minus",
        "(" => "open",
        ")" => "close",
        "'" => "apostrophe",
        "?" => "question",
        ">" => "greater",
        "<" => "less",
               );

    # ------------------------------------------------------------------------
    # process each character
    # ------------------------------------------------------------------------
    while ( defined( my $char = shift @chars ) ) {
        $char = $punc{$char} if exists $punc{$char};

        # special characters example: \\{beta}
        if ( $char eq "\\" ) {
            my $name = "";
            my $done = "";
            while ( not $done ) {
                my $c = shift @chars;
                unless ($c) {
                    carp("Badly formed string");
                    return $c;
                }
                next if $c eq "{";
                $done = 1 if $c eq "}";
                $name .= $c unless $c eq "}";
            }
            $char = $name;
        }

        # space - do we need to go to the next line?
        if ( $char eq " " ) {
            if ( $width && $line > $width ) {
                $v = $v + $down;
                push @lines, $line;
                $line = 0;
                next;
            }
        }

        # get the picture for each character
        if ( $fonts{ $font{$type} }{$char} ) {
            push @pics, $fonts{ $font{$type} }{$char};
        }
        else {
            push @pics, undef;
        }

        # keep track of the vertical and horizontal position of each character
        push @x, $line;
        push @y, $v;

        # define offset of next character
        my $w = 10;
        $w = 10 if lc($type) eq "text";
        $w = 8 if lc($type) eq "explain";
        $w = $fonts{ $font{$type} }{$char}->width() + 1
          if exists $fonts{ $font{$type} }{$char};
        $w = $fixed if $fixed;

        # current position
        $line = $line + $w;
    }
    push @lines, $line;

    # ------------------------------------------------------------------------
    # place each pic on the screen
    # ------------------------------------------------------------------------
    $v = 0;
    my $vold;
    my $l = 0;
    my @nw;
    my @se = ( 0, 0 );
    foreach my $pic (@pics) {

        # horizontal and vertical offset
        my $h = shift @x;
        $v = shift @y;
        if ( !( defined $vold ) || $v != $vold ) { $l = shift @lines }
        if ( $fixed && $pic ) {
            $h = $h + int( 0.5 * ( $fixed - $pic->width() + 1 ) );
        }

        # adjust position if we are centering text etc.
        # (note "n" doesn't work well for multiple lines)
        my $x = $xinit;
        my $y = $yinit;
        $x = $xinit - $l / 2     if $anchor eq "c" || $anchor eq "n";
        $x = $xinit - $l         if $anchor eq "e";
        $y = $yinit + $down - 20 if $anchor eq 'n';
        $vold = $v;

        # keep track of starting point
        unless (@nw) {
            @nw = ( $x, $y - 0.5 * $down );
        }

        # display the letter
        if ($pic) {
            my $im = $cn->createImage(
                                       $x + $h, $y + $v,
                                       -image  => $pic,
                                       -anchor => "w"
                                     );
            push @{ $self->{-images} }, $im;
            $cn->update();
        }
        usleep($WriteSpeed) if $pause;

        $se[0] = $se[0] > $x + $h ? $se[0] : $x + $h;
        $se[1] = $y + $v + 0.5 * $down;
    }

    # draw the polygon
    if (@nw) {
        $se[0] = $se[0] + 25;
        $nw[1] = $nw[1] - 5;
        $nw[0] = $nw[0] - 10;
        my $comment = $cn->createPolygon(
                                          @nw, $nw[0], $se[1], @se, $se[0], $nw[1],
                                          -fill    => undef,
                                          -outline => undef
                                        );
        $cn->bind( $comment, "<Button-1>", [ \&notice, $self, $comment ] );
        $cn->lower($comment);

        # save the comment boxes
        push @{ $self->{-notice} }, $comment;
    }

    # update the y position
    $self->{-y} = $yinit + $v;

}

sub notice {
    my $cn      = shift;
    my $self    = shift;
    my $comment = shift;
    my $colour  = $cn->itemcget( $comment, -fill ) || '';
    if ($colour) {
        $cn->itemconfigure( $comment, -fill => undef );
    }
    else {

        #       $cn->itemconfigure( $comment, -fill => $Notice );
    }
}

sub x {
    my $self = shift;
    if (@_) { $self->{-x} = shift }
    return $self->{-x};
}

sub y {
    my $self = shift;
    if (@_) { $self->{-y} = shift }
    return $self->{-y};
}

1;

