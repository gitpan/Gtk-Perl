
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

#define sp (*_sp)
static int fixup_xmhtml(SV ** * _sp, int match, GtkObject * object, char * signame, int nparams, GtkArg * args, GtkType return_type)
{
	XPUSHs(sv_2mortal(newSVXmAnyCallbackStruct((XmAnyCallbackStruct*)GTK_VALUE_POINTER(args[0]))));
	return 1;
}
#undef sp

MODULE = Gtk::XmHTML	PACKAGE = Gtk::XmHTML	PREFIX = gtk_xmhtml_

#ifdef GTK_XMHTML

void
init(Class)
	CODE:
	{
		static char * names[] = {
				"activate",
				"arm",
				"anchor_track",
				"frame",
				"form",
				"input",
				"link",
				"motion",
				"imagemap",
				"document",
				"_focus",
				"losing_focus",
				"motion_track",
				"html_event",
				"anchor_visited" };
		AddSignalHelperParts(gtk_xmhtml_get_type(), names, fixup_xmhtml, 0);
	}

Gtk::XmHTML_Sink
new(Class)
	SV * Class
	CODE:
	RETVAL = GTK_XMHTML(gtk_xmhtml_new());
	OUTPUT:
	RETVAL

void
gtk_xmhtml_freeze(self)
	Gtk::XmHTML self

void
gtk_xmhtml_thaw(self)
	Gtk::XmHTML self


void
gtk_xmhtml_source(self, source)
	Gtk::XmHTML self
	char* source

void
gtk_xmhtml_set_string_direction(self, direction)
	Gtk::XmHTML self
	int direction

void
gtk_xmhtml_set_alignment(self, alignment)
	Gtk::XmHTML self
	int alignment

#if 0

void
gtk_xmhtml_outline(self, flag)
	Gtk::XmHTML self
	int flag

#endif

void
gtk_xmhtml_set_font_familty(self, familty, sizes)
	Gtk::XmHTML self
	char* familty
	char* sizes

void
gtk_xmhtml_set_font_familty_fixed(self, familty, sizes)
	Gtk::XmHTML self
	char* familty
	char* sizes

void
gtk_xmhtml_set_font_charset(self, charset)
	Gtk::XmHTML self
	char* charset

void
gtk_xmhtml_set_allow_body_colors(self, enable)
	Gtk::XmHTML self
	int enable

void
gtk_xmhtml_set_hilight_on_enter(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_anchor_underline_type(self, underline_type)
	Gtk::XmHTML self
	int underline_type

void
gtk_xmhtml_set_anchor_visited_underline_type(self, underline_type)
	Gtk::XmHTML self
	int underline_type

void
gtk_xmhtml_set_anchor_target_underline_type(self, underline_type)
	Gtk::XmHTML self
	int underline_type

void
gtk_xmhtml_set_allow_color_switching(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_allow_font_switching(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_max_image_colors(self, max_colors)
	Gtk::XmHTML self
	int max_colors

void
gtk_xmhtml_set_allow_images(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_plc_intervals(self, min_delay, max_delay, def_delay)
	Gtk::XmHTML self
	int min_delay
	int max_delay
	int def_delay

void
gtk_xmhtml_set_def_body_image_url(self, url)
	Gtk::XmHTML self
	char* url

void
gtk_xmhtml_set_anchor_buttons(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_anchor_cursor(self, cursor, flag)
	Gtk::XmHTML self
	Gtk::Gdk::Cursor cursor
	int flag

void
gtk_xmhtml_set_topline(self, topline)
	Gtk::XmHTML self
	int topline

void
gtk_xmhtml_set_freeze_animations(self, flag)
	Gtk::XmHTML self
	int flag

#if 0

char*
gtk_xmhtml_get_source(self)
	Gtk::XmHTML self

#endif

void
gtk_xmhtml_set_screen_gamma(self, gamma)
	Gtk::XmHTML self
	double gamma

void
gtk_xmhtml_set_perfect_colors(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_uncompress_command(self, cmd)
	Gtk::XmHTML self
	char* cmd

void
gtk_xmhtml_set_strict_checking(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_bad_html_warnings(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_allow_form_coloring(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_imagemap_draw(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_mime_type(self, mime_type)
	Gtk::XmHTML self
	char* mime_type

void
gtk_xmhtml_set_alpha_processing(self, flag)
	Gtk::XmHTML self
	int flag

void
gtk_xmhtml_set_rgb_conv_mode(self, val)
	Gtk::XmHTML self
	int val

#endif

