
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::ProgressBar		PACKAGE = Gtk::ProgressBar		PREFIX = gtk_progress_bar_

#ifdef GTK_PROGRESS_BAR

Gtk::ProgressBar_Sink
new(Class)
	CODE:
	RETVAL = GTK_PROGRESS_BAR(gtk_progress_bar_new());
	OUTPUT:
	RETVAL

void
gtk_progress_bar_update(self, percentage)
	Gtk::ProgressBar	self
	double	percentage

# FIXME: DEPRECATED?

double
percentage(self)
	Gtk::ProgressBar	self
	CODE:
#if GTK_HVER < 0x010100	
	RETVAL = self->percentage;
#else
	RETVAL = gtk_progress_get_current_percentage(GTK_PROGRESS(self));
#endif
	OUTPUT:
	RETVAL

#endif
