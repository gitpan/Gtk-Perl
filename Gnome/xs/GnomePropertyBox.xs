
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gnome::PropertyBox		PACKAGE = Gnome::PropertyBox		PREFIX = gnome_property_box_

#ifdef GNOME_PROPERTY_BOX

Gnome::PropertyBox_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_PROPERTY_BOX(gnome_property_box_new());
	OUTPUT:
	RETVAL

void
gnome_property_box_changed(box)
	Gnome::PropertyBox	box

void
gnome_property_box_append_page(box, child, tab_label)
	Gnome::PropertyBox	box
	Gtk::Widget	child
	Gtk::Widget	tab_label

#endif

