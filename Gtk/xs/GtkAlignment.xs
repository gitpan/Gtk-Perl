
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Alignment		PACKAGE = Gtk::Alignment	PREFIX = gtk_alignment_

#ifdef GTK_ALIGNMENT

Gtk::Alignment_Sink
new(Class, xalign, yalign, xscale, yscale)
	SV *	Class
	double	xalign
	double	yalign
	double	xscale
	double	yscale
	CODE:
	RETVAL = GTK_ALIGNMENT(gtk_alignment_new(xalign, yalign, xscale, yscale));
	OUTPUT:
	RETVAL

void
gtk_alignment_set(self, xalign, yalign, xscale, yscale)
	Gtk::Alignment	self
	double	xalign
	double	yalign
	double	xscale
	double	yscale

#endif
