
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "BonoboDefs.h"

MODULE = Bonobo::Object		PACKAGE = Bonobo::Object		PREFIX = bonobo_object_

#ifdef BONOBO_OBJECT

void
bonobo_object_add_interface (object, newobj)
	Bonobo::Object	object
	Bonobo::Object	newobj

Bonobo::Object
bonobo_object_query_local_interface (object, repo_id)
	Bonobo::Object	object
	char *	repo_id

CORBA::Object
bonobo_object_query_interface (object, repo_id)
	Bonobo::Object	object
	char *	repo_id

CORBA::Object
bonobo_object_corba_objref (object)
	Bonobo::Object	object


void
bonobo_object_ref (object)
	Bonobo::Object	object

void
bonobo_object_idle_unref (object)
	Bonobo::Object	object

void
bonobo_object_unref (object)
	Bonobo::Object	object

MODULE = Bonobo::Object		PACKAGE = CORBA::Object		PREFIX = gnome_

gboolean
gnome_unknown_ping (unknown)
	CORBA::Object	unknown

#endif

