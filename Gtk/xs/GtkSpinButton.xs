
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::SpinButton		PACKAGE = Gtk::SpinButton		PREFIX = gtk_spin_button_

#ifdef GTK_SPIN_BUTTON

Gtk::SpinButton_Sink
new(Class, adjustment, climb_rate, digits)
	SV * Class
	Gtk::Adjustment adjustment
	double climb_rate
	int digits
	CODE:
	RETVAL = GTK_SPIN_BUTTON(gtk_spin_button_new(adjustment, climb_rate, digits));
	OUTPUT:
	RETVAL

void
gtk_spin_button_set_adjustment(self, adjustment)
	Gtk::SpinButton self
	Gtk::Adjustment adjustment

Gtk::Adjustment
gtk_spin_button_get_adjustment(self)
	Gtk::SpinButton self

void
gtk_spin_button_set_digits(self, digits)
	Gtk::SpinButton self
	int digits

int
gtk_spin_button_digits(self)
	Gtk::SpinButton self
	CODE:
	RETVAL = self->digits;
	OUTPUT:
	RETVAL

double
gtk_spin_button_get_value_as_float(self)
	Gtk::SpinButton self

int
gtk_spin_button_get_value_as_int(self)
	Gtk::SpinButton self

void
gtk_spin_button_set_value(self, value)
	Gtk::SpinButton self
	gfloat value

void
gtk_spin_button_set_update_policy(self, policy)
	Gtk::SpinButton	self
	Gtk::SpinButtonUpdatePolicy policy


void
gtk_spin_button_set_numeric(self, numeric)
	Gtk::SpinButton self
	int numeric

void
gtk_spin_button_spin(self, direction, step)
	Gtk::SpinButton self
	Gtk::ArrowType	direction
	gfloat	step

void
gtk_spin_button_set_wrap(self, wrap)
	Gtk::SpinButton self
	int	wrap

void
gtk_spin_button_set_snap_to_ticks(self, snap_to_ticks)
	Gtk::SpinButton self
	int snap_to_ticks
	CODE:
#if GTK_HVER >= 0x010100
	gtk_spin_button_set_snap_to_ticks(self, snap_to_ticks);
#else
	/* FIXME: Is this even vaguely right? */
	if (snap_to_ticks)
		gtk_spin_button_set_update_policy(self, GTK_UPDATE_SNAP_TO_TICKS);
	else
		gtk_spin_button_set_update_policy(self, GTK_UPDATE_ALWAYS);
#endif

#endif

