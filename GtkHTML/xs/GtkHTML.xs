
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GtkHTMLDefs.h"

static void 
destroy_handler(gpointer data) {
        SvREFCNT_dec((AV*)data);
}

static void     callXS (void (*subaddr)(CV* cv), CV *cv, SV **mark)
{
        int items;
        dSP;
        PUSHMARK (mark);
        (*subaddr)(cv);

        PUTBACK;  /* Forget the return values */
}

#define sp (*_sp)
static int fixup_html(SV ** * _sp, int match, GtkObject * object, char * signame, int nparams, GtkArg * args, GtkType return_type)
{
	dTHR;
	XPUSHs(sv_2mortal(newSVpv(GTK_VALUE_POINTER(args[0]), 0)));
	XPUSHs(sv_2mortal(newSViv(GPOINTER_TO_UINT(GTK_VALUE_POINTER(args[1])))));
	return 1;
}
#undef sp


MODULE = Gtk::HTML	PACKAGE = Gtk::HTML	PREFIX = gtk_html_

#ifdef GTK_HTML

void
init(Class)
	CODE:
	{
		static int did_it = 0;
		static char * names[] = { "url_requested", 0 };
		if (did_it)
			return;
		did_it = 1;
		GtkHTML_InstallTypedefs();
		GtkHTML_InstallObjects();
		AddSignalHelperParts(gtk_html_get_type(), names, fixup_html, 0);
	}

Gtk::HTML_Sink
gtk_html_new (Class)
	SV *	Class
	CODE:
	RETVAL = GTK_HTML(gtk_html_new());
	OUTPUT:
	RETVAL

void
gtk_html_parse (html)
	Gtk::HTML	html

guint
gtk_html_begin (html, url)
	Gtk::HTML	html
	char *	url

void
gtk_html_write (html, handle, chunk)
	Gtk::HTML	html
	guint	handle
	SV *	chunk
	CODE:
	gtk_html_write(html, handle, SvPV(chunk, PL_na), PL_na);

void
gtk_html_end (html, handle, status)
	Gtk::HTML	html
	guint	handle
	Gtk::HTMLStreamStatus	status

void
gtk_html_calc_scrollbars (html)
	Gtk::HTML	html

#endif

INCLUDE: ../build/boxed.xsh

INCLUDE: ../build/objects.xsh

INCLUDE: ../build/extension.xsh

