
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"

/* XXX Add dock, etc */

#define fill_uiinfo(index, count, infos) \
		count = items - index; \
		infos = pgtk_alloc_temp(sizeof(GnomeUIInfo) * (count+1)); \
		memset(infos, 0, sizeof(GnomeUIInfo) * (count+1)); \
		/* Because we accept a list rather than an array, we \
                   have to unroll the outer layer of recursion */ \
		for (i = 0; i < count; i++) { \
			SvGnomeUIInfo(ST(i+index), infos + i); \
		} \
		infos[count].type = GNOME_APP_UI_ENDOFINFO; \


MODULE = Gnome::App		PACKAGE = Gnome::App		PREFIX = gnome_app_

#ifdef GNOME_APP

Gnome::App_Sink
new(Class, appname, title)
	SV *	Class
	char *	appname
	char *	title
	CODE:
	RETVAL = GNOME_APP(gnome_app_new(appname, title));
	OUTPUT:
	RETVAL

void
gnome_app_set_menus(app, menubar)
	Gnome::App	app
	Gtk::MenuBar	menubar

void
gnome_app_create_menus(app, info, ...)
	Gnome::App	app
	ALIAS:
		Gnome::App::create_toolbar = 1
	CODE:
	{
		int i, count;
		GnomeUIInfo *infos;

		fill_uiinfo(1, count, infos);
		if (ix == 1)
			gnome_app_create_toolbar(app, infos);
		else
			gnome_app_create_menus(app, infos);
	}


void
gnome_app_fill_menu (Class, menu_shell, uiinfo, accel_group, uline_accels, pos, ...)
	SV *	Class
	Gtk::MenuShell	menu_shell
	Gtk::AccelGroup_OrNULL	accel_group
	bool	uline_accels
	int	pos
	CODE:
	{
		int i, count;
		GnomeUIInfo *infos;

		fill_uiinfo(6, count, infos);
		gnome_app_fill_menu (menu_shell, infos, accel_group, uline_accels, pos);
	}

void
gnome_app_fill_toolbar (Class, toolbar, accel_group, ...)
	SV *	Class
	Gtk::Toolbar	toolbar
	Gtk::AccelGroup_OrNULL	accel_group
	CODE:
	{
		int i, count;
		GnomeUIInfo *infos;

		fill_uiinfo(3, count, infos);
		gnome_app_fill_toolbar (toolbar, infos, accel_group);
	}

void
gnome_app_set_toolbar(app, toolbar)
	Gnome::App	app
	Gtk::Toolbar	toolbar

void
gnome_app_set_statusbar(app, contents)
	Gnome::App	app
	Gtk::Widget	contents

void
gnome_app_set_contents(app, contents)
	Gnome::App	app
	Gtk::Widget	contents

void
gnome_app_set_statusbar_custom(app, container, statusbar)
	Gnome::App	app
	Gtk::Widget	container
	Gtk::Widget	statusbar

void
gnome_app_add_toolbar(app, toolbar, name, behavior, placement, band_num, band_position, offset)
	Gnome::App	app
	Gtk::Toolbar	toolbar
	char*	name
	Gnome::DockItemBehavior	behavior
	Gnome::DockPlacement	placement
	int	band_num
	int	band_position
	int	offset

void
gnome_app_add_docked(app, widget, name, behavior, placement, band_num, band_position, offset)
	Gnome::App	app
	Gtk::Widget	widget
	char*	name
	Gnome::DockItemBehavior	behavior
	Gnome::DockPlacement	placement
	int	band_num
	int	band_position
	int	offset

void
gnome_app_add_dock_item(app, item, placement, band_num, band_position, offset)
	Gnome::App	app
	Gnome::DockItem	item
	Gnome::DockPlacement	placement
	int	band_num
	int	band_position
	int	offset

void
gnome_app_enable_layout_config(app, enable)
	Gnome::App	app
	bool	enable

Gnome::Dock
gnome_app_get_dock(app)
	Gnome::App	app

Gnome::DockItem
gnome_app_get_dock_item_by_name(app, name)
	Gnome::App	app
	char*	name


#endif

