#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Container-1.0		PACKAGE = Gtk::Container		PREFIX = gtk_container_

#ifdef GTK_CONTAINER

void
gtk_container_set_resize_mode(container, resize_mode)
	Gtk::Container	container
	Gtk::ResizeMode resize_mode

void
gtk_container_check_resize(container)
	Gtk::Container	container

#endif
