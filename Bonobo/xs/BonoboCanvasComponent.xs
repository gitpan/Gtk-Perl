
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "BonoboDefs.h"
#include "GtkDefs.h"
#include "GnomeDefs.h"

MODULE = Bonobo::CanvasComponent		PACKAGE = Bonobo::CanvasComponent		PREFIX = bonobo_canvas_component_

#ifdef BONOBO_CANVAS_COMPONENT

CORBA::Object
bonobo_canvas_component_object_create (object)
	Bonobo::Object	object

Bonobo::CanvasComponent
bonobo_canvas_component_construct (comp, corba_canvas_comp, item)
	Bonobo::CanvasComponent	comp
	CORBA::Object	corba_canvas_comp
	Gnome::CanvasItem	item

Bonobo::CanvasComponent
bonobo_canvas_component_new (Class, item)
	SV *	Class
	Gnome::CanvasItem	item
	CODE:
	RETVAL = bonobo_canvas_component_new (item);
	OUTPUT:
	RETVAL

Gnome::CanvasItem
bonobo_canvas_component_get_item (comp)
	Bonobo::CanvasComponent	comp

void
bonobo_canvas_component_grab (comp, mask, cursor, time)
	Bonobo::CanvasComponent	comp
	guint	mask
	Gtk::Gdk::Cursor	cursor
	guint32	time

void
bonobo_canvas_component_ungrab (comp, time)
	Bonobo::CanvasComponent	comp
	guint32	time

CORBA::Object
bonobo_canvas_component_get_ui_container (comp)
	Bonobo::CanvasComponent	comp

#endif

