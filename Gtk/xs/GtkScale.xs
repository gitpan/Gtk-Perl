
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Scale		PACKAGE = Gtk::Scale	PREFIX = gtk_scale_

#ifdef GTK_SCALE

void
gtk_scale_set_digits(self, digits)
	Gtk::Scale	self
	int	digits

void
gtk_scale_set_draw_value(self, draw_value)
	Gtk::Scale	self
	int	draw_value

void
gtk_scale_set_value_pos(self, pos)
	Gtk::Scale	self
	Gtk::PositionType	pos

int
gtk_scale_get_value_width(self)
	Gtk::Scale	self
	ALIAS:
		Gtk::Scale::value_width = 1
	CODE:
#if GTK_HVER < 0x010106
	RETVAL = gtk_scale_value_width(self);
#else
	RETVAL = gtk_scale_get_value_width(self);
#endif
	OUTPUT:
	RETVAL

void
gtk_scale_draw_value(self)
	Gtk::Scale	self

#endif
