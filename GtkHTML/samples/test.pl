#!/usr/bin/perl

#TITLE: HTML test (GtkHTML)
#REQUIRES: Gtk GtkHTML

use Gtk;
use Gtk::HTML;
use LWP::UserAgent;
use URI;

init Gtk;
init Gtk::Gdk::Rgb;
init Gtk::HTML;

Gtk::Widget->set_default_colormap(Gtk::Gdk::Rgb->get_cmap());
Gtk::Widget->set_default_visual(Gtk::Gdk::Rgb->get_visual());
$ua = new LWP::UserAgent();

$window = new Gtk::Window -toplevel;
$window->signal_connect('delete_event', sub {Gtk->exit(0)});
$sw = new Gtk::ScrolledWindow(undef, undef);
$sw->set_policy('automatic', 'automatic');
#$sw = new Gtk::HBox(0, 0);

$file = shift || '/var/www/index.html';

$html = new Gtk::HTML;

$html->signal_connect('load_done', sub {print "load done\n"});
$html->signal_connect('title_changed', sub {print "title changed\n"});
$html->signal_connect('set_base', sub {shift; print "base: ", shift,"\n"});
$html->signal_connect('url_requested', \&load_url);
$html->signal_connect('set_base_target', sub {shift; print "base_target: ", shift,"\n"});
$html->signal_connect('on_url', sub {shift; print "on_url: ", shift,"\n"});
$sw->show;
$sw->add($html);
$window->add($sw);
$html->realize;

$window->set_default_size(500, 400);

show_all $window;
$html->begin($file);
$html->parse;

main Gtk;

sub load_url {
	my ($html, $url, $handle) = @_;
	my ($req, $data);
	$url = "file:$url" unless $url =~ /^\w+:/;
	$req = new HTTP::Request('GET', $url);
	print "REQUEST: $url -> $handle\n";
	$data = $ua->request($req, sub {
		my ($d, $r, $p) = @_;
		if (defined ($d) && length($d)) {
			$html->write($handle, $d);
		} else {
			die "No more data?!?\n";
		}
	}, 4096);
	unless ($data->is_success) {
		$html->end($handle, 'error');
		print "Cannot get: $url\n";
	} else {
		$html->end($handle, 'ok');
	}
}

