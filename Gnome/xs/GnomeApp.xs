
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

/* XXX Add dock, etc */

MODULE = Gnome::App		PACKAGE = Gnome::App		PREFIX = gnome_app_

#ifdef GNOME_APP

Gnome::App_Sink
new(Class, appname, title)
	SV *	Class
	char *	appname
	char *	title
	CODE:
	RETVAL = GNOME_APP(gnome_app_new(appname, title));
	OUTPUT:
	RETVAL

void
gnome_app_set_menus(app, menubar)
	Gnome::App	app
	Gtk::MenuBar	menubar

void
gnome_app_set_toolbar(app, toolbar)
	Gnome::App	app
	Gtk::Toolbar	toolbar

void
gnome_app_set_statusbar(app, contents)
	Gnome::App	app
	Gtk::Widget	contents

void
gnome_app_set_contents(app, contents)
	Gnome::App	app
	Gtk::Widget	contents

#endif

