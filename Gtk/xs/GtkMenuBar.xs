
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::MenuBar		PACKAGE = Gtk::MenuBar		PREFIX = gtk_menu_bar_

#ifdef GTK_MENU_BAR

Gtk::MenuBar_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_MENU_BAR(gtk_menu_bar_new());
	OUTPUT:
	RETVAL

void
gtk_menu_bar_append(self, child)
	Gtk::MenuBar	self
	Gtk::Widget	child

void
gtk_menu_bar_prepend(self, child)
	Gtk::MenuBar	self
	Gtk::Widget	child

void
gtk_menu_bar_insert(self, child, position)
	Gtk::MenuBar	self
	Gtk::Widget	child
	int	position

# if GTK_HVER >= 0x010105

void
gtk_menu_bar_set_shadow_type (self, type)
	Gtk::MenuBar	self
	Gtk::ShadowType	type
	
#endif

#endif
