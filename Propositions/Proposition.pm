#!/usr/bin/perl
use strict;
use warnings;

package Proposition;
require Proposition_tocs;

use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Colour;

my $year = "2021";
my $copyright_msg = "Copyright $year by Sandy Bultena";


require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw($sky_blue $lime_green $pale_pink $blue $pink $pale_yellow
  $turquoise $green $teal $tan $purple
  $yellow $orange);
my $package = shift;
our $sky_blue    = "#b3e6ff";
our $lime_green  = "#ccffcc";
our $pale_pink   = "#ffcce0";
our $pale_yellow = "#ffffcc";
our $turquoise   = "#abefcd";

our $green = Colour->darken( 5, $lime_green );
our $blue   = Colour->add( $sky_blue,    $sky_blue );
our $teal   = Colour->add( $blue,        $lime_green );
our $pink   = Colour->add( $pale_pink,   $pale_pink );
our $tan    = Colour->add( $lime_green,  $pale_pink );
our $purple = Colour->add( $sky_blue,    $pale_pink );
our $yellow = Colour->add( $pale_yellow, $pale_yellow );
our $orange = Colour->add( $pale_yellow, $pale_pink );
my $self;
my $pn_dir;
my $pn;

# ============================================================================
# init
# ============================================================================
# - setup stuff for standardizing the options for display of propositions
# ----------------------------------------------------------------------------

sub init {
    $pn = shift;

    $self->{-pn} = $pn;
    my $mw = $pn->mw();

    # set animation by default (or not)
    set_animation(0);

    # create the copyright pics
    foreach my $lib ( keys %INC ) {
        if ( $lib =~ /Proposition.pm/ ) {
            $pn_dir = $INC{$lib};
            $pn_dir =~ s/^(.*)\/Proposition.pm/$1/;
            $self->{-cc} = $mw->Photo( -file => "$pn_dir/cc.gif" );
            $pn->set_image( "image1", "$pn_dir/cc.gif" );
            $self->{-cctext} = $mw->Photo( -file => "$pn_dir/cctext.gif" );
            $pn->set_image( "image2", "$pn_dir/cctext.gif" );
            $self->{-cclarge} = $mw->Photo( -file => "$pn_dir/cc_large.gif" );
            $pn->set_image( "image3", "$pn_dir/cc_large.gif" );
        }
    }

    # define the copyright sub
    $PropositionCanvas::CopyRight = sub {
        my $cn = $pn->Tk_canvas;
        $cn->createImage( 25, 710, -image => $self->{-cc}, -anchor => 'nw' );
        $cn->createText(
                         25, 750,
                         -text   => $copyright_msg,
                         -anchor => 'nw',
                         -fill => 'black',
        );
    };
}

sub set_animation {
    my $bool = shift || 0;
    my $pn = $self->{-pn};
    $pn->set_animatable($bool);

    if ($bool) {
        Shape->set_ani_speed();
        Shape->set_default_speed();
        Shape->set_shape_animation(1);
    }
    else {
        Shape->set_shape_animation(0);
    }

}

# ============================================================================
# play the individual steps.
# ============================================================================

my %subs = (
    I    => { -toc => \&toc,   -title_page => \&title_page },
    II   => { -toc => \&toc2,  -title_page => \&title_page2 },
    III  => { -toc => \&toc3,  -title_page => \&title_page3 },
    IV   => { -toc => \&toc4,  -title_page => \&title_page4 },
    V    => { -toc => \&toc5,  -title_page => \&title_page5 },
    VI   => { -toc => \&toc6,  -title_page => \&title_page6 },
    VII  => { -toc => \&toc7,  -title_page => \&title_page7 },
    VIII => { -toc => \&toc8,  -title_page => \&title_page8 },
    IX   => { -toc => \&toc9,  -title_page => \&title_page9 },
    X    => { -toc => \&toc10, -title_page => \&title_page10 },
    XI   => { -toc => \&toc11, -title_page => \&title_page11 },
    XII  => { -toc => \&toc12, -title_page => \&title_page12 },
    XIII => { -toc => \&toc13, -title_page => \&title_page13 },

);

sub play {
    my $pn       = shift;
    my %options  = (@_);
    my $book     = $options{-book};
    my $steps_fn = $options{-steps};
    my $title    = $options{-title};
    my $number   = $options{-number};
    $pn->title( $number, $title, $book );

    my $steps;
    push @$steps, $subs{$book}{-title_page}->($pn);
    push @$steps, $subs{$book}{-toc}->( $pn, $number );
    push @$steps, Proposition::reset();
    push @$steps, @{$steps_fn->($pn)};
    push @$steps, sub { last_page() };
    $pn->define_steps($steps);
    $pn->copyright();
    $pn->go();
}

# ============================================================================
# last page
# ============================================================================
# create a standardized 'last-page' to be used by the display of the propositions
sub last_page {

    my $list = prev_next();

    my $cn = $pn->Tk_canvas;
    $pn->clear();
    my $packageCanvas = ref($pn);
    no strict "refs";
    my $isPDF = ${ "$packageCanvas" . "::PDF" };
    use strict;
    if ( !$isPDF ) {
        $cn->createText(
                         700, 110,
                         -text => "Reference:",
                         -font => 'title',
                         -fill => 'black'
        );
        $cn->createText(
              700, 150,
              -text =>
                "Euclid's Elements - all thirteen books complete in one volume",
              -font => 'title',
              -fill => 'black',
        );
        $cn->createText(
              700, 180,
              -text => "The Thomas L Heath Translation,  Dana Densmore, Editor",
              -font => 'explain',
              -fill => 'black',
        );
        $cn->createText(
                         700, 210,
                         -text => "Green Lion Press (c) 2013",
                         -font => 'explain',
                         -fill => 'black',
        );
        $cn->createText(
                         700, 240,
                         -text => "ISBN 978-1-888009-19-4",
                         -font => 'explain',
                         -fill => 'black',
        );
        $cn->createText(
                         700, 325,
                         -text => " ",
                         -font => 'explain',
                         -fill => 'black',
        );

        if (1) {
            use Cwd qw(abs_path);
            my $next_text = $list->{ abs_path($0) }->{next_text} || '';
            my $next      = $list->{ abs_path($0) }->{next}      || '';
            my $prev_text = $list->{ abs_path($0) }->{prev_text} || '';
            my $prev      = $list->{ abs_path($0) }->{prev}      || '';
            my $p = $cn->createLine(
                                     200, 450, 400, 450,
                                     -width => 40,
                                     -arrow => 'first',
                                     -fill  => "#ddddee"
            );
            my $n = $cn->createLine(
                                     1000, 450, 1200, 450,
                                     -width => 40,
                                     -arrow => 'last',
                                     -fill  => "#ddddee"
            );
            $cn->createText(
                             300, 450,
                             -text => "Previous",
                             -font => 'explain',
                             -fill => 'black',
            );
            $cn->createText(
                             1100, 450,
                             -text => "Next",
                             -font => 'explain',
                             -fill => 'black',
            );
            $cn->createText(
                             1100, 500,
                             -text => "$next_text",
                             -font => 'explain',
                             -fill => 'black',
            );
            $cn->createText(
                             300, 500,
                             -text => "$prev_text",
                             -font => 'explain',
                             -fill => 'black',
            );
            $cn->bind(
                $n,
                "<Button-1>",
                sub {
                    $cn->toplevel->update;
                    if ( -e $next ) {
                        exec( "perl", $next );
                        die;
                        exit;
                    }
                }
            );
            $cn->bind(
                $n,
                "<Enter>",
                sub {
                    $cn->itemconfigure( $n, -fill => "#bbbbcc" );
                }
            );
            $cn->bind( $n, "<Leave>",
                       sub { $cn->itemconfigure( $n, -fill => "#ddddee" ) } );

            $cn->bind(
                $p,
                "<Button-1>",
                sub {
                    if ($prev) { exec( "perl", $prev ); die }
                    exit;
                }
            );
            $cn->bind(
                $p,
                "<Enter>",
                sub {
                    $cn->itemconfigure( $p, -fill => "#bbbbcc" );
                }
            );
            $cn->bind( $p, "<Leave>",
                       sub { $cn->itemconfigure( $p, -fill => "#ddddee" ) } );

        }
    }

    else {
        $cn->createText(
                         700, 150,
                         -text => "Youtube Videos",
                         -font => 'title',
                         -fill => 'black',
        );
        $cn->createText(
                         700, 200,
                         -text => "https://www.youtube.com/c/SandyBultena",
                         -font => 'explain',
                         -fill => 'black',
        );

    }

    my $cc_font =
      $cn->toplevel->fontCreate( 'cc_font', -family => 'Arial', -size => 28 );
    $cn->createImage( 300, 700, -image => $self->{-cclarge} );
    $cn->createText(
          800, 700,
          -text => "Except where otherwise noted, this work is licensed under\n"
            . "http://creativecommons.org/licenses/by-nc/3.0",
          -font => 'cc_font',
          -fill => 'black',
    );
    $cn->createText(
                     700, 600,
                     -text => $copyright_msg,
                     -font => 'signature',
                     -fill => 'black',
    );
    $cn->createText(
                     700, 650,
                     -text => " ",
                     -font => 'explain',
                     -fill => 'black',
    );
}

sub reset {
    my $pn = $self->{-pn};
    return sub {
        $pn->clear();
        if ( exists $pn->{-title} && exists $pn->{-number} ) {
            $pn->title( $pn->{-number}, $pn->{-title}, $pn->{-book} );
        }
      }
}

# ============================================================================
# Title Page for Book 1
# ============================================================================
sub title_page {
    my $pn = $self->{-pn};
    return (
        sub {
            local $Shape::AniSpeed = .01 * $Shape::AniSpeed;
            $pn->clear();
            my ( $x, $y ) = $pn->center_coords();
            my $cn = $pn->Tk_canvas();
            $cn->createText(
                             $x + 50, $y - 300,
                             -text => "Euclid's Elements",
                             -font => "intro",
                             -fill => 'black',
            );
            $cn->createText(
                             $x + 50, $y - 200,
                             -text => "Book I",
                             -font => "intro",
                             -fill => 'black',
            );

            pythagorus($pn);
            my ( $xc, $yc ) = $pn->center_coords();
            my $t2 =
              $pn->text_box( $xc, $yc - 100, -anchor => "w", -width => 550 );
            $t2->fancy(   "If Euclid did not kindle your youthful enthusiasm, "
                        . "you were not born to be a scientific thinker." );
            $t2->explain("       Albert Einstein");

        },

    );

}

# ============================================================================
# Title Page for Book 2
# ============================================================================
sub title_page2 {
    my $pn = $self->{-pn};
    return (
        sub {
            local $Shape::AniSpeed = .01 * $Shape::AniSpeed;
            $pn->clear();
            my ( $x, $y ) = $pn->center_coords();
            my $cn = $pn->Tk_canvas();
            $cn->createText(
                             $x + 50, $y - 300,
                             -text => "Euclid's Elements",
                             -font => "intro",
                             -fill => 'black',
            );
            $cn->createText(
                             $x + 50, $y - 200,
                             -text => "Book II",
                             -font => "intro",
                             -fill => 'black',
            );

            square_polygon($pn);
            my ( $xc, $yc ) = $pn->center_coords();
            my $t2 =
              $pn->text_box( $xc, $yc - 100, -anchor => "w", -width => 600 );
            $t2->fancy( "It is a remarkable fact in the history of geometry, "
                . "that the Elements of Euclid, "
                . "written two thousand years ago, are still regarded by many as the best "
                . "introduction to the mathematical sciences." );
            $t2->explain("     Florian Cajori, ");
            $t2->explain("     A History of Mathematics (1893)");
            $t2->down();
            $t2->bold("Definitions: ");
            $t2->explain(   "Any rectangular parallelogram is said to "
                          . "be contained by the two straight "
                          . "lines containing the right angle." );
            $t2->explain(
                    "And in any parallelogrammic area let any one whatever of "
                  . "the parallelograms about its diameter with the two complements "
                  . "be called a gnomon." );

            # 517, 667, 617,667
            my $para =
              Polygon->new( $pn, 4, 450, 700, 600, 700, 650, 600, 500, 600 );
            my $gnomon = Polygon->new(
                                       $pn, 6,   450, 700, 600, 700, 617, 667,
                                       517, 667, 550, 600, 500, 600
            )->fill($sky_blue);
            my $diag = Line->new( $pn, 450, 700, 650, 600 );
            my $l1   = Line->new( $pn, 500, 700, 550, 600 );
            my @cross = $l1->intersect($diag);
            my $l2    = $para->l(1)->parallel( Point->new( $pn, @cross ) );
            my $l3    = Line->new( $pn,
                                $l2->intersect( $para->l(4) ),
                                $l2->intersect( $para->l(2) ) );
            $l2->remove;

            my $ar1 = Line->new( $pn, 650, 660, 690, 660 );
            my $ar2 = Line->new( $pn, 650, 660, 660, 650 );
            my $ar3 = Line->new( $pn, 650, 660, 660, 670 );

        },
    );

}

# ============================================================================
# Title Page for Book 3
# ============================================================================
sub title_page3 {
    my $pn = $self->{-pn};
    return (
        sub {
            local $Shape::AniSpeed = .01 * $Shape::AniSpeed;
            $pn->clear();
            my ( $x, $y ) = $pn->center_coords();
            my $cn = $pn->Tk_canvas();
            $cn->createText(
                             $x + 50, $y - 300,
                             -text => "Euclid's Elements",
                             -font => "intro",
                             -fill => 'black',
            );
            $cn->createText(
                             $x + 50, $y - 200,
                             -text => "Book III",
                             -font => "intro",
                             -fill => 'black',
            );

            my ( $xc, $yc ) = $pn->center_coords();
            my $t2 =
              $pn->text_box( $xc, $yc - 100, -anchor => "w", -width => 580 );
            $t2->fancy(
                "A circle is a round straight line with a hole in the middle.");
            $t2->bold("     Mark Twain ");
            $t2->explain(   "      quoting a schoolchild in " . '"'
                          . "-English as She Is Taught-"
                          . '"' );
            $t2->down();
            $t2->down;
            $t2->fancy(   "If people stand in a circle long enough, "
                        . "they'll eventually begin to dance." );
            $t2->bold("     George Carlin, Napalm and Silly Putty (2001)");

            my ( %l, %p, %c, %s, %a );

            my @c1 = ( 260, 360 );
            my $r1 = 180;
            my @c2 = ( $c1[0] + 80, $c1[1] );
            my $r2 = 140;

            $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );
            $p{E} = Point->new( $pn, @c1 )->label(qw(E bottomleft));
            $p{F} = Point->new( $pn, @c2 )->label(qw(F bottomright));
            $p{A} = $c{A}->point(180)->label( "A", "left" );
            $l{FA} = Line->new( $pn, @c2, $p{A}->coords );
            $p{D} = $c{A}->point(0)->label( "D", "right" );
            $l{FD} = Line->new( $pn, @c2, $p{D}->coords );
            $p{B} = $c{A}->point(140)->label( "B", "left" );
            $l{FB} = Line->new( $pn, @c2, $p{B}->coords );
            $p{C} = $c{A}->point(100)->label( "C", "top" );
            $l{FC} = Line->new( $pn, @c2, $p{C}->coords );
            $p{G} = $c{A}->point(45)->label( "G", "right" );
            $l{FG} = Line->new( $pn, @c2, $p{G}->coords );
            $p{H} = $c{A}->point(-45)->label( "H", "right" );
            $l{FH} = Line->new( $pn, @c2, $p{H}->coords );
            Line->new( $pn, $p{B}->coords, $p{E}->coords );
            Line->new( $pn, $p{C}->coords, $p{E}->coords );
            Line->new( $pn, $p{G}->coords, $p{E}->coords );
            Line->new( $pn, $p{H}->coords, $p{E}->coords );

        },
    );

}

# ============================================================================
# Title Page for Book 4
# ============================================================================
sub title_page4 {
    my $pn = $self->{-pn};
    return (
        sub {
            local $Shape::AniSpeed = .01 * $Shape::AniSpeed;
            $pn->clear();
            my ( $x, $y ) = $pn->center_coords();
            my $cn = $pn->Tk_canvas();
            $cn->createText(
                             $x + 50, $y - 300,
                             -text => "Euclid's Elements",
                             -font => "intro",
                             -fill => 'black',
            );
            $cn->createText(
                             $x + 50, $y - 200,
                             -text => "Book IV",
                             -font => "intro",
                             -fill => 'black',
            );

            my ( $xc, $yc ) = $pn->center_coords();
            my $t2 =
              $pn->text_box( $xc, $yc - 100, -anchor => "w", -width => 400 );
            $t2->explain(
                    "Philosophy (nature) is written in that great book which "
                  . "ever is before our eyes -- I mean the universe -- but we cannot "
                  . "understand it if we do not first learn the "
                  . "language and grasp the symbols in which it is written. The book "
                  . "is written in mathematical language, and the symbols are triangles, "
                  . "circles and other geometrical figures, without whose help it is "
                  . "impossible to comprehend a single word of it - without which one "
                  . "wanders in vain through a dark labyrinth." );

            $t2->down;
            $t2->title("     Galileo Galilei ");

            my ( %l, %p, %c, %s, %a );

            my @c1 = ( 260, 500 );
            my $r1 = 180;

            $c{A} = Circle->new( $pn, @c1, $c1[0] + $r1, $c1[1] );

            $p{A} =
              Point->new( $pn, $c1[0], $c1[1] + $r1 )->label(qw(A bottom));
            $p{D} = Point->new( $pn, $c1[0], $c1[1] - $r1 )->label(qw(D top));
            $p{G} = Point->new( $pn, @c1 )->label( "G", "topright" );
            $l{AD} = Line->join( $p{A}, $p{D} );
            $c{H} = Circle->new( $pn, $p{D}->coords, $p{G}->coords );
            my @p = $c{A}->intersect( $c{H} );
            $p{C} = Point->new( $pn, @p[ 0, 1 ] )->label( "C", "left" );
            $p{E} = Point->new( $pn, @p[ 2, 3 ] )->label( "E", "right" );

            $l{EB} = Line->join( $p{E}, $p{G} )->extend($r1);
            $l{CF} = Line->join( $p{C}, $p{G} )->extend($r1);

            @p = $c{A}->intersect( $l{EB} );
            $p{B} = Point->new( $pn, @p[ 2, 3 ] )->label( "B", "bottomleft" );

            @p = $c{A}->intersect( $l{CF} );
            $p{F} = Point->new( $pn, @p[ 0, 1 ] )->label( "F", "bottomright" );

            $l{DC} = Line->join( $p{D}, $p{C} );
            $l{CB} = Line->join( $p{C}, $p{B} );
            $l{BA} = Line->join( $p{B}, $p{A} );
            $l{AF} = Line->join( $p{A}, $p{F} );
            $l{FE} = Line->join( $p{F}, $p{E} );
            $l{ED} = Line->join( $p{E}, $p{D} );

        },
        sub {
            $pn->clear();
            if ( exists $pn->{-title} && exists $pn->{-number} ) {
                $pn->title( $pn->{-number}, $pn->{-title}, $pn->{-book} );
            }
        }
    );

}

# ============================================================================
# Title Page for Book 5
# ============================================================================
sub title_page5 {
    my $pn = $self->{-pn};
    return (
        sub {
            local $Shape::AniSpeed = .01 * $Shape::AniSpeed;
            $pn->clear();
            my ( $x, $y ) = $pn->center_coords();
            my $cn = $pn->Tk_canvas();
            $cn->createText(
                             $x + 50, $y - 300,
                             -text => "Euclid's Elements",
                             -font => "intro",
                             -fill => 'black',
            );
            $cn->createText(
                             $x + 50, $y - 200,
                             -text => "Book V",
                             -font => "intro",
                             -fill => 'black',
            );

            my ( $xc, $yc ) = $pn->center_coords();
            my $t2 =
              $pn->text_box( $xc, $yc - 100, -anchor => "w", -width => 400 );
            $t2->fancy( "Proportions are what makes the old Greek temples "
                . "classic in their beauty. "
                . "They are like huge blocks, from which the air has been literally hewn "
                . "out between the columns. " );

            $t2->down;
            $t2->title("     Arne Jacobsen ");

            my $down   = 40;
            my $offset = 15;
            my $t1     = $pn->text_box( 800, 150, -width => 580 );
            my $t3     = $pn->text_box( 160, 300 + 4 * $down + $offset );
            my ( %l, %p, %c, %s, %a );
            my $p1 = 2 / 3;
            my $p2 = 1 / 2;
            my $a  = 300;
            my $c  = $a * $p1;
            my $b  = $c * $p2;
            my $d  = 250;
            my $f  = $d * $p1;
            my $e  = $f * $p2;
            my $s  = 150;
            my @A  = ( $s, 300 );
            my @B  = ( $s + $a, $A[1] );
            my @C  = ( $s, $A[1] + $down );
            my @D  = ( $s, $C[1] + $down );
            my @E  = ( $s + $d, $D[1] );
            my @F  = ( $s, $D[1] + $down );
            my @G  = ( $B[0] + $b, $A[1] );
            my @H  = ( $E[0] + $e, $D[1] );

            $p{A} = Point->new( $pn, @A )->label( "A", "top" );
            $p{B} = Point->new( $pn, @B )->label( "B", "top" );
            $p{C} = Point->new( $pn, @C )->label( "C", "top" );
            $p{D} = Point->new( $pn, @D )->label( "D", "top" );
            $p{E} = Point->new( $pn, @E )->label( "E", "top" );
            $p{F} = Point->new( $pn, @F )->label( "F", "top" );
            $p{G} = Point->new( $pn, @G )->label( "G", "top" );
            $p{H} = Point->new( $pn, @H )->label( "H", "top" );

            $l{A} = Line->new( $pn, @A, @G );
            $l{C} = Line->new( $pn, @C, $C[0] + $c, $C[1] );
            $l{D} = Line->new( $pn, @D, @H );
            $l{F} = Line->new( $pn, @F, $F[0] + $f, $F[1] );

            $t3->math("AB:C = DE:F");
            $t3->math("BG:C = EH:F");
            $t3->blue( [ 0, 1 ] );
            $t3->down;
            $t3->math("AG:C = DH:F");
            $t3->blue( [ 0, 1 ] );

        },
    );
}

# ============================================================================
# Title Page for Book 6
# ============================================================================
sub title_page6 {
    my $pn = $self->{-pn};
    return (
        sub {
            $pn->clear();
            my ( $x, $y ) = $pn->center_coords();
            my $cn = $pn->Tk_canvas();
            $cn->createText(
                             $x + 50, $y - 300,
                             -text => "Euclid's Elements",
                             -font => "intro",
                             -fill => 'black',
            );
            $cn->createText(
                             $x + 50, $y - 200,
                             -text => "Book VI",
                             -font => "intro",
                             -fill => 'black',
            );

            my ( $xc, $yc ) = $pn->center_coords();
            my $t2 =
              $pn->text_box( $xc, $yc - 100, -anchor => "w", -width => 400 );
            $t2->fancy(   "One can state, without exaggeration, that the "
                        . "observation of and the search for similarities and "
                        . "differences are the basis of all human knowledge." );

            $t2->down;
            $t2->title("      Alfred Nobel ");

            my $down   = 40;
            my $offset = 15;
            my $t1     = $pn->text_box( 800, 150, -width => 580 );
            my $t3     = $pn->text_box( 160, 300 + 4 * $down + $offset );
            my ( %l, %p, %c, %s, %a );

            # -----------------------------------------------------
            # create a golden spiral
            # -----------------------------------------------------

            # start with a golden rectangle
            my @A = ( 100, 600 );
            my @B = ( 500, 600 );
            $p{A} = Point->new( $pn, @A )->grey;
            $p{B} = Point->new( $pn, @B )->grey;
            $l{1} = Line->new( $pn, @A, @B )->grey();
            my @C = $l{1}->golden_ratio()->grey->coords;

            $a = Point->distance_between( @A, @C );
            $b = Point->distance_between( @B, @C );

            Arc->new( $pn, $a, $A[0], $A[1] - $a, @C );

            # rectangle 1
            $l{2} = Line->new( $pn, @B, $B[0], $B[1] - $a )->grey;
            $l{3} = Line->new( $pn, @C, $C[0], $C[1] - $a )->grey;
            $l{4} =
              Line->new( $pn, $A[0], $A[1] - $a, $B[0], $B[1] - $a )->grey;
            $l{5} = Line->new( $pn, @A, $A[0], $A[1] - $a )->grey;

            # rectangle 2
            my @D = ( $B[0], $B[1] - $b );
            $l{6} = Line->new( $pn, @D, $D[0] - $b, $D[1] )->grey;
            my $tmp = $a;
            $a = Point->distance_between( @B, @D );
            $b = $tmp - $a;
            Arc->new( $pn, $a, @C, @D );

            # rectangle 3
            my @E = ( $D[0] - $b, $D[1] );
            $l{7} = Line->new( $pn, $E[0], $E[1] - $b, @E )->grey;
            $tmp = $a;
            $a = Point->distance_between( @D, @E );
            $b = $tmp - $a;
            Arc->new( $pn, $a, @D, $E[0], $E[1] - $a );

            # rectangle 4
            my @F = ( $E[0], $E[1] - ( $a - $b ) );
            $l{8} = Line->new( $pn, $F[0] - $b, $F[1], @F )->grey;
            $tmp = $a;
            $b = Point->distance_between( @E, @F );
            $a = $tmp - $b;
            Arc->new( $pn, $a, $E[0], $E[1] - $tmp, $C[0], $F[1] );

            # rectangle 5
            my @G = ( $F[0] - ( $a - $b ), $F[1] );
            $l{9} = Line->new( $pn, @G, $G[0], $G[1] + $b )->grey;
            $tmp = $a;
            $b = Point->distance_between( @F, @G );
            $a = $tmp - $b;
            Arc->new( $pn, $a, $G[0] - $a, $G[1], $G[0], $G[1] + $a );

        },
    );
}

# ============================================================================
# Title Page for Book 7
# ============================================================================
sub title_page7 {
    my $pn = $self->{-pn};
    return (
        sub {
            local $Shape::AniSpeed = .01 * $Shape::AniSpeed;
            $pn->clear();
            my ( $x, $y ) = $pn->center_coords();
            my $cn = $pn->Tk_canvas();
            $cn->createText(
                             $x + 50, $y - 300,
                             -text => "Euclid's Elements",
                             -font => "intro",
                             -fill => 'black',
            );
            $cn->createText(
                             $x + 50, $y - 200,
                             -text => "Book VII",
                             -font => "intro",
                             -fill => 'black',
            );

            my ( $xc, $yc ) = $pn->center_coords();
            my $t2 =
              $pn->text_box(
                             $xc + 100, $yc - 100,
                             -anchor => "w",
                             -width  => 400
              );
            $t2->fancy( "As long as algebra and geometry have been separated, "
                . "their progress have been "
                . "slow and their uses limited; but when these two sciences have been united, "
                . "they have lent each mutual forces, and have marched together towards perfection."
            );

            $t2->down;
            $t2->title("      Joseph-Louis Lagrange");
            $t2->title("              (1736 to 1813)");

            my $down   = 40;
            my $offset = 15;
            my $t1     = $pn->text_box( 40, 250, -width => 580 );
            my $t3     = $pn->text_box( 160, 300 + 4 * $down + $offset );
            my ( %l, %p, %c, %s, %a );

            # -----------------------------------------------------
            # some of the definitions for book 7
            # -----------------------------------------------------
            $t1->title("Definitions:");
            $t1->point(
                        "A unit is that by virtue of which each "
                          . "of the things that exist is called one",
                        1
            );
            $t1->point(
                    "A number is a multitude " . "composed of units. (not one)",
                    2 );
            $t1->point(
                       "A number is part of a number, the less of the greater, "
                         . "when it measures the greater",
                       3
            );
            $t1->point(
                    "A prime number is that which is measured by a unit alone.",
                    11 );
            $t1->point(
                    "Numbers prime to one another are those which are measured "
                      . "by a unit alone as a common measure",
                    12
            );
            $t1->point(
                "A number is said to multiply a number when that which is "
                  . "multiplied is added to itself as many times as there are units in the other, and thus some number is produced.",
                15
            );
            $t1->point(
                "Numbers are proportional when the first is the same multiple, "
                  . "or the same part, or the same parts, of the second that the third is of the fourth.",
                20
            );
        }
    );
}

# ============================================================================
# Title Page for Book 8
# ============================================================================
sub title_page8 {
    my $pn = $self->{-pn};
    return (
        sub {
            local $Shape::AniSpeed = .01 * $Shape::AniSpeed;
            $pn->clear();
            my ( $x, $y ) = $pn->center_coords();
            my $cn = $pn->Tk_canvas();
            $cn->createText(
                             $x + 50, $y - 300,
                             -text => "Euclid's Elements",
                             -font => "intro",
                             -fill => 'black',
            );
            $cn->createText(
                             $x + 50, $y - 200,
                             -text => "Book VIII",
                             -font => "intro",
                             -fill => 'black',
            );

            my ( $xc, $yc ) = $pn->center_coords();
            my $t2 =
              $pn->text_box(
                             $xc + 100, $yc - 100,
                             -anchor => "w",
                             -width  => 400
              );
            $t2->fancy(   "There is no excellent beauty that hath not "
                        . "some strangeness in the proportion." );

            $t2->down;
            $t2->explain("      Francis Bacon");

            my $down   = 40;
            my $offset = 15;
            my $t1     = $pn->text_box( 40, 250, -width => 580 );
            my $t3     = $pn->text_box( 160, 300 + 4 * $down + $offset );
            my ( %l, %p, %c, %s, %a );

            # -----------------------------------------------------
            # Picture
            # -----------------------------------------------------
            my @pts = ( 150, 250, 550, 250, 550, 650, 150, 650 );
            my $base = Polygon->new( $pn, 4, @pts )->fill($sky_blue);
            foreach my $p ( $base->points ) {
                $p->remove;
            }

            foreach my $i ( 1 .. 8 ) {
                my $xh = 0.5 * ( $pts[0] + $pts[2] );
                my $yh = 0.5 * ( $pts[1] + $pts[5] );
                Line->new( $pn, $xh,     $pts[1], $xh,     $pts[7] );
                Line->new( $pn, $pts[0], $yh,     $pts[2], $yh );
                my @n =
                  ( $pts[0], $yh, $xh, $yh, $xh, $pts[7], $pts[0], $pts[7] );

                my $inset =
                  Polygon->new( $pn, 4, @n )->fillover( $base, $yellow );
                foreach my $p ( $inset->points ) {
                    $p->remove;
                }
                $pts[6] = $pts[0] = 0.5 * ( $pts[0] + $pts[2] );
                $pts[5] = $pts[7] = 0.5 * ( $pts[5] + $pts[1] );
            }

        }
    );
}

# ============================================================================
# square a polygon pic
# ============================================================================
sub square_polygon {
    my $pn = shift;

    my ( %l, %p, %c, %s, %a );

    my @A = ( 150, 200, 300, 225, 250, 350, 90, 275 );
    my @K = ( 100, 400 );

    $s{A} =
      Polygon->new( $pn, 4, @A, 1, -labels => [ undef, undef, "A  ", "left" ] );
    $p{K} = Point->new( $pn, @K );
    $s{R} = $s{A}->copy_to_rectangle( $p{K}, -1 );
    $s{R}->set_points(qw(C left D right E topright B left));
    $l{BF} = $s{R}->l(3)->clone();
    $l{BF}->prepend(100);
    $c{E} = Circle->new( $pn, $s{R}->p(3)->coords, $s{R}->p(2)->coords )->grey;
    my @cuts = $c{E}->intersect( $l{BF} );
    $p{F} = Point->new( $pn, @cuts[ 0, 1 ] )->label(qw(F bottom));
    $l{BF}
      ->prepend( $s{R}->l(3)->length + $s{R}->l(2)->length - $l{BF}->length );
    $p{G}  = $l{BF}->bisect()->label(qw(G topleft));
    $c{G}  = Circle->new( $pn, $p{G}->coords, $p{F}->coords )->grey;
    $l{H1} = $s{R}->l(2)->clone->extend(200);
    $p{H} =
      Point->new( $pn, $c{G}->intersect( $l{H1} ) )->label(qw(H topright));
    $p{E} = $s{R}->p(3);
    $l{H} = Line->new( $pn, $p{E}->coords, $p{H}->coords );
    $l{G} = Line->new( $pn, $p{G}->coords, $p{H}->coords );
    $l{H1}->remove;
    $s{EH} = Square->new( $pn, $l{H}->end, $l{H}->start );
    $s{A}->fill($pale_pink);
    $s{R}->fill($pink);
    $s{EH}->fill( Colour->add( $pale_pink, $pink ) );
}

# ============================================================================
# display the pythagoras theorem pic
# ============================================================================
sub pythagorus {
    my $pn = shift;
    my $speed = shift || -1;

    # make a pythagorean theorem (fast)
    my ( %l, %p, %c, %a, %t, %s );
    my @objs;
    my $top = 325;
    my $bot = 425;
    my @A   = ( 250, $top );
    my @B   = ( 175, $bot );

    my $s = -1. * ( $B[0] - $A[0] ) / ( $bot - $top );
    my $b = $A[1] - $s * $A[0];
    my @C = ( ( 1.0 / $s ) * ( $bot - $b ), $bot );

    $t{ABC} = Triangle->new( $pn, @A, @B, @C, -1,
                            -points => [qw(A top B bottomleft C bottomright)] );
    $t{ABC}->set_angles( " ", undef, undef );
    $s{B} = Square->new( $pn, @B, @A, -speed => $speed );
    $s{A} = Square->new( $pn, @A, @C, -speed => $speed );
    $s{C} = Square->new( $pn, @C, @B, -speed => $speed );
    $s{B}->set_points( qw(F left),   (undef) x 4, qw(G top ) );
    $s{C}->set_points( qw(E bottom), (undef) x 4, qw(D bottom) );
    $s{A}->set_points( qw(H top),    (undef) x 4, qw(K right) );
    $l{ALx} = $s{C}->l(3)->parallel( $t{ABC}->p(1), $speed );
    $p{L} =
      Point->new( $pn, $l{ALx}->intersect( $s{C}->l(4) ) )->label(qw(L bottom));
    $l{AL} = Line->new( $pn, @A, $p{L}->coords(), $speed );
    $l{ALx}->remove();
    $l{FC} = Line->new( $pn, $s{B}->p(1)->coords(), @C, $speed );
    $l{AD} = Line->new( $pn, @A, $s{C}->p(4)->coords(), $speed );
    $s{ABD} = Triangle->assemble( $pn,
                             -lines => [ $t{ABC}->l(1), $s{C}->l(3), $l{AD} ] );
    $s{FBC} = Triangle->assemble( $pn,
                             -lines => [ $s{B}->l(1), $t{ABC}->l(2), $l{FC} ] );
    $s{ABD}->fill($sky_blue);
    $s{B}->fill($sky_blue);
    $s{FBC}->fillover( $s{B}, $sky_blue );
    $p{AL} = Point->new( $pn, $l{AL}->intersect( $s{C}->l(2) ) );
    $s{BDL} = Polygon->new( $pn, 4, @B, $s{C}->p(4)->coords(),
                            $p{L}->coords(), $p{AL}->coords(), $speed );
    $s{ABD}->fillover( $s{ABD}, $sky_blue );
    $s{B}->fill($blue);
    $s{BDL}->fill($blue);
    $l{AE} = Line->new( $pn, @A, $s{C}->p(1)->coords(), $speed );
    $l{BK} = Line->new( $pn, @B, $s{A}->p(4)->coords(), $speed );
    $s{BCK} = Triangle->assemble( $pn,
                             -lines => [ $t{ABC}->l(2), $s{A}->l(3), $l{BK} ] );
    $s{ECA} = Triangle->assemble( $pn,
                             -lines => [ $s{C}->l(1), $t{ABC}->l(3), $l{AE} ] );
    $s{BCK}->fillover( $s{A}, $lime_green );
    $s{CEL} = Polygon->new(
                            $pn,
                            4,
                            $p{L}->coords(),
                            $s{C}->p(1)->coords(),
                            $s{C}->p(2)->coords(),
                            $l{AL}->intersect( $s{C}->l(2) ),
                            $speed
    );
    $s{ECA}->fillover( $s{CEL}, $lime_green );
    $s{A}->fill($green);
    $s{CEL}->fill($green);

    # add some depth to the colours
    #=remove
    $t{ABC}->grey;
    $s{ABD}->grey;
    $s{FBC}->grey;
    $s{BDL}->grey;
    $s{CEL}->grey;
    $s{A}->grey;
    $s{C}->grey;
    $s{B}->grey;
    $s{BDL}->grey;
    $s{BCK}->grey;
    $s{ECA}->grey;
    $s{ECA}->l(1)->normal;
    $s{ECA}->l(2)->green;

    $l{AL}->remove;
    $p{L}->remove;
    $p{AL}->remove;

    $p{middlelefttop} =
      Point->new( $pn, $s{FBC}->l(3)->intersect( $s{ABD}->l(3) ) );
    $p{middleleftbottom} =
      Point->new( $pn, $s{ABD}->l(3)->intersect( $s{BCK}->l(3) ) );
    $p{cl} = Point->new( $pn, $s{ABD}->l(3)->intersect( $t{ABC}->l(2) ) );
    $p{b}  = Point->new( $pn, $s{FBC}->l(3)->intersect( $t{ABC}->l(1) ) );

    $p{middle} = Point->new( $pn, $s{BCK}->l(3)->intersect( $l{AL} ) );
    $p{middlerighttop} =
      Point->new( $pn, $s{BCK}->l(3)->intersect( $s{ECA}->l(3) ) );
    $p{middlerightbottom} =
      Point->new( $pn, $s{FBC}->l(3)->intersect( $s{ECA}->l(3) ) );

    $p{a} = Point->new( $pn, $s{BCK}->l(3)->intersect( $t{ABC}->l(3) ) );
    $p{c} = Point->new( $pn, $s{ECA}->l(3)->intersect( $t{ABC}->l(2) ) );

    Polygon->join( 3, $p{middle}, $p{middlerighttop}, $p{middlerightbottom} )
      ->fill($lime_green)->remove_points;

    Polygon->join( 3, $t{ABC}->p(1), $p{middlerighttop}, $p{a} )
      ->fill($lime_green)->remove_points;
    Polygon->join( 3, $t{ABC}->p(3), $p{middlerightbottom}, $p{c} )
      ->fill( Colour->add( $green, $sky_blue ) )->remove_points;
    Polygon->join( 4, $t{ABC}->p(3), $p{a}, $p{middlerighttop},
                   $p{middlerightbottom} )->fill($green)->remove_points;

    Polygon->join( 4, $s{A}->p(1), $s{A}->p(2), $p{a}, $s{A}->p(4) )
      ->fill($green)->remove_points;
    Polygon->join( 3, $t{ABC}->p(3), $p{a}, $s{A}->p(4) )
      ->fill( Colour->add( $green, $lime_green ) )->remove_points;

    Polygon->join( 4, $p{L}, $p{AL}, $p{c}, $s{C}->p(1) )->fill($green)
      ->remove_points;
    Polygon->join( 3, $t{ABC}->p(3), $p{c}, $s{C}->p(1) )
      ->fill( Colour->add( $green, $lime_green ) )->remove_points;
    Polygon->join( 5, $p{middleleftbottom}, $p{cl}, $p{c},
                   $p{middlerightbottom}, $p{middle} )->fill($teal)
      ->remove_points;

    Polygon->join( 3, $p{middle}, $p{middlelefttop}, $p{middleleftbottom} )
      ->fill($sky_blue)->remove_points;
    Polygon->join( 3, $t{ABC}->p(2), $p{cl}, $p{middleleftbottom} )
      ->fill( Colour->add( $blue, $lime_green ) )->remove_points;

    Polygon->join( 4, $p{b}, $t{ABC}->p(2), $p{middleleftbottom},
                   $p{middlelefttop} )->fill($blue)->remove_points;
    Polygon->join( 3, $t{ABC}->p(1), $p{b}, $p{middlelefttop} )->fill($sky_blue)
      ->remove_points;

    Polygon->join( 3, $t{ABC}->p(2), $p{cl}, $s{BDL}->p(2) )
      ->fill( Colour->add( $sky_blue, $blue ) )->remove_points;
    Polygon->join( 4, $s{BDL}->p(2), $s{BDL}->p(3), $s{BDL}->p(4), $p{cl} )
      ->fill($blue)->remove_points;

    Polygon->join( 3, $t{ABC}->p(2), $p{b}, $s{B}->p(1) )
      ->fill( Colour->add( $sky_blue, $blue ) )->remove_points;
    Polygon->join( 4, $s{B}->p(1), $s{B}->p(4), $s{B}->p(3), $p{b} )
      ->fill($blue)->remove_points;

    $p{middlelefttop}->remove;
    $p{middleleftbottom}->remove;
    $p{cl}->remove;
    $p{b}->remove;

    $p{middle}->remove;
    $p{middlerighttop}->remove;
    $p{middlerightbottom}->remove;

    $p{a}->remove;
    $p{c}->remove;
    return;
}

# ============================================================================
# get list of all propositions in directory and make a linked list of
# the order in which they need to be displayed
# ============================================================================
sub prev_next {
    use FindBin;
    my $dir   = $FindBin::Bin;
    my @files = glob("$dir/*");
    my @pfiles;
    foreach my $file (@files) {
        if ( $file =~ /\.pl$/ ) {
            push @pfiles, $file;
        }
    }

    # these files have to be in alphabetical order in order for this to work
    @pfiles = sort { uc($a) cmp uc($b) } @pfiles;

    my %pfiles;
    foreach my $i ( 0 .. @pfiles - 1 ) {
        my $bname = $pfiles[$i];
        $pfiles{$bname}{next} = $pfiles[ $i + 1 ] if $i < ( @pfiles - 1 );
        $pfiles{$bname}{prev} = $pfiles[ $i - 1 ] if $i > 0;
        $pfiles{$bname}{next_text} = $pfiles[ $i + 1 ] if $i < ( @pfiles - 1 );
        $pfiles{$bname}{prev_text} = $pfiles[ $i - 1 ] if $i > 0;
        $pfiles{$bname}{prev_text} =~ s/^.*?([^\/]*\.pl)/$1/
          if $pfiles{$bname}{prev_text};
        $pfiles{$bname}{next_text} =~ s/^.*?([^\/]*\.pl)/$1/
          if $pfiles{$bname}{next_text};

        $bname =~ s/^.*?([^\/]*\.pl)/$1/;
        $pfiles{$bname}{next} = $pfiles[ $i + 1 ] if $i < ( @pfiles - 1 );
        $pfiles{$bname}{prev} = $pfiles[ $i - 1 ] if $i > 0;
        $pfiles{$bname}{next_text} = $pfiles[ $i + 1 ] if $i < ( @pfiles - 1 );
        $pfiles{$bname}{prev_text} = $pfiles[ $i - 1 ] if $i > 0;
        $pfiles{$bname}{prev_text} =~ s/^.*?([^\/]*\.pl)/$1/
          if $pfiles{$bname}{prev_text};
        $pfiles{$bname}{next_text} =~ s/^.*?([^\/]*\.pl)/$1/
          if $pfiles{$bname}{next_text};
    }
    return \%pfiles;
}
1;

__DATA__

Philosophy [nature] is written in that great book which ever is before our eyes --
I mean the universe -- but we cannot understand it if we do not first learn the
language and grasp the symbols in which it is written. The book is written in
mathematical language, and the symbols are triangles, circles and other
geometrical figures, without whose help it is impossible to comprehend a single
word of it; without which one wanders in vain through a dark labyrinth.

- Galileo Galilei

"Obvious" is the most dangerous word in mathematics

The description of right lines and circles, upon which geometry is founded,
belongs to mechanics. Geometry does not teach us to draw these lines, but requires
them to be drawn.
Sir Isaac Newton - Principia Mathematica


As long as algebra and geometry have been separated, their progress have been
slow and their uses limited; but when these two sciences have been united,
they have lent each mutual forces, and have marched together towards perfection.
Joseph-Louis Lagrange (1736 to 1813)

There is geometry in the humming of the strings. There is music in the spacing
of the spheres.
� Pythagoras

He is unworthy of the name of man who is ignorant of the fact that the
diagonal of a square is incommensurable with its side.
Plato

According to most accounts, geometry was first discovered among the Egyptians,
taking its origin from the measurement of areas. For they found it necessary
by reason of the flooding of the Nile, which wiped out everybody�s proper
boundaries. Nor is there anything surprising in that the discovery both of
this and of the other sciences should have had its origin in a practical need,
since everything which is in process of becoming progresses from the imperfect
to the perfect.
Proclus Wikipedia: Proclus
� On Euclid

�Don't be inscribed by circumstances, circumscribe the circumstances�
- Constance Chuks Friday

Proportions are what makes the old Greek temples classic in their beauty.
They are like huge blocks, from which the air has been literally hewn
out between the columns. Arne Jacobsen

"Pick up a sunflower and count the florets running into its centre,
or count the spiral scales of a pine cone or a pineapple, running from
its bottom up its sides to the top, and you will find an extraordinary truth:
recurring numbers, ratios and proportions."
Author: Charles Jencks
