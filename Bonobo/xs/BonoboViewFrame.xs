
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "BonoboDefs.h"
#include "GtkDefs.h"

MODULE = Bonobo::ViewFrame		PACKAGE = Bonobo::ViewFrame		PREFIX = bonobo_view_frame_

#ifdef BONOBO_VIEW_FRAME


Bonobo::ViewFrame
bonobo_view_frame_new (Class, client_site, uih)
	SV *	Class
	Bonobo::ClientSite	client_site
	CORBA::Object	uih
	CODE:
	RETVAL = bonobo_view_frame_new (client_site, uih);
	OUTPUT:
	RETVAL


void
bonobo_view_frame_bind_to_view (view_frame, view)
	Bonobo::ViewFrame	view_frame
	CORBA::Object	view

CORBA::Object
bonobo_view_frame_get_view (view_frame)
	Bonobo::ViewFrame	view_frame

Bonobo::ClientSite
bonobo_view_frame_get_client_site (view_frame)
	Bonobo::ViewFrame	view_frame

Gtk::Widget
bonobo_view_frame_get_wrapper (view_frame)
	Bonobo::ViewFrame	view_frame

void
bonobo_view_frame_set_covered (view_frame, covered)
	Bonobo::ViewFrame	view_frame
	bool	covered

CORBA::Object
bonobo_view_frame_get_ui_container (view_frame)
	Bonobo::ViewFrame	view_frame

void
bonobo_view_frame_view_activate (view_frame)
	Bonobo::ViewFrame	view_frame

void
bonobo_view_frame_view_deactivate (view_frame)
	Bonobo::ViewFrame	view_frame

void
bonobo_view_frame_set_zoom_factor (view_frame, zoom)
	Bonobo::ViewFrame	view_frame
	double	zoom

#endif

