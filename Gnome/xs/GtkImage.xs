
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"


MODULE = Gtk::Image		PACKAGE = Gtk::Image		PREFIX = gtk_image_

#ifdef GTK_IMAGE

Gtk::Image_Sink
new(Class, val, mask)
	SV *	Class
	Gtk::Gdk::Image	val
	Gtk::Gdk::Bitmap	mask
	CODE:
	RETVAL = GTK_IMAGE(gtk_image_new(val, mask));
	OUTPUT:
	RETVAL

void
gtk_image_set(image, val, mask)
	Gtk::Image	image
	Gtk::Gdk::Image	val
	Gtk::Gdk::Bitmap	mask

void
gtk_image_get(image)
	Gtk::Image	image
	PPCODE:
	{
		GdkImage * val;
		GdkBitmap * mask;
		gtk_image_get(image, &val, &mask);
		EXTEND(sp,2);
		PUSHs(sv_2mortal(val ? newSVGdkImage(val) : newSVsv(&PL_sv_undef)));
		PUSHs(sv_2mortal(mask ? newSVGdkBitmap(mask) : newSVsv(&PL_sv_undef)));
	}

#endif
