
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"


MODULE = Gtk::CList12		PACKAGE = Gtk::CList		PREFIX = gtk_clist_

#ifdef GTK_CLIST

void
gtk_clist_set_sort_type (self, sort_type)
	Gtk::CList	self
	Gtk::SortType	sort_type

void
gtk_clist_set_sort_column (self, column)
	Gtk::CList	self
	int		column

Gtk::SortType
sort_type (self)
	Gtk::CList	self
	CODE:
	RETVAL=self->sort_type;
	OUTPUT:
	RETVAL

int
sort_column (self)
	Gtk::CList	self
	CODE:
	RETVAL=self->sort_column;
	OUTPUT:
	RETVAL

#endif
