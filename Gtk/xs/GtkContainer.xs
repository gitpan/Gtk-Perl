#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

/* Still missing: argument, vector &c functions */

void foreach_container_handler (GtkWidget *widget, gpointer data)
{
	AV * perlargs = (AV*)data;
	SV * perlhandler = *av_fetch(perlargs, 1, 0);
	SV * sv_object = newSVGtkObjectRef(GTK_OBJECT(widget), 0);
	int i;
	dSP;
	
	PUSHMARK(sp);
	XPUSHs(sv_2mortal(sv_object));
	for(i=2;i<=av_len(perlargs);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(perlargs, i, 0))));
   	XPUSHs(sv_2mortal(newSVsv(*av_fetch(perlargs, 0, 0))));
	PUTBACK ;
	
	perl_call_sv(perlhandler, G_DISCARD);
}


MODULE = Gtk::Container		PACKAGE = Gtk::Container		PREFIX = gtk_container_

#ifdef GTK_CONTAINER

void
set_border_width(self, width)
	Gtk::Container	self
	int	width
	ALIAS:
		Gtk::Container::set_border_width = 0
		Gtk::Container::border_width = 1
	CODE:
#if GTK_HVER < 0x010106
	/* DEPRECATED */
	gtk_container_border_width(self, width);
#else
	gtk_container_set_border_width(self, width);
#endif

SV *
add(self, widget)
	Gtk::Container	self
	Gtk::Widget	widget	
	CODE:
		gtk_container_add(self, widget);
		RETVAL = newSVsv(ST(1));
	OUTPUT:
	RETVAL

Gtk::Widget
remove(self, widget)
	Gtk::Container	self
	Gtk::Widget	widget	
	CODE:
		gtk_container_remove(self, widget);
		RETVAL = widget;
	OUTPUT:
	RETVAL

void
foreach(self, code, ...)
	Gtk::Container	self
	SV *	code
	PPCODE:
	{
		AV * args;
		SV * arg;
		int i;
		int type;
		args = newAV();
		
		av_push(args, newRV_inc(SvRV(ST(0))));
		PackCallbackST(args, 1);

		gtk_container_foreach(self, foreach_container_handler, args);
		
		SvREFCNT_dec(args);
	}

void
children(self)
	Gtk::Container	self
	PPCODE:
	{
		GList * c = gtk_container_children(self);
		GList * start = c;
		while(c) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT((GtkWidget*)c->data), 0)));
			c = c->next;
		}
		if (start)
			g_list_free(start);
	}


int
gtk_container_focus(self, direction)
	Gtk::Container	self
	Gtk::DirectionType	direction


#ifdef GTK_HAVE_CONTAINER_FOCUS_ADJUSTMENTS

void
gtk_container_set_focus_vadjustment(self, adjustment)
	Gtk::Container	self
	Gtk::Adjustment	adjustment

void
gtk_container_set_focus_hadjustment(self, adjustment)
	Gtk::Container	self
	Gtk::Adjustment	adjustment

#endif

void
gtk_container_register_toplevel (self)
	Gtk::Container  self

void
gtk_container_unregister_toplevel (self)
	Gtk::Container  self

#if GTK_HVER < 0x010105

void
gtk_container_disable_resize(self)
	Gtk::Container	self

void
gtk_container_enable_resize(self)
	Gtk::Container	self

void
gtk_container_block_resize(self)
	Gtk::Container	self

void
gtk_container_unblock_resize(self)
	Gtk::Container	self

bool
gtk_container_need_resize(self)
	Gtk::Container	self

#endif

#if GTK_HVER >= 0x010100

void
gtk_container_resize_children(self)
	Gtk::Container self

void
gtk_container_set_focus_child(self, child)
	Gtk::Container	self
	Gtk::Widget	child

#endif

#endif
