
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gnome::FileEntry		PACKAGE = Gnome::FileEntry		PREFIX = gnome_file_entry_

#ifdef GNOME_FILE_ENTRY

Gnome::FileEntry_Sink
new(Class, history_id, browse_dialog_title)
	SV *	Class
	char *	history_id
	char *	browse_dialog_title
	CODE:
	RETVAL = GNOME_FILE_ENTRY(gnome_file_entry_new(history_id, browse_dialog_title));
	OUTPUT:
	RETVAL

Gtk::Widget_Up
gnome_file_entry_gnome_entry(fentry)
	Gnome::FileEntry	fentry

Gtk::Widget_Up
gnome_file_entry_gtk_entry(fentry)
	Gnome::FileEntry	fentry

void
gnome_file_entry_set_title(fentry, browse_dialog_title)
	Gnome::FileEntry	fentry
	char *	browse_dialog_title

#endif

