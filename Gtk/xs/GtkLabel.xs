
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Label		PACKAGE = Gtk::Label		PREFIX = gtk_label_

#ifdef GTK_LABEL

Gtk::Label_Sink
new(Class, string="")
	SV *	Class
	char *	string
	CODE:
	RETVAL = GTK_LABEL(gtk_label_new(string));
	OUTPUT:
	RETVAL

void
gtk_label_set(label, string)
	Gtk::Label	label
	char *	string

void
gtk_label_set_text(label, string)
	Gtk::Label	label
	char *	string

#if GTK_HVER >= 0x010108

void
gtk_label_set_pattern(label, string)
	Gtk::Label	label
	char *	string

void
gtk_label_set_line_wrap(label, wrap)
	Gtk::Label 	label
	bool wrap

#endif

void
gtk_label_set_justify(label, jtype)
	Gtk::Label	label
	Gtk::Justification	jtype

char *
gtk_label_get(label)
	Gtk::Label	label
	CODE:
	gtk_label_get(label, &RETVAL);
	OUTPUT:
	RETVAL

#if GTK_HVER >= 0x010101

unsigned int
gtk_label_parse_uline(label, string)
	Gtk::Label	label
	char *	string


#endif

#endif
