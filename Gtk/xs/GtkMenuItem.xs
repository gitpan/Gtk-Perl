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
gtk_menu_item_set_submenu(menu_item, child)
	Gtk::MenuItem	menu_item
	Gtk::Widget	child

void
gtk_menu_item_remove_submenu (menu_item)
	Gtk::MenuItem   menu_item

void
gtk_menu_item_set_placement(menu_item, placement)
	Gtk::MenuItem	menu_item
	Gtk::SubmenuPlacement	placement

#if GTK_HVER < 0x010100

void
gtk_menu_item_accelerator_size(menu_item)
	Gtk::MenuItem	menu_item

void
gtk_menu_item_accelerator_text(menu_item, buffer)
	Gtk::MenuItem	menu_item
	char *	buffer

#endif

void
gtk_menu_item_configure(menu_item, show_toggle, show_submenu)
	Gtk::MenuItem	menu_item
	bool	show_toggle
	bool	show_submenu

void
gtk_menu_item_select(menu_item)
	Gtk::MenuItem	menu_item

void
gtk_menu_item_deselect(menu_item)
	Gtk::MenuItem	menu_item

void
gtk_menu_item_activate(menu_item)
	Gtk::MenuItem	menu_item

void
gtk_menu_item_right_justify(menu_item)
	Gtk::MenuItem	menu_item

#endif
