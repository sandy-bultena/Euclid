#!/usr/bin/perl
use strict;
use warnings;

package Shape;
use Time::HiRes qw(usleep);
use Carp;
use Storable;
our @CARP_NOT;

=head1 NAME

Shape - super class for all the other shapes

=head1 SYNOPSIS

    package Angle;
    use Tk;
    use Geometry::Geometry;

    our @ISA = qw(Shape);

=cut

my $tag;

# ============================================================================
# Class Variables and Functions
# ============================================================================

=head1 Class Variables

=head2 C<$AniSpeed>

This variable defines the time between each 'tick' of animation.

The lower the number, the faster the animation, although there is a limit
to how fast it can go because of the time it takes Tk to refresh the screen

=head2 C<$DefaultSpeed>

This affects the animation by reducing the animation speed, but also limits
the number of screen refreshes, thereby 'skipping' the whole animation process.

This is more affective at higher speeds is (reduces refreshes), 
but it does make the animation more choppy.

=head2 C<$NoAnimation>

If set to true, then no animations are calculated, although you will still
see various bits of the construction pop-up, what won't happen is the line
or circle being drawn

=head2 C<%colour>

Hash table of colours used to define green, red, normal, grey

=cut

our $AniSpeed     = set_ani_speed();
our $DefaultSpeed = set_default_speed();
our $NoAnimation = set_shape_animation(1);

sub set_ani_speed {
    my $self = shift;
    $AniSpeed = shift @_ || 500;
}
sub get_ani_speed {
    return $AniSpeed;
}
sub set_default_speed {
    my $self = shift;
    $DefaultSpeed = shift @_ || 2;
}
sub set_shape_animation {
    my $self = shift;
    my $bool = shift || 0;
    $NoAnimation = !$bool;
}

our %colour = (
    green  => [ "#aaffaa", "#aaff88", "#66ff66", "#00ff00" ],
    green  => [ "#aaddaa", "#88dd88", "#66dd66", "#44dd44" ],
    red    => [ "#ffaaaa", "#ff8888", "#ff6666", "#ff0000" ],
    normal => [ "#aaaaaa", "#aa8888", "#666666", "#000000" ],
    grey   => [ "#ffffff", "#eeeeee", "#dddddd", "#cccccc" ],

              );
our @shape_sizes = (4, 3, 2, 1);

# --- modify the drawing of objects
%colour = (
    green  => [ "#00ff00", "#00ff00", "#00ff00", "#00ff00" ],
    green  => [ "#44dd44", "#44dd44", "#44dd44", "#44dd44" ],
    red    => [ "#ff0000", "#ff0000", "#ff0000", "#ff0000" ],
    normal => [ "#000000", "#000000", "#000000", "#000000" ],
    grey   => [ "#cccccc", "#cccccc", "#cccccc", "#cccccc" ],
    blue   => [ "#0000ff", "#0000ff", "#0000ff", "#0000ff" ],

              );
@shape_sizes = (3);


=head1 Class Variables

=head2 C<red_colour>
=head2 C<normal_colour>
=head2 C<green_colour>
=head2 C<grey_colour>

=cut

sub red_colour {return ( @{ $colour{red} } );}
sub normal_colour { return ( @{ $colour{normal} } ); }
sub green_colour  { return ( @{ $colour{green} } ); }
sub grey_colour   { return ( @{ $colour{grey} } ); }

# ============================================================================
# properties
# ============================================================================

=head1 Properties

=head2 canvas 

Returns the Tk canvas object

=cut

sub canvas {
    my $self = shift;
    my $cn   = $self->{-cn};
    return $cn;
}

=head2 bbox 

Returns the bounding box defining all of of the Tk canvas objects used to
create the Shape

=cut

sub bbox {
    my $self = shift;
    my $cn   = $self->canvas;
    return $cn->bbox( $self->cn_objects );
}

=head2 cn_objects 

Returns a list of all the Tk canvas objects used to define the shape

=cut

sub cn_objects {
    my $self = shift;
    $self->{-objects} = [] unless $self->{-objects};
    return @{ $self->{-objects} };
}

=head2 label

Returns the label object associated with this label

=cut 

sub label {
    my $self = shift;
    return $self;
}

=head2 label_is

returns the "text" of the label

=cut 

sub label_is {
    my $self = shift;
    my $r = $self->{"Shape::what"} || "";
    return $r;
}

=head2 label_where

returns the location ("bottom","top",...) of the label

=cut 

sub label_where {
    my $self = shift;
    my $r = $self->{"Shape::where"} || "";
    return $r;
}

# ============================================================================
# ============================================================================

=head1 Methods

=cut

# ============================================================================
# change colours
# ============================================================================

=head2 grey

=head2 red

=head2 green

=head2 normal

=cut
 
sub grey {
    my $self = shift;
    $self->_set_colour( "-fill",    "grey" );
    $self->_set_colour( "-outline", "grey" );
}

sub red {
    my $self = shift;
    $self->_set_colour( "-fill",    "red" );
    $self->_set_colour( "-outline", "red" );
}

sub green {
    my $self = shift;
    $self->_set_colour( "-fill",    "green" );
    $self->_set_colour( "-outline", "green" );
}

sub normal {
    my $self = shift;
    $self->_set_colour( "-fill",    "normal" );
    $self->_set_colour( "-outline", "normal" );

}

# ============================================================================
# scale
# ============================================================================

=head2 scale (scale,x,y)

Scales the Shape

B<Parameters>

=over

=item * scale - how much to scale the shape

=item * (x,y) - what is the "center" of the scaling

=back

=cut
 
sub scale {
    my $self  = shift;
    my $scale = shift;
    my @orig  = @_;

    my $cn    = $self->canvas;

    # scale each Tk canvas object
    foreach my $obj ( $self->cn_objects() ) {
        next unless $obj;
        $cn->scale( $obj, @orig, $scale, $scale );
    }
    
    # move all the labels
    if ( ref( $self->{-label} ) eq "ARRAY" ) {
        foreach my $l ( @{ $self->{-label} } ) {
            if ( ref($l) ) {
                $l->scale( $scale, @orig );
            }
        }
    }
    
    # update the Tk canvas
    $cn->update;
}


# ============================================================================
# move
# ============================================================================

=head2 moves (x, y, [no_update])

Moves the Shape

B<Parameters>

=over

=item * (x,y) - how far to move the object (x,y direction)

=item * no_update - flag... if true, don't update the Tk Window

- this is useful if moving lots of things, and you want to update the Tk
window only after you finished moving everything

=back

=cut
 
sub move {
    my $self      = shift;
    my $x         = shift;
    my $y         = shift;
    my $no_update = shift;

    # set some variables 
    my $cn        = $self->canvas;
    my $colour    = $self->{-colour} || "";
    my @coords;

 #       use Data::Dumper;print "\nbefore:\n",Dumper \@coords;
    # move each Tk canvas object that makes up the shape
    foreach my $obj ( $self->cn_objects ) {
        $cn->move( $obj, $x, $y );
        @coords = $cn->coords($obj);
        # NB: moved to Tcl::Tk changed how @coords are returned
        if ($coords[0] && ref($coords[0]) && $coords[0]->isa("Tcl::List")) {
            @coords = @{$coords[0]};
        }
    }
  #      use Data::Dumper;print "after:\n",Dumper \@coords;
    
    # set the coordinates for the shape to reflect the new position
    
   # print "self coords before: ",join(", ",$self->{-x1},$self->{-y1},$self->{-x2},
   # $self->{-y2}, $self->{-x}, $self->{-y}),"\n";
    ( $self->{-x1}, $self->{-y1}, $self->{-x2}, $self->{-y2} ) = @coords;
    ( $self->{-x}, $self->{-y} ) = @coords;
   # print "self coords after: ",join(", ",$self->{-x1},$self->{-y1},$self->{-x2},
   # $self->{-y2}, $self->{-x}, $self->{-y}),"\n";

        
    # could create possible bug here? (needed for point object!)
    $self->{-x1} = $self->{-x1} || 0;
    $self->{-y1} = $self->{-y1} || 0;
    $self->{-x2} = $self->{-x2} || 0;
    $self->{-y2} = $self->{-y2} || 0;
    $self->{-x} = 0.5 * ($self->{-x1} + $self->{-x2});
    $self->{-y} = 0.5 * ($self->{-y1} + $self->{-y2});

    # redraw the label
    if ( $colour ne "grey" ) {
        $self->label( $self->label_is, $self->label_where );
    }
    
    # update the Tk canvas
    $cn->update() unless $no_update;
}


# ============================================================================
# animate
# ============================================================================

=head2 animate (routine, fast, number_of_times)

Execute the call back routine repeatedly, updating the Tk Canvas
between each call.

B<Parameters>

=over

=item * C<$sub> - subroutine reference (takes an integer 1..C<$d> as input)

=item * C<$fast> - how fast (changes the factor of $Anispeed)

(if C<$fast> is less than zero, suppresses the Tk updates withing the loop)

=item * C<$d> - how many times do you want to call the C<$sub> reference?

=back

=cut
 
sub animate {
    my $self = shift;
    my $sub  = shift || sub { return };
    my $fast = shift || 1;
    my $d = shift || 0;
    
    $fast = $fast * $DefaultSpeed;
    
    my $cn = $self->canvas;

    # loop from 1 to d, and sleep, call sub, update Tk Canvas
    unless ($NoAnimation) {
        foreach my $i ( 1 .. int($d) ) {
#            print "Calling callback with ($i)\n";
            $sub->($i);
            usleep( $AniSpeed / $fast ) if $fast > 0;
            $cn->update() if $fast > 0 && !( $i % $fast );
        }
    }
    else {
        foreach my $i ( 1 .. int($d) ) {
            $sub->(int($d));
        }
    }
    
    # update Tk window
    $cn->update();
}


# ============================================================================
# raise
# ============================================================================

=head2 raise

Brings this shape to the top of the image stack

B<Returns>

the shape object

=cut
 
sub raise {
    my $self = shift;
    my $cn   = $self->canvas;

    foreach my $obj ( $self->cn_objects() ) {
        $cn->raise($obj);
    }

    $cn->update;
    return $self;
}

# ============================================================================
# lower
# ============================================================================

=head2 lower

Moves this shape to one lower in the image stack

B<Parameters>

=over

=item * C<$below> - if a valid shape object, moves the current shape to 
just below this shape

=back

B<Returns>

the shape object

=cut
 
sub lower {
    my $self  = shift;
    my $below = shift;
    my $cn    = $self->canvas;
    
    if ($below) {
        foreach my $obj ( $self->cn_objects ) {
            $cn->lower( $obj, $below );
        }
    }
    
    else {
        foreach my $obj ( reverse $self->cn_objects ) {
            $cn->lower($obj);
        }

    }
    
    $cn->update;
    return $self;
}

# ============================================================================
# draggable
# ============================================================================

=head2 draggable (true|false)

Sets or unsets the ability for the shape to be dragged by the mouse

B<Parameters>

=over 

=item * (true/false) true = draggable, false = not draggable

= back

B<Returns>

=over

=item * shape object

=back

=cut

# -----------------------------------------------------------------------------

sub draggable {
    my $self      = shift;
    my $draggable = shift;
    $draggable = 1 unless defined $draggable;

    # bind the mouse down and mouse movements to this object
    if ($draggable) {
        $self->{-draggable} = 1;
        $self->_unbind_notice();
        foreach my $obj ( $self->cn_objects ) {
            $self->canvas->bind( $obj, "<ButtonPress-1>", [ \&_start_moving, $self, Tk::Ev("x"), Tk::Ev("y") ] );
            $self->canvas->bind( $obj, "<ButtonRelease-1>", [ \&_stop_moving, $self ] );
        }
    }

    # remove bindings
    else {
        $self->{-draggable} = 0;
        foreach my $obj ( $self->cn_objects ) {
            $self->canvas->bind( $obj, "<ButtonPress-1>", "" );
        }
        $self->bind_notice();
    }

    # return object
    return $self;
}

{
    my $xstart;
    my $ystart;

    # -------------------------------------------------------------------------
    # _start_moving ... dragging has started
    # -------------------------------------------------------------------------
    sub _start_moving {
        my $cn   = shift;
        my $self = shift;
        $xstart = shift;
        $ystart = shift;
        $cn->CanvasBind( "<Motion>", [ \&_mouse_move, $self, Tk::Ev('x'), Tk::Ev('y') ] );
    }

    # -------------------------------------------------------------------------
    # _mouse_move ... dragging is happening!
    # -------------------------------------------------------------------------
    sub _mouse_move {
        my $cn   = shift;
        my $self = shift;
        my $x    = shift;
        my $y    = shift;

        # move the object (disable the binding while moving the object)
        _stop_moving( $cn, $self );
        $self->move( $x - $xstart, $y - $ystart );
        _start_moving( $cn, $self, $x, $y );

    }

    # -------------------------------------------------------------------------
    # _stop_moving ... dragging has stopped
    # -------------------------------------------------------------------------
    sub _stop_moving {
        my $cn   = shift;
        my $self = shift;
        foreach my $obj ( $self->cn_objects ) {
            $cn->CanvasBind( "<Motion>", "" );
        }
    }
}

# ============================================================================
# remove
# ============================================================================

=head2 remove

Removes the object from the Tk canvas

=cut

# -----------------------------------------------------------------------------

sub remove {
    my $self = shift;

    my $cn   = $self->canvas;

    # remove all Tk canvas objects from the canvas
    foreach my $p ( $self->cn_objects() ) {
        $cn->delete($p);
    }
    undef @{ $self->{-objects} };

    # hide the label (don't remove it, we may want to redraw!)
    $self->_hide_label();

    # update the Tk canvas 
    $cn->update;
    
    # return the object that was removed
    return $self;
}

# ============================================================================
# remove_label
# ============================================================================

=head2 remove_label

Removes the label from the shape (if it has one)

=cut

# -----------------------------------------------------------------------------

sub remove_label {
    my $self = shift;
    $self->_hide_label();
    $self->{"Shape::where"} = "";
    $self->{"Shape::what"}  = "";
}

# ============================================================================
# notice
# ============================================================================

=head2 notice(subroutine) 

causes the shape to be noticed by some form of animation

B<Parameters>

=over

=index * subroutine($i) - used to animate the shape

This routine will call the subroutine 7 times, with $i increasing from
1 to 7.  Pause, and then call the subroutine 6 times, with $i decreasing
from 6 to 1.

=back

=cut

# -----------------------------------------------------------------------------

sub notice {
    return if $NoAnimation;
    
    my $self   = shift;
    my $sub    = shift || sub { return };

    my $cn = $self->canvas;

    # save the current colour, and set the object red
    my $colour = $self->{-colour} || "normal";
    $self->red();

    # animate the object, incrementing upward
    foreach my $i ( 1 .. 7 ) {
        $cn->update();
        usleep(100000);
        $sub->($i);
    }
    
    # sleep
    usleep(50000);
    
    # animate the ojbect again, only increments goes down
    foreach my $i ( 1 .. 7 ) {
        $cn->update();
        usleep(100000);
        $sub->( 7 - $i );
    }
    $self->$colour;
}

# ============================================================================
# deep_clone
# ============================================================================

=head2 clone 

deep clones object using Storable, except for the canvas, which should stay the same

=back

=cut

# -----------------------------------------------------------------------------

sub deep_clone {
    my $self   = shift;
    my $copy = {};
    bless $copy, ref($self);
    foreach my $key (keys %$self) {
        if ($key eq '-cn') {
            $copy->{-cn} = $self->{-cn}
        }
        else {
            $copy->{$key} = Storable::dclone($self->{$key});
        }
    }
}

# ============================================================================
# _set_colour
# ============================================================================
sub _set_colour {
    my $self   = shift;
    my $opt    = shift;  # -fill, -outline
    my $colour = shift;  # what colour
    
    my $cn     = $self->canvas;
    my @cs;
    if (exists $colour{$colour}) {
        @cs     = @{ $colour{$colour} };
    }
    else {
        @cs = ($colour,$colour,$colour,$colour,$colour);
    }
    
    # go through the canvas objects that draw the shape, and colour
    # each one accordingly
    my $i      = 0;
    foreach my $obj ( $self->cn_objects ) {
        $cn->itemconfigure( $obj, $opt => $cs[ -( 4 - $i ) ] );
        $i++;
    }
    
    # if it is being greyed out, hide label, and push it to the bottom
    # of the layers
    $self->_hide_label() if $colour eq "grey";
    $self->lower()       if $colour eq "grey";

    # if colour is not grey, then reset the label, if there was one
    if ( $self->label_is && $colour ne "grey" ) {
        $self->label( $self->label_is, $self->label_where );
    }
    
    # rais it to the top to the top of the layers if it is normal colour
    $self->raise() if $colour eq "normal";
    
    # set the colour property of this object
    $self->{-colour} = $colour;
    
    # update Tk window
    $cn->update;
    
    # return calling object
    return $self;
}

# ============================================================================
# _bind_notice
#    --- create the proper bindings so that clicking the object will
#        cause it to grow large and red momentarily
#    --- also changes the cursor if it hovers over the shape
# ============================================================================
sub _bind_notice {
    my $self = shift;
    my $cn   = $self->canvas;
    my $cursor;

    foreach my $o ( $self->cn_objects ) {

        $cn->bind( $o, "<Button-1>", sub { $self->notice(); } );
        $cn->bind(
            $o,
            "<Enter>",
            sub {
                $cursor = $cn->cget( -cursor ) || '';
                my @point = split " ", $cursor;
                $point[2] = "darkred";
                $point[3] = "lightpink";
                $cn->configure( -cursor => [@point] ) if $point[1];
            }
        );
        $cn->bind( $o, "<Leave>", sub { $cn->configure( -cursor => $cursor ) } );
    }
}

# ============================================================================
# _unbind_notice
#    --- removes the binding from _bind_notice
# ============================================================================
sub _unbind_notice {
    my $self = shift;
    my $cn   = $self->canvas;
    my $cursor;

    foreach my $o ( $self->cn_objects ) {
        $cn->bind( $o, "<Button-1>", sub{} );
        $cn->bind( $o, "<Enter>",    sub{} );
        $cn->bind( $o, "<Leave>",    sub{} );
    }
}

# ============================================================================
# _hide_label
#    --- removes the label from the canvas, but keeps info as part of 
#        the shape object so that it can be redrawn later
# ============================================================================
sub _hide_label {
    my $self = shift;
    
    my $l    = $self->{-label};
    my $cn   = $self->canvas;
    
    if ($l) {

        # turn the label into an arry if it doesn't already exist as an array
        if ( ref($l) ne "ARRAY" ) {
            $l = [$l];
        }

        # loop over all label references
        foreach my $ll (@$l) {
            
            # if it is an object, delete it
            if ( ref($ll) ) {
                $ll->delete;
            }
            
            # if it is a canvas object, delete it
            else {
                $cn->delete($ll);
            }
        }

    }
    
    # update label info
    $self->{-label} = undef;
    $cn->update;

}

# ============================================================================
# _draw_label
# ============================================================================
sub _draw_label {

    my $self = shift;
    my $cn   = shift;

    # input set: [x,y,text,location]
    
    # convert input into an array or arrays
    my @input;
    if ( ref( $_[0] ) eq "ARRAY" ) {
        push @input, @_;
    }
    else {
        @input = ( [@_] );
    }

    # if more than one set (Gnomon's have 3 text labels for exampe)
    # it is necessary to keep track of the entire "text"
    # so concatenate for "storage" purposes
    my $text;
    foreach my $set (@input) {
        $text .= $set->[2] if $set->[2];
    }

    # do we really need to redraw?
    $self->_hide_label();
    return $self unless $text;
    
    
    $self->{"Shape::what"} = "";

    foreach my $set (@input) {

        my $x     = shift @$set;
        my $y     = shift @$set;
        my $what  = shift @$set;
        my $where = shift(@$set) || $self->label_where || 'right';

        my $t;

        if ( lc($where) eq 'exactly' ) {
            $t = $cn->createText( $x, $y, -text => $what, -anchor => "c" );
        }
        elsif ( lc($where) eq 'right' ) {
            $t = $cn->createText( $x + 15, $y-15, -text => $what, -anchor => "nw" );
        }
        elsif ( lc($where) eq 'left' ) {
            $t = $cn->createText( $x - 15, $y-15, -text => $what, -anchor => "ne" );
        }
        elsif ( lc($where) eq 'top' ) {
            $t = $cn->createText( $x, $y - 35, -text => $what, -anchor => "n" );
        }
        elsif ( lc($where) eq 'topleft' ) {
            $t = $cn->createText( $x - 15, $y - 35, -text => $what, -anchor => "ne" );
        }
        elsif ( lc($where) eq 'topright' ) {
            $t = $cn->createText( $x + 15, $y - 35, -text => $what, -anchor => "nw" );
        }
        elsif ( lc($where) eq 'bottomleft' ) {
            $t = $cn->createText( $x - 15, $y , -text => $what, -anchor => "ne" );
        }
        elsif ( lc($where) eq 'bottomright' ) {
            $t = $cn->createText( $x + 15, $y , -text => $what, -anchor => "nw" );
        }
        else {
            $t = $cn->createText( $x, $y + 7, -text => $what, -anchor => "n" );
        }
        push @{ $self->{-label} }, $t;
        $self->{"Shape::what"}  .= $what;
        $self->{"Shape::where"} = $where;
    }
    $cn->update;
    return $self;
}

=head1 AUTHOR

Sandy Bultena

=head1 COPYRIGHT

This module is copyright (c) 2015 Sandy Bultena. All rights reserved.

This library is free software; you may redistribute and/or modify it under 
the terms of either the GNU General Public License 
or the Perl Artistic License, as specified in the Perl 5.10.0 README file.

=cut


1;

