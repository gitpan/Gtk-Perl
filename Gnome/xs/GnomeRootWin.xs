
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gnome::RootWin		PACKAGE = Gnome::RootWin		PREFIX = gnome_root_win_

#ifdef GNOME_ROOT_WIN

Gnome::RootWin_Sink
new(Class, label=0)
	SV *	Class
	char *	label
	CODE:
	RETVAL = GTK_ROOTWIN(gtk_rootwin_new());
	OUTPUT:
	RETVAL

#endif

