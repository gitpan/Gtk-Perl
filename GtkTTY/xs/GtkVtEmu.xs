
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include <gtktty/gtktty.h>

static void reporter_callback(GtkVtEmu *vtemu, const guchar * buffer, guint count, gpointer user_data)
{
	AV * args = (AV*)user_data;
	SV * handler = *av_fech(args, 0, 0);
	int i;
	dSP;
	
	PUSHMARK(sp);
	for(i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	XPUSHs(sv_2mortal(newSVpv(buffer, count)));
	PUTBACK;

	perl_call_sv(handler, G_DISCARD);
}


MODULE = Gtk::VtEmu		PACKAGE = Gtk::VtEmu		PREFIX = gtk_vtemu_

#ifdef GTK_VTEMU

Gtk::VtEmu
gtk_vtemu_new(Class, term, terminal_type)
	SV *	Class
	Gtk::Term	term
	char *	terminal_type
	CODE:
	RETVAL = gtk_vtemu_new(term, terminal_type);
	OUTPUT:
	RETVAL

guint
gtk_vtemu_input(vtemu, buffer)
	Gtk::VtEmu	vtemu
	SV *	buffer
	CODE:
	{
		int l;
		char * c = SvPV(buffer, l);
		gtk_vtemu_input(vtemu, c, l);
	}
	OUTPUT:
	RETVAL

void
gtk_vtemu_report(vtemu, buffer)
	Gtk::VtEmu	vtemu
	SV *	buffer
	CODE:
	{
		int l;
		char * c = SvPV(buffer, l);
		gtk_vtemu_report(vtemu, c, l);
	}
void
gtk_vtemu_set_reporter(vtemu, callback, ...)
	Gtk::VtEmu	vtemu
	SV *	callback
	CODE:
	{
		AV * args = newAV();
		int j;
		PackCallbackST(args, 1);

		gtk_vtemu_set_reporter(vtemu, reporter_callback, (gpointer)args);
	}

void
gtk_vtemu_reset(vtemu, blank_screen)
	Gtk::VtEmu	vtemu
	gboolean	blank_screen

void
gtk_vtemu_invert(vtemu)
	Gtk::VtEmu	vtemu

void
gtk_vtemu_destroy(vtemu)
	Gtk::VtEmu	vtemu
	CODE:
	if (vtemu->reporter == reporter_callback)
		SvREFCNT_dec((AV*)vtemu->reporter_data);

#endif

