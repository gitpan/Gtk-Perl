
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

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
zvt_term_set_scrollback(term, scrollback)
	Gnome::ZvtTerm	term
	int	scrollback

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

void
zvt_term_set_default_color_scheme(term)
	Gnome::ZvtTerm	term

Gtk::Adjustment
adjustment(term)
	Gnome::ZvtTerm	term
	CODE:
	RETVAL = term->adjustment;
	OUTPUT:
	RETVAL

#endif

