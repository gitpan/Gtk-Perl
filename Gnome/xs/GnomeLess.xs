
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gnome::Less		PACKAGE = Gnome::Less		PREFIX = gnome_less_

#ifdef GNOME_LESS

Gnome::Less_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_LESS(gnome_less_new());
	OUTPUT:
	RETVAL

void
gnome_less_clear(gl)
	Gnome::Less	gl

void
gnome_less_show_file(gl, path)
	Gnome::Less	gl
	char *	path

void
gnome_less_show_command(gl, command)
	Gnome::Less	gl
	char *	command

void
gnome_less_show_string(gl, string)
	Gnome::Less	gl
	char *	string

void
gnome_less_show_filestream(gl, stream)
	Gnome::Less	gl
	FILE *	stream

void
gnome_less_fixed_font(gl)
	Gnome::Less	gl

#endif

