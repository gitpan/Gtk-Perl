
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::VBox		PACKAGE = Gtk::VBox

#ifdef GTK_VBOX

Gtk::VBox_Sink
new(Class, homogeneous, spacing)
	SV *	Class
	bool	homogeneous
	int	spacing
	CODE:
	RETVAL = GTK_VBOX(gtk_vbox_new(homogeneous, spacing));
	OUTPUT:
	RETVAL

#endif
