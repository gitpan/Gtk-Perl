#!/usr/bin/perl -w

#TITLE: Gnome App
#REQUIRES: Gtk Gnome

use strict;
use Gnome;

init Gnome "app-helper", "0.1";
my $app = new Gnome::App "app-helper", "gnome-app-helper test";
signal_connect $app 'delete_event', sub { Gtk->main_quit; return 0 };

$app->create_menus({type => 'subtree',
		    label => '_File',
		    subtree => [{type => 'subtree',
				 label => '_Foo',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_New',
				 subtree => [{type => 'item',
					      label => '_Quux'},
					     {type => 'item',
					      label => '_Argh'}]},
				{type => 'item',
				 label => '_Bar',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_About'},
				{type => 'item',
				 label => 'B_az',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_Quit',
				 callback => sub { Gtk->main_quit }}]},
		   {type => 'subtree',
		    label => '_Edit',
		    subtree => [{type => 'radioitems',
				 moreinfo => [{type => 'item',
					       label => '_Homer'},
					      {type => 'item',
					       label => '_Marge'}]}]},
		   {type => 'subtree',
		    label => '_Help',
		    subtree => [{type => 'item', label => '_About'}]});

$app->create_toolbar({type => 'item', label => 'Fred', callback => sub { Gtk->main_quit },
		      pixmap_type => 'stock', pixmap_info => 'Quit',
		      hint => "Click here to quit"},
		     {type => 'item', label => 'Wilma',
		      pixmap_type => 'stock', pixmap_info => 'Timer'},
		     ['item', 'Barney', undef, undef, 'stock', 'About']);

show_all $app;
main Gtk;
