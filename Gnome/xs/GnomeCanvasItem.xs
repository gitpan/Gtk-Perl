
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

int GnomeCanvasItem_SetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object)
{
	int result = 1;
	if (a->type == GTK_TYPE_GNOME_CANVAS_POINTS)
		{
			AV * av;
			int i;
			GnomeCanvasPoints * p;
			
			if (!SvOK(v) || !SvROK(v) || (SvTYPE(SvRV(v)) != SVt_PVAV) )
				croak("points should be an array reference of coords");
			
			av = (AV*)SvRV(v);
			p = gnome_canvas_points_new((av_len(av)+1)/2);

			for (i=0; i<=av_len(av); i++)
				p->coords[i] = SvNV(*av_fetch(av, i, 0));

			GTK_VALUE_POINTER(*a) = p;
		}
	else
		result = 0;
	
	return result;
}

int GnomeCanvasItem_FreeArg(GtkArg * a)
{
	if (a->type == GTK_TYPE_GNOME_CANVAS_POINTS) {
			gnome_canvas_points_free((GnomeCanvasPoints*)GTK_VALUE_POINTER(*a));
			return 1;
	}
	
	return 0;
}

static struct PerlGtkTypeHelper type_help =
{
	0/*GnomeCanvasItem_GetArg*/,
	GnomeCanvasItem_SetArg,
	0/*GnomeCanvasItem_SetRetArg*/,
	0/*GnomeCanvasItem_GetRetArg*/,
	GnomeCanvasItem_FreeArg,
	0
};

MODULE = Gnome::CanvasItem		PACKAGE = Gnome::CanvasItem		PREFIX = gnome_canvas_item_

#ifdef GNOME_CANVAS

Gnome::CanvasItem_Sink_Up
gnome_canvas_item_new(Class, parent, type, ...)
	Gnome::CanvasGroup	parent
	SV*	type
	CODE:
	{
		GtkArg	*argv;
		int	p, argc, i;
		GtkType realtype;

		SV * fixtypename = type;

		argc = items -3;
		if ( argc % 2 )
			croak("too few arguments");

		realtype = gtnumber_for_ptname(SvPV(type,PL_na));
		if(!realtype) {
			fixtypename = newSVpv("Gnome::Canvas", 0);
			sv_catsv(fixtypename, type);
			realtype = gtnumber_for_ptname(SvPV(fixtypename,PL_na));
		}
		
		if(!realtype) {
			croak("Invalid canvas item type '%s'", SvPV(type, PL_na));
		}
		
		RETVAL = gnome_canvas_item_new(parent, realtype, 0); /*i, argv);*/

		argv = malloc(sizeof(GtkArg)*argc);

		i=0;
		for(p=3; p<items;++i) {
			/* g_warning("NEW SETTING: %s -> %s\n", SvPV(ST(p), PL_na), SvPV(ST(p+1),PL_na)); */
			FindArgumentTypeWithObject(GTK_OBJECT(RETVAL), ST(p), &argv[i]);
			GtkSetArg(&argv[i], ST(p+1), fixtypename, GTK_OBJECT(RETVAL));

			p += 2;
		}

		gnome_canvas_item_setv(RETVAL, i, argv);
		
		for (p=0; p<i; p++)
			GtkFreeArg(&argv[i]);

		free(argv);

		if (fixtypename != type)
			SvREFCNT_dec(fixtypename);
		
	}
	OUTPUT:
	RETVAL

#if 1 /* This code is needed, as Gtk::Object::set() behaves differently from Gnome::CanvasItem::set(), which is a bug IMO. */

void
gnome_canvas_item_set (self, name, value,...)
	Gnome::CanvasItem	self
	CODE:
	{
		GtkArg	*argv;
		int	p, argc, i;
		GtkObject *obj;
		
		argc = items -1;
		if ( argc % 2 )
			croak("too few arguments");
		
		obj = GTK_OBJECT(self);
		argv = malloc(sizeof(GtkArg)*argc);

		i=0;
		for(p=1; p<items;++i) {
			/* g_warning("SETTING: %s -> %s\n", SvPV(ST(p), PL_na), SvPV(ST(p+1),PL_na)); */
			FindArgumentTypeWithObject(obj, ST(p), &argv[i]);
			GtkSetArg(&argv[i], ST(p+1), ST(0), obj);
			p += 2;
		}
		gnome_canvas_item_setv(self, i, argv);
		
		for(p=0;p<i;p++)
			GtkFreeArg(&argv[i]);
		
		free(argv);
	}

#endif

void
gnome_canvas_item_move(self, dx, dy)
	Gnome::CanvasItem	self
	double	dx
	double	dy

void
gnome_canvas_item_raise(self, positions)
	Gnome::CanvasItem	self
	int	positions

void
gnome_canvas_item_lower(self, positions)
	Gnome::CanvasItem	self
	int	positions

void
gnome_canvas_item_raise_to_top(self)
	Gnome::CanvasItem	self

void
gnome_canvas_item_lower_to_bottom(self)
	Gnome::CanvasItem	self

int
gnome_canvas_item_grab(self, event_mask, cursor, time)
	Gnome::CanvasItem	self
	Gtk::Gdk::EventMask	event_mask
	Gtk::Gdk::Cursor	cursor
	int		time

void
gnome_canvas_item_ungrab(self, time)
	Gnome::CanvasItem	self
	int		time

void
gnome_canvas_item_w2i(self, x, y)
	Gnome::CanvasItem	self
	double	x
	double	y
	PPCODE:
	{
		gnome_canvas_item_w2i(self, &x, &y);
		EXTEND(sp,2);
		PUSHs(sv_2mortal(newSVnv(x)));
		PUSHs(sv_2mortal(newSVnv(y)));
	}

void
gnome_canvas_item_i2w(self, x, y)
	Gnome::CanvasItem	self
	double	x
	double	y
	PPCODE:
	{
		gnome_canvas_item_i2w(self, &x, &y);
		EXTEND(sp,2);
		PUSHs(sv_2mortal(newSVnv(x)));
		PUSHs(sv_2mortal(newSVnv(y)));
	}

BOOT:
	AddTypeHelper(&type_help);



#endif

