
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"

#include <zvt/zvtterm.h>

MODULE = Gnome::ZvtTerm		PACKAGE = Gnome::ZvtTerm		PREFIX = zvt_term_

#ifdef ZVT_TERM

Gnome::ZvtTerm_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = ZVT_TERM(zvt_term_new());
	OUTPUT:
	RETVAL

Gnome::ZvtTerm_Sink
new_with_size(Class, cols, rows)
	SV *	Class
	int	cols
	int	rows
	CODE:
	RETVAL = ZVT_TERM(zvt_term_new_with_size(cols, rows));
	OUTPUT:
	RETVAL

void
zvt_term_reset (term, hard)
	Gnome::ZvtTerm	term
	int	hard


#ifdef NEW_GNOME

void
zvt_term_feed(term, text, len)
	Gnome::ZvtTerm	term
	char *	text
	int	len

#endif

int
zvt_term_forkpty(term, do_uwtmp_log)
	Gnome::ZvtTerm	term
	int do_uwtmp_log;

void
zvt_term_closepty(term)
	Gnome::ZvtTerm	term

void
zvt_term_killchild(term, signal)
	Gnome::ZvtTerm	term
	int	signal

void
zvt_term_bell(term)
	Gnome::ZvtTerm	term

void
zvt_term_set_scrollback(term, scrollback)
	Gnome::ZvtTerm	term
	int	scrollback

void
zvt_term_get_buffer (term, type, sx, sy, ex, ey)
	Gnome::ZvtTerm	term
	int	type
	int	sx
	int	sy
	int	ex
	int	ey
	PPCODE:
	{
		char* res;
		int len=0;

		res = zvt_term_get_buffer (term, &len, type, sx, sy, ex, ey);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSVpv(res, 0)));
		PUSHs(sv_2mortal(newSViv(len)));
		g_free(res);
	}

void
zvt_term_set_font_name(term, name)
	Gnome::ZvtTerm	term
	char *	name

void
zvt_term_set_fonts(term, font, font_bold)
	Gnome::ZvtTerm	term
	Gtk::Gdk::Font	font
	Gtk::Gdk::Font	font_bold

void
zvt_term_hide_pointer(term)
	Gnome::ZvtTerm	term

void
zvt_term_show_pointer(term)
	Gnome::ZvtTerm	term

void
zvt_term_set_bell (term, state)
	Gnome::ZvtTerm	term
	int	state

gboolean
zvt_term_get_bell (term)
	Gnome::ZvtTerm	term

void
zvt_term_set_blink(term, state)
	Gnome::ZvtTerm	term
	int	state

void
zvt_term_set_scroll_on_keystroke(term, state)
	Gnome::ZvtTerm	term
	int	state

void
zvt_term_set_scroll_on_output(term, state)
	Gnome::ZvtTerm	term
	int	state

# FIXME: zvt_term_set_color_scheme

void
zvt_term_set_default_color_scheme(term)
	Gnome::ZvtTerm	term

void
zvt_term_set_del_key_swap (term, state)
	Gnome::ZvtTerm	term
	int	state

void
zvt_term_set_wordclass (term ,klass)
	Gnome::ZvtTerm	term
	char*	klass

void
zvt_term_set_background (term, pixmap_file, transparent, shaded)
	Gnome::ZvtTerm	term
	char*	pixmap_file
	int	transparent
	int	shaded

void
zvt_term_set_shadow_type (term, type)
	Gnome::ZvtTerm	term
	Gtk::ShadowType	type

void
zvt_term_set_size (term, width, height)
	Gnome::ZvtTerm	term
	int	width
	int	height


Gtk::Adjustment
adjustment(term)
	Gnome::ZvtTerm	term
	CODE:
	RETVAL = term->adjustment;
	OUTPUT:
	RETVAL

#endif

