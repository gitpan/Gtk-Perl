
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "BonoboDefs.h"

MODULE = Bonobo::UIContainer		PACKAGE = Bonobo::UIContainer		PREFIX = bonobo_ui_container_

#ifdef BONOBO_UI_CONTAINER

Bonobo::UIContainer
bonobo_ui_container_new (Class)
	SV *	Class
	CODE:
	RETVAL = bonobo_ui_container_new();
	OUTPUT:
	RETVAL

void
bonobo_ui_container_set_win (container, win)
	Bonobo::UIContainer	container
	Bonobo::Window	win


#endif

