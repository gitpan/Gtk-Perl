#!/usr/bin/perl

#TITLE: Gnome applet new
#REQUIRES: Gtk GdkImlib Gnome Applet

use Gnome::Applet;

init Gnome::AppletWidget 'applet.pl';

$a = new Gnome::AppletWidget 'applet.pl';
realize $a;

$b = new Gtk::Button "Button";
$b->set_usize(50,50);
show $b;

$a->add($b);
show $a;

gtk_main Gnome::AppletWidget;
