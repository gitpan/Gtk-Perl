
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Fixed		PACKAGE = Gtk::Fixed		PREFIX = gtk_fixed_

#ifdef GTK_FIXED

Gtk::Fixed_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_FIXED(gtk_fixed_new());
	OUTPUT:
	RETVAL

void
gtk_fixed_put(self, widget, x, y)
	Gtk::Fixed	self
	Gtk::Widget	widget
	int	x
	int	y

void
gtk_fixed_move(self, widget, x, y)
	Gtk::Fixed	self
	Gtk::Widget	widget
	int	x
	int	y

#endif