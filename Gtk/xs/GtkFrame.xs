
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Frame		PACKAGE = Gtk::Frame		PREFIX = gtk_frame_

#ifdef GTK_FRAME

Gtk::Frame_Sink
new(Class, label=&PL_sv_undef)
	SV *	Class
	SV *	label
	CODE:
	{
		char * l = SvOK(label) ? SvPV(label, PL_na) : 0;
		RETVAL = GTK_FRAME(gtk_frame_new(l));
	}
	OUTPUT:
	RETVAL

void
gtk_frame_set_label(self, label)
	Gtk::Frame	self
	char *	label

void
gtk_frame_set_label_align(self, xalign, yalign)
	Gtk::Frame	self
	double	xalign
	double	yalign

void
gtk_frame_set_shadow_type(self, shadow)
	Gtk::Frame	self
	Gtk::ShadowType	shadow

#endif
