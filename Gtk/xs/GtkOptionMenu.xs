#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::OptionMenu		PACKAGE = Gtk::OptionMenu		PREFIX = gtk_option_menu_

#ifdef GTK_OPTION_MENU

Gtk::OptionMenu_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_OPTION_MENU(gtk_option_menu_new());
	OUTPUT:
	RETVAL

Gtk::Widget
gtk_option_menu_get_menu(self)
	Gtk::OptionMenu	self

void
gtk_option_menu_set_menu(self, menu)
	Gtk::OptionMenu	self
	Gtk::Widget	menu

void
gtk_option_menu_remove_menu(self)
	Gtk::OptionMenu	self

void
gtk_option_menu_set_history(self, index)
	Gtk::OptionMenu	self
	int	index

#endif
