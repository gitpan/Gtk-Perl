#!/usr/bin/perl

use Gnome;

init Gnome "gnome-dns.pl";

init Gnome::DNS;

$NAME = "DNS Lookup";

$w = new Gtk::Window -toplevel;
show $w;

$b = new Gtk::Button "Lookup";
$w->add($b);
show $b;

$b->signal_connect(clicked => sub {

	print "Starting DNS lookup...\n";

	Gnome::DNS->lookup("www.altavista.digital.com",
		sub {
			print "Address of www.altavista.digital.com is $_[1], data is $_[0]\n";
			exit;
		}, 34);
});

main Gtk;
