
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

/* This CTree implementation is only suitable for Gtk+ 1.1.1 and later. */

void ctree_func_handler (GtkCTree *ctree, GtkCTreeNode *node, gpointer data)
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

MODULE = Gtk::CTree		PACKAGE = Gtk::CTree		PREFIX = gtk_ctree_

#ifdef GTK_CTREE

Gtk::CTree_Sink
gtk_ctree_new(Class, columns, tree_column)
	SV *	Class
	int	columns
	int	tree_column
	CODE:
	RETVAL = GTK_CTREE(gtk_ctree_new(columns, tree_column));
	OUTPUT:
	RETVAL

Gtk::CTree_Sink
gtk_ctree_new_with_titles(Class, tree_column, title, ...)
	SV *	Class
	int	tree_column
	SV *	title
	CODE:
	{
		int columns = items - 2;
		int i;
		char** titles = malloc(columns * sizeof(gchar*));
		for (i=2; i < items; ++i)
			titles[i-2] = SvPV(ST(i),PL_na);
		RETVAL = GTK_CTREE(gtk_ctree_new_with_titles(columns, tree_column, titles));
		free(titles);
	}
	OUTPUT:
	RETVAL


void
gtk_ctree_construct(self, tree_column, title, ...)
	Gtk::CTree	self
	int		tree_column
	SV *		title
	CODE:
	{
		int columns = items - 2;
		int i;
		char** titles = malloc(columns * sizeof(gchar*));
		for (i=2; i < items; ++i)
			titles[i-2] = SvPV(ST(i),PL_na);
		gtk_ctree_construct(self, columns, tree_column, titles);
		free(titles);
	}

void
gtk_ctree_set_indent(self, indent)
	Gtk::CTree	self
	int		indent

void
gtk_ctree_set_reorderable(self, reorderable)
	Gtk::CTree	self
	bool		reorderable
	CODE:
#if GTK_HVER < 0x010108
	/* DEPRECATED */
	gtk_ctree_set_reorderable(self, reorderable);
#else
	gtk_clist_set_reorderable(GTK_CLIST(self), reorderable);
#endif

void
gtk_ctree_set_line_style(self, line_style)
	Gtk::CTree		self
	Gtk::CTreeLineStyle	line_style

int
tree_indent(self)
	Gtk::CTree	self
	CODE:
	RETVAL=self->tree_indent;
	OUTPUT:
	RETVAL

int
tree_column(self)
	Gtk::CTree	self
	CODE:
	RETVAL=self->tree_column;
	OUTPUT:
	RETVAL

Gtk::CTreeLineStyle
line_style(self)
	Gtk::CTree	self
	CODE:
	RETVAL=self->line_style;
	OUTPUT:
	RETVAL

Gtk::CellType
gtk_ctree_node_get_cell_type (self, node, column)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int column


char*
gtk_ctree_node_get_text(self, node, column)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int column
	ALIAS:
		Gtk::CTree::node_get_text = 0
		Gtk::CTree::get_text = 1
	CODE:
	{
		gchar* text=NULL;
#if GTK_HVER <= 0x010101
		/* FIXME: DEPRECATED? */
		gtk_ctree_get_text(self, node, column, &text);
#else
		gtk_ctree_node_get_text(self, node, column, &text);
#endif
		RETVAL = text;
	}
	OUTPUT:
	RETVAL


void
gtk_ctree_node_get_pixmap (self, node, column)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int column
	ALIAS:
		Gtk::CTree::node_get_pixmap = 0
		Gtk::CTree::get_pixmap = 1
	PPCODE:
	{
		GdkPixmap * pixmap = NULL;
		GdkBitmap * bitmap = NULL;
		int result;
		result = gtk_ctree_node_get_pixmap(self, node, column, &pixmap, (GIMME == G_ARRAY) ?&bitmap: NULL);
		if ( result ) {
			if ( pixmap ) {
				EXTEND(sp, 1);
				PUSHs(sv_2mortal(newSVGdkPixmap(pixmap)));
			}
			if (bitmap ) {
				EXTEND(sp, 1);
				PUSHs(sv_2mortal(newSVGdkBitmap(bitmap)));
			}
		}
	}


void
gtk_ctree_node_get_pixtext (self, node, column)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int column
	ALIAS:
		Gtk::CTree::node_get_pixtext = 0
		Gtk::CTree::get_pixtext = 1
	PPCODE:
	{
		gchar* text = NULL;
		guint8 spacing;
		GdkPixmap * pixmap = NULL;
		GdkBitmap * bitmap = NULL;
		int result;
		/* FIXME: require GIMME == G_ARRAY? */
		result = gtk_ctree_node_get_pixtext(self, node, column, &text, &spacing, &pixmap, &bitmap);
		if ( result ) {
			EXTEND(sp, 4);
			if ( text )
				PUSHs(sv_2mortal(newSVpv(text, 0)));
			else
				PUSHs(sv_2mortal(newSVsv(&PL_sv_undef)));
			PUSHs(sv_2mortal(newSViv(spacing)));
			if ( pixmap )
				PUSHs(sv_2mortal(newSVGdkPixmap(pixmap)));
			else
				PUSHs(sv_2mortal(newSVsv(&PL_sv_undef)));
			if (bitmap )
				PUSHs(sv_2mortal(newSVGdkBitmap(bitmap)));
			else
				PUSHs(sv_2mortal(newSVsv(&PL_sv_undef)));
		}
	}


#if GTK_HVER >= 0x010200

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
			EXTEND(sp, 8);
			PUSHs(sv_2mortal(newSVpv(text, 0)));
			PUSHs(sv_2mortal(newSViv(spacing)));
			PUSHs(sv_2mortal(newSVGdkPixmap(pc)));
			PUSHs(sv_2mortal(newSVGdkBitmap(bc)));
			PUSHs(sv_2mortal(newSVGdkPixmap(po)));
			PUSHs(sv_2mortal(newSVGdkBitmap(bo)));
			PUSHs(sv_2mortal(newSViv(is_leaf)));
			PUSHs(sv_2mortal(newSViv(expanded)));
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


#endif

#endif


MODULE = Gtk::CTree		PACKAGE = Gtk::CTreeRow		PREFIX = gtk_ctree_row_

#ifdef GTK_CTREE

int
is_leaf(self)
	Gtk::CTreeRow	self
	CODE:
	RETVAL=self->is_leaf;
	OUTPUT:
	RETVAL

int
expanded(self)
	Gtk::CTreeRow	self
	CODE:
	RETVAL=self->expanded;
	OUTPUT:
	RETVAL

Gtk::CTreeNode
children (self)
	Gtk::CTreeRow	self
	CODE:
	RETVAL = self->children;
	OUTPUT:
	RETVAL

Gtk::CTreeNode
sibling (self)
	Gtk::CTreeRow	self
	CODE:
	RETVAL = self->sibling;
	OUTPUT:
	RETVAL

Gtk::CTreeNode
parent (self)
	Gtk::CTreeRow	self
	CODE:
	RETVAL = self->parent;
	OUTPUT:
	RETVAL

#endif


MODULE = Gtk::CTree		PACKAGE = Gtk::CTree		PREFIX = gtk_ctree_

#ifdef GTK_CTREE

Gtk::CTreeNode
gtk_ctree_insert_node(self, parent, sibling, titles, spacing, pixmap_closed, mask_closed, pixmap_opened, mask_opened, is_leaf, expanded)
	Gtk::CTree		self
	Gtk::CTreeNode_OrNULL		parent
	Gtk::CTreeNode_OrNULL		sibling
	SV*			titles
	int			spacing
	Gtk::Gdk::Pixmap_OrNULL	pixmap_closed
	Gtk::Gdk::Bitmap_OrNULL	mask_closed
	Gtk::Gdk::Pixmap_OrNULL	pixmap_opened
	Gtk::Gdk::Bitmap_OrNULL	mask_opened
	bool			is_leaf
	bool			expanded
	ALIAS:
		Gtk::CTree::insert_node = 0
		Gtk::CTree::insert = 1
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
#if GTK_HVER <= 0x010101
		/* FIXME: DEPRECATED? */
		RETVAL = gtk_ctree_insert(self, parent, sibling, titlesa, spacing, pixmap_closed, mask_closed, pixmap_opened, mask_opened, is_leaf, expanded);
#else
		RETVAL = gtk_ctree_insert_node(self, parent, sibling, titlesa, spacing, pixmap_closed, mask_closed, pixmap_opened, mask_opened, is_leaf, expanded);
#endif
		free(titlesa);
	}
	OUTPUT:
	RETVAL


void
gtk_ctree_remove_node(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	ALIAS:
		Gtk::CTree::remove_node = 0
		Gtk::CTree::remove = 1
	CODE:
#if GTK_HVER <= 0x010101
	/* FIXME: DEPRECATED? */
	gtk_ctree_remove(self, node);
#else
	gtk_ctree_remove_node(self, node);
#endif
	

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

#if GTK_HVER > 0x010101

# FIXME, or something

bool
gtk_ctree_is_viewable(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

#endif

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
	Gtk::CTreeNode_OrNULL	new_parent
	Gtk::CTreeNode_OrNULL	new_sibling

void
gtk_ctree_expand(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_expand_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode_OrNULL	node

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
	Gtk::CTreeNode_OrNULL	node

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
	Gtk::CTreeNode_OrNULL	node

void
gtk_ctree_select(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_select_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode_OrNULL	node

void
gtk_ctree_unselect(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node

void
gtk_ctree_unselect_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode_OrNULL	node


void
gtk_ctree_node_set_text(self, node, column, text)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	int column
	char *text
	ALIAS:
		Gtk::CTree::node_set_text = 0
		Gtk::CTree::set_text = 1
	CODE:
#if GTK_HVER <= 0x010101
	/* FIXME: DEPRECATED? */
	gtk_ctree_set_text(self, node, column, text);
#else
	gtk_ctree_node_set_text(self, node, column, text);
#endif


void
gtk_ctree_sort_node(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode	node
	ALIAS:
		Gtk::CTree::sort_node = 0
		Gtk::CTree::sort = 1
	CODE:
#if GTK_HVER <= 0x010101
	/* FIXME: DEPRECATED? */
	gtk_ctree_sort(self, node);
#else
	gtk_ctree_sort_node(self, node);
#endif

void
gtk_ctree_sort_recursive(self, node)
	Gtk::CTree	self
	Gtk::CTreeNode_OrNULL	node

gboolean
gtk_ctree_is_hot_spot (ctree, x, y)
	Gtk::CTree	ctree
	int	x
	int	y

void
selection (self)
	Gtk::CList	self
	PPCODE:
	{
		GList * selection = self->selection;
		while(selection) {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkCTreeNode(GTK_CTREE_NODE(selection->data))));
			selection=selection->next;
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
			PUSHs(sv_2mortal(newSVGtkCTreeRow(row_list->data)));
			row_list=row_list->next;
		}

	}

#endif

MODULE = Gtk::CTree		PACKAGE = Gtk::CTreeNode		PREFIX = gtk_ctree_node_

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
