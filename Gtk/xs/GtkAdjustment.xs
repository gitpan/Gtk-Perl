#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Adjustment		PACKAGE = Gtk::Adjustment		PREFIX = gtk_adjustment_

#ifdef GTK_ADJUSTMENT

Gtk::Adjustment_Sink
new(Class, value, lower, upper, step_increment, page_increment, page_size)
	SV *	Class
	double	value
	double	lower
	double	upper
	double	step_increment
	double	page_increment
	double	page_size
	CODE:
	RETVAL = GTK_ADJUSTMENT(gtk_adjustment_new(value, lower, upper, step_increment, page_increment, page_size));
	OUTPUT:
	RETVAL

void
gtk_adjustment_set_value (self, value)
	Gtk::Adjustment self
	double value

gfloat
gtk_adjustment_get_value (self)
	Gtk::Adjustment self
	CODE:
	RETVAL = self->value;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_value (self, change=0)
	Gtk::Adjustment self
	gfloat	change
	CODE:
	RETVAL = self->value;
	if (items==2)
		self->value = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_lower (self, change=0)
	Gtk::Adjustment self
	gfloat	change
	CODE:
	RETVAL = self->lower;
	if (items==2)
		self->lower = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_upper (self, change=0)
	Gtk::Adjustment self
	gfloat	change
	CODE:
	RETVAL = self->upper;
	if (items==2)
		self->upper = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_step_increment (self, change=0)
	Gtk::Adjustment self
	gfloat	change
	CODE:
	RETVAL = self->step_increment;
	if (items==2)
		self->step_increment = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_page_increment (self, change=0)
	Gtk::Adjustment self
	gfloat	change
	CODE:
	RETVAL = self->page_increment;
	if (items==2)
		self->page_increment = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_page_size (self, change=0)
	Gtk::Adjustment self
	gfloat	change
	CODE:
	RETVAL = self->page_size;
	if (items==2)
		self->page_size = change;
	OUTPUT:
	RETVAL

#if GTK_HVER >= 0x010200

void
gtk_adjustment_changed (adj)
	Gtk::Adjustment	adj

void
gtk_adjustment_value_changed (adj)
	Gtk::Adjustment	adj

void
gtk_adjustment_clamp_page (adj, lower, upper)
	Gtk::Adjustment adj
	double	lower
	double	upper

#endif

#endif
