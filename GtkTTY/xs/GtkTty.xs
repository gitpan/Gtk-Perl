
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include <gtktty/gtktty.h>

MODULE = Gtk::Tty		PACKAGE = Gtk::Tty		PREFIX = gtk_tty_

#ifdef GTK_TTY

Gtk::Tty_Sink
new(Class, width, height, scrollback)
	SV *	Class
	guint	width
	guint	height
	guint	scrollback
	CODE:
	RETVAL = GTK_TTY(gtk_tty_new(width, height, scrollback));
	OUTPUT:
	RETVAL

void
gtk_tty_put_out(tty, buffer)
	Gtk::Tty	tty
	SV *	buffer
	CODE:
	{
		int l;
		char * c = SvPV(buffer, l);
		gtk_tty_put_out(tty, c, l);
	}

void
gtk_tty_put_in(tty, buffer)
	Gtk::Tty	tty
	SV *	buffer
	CODE:
	{
		int l;
		char * c = SvPV(buffer, l);
		gtk_tty_put_in(tty, c, l);
	}

void
gtk_tty_leds_changed(tty)
	Gtk::Tty	tty

void
gtk_tty_add_update_led(tty, led, mask)
	Gtk::Tty	tty
	Gtk::Led	led
	Gtk::TtyKeyStateBits	mask

void
gtk_tty_test_exec(tty)
	Gtk::Tty	tty
	CODE:
	{
	char *arg[] = {"/bin/sh",NULL};
	char *env[] = {NULL};
	
	gtk_tty_execute(tty, "/bin/sh", arg, env);
	}

#endif

