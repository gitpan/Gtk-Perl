
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "BonoboDefs.h"
#include "GtkDefs.h"

MODULE = Bonobo::Control		PACKAGE = Bonobo::Control		PREFIX = bonobo_control_

#ifdef BONOBO_CONTROL

Bonobo::Control
bonobo_control_new (Class, widget)
	SV *	Class
	Gtk::Widget	widget
	CODE:
	RETVAL = bonobo_control_new (widget);
	OUTPUT:
	RETVAL

Gtk::Widget
bonobo_control_get_widget (control)
	Bonobo::Control	control

void
bonobo_control_set_automerge (control, automerge)
	Bonobo::Control	control
	bool	automerge

bool
bonobo_control_get_automerge (control)
	Bonobo::Control	control

#if 0

void
bonobo_control_set_property (control, first_prop)
	Bonobo::Control	control
	char *	first_prop

void
bonobo_control_get_property (control, first_prop)
	Bonobo::Control	control
	char *	first_prop

#endif

CORBA::Object
bonobo_control_corba_object_create (object)
	Bonobo::Object	object

Bonobo::UIComponent
bonobo_control_get_ui_component (control)
	Bonobo::Control	control

void
bonobo_control_set_ui_component (control, component)
	Bonobo::Control	control
	Bonobo::UIComponent	component

CORBA::Object
bonobo_control_get_remote_ui_container (control)
	Bonobo::Control	control

void
bonobo_control_set_control_frame (control, control_frame)
	Bonobo::Control	control
	CORBA::Object	control_frame

CORBA::Object
bonobo_control_get_control_frame (control)
	Bonobo::Control	control

void
bonobo_control_set_properties (control, pb)
	Bonobo::Control	control
	Bonobo::PropertyBag	pb

Bonobo::PropertyBag
bonobo_control_get_properties (control)
	Bonobo::Control	control

CORBA::Object
bonobo_control_get_ambient_properties (control)
	Bonobo::Control	control
	CODE:
	TRY(RETVAL = bonobo_control_get_ambient_properties (control, &ev));
	OUTPUT:
	RETVAL

void
bonobo_control_activate_notify (control, activated)
	Bonobo::Control	control
	bool	activated

#endif

