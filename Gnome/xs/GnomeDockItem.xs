
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlGtkInt.h"

#include "GtkDefs.h"

MODULE = Gnome::DockItem		PACKAGE = Gnome::DockItem		PREFIX = gnome_dock_item_

#ifdef GNOME_DOCK_ITEM

#if 0

Gnome::DockItem_Sink
new (Class, name, behavior)
	SV *	Class
	char *	name
	Gnome::DockItemBehavior behavior
	CODE:
	RETVAL = GNOME_DOCK_ITEM(gnome_dock_item_new(name, behavior));
	OUTPUT:
	RETVAL

Gtk::Widget_Up
gnome_dock_item_get_child (dock_item)
	Gnome::DockItem	doc_item

char*
gnome_dock_item_get_name (dock_item)
	Gnome::DockItem	doc_item

void
gnome_dock_item_set_shadow_type (dock_item, type)
	Gnome::DockItem	doc_item
	Gtk::ShadowType	type

Gtk::ShadowType
gnome_dock_item_get_shadow_type (dock_item)
	Gnome::DockItem	doc_item

bool
gnome_dock_item_set_orientation (dock_item, orientation)
	Gnome::DockItem	doc_item
	Gtk::Orientation

Gtk::Orientation
gnome_dock_item_get_orientation (dock_item)
	Gnome::DockItem	doc_item

Gnome::DockItemBehavior
gnome_dock_item_get_behavior (dock_item)
	Gnome::DockItem	doc_item

#endif

#endif

