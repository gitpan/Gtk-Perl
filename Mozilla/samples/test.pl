#!/usr/bin/perl -w

# TITLE: Mozilla embedding
# REQUIRES: Gtk Mozilla
use POSIX qw(getenv);
BEGIN {
	$ENV{LD_LIBRARY_PATH} = '/usr/lib/mozilla'; # uhm, works only if set before starting ....
	$ENV{MOZILLA_FIVE_HOME} = '/usr/lib/mozilla';
}

use Gtk::MozEmbed;

Gtk->set_locale;
init Gtk;
#Gtk::MozEmbed->set_profile_path("/tmp", "testperl");
$win = new Gtk::Window;
$win->set_default_size(600, 700);
$win->signal_connect('destroy', sub {Gtk->main_quit});
$moz = new Gtk::MozEmbed;
#Gtk::MozEmbed->preference_set_int("network.proxy.type", 1);
#Gtk::MozEmbed->preference_set("network.proxy.http", 'localhost');
#Gtk::MozEmbed->preference_set_int("network.proxy.http_port", 80);
$win->add($moz);
$win->show_all;
#$moz->signal_connect('net_stop', sub {warn "net stop\n"});
#$moz->signal_connect('net_state', sub {shift; warn "STATE: @_\n"});
#$moz->signal_connect('progress_all', sub {shift; warn "PROGRESS: @_\n"});
#$moz->signal_connect('open_uri', sub {shift; warn "open uri: @_\n"; 0});
$moz->load_url(shift || 'http://www.gtk.org/');

main Gtk;

