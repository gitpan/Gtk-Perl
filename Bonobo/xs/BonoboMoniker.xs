
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "BonoboDefs.h"

MODULE = Bonobo::Moniker		PACKAGE = Bonobo::Moniker		PREFIX = bonobo_moniker_

#ifdef BONOBO_MONIKER

#if 0

CORBA::Object
bonobo_moniker_corba_object_create (object)
	Bonobo::Object	object

#endif

CORBA::Object
bonobo_moniker_get_parent (moniker)
	Bonobo::Moniker	moniker
	CODE:
	TRY(RETVAL = bonobo_moniker_get_parent (moniker, &ev));
	OUTPUT:
	RETVAL

void
bonobo_moniker_set_parent (moniker, parent)
	Bonobo::Moniker	moniker
	CORBA::Object	parent
	CODE:
	TRY(bonobo_moniker_set_parent (moniker, parent, &ev));

char*
bonobo_moniker_get_name (moniker)
	Bonobo::Moniker	moniker

void
bonobo_moniker_set_name (moniker, name)
	Bonobo::Moniker	moniker
	char*	name
	CODE:
	bonobo_moniker_set_name (moniker, name, strlen(name));

CORBA::Object
bonobo_moniker_client_new_from_name (Class, name)
	SV *	Class
	char *	name
	CODE:
	TRY(RETVAL = bonobo_moniker_client_new_from_name (name, &ev));
	OUTPUT:
	RETVAL

#endif

