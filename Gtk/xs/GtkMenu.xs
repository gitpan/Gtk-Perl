
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

/* XXX attach functions */

void menu_pos_func (GtkMenu *menu, int *x, int *y, gpointer user_data)
{
	AV * args = (AV*)user_data;
	SV * handler = *av_fetch(args, 0, 0);
	int i;
	dSP;
	
	ENTER;
	SAVETMPS;

	PUSHMARK(sp);
	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(menu), 0)));
	for (i=1;i<=av_len(args);i++)
		XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));
	XPUSHs(sv_2mortal(newSViv(*x)));
	XPUSHs(sv_2mortal(newSViv(*y)));
	PUTBACK;

	i = perl_call_sv(handler, G_ARRAY);
	SPAGAIN;
	
	if (i>2)
		croak("MenuPosFunc must return two or less values");
	if (i==1)
		POPs;
	else {
		*x = SvIV(POPs);
		*y = SvIV(POPs);
	}
	
	PUTBACK;
	FREETMPS;
	LEAVE;
}


MODULE = Gtk::Menu		PACKAGE = Gtk::Menu		PREFIX = gtk_menu_

#ifdef GTK_MENU

Gtk::Menu_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GTK_MENU(gtk_menu_new());
	OUTPUT:
	RETVAL

void
gtk_menu_append(self, child)
	Gtk::Menu	self
	Gtk::Widget	child

void
gtk_menu_prepend(self, child)
	Gtk::Menu	self
	Gtk::Widget	child

void
gtk_menu_insert(self, child, position)
	Gtk::Menu	self
	Gtk::Widget	child
	int	position

void
gtk_menu_popup(menu, parent_menu_shell, parent_menu_item, button, activate_time, func=0, ...)
	Gtk::Menu	menu
	Gtk::Widget_OrNULL	parent_menu_shell
	Gtk::Widget_OrNULL	parent_menu_item
	int	button
	int	activate_time
	SV *	func
	CODE:
	{
		AV * args = newAV();
		int i;
		if (func && SvOK(func)) {
			PackCallbackST(args, 5);
			gtk_menu_popup(menu, parent_menu_shell, parent_menu_item, menu_pos_func,
				 (void*)args, button, activate_time);
		} else {
			gtk_menu_popup(menu, parent_menu_shell, parent_menu_item, NULL,
				 NULL, button, activate_time);
		}
	}


void
gtk_menu_popdown(self)
	Gtk::Menu	self

Gtk::Widget
gtk_menu_get_active(self)
	Gtk::Menu	self

void
gtk_menu_set_active(self, index)
	Gtk::Menu	self
	int	index

# FIXME: detach_handler can't be supported in 0.99.10, at least
#
#void
#gtk_menu_attach_to_widget (self, attach_widget, detach_handler, ...)
#	Gtk::Menu   self
#	Gtk::Widget attach_widget
#	SV *	detach_handler
#	CODE:
#	{
#		
#	}

Gtk::Widget
gtk_menu_get_attach_widget (self)
	Gtk::Menu   self

void
gtk_menu_detach (self)
	Gtk::Menu   self

#if GTK_HVER >= 0x010100

void
gtk_menu_reposition(self)
	Gtk::Menu	self

#endif

#endif
