#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Container-1.0		PACKAGE = Gtk::Container		PREFIX = gtk_container_

#ifdef GTK_CONTAINER

void
gtk_container_set_resize_mode(self, resize_mode)
	Gtk::Container	self
	Gtk::ResizeMode resize_mode

void
gtk_container_check_resize(self)
	Gtk::Container	self

#endif
