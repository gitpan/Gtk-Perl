
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::MenuShell		PACKAGE = Gtk::MenuShell	PREFIX = gtk_menu_shell_

#ifdef GTK_MENU_SHELL

void
gtk_menu_shell_append(menu_shell, child)
	Gtk::MenuShell	menu_shell
	Gtk::Widget	child

void
gtk_menu_shell_prepend(menu_shell, child)
	Gtk::MenuShell	menu_shell
	Gtk::Widget	child

void
gtk_menu_shell_insert(menu_shell, child, position)
	Gtk::MenuShell	menu_shell
	Gtk::Widget	child
	int	position

void
gtk_menu_shell_deactivate(menu_shell)
	Gtk::MenuShell	menu_shell

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
