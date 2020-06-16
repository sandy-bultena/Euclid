#!/usr/bin/perl
use strict;

package PerlLib::Colours;
use PerlLib::Colour;
use PerlLib::VersionString;
use Tk;

require Exporter;
our @ISA = qw(Exporter);

our @EXPORT = qw(
  GetSystemColours
  SetSystemColours
);

# =================================================================
# GetSystemColours
# =================================================================
# gets the system colours from the user default settings
#
# Outputs: colour hash
#--------------------------------------------------------------------
sub GetSystemColours {
    my $theme = shift || '';

    my $invert = 0;
    if ( $theme eq '-invert' ) {
        $invert = 1;
        $theme  = '';
    }

    my %colours = ();

    # --------------------------------------------------------------
    # solaris default colour palette
    # --------------------------------------------------------------
    $colours{WindowHighlight}  = "#b2004d007a00";
    $colours{WorkspaceColour}  = "#ae00b200c300";
    $colours{ButtonBackground} = "#630063009c00";
    $colours{DataBackground}   = "#ff00f700e900";
    $colours{"unknown1"}       = "#68cea600a0e6";
    $colours{"unknown2"}       = "#8d40ad03c700";

    # --------------------------------------------------------------
    # if solaris or unix, read the gnome theme
    # --------------------------------------------------------------
    if ( $^O =~ /solaris|unix/ && -e "/usr/share/themes/Simple/gtk-2.0/gtkrc" )
    {
        _read_gtk_palette( $theme, \%colours );
    }

    # --------------------------------------------------------------
    # if solaris or unix, read the dt.resource file
    # --------------------------------------------------------------
    elsif ( $^O =~ /solaris|unix/ ) {
        _read_dt_palette( \%colours );
    }

    # --------------------------------------------------------------
    # if windows, try this
    # --------------------------------------------------------------
    if ( $^O =~ /win/i ) {
        _read_windows_palette( $theme, \%colours );
    }

    # --------------------------------------------------------------
    # Invert Colours
    # --------------------------------------------------------------
    if ($invert) {
        foreach my $col ( keys %colours ) {
            my @hsl = Colour->hsl( $colours{$col} );
            $hsl[2] = abs( 0.9 * $hsl[2] - 1 );
            $colours{$col} = Colour->setcolour_hsl(@hsl);
        }
    }

    # --------------------------------------------------------------
    # adjust for possible missing colours
    # --------------------------------------------------------------

    # data foreground
    unless ( $colours{DataForeground} ) {
        if ( Colour->isLight( $colours{DataBackground} ) ) {
            $colours{DataForeground} = "#000000";
        }
        else {
            $colours{DataForeground} = "#FFFFFF";
        }
    }

    # a darker background/lighter colour for unused tabs
    if ( Colour->isLight( $colours{DataBackground} ) ) {
        $colours{DarkBackground} =
          Colour->darken( 10, $colours{WorkspaceColour} );
    }
    else {
        $colours{DarkBackground} =
          Colour->darken( -10, $colours{WorkspaceColour} );
    }
    $colours{ButtonBackground} = $colours{WorkspaceColour}
      unless $colours{ButtonBackground};

    # a darker/lighter background colour for selections in lists
    if ( Colour->isLight( $colours{DataBackground} ) ) {
        $colours{SelectedBackground} =
          Colour->darken( 10, $colours{DataBackground} );
        $colours{SelectedForeground} = "#000000";
    }
    else {
        $colours{SelectedBackground} =
          Colour->darken( -10, $colours{DataBackground} );
        $colours{SelectedForeground} = "#ffffff";
    }

    # default foregrounds (white or black depending if colour is dark or not)
    unless ( $colours{WindowForeground} ) {
        if ( Colour->isLight( $colours{WorkspaceColour} ) ) {
            $colours{WindowForeground} = "#000000";
        }
        else {
            $colours{WindowForeground} = "#FFFFFF";
        }
    }

    unless ( $colours{ButtonForeground} ) {
        if ( Colour->isLight( $colours{ButtonBackground} ) ) {
            $colours{ButtonForeground} = "#000000";
        }
        else {
            $colours{ButtonForeground} = "#FFFFFF";
        }
    }

    if ( Colour->isLight( $colours{ButtonBackground} ) ) {
        $colours{ActiveBackground} =
          Colour->darken( 10, $colours{ButtonBackground} );
    }
    else {
        $colours{ActiveBackground} =
          Colour->lighten( 10, $colours{ButtonBackground} );
    }

    return %colours;
}

# =================================================================
# SetSystemColours
# =================================================================
# using colour array and main window, set up some standard
# defaults for tk widgets
#--------------------------------------------------------------------
sub SetSystemColours {
    my $mw      = shift;
    my %colours = %{ +shift };

    # generic
    $mw->optionAdd( '*background',            $colours{WorkspaceColour} );
    $mw->optionAdd( '*foreground',            $colours{WindowForeground} );
    $mw->optionAdd( '*selectBackground',      $colours{SelectedBackground} );
    $mw->optionAdd( '*selectForeground',      $colours{SelectedForeground} );
    $mw->optionAdd( '*Scrollbar.troughColor', $colours{DarkBackground} );

    # buttons
    $mw->optionAdd( '*Button.background',       $colours{ButtonBackground} );
    $mw->optionAdd( '*Button.foreground',       $colours{ButtonForeground} );
    $mw->optionAdd( '*Button.activeBackground', $colours{ActiveBackground} );
    $mw->optionAdd( '*Button.activeForeground', $colours{ButtonForeground} );
    $mw->optionAdd( '*Button.highlightbackground',
        $colours{ButtonHighlightBackground} );

    # radio buttons
    $mw->optionAdd( '*Radiobutton.activeBackground', $colours{DarkBackground} );
    $mw->optionAdd( '*Radiobutton.foreground', $colours{WindowForeground} );
    $mw->optionAdd( '*Radiobutton.background', $colours{WorkspaceColour} );
    $mw->optionAdd( '*Radiobutton.highlightBackground',
        $colours{WorkspaceColour} );
    $mw->optionAdd( '*Radiobutton.activeForeground',
        $colours{WindowForeground} );
    $mw->optionAdd( '*Radiobutton.selectColor', $colours{DataBackground} )
      if $^O =~ /win/i;

    # check buttons
    $mw->optionAdd( '*Checkbutton.activeBackground', $colours{DarkBackground} );
    $mw->optionAdd( '*Checkbutton.foreground', $colours{WindowForeground} );
    $mw->optionAdd( '*Checkbutton.background', $colours{WorkspaceColour} );
    $mw->optionAdd( '*Checkbutton.activeForeground',
        $colours{WindowForeground} );
    $mw->optionAdd( '*Checkbutton.highlightBackground',
        $colours{WorkspaceColour} );
    $mw->optionAdd( '*Checkbutton.selectColor', $colours{DataBackground} )
      if $^O =~ /win/i;

    # lists and entries
    $mw->optionAdd( '*Entry.foreground',       $colours{DataForeground} );
    $mw->optionAdd( '*Entry.background',       $colours{DataBackground} );
    $mw->optionAdd( '*Listbox.foreground',     $colours{DataForeground} );
    $mw->optionAdd( '*Listbox.background',     $colours{DataBackground} );
    $mw->optionAdd( '*BrowseEntry.foreground', $colours{DataForeground} );
    $mw->optionAdd( '*BrowseEntry.background', $colours{DataBackground} );

    # menu
    $mw->optionAdd( '*Menu.activeBackground', $colours{DarkBackground} );
    $mw->optionAdd( '*Menu.activeForeground', $colours{WindowForeground} );

    # trees
    $mw->optionAdd( '*DynamicTree.foreground', $colours{DataForeground} );
    $mw->optionAdd( '*DynamicTree.background', $colours{DataBackground} );
    $mw->optionAdd( '*EasyDir.foreground',     $colours{DataForeground} );
    $mw->optionAdd( '*EasyDir.background',     $colours{DataBackground} );

    # text boxes
    $mw->optionAdd( '*Text.foreground',   $colours{DataForeground} );
    $mw->optionAdd( '*Text.background',   $colours{DataBackground} );
    $mw->optionAdd( '*ROText.foreground', $colours{DataForeground} );
    $mw->optionAdd( '*ROText.background', $colours{DataBackground} );

    # notbook
    $mw->optionAdd( '*NoteBook.inactiveBackground', $colours{DarkBackground} );
    $mw->optionAdd( '*NoteBook.background',         $colours{WorkspaceColour} );
    $mw->optionAdd( '*NoteBook.backpagecolor',      $colours{WorkspaceColour} );

}

# =================================================================
# _read_dt_palette
# =================================================================
sub _read_dt_palette {
    my $colours = shift;
    my $palette;

    # define resource file
    my $home = $ENV{'HOME'};
    my $file = '/.dt/sessions/current/dt.resources';

    # if resourse file exists, read it to find name of user palette
    if ( open PREF, "$home/$file" ) {
        while (<PREF>) {

            if (/^OpenWindows\.(\w+)\:\s+(\#[0-9A-F]*)\s*$/) {
                $colours->{$1} = $2;
            }
            if (/ColorPalette:\s+(.*)/) {
                $palette = $1;
            }
        }
        close PREF;
        $colours->{WorkspaceColour} = $colours->{WorkspaceColor}
          if $colours->{WorkspaceColor};
    }

    # define and find the palette file
    my $palette_file = "/usr/dt/share/palettes/" . $palette;
    $palette_file = "$home/.dt/palettes/$palette"
      if -e "$home/.dt/palettes/$palette";

    # open and read palette file
    if ($palette) {
        if ( open PALETTE, "<$palette_file" ) {
            chomp( $colours->{WindowHighlight}  = <PALETTE> );
            chomp( $colours->{WorkspaceColour}  = <PALETTE> );
            chomp( $colours->{ButtonBackground} = <PALETTE> );
            chomp( $colours->{DataBackground}   = <PALETTE> );
            chomp( $colours->{"unknown1"}       = <PALETTE> );
            chomp( $colours->{"unknown2"}       = <PALETTE> );
            close PALETTE;
        }
    }

    return;
}

# =================================================================
# _read_gtk_palette
# =================================================================
sub _read_gtk_palette {
    my $palette = shift;
    my $colours = shift;

    # get the user defined config file for gnome
    my $home = $ENV{'HOME'};
    my $file = '/.gconf/desktop/gnome/interface/%gconf.xml';

    # read config file to determine which theme unless palette already
    # defined
    unless ($palette) {
        if ( open PREF, "$home/$file" ) {

            my $theme = 0;
            while (<PREF>) {
                if (/entry name="gtk_theme"/) {
                    $theme = 1;
                }
                if ( $theme && /<stringvalue>(.*)<\/stringvalue>/ ) {
                    $palette = $1;
                    last;
                }
            }
            close PREF;
        }
    }

    # read the themed file (use Simple as starting point, then modify
    # according to the theme
    foreach my $theme ( 'Simple', $palette ) {
        my $palette_file = "/usr/share/themes/$theme/gtk-2.0/gtkrc";
        if ( open PALETTE, "<$palette_file" ) {

            my $style;
            while (<PALETTE>) {
                $style = $1 if /style\s*"(.*)"/;
                if ( $style eq 'default' ) {
                    $colours->{WindowHighlight} = $1
                      if /fg\[ACTIVE\]\s*=\s*"(.*)"/;
                    $colours->{WindowForeground} = $1
                      if /fg\[NORMAL\]\s*=\s*"(.*)"/;
                    $colours->{DataBackground} = $1
                      if /base\[NORMAL\]\s*=\s*"(.*)"/;
                    $colours->{DataForeground} = $1
                      if /text\[NORMAL\]\s*=\s*"(.*)"/;
                    $colours->{WorkspaceColour} = $1
                      if /bg\[NORMAL\]\s*=\s*"(.*)"/;
                    $colours->{ButtonBackground} = $1
                      if /base\[SELECTED\]\s*=\s*"(.*)"/;
                }
            }
            close PALETTE;
        }
    }

    return;
}

# =================================================================
# _read_windows_palette
# =================================================================
sub _read_windows_palette {
    my $scheme  = shift;    # unused for now
    my $colours = shift;

    # open registry
    no warnings;
    no strict;
    eval {
        require Win32::TieRegistry;
        import Win32::TieRegistry;
    };

    return if $@;

    # get the current colour scheme
    my $x = $Registry->{q(HKEY_CURRENT_USER\\Control Panel\\Colors)};

    # get the colour from the registry
    $colours->{WindowHighlight}  = _key_to_colour( $x->{'Hilight Text'} );
    $colours->{WindowForeground} = _key_to_colour( $x->{'Menu Text'} );
    $colours->{DataBackground}   = _key_to_colour( $x->{'Window'} );
    $colours->{DataForeground}   = _key_to_colour( $x->{'Window Text'} );
    $colours->{WorkspaceColour}  = _key_to_colour( $x->{'ActiveBorder'} );
    $colours->{ButtonBackground} = _key_to_colour( $x->{'ButtonFace'} );

    return;
}

sub _key_to_colour {
    my $key = shift;
    my @rgb = map { $_ / 255. } split( ' ', $key );
    return Colour->setcolour_rgb(@rgb);
}

1;

=head1 NAME

PerlLib::Colours - gets the system colours from the user default settings

=cut

my $version_pod = << '=cut';

=head1 VERSION

Version 1.00 $Rev: 201 $

=cut

our $VERSION = VersionString($version_pod);

=head1 SYNOPSIS

    use PerlLib::Colours;
    use Tk;

    my $mw = MainWindow->new();

    my %colours = GetSystemColours();
    $colours{WorkspaceColour} = "#444400";
    $colours{WindowHighlight} = "#ffff00";
    SetSystemColours($mw,\%colours);

    MainLoop;

=head1 DESCRIPTION

Reads the solaris .dt.resource file to pick out the user's preferred colours. Under windows,
uses the system colours (not tested).

Can set the Tk colours, either with the user preferences, or lighten and/or darken the
colours as desired.

=head1 EXPORTED SUBROUTINES

A list of all the exported subroutines:

=head2 GetSystemColours

On solaris, reads the .dt.resources file to find the user's preferences.
On windows (not tested) uses the system defined colours

=head3 Inputs:

none

=head3 Returns:

hash table of defined colours

    $colours{WindowHighlight}  # from .dt.resources
    $colours{WorkspaceColour}  # from .dt.resources
    $colours{ButtonBackground} # from .dt.resources
    $colours{DataBackground}   # from .dt.resources
    $colours{"unknown1"}       # from .dt.resources
    $colours{"unknown2"}       # from .dt.resources

    $colours{DataForeground}   # white or black, depending on DataBackground
    $colours{DarkBackground}   # a 10% darker WorkspaceColour
    $colours{WindowForeground} # white or black, depending on WorkspaceColour
    $colours{ButtonForeground} # white or black, depending on ButtonBackground


=head2 SetSystemColours

Sets the Tk colour pallete to be more rich than the default

=head3 Inputs:

pointer to hash of colour definitions

=head3 Returns:

nothing

=head3 Sets

Defines the Tk colours as follows

    $mw->optionAdd('*Button.background',        $colours{ButtonBackground});
    $mw->optionAdd('*Button.foreground',        $colours{ButtonForeground});
    $mw->optionAdd('*Button.activeBackground',  $colours{ButtonBackground});
    $mw->optionAdd('*Button.activeForeground',  $colours{ButtonForeground});
    $mw->optionAdd('*Radiobutton.highlightBackground',$colours{WorkspaceColour});
    $mw->optionAdd('*Checkbutton.highlightBackground',$colours{WorkspaceColour});
    $mw->optionAdd('*Menu.activeBackground',    $colours{DarkBackground});
    $mw->optionAdd('*Menu.activeForeground',    $colours{WindowForeground});
    $mw->optionAdd('*DynamicTree.foreground',   $colours{DataForeground});
    $mw->optionAdd('*DynamicTree.background',   $colours{DataBackground});
    $mw->optionAdd('*Text.foreground',          $colours{DataForeground});
    $mw->optionAdd('*Text.background',          $colours{DataBackground});
    $mw->optionAdd('*ROText.foreground',        $colours{DataForeground});
    $mw->optionAdd('*ROText.background',        $colours{DataBackground});
    $mw->optionAdd('*Entry.foreground',         $colours{DataForeground});
    $mw->optionAdd('*Entry.background',         $colours{DataBackground});
    $mw->optionAdd('*Listbox.foreground',       $colours{DataForeground});
    $mw->optionAdd('*Listbox.background',       $colours{DataBackground});
    $mw->optionAdd('*LabEntry.foreground',      $colours{DataForeground});
    $mw->optionAdd('*LabEntry.background',      $colours{DataBackground});
    $mw->optionAdd('*Scrollbar.troughColor',    $colours{DarkBackground});
    $mw->optionAdd('*NoteBook.inactiveBackground',$colours{DarkBackground});
    $mw->optionAdd('*BrowseEntry.foreground',   $colours{DataForeground});
    $mw->optionAdd('*BrowseEntry.background',   $colours{DataBackground});

=head1 AUTHOR

Sandy Bultena

=cut

