
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include <gtktty/gtktty.h>

MODULE = Gtk::Term		PACKAGE = Gtk::Term		PREFIX = gtk_term_

#ifdef GTK_TERM

void
gtk_term_setup(term, width, height, max_width, scrollback)
	Gtk::Term	term
	guint	width
	guint	height
	guint	max_width
	guint	scrollback

gint
gtk_term_set_scroll_offset(term, offset)
	Gtk::Term	term
	gint	offset

void
gtk_term_block_refresh(term)
	Gtk::Term	term

void
gtk_term_force_refresh(term)
	Gtk::Term	term

void
gtk_term_unblock_refresh(term)
	Gtk::Term	term

void
gtk_term_set_fonts(term, font_normal, font_dim, font_bold, overstrike_bold, font_underline, draw_underline, font_reverse, colors_reversed)
	Gtk::Term	term
	Gtk::Gdk::Font	font_normal
	Gtk::Gdk::Font	font_dim
	Gtk::Gdk::Font	font_bold
	gboolean	overstrike_bold
	Gtk::Gdk::Font	font_underline
	gboolean	draw_underline
	Gtk::Gdk::Font	font_reverse
	gboolean	colors_reversed

void
gtk_term_set_color(term, index, back, fore, fore_dim, fore_bold)
	Gtk::Term	term
	guint	index
	gulong	back
	gulong	fore
	gulong	fore_dim
	gulong	fore_bold

void
gtk_term_select_color(term, fore_index, back_index)
	Gtk::Term	term
	guint	fore_index
	guint	back_index

void
gtk_term_set_dim(term, dim)
	Gtk::Term	term
	gboolean	dim

void
gtk_term_set_bold(term, bold)
	Gtk::Term	term
	gboolean	bold

void
gtk_term_set_underline(term, underline)
	Gtk::Term	term
	gboolean	underline

void
gtk_term_set_reverse(term, reverse)
	Gtk::Term	term
	gboolean	reverse

void
gtk_term_invert(term)
	Gtk::Term	term

void
gtk_term_insert_lines(term, n)
	Gtk::Term	term
	guint	n

void
gtk_term_delete_lines(term, n)
	Gtk::Term	term
	guint	n

void
gtk_term_scroll(term, n, downwards)
	Gtk::Term	term
	guint	n
	gboolean	downwards

void
gtk_term_clear_line(term, before_cursor, after_cursor)
	Gtk::Term	term
	gboolean	before_cursor
	gboolean	after_cursor

void
gtk_term_insert_chars(term, n)
	Gtk::Term	term
	guint	n

void
gtk_term_delete_chars(term, n)
	Gtk::Term	term
	guint	n

void
gtk_term_bell(term)
	Gtk::Term	term

void
gtk_term_clear(term, before_cursor, after_cursor)
	Gtk::Term	term
	gboolean	before_cursor
	gboolean	after_cursor

void
gtk_term_set_cursor(term, x, y)
	Gtk::Term	term
	guint	x
	guint	y

void
gtk_term_get_cursor(term, x, y)
	Gtk::Term	term
	PPCODE:
	{
		int x,y;
		gtk_term_get_cursor(term, &x, &y);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
	}

void
gtk_term_set_cursor_mode(term, mode, blinking)
	Gtk::Term	term
	Gtk::CursorMode	mode
	gboolean	blinking

void
gtk_term_save_cursor(term)
	Gtk::Term	term

void
gtk_term_restore_cursor(term)
	Gtk::Term	term

void
gtk_term_set_scroll_reg(term, top, bottom)
	Gtk::Term	term
	guint	top
	guint	bottom

void
gtk_term_reset(term)
	Gtk::Term	term

void
gtk_term_get_size(term, x, y)
	Gtk::Term	term
	PPCODE:
	{
		int x,y;
		gtk_term_get_size(term, &x, &y);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
	}

void
gtk_term_erase_chars(term, n)
	Gtk::Term	term
	guint	n

void
gtk_term_putc(term, text, insert)
	Gtk::Term	term
	SV *	text
	gboolean	insert
	CODE:
	{
		int i,l;
		char * c = SvPV(text, l);
		for(i=0;i<l;i++)
			gtk_term_putc(term, c[i], insert);
	}


#endif

