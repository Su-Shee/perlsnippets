#!/usr/bin/env perl

# http://www.pygtk.org/pygtk2reference/index.html
# http://forgeftp.novell.com/gtk2-perl-study/documentation/html/index.html

use strict;
use warnings;

use Gtk2 '-init';
use Time::localtime;

my $window = Gtk2::Window->new;
my $label  = Gtk2::Label->new;

$window->set_title('Simple Timer');
$window->set_default_size('400', '400');

$window->signal_connect('expose_event', \&on_expose, $label);
$window->signal_connect('delete_event', \&quit);

$window->add($label);

$window->show_all;
Gtk2->main;

sub on_expose {
    my ($widget, $event, $label) = @_;

    my $now = ctime;
    $label->set_markup("<big><b>$now</b></big>");
    #$label->set_text($now);
}

sub quit {
    Gtk2->exit;
}
