
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

#endif
