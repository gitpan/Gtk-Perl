#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::MenuItem		PACKAGE = Gtk::MenuItem		PREFIX = gtk_menu_item_

#ifdef GTK_MENU_ITEM

Gtk::MenuItem_Sink
new(Class, label=0)
	SV *	Class
	char *	label
	ALIAS:
		Gtk::MenuItem::new = 0
		Gtk::MenuItem::new_with_label = 1
	CODE:
	if (label)
		RETVAL = GTK_MENU_ITEM(gtk_menu_item_new_with_label(label));
	else
		RETVAL = GTK_MENU_ITEM(gtk_menu_item_new());
	OUTPUT:
	RETVAL

void
gtk_menu_item_set_submenu(self, child)
	Gtk::MenuItem	self
	Gtk::Widget	child

void
gtk_menu_item_remove_submenu (self)
	Gtk::MenuItem   self

void
gtk_menu_item_set_placement(self, placement)
	Gtk::MenuItem	self
	Gtk::SubmenuPlacement	placement

#if GTK_HVER < 0x010100

void
gtk_menu_item_accelerator_size(self)
	Gtk::MenuItem	self

void
gtk_menu_item_accelerator_text(self, buffer)
	Gtk::MenuItem	self
	char *	buffer

#endif

void
gtk_menu_item_configure(self, show_toggle, show_submenu)
	Gtk::MenuItem	self
	bool	show_toggle
	bool	show_submenu

void
gtk_menu_item_select(self)
	Gtk::MenuItem	self

void
gtk_menu_item_deselect(self)
	Gtk::MenuItem	self

void
gtk_menu_item_activate(self)
	Gtk::MenuItem	self

void
gtk_menu_item_right_justify(self)
	Gtk::MenuItem	self

#endif
