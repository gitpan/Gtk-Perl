
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlBonoboInt.h"

#include "BonoboDefs.h"
#include "GtkDefs.h"
#include "GtkTypes.h"

MODULE = Bonobo::Window		PACKAGE = Bonobo::Window		PREFIX = bonobo_window_

#ifdef BONOBO_WINDOW

Bonobo::Window_Sink
bonobo_window_new (Class, win_name, title)
	SV *	Class
	char *	win_name
	char *	title
	CODE:
	RETVAL = bonobo_window_new (win_name, title);
	OUTPUT:
	RETVAL

void
bonobo_window_set_contents (win, contents)
	Bonobo::Window	win
	Gtk::Widget	contents

Gtk::Widget_Up
bonobo_window_get_contents (win)
	Bonobo::Window	win

void
bonobo_window_freeze (win)
	Bonobo::Window	win

void
bonobo_window_thaw (win)
	Bonobo::Window	win

void
bonobo_window_set_name (win, win_name)
	Bonobo::Window	win
	char *	win_name

char *
bonobo_window_get_name (win)
	Bonobo::Window	win

Bonobo::UIError
bonobo_window_xml_merge (win, path, xml, component)
	Bonobo::Window	win
	char *	path
	char *	xml
	char *	component

Bonobo::UIError
bonobo_window_xml_merge_tree (win, path, tree, component)
	Bonobo::Window	win
	char *	path
	Bonobo::UINode	tree
	char *	component

char *
bonobo_window_xml_get (win, path, node_only)
	Bonobo::Window	win
	char *	path
	bool	node_only

bool
bonobo_window_xml_node_exists (win, path)
	Bonobo::Window	win
	char *	path

Bonobo::UIError
bonobo_window_xml_rm (win, path, by_component)
	Bonobo::Window	win
	char *	path
	char *	by_component

Bonobo::UIError
bonobo_window_object_set (win, path, object)
	Bonobo::Window	win
	char *	path
	CORBA::Object	object
	CODE:
	TRY(RETVAL = bonobo_window_object_set (win, path, object, &ev));
	OUTPUT:
	RETVAL

Bonobo::UIError
bonobo_window_object_get (win, path, object)
	Bonobo::Window	win
	char *	path
	CORBA::Object	object
	CODE:
	TRY(RETVAL = bonobo_window_object_get (win, path, object, &ev));
	OUTPUT:
	RETVAL

Gtk::AccelGroup
bonobo_window_get_accel_group (win)
	Bonobo::Window	win

void
bonobo_window_dump (win, msg)
	Bonobo::Window	win
	char *	msg

void
bonobo_window_register_component (win, name, component)
	Bonobo::Window	win
	char *	name
	CORBA::Object	component

void
bonobo_window_deregister_component (win, name)
	Bonobo::Window	win
	char *	name

CORBA::Object
bonobo_window_component_get (win, name)
	Bonobo::Window	win
	char *	name

void
bonobo_window_add_popup (win, popup, path)
	Bonobo::Window	win
	Gtk::Menu	popup
	char *	path

void
bonobo_window_remove_popup (win, path)
	Bonobo::Window	win
	char *	path

#endif

