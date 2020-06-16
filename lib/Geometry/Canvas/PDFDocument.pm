#!/usr/bin/perl
use strict;
use warnings;

#TODO:
# the cr in a middle of a text does not work!!!

package PDFDocument;
use PDF::API2;
our $Width;
our $Height;

use constant mm => 25.4 / 72;
use constant in => 1 / 72;
use constant pt => 1;

my $home_dir = $ENV{HOME};
my @font_dirs = ( "$home_dir/Library/Fonts", "/Library/Fonts/",
                        "/System/Library/Fonts/","/usr/share/fonts/dejavu/" );
PDF::API2::addFontDirs( @font_dirs );

# ==================================================================
# fonts - these fonts almost match what is used on the TK canvas
# ==================================================================
#https://www.1001fonts.com/dejavu-sans-mono-font.html#character-map
# right 21F2, a716 2E9, 53c, 221f
# perp  22A5,27c2
# rect 2395 2580
# square 25F8, 2610
# triangle 25FA
# times 0007
# parallel  2016
# triangle 2206
# parallelogram 27E0 2581 ??
# not para 02E7 2021
# dot 2022
# arc 0254 03ff 21ba
# circle
my %fonts = ();
my %font_names = (
                   menlo          => ["Menlo-Regular-01.ttf","DejaVuSans.ttf","Arial Narrow.ttf"],
                   dejavuMono     => ["DejaVuSansMono.ttf","DejaVuSansMono.ttf","Andale Mono.ttf","Courier New.ttf",],
                   zapfino        => ["Zapfino.ttf","DejaVuSans.ttf","Arial Narrow.ttf"],
                   arial          => ["Arial.ttf","DejaVuSans.ttf","Arial Narrow.ttf"],
                   arial_slant    => ["Arial Italic.ttf","DejaVuSans.ttf","Arial Narrow.ttf"],
                   chalkduster    => ["Chalkduster.ttf","DejaVuSans.ttf","Arial Narrow.ttf"],
                   chalkboard     => ["Chalkboard.ttf","DejaVuSans.ttf","Arial Narrow.ttf"],
                   arial_rounded  => ["Arial Rounded Bold.ttf","DejaVuSans.ttf","Arial Narrow.ttf"],
                   apple_chancery => ["Apple Chancery.ttf","DejaVuSans.ttf","Arial Narrow.ttf"],
                   arial_bold     => ["Arial Bold.ttf","DejaVuSans.ttf","Arial Narrow.ttf"],
                   dejavu         => ['DejaVuSans.ttf','DejaVuSansCondensed.ttf',"Arial Narrow.ttf"],
);
my %font_map = (
                 other_mono => { -font => "dejavuMono",     -size => 24 },
                 signature  => { -font => "zapfino",        -size => 18 },
                 point      => { -font => "dejavuMono",     -size => 16 },
                 text       => { -font => "arial",          -size => 16 },
                 smalltext  => { -font => "arial",          -size => 12 },
                 sidenote   => { -font => "arial_slant",    -size => 14 },
                 explain    => { -font => "arial",          -size => 18 },
                 cc_font    => { -font => "arial",          -size => 28 },
                 bold       => { -font => "arial_bold",     -size => 18 },
                 smallbold  => { -font => "arial_bold",     -size => 12 },
                 subsript   => { -font => "dejavuMono",     -size => 14 },
                 intro      => { -font => "chalkduster",    -size => 48 },
                 math       => { -font => "dejavuMono",     -size => 21 },
                 mathsmall  => { -font => "dejavuMono",     -size => 18 },
                 smallmath  => { -font => "dejavuMono",     -size => 10 },
                 label      => { -font => "dejavuMono",     -size => 22 },
                 title      => { -font => "arial_rounded",  -size => 30 },
                 fancy      => { -font => "apple_chancery", -size => 24 },
);

# ==================================================================
# new
# ==================================================================
sub new {
    my $class = shift;
    $Width  = shift || 1400;
    $Height = shift || 800;

    my $self = {};
    bless $self, $class;

    # undo fonts
    undef %fonts;

    # Create a blank PDF file, and first page
    my $pdf = PDF::API2->new();
    $self->PDF_doc($pdf);
    return $self;
}

# ==================================================================
# get_font
# ==================================================================
sub get_font {
    my $self      = shift;
    my $name      = shift || "explain";
    my $pdf       = $self->PDF_doc;
    my $font_spec = $font_map{$name} || $font_map{"explain"};
    my $font_name = $font_spec->{-font};
    my $font_size = $font_spec->{-size};

    # use font if it is already defined
    my $font = $fonts{$font_name};

    # set up the pdf font for this font_name
    if ( !ref($font) ) {
        my $font_file;

        # different computers have different fonts, so much look
        # for first match
        foreach my $test_filename (@{$font_names{$font_name}}) {

            # loop through each directory which may have fonts
            foreach my $font_dir (@font_dirs) {

                # if we have a file that matches, we're good :)
                if (-f "$font_dir/$test_filename") {
                    $font_file = $test_filename;
                    last;
                }
            }

            # ok, we found a font_file, time to stop looping already!
            last if $font_file;
        }

        # cannot find font, die (TODO: something other than dieing?
        die "Cannot find font $font_name\n" unless $font_file;

        # create the pdf font, and save for later
        $fonts{$font_name} = $pdf->ttfont($font_file);
        $font = $fonts{$font_name};

    }

    # return required info
    return ( $font, $font_size );
}

sub DESTROY {
    return;
}

# ==================================================================
# copyright images
# ==================================================================
my %images;

sub set_image {
    my $self = shift;

    my $name = shift;
    my $file = shift;
    $file =~ s/.gif/.jpg/;
    $images{$name} = { -name => $file, -image => undef };
}

# ==================================================================
# filename
# ==================================================================
sub filename {
    my $self = shift;
    if (@_) {
        my $name = shift;
        if ( $name =~ /^(.*)_(\d)$/ ) {
            $name = $1 . "_0" . $2;
        }
        $self->{-filename} = "./$name" . ".pdf";
    }
    return $self->{-filename} || "./PDFDocument" . $$ . ".pdf";
}

# ==================================================================
# create_page_from_tk_canvas
# ==================================================================
sub create_page_from_tk_canvas {
    my $self    = shift;
    my $objects = shift;

    $self->new_page();

    # loop over each canvas object
    foreach my $object (@$objects) {
        my $type   = $object->{type};
        my $sub    = $self->can($type);
        my @coords = @{ $object->{coords} };
        my $i      = 0;

        # convert coords from TK canvas to PDF
        foreach my $c (@coords) {
            if ( $i % 2 ) {
                $c = $Height - $c;
            }
            $i++;
        }

        # call appropriate sub for this object
        if ($sub) {
            $sub->(
                    $self,
                    { -coords => \@coords, -options => $object->{options} }
            );
        }
        else {
            print "Missing subroutine ($type)\n";
        }
    }
}

# ==================================================================
# image
# ==================================================================
sub image {
    my $self        = shift;
    my $details     = shift;
    my $page        = $self->PDF_page;
    my $pdf_content = $page->gfx();
    my $image_name  = $details->{-options}{-image};
    my ( $x1, $y1 ) = @{ $details->{-coords} }[ 0, 1 ];
    my $anchor = $details->{-options}{-anchor} || "center";

    if ( exists $images{$image_name} ) {
        my $image_obj = $images{$image_name}{-image};
        unless ($image_obj) {
            $images{$image_name}{-image} =
              $self->PDF_doc->image_jpeg( $images{$image_name}{-name} );
            $image_obj = $images{$image_name}{-image};
        }
        if ( $anchor =~ /^n/ ) {
            $y1 = $y1 - $image_obj->height();
        }
        elsif ( $anchor eq "center" ) {
            $y1 = $y1 - $image_obj->height / 2;
            $x1 = $x1 - $image_obj->width / 2;
        }

        if ( $anchor =~ /^[ns]?e/ ) {
            $x1 = $x1 - $image_obj->width;
        }
        $pdf_content->image( $image_obj, $x1, $y1 );
    }

    else {
        print "image <$image_name> is not available\n";
    }
}

# ==================================================================
# get the pdf content for text, includes getting font info, etc.
# ==================================================================
sub _get_text_content {
    my $self = shift;
    my $details = shift;
    my @font_info = $self->get_font( $details->{-options}{-font} );

    my $page        = $self->PDF_page;
    my $pdf_content = $page->text();
    $pdf_content->font(@font_info);

    my $lead = $pdf_content->lead( 1.15 * $font_info[1] );
    $details->{-options}{-lead} = $lead;

    return $pdf_content;
}

# ==================================================================
# text
# ==================================================================
sub text {
    my $self        = shift;
    my $details     = shift;

    my $original_width = $details->{-options}{-width} || 0;
    my $width = $original_width;
    my $text  = $details->{-options}{-text}  || "";


    # break text into separate bits if there are carriage returns
    # NB: THIS IS VERY FRAGILE, AND NOT VERY GOOD!
    foreach my $para ( split( "\n", $text ) ) {

        my $pdf_content = $self->_get_text_content($details);

        # if there is a width, treat it as a paragraph,
        # only if it exceeds the width
        if ( $width && $pdf_content->advancewidth($text) < $width ) {
            $width = 0;
            $details->{-options}{-width} = $width;
        }

        # paragraph
        if ($width) {
            $self->_write_paragraph( $para, $details);
        }

        # single line
        else {
            $self->_write_line( $pdf_content,$para, $details );
        }

        # reset for next paragraph
        $details->{-options}{-width} = $original_width;
        $width = $original_width;



    }

}

# ==================================================================
# paragraph
# ==================================================================
sub _write_paragraph {
    my $self        = shift;
    my $text        = shift;
    my $details     = shift;
    my $width       = $details->{-options}{-width};
    my $margin      = $details->{-options}{-margins} || 15;

    # convert into lines
    my @lines;
    my @words = split( /( +|\n\t)/, $text );
    my $line  = shift @words;              # maybe text starts with spaces?
    my $try   = $line;
    my $done  = @words;

    # process one word at a time to create a line
    my $pdf_content;
    while ($done || $try ) {
        my $next  = "";
        my $next2 = "";
        my $no_trailing_space = "";
        my $pdf_content = $self->_get_text_content($details);  # is this necessary here??????
        do {

            # "try" fit, so make it the new line
            $line  = $try;

            # get next word, and if that is a space, get the next,next word
            $next  = "";
            $next  = shift @words if @words;
            $next2 = "";
            if ( $next =~ /^\s*$/ ) {
                $next2 = shift @words if @words;
            }
            $try = $try . $next . $next2;

            $no_trailing_space = $try;
            $no_trailing_space =~ s/\s*$//;

            # if this new "try" line fits, keep going
        } while ( $pdf_content->advancewidth($no_trailing_space) < $width+$margin && $try ne $line ) ;

        # write the line that fits
        $self->_write_line( $pdf_content, $line, $details ) if $line !~ /^\s*$/;

        # reset for next go-around
        $done = @words;
        $try = substr($try,length($line));
        $try =~ s/^\s*//;
    }

}

# ==================================================================
# write line,
# ==================================================================
sub _write_line {
    use Encode qw(encode decode);
    my $self        = shift;
    my $pdf_content = shift;
    my $text        = shift;
    my $details     = shift;
    
    my $type = "text";
    $type = $details->{-options}->{-type} || $text;

    my @list        = Encode->encodings();
    my $width = $details->{-options}{-width} || 0;
    my $margin = $details->{-options}{-margins} || 15;
    my $lead = $details->{-options}{-lead};

    # location of text
    my ( $x1, $y1 ) = _location_of_text($pdf_content,$details,$text);

    # new page if necessary and required
    if ($details->{-options}{-make_new_page}) {
        if ($y1-$lead < $margin) {
            $details->{-coords} = [ $x1, $Height-$margin ];
            $self->new_page();
            $pdf_content = $self->_get_text_content($details);
            ( $x1, $y1 ) = _location_of_text($pdf_content,$details,$text);
        }
    }

    # colour
    my $colour = $details->{-options}{-fill} || "black";
    $colour = "#cccccc" if $colour eq '#aaaaaa';
    $pdf_content->fillcolor($colour);

    # special characters, don't know how to get pdf to show them
    $text =~ s/\x{2236}/:/g;
    $text =~ s/\N{U+22C5}/\N{U+00B7}/g;
    $text =~ s/\N{U+2221}/\N{U+2220}/g;

    # undo "use non-breaking '.' for references to other propositions"
    $text =~ s/([VIX])\N{U+22C5}(\d)/$1.$2/g;
    $text =~ s/([VIX])\N{U+22C5}def\N{U+22C5}(\d)/$1.def.$2/g;

    # stupid arial font isn't supporting some ligatures!!!
    $text =~ s/\x{fb00}/ff/g;

    # if the type of text is code, then minimal syntax highlighting
    if ($type eq 'code') {
        $text =~ /^(.*?)(\#.*|\/\/.*)*$/;
        my $code = $1 || "";
        my $comment = $2 || "";
        if ($code =~ /^\s*(function\s|sub\s)/) {
          $pdf_content->fillcolor("#de0909");
        }
        $pdf_content->text($code);
        my $comment_pos = $pdf_content->advancewidth($code);
        $pdf_content->translate( $x1+$comment_pos, $y1 );
        $pdf_content->fillcolor("#006600");
        $pdf_content->text($comment);
        $pdf_content->fillcolor($colour);

    }
    else {
        # write the text
        $pdf_content->text($text);
    }

    # adjust the y position for the next line
    $lead = $details->{-options}{-lead};
    ( $x1, $y1 ) = @{ $details->{-coords} };
    $details->{-coords} = [ $x1, $y1 - $lead ];

}

# ==================================================================
# get location of text
# ==================================================================
sub _location_of_text {
    my $pdf_content = shift;
    my $details = shift;
    my $text = shift;

    my ( $x1, $y1 ) = @{ $details->{-coords} }[ 0, 1 ];
    my $width = $details->{-options}{-width} || 0;
    my $anchor  = $details->{-options}{-anchor}  || "center";
    my $justify = $details->{-options}{-justify} || "left";

    my $lead = $details->{-options}{-lead};
    if ( $anchor =~ /^n/ ) {
        $y1 = $y1 - $lead;
    }
    elsif ( $anchor eq "center" ) {
        $y1 = $y1 - $lead / 2;
    }

    if ( $anchor =~ /^[ns]?e/ ) {
        $x1 = $x1 - $pdf_content->advancewidth($text) if !$width;
        $x1 = $x1 - $width if $width;
    }
    elsif ( $anchor !~ /^[ns][we]/ ) {
        $x1      = $x1 - $pdf_content->advancewidth($text) / 2;
        $justify = "center";
    }

    if ( $width && $justify =~ /^r/ ) {
        $x1 = $x1 + ( $width - $pdf_content->advancewidth($text) );

    }
    $pdf_content->translate( $x1, $y1 );

    return ($x1,$y1);
}

# ==================================================================
# line
# ==================================================================
sub line {
    my $self        = shift;
    my $details     = shift;
    my $page        = $self->PDF_page;
    my $pdf_content = $page->gfx();

    my $width = $details->{-options}{-width} || 1;
    $pdf_content->linewidth($width);

    my @dashpattern;
    my $dash = $details->{-options}{-dash} || "";
    $pdf_content->linedash();
    if ($dash) {
        @dashpattern = ( $dash =~ /(\d+)/g );
        $pdf_content->linedash(@dashpattern);
    }

    my $colour = $details->{-options}{-fill} || "black";
    $pdf_content->strokecolor($colour);

    my $x1 = shift @{ $details->{-coords} };
    my $y1 = shift @{ $details->{-coords} };
    $pdf_content->move( $x1, $y1 );

    while ( @{ $details->{-coords} } ) {
        my $x2 = shift @{ $details->{-coords} };
        my $y2 = shift @{ $details->{-coords} };
        $pdf_content->line( $x2, $y2 );
    }
    $pdf_content->stroke;
}

# ==================================================================
# oval
# ==================================================================
sub oval {
    my $self        = shift;
    my $details     = shift;
    my $page        = $self->PDF_page;
    my $pdf_content = $page->gfx();

    my $width = $details->{-options}{-width} || 1;
    $pdf_content->linewidth($width);
    $pdf_content->linedash();

    my $fillcolour = $details->{-options}{-fill};

    my $strokecolour = $details->{-options}{-outline} || "black";
    $pdf_content->strokecolor($strokecolour);

    my ( $x1, $y1 ) = @{ $details->{-coords} }[ 0, 1 ];
    my ( $x2, $y2 ) = @{ $details->{-coords} }[ 2, 3 ];
    my $x = ( $x1 + $x2 ) / 2;
    my $y = ( $y1 + $y2 ) / 2;
    my $a = abs( $x1 - $x );
    my $b = abs( $y2 - $y );

    if ($fillcolour) {
        $pdf_content->fillcolor($fillcolour);
        $pdf_content->ellipse( $x, $y, $a, $b );
        $pdf_content->fill;
    }

    $pdf_content->ellipse( $x, $y, $a, $b );
    $pdf_content->stroke;

}

# ==================================================================
# arc
# ==================================================================
sub arc {
    my $self        = shift;
    my $details     = shift;
    my $page        = $self->PDF_page;
    my $pdf_content = $page->gfx();

    my $width = $details->{-options}{-width} || 1;
    $pdf_content->linewidth($width);
    $pdf_content->linedash();

    my $fillcolour   = $details->{-options}{-fill};
    my $strokecolour = $details->{-options}{-outline};

    $pdf_content->strokecolor($strokecolour);

    my ( $x1, $y1 ) = @{ $details->{-coords} }[ 0, 1 ];
    my ( $x2, $y2 ) = @{ $details->{-coords} }[ 2, 3 ];
    my $x      = ( $x1 + $x2 ) / 2;
    my $y      = ( $y1 + $y2 ) / 2;
    my $a      = abs( $x1 - $x );
    my $b      = abs( $y2 - $y );
    my $alpha  = $details->{-options}{-start} || 0;
    my $extent = $details->{-options}{-extent} || 90;
    my $type   = $details->{-options}{-style} || "arc";

    # point is currently on the end point, need to find the
    # starting point for "chord" or "pie" type
    my $start_arc_x = $a * cos( $alpha / 180.0 * 3.14159 ) + $x;
    my $start_arc_y = $a * sin( $alpha / 180.0 * 3.14159 ) + $y;
    my $end_arc_x   = $a * cos( ( $alpha + $extent ) / 180.0 * 3.14159 ) + $x;
    my $end_arc_y   = $a * sin( ( $alpha + $extent ) / 180.0 * 3.14159 ) + $y;

    # draw the arc/chord/pie
    if ($strokecolour) {
        $pdf_content->arc( $x, $y, $a, $b, $alpha, $alpha + $extent, 1 );

        if ( $type eq "chord" ) {
            $pdf_content->line( $start_arc_x, $start_arc_y );
        }
        elsif ( $type eq "pieslice" ) {
            $pdf_content->line( $x,           $y );
            $pdf_content->line( $start_arc_x, $start_arc_y );
        }

        # draw it
        $pdf_content->strokecolor($strokecolour);
        $pdf_content->stroke;
    }

    # fill the chord/pie
    if ( $fillcolour && $type ne "arc" ) {
        $pdf_content->fillcolor($fillcolour);
        $pdf_content->arc( $x, $y, $a, $b, $alpha, $alpha + $extent, 1 );
        if ( $type eq "pieslice" ) {
            $pdf_content->line( $x, $y );
        }
        $pdf_content->fill;
    }

}

# ==================================================================
# polygon
# ==================================================================
sub polygon {
    my $self        = shift;
    my $details     = shift;
    my $page        = $self->PDF_page;
    my $pdf_content = $page->gfx();

    my $width = $details->{-options}{-width} || 0;
    $pdf_content->linewidth($width);
    $pdf_content->linedash();

    my $fillcolour = $details->{-options}{-fill};
    return unless $fillcolour || $width;

    my $strokecolour = $details->{-options}{-outline};
    my @coords       = @{ $details->{-coords} };

    if ( $coords[0] != $coords[-2] || $coords[1] != $coords[-1] ) {
        push @coords, $coords[0];
        push @coords, $coords[1];
    }

    if ($strokecolour) {
        $pdf_content->poly(@coords);
        $pdf_content->strokecolor($strokecolour);
        $pdf_content->stroke;
    }

    if ($fillcolour) {
        $pdf_content->fillcolor($fillcolour);
        $pdf_content->poly(@coords);
        $pdf_content->fill;
    }

}

# ==================================================================
# new_page
# ==================================================================
sub new_page() {
    my $self = shift;
    $self->PDF_page( $self->PDF_doc->page() );
    $self->PDF_page->mediabox( $Width, $Height );
}

# ==================================================================
# PDF_page
# ==================================================================

=head2 PDF_page

returns the PDF page object

=cut

sub PDF_page {
    my $self = shift;
    $self->{-page} = shift if @_;
    return $self->{-page};
}

# ==================================================================
# PDF_doc
# ==================================================================

=head2 PDF_doc

returns the PDF document

=cut

sub PDF_doc {
    my $self = shift;
    $self->{-pdf} = shift if @_;
    return $self->{-pdf};
}

sub save {
    my $self = shift;
    $self->PDF_doc->saveas( $self->filename );
    $self->PDF_doc->end;
}

sub open {
    my $self = shift;
    $self->PDF_doc->saveas( $self->filename );
    $self->PDF_doc->end;
}

# ==================================================================
# uncaught method calls
# ==================================================================
our $AUTOLOAD;

sub AUTOLOAD {
    my $self   = shift;
    my $called = $AUTOLOAD;
    $called =~ s/.*:://;
    print "PDFDocument missing method $called\n";
}

1;
__END__
sub _line_with_possible_non_printable_characters {
    my $self = shift;
    my $pdf_content = shift;
    my $text = shift;
    use Encode;
    {
        my %special = ( 8756 => "abcdefghijiklmlnlk" );

        # my %special = ();
        foreach my $ord ( keys %special ) {
            my $special = $special{$ord};
            my @line_bits = split( /($special)/, $text );

       # if (@line_bits > 1) {print "\n ===================== special char \n";}
            my $offset = 0;
            foreach my $line (@line_bits) {
                if ( ord($line) == $ord ) {
                    print "special character\n";
                    $pdf_content->distance( $pdf_content->advancewidth("m"), 0 );
                    $self->replace( $line, $x1 + $offset,
                                    $y1, $pdf_content->advancewidth("m") );
                    $offset = $offset + $pdf_content->advancewidth("m");
                }
                else {
                    print "Not special characters $line\n";
                    $pdf_content->text($line);
                    $pdf_content->distance( $pdf_content->advancewidth($line), 0 );
                    $offset = $offset + $pdf_content->advancewidth($line);
                }
            }
            return;
        }
    }

    sub replace {
    my $self  = shift;
    my $glyph = shift;
    my $x     = shift;
    my $y     = shift;
    my $width = shift;
    print "==============\n";
    print "calling replace\n";
    print "glyph is: $glyph\n";
    print ord( substr( $glyph, 0, 1 ) ), "\n";

# -------------------------------------------------------------------------------
# therefore
# -------------------------------------------------------------------------------
    if ( ord( substr( $glyph, 0, 1 ) ) == 8756 ) {
        $x     = $x + .2 * $width;
        $width = .6 * $width;
        my $d = $width / 4 || 1;
        $self->oval(
                     {
                       -coords => [ $x, $y, $x + $d, $y + $d ],
                       -options => { -fill => 'black' }
                     }
        );
        $self->oval(
                   {
                     -coords => [ $x + $width - $d, $y, $x + $width, $y + $d ],
                     -options => { -fill => 'black' }
                   }
        );
        $self->oval(
                     {
                       -coords => [
                                    $x + $width / 2 - $d / 2,
                                    $y + $width - $d,
                                    $x + $width / 2 + $d / 2,
                                    $y + $width
                       ],
                       -options => { -fill => 'black' }
                     }
        );

    }
}
