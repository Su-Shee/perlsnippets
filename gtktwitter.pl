#!/usr/bin/env perl

use strict;
use warnings;

use Gtk2 '-init';
use Net::Twitter::Lite;

my $username = 'YOU@SOMEWHERE';
my $password = 'YOURPASSWORD';

my $window  = Gtk2::Window->new;

$window->signal_connect('delete_event' => sub { Gtk2->main_quit; } );

$window->set_title('glipsch twitter client');
$window->set_default_size('600', '80');
$window->set_border_width('10');

my $mainbox   = Gtk2::VBox->new('TRUE', 5);
my $inputbox  = Gtk2::VBox->new('TRUE', 10);
my $updatebox = Gtk2::HBox->new('TRUE', 0);

my $input     = Gtk2::Entry->new_with_max_length('140');
my $counter   = Gtk2::Label->new();
my $update    = Gtk2::Button->new('update');

$counter->set_alignment('0.1', '0.5');

$input->signal_connect('expose_event' => sub {
                       my ($widget, $event) = @_;
                       on_expose($widget, $event, $counter);
});

$input->signal_connect('activate' => sub { 
                       my ($widget, $event) = @_;
                       on_enter($widget, $event, $update); 
});

$update->signal_connect('clicked' => sub {
                        my ($widget, $event) = @_;
                        on_click($widget, $event, $input);
});

$inputbox->pack_start($input, 'FALSE', 'FALSE', 0);
$updatebox->pack_start($counter, 'FALSE', 'FALSE', 30);
$updatebox->pack_start($update, 'FALSE', 'FALSE', 0);

$mainbox->pack_start($inputbox, 'FALSE', 'FALSE', 0);
$mainbox->pack_start($updatebox, 'FALSE', 'FALSE', 3);

$window->add($mainbox);
$window->show_all;

Gtk2->main;

sub on_enter {
    my ($widget, $event, $button) = @_;
    $button->clicked();
}

sub on_click {
    my ($widget, $event, $input) = @_;
    my $message = $input->get_text();
     
    my $twit = Net::Twitter::Lite->new( 'username' => "$username",
                                        'password' => "$password", );

    my $status = eval { $twit->update($message) };

    if($status) {
        empty_input_on_success(@_);
    }
}

sub empty_input_on_success {
    my ($widget, $event, $input) = @_;
    sleep(3);
    $input->set_text("");
    $input->show;
}

sub on_expose {
    my ($widget, $event, $label) = @_;
    my $charcount                = length($input->get_text());

    $label->set_text($charcount);
    $label->set_markup("<big><b><span foreground=\"#dd00dd\">$charcount</span></b></big>");
    $label->show;
}

1;
