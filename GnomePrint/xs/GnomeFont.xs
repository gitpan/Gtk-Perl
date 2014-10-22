
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "PerlGnomePrintInt.h"

#include "GnomePrintDefs.h"

MODULE = Gnome::Font		PACKAGE = Gnome::Font		PREFIX = gnome_font_

#ifdef GNOME_FONT

Gnome::Font
gnome_font_new(Class, name, size)
	SV 	*Class
	char*	name
	double	size
	CODE:
	RETVAL = GNOME_FONT(gnome_font_new(name, size));
	OUTPUT:
	RETVAL

Gnome::Font
gnome_font_new_closest (Class, family, weight, italic, size)
	SV 	*Class
	char*	family
	Gnome::FontWeight	weight
	bool	italic
	double	size
	CODE:
	RETVAL = GNOME_FONT(gnome_font_new_closest(family, weight, italic, size));
	OUTPUT:
	RETVAL

Gnome::Font
gnome_font_new_from_full_name(Class, name)
	SV 	*Class
	char*	name
	CODE:
	RETVAL = GNOME_FONT(gnome_font_new_from_full_name(name));
	OUTPUT:
	RETVAL

char*
gnome_font_get_name (font)
	Gnome::Font	font

char*
gnome_font_get_glyph_name (font)
	Gnome::Font	font

char*
gnome_font_get_pfa (font)
	Gnome::Font	font

char*
gnome_font_get_full_name (font)
	Gnome::Font	font

double
gnome_font_get_width_string (font, text)
	Gnome::Font	font
	char *text

double
gnome_font_get_ascender (font)
	Gnome::Font	font

double
gnome_font_get_descender (font)
	Gnome::Font	font

double
gnome_font_get_underline_position (font)
	Gnome::Font	font

double
gnome_font_get_underline_thickness (font)
	Gnome::Font	font

# missing unsized font stuff and displayfont stuff
# they will lead to memleaks

#endif

