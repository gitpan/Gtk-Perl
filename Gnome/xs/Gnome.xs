
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"

extern int did_we_init_gdk, did_we_init_gtk;
int did_we_init_gnome = 0;

#define sp (*_sp)

static int fixup_gil(SV ** * _sp, int match, GtkObject * object, char * signame, int nparams, GtkArg * args, GtkType return_type)
{
	dTHR;
	args[1].type = GTK_TYPE_STRING;
	return 2;
}

#if GNOME_HVER >= 0x010032

static int fixup_druid(SV ** * _sp, int match, GtkObject * object, char * signame, int nparams, GtkArg * args, GtkType return_type)
{
	dTHR;
	args[0].type = GTK_TYPE_WIDGET;
	return 2;
}

#endif

#undef sp

/* It might be reasonable to autogenerate this.. on the other hand,
 * there are not that many...
 * This needs ANSI
 */
#define MAYBE(str) if(!strcmp(name,#str)) {return GNOME_STOCK_BUTTON_##str;}
char *gnome_perl_stock_button(const char *name) 
{
#ifdef GNOME_STOCK_BUTTON_OK
	MAYBE(OK)
#endif
#ifdef GNOME_STOCK_BUTTON_CANCEL
	MAYBE(CANCEL)
#endif
#ifdef GNOME_STOCK_BUTTON_YES
	MAYBE(YES)
#endif
#ifdef GNOME_STOCK_BUTTON_NO
	MAYBE(NO)
#endif
#ifdef GNOME_STOCK_BUTTON_CLOSE
	MAYBE(CLOSE)
#endif
#ifdef GNOME_STOCK_BUTTON_APPLY
	MAYBE(APPLY)
#endif
#ifdef GNOME_STOCK_BUTTON_HELP
	MAYBE(HELP)
#endif
#ifdef GNOME_STOCK_BUTTON_NEXT
	MAYBE(NEXT)
#endif
#ifdef GNOME_STOCK_BUTTON_PREV
	MAYBE(PREV)
#endif
#ifdef GNOME_STOCK_BUTTON_UP
	MAYBE(UP)
#endif
#ifdef GNOME_STOCK_BUTTON_DOWN
	MAYBE(DOWN)
#endif
#ifdef GNOME_STOCK_BUTTON_FONT
	MAYBE(FONT)
#endif
	return NULL;
}

#undef MAYBE
#define MAYBE(str) if(!strcmp(name,#str)) {return GNOME_STOCK_MENU_##str;}
static char *gnome_perl_stock_menu_item(const char *name) 
{
	MAYBE(BLANK)
	MAYBE(NEW)
	MAYBE(SAVE)
	MAYBE(SAVE_AS)
	MAYBE(REVERT)
	MAYBE(OPEN)
	MAYBE(CLOSE)
	MAYBE(QUIT)
	MAYBE(CUT)
	MAYBE(COPY)
	MAYBE(PASTE)
	MAYBE(PROP)
	MAYBE(PREF)
	MAYBE(ABOUT)
	MAYBE(SCORES)
	MAYBE(UNDO)
	MAYBE(REDO)
	MAYBE(PRINT)
	MAYBE(SEARCH)
	MAYBE(BACK)
	MAYBE(FORWARD)
	MAYBE(FIRST)
	MAYBE(LAST)
	MAYBE(HOME)
	MAYBE(STOP)
	MAYBE(REFRESH)
	MAYBE(MAIL)
	MAYBE(MAIL_RCV)
	MAYBE(MAIL_SND)
	MAYBE(MAIL_RPL)
	MAYBE(MAIL_FWD)
	MAYBE(MAIL_NEW)
	MAYBE(TRASH)
	MAYBE(TRASH_FULL)
	MAYBE(UNDELETE)
	MAYBE(TIMER)
	MAYBE(TIMER_STOP)
	MAYBE(SPELLCHECK)
	MAYBE(MIC)
	MAYBE(LINE_IN)
	MAYBE(VOLUME)
	MAYBE(BOOK_RED)
	MAYBE(BOOK_GREEN)
	MAYBE(BOOK_BLUE)
	MAYBE(BOOK_YELLOW)
	MAYBE(BOOK_OPEN)
	MAYBE(CONVERT)
	MAYBE(JUMP_TO)
/*	MAYBE(UP)
	MAYBE(DOWN)
	MAYBE(TOP)
	MAYBE(BOTTOM)
	MAYBE(ATTACH)
	MAYBE(FONT)
	MAYBE(EXEC)*/

/* Soon.. 
	MAYBE(ALIGN_LEFT)
	MAYBE(ALIGN_RIGHT)
	MAYBE(ALIGN_CENTER)
	MAYBE(ALIGN_JUSTIFY)
 */

	MAYBE(EXIT)

	return NULL;
}


static void     callXS (void (*subaddr)(CV* cv), CV *cv, SV **mark) 
{
    int items;
  dSP;
   PUSHMARK (mark);
   (*subaddr)(cv);
                
    PUTBACK;  /* Forget the return values */
}

void GnomeInit_internal(char * app_id, char * app_version)
{
	dTHR;
		if (!did_we_init_gdk && !did_we_init_gtk && !did_we_init_gnome) {
			int argc;
			char ** argv = 0;
			AV * ARGV = perl_get_av("ARGV", FALSE);
			SV * ARGV0 = perl_get_sv("0", FALSE);
			int i;

			argc = av_len(ARGV)+2;
			if (argc) {
				argv = malloc(sizeof(char*)*argc);
				argv[0] = SvPV(ARGV0, PL_na);
				for(i=0;i<=av_len(ARGV);i++)
					argv[i+1] = SvPV(*av_fetch(ARGV, i, 0), PL_na);
			}

			i = argc;
#ifdef NEW_GNOME
			gnome_init(app_id, app_version, argc, argv);
#else
			gnome_init(app_id, NULL, argc, argv, 0, &i); 
#endif

			did_we_init_gdk = 1;
			did_we_init_gtk = 1;
			did_we_init_gnome = 1;

			/* Shouldn't ... */
			/*while (i--)
				av_shift(ARGV);*/

			if (argv)
				free(argv);
				
			GtkInit_internal();

			Gnome_InstallTypedefs();

			Gnome_InstallObjects();

			/*printf("Init gnome\n");*/
			{
				static char *names[] = {"text-changed", 0};
				AddSignalHelperParts(gnome_icon_list_get_type(), names, fixup_gil, 0);
			}
#if GNOME_HVER >= 0x010032
			{
				static char *names[] = {"next", "prepare", "back",
					"finish", "cancel", 0};
				AddSignalHelperParts(gnome_druid_page_get_type(), names, fixup_druid, 0);
			}
#endif
		}
}


MODULE = Gnome		PACKAGE = Gnome		PREFIX = gnome_

void
init(Class, app_id, app_version="X.X")
	char *  app_id
	char *  app_version
	CODE:
	{
		GnomeInit_internal(app_id, app_version);
	}

Gtk::Button_Sink
gnome_stock_button(btype)
	char *btype
CODE:
	const char *t = gnome_perl_stock_button(btype);
	if(!t) {die("Invalid stock button '%s'", btype);}
	RETVAL = GTK_BUTTON(gnome_stock_button(t));
OUTPUT:
	RETVAL

Gtk::Button_Sink
gnome_stock_or_ordinary_button(btype)
	char *btype
CODE:
	const char *t = gnome_perl_stock_button(btype);
	if(!t) t = btype;
	RETVAL = GTK_BUTTON(gnome_stock_or_ordinary_button(t));
OUTPUT:
	RETVAL

Gtk::MenuItem_Sink
gnome_stock_menu_item(mtype, text)
	char *mtype
	char *text
CODE:
	const char *t = gnome_perl_stock_menu_item(mtype);
	if(!t) {die("Invalid stock menuitem '%s'", mtype);}
	RETVAL = GTK_MENU_ITEM(gnome_stock_menu_item(t,text));
OUTPUT:
	RETVAL


MODULE = Gnome		PACKAGE = Gnome::Preferences	PREFIX = gnome_preferences_

void
gnome_preferences_load (Class)
	SV *	Class
	CODE:
	gnome_preferences_load();

void
gnome_preferences_save (Class)
	SV *	Class
	CODE:
	gnome_preferences_save();

# this interface is so boring that should have been done with
# an hash table in the first place (hint someone should write a tied hash interface).

Gtk::ButtonBoxStyle
gnome_preferences_get_button_layout ()

void
gnome_preferences_set_button_layout (style)
	Gtk::ButtonBoxStyle	style

gboolean
gnome_preferences_get_statusbar_dialog ()

void
gnome_preferences_set_statusbar_dialog (value)
	bool	value

gboolean
gnome_preferences_get_statusbar_interactive ()

void
gnome_preferences_set_statusbar_interactive (value)
	bool	value

gboolean
gnome_preferences_get_statusbar_meter_on_right ()

void
gnome_preferences_set_statusbar_meter_on_right (value)
	bool	value

gboolean
gnome_preferences_get_menubar_detachable ()

void
gnome_preferences_set_menubar_detachable (value)
	bool	value

gboolean
gnome_preferences_get_menubar_relief ()

void
gnome_preferences_set_menubar_relief (value)
	bool	value

gboolean
gnome_preferences_get_toolbar_detachable ()

void
gnome_preferences_set_toolbar_detachable (value)
	bool	value

gboolean
gnome_preferences_get_toolbar_relief ()

void
gnome_preferences_set_toolbar_relief (value)
	bool	value

gboolean
gnome_preferences_get_toolbar_relief_btn ()

void
gnome_preferences_set_toolbar_relief_btn (value)
	bool	value

gboolean
gnome_preferences_get_toolbar_lines ()

void
gnome_preferences_set_toolbar_lines (value)
	bool	value

gboolean
gnome_preferences_get_toolbar_labels ()

void
gnome_preferences_set_toolbar_labels (value)
	bool	value

gboolean
gnome_preferences_get_dialog_centered ()

void
gnome_preferences_set_dialog_centered (value)
	bool	value

Gtk::WindowType
gnome_preferences_get_dialog_type ()

void
gnome_preferences_set_dialog_type (type)
	Gtk::WindowType	type

Gtk::WindowPosition
gnome_preferences_get_dialog_position ()

void
gnome_preferences_set_dialog_position (position)
	Gtk::WindowPosition	position

Gnome::MDIMode
gnome_preferences_get_mdi_mode ()

void
gnome_preferences_set_mdi_mode (mode)
	Gnome::MDIMode	mode

Gtk::PositionType
gnome_preferences_get_mdi_tab_pos ()

void
gnome_preferences_set_mdi_tab_pos (position)
	Gtk::PositionType	position

int
gnome_preferences_get_property_box_apply ()

void
gnome_preferences_set_property_box_button_apply (value)
	int	value

int
gnome_preferences_get_menus_have_tearoff ()

void
gnome_preferences_set_menus_have_tearoff (value)
	bool	value

int
gnome_preferences_get_menus_have_icons ()

void
gnome_preferences_set_menus_have_icons (value)
	int	value

int
gnome_preferences_get_disable_imlib_cache ()

void
gnome_preferences_set_disable_imlib_cache (value)
	int value

INCLUDE: ../build/boxed.xsh

INCLUDE: ../build/objects.xsh

INCLUDE: ../build/extension.xsh

