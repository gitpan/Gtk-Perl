
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::HandleBox		PACKAGE = Gtk::HandleBox	PREFIX = gtk_handle_box_

#ifdef GTK_HANDLE_BOX

Gtk::HandleBox_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_HANDLE_BOX(gtk_handle_box_new());
	OUTPUT:
	RETVAL

#endif
