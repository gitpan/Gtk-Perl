
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"


MODULE = Gnome::DialogUtil		PACKAGE = Gnome::DialogUtil

Gtk::Widget_Sink
ok(Class, message, parent=0)
	SV *	Class
	char *	message
	Gtk::Widget	parent
	CODE:
	RETVAL = GTK_WIDGET(parent ? gnome_ok_dialog_parented(message, parent) : gnome_ok_dialog(message));
	OUTPUT:
	RETVAL

Gtk::Widget_Sink
error(Class, message, parent=0)
	SV *	Class
	char *	message
	Gtk::Widget	parent
	CODE:
	RETVAL = GTK_WIDGET(parent ? gnome_error_dialog_parented(message, parent) : gnome_error_dialog(message));
	OUTPUT:
	RETVAL

Gtk::Widget_Sink
warning(Class, message, parent=0)
	SV *	Class
	char *	message
	Gtk::Widget	parent
	CODE:
	RETVAL = GTK_WIDGET(parent ? gnome_warning_dialog_parented(message, parent) : gnome_warning_dialog(message));
	OUTPUT:
	RETVAL


