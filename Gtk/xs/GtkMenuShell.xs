
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::MenuShell		PACKAGE = Gtk::MenuShell	PREFIX = gtk_menu_shell_

#ifdef GTK_MENU_SHELL

void
gtk_menu_shell_append(self, child)
	Gtk::MenuShell	self
	Gtk::Widget	child

void
gtk_menu_shell_prepend(self, child)
	Gtk::MenuShell	self
	Gtk::Widget	child

void
gtk_menu_shell_insert(self, child, position)
	Gtk::MenuShell	self
	Gtk::Widget	child
	int	position

void
gtk_menu_shell_deactivate(self)
	Gtk::MenuShell	self

#if GTK_HVER >= 0x010200

void
gtk_menu_shell_select_item (menu_shell, widget)
	Gtk::MenuShell	menu_shell
	Gtk::Widget	widget

void
gtk_menu_shell_deselect (menu_shell)
	Gtk::MenuShell	menu_shell

void
gtk_menu_shell_activate_item (menu_shell, widget, force_deactivate)
	Gtk::MenuShell	menu_shell
	Gtk::Widget	widget
	gboolean	force_deactivate

#endif

#endif
