
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"


MODULE = Gnome::Canvas	PACKAGE = Gnome::Canvas	PREFIX = gnome_canvas_

#ifdef GNOME_CANVAS

Gnome::Canvas_Sink
gnome_canvas_new(Class)
	SV*	Class
	CODE:
	RETVAL= GNOME_CANVAS(gnome_canvas_new());
	OUTPUT:
	RETVAL

#ifdef NEW_GNOME

Gnome::Canvas_Sink
gnome_canvas_new_aa(Class)
	SV*	Class
	CODE:
	RETVAL= GNOME_CANVAS(gnome_canvas_new_aa());
	OUTPUT:
	RETVAL

#endif

Gnome::CanvasGroup
gnome_canvas_root(self)
	Gnome::Canvas	self

void
gnome_canvas_set_scroll_region(self, x1, y1, x2, y2)
	Gnome::Canvas	self
	double	x1
	double	y1
	double	x2
	double	y2

void
gnome_canvas_get_scroll_region (canvas)
	Gnome::Canvas	canvas
	PPCODE:
	{
		double x1, y1, x2, y2;
		gnome_canvas_get_scroll_region(canvas, &x1, &y1, &x2, &y2);
		EXTEND(sp, 4);
		PUSHs(sv_2mortal(newSVnv(x1)));
		PUSHs(sv_2mortal(newSVnv(y1)));
		PUSHs(sv_2mortal(newSVnv(x2)));
		PUSHs(sv_2mortal(newSVnv(y2)));
	}

void
gnome_canvas_set_pixels_per_unit(self, n)
	Gnome::Canvas	self
	double	n

#if 0

void
gnome_canvas_set_size(self, width, height)
	Gnome::Canvas	self
	int	width
	int	height

#endif

void
gnome_canvas_scroll_to(self, x, y)
	Gnome::Canvas	self
	int	x
	int	y

void
gnome_canvas_get_scroll_offsets (canvas)
	Gnome::Canvas	canvas
	PPCODE:
	{
		int x, y;
		gnome_canvas_get_scroll_offsets(canvas, &x, &y);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
	}

void
gnome_canvas_update_now(self)
	Gnome::Canvas	self

Gnome::CanvasItem_OrNULL
gnome_canvas_get_item_at (canvas, x, y)
	Gnome::Canvas	canvas
	double x
	double y

void
gnome_canvas_request_redraw(self, x1, y1, x2, y2)
	Gnome::Canvas	self
	int	x1
	int	y1
	int	x2
	int	y2

# missing: gnome_canvas_request_redraw_uta

void
gnome_canvas_w2c_affine (canvas)
	Gnome::Canvas	canvas
	PPCODE:
	{
		double affine[6];
		int i;
		gnome_canvas_w2c_affine(canvas, affine);
		EXTEND(sp, 6);
		for(i=0; i < 6; ++i)
			PUSHs(sv_2mortal(newSVnv(affine[i])));
	}

void
gnome_canvas_w2c (canvas, wx, wy)
	Gnome::Canvas	canvas
	double	wx
	double	wy
	PPCODE:
	{
		int cx, cy;
		gnome_canvas_w2c(canvas, wx, wy, &cx, &cy);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSViv(cx)));
		PUSHs(sv_2mortal(newSViv(cy)));

	}

void
gnome_canvas_w2c_d (canvas, wx, wy)
	Gnome::Canvas	canvas
	double	wx
	double	wy
	PPCODE:
	{
		double cx, cy;
		gnome_canvas_w2c_d(canvas, wx, wy, &cx, &cy);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSVnv(cx)));
		PUSHs(sv_2mortal(newSVnv(cy)));
	}

void
gnome_canvas_c2w (canvas, cx, cy)
	Gnome::Canvas	canvas
	int	cx
	int	cy
	PPCODE:
	{
		double wx, wy;
		gnome_canvas_c2w(canvas, cx, cy, &wx, &wy);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSVnv(wx)));
		PUSHs(sv_2mortal(newSVnv(wy)));
	}

void
gnome_canvas_window_to_world (canvas, winx, winy)
	Gnome::Canvas	canvas
	double	winx
	double	winy
	PPCODE:
	{
		double wx, wy;
		gnome_canvas_window_to_world(canvas, winx, winy, &wx, &wy);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSVnv(wx)));
		PUSHs(sv_2mortal(newSVnv(wy)));
	}

void
gnome_canvas_world_to_window (canvas, wx, wy)
	Gnome::Canvas	canvas
	double	wx
	double	wy
	PPCODE:
	{
		double winx, winy;
		gnome_canvas_world_to_window(canvas, wx, wy, &winx, &winy);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSVnv(winx)));
		PUSHs(sv_2mortal(newSVnv(winy)));
	}

# missing: gnome_canvas_get_color
# missing: gnome_canvas_get_color_pixel

void
gnome_canvas_set_stipple_origin (canvas, gc)
	Gnome::Canvas	canvas
	Gtk::Gdk::GC	gc

void
gnome_canvas_set_close_enough(self, ce)
	Gnome::Canvas	self
	int		ce
	CODE:
	self->close_enough = ce;

#endif

