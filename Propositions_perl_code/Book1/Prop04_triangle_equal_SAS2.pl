#!/usr/bin/perl
use Geometry::Canvas::PropositionCanvas;
use FindBin;
use lib "$FindBin::Bin/..";
use Proposition;

# ============================================================================
# Definitions
# ============================================================================
my $title =
    "If two triangles have two sides equal to two sides respectively, "
  . "and have the angles contained by the equal straight lines equal, "
  . "then they also have the base equal to the base, the triangle equals "
  . "the triangle, and the remaining angles equal the remaining angles "
  . "respectively, namely those opposite the equal sides.";

my $pn = PropositionCanvas->new( -number => 4, -title => $title );

# set up Proposition (includes opening and closing pages)
Proposition::init($pn);

$pn->copyright;

my $t1 = $pn->text_box( 800, 200, -width => 500 );
my $t2 = $pn->text_box( 40,  400, -width => 500 );
my $t3 = $pn->text_box( 100, 500, -width => 800 );

my $steps;
push @$steps, Proposition::title_page($pn);
push @$steps, Proposition::toc($pn,4);
push @$steps, Proposition::reset();
push @$steps, @{explanation( $pn )};
push @$steps,sub{Proposition::last_page};
$pn->define_steps($steps);
$pn->copyright();
$pn->go;


# ============================================================================
# Explanation
# ============================================================================
sub explanation {

    my %l;
    my %p;
    my %c;
    my %t;
    my @objs;
    my %a;

    my @A = ( 300, 250 );
    my @B = ( 100, 250 );
    my @C = ( 250, 450 );

    my @D = ( 400, 400 );
    my @E = ( 600, 400 );
    my @F = ( 450, 200 );

    my @steps;

    # ------------------------------------------------------------------------
    # In other words
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->title("In other words");
        $t1->explain(
                "If two triangles have two sides which are "
              . "equivalent, and if the angles between the two "
              . "sides are also equivalent, "
              . "(side-angle-side SAS)..."
        );
        $t2->math("AB = DE");
        $t2->math("AC = DF");
        $t2->math("\\{angle}BAC = \\{angle}FDE");

        $t{ABC} = Triangle->new(
                            $pn,
                            @A, @B, @C, 1,
                            -points => [qw(A top B left C bottom)],
                            -labels => [ qw(x top), undef, undef, qw(y right) ],
                            -angles => [ "\\{alpha}", undef, undef, 20 ]
        );

        $t{DEF} = Triangle->new(
                         $pn,
                         @D, @E, @F, 1,
                         -points => [qw(D left E bottom F  left)],
                         -labels => [ qw(x bottom ), undef, undef, qw(y left) ],
                         -angles => [ "\\{alpha}", undef, undef ]
        );
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain("... then they are equal in all respects");
        $t2->math("\\{triangle}ABC \\{equivalent} \\{triangle}DEF");
        $t{ABC}->set_labels( undef, undef, qw(z left) );
        $t{DEF}->set_labels( undef, undef, "z", "right" );
        $t{ABC}->set_angles( undef, "\\{gamma}", "\\{beta}" );
        $t{DEF}->set_angles( undef, "\\{gamma}", "\\{beta}" );
    };

    # ------------------------------------------------------------------------
    # Proof
    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->down;
        $t2->erase;
        $t{ABC}->l(2)->label;
        $t{DEF}->l(2)->label;
        $t{ABC}->a(2)->remove;
        $t{ABC}->a(3)->remove;
        $t{DEF}->a(3)->remove;
        $t{DEF}->a(2)->remove;
        $t1->title("Proof");
        $t2->math("AB = DE");
        $t2->math("AC = DF");
        $t2->math("\\{angle}BAC = \\{angle}FDE");
    };

    # --------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Move triangle ABC such that point A coincides "
                      . "with point\\{nb}D " );

        $t{ABC}->green();
        $t{ABC}->remove_labels();
        $t{ABC}->move( $D[0] - $A[0], $D[1] - $A[1], 10 );
    };

    # --------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(
                 "Rotate the triangle so that line AB line coincides with DE.");
        $t1->explain("... diagram is offset a bit so we can see more clearly");
        $t{DEF}->l(1)->red();
        $t{DEF}->remove_labels();
        $t{ABC}->rotate( @D, 180, 5 );
        $t{ABC}->move( 20, 10 );
        $t{ABC}->l(1)->red();
        $t{ABC}->set_points(qw(A bottom B right C right));
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Since lines AB and DE are the same lengths, "
                      . "the endpoints are congruent" );

        $t{ABC}->l(1)->normal();
        $t{DEF}->l(1)->normal();
        $t{DEF}->l(2)->grey;
        $t{DEF}->l(3)->grey;
        $t{ABC}->l(2)->grey;
        $t{ABC}->l(3)->grey;
        $t{DEF}->a(1)->remove;
        $t{ABC}->p(1)->notice();
        $t{DEF}->p(1)->notice();
        $t{ABC}->p(2)->notice();
        $t{DEF}->p(2)->notice();
        $t2->allgrey;
        $t2->blue(0);
        $t2->math("A = D");
        $t2->math("B = E");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "Line AC coincides with DF since they are the "
                      . "same length and the angles "
                      . "BAC and EDF are equal " );
        $t{DEF}->a(1)->draw;
        $a{ABC} =
          Angle->new( $pn, $t{ABC}->l(1), $t{ABC}->l(3) )
          ->label( "\\{alpha}", 20 );
        $t{ABC}->l(3)->normal();
        $t{DEF}->l(3)->normal();

        #$t{ABC}->p(1)->notice();
        #$t{ABC}->p(3)->notice();
        $t2->allgrey;
        $t2->blue( [ 1, 2 ] );
        $t2->math("C = F");
        $t2->math("AC = DF");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain( "Since the points B coincides with E and C with F, "
            . "then the lines BC coincides with EF"
            . "... based on the implicit  understanding that there is only one "
            . "straight path"
            . " between two points" );
        $t2->allgrey;
        $t2->black( [ 4, 5 ] );
        $a{ABC}->grey;
        $t{DEF}->a(1)->grey;
        $t{ABC}->p(2)->notice;
        $t{DEF}->p(2)->notice;
        $t{ABC}->p(3)->notice;
        $t{DEF}->p(3)->notice;
        $t{ABC}->p(2)->red;
        $t{DEF}->p(2)->red;
        $t{ABC}->p(3)->red;
        $t{DEF}->p(3)->red;
        $t{ABC}->l(1)->grey;
        $t{DEF}->l(1)->grey;
        $t{ABC}->l(3)->grey;
        $t{DEF}->l(3)->grey;
        $t{ABC}->l(2)->normal;
        $t{DEF}->l(2)->normal;
        $t2->math("BC = EF");
    };

    # ------------------------------------------------------------------------
    push @steps, sub {
        $t1->explain(   "From common notion 4, things which coincide "
                      . "with one another, equal one another" );

        $t2->allblack;
        $t2->blue( [ 0 .. 2 ] );
        $t{ABC}->normal;
        $t{DEF}->normal;

        $t2->math("\\{triangle}ABC \\{equivalent} \\{triangle}DEF");
    };

    # ------------------------------------------------------------------------
    return \@steps;
}

