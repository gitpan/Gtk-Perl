
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Editable		PACKAGE = Gtk::Editable		PREFIX = gtk_editable_

#ifdef GTK_EDITABLE

void
gtk_editable_select_region (editable, start, end)
	Gtk::Editable editable
	int           start
	int           end

int
gtk_editable_insert_text (editable, new_text, position)
	Gtk::Editable editable
	SV*           new_text
	int           position
	CODE:
	{
		STRLEN len;
		char * c = SvPV(new_text, len);
#if GTK_MAJOR_VERSION < 1

		/* FIXME: Do later versions correctly insert text in unrealized text widgets? */

		if (!GTK_WIDGET_REALIZED(GTK_WIDGET(editable)))
			gtk_widget_realize(GTK_WIDGET(editable));
#endif
		gtk_editable_insert_text (editable, c, len, &position);
		RETVAL = position;
	}

void
gtk_editable_delete_text (editable, start, end)
	Gtk::Editable editable
	int           start
	int           end

gstring
gtk_editable_get_chars (editable, start, end)
	Gtk::Editable editable
	int           start
	int           end

#if (GTK_MAJOR_VERSION > 1) || ((GTK_MAJOR_VERSION == 1) && (GTK_MINOR_VERSION >= 1))

void
gtk_editable_cut_clipboard (editable)
	Gtk::Editable editable

void
gtk_editable_copy_clipboard (editable)
	Gtk::Editable editable

void
gtk_editable_paste_clipboard (editable)
	Gtk::Editable editable

#else

void
gtk_editable_cut_clipboard (editable, time)
	Gtk::Editable editable
	int           time

void
gtk_editable_copy_clipboard (editable, time)
	Gtk::Editable editable
	int           time

void
gtk_editable_paste_clipboard (editable, time)
	Gtk::Editable editable
	int           time

#endif

void
gtk_editable_claim_selection (editable, claim, time)
	Gtk::Editable editable
	bool          claim
	int           time

void
gtk_editable_delete_selection (editable)
	Gtk::Editable editable

void
gtk_editable_changed (editable)
	Gtk::Editable editable

#if GTK_HVER > 0x010101

int
gtk_editable_get_position (editable)
	Gtk::Editable editable

void
gtk_editable_set_position (editable, position)
	Gtk::Editable editable
	int           position

void
gtk_editable_set_editable (editable, is_editable)
	Gtk::Editable editable
	bool          is_editable

#endif

#endif

