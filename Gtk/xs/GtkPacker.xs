
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

/* ??? XXX Is PackerChild relevant? Container should handle that */

MODULE = Gtk::Packer		PACKAGE = Gtk::Packer		PREFIX = gtk_packer_

#ifdef GTK_PACKER

Gtk::Packer_Sink
new(Class)
	CODE:
	RETVAL = GTK_PACKER(gtk_packer_new());
	OUTPUT:
	RETVAL

void
gtk_packer_add_defaults(packer, child, side, anchor, options)
	Gtk::Packer	packer
	Gtk::Widget	child
	Gtk::SideType	side
	Gtk::AnchorType	anchor
	Gtk::PackerOptions	options

void
gtk_packer_add(packer, child, side, anchor, options, border_width, pad_x, pad_y, ipad_x, ipad_y)
	Gtk::Packer	packer
	Gtk::Widget	child
	Gtk::SideType	side
	Gtk::AnchorType	anchor
	Gtk::PackerOptions	options
	int	border_width
	int	pad_x
	int	pad_y
	int	ipad_x
	int	ipad_y

void
gtk_packer_set_child_packing(packer, child, side, anchor, options, border_width, pad_x, pad_y, ipad_x, ipad_y)
	Gtk::Packer	packer
	Gtk::Widget	child
	Gtk::SideType	side
	Gtk::AnchorType	anchor
	Gtk::PackerOptions	options
	int	border_width
	int	pad_x
	int	pad_y
	int	ipad_x
	int	ipad_y
	ALIAS:
		Gtk::Packer::configure = 1
	CODE:
#if GTK_HVER < 0x010106
	/* DEPRECATED */
	gtk_packer_configure(packer, child, side, anchor, options, border_width, pad_x, pad_y, ipad_x, ipad_y);
#else
	gtk_packer_set_child_packing(packer, child, side, anchor, options, border_width, pad_x, pad_y, ipad_x, ipad_y);
#endif

void
gtk_packer_reorder_child(packer,child,position)
	Gtk::Packer 	packer
	Gtk::Widget	child
	int		position

void
gtk_packer_set_spacing(packer, spacing)
	Gtk::Packer	packer
	int	spacing

void
gtk_packer_set_default_border_width(packer, border)
	Gtk::Packer	packer
	int	border

void
gtk_packer_set_default_pad(packer, pad_x, pad_y)
	Gtk::Packer	packer
	int	pad_x
	int pad_y

void
gtk_packer_set_default_ipad(packer, ipad_x, ipad_y)
	Gtk::Packer	packer
	int	ipad_x
	int ipad_y

void
children(packer)
	Gtk::Packer	packer
	PPCODE:
	{
		GList * list;
		list = g_list_first(packer->children);
		while (list) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkPackerChild((GtkPackerChild*)(list->data))));
			list = g_list_next(list);
		}
	}

#endif

MODULE = Gtk::Packer		PACKAGE = Gtk::PackerChild	

#ifdef GTK_PACKER

Gtk::Widget_Up
widget(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->widget;
	OUTPUT:
	RETVAL

Gtk::AnchorType
anchor(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->anchor;
	OUTPUT:
	RETVAL

Gtk::SideType
side(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->side;
	OUTPUT:
	RETVAL

Gtk::PackerOptions
options(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->options;
	OUTPUT:
	RETVAL

int
use_default(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->use_default;
	OUTPUT:
	RETVAL

int
border_width(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->border_width;
	OUTPUT:
	RETVAL

int
pad_x(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->pad_x;
	OUTPUT:
	RETVAL

int
pad_y(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->pad_y;
	OUTPUT:
	RETVAL

int
ipad_x(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->i_pad_x;
	OUTPUT:
	RETVAL

int
ipad_y(packerchild)
	Gtk::PackerChild	packerchild
	CODE:
	RETVAL = packerchild->i_pad_y;
	OUTPUT:
	RETVAL

#endif

