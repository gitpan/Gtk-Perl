
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"


MODULE = Gnome::Calculator		PACKAGE = Gnome::Calculator		PREFIX = gnome_calculator_

#ifdef GNOME_CALCULATOR

Gnome::Calculator_Sink
new(Class)
	CODE:
	printf("c1\n");
	RETVAL = GNOME_CALCULATOR(gnome_calculator_new());
	printf("c2\n");
	OUTPUT:
	RETVAL

void
gnome_calculator_clear(calculator, reset)
	Gnome::Calculator	calculator
	gint	reset

void
gnome_calculator_set(calculator, result)
	Gnome::Calculator	calculator
	gdouble	result

gdouble
gnome_calculator_get_result(calculator)
	Gnome::Calculator	calculator

#endif

