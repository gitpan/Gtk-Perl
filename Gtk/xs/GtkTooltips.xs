
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Tooltips		PACKAGE = Gtk::Tooltips		PREFIX = gtk_tooltips_

#ifdef GTK_TOOLTIPS

Gtk::Tooltips_Sink
new(Class)
	SV * Class
	CODE:
	RETVAL = GTK_TOOLTIPS(gtk_tooltips_new());
	OUTPUT:
	RETVAL

void
gtk_tooltips_enable(self)
	Gtk::Tooltips self

void
gtk_tooltips_disable(self)
	Gtk::Tooltips self

void
gtk_tooltips_set_delay(self, delay)
	Gtk::Tooltips self
	int delay

void
gtk_tooltips_set_tip(self, widget, tip_text, tip_private="")
	Gtk::Tooltips self
	Gtk::Widget widget
	char* tip_text
	char* tip_private

void
gtk_tooltips_set_colors(self, background, foreground)
	Gtk::Tooltips self
	Gtk::Gdk::Color background
	Gtk::Gdk::Color foreground

#if GTK_HVER >= 0x010200

void
gtk_tooltips_force_window (tooltips)
	Gtk::Tooltips	tooltips

#endif

#endif

