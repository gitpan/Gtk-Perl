
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Arrow		PACKAGE = Gtk::Arrow		PREFIX = gtk_arrow_

#ifdef GTK_ARROW

Gtk::Arrow_Sink
new(Class, arrow_type, shadow_type)
	SV *	Class
	Gtk::ArrowType	arrow_type
	Gtk::ShadowType	shadow_type
	CODE:
	RETVAL = GTK_ARROW(gtk_arrow_new(arrow_type, shadow_type));
	OUTPUT:
	RETVAL

void
gtk_arrow_set(arrow, arrow_type, shadow_type)
	Gtk::Arrow	arrow
	Gtk::ArrowType	arrow_type
	Gtk::ShadowType	shadow_type

#endif
