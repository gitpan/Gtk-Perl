
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Bin		PACKAGE = Gtk::Bin		PREFIX = gtk_bin_

#ifdef GTK_BIN

Gtk::Widget_Up
child(widget, newvalue=0)
	Gtk::Bin	widget
	Gtk::Widget_OrNULL	newvalue
	CODE:
	RETVAL = widget->child;
	if (newvalue)
		widget->child = newvalue;
	OUTPUT:
	RETVAL

#endif

