#!/usr/bin/perl -w

#TITLE: Gnome HTML
#REQUIRES: Gtk Gnome GtkXmHTML

$NAME = 'HTML';

use Gnome;
use Gtk::XmHTML;
use LWP::UserAgent;

init Gnome "html.pl";

$ua = new LWP::UserAgent;
$request = new HTTP::Request('GET', shift(@ARGV) || 'www.altavista.digital.com');

$data = $ua->request($request);
$win = new Gtk::Window -toplevel;
$win->signal_connect('destroy', sub {Gtk->exit(0)});
$html = new Gtk::XmHTML;
if ($data->is_success) {
	$html->source($data->content());
} else {
	$html->source($data->error_as_HTML());
}
$html->signal_connect('activate', \&goto_url);
$html->show;
$win->add($html);
$win->show;

main Gtk;


sub goto_url {
	my ($html, $p) =@_;
	print "void* ($p)", ref($p), "\n";
}

