
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Tree		PACKAGE = Gtk::Tree		PREFIX = gtk_tree_

#ifdef GTK_TREE

Gtk::Tree_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_TREE(gtk_tree_new());
	OUTPUT:
	RETVAL

void
gtk_tree_append(self, child)
	Gtk::Tree	self
	Gtk::Widget	child

void
gtk_tree_prepend(self, child)
	Gtk::Tree	self
	Gtk::Widget	child

void
gtk_tree_insert(self, child, position)
	Gtk::Tree	self
	Gtk::Widget	child
	int	position

# FIXME: DEPRECATED
void
gtk_tree_remove_item(self, child)
	Gtk::Tree	self
	Gtk::Widget	child

void
gtk_tree_remove_items(self, ...)
	Gtk::Tree	self
	CODE:
	{
		GList * list = 0;
		int i;
		for(i=1;i<items;i++) {
			GtkObject * o;
			o = SvGtkObjectRef(ST(i), "Gtk::TreeItem");
			if (!o)
				croak("item cannot be undef");
			list = g_list_prepend(list, GTK_TREE_ITEM(o));
		}
		g_list_reverse(list);
		gtk_tree_remove_items(self, list);
		g_list_free(list);
	}

void
gtk_tree_clear_items(self, start, end)
	Gtk::Tree	self
	int		start
	int		end

void
gtk_tree_select_item(self, item)
	Gtk::Tree	self
	int		item

void
gtk_tree_unselect_item(self, item)
	Gtk::Tree	self
	int		item

void
gtk_tree_select_child(self, child)
	Gtk::Tree	self
	Gtk::Widget	child

void
gtk_tree_unselect_child(self, child)
	Gtk::Tree	self
	Gtk::Widget	child

int
gtk_tree_child_position(self, child)
	Gtk::Tree	self
	Gtk::Widget	child

void
gtk_tree_set_selection_mode(self, mode)
	Gtk::Tree	self
	Gtk::SelectionMode	mode

void
gtk_tree_set_view_mode(self, mode)
	Gtk::Tree	self
	Gtk::TreeViewMode	mode

void
gtk_tree_set_view_lines(self, flag)
	Gtk::Tree	self
	unsigned int	flag

void
selection(list)
	Gtk::Tree	list
	PPCODE:
	{
		GList * selection = list->selection;
		while(selection) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(selection->data),0)));
			selection=selection->next;
		}
	}

#endif
