
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::ListItem		PACKAGE = Gtk::ListItem		PREFIX = gtk_list_item_

#ifdef GTK_LIST_ITEM

Gtk::ListItem_Sink
new(Class, string=0)
	SV *	Class
	char *	string
	ALIAS:
		Gtk::ListItem::new = 0
		Gtk::ListItem::new_with_label = 1
	CODE:
	if (!string)
		RETVAL = GTK_LIST_ITEM(gtk_list_item_new());
	else
		RETVAL = GTK_LIST_ITEM(gtk_list_item_new_with_label(string));
	OUTPUT:
	RETVAL

void
gtk_list_item_select(self)
	Gtk::ListItem	self

void
gtk_list_item_deselect(self)
	Gtk::ListItem	self

#endif
