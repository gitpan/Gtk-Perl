
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlGtkInt.h"

#include "GtkDefs.h"
#include "GtkGladeXMLDefs.h"

static void
connect_func_handler(const gchar *handler_name, GtkObject* object, 
		const gchar * signal_name, const gchar* signal_data, 
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

/* This function needs to be exported to handle custom widgets in the 
   currently broken way that libglade provides... */

GtkWidget*
pgtk_glade_custom_widget (char* name, char* string1, char* string2, int int1, int int2) {
	SV * s;
	char *handler="Gtk::GladeXML::create_custom_widget";
	int i;
	dSP;

	ENTER;
	SAVETMPS;
	PUSHMARK(sp);

	if (!name) name = "";
	if (!string1) string1 = "";
	if (!string2) string2 = "";

	XPUSHs(sv_2mortal(newSVpv(name, 0)));
	XPUSHs(sv_2mortal(newSVpv(string1, 0)));
	XPUSHs(sv_2mortal(newSVpv(string2, 0)));
	XPUSHs(sv_2mortal(newSViv(int1)));
	XPUSHs(sv_2mortal(newSViv(int2)));

	PUTBACK;

	i=perl_call_pv(handler, G_SCALAR);
	SPAGAIN;
	if (i != 1)
		croak("create_custom_widget failed");
	s = POPs;
	PUTBACK;
	FREETMPS;
	LEAVE;
	return (GtkWidget*)SvGtkObjectRef(s, NULL);
}

MODULE = Gtk::GladeXML		PACKAGE = Gtk::GladeXML		PREFIX = glade_xml_

#ifdef GLADE_XML

void
init (Class)
	SV* Class
	CODE:
	{
		static int did_it = 0;
		if (did_it)
			return;
		did_it = 1;
#ifdef GNOME_HVER
		glade_gnome_init();
#else
		glade_init();
#endif
		GtkGladeXML_InstallObjects();
		GtkGladeXML_InstallTypedefs();
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

Gtk::Widget_OrNULL_Up
glade_xml_get_widget (self, name)
	Gtk::GladeXML self
	char* name

Gtk::Widget_OrNULL_Up
glade_xml_get_widget_by_long_name (self, name)
	Gtk::GladeXML self
	char* name

char*
glade_xml_relative_file (self, filename)
	Gtk::GladeXML	self
	char*	filename


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


INCLUDE: ../build/boxed.xsh

INCLUDE: ../build/objects.xsh

INCLUDE: ../build/extension.xsh

