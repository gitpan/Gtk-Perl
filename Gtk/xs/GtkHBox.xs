
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::HBox		PACKAGE = Gtk::HBox

#ifdef GTK_HBOX

Gtk::HBox_Sink
new(Class, homogeneous, spacing)
	SV *	Class
	bool	homogeneous
	int	spacing
	CODE:
	RETVAL = GTK_HBOX(gtk_hbox_new(homogeneous, spacing));
	OUTPUT:
	RETVAL

#endif
