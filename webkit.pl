#!/usr/bin/perl

use strict;
use warnings;

use Gtk2 -init;
use Gtk2::WebKit;
use Gtk2::Gdk::Keysyms;

my $window = Gtk2::Window->new;
$window->set_title("GtkPerl Mini Webkit");
$window->set_default_size('800', '800');
$window->signal_connect('delete_event' => sub { Gtk2->quit; });

my $main_table     = Gtk2::Table->new(4, 2);
my $scroll_window  = Gtk2::ScrolledWindow->new;
my $browser        = Gtk2::WebKit::WebView->new;

my $back_button    = Gtk2::Button->new_from_stock('gtk-go-back');
my $forward_button = Gtk2::Button->new_from_stock('gtk-go-forward');
my $reload_button  = Gtk2::Button->new_from_stock('gtk-refresh');
my $url_entry      = Gtk2::Entry->new;

$main_table->attach($back_button, 0, 1, 0, 1,
                    ['expand', 'fill'], 'expand', 10, 10);

$main_table->attach($forward_button, 1, 2, 0, 1,
                    ['expand', 'fill'], 'expand', 10, 10);

$main_table->attach($reload_button, 2, 3, 0, 1,
                    ['expand', 'fill'], 'expand', 10, 10);

$main_table->attach($url_entry, 3, 4, 0, 1,
                    ['expand', 'fill'], 'expand', 10, 10);

$main_table->attach($scroll_window, 0, 4, 1, 2,
                    ['expand', 'fill'], ['expand', 'fill'], 10, 10);

$scroll_window->set_size_request('-1', '700');

$window->add($main_table);
$scroll_window->add($browser);

$url_entry->signal_connect('activate' => sub {
                           my ($widget, $event) = @_;
                           open_url($widget, $event, $browser); 
});

$reload_button->signal_connect('clicked' => sub {
                                my ($widget, $event) = @_;
                                reload_url($widget, $event, $browser); 
});

$back_button->signal_connect('clicked' => sub {
                             my ($widget, $event) = @_;
                             back_url($widget, $event, $browser); 
});

$forward_button->signal_connect('clicked' => sub {
                                my ($widget, $event) = @_;
                                forward_url($widget, $event, $browser); 
});

$window->show_all;
Gtk2->main;

sub open_url {
    my ($widget, $event, $browser) = @_;
    my $url = $widget->get_text;
    $browser->open($url);
}

sub reload_url {
    my ($widget, $event, $browser) = @_;
    $browser->reload;
}

sub back_url {
    my ($widget, $event, $browser) = @_;
    $browser->go_back;
}

sub forward_url {
    my ($widget, $event, $browser) = @_;
    $browser->go_forward;
}

