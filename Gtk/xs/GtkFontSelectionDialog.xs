
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
gtk_font_selection_dialog_get_font_name(self)
	Gtk::FontSelectionDialog	self

Gtk::Gdk::Font
gtk_font_selection_dialog_get_font(self)
	Gtk::FontSelectionDialog	self

bool
gtk_font_selection_dialog_set_font_name(self, font_name)
	Gtk::FontSelectionDialog	self
	char*			font_name

char*
gtk_font_selection_dialog_get_preview_text(self)
	Gtk::FontSelectionDialog	self

void
gtk_font_selection_dialog_set_preview_text(self, text)
	Gtk::FontSelectionDialog	self
	char*			text

Gtk::Widget_Up
fontsel(self)
	Gtk::FontSelectionDialog	self
	CODE:
	RETVAL = self->fontsel;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
main_vbox(self)
	Gtk::FontSelectionDialog	self
	CODE:
	RETVAL = self->main_vbox;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
action_area(self)
	Gtk::FontSelectionDialog	self
	CODE:
	RETVAL = self->action_area;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
ok_button(self)
	Gtk::FontSelectionDialog	self
	CODE:
	RETVAL = self->ok_button;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
apply_button(self)
	Gtk::FontSelectionDialog	self
	CODE:
	RETVAL = self->apply_button;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
cancel_button(self)
	Gtk::FontSelectionDialog	self
	CODE:
	RETVAL = self->cancel_button;
	OUTPUT:
	RETVAL


#endif

