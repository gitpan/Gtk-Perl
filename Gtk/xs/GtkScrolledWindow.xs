
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::ScrolledWindow		PACKAGE = Gtk::ScrolledWindow	PREFIX = gtk_scrolled_window_

#ifdef GTK_SCROLLED_WINDOW

Gtk::ScrolledWindow_Sink
new(Class, hadj=0, vadj=0)
	SV *	Class
	Gtk::Adjustment_OrNULL	hadj
	Gtk::Adjustment_OrNULL	vadj
	CODE:
	RETVAL = GTK_SCROLLED_WINDOW(gtk_scrolled_window_new(hadj, vadj));
	OUTPUT:
	RETVAL

Gtk::Adjustment
gtk_scrolled_window_get_hadjustment(self)
	Gtk::ScrolledWindow	self

Gtk::Adjustment
gtk_scrolled_window_get_vadjustment(self)
	Gtk::ScrolledWindow	self

void
gtk_scrolled_window_set_policy(self, hscrollbar_policy, vscrollbar_policy)
	Gtk::ScrolledWindow	self
	Gtk::PolicyType	hscrollbar_policy
	Gtk::PolicyType	vscrollbar_policy

SV *
add_with_viewport(self, widget)
	Gtk::ScrolledWindow	self
	Gtk::Widget		widget
	CODE:
#if GTK_HVER >= 0x010104
		gtk_scrolled_window_add_with_viewport(self, widget);
#else
		/* DEPRECATED */
		gtk_container_add(GTK_CONTAINER(self), widget);
#endif
		RETVAL = newSVsv(ST(1));
	OUTPUT:
	RETVAL


#endif
