
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::FileSelection		PACKAGE = Gtk::FileSelection	PREFIX = gtk_file_selection_

#ifdef GTK_FILE_SELECTION

Gtk::FileSelection_Sink
new(Class, title)
	SV *	Class
	char *	title
	CODE:
	RETVAL = GTK_FILE_SELECTION(gtk_file_selection_new(title));
	OUTPUT:
	RETVAL

void
gtk_file_selection_set_filename(file_selection, filename)
	Gtk::FileSelection	file_selection
	char *	filename

char *
gtk_file_selection_get_filename(file_selection)
	Gtk::FileSelection	file_selection

void
gtk_file_selection_show_fileop_buttons (file_selection)
	Gtk::FileSelection	file_selection

void
gtk_file_selection_hide_fileop_buttons (file_selection)
	Gtk::FileSelection	file_selection

#if GTK_HVER >= 0x010200

void
gtk_file_selection_complete (file_selection, pattern)
	Gtk::FileSelection	file_selection
	char *	pattern

#endif

Gtk::Widget_Up
ok_button(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->ok_button;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
cancel_button(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->cancel_button;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
dir_list(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->dir_list;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
file_list(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->file_list;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
selection_entry(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->selection_entry;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
selection_text(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->selection_text;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
main_vbox(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->main_vbox;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
help_button(fs)
	Gtk::FileSelection	fs
	CODE:
	RETVAL = fs->help_button;
	OUTPUT:
	RETVAL

#endif
