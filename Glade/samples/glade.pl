#!/usr/bin/perl -w

#TITLE: Glade
#REQUIRES: Gtk Glade
use Gtk;
use Gtk::GladeXML;
use Data::Dumper;

eval {
	require Gtk::Gdk::ImlibImage;
	require Gnome;
	init Gnome('glade.pl');
	init Gtk::Gdk::ImlibImage;
};
init Gtk if $@;
Gtk::GladeXML->init;

print STDERR "Glade inited\n";

$g = new Gtk::GladeXML(shift || "test.glade");

print "Glade object: ", ref($g),"\n";

#$g->handler_connect('gtk_main_quit', sub {Gtk->main_quit;});
$g->signal_autoconnect_from_package('main');
$w = $g->get_widget('MainWindow');

print STDERR "NAME: ", $w->get_name(), "\n" if $w;

main Gtk;

## callbacks..
sub gtk_main_quit {
	print "Test glade quitting\n";
	main_quit Gtk;
}

sub gtk_widget_hide {
	shift->hide();
}
sub gtk_widget_show {
	my ($w) = shift;
	print STDERR Dumper($w);
	$w->show;
}

# custom widget creation func
sub Gtk::GladeXML::create_custom_widget {
	my @args = @_;
	my $w = new Gtk::Label($args[1])|| die;
	print "custom widget got: @args -> $w\n";
	return $w;
}

