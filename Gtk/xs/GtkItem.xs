
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Item		PACKAGE = Gtk::Item		PREFIX = gtk_item_

#ifdef GTK_ITEM

void
gtk_item_select(item)	
	Gtk::Item	item

void
gtk_item_deselect(item)	
	Gtk::Item	item

void
gtk_item_toggle(item)	
	Gtk::Item	item

#endif
