
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"
#include "GnomeAppletDefs.h"
#include <applet-widget.h>

extern int pgtk_did_we_init_gnome;
int pgtk_did_we_init_panel = 0;

static void start_new_callback(const char * param, gpointer data)
{
        AV * args = (AV*)data;
        SV * handler = *av_fetch(args, 0, 0);
        int i;
        dSP;
        
        ENTER;
        SAVETMPS;

        PUSHMARK(sp);
        for (i=1;i<=av_len(args);i++)
                XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
        if (param)
	        XPUSHs(sv_2mortal(newSVpv(param, 0)));
        PUTBACK;

        i = perl_call_sv(handler, G_DISCARD);

        FREETMPS;
        LEAVE;	
}

void AppletInit_internal(char * app_id, char *version, int panel)
{
		if (!pgtk_did_we_init_gdk && !pgtk_did_we_init_gtk && !pgtk_did_we_init_gnome && !pgtk_did_we_init_panel) {
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
			if (panel)
				applet_widget_init(app_id, version , argc, argv, NULL, 0, NULL);
			else
				gnome_capplet_init(app_id, version , argc, argv, NULL, 0, NULL);

			pgtk_did_we_init_gdk = 1;
			pgtk_did_we_init_gtk = 1;
			pgtk_did_we_init_gnome = 1;
			pgtk_did_we_init_panel = 1;

			while (i--)
				av_shift(ARGV);

			if (argv)
				free(argv);
				
			GtkInit_internal();

			Gnome_InstallTypedefs();
			Gnome_InstallObjects();
			GnomeApplet_InstallTypedefs();
			GnomeApplet_InstallObjects();

		}
}

static void     callXS (void (*subaddr)(CV* cv), CV *cv, SV **mark) 
{
	int items;
	dSP;
	PUSHMARK (mark);
	(*subaddr)(cv);

	PUTBACK;  /* Forget the return values */
}


MODULE = Gnome::AppletWidget		PACKAGE = Gnome::AppletWidget		PREFIX = applet_widget_

#ifdef APPLET_WIDGET

void
init(Class, app_id, version="")
	SV *    Class
	char *  app_id
	char *	version
	CODE:
	{
		AppletInit_internal(app_id, version, 1);
	}

Gnome::AppletWidget
new(Class, param=0)
	SV *	Class
	char *	param
	CODE:
	RETVAL = APPLET_WIDGET(applet_widget_new(param));
	OUTPUT:
	RETVAL

void
applet_widget_set_tooltip(aw, tooltip)
	Gnome::AppletWidget	aw
	char *	tooltip

void
applet_widget_set_widget_tooltip(aw, widget, tooltip)
	Gnome::AppletWidget	aw
	Gtk::Widget	widget
	char *	tooltip

void
applet_widget_add(aw, widget)
	Gnome::AppletWidget	aw
	Gtk::Widget	widget

#if 0

void
applet_widget_remove_from_panel(aw)
	Gnome::AppletWidget	aw

#endif

void
applet_widget_sync_config(aw)
	Gnome::AppletWidget	aw

#if 0

Gnome::Panel::OrientType
applet_widget_get_panel_orient(aw)
	Gnome::AppletWidget	aw

#endif

int
applet_widget_get_applet_count(Class)
	CODE:
	RETVAL = applet_widget_get_applet_count();
	OUTPUT:
	RETVAL

void
applet_widget_gtk_main(Class)
	CODE:
	applet_widget_gtk_main();

#endif

