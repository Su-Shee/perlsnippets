#!/usr/bin/env perl
# http://www.pygtk.org/pygtk2reference/index.html
# http://forgeftp.novell.com/gtk2-perl-study/documentation/html/index.html

use strict;
use warnings;

use Gtk2 '-init';
use Time::localtime;

my $window  = Gtk2::Window->new;
my $mainbox = Gtk2::VBox->new('TRUE', 2);

my $timer1  = Gtk2::Label->new;
my $timer2  = Gtk2::Label->new;

my @timers = ($timer1, $timer2);

$window->set_title('Simple Timer');
$window->set_default_size('400', '400');

$window->signal_connect('expose_event', \&on_expose, \@timers);
$window->signal_connect('delete_event', \&quit);

$window->add($mainbox);

$mainbox->pack_start($timer1, 'FALSE', 'FALSE', 0);
$mainbox->pack_start($timer2, 'FALSE', 'FALSE', 0);

$window->show_all;
Gtk2->main;

sub on_expose {
    my ($widget, $event, $timers) = @_;
    my ($timer1, $timer2)         = @{ $timers };

    my $now  = ctime;
    $timer1->set_markup("<big><b>$now</b></big>");
    $timer2->set_text($now);
}

sub quit {
    Gtk2->exit;
}
