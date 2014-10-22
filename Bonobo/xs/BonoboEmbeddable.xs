
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "GtkDefs.h"
#include "MiscTypes.h"
#include "BonoboDefs.h"

/* FIXME: leaks of args */

static BonoboView *
generic_view_factory (BonoboEmbeddable *embeddable, const Bonobo_ViewFrame view_frame, void *closure) {
	AV * args = (AV*)closure;
	SV *handler = * av_fetch(args, 0, 0);
	int i;
	SV * result;
	BonoboView * bview = NULL;
	dSP;

	ENTER;
	SAVETMPS;
	PUSHMARK(sp);
	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(embeddable), 0)));
	XPUSHs(sv_2mortal(newSVsv(porbit_objref_to_sv(view_frame))));
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	PUTBACK;
	i = perl_call_sv(handler, G_SCALAR);
	SPAGAIN;
	if (i!=1)
		croak("handler failed");
	result = POPs;
	bview = BONOBO_VIEW(SvGtkObjectRef(result, 0));
	PUTBACK;
	FREETMPS;
	LEAVE;

	return bview;
}

static BonoboCanvasComponent *
generic_item_factory (BonoboEmbeddable *embeddable, GnomeCanvas *canvas, void *closure) {
	AV * args = (AV*)closure;
	SV *handler = * av_fetch(args, 0, 0);
	int i;
	SV * result;
	BonoboCanvasComponent * comp = NULL;
	dSP;

	ENTER;
	SAVETMPS;
	PUSHMARK(sp);
	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(embeddable), 0)));
	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(canvas), 0)));
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	PUTBACK;
	i = perl_call_sv(handler, G_SCALAR);
	SPAGAIN;
	if (i!=1)
		croak("handler failed");
	result = POPs;
	comp = BONOBO_CANVAS_COMPONENT(SvGtkObjectRef(result, 0));
	PUTBACK;
	FREETMPS;
	LEAVE;

	return comp;
}

static void
generic_foreach_view (BonoboView *view, void *data) {
	AV * args = (AV*)data;
	SV * handler = *av_fetch(args, 0, 0);
	int i;
	dSP;

	PUSHMARK(sp);
	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(view), 0)));
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	PUTBACK;
	perl_call_sv(handler, G_DISCARD);
	return;
}

static void
generic_foreach_item (BonoboCanvasComponent *comp, void *data) {
	AV * args = (AV*)data;
	SV * handler = *av_fetch(args, 0, 0);
	int i;
	dSP;

	PUSHMARK(sp);
	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(comp), 0)));
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	PUTBACK;
	perl_call_sv(handler, G_DISCARD);
	return;
}


MODULE = Bonobo::Embeddable		PACKAGE = Bonobo::Embeddable		PREFIX = bonobo_embeddable_

#ifdef BONOBO_EMBEDDABLE

Bonobo::Embeddable
bonobo_embeddable_new (Class, factory, ...)
	SV *	Class
	SV *	factory
	CODE:
	{
		AV *args = newAV();
		PackCallbackST(args, 1);
		RETVAL = bonobo_embeddable_new(generic_view_factory, args);
	}
	OUTPUT:
	RETVAL

Bonobo::Embeddable
bonobo_embeddable_new_canvas_item (Class, item_factory, ...)
	SV *	Class
	SV *	item_factory
	CODE:
	{
		AV *args = newAV();
		PackCallbackST(args, 1);
		RETVAL = bonobo_embeddable_new_canvas_item(generic_item_factory, args);
	}
	OUTPUT:
	RETVAL

Bonobo::Embeddable
bonobo_embeddable_construct (embeddable, corba_embeddable, factory, ...)
	Bonobo::Embeddable	embeddable
	CORBA::Object	corba_embeddable
	SV *	factory
	CODE:
	{
		AV *args = newAV();
		PackCallbackST(args, 2);
		RETVAL = bonobo_embeddable_construct (embeddable, corba_embeddable, generic_view_factory, args);
	}
	OUTPUT:
	RETVAL

CORBA::Object
bonobo_embeddable_corba_object_create (object)
	Bonobo::Object	object

void
bonobo_embeddable_set_view_factory (embeddable, factory, ...)
	Bonobo::Embeddable	embeddable
	SV *	factory
	CODE:
	{
		AV *args = newAV();
		PackCallbackST(args, 1);
		bonobo_embeddable_set_view_factory (embeddable, generic_view_factory, args);
	}

char *
bonobo_embeddable_get_uri (embeddable)
	Bonobo::Embeddable	embeddable

void
bonobo_embeddable_set_uri (embeddable, uri)
	Bonobo::Embeddable	embeddable
	char *	uri

void
bonobo_embeddable_foreach_view (embeddable, handler, ...)
	Bonobo::Embeddable	embeddable
	SV *	handler
	CODE:
	{
		AV *args = newAV();
		PackCallbackST(args, 1);
		bonobo_embeddable_foreach_view (embeddable, generic_foreach_view, args);
	}

void
bonobo_embeddable_foreach_item (embeddable, handler, ...)
	Bonobo::Embeddable	embeddable
	SV *	handler
	CODE:
	{
		AV *args = newAV();
		PackCallbackST(args, 1);
		bonobo_embeddable_foreach_item (embeddable, generic_foreach_item, args);
	}

#endif

