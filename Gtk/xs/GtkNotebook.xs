
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

/* FIXME: XXX Notebookpage stuff??? */

MODULE = Gtk::Notebook		PACKAGE = Gtk::Notebook		PREFIX = gtk_notebook_

#ifdef GTK_NOTEBOOK

Gtk::Notebook_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_NOTEBOOK(gtk_notebook_new());
	OUTPUT:
	RETVAL

void
gtk_notebook_append_page(self, child, tab_label)
	Gtk::Notebook	self
	Gtk::Widget	child
	Gtk::Widget	tab_label

void
gtk_notebook_append_page_menu(self, child, tab_label, menu_label)
	Gtk::Notebook	self
	Gtk::Widget	child
	Gtk::Widget	tab_label
	Gtk::Widget	menu_label

void
gtk_notebook_prepend_page(self, child, tab_label)
	Gtk::Notebook	self
	Gtk::Widget	child
	Gtk::Widget	tab_label

void
gtk_notebook_prepend_page_menu(self, child, tab_label, menu_label)
	Gtk::Notebook	self
	Gtk::Widget	child
	Gtk::Widget	tab_label
	Gtk::Widget	menu_label

void
gtk_notebook_insert_page(self, child, tab_label, position)
	Gtk::Notebook	self
	Gtk::Widget	child
	Gtk::Widget	tab_label
	int	position

void
gtk_notebook_insert_page_menu(self, child, tab_label, menu_label, position)
	Gtk::Notebook	self
	Gtk::Widget	child
	Gtk::Widget	tab_label
	Gtk::Widget	menu_label
	int	position

void
gtk_notebook_remove_page(self, page_num)
	Gtk::Notebook	self
	int	page_num

# FIXME: DEPRECATED? Please?

Gtk::NotebookPage_OrNULL
cur_page(self)
	Gtk::Notebook	self
	CODE:
	RETVAL = self->cur_page;
	OUTPUT:
	RETVAL

int
gtk_notebook_get_current_page(self)
	Gtk::Notebook	self
	ALIAS:
		Gtk::Notebook::current_page = 1
	CODE:
#if GTK_HVER >= 0x010106
	RETVAL = gtk_notebook_get_current_page(self);
#else
	/* DEPRECATED */
	RETVAL = gtk_notebook_current_page(self);
#endif
	OUTPUT:
	RETVAL

void
gtk_notebook_set_page(self, page_num)
	Gtk::Notebook	self
	int	page_num

void
gtk_notebook_next_page(self)
	Gtk::Notebook	self

void
gtk_notebook_prev_page(self)
	Gtk::Notebook	self


void
gtk_notebook_set_show_border(self, show_border)
	Gtk::Notebook	self
	bool	show_border

void
gtk_notebook_set_show_tabs(self, show_tabs)
	Gtk::Notebook self
	bool	show_tabs

void
gtk_notebook_set_tab_pos(self, pos)
	Gtk::Notebook	self
	Gtk::PositionType	pos

void
gtk_notebook_set_tab_border(self, border)
	Gtk::Notebook   self
	int border

void
gtk_notebook_set_scrollable(self, scrollable)
	Gtk::Notebook   self
	bool    scrollable

void
gtk_notebook_popup_enable(self)
	Gtk::Notebook	self

void
gtk_notebook_popup_disable(self)
	Gtk::Notebook	self

Gtk::PositionType
gtk_notebook_tab_pos(self)
	Gtk::Notebook	self
	CODE:
	RETVAL = self->tab_pos;
	OUTPUT:
	RETVAL

void
children(notebook)
	Gtk::Notebook	notebook
	PPCODE:
	{
		GList * list;
		if (GIMME != G_ARRAY) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSViv(g_list_length(notebook->children))));
		} else {
			for(list = g_list_first(notebook->children); list; list = g_list_next(list)) {
				EXTEND(sp, 1);
				PUSHs(sv_2mortal(newSVGtkNotebookPage((GtkNotebookPage*)list->data)));
			}
		}
	}

#if GTK_HVER >= 0x010106

Gtk::Widget
gtk_notebook_get_nth_page(self, page_num)
	Gtk::Notebook	self
	int		page_num

int
gtk_notebook_page_num(self, child)
	Gtk::Notebook	self
	Gtk::Widget	child

void
gtk_notebook_set_homogeneous_tabs(self, homog)
	Gtk::Notebook self
	bool	homog

void
gtk_notebook_set_tab_hborder(self, border)
	Gtk::Notebook   self
	int border

void
gtk_notebook_set_tab_vborder(self, border)
	Gtk::Notebook   self
	int border

#endif

#if GTK_HVER >= 0x010200

void
gtk_notebook_query_tab_label_packing (notebook, child)
	Gtk::Notebook	notebook
	Gtk::Widget	child
	PPCODE:
	{
		gboolean expand, fill;
		GtkPackType pack_type;
		gtk_notebook_query_tab_label_packing(notebook, child, &expand, &fill, &pack_type);
		XPUSHs(sv_2mortal(newSViv(expand)));
		XPUSHs(sv_2mortal(newSViv(fill)));
		XPUSHs(sv_2mortal(newSVGtkPackType(pack_type)));
	}

void
gtk_notebook_reorder_child (notebook, child, position)
	Gtk::Notebook	notebook
	Gtk::Widget	child
	gint	position

Gtk::Widget_Up
gtk_notebook_get_menu_label (notebook, child)
	Gtk::Notebook	notebook
	Gtk::Widget	child

void
gtk_notebook_set_menu_label_text (notebook, child, label)
	Gtk::Notebook	notebook
	Gtk::Widget	child
	char *	label

void
gtk_notebook_set_menu_label (notebook, child, label)
	Gtk::Notebook	notebook
	Gtk::Widget	child
	Gtk::Widget	label

Gtk::Widget_Up
gtk_notebook_get_tab_label (notebook, child)
	Gtk::Notebook	notebook
	Gtk::Widget	child

void
gtk_notebook_set_tab_label_text (notebook, child, label)
	Gtk::Notebook	notebook
	Gtk::Widget	child
	char *	label

void
gtk_notebook_set_tab_label (notebook, child, label)
	Gtk::Notebook	notebook
	Gtk::Widget	child
	Gtk::Widget	label

void
gtk_notebook_set_tab_label_packing (notebook, child, expand, fill, pack_type)
	Gtk::Notebook	notebook
	Gtk::Widget	child
	gboolean	expand
	gboolean	fill
	Gtk::PackType	pack_type

#endif

#endif

MODULE = Gtk::Notebook		PACKAGE = Gtk::NotebookPage		PREFIX = gtk_notebook_

#ifdef GTK_NOTEBOOK

Gtk::Widget_Up
child(self)
	Gtk::NotebookPage	self
	CODE:
	RETVAL = self->child;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
tab_label(self)
	Gtk::NotebookPage	self
	CODE:
	RETVAL = self->tab_label;
	OUTPUT:
	RETVAL

Gtk::Widget_Up
menu_label(self)
	Gtk::NotebookPage	self
	CODE:
	RETVAL = self->menu_label;
	OUTPUT:
	RETVAL

int
default_menu(self)
	Gtk::NotebookPage	self
	CODE:
	RETVAL = self->default_menu;
	OUTPUT:
	RETVAL

int
default_tab(self)
	Gtk::NotebookPage	self
	CODE:
	RETVAL = self->default_tab;
	OUTPUT:
	RETVAL

#endif

