#!/usr/bin/perl -w

use Bonobo;

init Gnome $0, '0.1';
init Bonobo;

$factory = new Bonobo::GenericFactory (
	'OAFIID:Bonobo_perlentry_factory',
	\&create_instance);

main Bonobo;

sub create_instance {
	my $widget = new Gtk::Entry;
	my $object = new Bonobo::Control $widget;
	$widget->set_text("Hello from Bonobo/Perl!");
	$widget->show;
	return $object;
}

