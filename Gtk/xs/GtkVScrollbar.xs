
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::VScrollbar		PACKAGE = Gtk::VScrollbar

#ifdef GTK_VSCROLLBAR

Gtk::VScrollbar_Sink
new(Class, adjustment)
	SV *	Class
	Gtk::Adjustment	adjustment
	CODE:
	RETVAL = GTK_VSCROLLBAR(gtk_vscrollbar_new(adjustment));
	OUTPUT:
	RETVAL

#endif
