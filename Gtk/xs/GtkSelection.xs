
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

static void selection_handler(GtkWidget *widget, GtkSelectionData *selection_data,
		       gpointer data)
{
	AV * args = (AV *)data;
	SV * handler = *av_fetch(args, 0, 0);
	int i;
	dSP;

	PUSHMARK(sp);
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(widget),0)));
	XPUSHs(sv_2mortal(newSVGtkSelectionDataRef(selection_data)));
	PUTBACK;

	perl_call_sv(handler, G_DISCARD);
}


static void selection_handler_remove (gpointer data)
{
	AV * args = (AV *)data;
	SvREFCNT_dec(args);
}

/* FIXME: Lots still to do, and check marshalling of handler */

MODULE = Gtk::Selection		PACKAGE = Gtk::Widget	PREFIX = gtk_

int
gtk_selection_owner_set(widget, atom, time)
	Gtk::Widget	widget
	Gtk::Gdk::Atom	atom
	int	time

#if GTK_HVER < 0x010103

void
gtk_selection_add_handler(widget, selection, target, handler, ...)
	Gtk::Widget	widget
	Gtk::Gdk::Atom	selection
	Gtk::Gdk::Atom	target
	SV *	handler
	CODE:
	{
		AV * args = newAV();
		
		PackCallbackST(args, 3);
		
		gtk_selection_add_handler_full(widget, selection, target, selection_handler, 
			0, (gpointer)args, selection_handler_remove);
	}

#endif

int
gtk_selection_convert(widget, selection, target, time)
	Gtk::Widget	widget
	Gtk::Gdk::Atom	selection
	Gtk::Gdk::Atom	target
	int time

void
gtk_selection_remove_all(widget)
	Gtk::Widget widget
