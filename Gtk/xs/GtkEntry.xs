
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Entry		PACKAGE = Gtk::Entry	PREFIX = gtk_entry_

#ifdef GTK_ENTRY

Gtk::Entry_Sink
new(Class, max_length = 0)
	SV *	Class
	int	max_length
	ALIAS:
		Gtk::Entry::new = 0
		Gtk::Entry::new_with_max_length = 1
	CODE:
	if (items == 1)
		RETVAL = GTK_ENTRY(gtk_entry_new());
	else
		RETVAL = GTK_ENTRY(gtk_entry_new_with_max_length(max_length));
	OUTPUT:
	RETVAL

void
gtk_entry_set_text(self, text)
	Gtk::Entry	self
	char *	text

void
gtk_entry_append_text(self, text)
	Gtk::Entry	self
	char *	text

void
gtk_entry_prepend_text(self, text)
	Gtk::Entry	self
	char *	text

void
gtk_entry_set_position(self, position)
	Gtk::Entry	self
	int	position

char *
gtk_entry_get_text(self)
	Gtk::Entry	self

void
gtk_entry_select_region (self, start, end)
	Gtk::Entry  self
	int start
	int end

void
gtk_entry_set_visibility (self, visibility)
	Gtk::Entry  self
	bool visibility

void
gtk_entry_set_editable (self, editable)
	Gtk::Entry  self
	bool editable

void
gtk_entry_set_max_length (self, max)
	Gtk::Entry  self
	int max

#endif
