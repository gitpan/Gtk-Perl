
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::AccelLabel		PACKAGE = Gtk::AccelLabel		PREFIX = gtk_accel_label_

#ifdef GTK_ACCEL_LABEL

Gtk::AccelLabel_Sink
gtk_accel_label_new(Class, string)
	SV 	*Class
	char	*string
	CODE:
	RETVAL = GTK_ACCEL_LABEL(gtk_accel_label_new(string));
	OUTPUT:
	RETVAL

unsigned int
gtk_accel_label_get_accel_width(self)
	Gtk::AccelLabel	self
	ALIAS:
		Gtk::AccelLabel::accelerator_width = 1
	CODE:
#if GTK_HVER < 0x010106
	/* DEPRECATED */
	RETVAL = gtk_accel_label_accelerator_width(self);
#else
	RETVAL = gtk_accel_label_get_accel_width(self);
#endif
	OUTPUT:
	RETVAL

void
gtk_accel_label_set_accel_widget(self, accel_widget)
	Gtk::AccelLabel	self
	Gtk::Widget	accel_widget

bool
gtk_accel_label_refetch(self)
	Gtk::AccelLabel	self


#endif

