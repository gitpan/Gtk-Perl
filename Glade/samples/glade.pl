#!/usr/bin/perl -w

#TITLE: Glade
#REQUIRES: Gtk Glade
use Gtk;
use Gtk::GladeXML;
use Data::Dumper;

init Gtk;
init Gtk::GladeXML;

print STDERR "Glade inited\n";

$g = new Gtk::GladeXML("test.glade");

#$g->handler_connect('gtk_main_quit', sub {Gtk->main_quit;});
$g->signal_autoconnect_from_package('main');
$w = $g->get_widget('MainWindow');

print STDERR "NAME: ", $w->get_name(), "\n";

main Gtk;

## callbacks..
sub gtk_main_quit {
	main_quit Gtk;
}

sub gtk_widget_show {
	my ($w) = shift;
	print STDERR Dumper($w);
	$w->show;
}
