#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Box		PACKAGE = Gtk::Box	PREFIX = gtk_box_

#ifdef GTK_BOX

void
gtk_box_pack_start(box, child, expand, fill, padding)
	Gtk::Box	box
	Gtk::Widget	child
	int	expand
	int	fill
	int	padding

void
gtk_box_pack_end(box, child, expand, fill, padding)
	Gtk::Box	box
	Gtk::Widget	child
	int	expand
	int	fill
	int	padding

void
gtk_box_pack_start_defaults(box, child)
	Gtk::Box	box
	Gtk::Widget	child

void
gtk_box_pack_end_defaults(box, child)
	Gtk::Box	box
	Gtk::Widget	child

void
gtk_box_set_homogeneous(box, homogeneous)
	Gtk::Box	box
	int	homogeneous

void
gtk_box_set_spacing(box, spacing)
	Gtk::Box	box
	int	spacing

void
gtk_box_reorder_child (box, child, pos)
	Gtk::Box    box
	Gtk::Widget child
	int pos

void
gtk_box_query_child_packing (box, child)
	Gtk::Box    box
	Gtk::Widget child
	PREINIT:
	int expand, fill, padding;
	GtkPackType pack_type;
	PPCODE:
		gtk_box_query_child_packing (box, child, &expand, &fill, &padding, &pack_type);
		EXTEND(sp,4);
		PUSHs(sv_2mortal(newSViv(expand)));
		PUSHs(sv_2mortal(newSViv(fill)));
		PUSHs(sv_2mortal(newSViv(padding)));
		PUSHs(sv_2mortal(newSViv(pack_type)));
		

void
gtk_box_set_child_packing (box, child, expand, fill, padding, pack_type)
	Gtk::Box    box
	Gtk::Widget child
	int expand
	int fill
	int padding
	Gtk::PackType pack_type

void
children(box)
	Gtk::Box	box
	PPCODE:
	{
		GList * list;
		if (GIMME != G_ARRAY) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSViv(g_list_length(box->children))));
		} else {
			for(list = box->children; list; list = list->next) {
				EXTEND(sp, 1);
				PUSHs(sv_2mortal(newSVGtkBoxChild((GtkBoxChild*)list->data)));
			}
		}
	}

#endif

MODULE = Gtk::Box		PACKAGE = Gtk::BoxChild	PREFIX = gtk_box_

#ifdef GTK_BOX

Gtk::Widget_Up
widget(child)
	Gtk::BoxChild	child
	CODE:
	RETVAL = child->widget;
	OUTPUT:
	RETVAL

int
padding(child)
	Gtk::BoxChild	child
	CODE:
	RETVAL = child->padding;
	OUTPUT:
	RETVAL

int
expand(child)
	Gtk::BoxChild	child
	CODE:
	RETVAL = child->expand;
	OUTPUT:
	RETVAL

int
fill(child)
	Gtk::BoxChild	child
	CODE:
	RETVAL = child->fill;
	OUTPUT:
	RETVAL

int
pack(child)
	Gtk::BoxChild	child
	CODE:
	RETVAL = child->pack;
	OUTPUT:
	RETVAL

#endif
