
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::DrawingArea		PACKAGE = Gtk::DrawingArea		PREFIX = gtk_drawing_area_

#ifdef GTK_DRAWING_AREA

Gtk::DrawingArea_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_DRAWING_AREA(gtk_drawing_area_new());
	OUTPUT:
	RETVAL

void
gtk_drawing_area_size(self, width, height)
	Gtk::DrawingArea	self
	int	width
	int	height

#endif
