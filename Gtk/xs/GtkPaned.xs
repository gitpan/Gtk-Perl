
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Paned		PACKAGE = Gtk::Paned	PREFIX = gtk_paned_

#ifdef GTK_PANED

void
gtk_paned_add1(paned, child)
	Gtk::Paned	paned
	Gtk::Widget	child

void
gtk_paned_add2(paned, child)
	Gtk::Paned	paned
	Gtk::Widget	child

void
gtk_paned_set_handle_size(paned, size)
	Gtk::Paned	paned
	int	size
	ALIAS:
		Gtk::Paned::handle_size = 1
	CODE:
#if GTK_HVER < 0x010106
	/* DEPRECATED */
	gtk_paned_handle_size(paned, size);
#else
	gtk_paned_set_handle_size(paned, size);
#endif

void
gtk_paned_set_gutter_size(paned, size)
	Gtk::Paned	paned
	int	size
	ALIAS:
		Gtk::Paned::gutter_size = 1
	CODE:
#if GTK_HVER < 0x010106
	/* DEPRECATED */
	gtk_paned_gutter_size(paned, size);
#else
	gtk_paned_set_gutter_size(paned, size);
#endif

#if GTK_HVER >= 0x010108

void
gtk_paned_pack1(paned, child, resize, shrink)
	Gtk::Paned	paned
	Gtk::Widget	child
	bool 		resize
	bool		shrink

void
gtk_paned_pack2(paned, child, resize, shrink)
	Gtk::Paned	paned
	Gtk::Widget	child
	bool 		resize
	bool		shrink


void
gtk_paned_set_position(paned, position)
	Gtk::Paned	paned
	int		position

#endif

#endif
