
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::RadioButton		PACKAGE = Gtk::RadioButton		PREFIX = gtk_radio_button_

#ifdef GTK_RADIO_BUTTON

Gtk::RadioButton_Sink
new(Class, label=0, previous=0)
	SV *	Class
	SV *	label
	Gtk::RadioButton	previous
	ALIAS:
		Gtk::RadioButton::new = 0
		Gtk::RadioButton::new_with_label = 1
	CODE:
	{
		GSList * group = 0;
		
		if (previous)
			group = gtk_radio_button_group(previous);
		
		if (label && SvOK(label) )
			RETVAL = GTK_RADIO_BUTTON(gtk_radio_button_new_with_label(group, SvPV(label,PL_na)));
		else
			RETVAL = GTK_RADIO_BUTTON(gtk_radio_button_new(group));
	}
	OUTPUT:
	RETVAL

void
gtk_radio_button_set_group(radio_button, other_button)
	Gtk::RadioButton	radio_button
	Gtk::RadioButton	other_button
	CODE:
	gtk_radio_button_set_group(radio_button, gtk_radio_button_group(other_button));

void
group(self)
	Gtk::RadioButton	self
	PPCODE:
	{
		GSList * group = 0;
		group = gtk_radio_button_group(self);
		while(group) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkRadioButton(group->data)));
			group=group->next;
		}
	}

#endif
