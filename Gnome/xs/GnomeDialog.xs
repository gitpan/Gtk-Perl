
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"


MODULE = Gnome::Dialog		PACKAGE = Gnome::Dialog		PREFIX = gnome_dialog_

#ifdef GNOME_DIALOG

Gnome::Dialog_Sink
new(Class, title, ...)
	SV *	Class
	char *	title
	CODE:
	{
		int count = items-2;
		char ** b = malloc(sizeof(char*) * (count+1));
		int i;
		
		for(i=0;i<count;i++)
			b[i] = SvPV(ST(i+2), PL_na);
		b[i] = 0;
#ifdef NEW_GNOME
		RETVAL = GNOME_DIALOG(gnome_dialog_newv(title, b));
#else
		/* I don't think this is right... */
		RETVAL = GNOME_DIALOG(gnome_dialog_new(title, b));
#endif
		free(b);
	}
	OUTPUT:
	RETVAL

void
gnome_dialog_set_parent(dialog, parent)
	Gnome::Dialog	dialog
	Gtk::Window	parent

#if 0

void
gnome_dialog_set_modal(dialog)
	Gnome::Dialog	dialog

#endif

int
gnome_dialog_run(dialog)
	Gnome::Dialog	dialog

#if 0

int
gnome_dialog_run_modal(dialog)
	Gnome::Dialog	dialog


int
gnome_dialog_run_and_hide(dialog)
	Gnome::Dialog	dialog

int
gnome_dialog_run_and_destroy(dialog)
	Gnome::Dialog	dialog

#endif

void
gnome_dialog_set_default(dialog, button)
	Gnome::Dialog	dialog
	int	button

void
gnome_dialog_set_sensitive(dialog, button, setting)
	Gnome::Dialog	dialog
	gint	button
	gboolean	setting

void
gnome_dialog_close(dialog)
	Gnome::Dialog	dialog

void
gnome_dialog_close_hides(dialog, just_hide)
	Gnome::Dialog	dialog
	gboolean	just_hide

void
gnome_dialog_set_close(dialog, click_closes)
	Gnome::Dialog	dialog
	gboolean	click_closes

void
gnome_dialog_editable_enters(dialog, editable)
	Gnome::Dialog	dialog
	Gtk::Editable	editable

Gtk::Widget_Sink_Up
vbox(dialog)
	Gnome::Dialog dialog
CODE:
	RETVAL = GTK_WIDGET(dialog->vbox);
OUTPUT:
	RETVAL

Gtk::Widget_OrNULL_Up
action_area(dialog)
	Gnome::Dialog dialog
	CODE:
	RETVAL = GTK_WIDGET(dialog->action_area);
	OUTPUT:
	RETVAL


#endif

