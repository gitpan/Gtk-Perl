
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::Ruler		PACKAGE = Gtk::Ruler	PREFIX = gtk_ruler_

#ifdef GTK_RULER

void
gtk_ruler_set_metric(ruler, metric)
	Gtk::Ruler	ruler
	Gtk::MetricType	metric

void
gtk_ruler_set_range(ruler, lower, upper, position, max_size)
	Gtk::Ruler	ruler
	double	lower
	double	upper
	double	position
	double	max_size

void
gtk_ruler_draw_ticks(ruler)
	Gtk::Ruler	ruler

void
gtk_ruler_draw_pos(ruler)
	Gtk::Ruler	ruler

#endif
