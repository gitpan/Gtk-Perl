
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "BonoboDefs.h"
#include "GtkDefs.h"

typedef void (*BonoboViewVerbFunc)(BonoboView *view, const char *verb_name, void *user_data);


MODULE = Bonobo::View		PACKAGE = Bonobo::View		PREFIX = bonobo_view_

#ifdef BONOBO_VIEW

Bonobo::View
bonobo_view_new (Class, widget)
	SV *	Class
	Gtk::Widget	widget
	CODE:
	RETVAL = bonobo_view_new (widget);
	OUTPUT:
	RETVAL

CORBA::Object
bonobo_view_corba_object_create (object)
	Bonobo::Object	object

void
bonobo_view_set_embeddable (view, embeddable)
	Bonobo::View	view
	Bonobo::Embeddable	embeddable

Bonobo::Embeddable
bonobo_view_get_embeddable (view)
	Bonobo::View	view

void
bonobo_view_set_view_frame (view, view_frame)
	Bonobo::View	view
	CORBA::Object	view_frame

CORBA::Object
bonobo_view_get_view_frame (view)
	Bonobo::View	view

CORBA::Object
bonobo_view_get_remote_ui_container (view)
	Bonobo::View	view

Bonobo::UIComponent
bonobo_view_get_ui_component (view)
	Bonobo::View	view

void
bonobo_view_activate_notify (view, activated)
	Bonobo::View	view
	bool	activated
						  
#endif

