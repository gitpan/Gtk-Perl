
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

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
gnome_canvas_update_now(self)
	Gnome::Canvas	self

void
gnome_canvas_request_redraw(self, x1, y1, x2, y2)
	Gnome::Canvas	self
	int	x1
	int	y1
	int	x2
	int	y2

void
gnome_canvas_w2c(self, wx, wy)
	Gnome::Canvas	self
	double	wx
	double	wy
	PPCODE:
	{
		int cx, cy;
		gnome_canvas_w2c(self, wx, wy, &cx, &cy);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSViv(cx)));
		PUSHs(sv_2mortal(newSViv(cy)));
	}

void
gnome_canvas_c2w(self, cx, cy)
	Gnome::Canvas      self
	int	cx
	int	cy
	CODE:
	{
		double wx, wy;
		gnome_canvas_c2w(self, cx, cy, &wx, &wy);
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSVnv(wx)));
		PUSHs(sv_2mortal(newSVnv(wy)));
	}

#endif

