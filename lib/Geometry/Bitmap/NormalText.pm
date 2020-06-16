#!/usr/bin/perl
use strict;
use warnings;

package NormalText;
use Geometry::Dictionary;
my $read_font;
my %fonts;
use Time::HiRes qw(usleep);
my $create_font;
my $ydown = 7;
my $tdown = 5;
our $Spell_check = $ENV{SPELL_CHECK};
our $Dictionary;
my $Read_dict;
our $math_char_width;
my @subscripts = (
                   "\N{U+2080}", "\N{U+2081}", "\N{U+2082}", "\N{U+2083}",
                   "\N{U+2084}", "\N{U+2085}", "\N{U+2086}", "\N{U+2087}",
                   "\N{U+2088}", "\N{U+2089}",
);

# ============================================================================
# new
# ============================================================================
sub new {
    my $class = shift;
    my $cn    = shift;
    my $x     = shift;
    my $y     = shift;
    my $self = bless {
                       -x      => $x,
                       -y      => $y,
                       -cn     => $cn,
                       -xstart => $x,
                       -ystart => $y,
                       @_
    }, $class;
    delete $self->{-text};

    unless ($create_font) {
        my $mw = $cn->toplevel();
        my $title_font = $mw->fontCreate(
                                          'other_mono',
                                          -family => 'Bitstream Charter',
                                          -size   => 24
        );
        my $signature_font =
          $mw->fontCreate( 'signature', -family => 'Zapfino', -size => 18 );
        my $point_font = $mw->fontCreate(
                                          'point',
                                          -family => 'Bitstream Charter',
                                          -size   => 16
        );
        my $text_font =
          $mw->fontCreate( 'text', -family => 'Arial', -size => 16 );
        $mw->fontCreate( 'footnote', -family => 'Arial', -size => 14 );
        $mw->fontCreate(
                         'sidenote',
                         -family => 'Arial',
                         -size   => 14,
                         -slant  => "italic"
        );
        $mw->fontCreate( 'explain', -family => 'Arial', -size => 18 );
        $mw->fontCreate(
                         'bold',
                         -family => 'Arial',
                         -size   => 18,
                         -weight => 'bold'
        );
        $mw->fontCreate( 'subscript', -family => 'PT Mono',     -size => 14 );
        $mw->fontCreate( 'intro',     -family => 'Chalkduster', -size => 48 );
        $mw->fontCreate( 'math',      -family => 'PT Mono',     -size => 22 );
        $mw->fontCreate( 'mathsmall', -family => 'PT Mono',     -size => 18 );

        $mw->fontCreate( 'label', -family => 'Chalkboard', -size => 24 );
        $mw->fontCreate(
                         'title',
                         -family => 'Arial Rounded MT Bold',
                         -size   => 30,
        );
        $mw->fontCreate( 'fancy', -family => 'Apple Chancery', -size => 24, );
        $math_char_width = 13.3;
        if ( $ENV{EUCLID_CREATE_PDF} ) {
            $math_char_width = 12.7;
        }
    }
    $create_font = 1;

    return $self;

}

# ============================================================================
# title
# ============================================================================
sub title {
    my $self = shift;
    my $text = shift;

    $self->_write_text( $text, "title" );
    $self->y( $self->y() + $tdown );
    return $self;
}

# ============================================================================
# footnote
# ============================================================================
sub footnote {
    my $self = shift;
    my $text = shift;

    $self->_write_text( $text, "footnote" );
    $self->y( $self->y() );
    return $self;
}

# ============================================================================
# sidenote
# ============================================================================
sub sidenote {
    my $self = shift;
    my $text = shift;

    $self->_write_text( $text, "sidenote" );
    $self->y( $self->y() );
    return $self;
}

# ============================================================================
# math
# ============================================================================
sub math {
    my $self = shift;
    my $text = shift;

    $self->_write_text( $text, "math" );
    $self->y( $self->y + $tdown );
    $self->y( $self->y + $tdown / 2 ) if $self->{-wide_math};
    return $self;
}
sub mathsmall {
    my $self = shift;
    my $text = shift;

    $self->_write_text( $text, "mathsmall" );
    $self->y( $self->y + $tdown );
    $self->y( $self->y + $tdown / 2 ) if $self->{-wide_math};
    return $self;
}

sub wide_math {
    my $self = shift;
    $self->{-wide_math} = shift if @_;
    return $self->{-wide_math};
}

# ============================================================================
# fraction_equation
# ============================================================================
sub fraction_equation {
    my $self   = shift;
    my $text   = shift;
    my $top    = "";
    my $bottom = "";
    my $middle = "";
    my $lines  = "";

    $text = _resolve_special_chars($text);

    while ( length($text) > 0 ) {
        if ( $text =~ /^!(.*?)\/(.*?)!/ ) {
            my $t   = $1;
            my $b   = $2;
            my $max = length($t) > length($b) ? length($t) : length($b);
            $top    .= " " x ( int( $max - length($t) ) / 2 ) . $t;
            $bottom .= " " x ( int( $max - length($b) ) / 2 ) . $b;
            if ( length($top) > length($bottom) ) {
                $bottom = $bottom . " " x ( length($top) - length($bottom) );
            }
            else {
                $top = $top . " " x ( length($bottom) - length($top) );
            }
            $lines  .= "_" x $max;
            $middle .= " " x $max;
            $text =~ s/!.*?\/.*?!//;
        }
        else {
            $middle .= substr( $text, 0, 1 );
            $top    .= " ";
            $bottom .= " ";
            $lines  .= " ";
            $text = substr( $text, 1 );
        }

    }
    $self->math($top);
    $self->down(-28);
    my $y = $self->y;
    my $x = $self->x;
    $self->math($lines);
    $self->y($y);
    $self->x( $x - 5 );
    $self->math($lines);
    $self->y($y);
    $self->x( $x + 5 );
    $self->math($lines);
    $self->x($x);
    $self->down(-18);
    $self->math($middle);
    $self->down(-15);
    $self->math($bottom);

    return $self;
}

# ============================================================================
# label
# ============================================================================
sub label {
    my $self = shift;
    my $text = shift;

    $self->_write_text( $text, "label" );
    $self->y( $self->y() + $tdown );
    return $self;
}

# ============================================================================
# fancy
# ============================================================================
sub fancy {
    my $self = shift;
    my $text = shift;

    $self->_write_text( $text, "fancy" );
    $self->y( $self->y() + $tdown );
    return $self;
}

# ============================================================================
# canvas
# ============================================================================
sub canvas {
    my $self = shift;
    return $self->{-cn};
}

# ============================================================================
# explain
# ============================================================================
sub explain {
    my $self = shift;
    my $text = shift;
    $self->_write_text( $text, "explain" );
    $self->y( $self->y() + $ydown );
    return $self;
}

# ============================================================================
# bold
# ============================================================================
sub bold {
    my $self = shift;
    my $text = shift;
    $self->_write_text( $text, "bold" );
    $self->y( $self->y() + $ydown );
    return $self;
}

# ============================================================================
# point
# ============================================================================
sub point {
    my $self   = shift;
    my $text   = shift;
    my $bullet = shift || "*";

    # get info about current text
    my $anchor = $self->{-anchor} || 'w';
    my $width  = $self->{-width}  || 20;
    my $xinit  = $self->x;
    my $yinit  = $self->y;

    # create temporary NormalText object, indented by 20 pixels
    my $temp = NormalText->new(
                                $self->canvas, $xinit + 40, $yinit,
                                -width  => $width - 40,
                                -anchor => $anchor
    );

    # create the point, write the text, and update the y position
    $self->explain("$bullet");
    $temp->explain($text);
    $self->y( $temp->y );

    # save temp so that it can be erased if necessary
    push @{ $self->{-indented} }, $temp;

    return $self;
}

# ============================================================================
# indent
# ============================================================================
sub indent {
    my $self = shift;
    my $text = shift;

    # get info about current text
    my $anchor = $self->{-anchor} || 'w';
    my $width  = $self->{-width}  || 20;
    my $xinit  = $self->x;
    my $yinit  = $self->y;

    # create temporary NormalText object, indented by 20 pixels
    my $temp = NormalText->new(
                                $self->canvas, $xinit + 20, $yinit,
                                -width  => $width - 20,
                                -anchor => $anchor
    );

    # write the text, and update the y position
    $temp->explain($text);
    $self->y( $temp->y );

    # save temp so that it can be erased if necessary
    push @{ $self->{-indented} }, $temp;

    return $self;
}

# ============================================================================
# normal
# ============================================================================
sub normal {
    my $self = shift;
    my $text = shift;
    $self->_write_text( $text, "normal" );
    $self->y( $self->y() + $ydown );
    return $self;
}

# ============================================================================
# down
# ============================================================================
sub down {
    my $self = shift;
    my $down = shift || 25;
    $self->y( $self->y() + $down );
}

# ============================================================================
# delete
# ============================================================================
sub delete {
    my $self = shift;
    my $cn   = $self->canvas;
    foreach my $i ( @{ $self->{-text} } ) {
        $cn->delete($i);
    }
    undef @{ $self->{-text} };
}

# ============================================================================
# delete item
# ============================================================================
sub delete_item {
    my $self = shift;
    my $item = shift || 0;
    my $cn   = $self->canvas;

    # if no text, bailout
    return unless ref $self->{-text};

    # convert item to an array if it isn't already
    my @items;
    if   ( ref($item) ) { @items = @$item }
    else                { @items = ($item) }

    # delete text item
    foreach my $item (@items) {
        my $textbox = $self->{-text}->[$item];
        if ($textbox) {
            $cn->delete($textbox);
            undef $self->{-text}->[$item];
        }
    }
}

# ============================================================================
# erase
# ============================================================================
sub clear {
    my $self = shift;
    $self->erase(@_);
}

sub erase {
    my $self = shift;
    my $cn   = $self->canvas;
    foreach my $t_array ( @{ $self->{-text} } ) {
        foreach my $i (@$t_array) {
            $cn->delete($i);
        }
    }
    foreach my $indent ( @{ $self->{-indented} } ) {
        $indent->erase;
    }
    undef @{ $self->{-text} };
    $self->y( $self->{-xstart} );
    $self->y( $self->{-ystart} );
}

# ============================================================================
# scale
# ============================================================================
sub scale {
    my $self  = shift;
    my $scale = shift;
    my @orig  = @_;
    my $cn    = $self->canvas;
    foreach my $i ( @{ $self->{-text} } ) {
        $cn->scale( $i, @orig, $scale, $scale );
    }
}

# ============================================================================
# write text
# ============================================================================
sub superscript_subscript {
    my $text = shift || "";
    my $type = shift || "";
    my @superscripts = (
                         "\N{U+2070}", "\N{U+00B9}",
                         "\N{U+00B2}", "\N{U+00B3}",
                         "\N{U+2074}", "\N{U+2075}",
                         "\N{U+2076}", "\N{U+2077}",
                         "\N{U+2078}", "\N{U+2079}",
    );
    while ( $text =~ /\\{^([0-9])}/ ) {
        my $superscript = $superscripts[$1];
        $text =~ s/\\{^([0-9])}/$superscript/;
    }
    while ( $text =~ /\\{(.*?)\^([0-9])}/ ) {
        my $superscript = $superscripts[$2];
        $text =~ s/\\{([^{}]*?)\^([0-9])}/$1$superscript/;
    }

    if ( $ENV{EUCLID_CREATE_PDF} && $type eq "explain" ) {
        while ( $text =~ /\\{_([0-9])}/ ) {
            $text =~ s/\\{_([0-9])}/[$1]/;
        }
        while ( $text =~ /\\{(.*?)\_([0-9])}/ ) {
            $text =~ s/\\{([^{}]?)\_([0-9])}/$1[$2]/;
        }

    }

    while ( $text =~ /\\{_([0-9])}/ ) {
        my $subscript = $subscripts[$1];
        $text =~ s/\\{_([0-9])}/$subscript/;
    }
    while ( $text =~ /\\{(.*?)\_([0-9])}/ ) {
        my $subscript = $subscripts[$2];
        $text =~ s/\\{(.*?)\_([0-9])}/$1$subscript/;
    }
    return $text;
}

sub _resolve_special_chars {
    my $text = shift || "";
    
    
    $text =~ s/-/\N{U+2011}/gi unless $ENV{EUCLID_CREATE_PDF};
    $text =~ s/\\{arc}/\N{U+21BA}/gi;
    $text =~ s/\\{circle}/\N{U+2299}/gi;
    $text =~ s/\\{notpara}/\\{notequal}\\{parallel}/gi;
    $text =~ s/\\{polygon}/\\{square}/gi;
    $text =~ s/\\{rectangle}/\\{square}/gi;
    $text =~ s/\\{parallelogram}/\\{square}/gi;

    $text =~ s/\\{equivalent}/\N{U+2261}/gi;
    $text =~ s/\\{sum}/\N{U+2211}/gi;
    $text =~ s/\\{forall}/\N{U+2200}/gi;
    $text =~ s/\\{elementof}/\N{U+2208}/gi;
    $text =~ s/\\{natural}/\N{U+2115}/gi;
    $text =~ s/\\{real}/\N{U+211D}/gi;
    $text =~ s/\\{prime}/\N{U+2119}/gi;
    $text =~ s/:/\N{U+2236}/gi;
    $text =~ s/\\{alpha}/\N{U+03B1}/gi;
    $text =~ s/\\{eta}/\N{U+03B7}/gi;
    $text =~ s/\\{angle}/\N{U+2220}/gi;
    $text =~ s/\\{beta}/\N{U+03B2}/gi;
    $text =~ s/\\{br}/\n/gi;
    $text =~ s/\\{correct}/\N{U+2713}/gi;
    $text =~ s/\\{degrees}/\N{U+030A}/gi;
    $text =~ s/\\{delta}/\N{U+03B4}/gi;
    $text =~ s/\\{dot}/\N{U+22C5}/gi;
    $text =~ s/\\{epsilon}/\N{U+03B5}/gi;
    $text =~ s/\\{gamma}/\N{U+03B3}/gi;
    $text =~ s/\\{half}/\N{U+00BD}/gi;
    $text =~ s/\\{lambda}/\N{U+03BB}/gi;
    $text =~ s/\\{nb}/\N{U+00A0}/gi;
    $text =~ s/\\{notpara}/\N{U+2224}/gi;
    $text =~ s/\\{nb}/\N{U+00A0}/gi;

    $text =~ s/\\{parallel}/\N{U+2016}/gi;
    $text =~ s/\\{parallel}/\N{U+2225}/gi;

    $text =~ s/\\{parallelogram}/\N{U+2662}/gi;
    $text =~ s/\\{parallelogram}/\N{U+25B1}/gi;
    $text =~ s/\\{parallelogram}/\N{U+27E0}/gi;
    $text =~ s/\\{perp}/\N{U+22A5}/gi;
    $text =~ s/\\{perp}/\N{U+22A5}/gi;
    $text =~ s/\\{phi}/\N{U+03C6}/gi;

    $text =~ s/\\{right}/\N{U+221F}/gi;

    # $text =~ s/\\{right}/\N{U+02E9}/gi;
    # $text =~ s/\\{right}/\N{U+A716}/gi;
    # $text =~ s/\\{right}/\N{U+21F2}/gi;
    # $text =~ s/\\{right}/\N{U+22BE}/gi;

    $text =~ s/\\{sigma}/\N{U+03C3}/gi;
    $text =~ s/\\{square}/\N{U+25A1}/gi;
    $text =~ s/\\{squared}/\N{U+00B2}/gi;
    $text =~ s/\\{cubed}/\N{U+00B3}/gi;
    $text =~ s/\\{therefore}/\N{U+2234}/gi;
    $text =~ s/\\{theta}/\N{U+03B8}/gi;
    $text =~ s/\\{triangle}/\N{U+0394}/gi;
    $text =~ s/\\{wrong}/\N{U+2717}/gi;
    $text =~ s/\\{notequal}/\N{U+2260}/gi;
    $text =~ s/\\{then}/\N{U+2192}/gi;
    $text =~ s/\\{times}/\N{U+00D7}/gi;
    $text =~ s/\.\.\./\N{U+2026}/gi;
    $text =~ s/\\{lessthanorequal}/\N{U+2264}/gi;
    $text =~ s/\\{greaterthanorequal}/\N{U+2265}/gi;
    $text =~ s/\\{(.+?)_(.+?)}/$1[$2]/gi;
    $text =~ s/\\{_(.+?)}/[$1]/gi;
    $text =~ s/\\{gnomon}//gi;
    $text =~ s/\\{thereexists}/\N{U+2203}/gi;
    $text =~ s/\\{(.*?)}/$1/gi;
    return $text;
}

# ============================================================================
# write text
# ============================================================================
sub _write_text {
    my $self = shift;
    my $text = shift || "";
    my $type = shift;

    # create an empy array to hold text
    $self->{-text} = [] unless $self->{-text};
    push @{ $self->{-text} }, [];

    # if spell check is on...
    if ( $Spell_check && $type !~ /^math/ && $type ne 'label' ) {
        spell_check($text);
    }

    # get info from data object
    my $anchor = $self->{-anchor} || 'w';
    my $width  = $self->{-width}  || 0;
    my $xinit  = $self->x;
    my $yinit  = $self->y;
    my $cn     = $self->canvas;
    my $real_cn = $cn->Tk_canvas;

    if ( $anchor !~ /[nsc]/ ) { $anchor = 'n' . $anchor }

    # supported fonts
    my %font = (
                 math      => "math",
                 mathsmall => "mathsmall",
                 explain   => "explain",
                 normal    => "explain",
                 title     => "title",
                 text      => "text",
                 label     => "label",
                 mono      => "mono",
                 fancy     => "fancy",
                 subscript => "subscript",
                 bold      => "bold",
                 sidenote  => "sidenote",
    );

    $text = superscript_subscript( $text, $type );
    my @texts = ($text);

    # separate into sections based on subscripts (if math)
    if ( $type eq 'math' ) {
        $text =~ s/\\{sum\((.+?),(.+?)\)}\s*/$2\\{dot}/gi;

        # $text =~ s/\\{sum\((.+?),(.+?)\)}/\\{sum}\\{_$1}\\{^$2} /gi;
        @texts = split( /(\\{[^\{\}]*?[_^].+?})/, $text );
    }

    # loop over every part of the text
    foreach my $t (@texts) {
        my $xinit = $self->x;

        # not subscript or super script
        if ( $t !~ /\\{(.*?)([_^])(.+?)}/ || $type ne 'math' ) {

            # make text substitutions as required
            $t = _resolve_special_chars($t);

            # use non-breaking '.' for references to other propositions
            $t =~ s/([VIX])\.(\d)/$1\N{U+22C5}$2/g;
            $t =~ s/([VIX])\.def\.(\d)/$1\N{U+22C5}def\N{U+22C5}$2/g;

            # having fun with ligatures (as long as it is not a mono font)
            if ( $type ne 'math' && $type ne 'mono' && $type ne 'title' ) {
                $t = _ligatures($t);
            }

            # create the actual text object
            my $to =
              $real_cn->createText(
                                    $xinit, $yinit,
                                    -text   => $t,
                                    -anchor => $anchor,
                                    -width  => $width,
                                    -font   => $font{$type} || "explain",
              );

            # save text bit
            push @{ $self->{-text}[-1] }, $to;

            # save the x,y position
            my ( $left, $top, $right, $bottom ) = $cn->bbox($to);

            $self->y($bottom);
            $self->x($right);
            $self->x( $xinit + $math_char_width * length($t) )
              if $type eq "math";

        }

        # sub or superscript (only for math)
        else {

            # some offsets that differ between tk canvas and pdf
            my $nudge     = 0;
            my $sublength = $math_char_width / 2;
            if ( $ENV{EUCLID_CREATE_PDF} ) {
                $nudge     = $math_char_width / 8;
                $sublength = $math_char_width / 1.5 + $nudge;
            }

            # adjust y according to super or sub script
            my $base             = $1;
            my $sub_super_script = $3;
            my $yoffset          = $yinit + 12;
            my $base_width       = $math_char_width * length($base);

            if ( $2 eq '^' ) {
                $yoffset = $yinit - 2;
            }

            # write the base
            my $po =
              $real_cn->createText(
                                    $self->x(), $yinit,
                                    -text   => $base,
                                    -anchor => $anchor,
                                    -width  => $width,
                                    -font   => $font{$type} || "explain",
              );

            # write sub script,
            my $to =
              $real_cn->createText(
                                    $self->x() + $base_width + $nudge, $yoffset,
                                    -text   => $sub_super_script,
                                    -anchor => $anchor,
                                    -width  => $width,
                                    -font   => 'subscript',
              );

            # save text bits
            push @{ $self->{-text}[-1] }, $po, $to;

            # adjust to new location
            $self->x( $self->x +
                      $base_width +
                      $sublength * length($sub_super_script) );
            my ( $left, $top, $right, $bottom ) = $cn->bbox($po);
            $self->y($bottom);

        }
    }

    # if type is normal, then center text
    if ( $type eq 'normal' ) {
        $cn->itemconfigure( $self->{-text}[-1][-1], -justify => 'center' );
    }

    # reset x position
    $self->x($xinit);
    $cn->update();

}

sub _ligatures {
    my $text = shift;
    $text =~ s/DZ/\N{U+0761}/g;
    $text =~ s/DZ/\N{U+0763}/g;
    $text =~ s/ffi/\x{fb03}/g;
    $text =~ s/ffl/\x{fb04}/g;
    $text =~ s/ff/\x{fb00}/g;
    $text =~ s/fi/\x{fb01}/g;
    $text =~ s/fl/\x{fb02}/g;

    #    $text =~ s/ft/\x{fb05}/g;
    $text =~ s/LJ/\x{132}/g;
    $text =~ s/lj/\x{133}/g;
    $text =~ s/NJ/\x{1CA}/g;
    $text =~ s/nj/\x{1cc}/g;
    return $text;
}

sub x {
    my $self = shift;
    if (@_) { $self->{-x} = shift }
    return $self->{-x};
}

sub right {
    my $self = shift;
    if (@_) { $self->{-right} = shift }
    return $self->{-right};
}

sub y {
    my $self = shift;
    if (@_) { $self->{-y} = shift }
    return $self->{-y};
}

sub color {
    return colour(@_);
}

sub colour {
    my $self    = shift;
    my $index   = shift || 0;
    my $colour  = shift || "black";
    my $allflag = shift || 0;
    my $cn      = $self->canvas;

    # if no text, bailout
    return unless ref $self->{-text};

    # if allflag true, set indices to everything
    $index = [ 0 .. scalar( @{ $self->{-text} } ) ] if $allflag;

    # convert indices to an array if it isn't already
    my @indices;
    if   ( ref($index) ) { @indices = @$index }
    else                 { @indices = ($index) }

    # loop over each one of the items and change colour
    foreach my $index (@indices) {
        my $textbox_array = $self->{-text}->[$index] || [];
        foreach my $textbox (@$textbox_array) {
            if ($textbox) {
                $cn->itemconfigure( $textbox, -fill => $colour );
            }
        }
    }

    # update gui
    $cn->update;
    return $self;
}

sub red {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, 'red' );
}

sub allred {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, 'red', 1 );
}

sub green {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, 'green' );
}

sub allgreen {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, 'green', 1 );
}

sub blue {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, 'blue' );
}

sub allblue {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, 'blue', 1 );
}

sub grey {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, '#aaaaaa' );
}

sub allgrey {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, '#aaaaaa', 1 );
}

sub black {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, 'black' );
}

sub allblack {
    my $self = shift;
    my $item = shift;
    return $self->colour( $item, 'black', 1 );
}

# ============================================================================
# spell_check
# ============================================================================
sub spell_check {
    my $text     = shift;
    my $new_word = 0;
    my $no_punc  = $text;
    $no_punc =~ s/[\(\).,'"\;\:\x{2026}]/ /g;
    $no_punc =~ s/\\\{.*?\}/ /g;

    # read the current dictionary
    unless ($Read_dict) {
        $Read_dict = 1;
        open my $dh, $INC{"Geometry/Dictionary.pm"}
          or die "Cannot open data\n";
        my $found_end = 0;
        while ( my $w = <$dh> ) {
            chomp($w);
            if ( $w eq '__END__' ) {
                $found_end = 1;
                next;
            }
            next unless $found_end;
            $Dictionary->{$w}++;
        }
        close $dh;
    }

    # go through each word in this text
    my @words = split( /\s+/, $no_punc );

    foreach my $word (@words) {
        next if ( uc($word) eq $word );
        next if $word =~ /\d/;

        # word is not in dictionary... check?
        unless ( exists $Dictionary->{ lc($word) } ) {
            print "Accept '$word' ? ";
            my $ans = <>;
            if ( lc( substr( $ans, 0, 1 ) eq 'y' ) ) {
                $Dictionary->{ lc($word) }++;
                $new_word++;
            }
        }
    }

    # we have a new word, rewrite the dictionary file
    if ($new_word) {
        open my $dh, ">", $INC{"Geometry/Dictionary.pm"}
          or die "Cannot open data\n";
        print $dh "#!/usr/bin/perl\nuse strict;",
          "\nuse warnings;\npackage Dictionary;\n1;\n__END__\n";
        print $dh join( "\n", sort keys $Dictionary ), "\n";
        close $dh;
    }
}

1;
