#!/usr/bin/env perl

use strict;
use warnings;

use Gtk2 '-init';
use Cairo;

my $supports_alpha;

sub expose {
    my($widget, $event) = @_;
    my($width, $height, $radius);
    
    my $cr = Gtk2::Gdk::Cairo::Context->create($widget->window());

    if($supports_alpha) {
        $cr->set_source_rgba(1.0, 1.0, 1.0, 0.0); 
    } else {
        $cr->set_source_rgb(1.0, 1.0, 1.0);
    } 

    $cr->set_operator('source');
    $cr->paint();
    $cr->set_source_rgba(1.0, 0.2, 0.2, 0.6);

    ($width, $height) = $widget->get_size();

    if($width < $height) {
        $radius = $width/2 - 0.8;
    } else {
        $radius = $height/2 - 0.8;
    }

    $cr->arc($width/2, $height/2, $radius, 0, 2.0*3.14);
    $cr->fill();
    $cr->stroke();
}

sub screen_changed {
    my ($widget, $old_screen) = @_;

    my $screen   = $widget->get_screen();
    my $colormap = $screen->get_rgba_colormap();

    if(!$colormap){ 
        print "Your screen doesn't support alpha channels!\n";
        $colormap = $screen->get_rgb_colormap();
    } else {
        $supports_alpha = 1;
        print "Your screen does support alpha channels!\n";
    }

    $widget->set_colormap($colormap);
}

sub main {
    my $window = Gtk2::Window->new();
    
    $window->set_title("Alpha Demo");
    $window->set_app_paintable('TRUE');

    $window->signal_connect('delete_event', \&quit);
    $window->signal_connect('expose_event', \&expose, $window);
    $window->signal_connect('screen_changed', \&screen_changed, $window);
    
    screen_changed($window);

    $window->show_all();
    Gtk2->main;
}

sub quit {
    exit;
}

main();
