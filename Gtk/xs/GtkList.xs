
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::List		PACKAGE = Gtk::List		PREFIX = gtk_list_

#ifdef GTK_LIST

Gtk::List_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_LIST(gtk_list_new());
	OUTPUT:
	RETVAL

 #ARG: ... list (list of Gtk::ListItem widgets)
void
insert_items(list, position, ...)
	Gtk::List	list
	int	position
	CODE:
	{
		GList * tmp = 0;
		int i;
		for(i=items-1;i>1;i--) {
			GtkObject * o;
			o = SvGtkObjectRef(ST(i), "Gtk::ListItem");
			if (!o)
				croak("item cannot be undef");
			tmp = g_list_prepend(tmp, o);
		}	
		gtk_list_insert_items(list, tmp, position);
	}

# FIXME: See if these can't be aliased together

 #ARG: ... list (list of Gtk::ListItem widgets)
void
append_items(list, ...)
	Gtk::List	list
	CODE:
	{
		GList * tmp = 0;
		int i;
		for(i=items-1;i>0;i--) {
			GtkObject * o;
			o = SvGtkObjectRef(ST(i), "Gtk::ListItem");
			if (!o)
				croak("item cannot be undef");
			tmp = g_list_prepend(tmp, GTK_LIST_ITEM(o));
		}
		gtk_list_append_items(list, tmp);
	}

 #ARG: ... list (list of Gtk::ListItem widgets)
void
prepend_items(list, ...)
	Gtk::List	list
	CODE:
	{
		GList * tmp = 0;
		int i;
		for(i=items-1;i>0;i--) {
			GtkObject * o;
			o = SvGtkObjectRef(ST(i), "Gtk::ListItem");
			if (!o)
				croak("item cannot be undef");
			tmp = g_list_prepend(tmp, GTK_LIST_ITEM(o));
		}
		gtk_list_prepend_items(list, tmp);
	}

 #ARG: ... list (list of Gtk::ListItem widgets)
void
remove_items(list, ...)
	Gtk::List	list
	CODE:
	{
		GList * tmp = 0;
		int i;
		for(i=items-1;i>0;i--) {
			GtkObject * o;
			o = SvGtkObjectRef(ST(i), "Gtk::ListItem");
			if (!o)
				croak("item cannot be undef");
			tmp = g_list_prepend(tmp, GTK_LIST_ITEM(o));
		}
		gtk_list_remove_items(list, tmp);
		g_list_free(tmp);
	}

#if GTK_HVER >= 0x010200

 #ARG: ... list (list of Gtk::ListItem widgets)
void
remove_items_no_unref(list, ...)
	Gtk::List	list
	CODE:
	{
		GList * tmp = 0;
		int i;
		for(i=items-1;i>0;i--) {
			GtkObject * o;
			o = SvGtkObjectRef(ST(i), "Gtk::ListItem");
			if (!o)
				croak("item cannot be undef");
			tmp = g_list_prepend(tmp, GTK_LIST_ITEM(o));
		}
		gtk_list_remove_items_no_unref(list, tmp);
		g_list_free(tmp);
	}

#endif

void
gtk_list_clear_items(list, start=0, end=-1)
	Gtk::List	list
	int	start
	int	end

void
gtk_list_select_item(list, the_item)
	Gtk::List	list
	int	the_item

void
gtk_list_unselect_item(list, the_item)
	Gtk::List	list
	int	the_item

void
gtk_list_select_child(list, widget)
	Gtk::List	list
	Gtk::Widget	widget

void
gtk_list_unselect_child(list, widget)
	Gtk::List	list
	Gtk::Widget	widget

int
gtk_list_child_position(list, widget)
	Gtk::List	list
	Gtk::Widget	widget

void
gtk_list_set_selection_mode(list, mode)
	Gtk::List	list
	Gtk::SelectionMode	mode

#if GTK_HVER >= 0x010200

void
gtk_list_end_drag_selection (list)
	Gtk::List	list

void
gtk_list_end_selection (list)
	Gtk::List	list

void
gtk_list_undo_selection (list)
	Gtk::List	list

void
gtk_list_start_selection (list)
	Gtk::List	list

void
gtk_list_toggle_add_mode (list)
	Gtk::List	list

void
gtk_list_toggle_focus_row (list)
	Gtk::List	list

void
gtk_list_toggle_row (list, item)
	Gtk::List	list
	Gtk::Widget	item

void
gtk_list_extend_selection (list, scroll_type, position, auto_start)
	Gtk::List	list
	Gtk::ScrollType	scroll_type
	double	position
	gboolean	auto_start

void
gtk_list_scroll_horizontal (list, scroll_type, position)
	Gtk::List	list
	Gtk::ScrollType	scroll_type
	double	position

void
gtk_list_scroll_vertical (list, scroll_type, position)
	Gtk::List	list
	Gtk::ScrollType	scroll_type
	double	position

void
gtk_list_select_all (list)
	Gtk::List	list

void
gtk_list_unselect_all (list)
	Gtk::List	list

#endif

 #OUTPUT: list
 #RETURNS: a list of the currently selected Gtk::Widgets
void
selection(list)
	Gtk::List	list
	PPCODE:
	{
		GList * selection = list->selection;
		while(selection) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(selection->data),0)));
			selection=selection->next;
		}
	}

 #OUTPUT: list
 #RETURNS: a list of the child Gtk::Widgets
void
children(list)
	Gtk::List	list
	PPCODE:
	{
		GList * children = list->children;
		while(children) {
			EXTEND(sp,1);
			PUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(children->data),0)));
			children=children->next;
		}
	}

#endif
