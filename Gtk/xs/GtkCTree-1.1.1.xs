
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

static void ctree_func_handler (GtkCTree *ctree, GtkCTreeNode *node, gpointer data)
{
	AV * perlargs = (AV*)data;
	SV * perlhandler = *av_fetch(perlargs, 1, 0);
	SV * sv_ctree = newSVGtkCTree(ctree);
	SV * sv_node = newSVGtkCTreeNode(node);
	int i;
	dSP;

	PUSHMARK(sp);
	XPUSHs(sv_2mortal(sv_ctree));
	XPUSHs(sv_2mortal(sv_node));
	for(i=2;i<av_len(perlargs);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(perlargs,i,0))));
	XPUSHs(sv_2mortal(newSVsv(*av_fetch(perlargs,0,0))));
	PUTBACK;

	perl_call_sv(perlhandler, G_DISCARD);
}

MODULE = Gtk::CTree111		PACKAGE = Gtk::CTree		PREFIX = gtk_ctree_

#ifdef GTK_CTREE

Gtk::CTreeNode
gtk_ctree_insert_node(self, parent, sibling, titles, spacing, pixmap_closed, mask_closed, pixmap_opened, mask_opened, is_leaf, expanded)
	Gtk::CTree		self
	Gtk::CTreeNode		parent
	Gtk::CTreeNode		sibling
	SV*			titles
	int			spacing
	Gtk::Gdk::Pixmap	pixmap_closed
	Gtk::Gdk::Bitmap	mask_closed
	Gtk::Gdk::Pixmap	pixmap_opened
	Gtk::Gdk::Bitmap	mask_opened
	bool			is_leaf
	bool			expanded
	CODE:
	{
		char** titlesa;
		AV* av;
		SV** temp;
		int i;
		if (!SvROK(titles) || (SvTYPE(SvRV(titles)) != SVt_PVAV))
			croak("titles must be a reference to an array");
		av = (AV*)SvRV(titles);
		titlesa = (char**)malloc(sizeof(char*) * (av_len(av)+2));
		for(i = 0; i <= av_len(av); ++i) {
			temp = av_fetch(av,i,0);
			titlesa[i] = temp?SvPV(*temp,PL_na):"";
		}
		titlesa[i]=0;
		RETVAL = gtk_ctree_insert_node(self, parent, sibling, titlesa, spacing, pixmap_closed, mask_closed, pixmap_opened, mask_opened, is_leaf, expanded);
		free(titlesa);
	}
	OUTPUT:
	RETVAL


void
gtk_ctree_remove_node(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_post_recursive(self, node, func, ...)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	SV *		func
	CODE:
	{
		AV * args;
		SV * arg;

		args = newAV();
		av_push(args, newRV_inc(SvRV(ST(0))));
		PackCallbackST(args, 2);

		gtk_ctree_post_recursive(self, node, ctree_func_handler, args);

		SvREFCNT_dec(args);
	}

bool
gtk_ctree_is_viewable(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

Gtk::CTreeNode
gtk_ctree_last(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

bool
gtk_ctree_find(self, node, child)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	Gtk::CTreeNode	child

bool
gtk_ctree_is_ancestor(self, node, child)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	Gtk::CTreeNode	child


void
gtk_ctree_move(self, node, new_parent, new_sibling)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	Gtk::CTreeNode	new_parent
	Gtk::CTreeNode	new_sibling

void
gtk_ctree_expand(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_expand_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_expand_to_depth(self, node, depth)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int		depth

void
gtk_ctree_collapse(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_collapse_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_collapse_to_depth(self, node, depth)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int		depth

void
gtk_ctree_toggle_expansion(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_toggle_expansion_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_select(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_select_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_unselect(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_unselect_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node


void
gtk_ctree_node_set_text(self, node, column, text)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int column
	char *text
	

void
gtk_ctree_sort_node(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_sort_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

Gtk::Style
gtk_ctree_node_get_cell_style (self, node, column)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int	column

Gtk::Style
gtk_ctree_node_get_row_style (self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_node_set_row_style (self, node, style)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	Gtk::Style	style

void
gtk_ctree_node_set_cell_style (self, node, column, style)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	gint	column
	Gtk::Style	style

gboolean
gtk_ctree_node_get_selectable (self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_node_set_selectable (self, node, selectable)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	gboolean	selectable

void
gtk_ctree_node_set_shift (self, node, column, vertical, horizontal)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int	column
	int	vertical
	int	horizontal

Gtk::Visibility
gtk_ctree_node_is_visible (self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_node_moveto (self, node, column, row_align, col_align)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int	column
	double	row_align
	double	col_align

Gtk::CTreeNode
gtk_ctree_node_nth (self, row)
	Gtk::CTree	self
	int	row

void
gtk_ctree_node_set_foreground (self, node, color)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	Gtk::Gdk::Color	color

void
gtk_ctree_node_set_background (self, node, color)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	Gtk::Gdk::Color	color

void
gtk_ctree_node_set_pixmap (self, node, column, pixmap, mask)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int	column
	Gtk::Gdk::Pixmap	pixmap
	Gtk::Gdk::Bitmap	mask

void
gtk_ctree_node_set_pixtext (self, node, column, text, spacing, pixmap, mask)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int	column
	char *	text
	gint	spacing
	Gtk::Gdk::Pixmap	pixmap
	Gtk::Gdk::Bitmap	mask

void
gtk_ctree_set_node_info (self, node, text, spacing, pixmap_closed, mask_closed, pixmap_opened, mask_opened, is_leaf, expanded)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	char *	text
	gint	spacing
	Gtk::Gdk::Pixmap	pixmap_closed
	Gtk::Gdk::Bitmap	mask_closed
	Gtk::Gdk::Pixmap	pixmap_opened
	Gtk::Gdk::Bitmap	mask_opened
	gboolean	is_leaf
	gboolean	expanded

void
gtk_ctree_get_node_info (self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	PPCODE:
	{
		char * text;
		guint8 spacing;
		GdkPixmap *pc = NULL, * po=NULL;
		GdkBitmap *bc=NULL, *bo=NULL;
		gboolean is_leaf, expanded;
		if (gtk_ctree_get_node_info(self, node, &text, &spacing, &pc, &bc, &po, &bo, &is_leaf, &expanded)) {
			EXPAND(sp, 8);
			PUSHp(text, 0);
			PUSHi(spacing);
			PUSHs(sv_2mortal(newSVGdkPixmap(pc)));
			PUSHs(sv_2mortal(newSVGdkBitmap(bc)));
			PUSHs(sv_2mortal(newSVGdkPixmap(po)));
			PUSHs(sv_2mortal(newSVGdkBitmap(bo)));
			PUSHi(is_leaf);
			PUSHi(expanded);
		}
	}

void
gtk_ctree_set_expander_style (self, expander_style)
	Gtk::CTree	self
	Gtk::CTreeExpanderStyle	expander_style

void
gtk_ctree_set_show_stub (self, show_stub)
	Gtk::CTree	self
	gboolean	show_stub

void
gtk_ctree_set_spacing (self, spacing)
	Gtk::CTree	self
	gint	spacing

void
selection (self)
	Gtk::CList	self
	PPCODE:
	{
		GList * selection = self->selection;
		while(selection) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkCTreeNode(GTK_CTREE_NODE(selection->data))));
			selection=g_list_next(selection);
		}
	}

void
row_list (self)
	Gtk::CList	self
	PPCODE:
	{
		GList * row_list = self->row_list;
		while(row_list) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkCTreeNode(row_list->data)));
			row_list=g_list_next(row_list);
		}

	}

#endif

MODULE = Gtk::CTree111		PACKAGE = Gtk::CTreeNode		PREFIX = gtk_ctree_node_

#ifdef GTK_CTREE

void
row(self)
	Gtk::CTreeNode	self
	PPCODE:
	{
		if (self) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkCTreeRow(GTK_CTREE_ROW(self))));
		}
	}

void
next(self)
	Gtk::CTreeNode	self
	PPCODE:
	{
		if (self) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkCTreeNode(GTK_CTREE_NODE_NEXT(self))));
		}
	}

void
prev(self)
	Gtk::CTreeNode	self
	PPCODE:
	{
		if (self) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkCTreeNode(GTK_CTREE_NODE_PREV(self))));
		}
	}

#endif
