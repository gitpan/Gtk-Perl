
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Statusbar		PACKAGE = Gtk::Statusbar		PREFIX = gtk_statusbar_

#ifdef GTK_STATUSBAR

Gtk::Statusbar_Sink
new(Class)
	CODE:
	RETVAL = GTK_STATUSBAR(gtk_statusbar_new());
	OUTPUT:
	RETVAL

int
gtk_statusbar_get_context_id(self, context_description)
	Gtk::Statusbar self
	char* context_description

int
gtk_statusbar_push(self, context_id, text)
	Gtk::Statusbar self
	int context_id
	char* text

void
gtk_statusbar_pop(self, context_id)
	Gtk::Statusbar self
	int context_id

void
gtk_statusbar_remove(self, context_id, message_id)
	Gtk::Statusbar self
	int context_id
	int message_id

void
gtk_statusbar_messages(self)
	Gtk::Statusbar	self
	PPCODE:
	{
		GSList * list;
		for (list = self->messages; list; list = list->next) {
			HV * hv = newHV();
			GtkStatusbarMsg * msg = (GtkStatusbarMsg*)list->data;
			
			EXTEND(sp, 1);
			
			hv_store(hv, "text", 4, newSVpv(msg->text, 0), 0);
			hv_store(hv, "context_id", 10, newSViv(msg->context_id), 0);
			hv_store(hv, "message_id", 10, newSViv(msg->message_id), 0);
			
			PUSHs(sv_2mortal(newRV_inc((SV*)hv)));
			SvREFCNT_dec(hv);
		}
	}

Gtk::Widget_Up
frame(self)
	Gtk::Statusbar self
	CODE:
	RETVAL = self->frame;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
label(self)
	Gtk::Statusbar self
	CODE:
	RETVAL = self->label;
	OUTPUT:
	RETVAL

#endif

