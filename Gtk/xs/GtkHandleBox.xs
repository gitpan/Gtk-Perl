
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::HandleBox		PACKAGE = Gtk::HandleBox	PREFIX = gtk_handle_box_

#ifdef GTK_HANDLE_BOX

Gtk::HandleBox_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_HANDLE_BOX(gtk_handle_box_new());
	OUTPUT:
	RETVAL

#if GTK_HVER >= 0x01010F

void
gtk_handle_box_set_shadow_type(self, type)
	Gtk::HandleBox	self
	Gtk::ShadowType	type

void
gtk_handle_box_set_handle_position(self, position)
	Gtk::HandleBox	self
	Gtk::PositionType	position

void
gtk_handle_box_set_snap_edge(self, edge)
	Gtk::HandleBox	self
	Gtk::PositionType	edge

#endif


#endif
