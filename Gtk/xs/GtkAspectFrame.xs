
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::AspectFrame		PACKAGE = Gtk::AspectFrame		PREFIX = gtk_aspect_frame_

#ifdef GTK_ASPECT_FRAME

Gtk::AspectFrame_Sink
new(Class, label, xalign, yalign, ratio, obey_child)
	SV *	Class
	char *	label
	double	xalign
	double	yalign
	double	ratio
	bool	obey_child
	CODE:
	RETVAL = GTK_ASPECT_FRAME(gtk_aspect_frame_new(label, xalign, yalign, ratio, obey_child));
	OUTPUT:
	RETVAL

void
gtk_aspect_frame_set(self, xalign, yalign, ratio, obey_child)
	Gtk::AspectFrame	self
	double	xalign
	double	yalign
	double	ratio
	bool	obey_child

#endif
