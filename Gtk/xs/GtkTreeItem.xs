#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::TreeItem		PACKAGE = Gtk::TreeItem		PREFIX = gtk_tree_item_

#ifdef GTK_TREE_ITEM

Gtk::TreeItem_Sink
new(Class, label=0)
	SV *	Class
	char *	label
	ALIAS:
		Gtk::TreeItem::new = 0
		Gtk::TreeItem::new_with_label = 1
	CODE:
	if (label)
		RETVAL = GTK_TREE_ITEM(gtk_tree_item_new_with_label(label));
	else
		RETVAL = GTK_TREE_ITEM(gtk_tree_item_new());
	OUTPUT:
	RETVAL

void
gtk_tree_item_set_subtree(tree_item, subtree)
	Gtk::TreeItem	tree_item
	Gtk::Widget	subtree

void
gtk_tree_item_remove_subtree(tree_item)
	Gtk::TreeItem   tree_item

void
gtk_tree_item_select(tree_item)
	Gtk::TreeItem	tree_item

void
gtk_tree_item_deselect(tree_item)
	Gtk::TreeItem	tree_item

void
gtk_tree_item_expand(tree_item)
	Gtk::TreeItem	tree_item

void
gtk_tree_item_collapse(tree_item)
	Gtk::TreeItem	tree_item

Gtk::Widget_OrNULL_Up
subtree(tree_item)
	Gtk::TreeItem   tree_item
	CODE:
	RETVAL=GTK_TREE_ITEM_SUBTREE(tree_item);
	OUTPUT:
	RETVAL

int
expanded(tree_item)
       Gtk::TreeItem tree_item
       CODE:
       RETVAL=tree_item->expanded;
       OUTPUT:
       RETVAL

#endif
