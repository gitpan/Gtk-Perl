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
gtk_adjustment_set_value (adjustment, value)
	Gtk::Adjustment adjustment
	double value

gfloat
gtk_adjustment_get_value (adjustment)
	Gtk::Adjustment adjustment
	CODE:
	RETVAL = adjustment->value;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_value (adjustment, change=0)
	Gtk::Adjustment adjustment
	gfloat	change
	CODE:
	RETVAL = adjustment->value;
	if (items==2)
		adjustment->value = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_lower (adjustment, change=0)
	Gtk::Adjustment adjustment
	gfloat	change
	CODE:
	RETVAL = adjustment->lower;
	if (items==2)
		adjustment->lower = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_upper (adjustment, change=0)
	Gtk::Adjustment adjustment
	gfloat	change
	CODE:
	RETVAL = adjustment->upper;
	if (items==2)
		adjustment->upper = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_step_increment (adjustment, change=0)
	Gtk::Adjustment adjustment
	gfloat	change
	CODE:
	RETVAL = adjustment->step_increment;
	if (items==2)
		adjustment->step_increment = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_page_increment (adjustment, change=0)
	Gtk::Adjustment adjustment
	gfloat	change
	CODE:
	RETVAL = adjustment->page_increment;
	if (items==2)
		adjustment->page_increment = change;
	OUTPUT:
	RETVAL

gfloat
gtk_adjustment_page_size (adjustment, change=0)
	Gtk::Adjustment adjustment
	gfloat	change
	CODE:
	RETVAL = adjustment->page_size;
	if (items==2)
		adjustment->page_size = change;
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
