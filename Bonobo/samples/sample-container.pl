#!/usr/bin/perl -w

#TITLE: Bonobo sample container
#REQUIRES: Gtk Gnome Bonobo

use Bonobo;

init Gnome('sample-container');

if (!Bonobo->init) {
	die "Can't initialize bonobo\n";
}

container_create ();
Bonobo->main;
exit(0);

sub container_create {
	my ($app, $uic, $box, $control, $button, $clock_button);
	$app = new Bonobo::Window("sample-container", "Sample Bonobo Container");
	$app->set_default_size(400, 400);
	$app->set_policy(1, 1, 0);
	$app->signal_connect('delete_event', sub {shift->destroy; return 0;});
	$app->signal_connect('destroy', sub {Gtk->main_quit;});

	$uic = new Bonobo::UIContainer();
	$uic->set_win($app);
	$container->signal_connect('system_exception', sub {
		my ($c, $o) = @_;
		Gnome::DialogUtil->warning("Container encountered a fatal CORBA exception! Shutting down...");
		$o->destroy;
		$app->destroy;
		Gtk->main_quit;
	});
	$box = new Gtk::VBox(0, 0);
	$app->set_contents($vbox);
	
	$control = new_control Bonobo::Widget("OAFIID:Bonobo_Sample_Calculator", $uic);
	$box->pack_start($control, 1, 1, 0) if $control;
	$button = new Gtk::Button("Increment result");
	$button->signal_connect('clicked', \&increment_cb, $control);

	$control = new_control Bonobo::Widget("OAFIID:Bonobo_Sample_Clock", $uic)
	$box->pack_start($control, 1, 1, 0) if $control;
	$clock_button = new Gtk::Button("Pause/Resume Clock");
	$clock_button('clicked', \&toggle_clock, $control);
	
	$uih = new Gnome::UIHandler;
	$uih->set_app($app);
	container_create_menus();
	$app->show_all;
}

sub increment_cb {
	my ($button, $control) = @_;
	my $i;
	$i = $control->get_property('value');
	$i += 0.37;
	$control->set_property('value', $i);
}

sub toggle_clock {
	my ($button, $control) = @_;
	my ($state);
	$state = $control->get_property('running');
	$control->set_property('running', !$state);
}

sub container_create_menus {
	$uih->create_menubar();

}

