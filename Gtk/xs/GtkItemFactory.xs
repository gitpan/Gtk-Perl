
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::ItemFactory	PACKAGE = Gtk::ItemFactory	PREFIX = gtk_item_factory_

#ifdef GTK_ITEM_FACTORY

Gtk::ItemFactory_Sink
gtk_item_factory_new(Class, container_type, path, accel_group)
	SV *		Class
	int		container_type
	char*		path
	Gtk::AccelGroup	accel_group
	CODE:
	RETVAL = GTK_ITEM_FACTORY(gtk_item_factory_new(container_type, path, accel_group));
	OUTPUT:
	RETVAL

void
gtk_item_factory_construct(self, container_type, path, accel_group)
	Gtk::ItemFactory	self
	int		container_type
	char*		path
	Gtk::AccelGroup	accel_group

void
gtk_item_factory_parse_rc(Class, file_name)
	SV*	Class
	char*			file_name
	CODE:
	gtk_item_factory_parse_rc(file_name);

void
gtk_item_factory_parse_rc_string(Class, rc_string)
	SV*	Class
	char*			rc_string
	CODE:
	gtk_item_factory_parse_rc_string(rc_string);


#	gtk_item_factory_parse_rc_scanner()
#	gtk_item_factory_from_widget()
#	gtk_item_factory_path_from_widget()


Gtk::Widget_Up
gtk_item_factory_get_widget(self, path)
	Gtk::ItemFactory	self
	char*			path

Gtk::Widget_Up
gtk_item_factory_get_widget_by_action(self, action)
	Gtk::ItemFactory	self
	int			action


#endif

