
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::HRuler		PACKAGE = Gtk::HRuler

#ifdef GTK_HRULER

Gtk::HRuler_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_HRULER(gtk_hruler_new());
	OUTPUT:
	RETVAL

#endif
