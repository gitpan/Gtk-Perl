#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"


MODULE = Gtk::Button		PACKAGE = Gtk::Button		PREFIX = gtk_button_

#ifdef GTK_BUTTON

Gtk::Button_Sink
new(Class, label=0)
	SV *	Class
	char *	label
	ALIAS:
		Gtk::Button::new = 0
		Gtk::Button::new_with_label = 1
	CODE:
	if (!label)
		RETVAL = GTK_BUTTON(gtk_button_new());
	else
		RETVAL = GTK_BUTTON(gtk_button_new_with_label(label));
	OUTPUT:
	RETVAL

void
gtk_button_pressed(button)
	Gtk::Button	button

void
gtk_button_released(button)
	Gtk::Button	button

void
gtk_button_clicked(button)
	Gtk::Button	button

void
gtk_button_enter(button)
	Gtk::Button	button

void
gtk_button_leave(button)
	Gtk::Button	button

Gtk::Widget_Up
child(widget, newvalue=0)
	Gtk::Button	widget
	Gtk::Widget_OrNULL	newvalue
	CODE:
	RETVAL = widget->child;
	if (newvalue)
		widget->child = newvalue;
	OUTPUT:
	RETVAL

# void FIXME
# gtk_button_set_relief(button, newstyle)
# 	Gtk::Button 	button
# 	Gtk::ReliefStyle newstyle
#
# Gtk::ReliefStyle
# gtk_button_get_relief(button)
# 	Gtk::Button 	button

#endif
