
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Layout		PACKAGE = Gtk::Layout		PREFIX = gtk_layout_

#ifdef GTK_LAYOUT

Gtk::Layout_Sink
new(Class, hadj=0, vadj=0)
	SV*	Class
	Gtk::Adjustment_OrNULL	hadj
	Gtk::Adjustment_OrNULL	vadj
	CODE:
	RETVAL=GTK_LAYOUT(gtk_layout_new(hadj, vadj));
	OUTPUT:
	RETVAL

void
gtk_layout_put(self, widget, x, y)
	Gtk::Layout	self
	Gtk::Widget	widget
	int		x
	int		y

void
gtk_layout_move(self, widget, x, y)
	Gtk::Layout	self
	Gtk::Widget	widget
	int		x
	int		y

void
gtk_layout_set_size(self, width, height)
	Gtk::Layout	self
	int		width
	int		height

Gtk::Adjustment
gtk_layout_get_hadjustment(self)
	Gtk::Layout	self

Gtk::Adjustment
gtk_layout_get_vadjustment(self)
	Gtk::Layout	self

void
gtk_layout_set_hadjustment(self, hadj)
	Gtk::Layout	self
	Gtk::Adjustment_OrNULL	hadj

void
gtk_layout_set_vadjustment(self, vadj)
	Gtk::Layout	self
	Gtk::Adjustment_OrNULL	vadj

void
gtk_layout_freeze(self)
	Gtk::Layout	self

void
gtk_layout_thaw(self)
	Gtk::Layout	self

Gtk::Gdk::Window
bin_window (self)
	Gtk::Layout	self
	CODE:
	RETVAL = self->bin_window;
	OUTPUT:
	RETVAL

guint
width (self)
	Gtk::Layout	self
	CODE:
	RETVAL = self->width;
	OUTPUT:
	RETVAL

guint
height (self)
	Gtk::Layout	self
	CODE:
	RETVAL = self->height;
	OUTPUT:
	RETVAL

guint
xoffset (self)
	Gtk::Layout	self
	CODE:
	RETVAL = self->xoffset;
	OUTPUT:
	RETVAL

guint
yoffset (self)
	Gtk::Layout	self
	CODE:
	RETVAL = self->yoffset;
	OUTPUT:
	RETVAL


#endif

