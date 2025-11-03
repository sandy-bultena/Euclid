#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

package PropositionCanvas;

=head1 NAME

PropositionCanvas - create a canvas for showing Euclid's Propositions

=head1 SYNOPSIS

    use Geometry::Canvas::PropositionCanvas;
    my $pn = PropositionCanvas->new(-title=>"Example");
    my $t = $pn->text_box( 700, 50, -anchor => "c", -width => 1000 );

    my @A = ( 200, 500 );
    my @B = ( 450, 500 );
    my @subs;
    push @subs, sub {
        $t->title("Construction:");
        $t->explain("Start with line segment AB");
        Point->new($pn,@A)->label( 'A', 'left' );
        Line->new($pn, @A, @B );
        Point->new($pn,@B)->label( 'B', 'right' );
    };

    push @subs, sub {
        $t->explain("Create a circle with center A and radius AB");
        Circle->new($pn, @A, @B );
    };
    $pn->define_steps(@subs);
    $pn->go();

=head1 DESCRIPTION

Using Tk canvas, create a canvas object with some built-in bindings, and a few
special tweaks.

=head2 Bindings

Moving through pages

=over

=item * C<< <KeyPress-Return> >> go to next page

=item * C<< <KeyPress-Right> >> go to next page

=item * C<< <KeyPress-Left> >> go to previous page

=back

Free-hand drawing

=over

=item * C<< <KeyPress-d> >> enable free hand drawing

=item * C<< <KeyPress-l> >> enable line drawing

=item * C<< <KeyPress-x> >> disable drawing

=item * C<< <KeyPress-e> >> erase drawing

=item * C<< <ButtonPress-3> >> erase drawing

=item * While drawing is enabled:

=over

=item * C<< <ButtonPress-1> >> hold button and move mouse while drawing

=item * C<< <ButtonRelease-1> >> stops drawing while mouse is moving

=back

=back

PDF - only works if EUCLID_CREATE_PDF environment variable was set

=over

=item * C<< <KeyPress-s> >> save to PDF

=back

=head2 Fonts

see documentation in C<Geometry::Bitmap::NormalText>

=head2 Package Variables

C<@CARP_NOT> See "Carp" module for its use

C<$PDF = $ENV{EUCLID_CREATE_PDF}> to create the PDF, or not;

C<$ENV{EUCLID_AUTO}> automatically cycles through each page, good for autogenerating
pdf versions of propositions

C<$CopyRight> subroutine that when executed, creates the copyright info;

=cut

# ===========================================================================
# using Tcl/Tk instead of Perl/Tk
# ===========================================================================
use Tcl::Tk;
my $int = new Tcl::Tk;

use Geometry::Geometry;
use Geometry::Bitmap::NormalText;
use Geometry::Canvas::PDFDocument;

use Carp;
our @CARP_NOT;
our $PDF = $ENV{EUCLID_CREATE_PDF} || 0;

my ( $lx, $ly );
my $Hand;
my $Width  = 1400;
my $Height = 800;

sub Width {
    return $Width;
}

sub Height {
    return $Height;
}

our $CopyRight = sub { };
our $overrideWindowsRefresh = 0;

=head1 Methods

=cut

# ==================================================================
# new
# ==================================================================

=head2 new

Create the PropositionCanvas, and write the title if there is one.

Executes the copyright sub if it has been defined
(set package variable C<$PropositionCanvas::CopyRight> to an
anonymous sub)

Returns object

=cut

sub new {
    print "in new ";
    my $class = shift;
    print $class,"\n";
    my $self = { -page => 0, -lastpage => 0, @_ };
    bless $self, $class;
    $self->_pdf( $self->_create_pdf_doc ) if $PDF;
    $self->set_animatable(0) if $PDF;

    # create the main window, and the canvas on top
    $self->_make_canvas();
    if ( exists $self->{-title} && exists $self->{-number} ) {
        $self->title( $self->{-number}, $self->{-title} );
    }

    return $self;
}

# ==================================================================
# ==================================================================
sub _create_pdf_doc {
    my $self = shift;
    $self->{-pdf} = PDFDocument->new( $Width, $Height );
    return $self->{-pdf};
}

# ==================================================================
# ==================================================================
sub _pdf {
    my $self = shift;
    $self->{-pdf} = shift if @_;
    return $self->{-pdf};
}

# ==================================================================
# set_animatable
# ==================================================================

=head2 set_animatable

Sets the flag that allows any animation to take place.

Note that this is different than any parameters set in the Shape
module, in that this flag affects when and if the canvas is refreshed

=cut

sub set_animatable {
    my $self = shift;
    my $bool = shift || 0;
    $overrideWindowsRefresh = !$bool;
}

# ==================================================================
# set_animatable
# ==================================================================

=head2 is_animatable

Determines if the flag that allows any animation to take place has been set

Note that this is different than any parameters set in the Shape
module, in that this flag affects when and if the canvas is refreshed

=cut

sub is_animatable {
    return !$overrideWindowsRefresh;
}

# ==================================================================
# _make_canvas
# ==================================================================
sub _make_canvas {
    my $self = shift;
    my $mw   = $int->mainwindow;

    # --------------------------------------------------------------
    # find the path of this module
    # --------------------------------------------------------------
    my $cursor_dir;
    foreach my $lib ( keys %INC ) {
        if ( $lib =~ /PropositionCanvas.pm/ ) {
            $cursor_dir = $INC{$lib};
            $cursor_dir =~ s/^(.*)\/PropositionCanvas.pm/$1/;
        }
    }

    # --------------------------------------------------------------
    # create the Tk canvas
    # --------------------------------------------------------------
    my $cn =
      $mw->Canvas( -bg => "white", -width => $Width, -height => $Height )
      ->pack();

    $cn->configure( "-scrollregion" => [ 0, 0, 1400, 800 ],
                    -closeenough    => 2.0 );

    # --------------------------------------------------------------
    # define the cursor
    # --------------------------------------------------------------
    $Hand = $^O eq 'MSWin32' ? 'Hand2' : 'pointinghand';
    $cn->configure( -cursor => $Hand );
    $self->{-cursor} = $Hand;

    # --------------------------------------------------------------
    # save some of this stuff
    # --------------------------------------------------------------

    $self->{-cn}     = $self;
    $self->{-mw}     = $mw;
    $self->{-realcn} = $cn;



    # --------------------------------------------------------------
    # setbindings & make grid
    # --------------------------------------------------------------
    $self->setbindings($mw);
    my $g = $self->grid();
    $self->{-grid} = $g;

    # --------------------------------------------------------------
    # copyright and return
    # --------------------------------------------------------------
    $self->copyright();
    $self->disable_draw();
    return $self;
}

# ==================================================================
# setbindings
# ==================================================================
sub setbindings {
    my $self = shift;
    my $mw   = shift;

    # --------------------------------------------------------------
    # Bind the enter key to executing the next step routine
    # --------------------------------------------------------------
    $mw->bind( "<KeyPress-Return>", [ \&_steps, $self ] );
    $mw->bind( "<KeyPress-Right>",  [ \&_steps, $self ] );

    # --------------------------------------------------------------
    # Bind the left key to executing the next step routine
    # --------------------------------------------------------------
    $mw->bind( "<KeyPress-Left>", [ \&_go_back, $self ] );

    # --------------------------------------------------------------
    # define bindings for free-Hand drawing
    # --------------------------------------------------------------
    $mw->bind( '<KeyPress-d>', sub { $self->enable_draw() } );
    $mw->bind( '<KeyPress-l>', sub { $self->enable_line_draw() } );
    $mw->bind( '<KeyPress-x>', sub { $self->disable_draw() } );
    $mw->bind( '<KeyPress-e>', sub { $self->erase_draw() } );

    $mw->bind( '<ButtonPress-3>', sub { $self->erase_draw() } );

    # --------------------------------------------------------------
    # save pdf
    # --------------------------------------------------------------
    $mw->bind( '<KeyPress-s>', sub { $self->_pdf->save() if $PDF } );

}

# ==================================================================
# title
# ==================================================================

=head2 title

Writes the title for this proposition

Inputs:

=over

=item C<$number> Proposition number

=item C<$title> Title of the Proposition

=item C<$book> Book number (I .. XIII)

=back

=cut

sub title {
    my $self   = shift;
    my $number = shift;
    my $title  = shift;
    my $book   = shift || "I";
    my $cn     = $self->{-cn};
    $self->{-title}  = $title;
    $self->{-number} = $number;
    $self->{-book}   = $book;
    return unless $cn;
    my $t = $self->text_box( 700, 50, -anchor => "n", -width => 1000 );
    $t->title("Proposition $number of Book $book");
    $t->normal($title);

    $self->_pdf->filename( $book . "_$number" ) if $PDF;
    return;
}

# ==================================================================
# enable_draw
# ==================================================================

=head2 enable_draw

Sets up the canvas for free-Hand drawing.

Draw by pressing button 1 and drag cursor

=cut

sub enable_draw {
    my $self = shift;
    my $cn   = $self->Tk_canvas;

    $cn->toplevel->bind(
        '<ButtonPress-1>',
        [
           sub {
               my ( $x, $y, $cn ) = @_;
               $lx = $x;
               $ly = $y;
               _start_draw($cn);
           },
           Tcl::Ev( '%x', '%y' ),
           $cn,
        ]
    );
    $cn->toplevel->bind( '<ButtonRelease-1>', [ \&_end_draw, $cn ] );
    $cn->configure( -cursor => "pencil" );
}

=head2 enable_line_draw

Sets up the canvas for free-Hand drawing.

Draw by pressing button 1 and drag cursor

=cut

sub enable_line_draw {
    my $self = shift;
    my $cn   = $self->Tk_canvas;

    $cn->toplevel->bind(
        '<ButtonPress-1>',
        [
           sub {
               my ( $x, $y, $cn ) = @_;
               $lx = $x;
               $ly = $y;
               _start_line_draw( $cn, $self, $lx, $ly );
           },
           Tcl::Ev( '%x', '%y' ),
           $cn
        ]
    );

    $cn->toplevel->bind( '<ButtonRelease-1>',
                         [ \&_end_line_draw, $self, $cn ] );
    $cn->configure( -cursor => "pencil" );
}

# ==================================================================
# disable_draw
# ==================================================================

=head2 disable_draw

Disables the free-Hand drawing.

=cut

sub disable_draw {
    my $self = shift;
    my $cn   = $self->Tk_canvas;
    $cn->toplevel->bind( '<ButtonPress-1>',   undef );
    $cn->toplevel->bind( '<ButtonRelease-1>', undef );
    $cn->configure( -cursor => $Hand );
}

# ==================================================================
# erase_draw
# ==================================================================

=head2 erase_draw

Erases all the free-Hand drawing

=cut

sub erase_draw {
    my $self = shift;
    my $cn   = $self->Tk_canvas;
    $cn->delete("freeHand");
}

# ==================================================================
# _start_draw - define binding for free-Hand drawing
# ==================================================================
sub _start_draw {
    my $cn = shift;
    $cn->toplevel->bind( '<Motion>',
                        [ sub { _add_line(@_) }, Tcl::Ev( '%x', '%y' ), $cn ] );
    $cn->configure( -cursor => "dot" );
}

# ==================================================================
# _start_line_draw - define binding for straight line drawing
# ==================================================================
sub _start_line_draw {
    my $cn   = shift;
    my $self = shift;
    $cn->configure( -cursor => "dot" );
    $cn->toplevel->bind(
                         '<Motion>',
                         [
                            sub { _add_line(@_) },
                            Tcl::Ev( '%x', '%y' ),
                            $cn, 1
                         ]
    );
    $cn->toplevel->bind(
                         '<ButtonRelease-1>',
                         [
                            sub { _end_line_draw(@_) }, Tcl::Ev( '%x', '%y' ),
                            $cn, $self
                         ]
    );
}

sub _end_line_draw {
    my $x    = shift;
    my $y    = shift;
    my $cn   = shift;
    my $self = shift;
    _add_line( $x, $y, $cn );
    $cn->configure( -cursor => "pencil" );
    $cn->toplevel->bind( '<Motion>', sub { } );

    #$self->enable_draw();
}

# ==================================================================
# _end_draw - stop drawing
# ==================================================================
sub _end_draw {
    my $cn = shift;
    $cn->toplevel->bind( '<Motion>', sub { } );
    $cn->configure( -cursor => "pencil" );
}

# ==================================================================
# _add_line - free-Hand drawing
# ==================================================================
sub _add_line {
    my $x    = shift;
    my $y    = shift;
    my $cn   = shift;
    my $line = shift;

    if ($line) {
        $cn->delete("temp");
        $cn->createLine(
                         $lx, $ly, $x, $y,
                         -width => 3,
                         -fill  => "blue",
                         -tags  => "temp freeHand"
        );
    }
    else {
        $cn->createLine(
                         $lx, $ly, $x, $y,
                         -width => 3,
                         -fill  => "blue",
                         -tag   => "freeHand"
        );
        $lx = $x;
        $ly = $y;
    }
}

# ==================================================================
# define_steps
# ==================================================================

=head2 define_steps

Define a series of subroutines, which will be executed each time
the user presses "Enter" on this canvas

Inputs:

=over

=item C<$steps> array ref of anonymous subroutines

=back

=cut

sub define_steps {
    my $self  = shift;
    my $steps = shift;
    $self->{-steps} = $steps;
}

# ==================================================================
# _go_back - go back one page
# ==================================================================
sub _go_back {
    my $self  = shift;
    my $steps = $self->{-steps};

    $self->{-page} = $self->{-page} > 0 ? $self->{-page} - 1 : 0;
    $self->busy();
    $self->_reset_page;
    $self->unbusy();
}

# ==================================================================
# _steps - execute the next subroutine step
# ==================================================================
sub _steps {
    my $self  = shift;
    my $steps = $self->{-steps};
    my $cn    = $self->Tk_canvas;

    # keep from any other event from triggering
    $self->busy();

    # if brand new page
    if ( $self->{-page} >= $self->{-lastpage} ) {

        # execute code for new page
        while ( my $step = shift @$steps ) {

            if ( ref($step) =~ /CODE/ ) {
                $step->();
                $self->{-page}     = $self->{-page} + 1;
                $self->{-lastpage} = $self->{-lastpage} + 1;

                # save state of page
                $self->_save_state;

                last;
            }
        }
    }

    # page was displayed before, so redisplay page
    else {
        $self->{-page} = $self->{-page} + 1;
        $self->_reset_page();
    }
    $self->unbusy();
}

sub set_image {
    my $self = shift;
    my $name = shift;
    my $file = shift;
    $self->_pdf->set_image( $name, $file ) if $PDF;
}

# ==================================================================
# _save_state
# ==================================================================
sub _save_state {
    my $self = shift;
    my $cn   = $self->Tk_canvas;
    my $tag  = "page" . $self->{-page};
    $self->{-pages} = {} unless defined $self->{-pages};
    my $save        = {};
    my $canvas_objs = [];

    my $objects = $cn->find( 'withtag', 'all' );
    my @objects = split(" ",$objects);

    # get all important objects, and save configuration
    foreach my $obj (@objects) {

        my $option;
        my $type = $cn->type($obj);

        $option = $cn->itemcget( $obj, "-state" ) || '';
        $save->{$obj}->{-state} = $option;

        # if this is not a hidden object, then get all the info for this object
        if ( $save->{$obj}->{-state} ne "hidden" ) {
            my %options = parse_options( $cn->itemconfig($obj), $type );
            my $coords = $cn->coords($obj);
            push @$canvas_objs,
              { type => $type, options => \%options, coords => $coords };
        }

        next if $type eq 'image';

        $option = $cn->itemcget( $obj, "-fill" ) || '';
        $save->{$obj}->{-fill} = $option;

        if ( $type eq 'line' ) {
            $option = $cn->itemcget( $obj, "-dash" ) || '';
            $save->{$obj}->{-dash} = $option;
        }

        if ( $type eq 'oval' || $type eq 'polygon' || $type eq 'rectangle' ) {
            $option = $cn->itemcget( $obj, "-outline" ) || '';
            $save->{$obj}->{-outline} = $option;
        }

    }
    $self->{-pages}->{$tag} = $save;

    $self->_pdf->create_page_from_tk_canvas($canvas_objs) if $PDF;
}

# ==================================================================
# parse_options
# take the options of the canvas options, and convert it into
# something useful
# ==================================================================
sub parse_options {
    my $txt = shift;
    my $type = shift || "";
    my @options;

    # --------------------------------------------------------------
    # break string by groups of {....}
    # Must assume that there are no dangling "{" or "}" (let's hope)
    # --------------------------------------------------------------
    my $open_squiggle = 0;
    my $i             = 0;
    for my $c ( split "", $txt ) {
        if ( $c eq "{" ) {
            $open_squiggle++;
        }

        # keep char unless it is between {} groups
        $options[$i] .= $c if $open_squiggle;

        if ( $c eq "}" ) {
            $open_squiggle--;
            if ( $open_squiggle == 0 ) {
                $i++;
            }
        }
    }

    # --------------------------------------------------------------
    # foreach option, must break string into 5 groups
    # rules... if no spaces, then just the text
    # ... if spaces, then string is enclosed between {...}
    # again, assume no dangling "{" or "}"
    #
    #  sample input option:
    # {-text {} {} {} {Copyright \x{a9} 2019 by Sandy Bultena}}
    # --------------------------------------------------------------

    my %option_hashes;

    foreach my $option (@options) {
        my @tmp;
        $open_squiggle = 0;
        $i             = 0;

        # split option into 4 sections
        for my $c ( split "", $option ) {
            if ( $c eq "{" ) {
                $open_squiggle++;
                next if $open_squiggle == 1;    # ignore beginning squiggle
            }

            if ( $c eq "}" ) {
                $open_squiggle--;
                next if $open_squiggle == 0;    # ignore last squiggle
            }

            # if space not inside squiggles
            if ( $c eq " " && $open_squiggle == 1 ) {
                $i++;
                next;
            }

            $tmp[$i] .= $c;
        }

        # assign info to hash
        if ( @tmp == 5 ) {
            my $value = $tmp[4];
            $value =~ s/^{?(.*?)}?$/$1/s;
            $option_hashes{ $tmp[0] } = $value;
        }

        # Print input because there is an ERROR
        else {
            use Data::Dumper;
            print "\nERROR:\n$txt\n";
            print Dumper \@options if $type eq "text";
            print Dumper \@tmp;
        }
    }
    return %option_hashes;
}

# ==================================================================
# _reset_page
# ==================================================================
sub _reset_page {
    my $self = shift;
    my $cn   = $self->Tk_canvas;
    my $tag  = "page" . $self->{-page};
    $self->{-pages} = {} unless $self->{-pages};
    my $save = $self->{-pages}->{$tag};

    my $objects = $cn->find( 'withtag', 'all' );

    # adjust all saved object configurations
    foreach my $obj (@$objects) {

        # restore saved object to previous state
        if ( exists $save->{$obj} ) {
            foreach my $key ( keys %{ $save->{$obj} } ) {
                $cn->itemconfigure( $obj, $key, $save->{$obj}->{$key} );
            }
        }

        # if object is saved in this page, hide it
        else {
            $cn->itemconfigure( $obj, -state => 'hidden' );
        }

    }

    # make sure grid is at the bottom of the stacking order
    $cn->lower('grid');

}

sub lower {
    my $self = shift;
    my $cn   = $self->Tk_canvas;
    $cn->lower(@_);
    $cn->lower('grid');
}

# ==================================================================
# busy - unbind
# ==================================================================
sub busy {
    my $self = shift;
    my $cn   = $self->Tk_canvas;
    my $mw   = $cn->toplevel;

    $mw->bind( "<KeyPress-Return>", undef );
    $mw->bind( "<KeyPress-Right>",  undef );
    $mw->bind( "<KeyPress-Left>",   undef );
    $mw->bind( '<KeyPress-d>',      undef );
    $mw->bind( '<KeyPress-l>',      undef );
    $mw->bind( '<KeyPress-x>',      undef );
    $mw->bind( '<KeyPress-e>',      undef );

    $mw->bind( '<ButtonPress-3>', undef );
    $cn->configure( -cursor => 'watch' );

}

# ==================================================================
# busy re-bind
# ==================================================================
sub unbusy {
    my $self = shift;
    my $cn   = $self->Tk_canvas;
    my $mw   = $cn->toplevel;
    $self->setbindings($mw);

    $cn->configure( -cursor => $self->{-cursor} );

}

# ==================================================================
# go
# ==================================================================

=head2 go

Starts the Tk MainLoop (i.e. ready to roll guys!)

=cut

sub go {

    # just go through it all, no stopping for the user, and create a pdf
    # at the end
    if ( $ENV{EUCLID_AUTO} ) {
        my $self  = shift;
        my $steps = $self->{-steps};
        while ( @{$steps} ) {
            $self->_steps;
        }
        $self->_pdf->save() if $PDF;
        exit();
    }

    # normal behaviour
    $int->MainLoop;
}

# ==================================================================
# text_box
# ==================================================================

=head2 text_box

Creates a box for writing NormalText

Inputs:

=over

=item C<$x> x position

=item C<$y> y position

=back

For other options, see NormalText

Returns: NormalText object

=cut

sub text_box {
    my $self = shift;
    my $cn   = $self->Tk_canvas;
        return unless $cn;
    my $x    = shift;
    my $y    = shift;
    my @opts = @_;
    my $t1   = NormalText->new( $self, $x, $y, @opts );
    return $t1;
}

# ==================================================================
# createText
# ==================================================================

=head2 createText

Replaces the Tk createText method, uses NormalText

Inputs:

=over

=item C<$x> x position

=item C<$y> y position

=item C<< -text => >> I<text>

=back

For other options, see NormalText

Returns: NormalText object

=cut

sub createText {
    my $self = shift;
    my $x    = shift;
    my $y    = shift;
    my %opts = (@_);
    $opts{-anchor} = $opts{-anchor} || "c";

    my $t = $self->text_box( $x, $y, %opts );
    $t->label( $opts{-text} ) if $opts{-text};
    return $t;
}

# ==================================================================
# update
# ==================================================================

=head2 update

Replaces Tk::update - allows user to forgo animation altogether

=cut

sub update {
    my $self = shift;
    my $cn   = $self->Tk_canvas;
    $cn->toplevel()->update() if is_animatable();
}

# ==================================================================
# force_update
# ==================================================================

=head2 force_update

Replaces Tk::update - forces update even if $NoAnimation has been set

=cut

sub force_update {
    my $self = shift;
    my $cn   = $self->Tk_canvas;

    $cn->toplevel()->update();
}

# ==================================================================
# Tk_canvas
# ==================================================================

=head2 Tk_canvas

returns the Tk canvas object

=cut

sub Tk_canvas {
    my $self = shift;
    return $self->{-realcn};
}

# ==================================================================
# mw
# ==================================================================

=head2 mw

returns the Tk main window object

=cut

sub mw {
    my $self = shift;
    return $self->{-mw};
}

# ==================================================================
# center_coords
# ==================================================================

=head2 center_coords

Returns the x,y coordinates of the center of the canvas

=cut

sub center_coords {
    my $self = shift;
    return int( $Width / 2 ), int( $Height / 2 );

}

# ==================================================================
# scaleall
# ==================================================================

=head2 scaleall

Scale all of the specified objects

Inputs:

=over

=item C<$scale> how much to scale

=item C<$x,$y> center of scaling region

=item C<@objs> Objects to scale

=back

=cut

sub scaleall {
    my $self  = shift;
    my $scale = shift;
    my @orig  = splice( @_, 0, 2 );
    my @objs  = @_;

    foreach my $o (@objs) {
        next unless $o;
        $o->scale( $scale, @orig );
    }
}

# ==================================================================
# clear
# ==================================================================

=head2 clear

Erase everything on the canvas except for the grid and the copyright

=cut

sub clear {
    my $self = shift;
    my $page = $self->{-page};
    my $objs = $self->Tk_canvas->find( 'withtag', 'all' );
    print ("Clearing, this are my objects: <$objs>\n");
    my @objs = split( " ",$objs);
    print ("Clearing, this are my objects: <@objs>\n");
    foreach my $obj (@objs) {
        $self->delete($obj);
    }
    $self->grid();
    $self->copyright();
}

# ==================================================================
# delete
# ==================================================================

=head2 delete

overrides canvas delete, and hides objects instead

=cut

sub delete {
    my $self = shift;
    my @objs = $self->Tk_canvas->find( 'withtag', @_ );
    foreach my $obj (@objs) {
        $self->itemconfigure( $obj, -state => 'hidden' );
    }
}

# ==================================================================
# grid
# ==================================================================
sub grid {
    my $self = shift;
    my $cn   = $self->Tk_canvas;

    my ( $x, $y ) = ( 0, 0 );
    while ( $x < $Width ) {
        $x = $x + 20;
        $cn->createLine(
                         $x, -2, $x, $Height,
                         -fill => '#eeeedd',
                         -tag  => 'grid',
                         -dash => [ 4, 2, 2, 2, 2, 2, 2, 4 ],
        );
    }

    while ( $y < $Height ) {
        $y = $y + 20;
        $cn->createLine(
                         -2, $y, $Width, $y,
                         -fill => '#eeeedd',
                         -dash => [ 4, 2, 2, 2, 2, 2, 2, 4 ],
                         -tag  => 'grid'
        );
    }

}

# my $grid = $cn->createGrid( 0, 0, 20, 20, -lines => 2, -color => '#eeeedd' );
#  $self->Tk_canvas->createGrid( 0, 0, 20, 20, -lines => 2, -color => '#eeeedd' );

# ==================================================================
# copyright
# ==================================================================

=head2 copyright

Executes the copyright sub defined by the global variable
C<$PropositionCanvas::COPYRIGHT>

Default is an empty sub

=cut

sub copyright {
    my $self = shift;
    if ( defined $CopyRight && ref($CopyRight) eq "CODE" ) {
        $CopyRight->();
    }
}

# ==================================================================
# AUTOLOAD Tk methods
# ==================================================================

=head2 AUTOLOAD Tk methods

If the method cannot be found, assumes it is a method for the
Tk canvas, and calls this method inside an eval block.

Does not return any errors

=cut

our $AUTOLOAD;

sub AUTOLOAD {
    my $self   = shift;
    my $called = $AUTOLOAD;
    $called =~ s/.*:://;
    eval { $self->Tk_canvas->$called(@_) };
}

=head1 AUTHOR

Sandy Bultena

=head1 COPYRIGHT

This module is copyright (c) 2014 Sandy Bultena. All rights reserved.

This library is free software; you may redistribute and/or modify it under
the terms of either the GNU General Public License
or the Perl Artistic License, as specified in the Perl 5.10.0 README file.

=cut

1;
