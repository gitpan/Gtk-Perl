
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "BonoboDefs.h"

MODULE = Bonobo::ClientSite		PACKAGE = Bonobo::ClientSite		PREFIX = bonobo_client_site_

#ifdef BONOBO_CLIENT_SITE

Bonobo::ClientSite
bonobo_client_site_new (Class, container)
	SV *	Class
	Bonobo::ItemContainer	container
	CODE:
	RETVAL = bonobo_client_site_new (container);
	OUTPUT:
	RETVAL

Bonobo::ClientSite
bonobo_client_site_construct (client_site, container)
	Bonobo::ClientSite	client_site
	Bonobo::ItemContainer	container

bool
bonobo_client_site_bind_embeddable (client_site, object)
	Bonobo::ClientSite	client_site
	Bonobo::ObjectClient	object

Bonobo::ObjectClient
bonobo_client_site_get_embeddable (client_site)
	Bonobo::ClientSite	client_site

Bonobo::ItemContainer
bonobo_client_site_get_container (client_site)
	Bonobo::ClientSite	client_site

Bonobo::ViewFrame
bonobo_client_site_new_view_full (client_site, uih, visible_cover, active_view)
	Bonobo::ClientSite	client_site
	CORBA::Object	uih
	bool	visible_cover
	bool	active_view

Bonobo::ViewFrame
bonobo_client_site_new_view (client_site, uih)
	Bonobo::ClientSite	client_site
	CORBA::Object	uih

#Gnome::CanvasItem
#bonobo_client_site_new_item (client_site, group)
#	Bonobo::ClientSite	client_site
#	Gnome::CanvasGroup	group

#endif

