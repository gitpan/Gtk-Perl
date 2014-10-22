
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Combo		PACKAGE = Gtk::Combo		PREFIX = gtk_combo_

#ifdef GTK_COMBO

Gtk::Combo_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_COMBO(gtk_combo_new());
	OUTPUT:
	RETVAL

void
gtk_combo_set_value_in_list(combo, val, ok_if_empty)
	Gtk::Combo	combo
	int	val
	int	ok_if_empty

void
gtk_combo_set_use_arrows(combo, val)
	Gtk::Combo	combo
	int	val

void
gtk_combo_set_use_arrows_always(combo, val)
	Gtk::Combo	combo
	int	val

void
gtk_combo_set_case_sensitive (combo, val)
	Gtk::Combo	combo
	int	val

void
gtk_combo_set_item_string(combo, item, item_value)
	Gtk::Combo	combo
	Gtk::Item	item
	char *	item_value

void
gtk_combo_set_popdown_strings(combo, ...)
	Gtk::Combo	combo
	CODE:
	{
		GList * list = 0;
        int i;
        for(i=1;i<items;i++)
        	list = g_list_append(list, SvPV(ST(i),PL_na));
        gtk_combo_set_popdown_strings(combo, g_list_first(list));
	}

void
gtk_combo_disable_activate(combo)
	Gtk::Combo	combo

Gtk::Widget_Up
list (combo)
	Gtk::Combo	combo
	CODE:
	RETVAL = combo->list;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
entry (combo)
	Gtk::Combo	combo
	CODE:
	RETVAL = combo->entry;
	OUTPUT:
	RETVAL

#endif

