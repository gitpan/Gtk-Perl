
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "GtkDefs.h"
#include "BonoboDefs.h"
#include "MiscTypes.h"

MODULE = Bonobo::UIComponent		PACKAGE = Bonobo::UIComponent		PREFIX = bonobo_uicomponent_

#ifdef BONOBO_UI_COMPONENT

Bonobo::UIComponent
bonobo_ui_component_new (Class, name)
	SV *	Class
	char *	name
	CODE:
	RETVAL = bonobo_ui_component_new (name);
	OUTPUT:
	RETVAL


Bonobo::UIComponent
bonobo_ui_component_new_default (Class)
	SV *	Class
	CODE:
	RETVAL = bonobo_ui_component_new_default();
	OUTPUT:
	RETVAL

void
bonobo_ui_component_set_name (component, name)
	Bonobo::UIComponent	component
	char *	name

char *
bonobo_ui_component_get_name (component)
	Bonobo::UIComponent	component

void
bonobo_ui_component_set_container (component, container)
	Bonobo::UIComponent	component
	CORBA::Object	container

void
bonobo_ui_component_unset_container (component)
	Bonobo::UIComponent	component

CORBA::Object
bonobo_ui_component_get_container (component)
	Bonobo::UIComponent	component

void
bonobo_ui_component_add_verb (component, cname, handler, ...)
	Bonobo::UIComponent	component
	char *	cname
	SV *	handler
	CODE:
	{
		AV *args;
		args = newAV();
		PackCallbackST(args, 2);
		/* FIXME destroy */
		/*bonobo_ui_component_add_verb_full (component, cname, pgtk_generic_handler, args, NULL);*/
	}

void
bonobo_ui_component_remove_verb (component, cname)
	Bonobo::UIComponent	component
	char *	cname

void
bonobo_ui_component_add_listener (component, id, handler, ...)
	Bonobo::UIComponent	component
	char *	id
	SV *	handler
	CODE:
	{
		/* FIXME */
		bonobo_ui_component_add_listener_full (component, id, NULL, NULL, NULL);
	}

void
bonobo_ui_component_remove_listener (component, cname)
	Bonobo::UIComponent	component
	char *	cname

#endif

