
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::ToggleButton		PACKAGE = Gtk::ToggleButton		PREFIX = gtk_toggle_button_

#ifdef GTK_TOGGLE_BUTTON

Gtk::ToggleButton_Sink
new(Class, label=0)
	SV *	Class
	char *	label
	ALIAS:
		Gtk::ToggleButton::new = 0
		Gtk::ToggleButton::new_with_label = 1
	CODE:
	if (label)
		RETVAL = GTK_TOGGLE_BUTTON(gtk_toggle_button_new_with_label(label));
	else
		RETVAL = GTK_TOGGLE_BUTTON(gtk_toggle_button_new());
	OUTPUT:
	RETVAL

void
gtk_toggle_button_set_active(self, state)
	Gtk::ToggleButton	self
	int	state
	ALIAS:
		Gtk::ToggleButton::set_state = 1
	CODE:
#if GTK_HVER < 0x010114
	/* DEPRECATED */
	gtk_toggle_button_set_state(self, state);
#else
	gtk_toggle_button_set_active(self, state);
#endif

void
gtk_toggle_button_set_mode(self, draw_indicator)
	Gtk::ToggleButton	self
	int	draw_indicator

void
gtk_toggle_button_toggled(self)
	Gtk::ToggleButton	self

int
active(self, new_value=0)
	Gtk::ToggleButton	self
	int	new_value
	CODE:
		RETVAL = self->active;
		if (items>1)
			self->active = new_value;
	OUTPUT:
	RETVAL

int
draw_indicator(self)
	Gtk::ToggleButton	self
	CODE:
		RETVAL = self->draw_indicator;
	OUTPUT:
	RETVAL

#endif
