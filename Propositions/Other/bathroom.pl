#!/usr/bin/perl 
use strict;
use warnings;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;
use Colour;

my $pn = PropositionCanvas->new;
Proposition::init($pn);
$Shape::DefaultSpeed = 20;

# ============================================================================
# Basic Dimensions
# ============================================================================

my $t1 = $pn->text_box( 800, 150, -width => 500 );
my $t2 = $pn->text_box( 800, 200 );
my $t3 = $pn->text_box( 600, 160 );
my $t4 = $pn->text_box( 700, 160 );
my $sep = 5;

my $scale  = 7;
my $offset = 60;
my $version = 1;

my $steps = explanation($pn);
$pn->define_steps($steps);
$pn->go;

# ============================================================================
# Design
# ============================================================================
sub explanation {
    my $width        = 66;
    my $height       = 92;
    my $inset_width  = 20;
    my $inset_height = 32;
    my $door_arc;
    my $door_line;

    my %stuff;

    # -----------------------------------------------------------------
    # walls
    # -----------------------------------------------------------------
    my @points = (
                   $inset_width,                     0,
                   $inset_width + $width, 0,
                   $inset_width + $width, $height,
                   $inset_width,          $height,
                 );
    my $num = @points / 2;
    my @room_coords = map { $_ * $scale + $offset } @points;
    my @old_wall_coords =
      map { $_ * $scale + $offset }
      ( $inset_width, 0, $inset_width, $inset_height );

    # -----------------------------------------------------------------
    # stack
    # -----------------------------------------------------------------
    my $radius_stack = 3;
    my $x_stack      = 6 + $inset_width;
    my $y_stack      = -3;

    # -----------------------------------------------------------------
    # door
    # -----------------------------------------------------------------
    my $door_width = 28;

    # -----------------------------------------------------------------
    # toilet space
    # -----------------------------------------------------------------
    my $toilet_w = 24;
    my $toilet_l = 30;
    my @toilet_v = ( 0, 0, 0, $toilet_l, $toilet_w, $toilet_l, $toilet_w, 0 );
    my @toilet_h = ( 0, 0, 0, $toilet_w, $toilet_l, $toilet_w, $toilet_l, 0 );

    # -----------------------------------------------------------------
    # vanity
    # -----------------------------------------------------------------
    my $vanity_width = 31;
    my $vanity_depth = 19;

    # -------------------------------------------------------------------------
    # Basic Layout
    # -------------------------------------------------------------------------
    push @$steps, sub {
        my $l = Polygon->new( $pn, $num, @room_coords );
        $l->l(2)->label("$height".'"');
        $l->l(3)->label("$width".'"',"bottom");
        my @p = place(4+$inset_width,$height+0.5,[0,0,$door_width,0]);
        $door_line = Line->new( $pn, @p );
    };

    # -------------------------------------------------------------------------
    # Original 1
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # toilet
        my @toilet_coords = place( $inset_width, 0, \@toilet_v );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'n', \@toilet_coords );
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 5,
                        place(
                               $inset_width + $width,
                               0, [ 0, 0, 0, 36, -18, 36, -36, 18, -36, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x36");

        my @vanity_coords = place(
                                   $inset_width + $width,
                                   $height,
                                   [
                                      0,              0,
                                      -$vanity_depth, 0,
                                      -$vanity_depth, -$vanity_width,
                                      0,              -$vanity_width
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

    };

    # -------------------------------------------------------------------------
    # Final
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Final Version ");

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }

        #vanity
        my @vanity_coords = place(
                                   $inset_width+3,0,
                                   [
                                      0,              0,
                                      24, 0,
                                      24, $vanity_depth,
                                      0,              $vanity_depth
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->
          label("Vanity\n$vanity_depth"."x".24);

        # toilet
        my @toilet_coords = place(
                               $inset_width + $width - $toilet_l,
                               $height - $toilet_w-3,
                               \@toilet_h
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'w', \@toilet_coords );


        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               0,
                               [ 0, 0, 0, 60, -36, 60, -36, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x60");

    };

    
    # -------------------------------------------------------------------------
    # shower in back 2
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }

        # old wall
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        #vanity
        my @vanity_coords = place(
                                   $inset_width + $width,
                                   $height,
                                   [
                                      0,              0,
                                      -$vanity_depth, 0,
                                      -$vanity_depth, -$vanity_width,
                                      0,              -$vanity_width
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width + $width - $toilet_l,
                               $height - $vanity_width - $toilet_w,
                               \@toilet_h
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'w', \@toilet_coords );

        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               -4,
                               [ 0, 0, 0, 36, -60, 36, -60, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x60");

    };

    # -------------------------------------------------------------------------
    # shower on side 3
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }

        # old wall
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        #vanity
        my @vanity_coords = place(
                                   $inset_width + $width,
                                   $height,
                                   [
                                      0,              0,
                                      -$vanity_depth, 0,
                                      -$vanity_depth, -$vanity_width,
                                      0,              -$vanity_width
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place( $inset_width, 0, \@toilet_v );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'n', \@toilet_coords );
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               0,
                               [ 0, 0, 0, 54, -36, 54, -36, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x54");

    };

    # -------------------------------------------------------------------------
    # shower in back toilet left, vanity right 4
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }
        
        # old wall
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        #vanity
        my @vanity_coords = place(
                                   $inset_width + $width,
                                   $height,
                                   [
                                      0,              0,
                                      -$vanity_depth, 0,
                                      -$vanity_depth, -$vanity_width,
                                      0,              -$vanity_width
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width ,
                               36,
                               \@toilet_h
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'e', \@toilet_coords );

        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               0,
                               [ 0, 0, 0, 36, -64, 36, -64, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x64");

    };

    # -------------------------------------------------------------------------
    # shower in back toilet left, vanity front 5
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }
        
        # old wall
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        #vanity
        my @vanity_coords = place(
                                   $inset_width + $width,
                                   $height,
                                   [
                                      0,              0,
                                      -$vanity_width, 0,
                                      -$vanity_width, -$vanity_depth,
                                      0,              -$vanity_depth
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width ,
                               36,
                               \@toilet_h
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'e', \@toilet_coords );

        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               0,
                               [ 0, 0, 0, 36, -64, 36, -64, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x64");

    };

    # -------------------------------------------------------------------------
    # using cubby with toilet in front 6
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }

        #vanity
        my @vanity_coords = place(
                                   0,0,
                                   [
                                      0,              0,
                                      $vanity_depth, 0,
                                      $vanity_depth, $vanity_width,
                                      0,              $vanity_width
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width + $width - $toilet_l,
                               $height - $toilet_w,
                               \@toilet_h
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'w', \@toilet_coords );


        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               0,
                               [ 0, 0, 0, 60, -36, 60, -36, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x60");

    };

    # -------------------------------------------------------------------------
    # using cubby with toilet in back 7
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }

        #vanity
        my @vanity_coords = place(
                                   0,0,
                                   [
                                      0,              0,
                                      $vanity_depth, 0,
                                      $vanity_depth, $vanity_width,
                                      0,              $vanity_width
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width + $width - $toilet_l,
                               0,
                               \@toilet_h
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'w', \@toilet_coords );


        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               $height-60,
                               [ 0, 0, 0, 60, -36, 60, -36, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x36");

    };

    # -------------------------------------------------------------------------
    # shower in back with sliding door 8
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }
        
        # remove door
        $door_arc->remove;
        $door_line->remove;
        
        # add sliding door
        $door_line = Line->new($pn,place($inset_width+4,.5+$height,[0,0,$door_width,0]));

        # old wall
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        #vanity
        my @vanity_coords = place(
                                   $inset_width,
                                   32,
                                   [
                                      0,              0,
                                      $vanity_width, 0,
                                      $vanity_width, $vanity_depth,
                                      0,              $vanity_depth
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width + $width - $toilet_l,
                               $height - $toilet_w,
                               \@toilet_h
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'w', \@toilet_coords );

        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               -4,
                               [ 0, 0, 0, 36, -64, 36, -64, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x64");

    };

    # -------------------------------------------------------------------------
    # shower in back with sliding door 9
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }
        
        # remove door
        $door_arc->remove;
        $door_line->remove;
        
        # add sliding door
        $door_line = Line->new($pn,place($inset_width+4,.5+$height,[0,0,$door_width,0]));

        # old wall
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        #vanity
        my @vanity_coords = place(
                                   $inset_width,
                                   32,
                                   [
                                      0,              0,
                                      $vanity_width, 0,
                                      $vanity_width, $vanity_depth,
                                      0,              $vanity_depth
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width + $width - $toilet_w,
                               $height - $toilet_l,
                               \@toilet_v
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 's', \@toilet_coords );

        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               -4,
                               [ 0, 0, 0, 36, -64, 36, -64, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x64");

    };

    # -------------------------------------------------------------------------
    # shower in back with sliding - toilet back, vanity front
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }
        
        # remove door
        $door_arc->remove;
        $door_line->remove;
        
        # add sliding door
        $door_line = Line->new($pn,place($inset_width+4,.5+$height,[0,0,$door_width,0]));

        # old wall
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        #vanity
        my @vanity_coords = place(
                                   $inset_width + $width,
                                   $height,
                                   [
                                      0,              0,
                                      -$vanity_depth, 0,
                                      -$vanity_depth, -$vanity_width,
                                      0,              -$vanity_width
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width ,
                               36-4,
                               \@toilet_v
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'n', \@toilet_coords );

        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               -4,
                               [ 0, 0, 0, 36, -64, 36, -64, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x64");

    };

    # -------------------------------------------------------------------------
    # shower in back toilet right, vanity left horizontal
    # -------------------------------------------------------------------------
    push @$steps, sub {
        
        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }
        
        # old wall
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        #vanity
        my @vanity_coords = place(
                                   $inset_width ,
                                   36,
                                   [
                                      0,              0,
                                      $vanity_depth, 0,
                                      $vanity_depth, $vanity_width,
                                      0,              $vanity_width
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width + $width - $toilet_w,
                               $height - $toilet_l,
                               \@toilet_v
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 's', \@toilet_coords );

        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               0,
                               [ 0, 0, 0, 36, -64, 36, -64, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x64");

    };

    # -------------------------------------------------------------------------
    # shower in back toilet left, vanity front
    # -------------------------------------------------------------------------
    push @$steps, sub {

        $t2->erase;
        $t2->title("Version ".$version);
        $version++;
        $t2->math("Toilet space");
        $t2->math($toilet_l . "x". $toilet_w);

        # erase previous shit
        foreach my $stuff ( @{ $stuff{original} } ) {
            $stuff->remove;
        }
        
        # remove door
        $door_arc->draw;
        $door_line->remove;
        
        # add sliding door
        $door_line = Line->new($pn,place($inset_width+4,.5+$height,[0,0,$door_width,0]));

        # old wall
        push @{ $stuff{original} }, Line->new( $pn, @old_wall_coords );

        #vanity
        my @vanity_coords = place(
                                   $inset_width + $width,
                                   $height,
                                   [
                                      0,              0,
                                      -$vanity_depth, 0,
                                      -$vanity_depth, -$vanity_width,
                                      0,              -$vanity_width
                                   ]
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @vanity_coords )->fill("#cdefab")->label("Vanity\n$vanity_depth"."x".$vanity_width);

        # toilet
        my @toilet_coords = place(
                               $inset_width ,
                               36,
                               \@toilet_h
                                 );
        push @{ $stuff{original} },
          Polygon->new( $pn, 4, @toilet_coords )->grey;
        push @{ $stuff{original} }, draw_toilet( $pn, 'e', \@toilet_coords );

        # shower stall
        push @{ $stuff{original} },
          Polygon->new(
                        $pn, 4,
                        place(
                               $inset_width + $width,
                               0,
                               [ 0, 0, 0, 36, -64, 36, -64, 0 ]
                             )
                      )->fill("#abcdef")->label("Shower\n36x64");

    };


    return $steps;

}

# ============================================================================
# create coords after placing
# ============================================================================
sub place {
    my $xinit = shift;
    my $yinit = shift;
    my $input = shift || [];
    my @output;
    foreach my $i ( 1 .. @$input / 2 ) {
        my $x = $input->[ 0 + 2 * ( $i - 1 ) ];
        my $y = $input->[ 1 + 2 * ( $i - 1 ) ];
        push @output, $x * $scale + $offset + $xinit * $scale;
        push @output, $y * $scale + $offset + $yinit * $scale;
    }
    return @output;
}

# ============================================================================
# Draw toilet
# ============================================================================
sub draw_toilet {
    my $pn   = shift;
    my $nsew = shift || 'n';
    my $ps   = shift || [];
    my @ps   = @$ps;
    my $l1   = $ps->[4] - $ps->[0];
    my $l2   = $ps->[3] - $ps->[1];

    #horizontal
    if ( abs($l1) > abs($l2) ) {
        $nsew = 'w' if ( $nsew !~ /[we]/i );
    }

    #vertical
    else {
        $nsew = 's' if ( $nsew !~ /[ns]/i );
    }

    # dimensions
    my @tank;
    my @outer;
    my @inner;
    if ( $nsew eq 'n' ) {
        @tank = (
                  $ps[0] + 1 / 8 * $l1,
                  $ps[1] + 1 / 8 * $l2,
                  $ps[0] + 7 / 8 * $l1,
                  $ps[1] + 1 / 8 * $l2,
                  $ps[0] + 7 / 8 * $l1,
                  $ps[1] + 1 / 3 * $l2,
                  $ps[0] + 1 / 8 * $l1,
                  $ps[1] + 1 / 3 * $l2
                );

        @outer = (
                   $ps[0] + 1 / 8 * $l1,
                   $ps[1] + 1 / 3 * $l2,
                   $ps[0] + 7 / 8 * $l1,
                   $ps[3]
                 );

        @inner = (
                   $outer[0] + ( 1 / 5 ) * ( $outer[2] - $outer[0] ),
                   $outer[1] + ( 1 / 5 ) * ( $outer[3] - $outer[1] ),
                   $outer[2] - ( 1 / 5 ) * ( $outer[2] - $outer[0] ),
                   $outer[3] - ( 1 / 5 ) * ( $outer[3] - $outer[1] ),
                 );
    }

    if ( $nsew eq 's' ) {
        print "drawing toilet south\n";
        @tank = (
                  $ps[0] + 1 / 8 * $l1,
                  $ps[1] + 2 / 3 * $l2,
                  $ps[0] + 7 / 8 * $l1,
                  $ps[1] + 2 / 3 * $l2,
                  $ps[0] + 7 / 8 * $l1,
                  $ps[1] + 7 / 8 * $l2,
                  $ps[0] + 1 / 8 * $l1,
                  $ps[1] + 7 / 8 * $l2
                );

        @outer = (
                   $ps[0] + 1 / 8 * $l1,
                   $ps[1] +0  * $l2,
                   $ps[0] + 7 / 8 * $l1,
                   $ps[1] + 2/3 * $l2,
                 );

        @inner = (
                   $outer[0] + ( 1 / 5 ) * ( $outer[2] - $outer[0] ),
                   $outer[1] + ( 1 / 5 ) * ( $outer[3] - $outer[1] ),
                   $outer[2] - ( 1 / 5 ) * ( $outer[2] - $outer[0] ),
                   $outer[3] - ( 1 / 5 ) * ( $outer[3] - $outer[1] ),
                 );
    }

    if ( $nsew eq 'w' ) {
        @tank = (
                  $ps[0] + 2 / 3 * $l1,
                  $ps[1] + 1 / 8 * $l2,
                  $ps[0] + 7 / 8 * $l1,
                  $ps[1] + 1 / 8 * $l2,
                  $ps[0] + 7 / 8 * $l1,
                  $ps[1] + 7 / 8 * $l2,
                  $ps[0] + 2 / 3 * $l1,
                  $ps[1] + 7 / 8 * $l2
                );

        @outer = (
                   $ps[0],
                   $ps[1] + 1 / 8 * $l2,
                   $ps[0] + 2 / 3 * $l1,
                   $ps[1] + 7 / 8 * $l2
                 );

        @inner = (
                   $outer[0] + ( 1 / 5 ) * ( $outer[2] - $outer[0] ),
                   $outer[1] + ( 1 / 5 ) * ( $outer[3] - $outer[1] ),
                   $outer[2] - ( 1 / 5 ) * ( $outer[2] - $outer[0] ),
                   $outer[3] - ( 1 / 5 ) * ( $outer[3] - $outer[1] ),
                 );

    }
    if ( $nsew eq 'e' ) {
        @tank = (
                  $ps[0] + 1 / 8 * $l1,
                  $ps[1] + 1 / 8 * $l2,
                  $ps[0] + 1/3 * $l1,
                  $ps[1] + 1 / 8 * $l2,
                  $ps[0] + 1/3 * $l1,
                  $ps[1] + 7 / 8 * $l2,
                  $ps[0] + 1 / 8 * $l1,
                  $ps[1] + 7 / 8 * $l2
                );

        @outer = (
                   $ps[0] + 1/3 * $l1,
                   $ps[1] + 1 / 8 * $l2,
                   $ps[0] + 1 * $l1,
                   $ps[1] + 7 / 8 * $l2
                 );

        @inner = (
                   $outer[0] + ( 1 / 5 ) * ( $outer[2] - $outer[0] ),
                   $outer[1] + ( 1 / 5 ) * ( $outer[3] - $outer[1] ),
                   $outer[2] - ( 1 / 5 ) * ( $outer[2] - $outer[0] ),
                   $outer[3] - ( 1 / 5 ) * ( $outer[3] - $outer[1] ),
                 );

        }


    # draw toilet
    my @objs;
    use Data::Dumper;
    print Dumper "tank", \@tank, "outer", \@outer;
    push @objs, Polygon->new( $pn, 4, @tank );
    push @objs, Oval->new( $pn, @outer );
    push @objs, Oval->new( $pn, @inner );

    # return objects
    return @objs;

}

