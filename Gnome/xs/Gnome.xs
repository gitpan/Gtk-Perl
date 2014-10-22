
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"

static GnomeUIInfo * svrv_to_uiinfo_tree(SV *data);
extern void pgtk_menu_callback(GtkWidget *w, gpointer data);

extern int pgtk_did_we_init_gdk, pgtk_did_we_init_gtk;
int pgtk_did_we_init_gnome = 0;

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
static char *gnome_perl_stock_button(const char *name) 
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

/* popt is buggy! */
static void
pgtk_popt_callback_void (poptContext ctx,
           enum poptCallbackReason reason,
           const struct poptOption *opt,
           const char *arg, void *data) {}

static void
pgtk_popt_callback (poptContext ctx,
           enum poptCallbackReason reason,
           const struct poptOption *opt,
           const char *arg, void *data) {
	dSP;
	if (!data)
		return;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSVpv(opt->longName, strlen(opt->longName))));
	if (arg && opt->argInfo != POPT_ARG_NONE)
		XPUSHs(sv_2mortal(newSVpv(arg, strlen(arg))));
	PUTBACK;
	perl_call_sv((SV*)data, G_DISCARD|G_EVAL);
	FREETMPS;
	LEAVE;
}

static void
free_options (struct poptOption* o) {
	int i;
	if (!o)
		return;
	for (i=0; o[i].longName; ++i)
		g_free(o[i].longName);
	g_free(o);
}

static struct poptOption*
get_options (SV *options, int *remove) {
	HV *hv;
	AV *av = NULL;
	SV *handler = NULL;
	SV **sv;
	int n, i;
	struct poptOption* res = NULL;

	if ((!SvOK(options)) || (!SvRV(options)))
		croak("Options must be an array or hash reference");
	if (SvTYPE(SvRV(options)) == SVt_PVHV) {
		hv = (HV*)SvRV(options);

		if ((sv=hv_fetch(hv, "callback", 8, 0)) && SvOK(*sv))
			handler = *sv;
		if ((sv=hv_fetch(hv, "remove", 6, 0)) && SvOK(*sv))
			*remove = SvTRUE(*sv);
		if ((sv=hv_fetch(hv, "options", 7, 0)) && SvOK(*sv) && SvRV(*sv) && SvTYPE(SvRV(*sv)) == SVt_PVAV)
			av = (AV*)SvRV(*sv);
		else
			croak("Options should have an 'options' key that is an array ref");
	} else if (SvTYPE(SvRV(options)) == SVt_PVAV) {
		av = (AV*)SvRV(options);
		handler = NULL;
	} else {
		handler = NULL; /* arguments will be parsed later by Getopt::Long or something else ..*/
	}
	
	n = av_len(av)+1;
	if (n % 2)
		croak("options should be an array ref containing argname, argdescription couples");
	
	res = g_new0(struct poptOption, n/2 + 2);
	res[0].argInfo = POPT_ARG_CALLBACK;
	res[0].arg = handler?pgtk_popt_callback:pgtk_popt_callback_void;
	res[0].descrip = (char*)handler;
	for (i=0; i < n; i+=2) {
		char *p = NULL;
		char *longopt = NULL;
		char *end;
		struct poptOption * o = &res[1+i/2];
		SV **s;

		o->argInfo = POPT_ARG_NONE;
		if ((s=av_fetch(av, i, 0)) && SvOK(*s))
			longopt = o->longName = g_strdup(SvPV(*s, PL_na));
		if (longopt && (p=strchr(longopt, '|'))) { /* short option */
			*p++ = 0;
			o->shortName = *p;
		} else {
			p = longopt;
		}
		end = p;
		if (p && (p=strchr(p, '='))) { /* type: s or i for string or integer */
			*p++ = 0;
			if (*p == 's' || *p == 'f')
				o->argInfo = POPT_ARG_STRING;
			else if (*p == 'i')
				o->argInfo = POPT_ARG_LONG;
			else
				warn("Unknown option type %c", *p);
		} else {
			p = end;
		}
		end = p;
		if (p && (p=strchr(p, '+'))) /* skip flags used in Getopt::Long */
			*p = 0;
		else
			p = end;
		end = p;
		if (p && (p=strchr(p, '!')))
			*p = 0;
		else
			p = end;
		if ((s=av_fetch(av, i+1, 0)) && SvOK(*s))
			o->descrip = SvPV(*s, PL_na);
	}
	return res;
}

static void GnomeInit_internal(char * app_id, char * app_version, SV * options)
{
	dTHR;
		if (!pgtk_did_we_init_gdk && !pgtk_did_we_init_gtk && !pgtk_did_we_init_gnome) {
			int argc;
			char ** argv = 0;
			AV * ARGV = perl_get_av("ARGV", FALSE);
			SV * ARGV0 = perl_get_sv("0", FALSE);
			int i;

			argc = av_len(ARGV)+2;
			if (argc) {
				argv = malloc(sizeof(char*)*argc);
				argv[0] = g_strdup(SvPV(ARGV0, PL_na));
				for(i=0;i<=av_len(ARGV);i++)
					argv[i+1] = g_strdup(SvPV(*av_fetch(ARGV, i, 0), PL_na));
			}

			i = argc;
#if GNOME_HVER >= 0x010200
			if (options) {
				int remove = 0;
				struct poptOption * my_options = get_options (options, &remove);
				poptContext pctx;
				char **args;
				gnome_init_with_popt_table(app_id, app_version, argc, argv,
					my_options, 0, &pctx);
				args = poptGetArgs(pctx);
				if (remove && args) {
					av_clear(ARGV);
					while (*args) {
						av_push(ARGV, newSVpv(*args, 0));
						++args;
					}
				}
				free_options(my_options);
				poptFreeContext(pctx);
			} else {
				gnome_init(app_id, app_version, argc, argv);
			}
#else
			gnome_init(app_id, NULL, argc, argv, 0, &i); 
#endif

			pgtk_did_we_init_gdk = 1;
			pgtk_did_we_init_gtk = 1;
			pgtk_did_we_init_gnome = 1;

			/* Shouldn't ... */
			/*while (i--)
				av_shift(ARGV);*/

			if (argv) {
				for (i=0; i < argc; ++i)
					g_free(argv[i]);
				free(argv);
			}
				
			GtkInit_internal();

			Gnome_InstallTypedefs();

			Gnome_InstallObjects();

			pgtk_exec_init("Gnome");

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

static GnomeUIInfo *
svrv_to_uiinfo_tree(SV* data)
{
	AV *a;
	int i, count;
	GnomeUIInfo* infos;

	g_assert(data != NULL);
	if ((!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVAV)) {
		croak("Subtree must be an array reference");
	}

	a = (AV*)SvRV(data);
	count = av_len(a) + 1;
	infos = pgtk_alloc_temp(sizeof(GnomeUIInfo) * (count+1));
	memset(infos, 0, sizeof(GnomeUIInfo) * (count+1));
	for (i = 0; i < count; i++) {
		SV** s = av_fetch(a, i, 0);
		SvGnomeUIInfo(*s, infos + i);
	}
	infos[count].type = GNOME_APP_UI_ENDOFINFO;
	
	return infos;
}

void
SvGnomeUIInfo(SV *data, GnomeUIInfo *info)
{
	g_assert(data != NULL);
	g_assert(info != NULL);

	if (!SvOK(data))
		return; /* fail silently if undef */
	if ((!SvRV(data)) ||
	    (SvTYPE(SvRV(data)) != SVt_PVHV && SvTYPE(SvRV(data)) != SVt_PVAV)) {
		croak("GnomeUIInfo must be a hash or array reference");
	}

	if (SvTYPE(SvRV(data)) == SVt_PVHV) {
		HV *h = (HV*)SvRV(data);
		SV **s;
		STRLEN len;
		if ((s = hv_fetch(h, "type", 4, 0)) && SvOK(*s))
			info->type = SvGnomeUIInfoType(*s);
		if ((s = hv_fetch(h, "label", 5, 0)) && SvOK(*s))
			info->label = SvPV(*s, len);
		if ((s = hv_fetch(h, "hint", 4, 0)) && SvOK(*s))
			info->hint = SvPV(*s, len);

		/* 'subtree' and 'callback' are also allowed - they
                   have the bonus that we know what you mean if you
                   use them */
		if ((s = hv_fetch(h, "moreinfo", 8, 0)) && SvOK(*s)) {
			info->moreinfo = *s;
		} else if ((s = hv_fetch(h, "subtree", 7, 0)) && SvOK(*s)) {
			if (info->type != GNOME_APP_UI_SUBTREE &&
			    info->type != GNOME_APP_UI_SUBTREE_STOCK)
				croak("'subtree' argument specified, but GnomeUIInfo type"
				      " is not 'subtree'");
			info->moreinfo = *s;
		} else if ((s = hv_fetch(h, "callback", 8, 0)) && SvOK(*s)) {
			if ((info->type != GNOME_APP_UI_ITEM) &&
			    (info->type != GNOME_APP_UI_TOGGLEITEM))
				croak("'callback' argument specified, but GnomeUIInfo type"
				      " is not an item type");
				info->moreinfo = *s;
		}

		if ((s = hv_fetch(h, "pixmap_type", 11, 0)) && SvOK(*s))
			info->pixmap_type = SvGnomeUIPixmapType(*s);
		if ((s = hv_fetch(h, "pixmap_info", 11, 0)) && SvOK(*s))
			info->pixmap_info = SvPV(*s, len); /* works for stock pixmaps at least */
		if ((s = hv_fetch(h, "accelerator_key", 15, 0)) && SvOK(*s)) /* keysym */
			info->accelerator_key = SvIV(*s);
		if ((s = hv_fetch(h, "ac_mods", 7, 0)) && SvOK(*s))
			info->ac_mods = SvGdkModifierType(*s);
	} else { /* As in Python - it's an array of:
		    type, label, hint, moreinfo, pixmap_type, pixmap_info,
		    accelerator_key, modifiers */
		AV *a = (AV*)SvRV(data);
		SV **s;
		STRLEN len;
		if ((s = av_fetch(a, 0, 0)) && SvOK(*s))
			info->type = SvGnomeUIInfoType(*s);
		if ((s = av_fetch(a, 1, 0)) && SvOK(*s))
			info->label = SvPV(*s, len);
		if ((s = av_fetch(a, 2, 0)) && SvOK(*s))
			info->hint = SvPV(*s, len);
		if ((s = av_fetch(a, 3, 0)) && SvOK(*s))
			info->moreinfo = *s;
		if ((s = av_fetch(a, 4, 0)) && SvOK(*s))
			info->pixmap_type = SvGnomeUIPixmapType(*s);
		if ((s = av_fetch(a, 5, 0)) && SvOK(*s))
			info->pixmap_info = SvPV(*s, len);
		if ((s = av_fetch(a, 6, 0)) && SvOK(*s)) /* keysym */
			info->accelerator_key = SvIV(*s);		
		if ((s = av_fetch(a, 7, 0)) && SvOK(*s))
			info->ac_mods = SvGdkModifierType(*s);
	}

	/* Decide what to do with the moreinfo */
	switch (info->type) {
	case GNOME_APP_UI_SUBTREE:
	case GNOME_APP_UI_SUBTREE_STOCK:
	case GNOME_APP_UI_RADIOITEMS:
		if (info->moreinfo == NULL)
			croak("GnomeUIInfo type requires a 'moreinfo' or 'subtree' argument, "
			      "but none was specified");
		/* Now we can recurse */
		info->moreinfo = svrv_to_uiinfo_tree(info->moreinfo);
		break;

	case GNOME_APP_UI_ITEM:
	case GNOME_APP_UI_ITEM_CONFIGURABLE:
	case GNOME_APP_UI_TOGGLEITEM:
		if (info->moreinfo) {
			/* Build a callback */
			info->user_data = info->moreinfo;
			SvREFCNT_inc(info->user_data); /* XXX: memory leak? */
			info->moreinfo = pgtk_menu_callback; /* might as well reuse this */
		}
		break;

	case GNOME_APP_UI_HELP:
		if (info->moreinfo == NULL)
			croak("GnomeUIInfo type requires a 'moreinfo' argument, "
			      "but none was specified");
		{
			STRLEN len;
			/* It's just a string */
			info->moreinfo = SvPV((SV*)info->moreinfo, len);
			break;
		}

	default:
		/* Do nothing */
	}
}


MODULE = Gnome		PACKAGE = Gnome		PREFIX = gnome_

void
init(Class, app_id, app_version="X.X", options=NULL)
	char *  app_id
	char *  app_version
	SV *	options
	CODE:
	{
		GnomeInit_internal(app_id, app_version, options);
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

