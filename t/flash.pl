  #!perl -w

  use strict;
use Tcl::Tk;
my $int = new Tcl::Tk;

    my $mw   = $int->mainwindow;
  my $c  = $mw->Canvas->pack;

  #my $w  = $c->createWindow(50, 50,
  #             -window => $c->Label(-text => 'Hello'),
   #            -state  => 'hidden',
   #          );

  my $l = $c->createLine(30, 60, 100, 100,-width=>5);
  $mw->update;

  my $i = 0;
  my %stuff = $c->itemcget($i);
  use Data::Dumper;print Dumper \%stuff;
#  flash();
  sub flash {
  
          $i++;
          $c->itemconfigure($_, -state => $i % 2 ? 'normal' : 'hidden') for $l;
          $mw->after(1000,[\&flash]);
        
  }
$int->MainLoop;