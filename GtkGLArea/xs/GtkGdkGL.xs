
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
	
MODULE = Gtk::Gdk::GL		PACKAGE = Gtk::Gdk::GL		PREFIX = gdk_gl_

gint
gdk_gl_query(Class)
	CODE:
	RETVAL = gdk_gl_query();
	OUTPUT:
	RETVAL

Gtk::Gdk::Visual
gdk_gl_choose_visual(Class, ...)
	CODE:
	{
		int * attr = malloc(sizeof(int)*(items));
		int i;
		for (i=0; i < items -1; ++i)
			attr[i] = SvIV(ST(i+1));
		attr[i] = 0;
		RETVAL = gdk_gl_choose_visual(attr);
		free(attr);
	}

	OUTPUT:
	RETVAL

void
gdk_gl_wait_gdk(Class)
	CODE:
	gdk_gl_wait_gdk();

void
gdk_gl_wait_gl(Class)
	CODE:
	gdk_gl_wait_gl();

MODULE = Gtk::Gdk::GL		PACKAGE = Gtk::Gdk::GL::Pixmap		PREFIX = gdk_gl_pixmap_

gint
gdk_gl_pixmap_make_current(glpixmap, context)
	Gtk::Gdk::GL::Pixmap	glpixmap
	Gtk::Gdk::GL::Context	context

MODULE = Gtk::Gdk::GL		PACKAGE = Gtk::Gdk::Visual		PREFIX = gdk_

int
gdk_gl_get_config(visual, attrib)
	Gtk::Gdk::Visual	visual
	int	attrib

Gtk::Gdk::GL::Context
gdk_gl_context_new(visual)
	Gtk::Gdk::Visual	visual

Gtk::Gdk::GL::Context
gdk_gl_context_share_new(visual, sharelist, direct)
	Gtk::Gdk::Visual	visual
	Gtk::Gdk::GL::Context	sharelist
	gint	direct

MODULE = Gtk::Gdk::GL		PACKAGE = Gtk::Gdk::Window	PREFIX = gdk_

int
gdk_gl_make_current(drawable, context)
	Gtk::Gdk::Window	drawable
	Gtk::Gdk::GL::Context	context

void
gdk_gl_swap_buffers(drawable)
	Gtk::Gdk::Window	drawable


MODULE = Gtk::Gdk::GL		PACKAGE = Gtk::Gdk::Font	PREFIX = gdk_

void
gdk_gl_use_gdk_font(font, first, count, list_base)
	Gtk::Gdk::Font	font
	int	first
	int	count
	int	list_base
