
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlGtkInt.h"

#include "GtkDefs.h"

#if 0

static SV*
get_sinfo (char* name, GladeSignalData* data) {
	HV *h;
	SV *r;
	SV *o;
	
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);

	if (data->signal_name)
		hv_store(h, "name", 4, newSVpv(data->signal_name, 0), 0);
	if (name)
		hv_store(h, "handler", 7, newSVpv(name, 0), 0);
	if (data->signal_data)
		hv_store(h, "data", 4, newSVpv(data->signal_data, 0), 0);
	hv_store(h, "after", 5, newSViv(data->signal_after), 0);
	o = newSVsv(newSVGtkObjectRef(data->signal_object, 0));
	SvREFCNT_dec(SvRV(o));
	hv_store(h, "object", 6, o, 0);
	if (data->connect_object) {
		GladeXML *self = glade_get_widget_tree(GTK_WIDGET(data->signal_object));
		GtkObject *other = g_hash_table_lookup(self->name_hash,
			data->connect_object);
		if (other) {
			o = newSVsv(newSVGtkObjectRef(other, 0));
			SvREFCNT_dec(SvRV(o));
			hv_store(h, "cobject", 7, o, 0);
		}
	}
	return r;
}


static void
autoconnect_foreach(char *signal_handler, GList *signals, SV ***_sp) {
#define sp (*_sp)
	dTHR;
	for (; signals != NULL; signals = signals->next) {
		GladeSignalData *data = signals->data;
		XPUSHs(sv_2mortal(get_sinfo(signal_handler, data)));
	}
#undef sp
}

#endif

static void
connect_func_handler(gchar *handler_name, GtkObject* object, 
		gchar * signal_name, gchar* signal_data, 
		GtkObject *connect_object, gboolean after, gpointer user_data) {

	AV * stuff;
	SV * handler;
	int i;
	dSP;

	if (!handler_name)
		handler_name = "";
	if (!signal_name)
		signal_name = "";
	if (!signal_data)
		signal_data = "";
	stuff = (AV*)user_data;
	handler = *av_fetch(stuff, 0, 0);
	
	ENTER;
	SAVETMPS;
	PUSHMARK(sp);

	XPUSHs(sv_2mortal(newSVpv(handler_name, 0)));
	XPUSHs(sv_2mortal(newSVGtkObjectRef(object, 0)));
	XPUSHs(sv_2mortal(newSVpv(signal_name, 0)));
	XPUSHs(sv_2mortal(newSVpv(signal_data, 0)));
	if (connect_object)
		XPUSHs(sv_2mortal(newSVGtkObjectRef(connect_object, 0)));
	else
		XPUSHs(sv_2mortal(newSVsv(&sv_undef)));
	XPUSHs(sv_2mortal(newSViv(after)));

	for (i=1;i<=av_len(stuff);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(stuff, i, 0))));

	PUTBACK;

	perl_call_sv(handler, G_DISCARD);
	
	FREETMPS;
	LEAVE;
}

MODULE = Gtk::GladeXML		PACKAGE = Gtk::GladeXML		PREFIX = glade_xml_

#ifdef GLADE_XML

void
init (Class)
	SV* Class
	CODE:
	{
		glade_init();
	}


Gtk::GladeXML_Sink
glade_xml_new (Class, fname, root=0)
	SV* Class
	char* fname
	char* root
	CODE: 
	{
		RETVAL = glade_xml_new(fname, root);
	}
	OUTPUT:
	RETVAL

Gtk::GladeXML_Sink
glade_xml_new_with_domain (Class, fname, root, domain)
	SV* Class
	char* fname
	char* root
	char* domain
	CODE: 
	{
		RETVAL = glade_xml_new_with_domain(fname, root, domain);
	}
	OUTPUT:
	RETVAL

bool
glade_xml_construct (self, fname, root, domain)
	Gtk::GladeXML	self
	char* fname
	char* root
	char* domain

void
glade_xml_signal_autoconnect(self)
	Gtk::GladeXML self

void
glade_xml_signal_connect_full (self, handler_name, func, ...)
	Gtk::GladeXML self
	char*	handler_name
	SV*	func
	CODE:
	{
		AV * args;

		args = newAV();
		PackCallbackST(args, 2);
		glade_xml_signal_connect_full(self, handler_name, connect_func_handler, (gpointer)args);
	}

void
glade_xml_signal_autoconnect_full (self, func, ...)
	Gtk::GladeXML self
	SV*	func
	CODE:
	{
		AV * args;

		args = newAV();
		PackCallbackST(args, 1);
		glade_xml_signal_autoconnect_full(self, connect_func_handler, (gpointer)args);
	}

Gtk::Widget_Up
glade_xml_get_widget (self, name)
	Gtk::GladeXML self
	char* name

Gtk::Widget_Up
glade_xml_get_widget_by_long_name (self, name)
	Gtk::GladeXML self
	char* name

char*
glade_xml_relative_file (self, filename)
	Gtk::GladeXML	self
	char*	filename


#if 0

void
_get_signal_info (self, name)
	Gtk::GladeXML self
	char* name
	PPCODE:
	{
		GList *signals;
		signals = g_hash_table_lookup(self->signals, name);
		for (; signals != NULL; signals = signals->next) {
			XPUSHs(sv_2mortal(get_sinfo(name, (GladeSignalData*)signals->data)));
		}
	}
	
void
_get_all_signals (self)
	Gtk::GladeXML self
	PPCODE:
	{
		SV ** _sp = sp;
		g_hash_table_foreach(self->signals, (GHFunc)autoconnect_foreach, &_sp);
		sp = _sp;
	}

#endif 

MODULE = Gtk::GladeXML		PACKAGE = Gtk::Widget		PREFIX = glade_

char*
glade_get_widget_name (self)
	Gtk::Widget self

char*
glade_get_widget_long_name (self)
	Gtk::Widget self

Gtk::GladeXML
glade_get_widget_tree (self)
	Gtk::Widget self


#endif

