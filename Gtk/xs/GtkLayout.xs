
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
gtk_layout_put(layout, widget, x, y)
	Gtk::Layout	layout
	Gtk::Widget	widget
	int		x
	int		y

void
gtk_layout_move(layout, widget, x, y)
	Gtk::Layout	layout
	Gtk::Widget	widget
	int		x
	int		y

void
gtk_layout_set_size(layout, width, height)
	Gtk::Layout	layout
	int		width
	int		height

Gtk::Adjustment
gtk_layout_get_hadjustment(layout)
	Gtk::Layout	layout

Gtk::Adjustment
gtk_layout_get_vadjustment(layout)
	Gtk::Layout	layout

void
gtk_layout_set_hadjustment(layout, hadj)
	Gtk::Layout	layout
	Gtk::Adjustment_OrNULL	hadj

void
gtk_layout_set_vadjustment(layout, vadj)
	Gtk::Layout	layout
	Gtk::Adjustment_OrNULL	vadj

void
gtk_layout_freeze(layout)
	Gtk::Layout	layout

void
gtk_layout_thaw(layout)
	Gtk::Layout	layout

Gtk::Gdk::Window
bin_window (layout)
	Gtk::Layout	layout
	CODE:
	RETVAL = layout->bin_window;
	OUTPUT:
	RETVAL

guint
width (layout)
	Gtk::Layout	layout
	CODE:
	RETVAL = layout->width;
	OUTPUT:
	RETVAL

guint
height (layout)
	Gtk::Layout	layout
	CODE:
	RETVAL = layout->height;
	OUTPUT:
	RETVAL

guint
xoffset (layout)
	Gtk::Layout	layout
	CODE:
	RETVAL = layout->xoffset;
	OUTPUT:
	RETVAL

guint
yoffset (layout)
	Gtk::Layout	layout
	CODE:
	RETVAL = layout->yoffset;
	OUTPUT:
	RETVAL


#endif

