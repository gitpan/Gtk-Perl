
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::FontSelectionDialog	PACKAGE = Gtk::FontSelectionDialog	PREFIX = gtk_font_selection_dialog_

#ifdef GTK_FONT_SELECTION_DIALOG

Gtk::FontSelectionDialog_Sink
gtk_font_selection_dialog_new(Class, title)
	SV *	Class
	char*	title
	CODE:
	RETVAL = GTK_FONT_SELECTION_DIALOG(gtk_font_selection_dialog_new(title));
	OUTPUT:
	RETVAL

char*
gtk_font_selection_dialog_get_font_name(font_selection_dialog)
	Gtk::FontSelectionDialog	font_selection_dialog

Gtk::Gdk::Font
gtk_font_selection_dialog_get_font(font_selection_dialog)
	Gtk::FontSelectionDialog	font_selection_dialog

bool
gtk_font_selection_dialog_set_font_name(font_selection_dialog, font_name)
	Gtk::FontSelectionDialog	font_selection_dialog
	char*			font_name

char*
gtk_font_selection_dialog_get_preview_text(font_selection_dialog)
	Gtk::FontSelectionDialog	font_selection_dialog

void
gtk_font_selection_dialog_set_preview_text(font_selection_dialog, text)
	Gtk::FontSelectionDialog	font_selection_dialog
	char*			text

Gtk::Widget_Up
fontsel(font_selection_dialog)
	Gtk::FontSelectionDialog	font_selection_dialog
	CODE:
	RETVAL = font_selection_dialog->fontsel;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
main_vbox(font_selection_dialog)
	Gtk::FontSelectionDialog	font_selection_dialog
	CODE:
	RETVAL = font_selection_dialog->main_vbox;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
action_area(font_selection_dialog)
	Gtk::FontSelectionDialog	font_selection_dialog
	CODE:
	RETVAL = font_selection_dialog->action_area;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
ok_button(font_selection_dialog)
	Gtk::FontSelectionDialog	font_selection_dialog
	CODE:
	RETVAL = font_selection_dialog->ok_button;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
apply_button(font_selection_dialog)
	Gtk::FontSelectionDialog	font_selection_dialog
	CODE:
	RETVAL = font_selection_dialog->apply_button;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
cancel_button(font_selection_dialog)
	Gtk::FontSelectionDialog	font_selection_dialog
	CODE:
	RETVAL = font_selection_dialog->cancel_button;
	OUTPUT:
	RETVAL


#endif

