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

$html->enable_debug(1);

$html->signal_connect('load_done', sub {print "load done\n"});
$html->signal_connect('title_changed', sub {$window->set_title($html->get_title())});
$html->signal_connect('set_base', sub {shift; print "base: ", shift,"\n"});
$html->signal_connect('url_requested', \&load_url);
$html->signal_connect('set_base_target', sub {shift; print "base_target: ", shift,"\n"});
$html->signal_connect('on_url', sub {shift; print "on_url: ", shift,"\n"});
$html->signal_connect('submit', sub {shift; print "@_\n"});
$html->signal_connect('link_clicked', sub {my $h= shift; load_url($h, shift, $h->begin)});
$html->signal_connect('object_requested', sub {shift; my $e= shift; print "want obj\n"; my $w = new Gtk::Button($e->classid); $w->show; $e->add($w);});
$sw->show;
$sw->add($html);
$window->add($sw);
$html->realize;

$window->set_default_size(500, 400);

show_all $window;
load_url($html, $file, $html->begin);
$html->set_editable(1);

Gtk->timeout_add(2000, sub {
	$html->save(sub {print $_[0];1});
	return 0;
});
main Gtk;

sub load_url {
	my ($html, $url, $handle) = @_;
	my ($req, $data);
	$url = "file:$url" unless $url =~ /^\w+:/;
	$req = new HTTP::Request('GET', $url);
	print "REQUEST: $url -> $handle\n";
	$data = $ua->request($req, sub {
		my ($d, $r, $p) = @_;
		while (Gtk->events_pending) {
			Gtk->main_iteration;
		}
		if (defined ($d) && length($d)) {
			$html->write($handle, $d);
			print "handle $handle write: ", length($d), "\n";
		} else {
			die "No more data ($handle)?!?\n";
		}
	}, 8096);
	unless ($data->is_success) {
		$html->end($handle, 'error');
		print "Cannot get ($handle): $url\n";
	} else {
		print "handle $handle end\n";
		$html->end($handle, 'ok');
	}
}

